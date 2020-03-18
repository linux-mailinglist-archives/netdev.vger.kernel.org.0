Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D14189838
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgCRJob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:31 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51672 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727624AbgCRJn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:58 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9ho5q012856;
        Wed, 18 Mar 2020 11:43:50 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id D0D49360F45; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 10/28] gro: prevent ACE field corruption & better AccECN handling
Date:   Wed, 18 Mar 2020 11:43:14 +0200
Message-Id: <1584524612-24470-11-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

There are important differences in how the CWR field behaves
in RFC3168 and AccECN.

Thus, it is better to never let anything to receive
a mixed-CWR skb. Set the Accurate ECN GSO flag to
avoid corrupting CWR bits somewhere.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 net/ipv4/tcp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 7a81cf438010..58ce382c793e 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -242,7 +242,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	flush = NAPI_GRO_CB(p)->flush;
 	flush |= (__force int)(flags & TCP_FLAG_CWR);
 	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
-		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
+		  ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
 	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
 	for (i = sizeof(*th); i < thlen; i += 4)
 		flush |= *(u32 *)((u8 *)th + i) ^
@@ -300,7 +300,7 @@ int tcp_gro_complete(struct sk_buff *skb)
 	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 
 	if (th->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 
 	return 0;
 }
-- 
2.20.1

