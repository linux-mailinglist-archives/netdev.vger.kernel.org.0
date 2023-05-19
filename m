Return-Path: <netdev+bounces-3841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1D0709138
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7DB5281BDB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4F32114;
	Fri, 19 May 2023 08:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29682105
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:02:39 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0E610DC
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:02:25 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VizyLYC_1684483342;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VizyLYC_1684483342)
          by smtp.aliyun-inc.com;
          Fri, 19 May 2023 16:02:23 +0800
From: Cambda Zhu <cambda@linux.alibaba.com>
To: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Cambda Zhu <cambda@linux.alibaba.com>,
	Jack Yang <mingliang@linux.alibaba.com>
Subject: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state
Date: Fri, 19 May 2023 16:01:18 +0800
Message-Id: <20230519080118.25539-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bug,
since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
TCP_MAXSEG of sock in other state will still return tp->mss_cache.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Reported-by: Jack Yang <mingliang@linux.alibaba.com>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3d18e295bb2f..713854f1f061 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4083,7 +4083,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 	switch (optname) {
 	case TCP_MAXSEG:
 		val = tp->mss_cache;
-		if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
 			val = tp->rx_opt.user_mss;
 		if (tp->repair)
 			val = tp->rx_opt.mss_clamp;
-- 
2.16.6


