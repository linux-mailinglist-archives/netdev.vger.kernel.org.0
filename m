Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8869F5E6324
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiIVNFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIVNFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:05:44 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13696E3EFB;
        Thu, 22 Sep 2022 06:05:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VQStrrr_1663851937;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VQStrrr_1663851937)
          by smtp.aliyun-inc.com;
          Thu, 22 Sep 2022 21:05:38 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next] net/smc: Support SO_REUSEPORT
Date:   Thu, 22 Sep 2022 20:19:07 +0800
Message-Id: <20220922121906.72406-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables SO_REUSEPORT [1] for clcsock when it is set on smc socket,
so that some applications which uses it can be transparently replaced
with SMC. Also, this helps improve load distribution.

Here is a simple test of NGINX + wrk with SMC. The CPU usage is collected
on NGINX (server) side as below.

Disable SO_REUSEPORT:

05:15:33 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
05:15:34 PM  all    7.02    0.00   11.86    0.00    2.04    8.93    0.00    0.00    0.00   70.15
05:15:34 PM    0    0.00    0.00    0.00    0.00   16.00   70.00    0.00    0.00    0.00   14.00
05:15:34 PM    1   11.58    0.00   22.11    0.00    0.00    0.00    0.00    0.00    0.00   66.32
05:15:34 PM    2    1.00    0.00    1.00    0.00    0.00    0.00    0.00    0.00    0.00   98.00
05:15:34 PM    3   16.84    0.00   30.53    0.00    0.00    0.00    0.00    0.00    0.00   52.63
05:15:34 PM    4   28.72    0.00   44.68    0.00    0.00    0.00    0.00    0.00    0.00   26.60
05:15:34 PM    5    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
05:15:34 PM    6    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
05:15:34 PM    7    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00

Enable SO_REUSEPORT:

05:15:20 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
05:15:21 PM  all    8.56    0.00   14.40    0.00    2.20    9.86    0.00    0.00    0.00   64.98
05:15:21 PM    0    0.00    0.00    4.08    0.00   14.29   76.53    0.00    0.00    0.00    5.10
05:15:21 PM    1    9.09    0.00   16.16    0.00    1.01    0.00    0.00    0.00    0.00   73.74
05:15:21 PM    2    9.38    0.00   16.67    0.00    1.04    0.00    0.00    0.00    0.00   72.92
05:15:21 PM    3   10.42    0.00   17.71    0.00    1.04    0.00    0.00    0.00    0.00   70.83
05:15:21 PM    4    9.57    0.00   15.96    0.00    0.00    0.00    0.00    0.00    0.00   74.47
05:15:21 PM    5    9.18    0.00   15.31    0.00    0.00    1.02    0.00    0.00    0.00   74.49
05:15:21 PM    6    8.60    0.00   15.05    0.00    0.00    0.00    0.00    0.00    0.00   76.34
05:15:21 PM    7   12.37    0.00   14.43    0.00    0.00    0.00    0.00    0.00    0.00   73.20

Using SO_REUSEPORT helps the load distribution of NGINX be more
balanced.

[1] https://man7.org/linux/man-pages/man7/socket.7.html

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0939cc3b915a..d933a804c94b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -427,6 +427,7 @@ static int smc_bind(struct socket *sock, struct sockaddr *uaddr,
 		goto out_rel;
 
 	smc->clcsock->sk->sk_reuse = sk->sk_reuse;
+	smc->clcsock->sk->sk_reuseport = sk->sk_reuseport;
 	rc = kernel_bind(smc->clcsock, uaddr, addr_len);
 
 out_rel:
-- 
2.19.1.6.gb485710b

