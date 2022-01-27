Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2349E202
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiA0MIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:08:39 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33654 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229776AbiA0MIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:08:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2zx.Vm_1643285315;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V2zx.Vm_1643285315)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 20:08:36 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next 0/3]  Optimizing performance in short-lived
Date:   Thu, 27 Jan 2022 20:08:00 +0800
Message-Id: <cover.1643284658.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch set aims to optimizing performance of SMC in short-lived
links scenarios, which is quite unsatisfactory right now.

In our benchmark, we test it with follow scripts:

./wrk -c 10000 -t 4 -H 'Connection: Close' -d 20 http://smc-server

Current performance figures like that:

Running 20s test @ http://11.213.45.6
  4 threads and 10000 connections
  4956 requests in 20.06s, 3.24MB read
  Socket errors: connect 0, read 0, write 672, timeout 0
Requests/sec:    247.07
Transfer/sec:    165.28KB

There are many reasons for this phenomenon, this patch set doesn't
solve it all though, but it can be well alleviated with it in.

Patch 1/3  (Make smc_tcp_listen_work() independent) :

Separate smc_tcp_listen_work() from smc_listen_work(), make them
independent of each other, the busy SMC handshake can not affect new TCP
connections visit any more. Avoid discarding a large number of TCP
connections after being overstock, which is undoubtedly raise the
connection establishment time.

Patch 2/3 (Limits SMC backlog connections):

Since patch 1 has separated smc_tcp_listen_work() from
smc_listen_work(), an unrestricted TCP accept have come into being. This
patch try to put a limit on SMC backlog connections refers to
implementation of TCP.

Patch 3/3 (Fallback when SMC handshake workqueue congested):

Considering the complexity of SMC handshake right now, in short-lived
links scenarios, this may not be the main scenario of SMC though, it's
performance is still quite poor. This Patch try to provide auto fallback
case when SMC handshake workqueue congested, which is the sign of SMC
handshake stacking in our opinion.

Of course, it's optional.

After this patch set, performance figures like that:

Running 20s test @ http://11.213.45.6
  4 threads and 10000 connections
  693253 requests in 20.10s, 452.88MB read
Requests/sec:  34488.13
Transfer/sec:     22.53MB

That's a quite well performance improvement, about to 6 to 7 times in my
environment.

D. Wythe (3):
  net/smc: Make smc_tcp_listen_work() independent
  net/smc: Limits backlog connections
  net/smc: Fallback when SMC handshake workqueue

 include/linux/tcp.h  |  1 +
 net/ipv4/tcp_input.c |  3 +-
 net/smc/Kconfig      | 12 ++++++++
 net/smc/af_smc.c     | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc.h        |  5 ++++
 5 files changed, 96 insertions(+), 3 deletions(-)

-- 
1.8.3.1

