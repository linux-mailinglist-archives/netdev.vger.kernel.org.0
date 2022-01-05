Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5932B484FA9
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiAEI5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:57:51 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46486 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbiAEI5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:57:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V10Yb0z_1641373068;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V10Yb0z_1641373068)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 16:57:49 +0800
Date:   Wed, 5 Jan 2022 16:57:48 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <20220105085748.GD31579@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105044049.GA107642@e02h04389.eu6sqa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 12:40:49PM +0800, D. Wythe wrote:
>Hi, 
>
>Since we are trying to use the backlog parameter to limit smc dangling
>connections, it's seems there's no difference from increasing the
>backlog parameter for the TCP listen socket, user space Application can
>simply avoid the 10K connections problem through that.
>
>If so, this patch looks redundant to me. Look forward to your advise.

I think increase backlog in the userspace application is not a good idea.

AFAIU, SMC tries to behave the same like TCP in the socket layer, asking
the APP to increase the backlog breaks this principle.

In the TCP case, the backlog usually don't get overflow if the APP calls
accept() fast enough.
For SMC, it should also accept() fast enough to make sure the backlog of
the CLC socket won't overflow. But it didn't because smc_hs_wq is busy
hence TCP dropped the SYN. From the APP's perspective of view, he is fast
enough, but the kernel didn't give him the chance. I think this behaves
different from TCP.

I'm thinking maybe we can actively fall back to TCP in this case ? Not
sure if this is a good idea.
