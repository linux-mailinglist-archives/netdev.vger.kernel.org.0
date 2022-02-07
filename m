Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10D84AB4EA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiBGGbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 01:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiBGGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 01:24:25 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A87C043181;
        Sun,  6 Feb 2022 22:24:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3nGPGq_1644215059;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3nGPGq_1644215059)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 14:24:20 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v4 0/3] net/smc: Optimizing performance in short-lived scenarios
Date:   Mon,  7 Feb 2022 14:24:12 +0800
Message-Id: <cover.1644214112.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
---
changelog:
v2 -> v1:
- fix compile warning
- fix invalid dependencies in kconfig
v3 -> v2:
- correct spelling mistakes
- fix useless variable declare
v4 -> v3
- make smc_tcp_ls_wq be static 
---
D. Wythe (3):
  net/smc: Make smc_tcp_listen_work() independent
  net/smc: Limits backlog connections
  net/smc: Fallback when handshake workqueue congested

 include/linux/tcp.h  |  1 +
 net/ipv4/tcp_input.c |  3 +-
 net/smc/Kconfig      | 12 ++++++++
 net/smc/af_smc.c     | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc.h        |  4 +++
 5 files changed, 95 insertions(+), 3 deletions(-)

-- 
1.8.3.1

