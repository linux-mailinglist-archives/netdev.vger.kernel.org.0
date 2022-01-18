Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EBC49299A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344683AbiARPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:25:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242695AbiARPZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642519516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6TEMHfkJFFsNPCEXQEWk8iYL0SnF/mJ5afISlqyFkk=;
        b=Fb1QNyEAnwQ+0r35eZDETRWDWDYykgjt4sBYhd80xVRCt3N90mjgjcSzh4aiGi5SGvadJU
        984Ctyr2DOCYLEQiDGlnlP4HPz8Ven6W18kWlHIFexN8376xCPm0zpwd7T9HZMf3dESPn0
        9W7pK7NoAurrBJr43ku8jpEmePlOZFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-Fhdy4-gtM8GE1lMHhBEhVg-1; Tue, 18 Jan 2022 10:25:15 -0500
X-MC-Unique: Fhdy4-gtM8GE1lMHhBEhVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A43B1018725;
        Tue, 18 Jan 2022 15:25:14 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4227D106C063;
        Tue, 18 Jan 2022 15:25:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Tue, 18 Jan 2022 16:24:19 +0100
Message-Id: <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
In-Reply-To: <cover.1642519257.git.pabeni@redhat.com>
References: <cover.1642519257.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While inspecting some perf report, I noticed that the compiler
emits suboptimal code for the napi CB initialization, fetching
and storing multiple times the memory for flags bitfield.
This is with gcc 10.3.1, but I observed the same with older compiler
versions.

We can help the compiler to do a nicer work e.g. initially setting
all the bitfield to 0 using an u16 alias. The generated code is quite
smaller, with the same number of conditional

Before:
objdump -t net/core/gro.o | grep " F .text"
0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive

After:
0000000000000bb0 l     F .text	000000000000033c dev_gro_receive

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/gro.h | 13 +++++++++----
 net/core/gro.c    | 16 +++++-----------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 8f75802d50fd..a068b27d341f 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -29,14 +29,17 @@ struct napi_gro_cb {
 	/* Number of segments aggregated. */
 	u16	count;
 
-	/* Start offset for remote checksum offload */
-	u16	gro_remcsum_start;
+	/* Used in ipv6_gro_receive() and foo-over-udp */
+	u16	proto;
 
 	/* jiffies when first packet was created/queued */
 	unsigned long age;
 
-	/* Used in ipv6_gro_receive() and foo-over-udp */
-	u16	proto;
+	/* portion of the cb set to zero at every gro iteration */
+	u32	zeroed_start[0];
+
+	/* Start offset for remote checksum offload */
+	u16	gro_remcsum_start;
 
 	/* This is non-zero if the packet may be of the same flow. */
 	u8	same_flow:1;
@@ -70,6 +73,8 @@ struct napi_gro_cb {
 	/* GRO is done by frag_list pointer chaining. */
 	u8	is_flist:1;
 
+	u32	zeroed_end[0];
+
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
 
diff --git a/net/core/gro.c b/net/core/gro.c
index d43d42215bdb..b9ebe9298731 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -435,6 +435,9 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 	napi_gro_complete(napi, oldest);
 }
 
+#define zeroed_len	(offsetof(struct napi_gro_cb, zeroed_end) - \
+			 offsetof(struct napi_gro_cb, zeroed_start))
+
 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
 	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
@@ -459,29 +462,20 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 		skb_set_network_header(skb, skb_gro_offset(skb));
 		skb_reset_mac_len(skb);
-		NAPI_GRO_CB(skb)->same_flow = 0;
+		BUILD_BUG_ON(zeroed_len != sizeof(NAPI_GRO_CB(skb)->zeroed_start[0]));
+		NAPI_GRO_CB(skb)->zeroed_start[0] = 0;
 		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
-		NAPI_GRO_CB(skb)->free = 0;
-		NAPI_GRO_CB(skb)->encap_mark = 0;
-		NAPI_GRO_CB(skb)->recursion_counter = 0;
-		NAPI_GRO_CB(skb)->is_fou = 0;
 		NAPI_GRO_CB(skb)->is_atomic = 1;
-		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
 
 		/* Setup for GRO checksum validation */
 		switch (skb->ip_summed) {
 		case CHECKSUM_COMPLETE:
 			NAPI_GRO_CB(skb)->csum = skb->csum;
 			NAPI_GRO_CB(skb)->csum_valid = 1;
-			NAPI_GRO_CB(skb)->csum_cnt = 0;
 			break;
 		case CHECKSUM_UNNECESSARY:
 			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
-			NAPI_GRO_CB(skb)->csum_valid = 0;
 			break;
-		default:
-			NAPI_GRO_CB(skb)->csum_cnt = 0;
-			NAPI_GRO_CB(skb)->csum_valid = 0;
 		}
 
 		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
-- 
2.34.1

