Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3854A87FE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351959AbiBCPss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:48:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244315AbiBCPsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643903322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONfCTeY4DTT3Qpg9+rSTZST8f2A/MEhSP804OmUADLA=;
        b=W4Cnv7qpQY+X5K8smEoY/U7yKwyfRgKVTMr+ziGf633zmxAGoiX8BxqO6CP5GMMPUSI2py
        htqIdyCE7RZdRkoMkppq4u4rvWxsNgKRzPoIRGbGQ3oH/NSLr0YQWgxs2r4Fh9v/eMkTNO
        6ET6ic46WNSOvuQ9BWfz91Z6xwL7POI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-6CZ-_sOBP-aPSlvDnVnnxA-1; Thu, 03 Feb 2022 10:48:39 -0500
X-MC-Unique: 6CZ-_sOBP-aPSlvDnVnnxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FC3B802C87;
        Thu,  3 Feb 2022 15:48:38 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC0E410841E4;
        Thu,  3 Feb 2022 15:48:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Thu,  3 Feb 2022 16:48:22 +0100
Message-Id: <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
In-Reply-To: <cover.1643902526.git.pabeni@redhat.com>
References: <cover.1643902526.git.pabeni@redhat.com>
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

We can help the compiler to do a nicer work clearing several
fields at once using an u32 alias. The generated code is quite
smaller, with the same number of conditional.

Before:
objdump -t net/core/gro.o | grep " F .text"
0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive

After:
0000000000000bb0 l     F .text	000000000000033c dev_gro_receive

RFC -> v1:
 - use __struct_group to delimt the zeroed area (Alexander)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
 net/core/gro.c    | 18 +++++++---------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 8f75802d50fd..fa1bb0f0ad28 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -29,46 +29,50 @@ struct napi_gro_cb {
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
+	__struct_group(/* no tag */, zeroed, /* no attrs */,
+
+		/* Start offset for remote checksum offload */
+		u16	gro_remcsum_start;
 
-	/* This is non-zero if the packet may be of the same flow. */
-	u8	same_flow:1;
+		/* This is non-zero if the packet may be of the same flow. */
+		u8	same_flow:1;
 
-	/* Used in tunnel GRO receive */
-	u8	encap_mark:1;
+		/* Used in tunnel GRO receive */
+		u8	encap_mark:1;
 
-	/* GRO checksum is valid */
-	u8	csum_valid:1;
+		/* GRO checksum is valid */
+		u8	csum_valid:1;
 
-	/* Number of checksums via CHECKSUM_UNNECESSARY */
-	u8	csum_cnt:3;
+		/* Number of checksums via CHECKSUM_UNNECESSARY */
+		u8	csum_cnt:3;
 
-	/* Free the skb? */
-	u8	free:2;
+		/* Free the skb? */
+		u8	free:2;
 #define NAPI_GRO_FREE		  1
 #define NAPI_GRO_FREE_STOLEN_HEAD 2
 
-	/* Used in foo-over-udp, set in udp[46]_gro_receive */
-	u8	is_ipv6:1;
+		/* Used in foo-over-udp, set in udp[46]_gro_receive */
+		u8	is_ipv6:1;
 
-	/* Used in GRE, set in fou/gue_gro_receive */
-	u8	is_fou:1;
+		/* Used in GRE, set in fou/gue_gro_receive */
+		u8	is_fou:1;
 
-	/* Used to determine if flush_id can be ignored */
-	u8	is_atomic:1;
+		/* Used to determine if flush_id can be ignored */
+		u8	is_atomic:1;
 
-	/* Number of gro_receive callbacks this packet already went through */
-	u8 recursion_counter:4;
+		/* Number of gro_receive callbacks this packet already went through */
+		u8 recursion_counter:4;
 
-	/* GRO is done by frag_list pointer chaining. */
-	u8	is_flist:1;
+		/* GRO is done by frag_list pointer chaining. */
+		u8	is_flist:1;
+	);
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
diff --git a/net/core/gro.c b/net/core/gro.c
index d43d42215bdb..fc56be9408c7 100644
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
@@ -459,29 +462,22 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 		skb_set_network_header(skb, skb_gro_offset(skb));
 		skb_reset_mac_len(skb);
-		NAPI_GRO_CB(skb)->same_flow = 0;
+		BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
+		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
+					 sizeof(u32))); /* Avoid slow unaligned acc */
+		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
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

