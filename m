Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4B48190F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhL3DrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:47:11 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:39390 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235450AbhL3DrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:47:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0IhzE1_1640836017;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V0IhzE1_1640836017)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Dec 2021 11:46:58 +0800
Date:   Thu, 30 Dec 2021 11:46:57 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net 2/2] net/smc: fix kernel panic caused by race of
 smc_sock
Message-ID: <20211230034657.GB55356@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-3-dust.li@linux.alibaba.com>
 <444f15e6-db60-3e86-fe20-32f24928844c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444f15e6-db60-3e86-fe20-32f24928844c@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 01:33:20PM +0100, Karsten Graul wrote:
>On 28/12/2021 10:03, Dust Li wrote:
>> A crash occurs when smc_cdc_tx_handler() tries to access smc_sock
>> but smc_release() has already freed it.
>
>I am not sure about what happened here. 
>Your patch removes the whole dismisser concept that was introduced to
>solve exactly the problem you describe. And you implemented a different approach.
>
>In theory, when smc_cdc_tx_handler() is called but the connection is already
>freed than the connection should have gone through smc_cdc_tx_dismiss_slots(),
>called by smc_conn_kill() or smc_conn_free(). If that happened there would be no
>access to an already freed address in smc_cdc_tx_handler().
>
>Can you explain why the code reached smc_cdc_tx_handler() with cdcpend->conn
>pointing to a connection that is already freed? I think if there is a bug it should
>be fixed instead of replacing the code by a new construct.
>
>Thoughts?

Yes, at first we do try to fix this on the original path, but finally failed.
that's why we turned into this way.

This bug can be reproduced in our environment pretty fast running the
following test:

server:
  smc_run nginx
client:
  while true; do smc_run wrk -c 1000 -t 4 -d 20 http://smc-server; done

The reason is smc_cdc_tx_handler() checks whether cdcpend->conn == NULL
or not, and will access to the connection if it's not NULL.
But for short TCP flows(transfered to SMC flow), it is likely to close()
the connection very soon. Since smc_cdc_tx_handler() is running in the
soft IRQ context, and close(2) is running in the process context.
There is a chance of race as describe below:

    smc_cdc_tx_handler()           |smc_release()
    if (!conn)                     |
                                   |
                                   |smc_cdc_tx_dismiss_slots()
                                   |      smc_cdc_tx_dismisser()
                                   |
                                   |sock_put(&smc->sk) <- last sock_put,
                                   |                      smc_sock freed
    bh_lock_sock(&smc->sk) (panic) |

If the check at the left passed, and then the application closed the
smc_socket and dismissed the cdcpend with smc_connection.
smc_cdc_tx_handler() still think the smc_sock is alive but actually
it's already released, and further bh_lock_sock(&smc->sk) will cause
the kernel panic.

As long as the check in smc_cdc_tx_handler() is not synchronized with
the smc_release(), this is inevitable. And unfortunately, I haven't
found a good way to synchronized them with the dismisser.

So my final solution is to remove the dissmiser and introduce the
refcount for tx cdc messages to protect the visit from
smc_cdc_tx_handler() from smc_release().
With the refcount, we can make sure the smc_conn_free() will wait for
all pending tx cdc messages done by the underlying RDMA device and
smc_cdc_tx_handler() is always safe to visit the smc_sock.


With this patchset, I run the wrk/nginx test cases for 2 days without
any panic(No link down/up is performed) any more.
