Return-Path: <netdev+bounces-4899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE1C70F124
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 282D02811E7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE944C79;
	Wed, 24 May 2023 08:37:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8302904
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:37:00 +0000 (UTC)
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1542C1FE8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:36:27 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VjNRRzq_1684917299;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VjNRRzq_1684917299)
          by smtp.aliyun-inc.com;
          Wed, 24 May 2023 16:35:00 +0800
From: Cambda Zhu <cambda@linux.alibaba.com>
To: netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Cambda Zhu <cambda@linux.alibaba.com>,
	Jack Yang <mingliang@linux.alibaba.com>
Subject: [PATCH net v1] tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set
Date: Wed, 24 May 2023 16:33:50 +0800
Message-Id: <20230524083350.54197-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
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

This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
it's zero is probably a bug.

With this change, getting TCP_MAXSEG before connecting will return
default MSS normally, and return user_mss if user_mss is set.

Fixes: 0c409e85f0ac ("Import 2.3.41pre2")
Reported-by: Jack Yang <mingliang@linux.alibaba.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com/#t
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com/
---
v1:
- Return default MSS if user_mss not set for backwards compatibility.
- Send patch to net instead of net-next, with Fixes tag.
- Add Eric's tags.
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..3e01a58724b8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4081,7 +4081,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 	switch (optname) {
 	case TCP_MAXSEG:
 		val = tp->mss_cache;
-		if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		if (tp->rx_opt.user_mss &&
+		    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 			val = tp->rx_opt.user_mss;
 		if (tp->repair)
 			val = tp->rx_opt.mss_clamp;
-- 
2.16.6


