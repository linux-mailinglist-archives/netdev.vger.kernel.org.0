Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66864AD89D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiBHNP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiBHMxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:53:23 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA70C03FEC0;
        Tue,  8 Feb 2022 04:53:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3we9Sx_1644324796;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3we9Sx_1644324796)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 20:53:16 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v5 0/5] net/smc: Optimizing performance in short-lived scenarios 
Date:   Tue,  8 Feb 2022 20:53:08 +0800
Message-Id: <cover.1644323503.git.alibuda@linux.alibaba.com>
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

Patch 1/5  (Make smc_tcp_listen_work() independent) :

Separate smc_tcp_listen_work() from smc_listen_work(), make them
independent of each other, the busy SMC handshake can not affect new TCP
connections visit any more. Avoid discarding a large number of TCP
connections after being overstock, which is undoubtedly raise the
connection establishment time.

Patch 2/5 (Limits SMC backlog connections):

Since patch 1 has separated smc_tcp_listen_work() from
smc_listen_work(), an unrestricted TCP accept have come into being. This
patch try to put a limit on SMC backlog connections refers to
implementation of TCP.

Patch 3/5 (Fallback when SMC handshake workqueue congested):

Considering the complexity of SMC handshake right now, in short-lived
links scenarios, this may not be the main scenario of SMC though, it's
performance is still quite poor. This Patch try to provide auto fallback
case when SMC handshake workqueue congested, which is the sign of SMC
handshake stacking in our opinion.

Patch 4/5 (Dynamic control SMC auto fallback by socket options)

This patch allow applications dynamically control the ability of SMC
auto fallback. Since SMC don't support set SMC socket option before,
this patch also have to support SMC's owns socket options.

Patch 5/5 (Add global configure for auto fallback by netlink)

This patch provides a way to get benefit of auto fallback without
modifying any code for applications, which is quite useful for most
existing applications.

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
v5 -> v4
- add dynamic control for SMC auto fallback by socket options
- add global configure for SMC auto fallback through netlink
---
D. Wythe (5):
  net/smc: Make smc_tcp_listen_work() independent
  net/smc: Limits backlog connections
  net/smc: Fallback when handshake workqueue congested
  net/smc: Dynamic control auto fallback by socket options
  net/smc: Add global configure for auto fallback by netlink

 include/linux/socket.h   |   1 +
 include/linux/tcp.h      |   1 +
 include/uapi/linux/smc.h |   7 +++
 net/ipv4/tcp_input.c     |   3 +-
 net/smc/af_smc.c         | 158 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc.h            |  12 ++++
 net/smc/smc_core.c       |   2 +
 net/smc/smc_netlink.c    |  10 +++
 8 files changed, 191 insertions(+), 3 deletions(-)

-- 
1.8.3.1

