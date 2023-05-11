Return-Path: <netdev+bounces-1705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E726FEEF2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F12391C20F2A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD1C27703;
	Thu, 11 May 2023 09:35:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743027734
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21208C433D2;
	Thu, 11 May 2023 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683797703;
	bh=TyVMmLfQNyRUMre/Tdz35CHIY/sV2VSF64eZdStd4OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsjC4u/NMGYAleWM6QuCYt6B6MQzRmWNUFAtPrOKqHsLCu6S5gbrGMBctnW+sAakQ
	 WV4uKeWANMGdIqGKxG9fTyGB+D19j72Gsd1UZy3c3DoL+VLTJ94O2Mj+EhtgMD4KOZ
	 nkziaZJv7bo2JHfdFYpM/h820SeQMEA04JfNKdZiBE52LLGvUnOYxkSUzU612TrRCa
	 YZP3mRrdl5ST1aMZK/j55oOLPwWf76bKbkzgP5zk087M+0SkDQftb1CFqMVCqcBj5p
	 f+koSdX37mWAjPXKNim0WXkX+zqOSFIEXNLSX4rb9GEPOjDONOyR/LdhiYz6kC18Ca
	 3/75g2hvj0AqQ==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
Date: Thu, 11 May 2023 11:34:53 +0200
Message-Id: <20230511093456.672221-2-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
References: <20230511093456.672221-1-atenart@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c67b85558ff2 ("ipv6: tcp: send consistent autoflowlabel in
TIME_WAIT state") made the socket txhash also available in TIME_WAIT
sockets but for IPv6 only. Make it available for IPv4 too as we'll use
it in later commits.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index dac0d62120e6..04fc328727e6 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -303,6 +303,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		tcptw->tw_ts_offset	= tp->tsoffset;
 		tcptw->tw_last_oow_ack_time = 0;
 		tcptw->tw_tx_delay	= tp->tcp_tx_delay;
+		tw->tw_txhash		= sk->sk_txhash;
 #if IS_ENABLED(CONFIG_IPV6)
 		if (tw->tw_family == PF_INET6) {
 			struct ipv6_pinfo *np = inet6_sk(sk);
@@ -311,7 +312,6 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tw->tw_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
 			tw->tw_tclass = np->tclass;
 			tw->tw_flowlabel = be32_to_cpu(np->flow_label & IPV6_FLOWLABEL_MASK);
-			tw->tw_txhash = sk->sk_txhash;
 			tw->tw_ipv6only = sk->sk_ipv6only;
 		}
 #endif
-- 
2.40.1


