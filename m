Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3363D1474
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhGUQE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234958AbhGUQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gugCLHaVbmv/C295S1bpwRbJv0VkheeePCutWfFf0A=;
        b=MXmaxC6+SzomoEz+GZ6SLBx33EzOiDzj5eiwmiqpcU0NEfynKuHE81afduUUr0gn8nSIE5
        2NPZv9hg6wTU4fiSoYpPrQ4yV1j2gv3apI3+aiDa69a4iKVBY5suolZzolEUNJzeFh7EvX
        mNMSA9nw6yW1pQWuRBTvYBK3cFmHnCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-SXlQRE7mMYSuIzjb2ieV0w-1; Wed, 21 Jul 2021 12:45:25 -0400
X-MC-Unique: SXlQRE7mMYSuIzjb2ieV0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6988481C6DB;
        Wed, 21 Jul 2021 16:45:23 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F75C797C0;
        Wed, 21 Jul 2021 16:45:21 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 7/9] sk_buff: move inner header fields after tail
Date:   Wed, 21 Jul 2021 18:44:39 +0200
Message-Id: <99ff8a613938fd5bb670e1e7b4e3bb79770c5078.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

all the inner header fields are valid only if the 'encaspulation'
flag is set, and the relevant fields are always initialized when
the field is set: we don't need to initialize them at skb allocation
time

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 v1 -> v2:
  - add CHECK_SKB_FIELD(__encapsulation_offset) in __copy_skb_header
---
 include/linux/skbuff.h | 31 ++++++++++++++++++++++---------
 net/core/skbuff.c      |  6 ++----
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ea9fdcc7c7ca..a3e756575aa7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -822,6 +822,9 @@ struct sk_buff {
 	__u8			ip_summed:2;
 	__u8			ooo_okay:1;
 
+	/* private: */
+	__u8			__pkt_encapsulation_offset[0];
+	/* public: */
 	__u8			l4_hash:1;
 	__u8			sw_hash:1;
 	__u8			wifi_acked_valid:1;
@@ -911,15 +914,6 @@ struct sk_buff {
 		__u32		reserved_tailroom;
 	};
 
-	union {
-		__be16		inner_protocol;
-		__u8		inner_ipproto;
-	};
-
-	__u16			inner_transport_header;
-	__u16			inner_network_header;
-	__u16			inner_mac_header;
-
 	__be16			protocol;
 	__u16			transport_header;
 	__u16			network_header;
@@ -948,6 +942,19 @@ struct sk_buff {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	unsigned long		 _nfct;
 #endif
+	union {
+		struct {
+			union {
+			__be16	inner_protocol;
+			__u8	inner_ipproto;
+			};
+
+			__u16	inner_transport_header;
+			__u16	inner_network_header;
+			__u16	inner_mac_header;
+		};
+		__u64		inner_headers;
+	};
 };
 
 #ifdef __KERNEL__
@@ -2449,6 +2456,12 @@ static inline void skb_tailroom_reserve(struct sk_buff *skb, unsigned int mtu,
 #define ENCAP_TYPE_ETHER	0
 #define ENCAP_TYPE_IPPROTO	1
 
+static inline void __skb_copy_inner_headers(struct sk_buff *dst, const struct sk_buff *src)
+{
+	if (src->encapsulation)
+		dst->inner_headers = src->inner_headers;
+}
+
 static inline void skb_set_inner_protocol(struct sk_buff *skb,
 					  __be16 protocol)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9ed754da6e13..53b8db10e567 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -995,6 +995,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	skb_dst_copy(new, old);
 	__skb_ext_copy(new, old);
 	__nf_copy(new, old, false);
+	__skb_copy_inner_headers(new, old);
 
 	/* Note : this field could be in headers_start/headers_end section
 	 * It is not yet because we do not want to have a 16 bit hole
@@ -1005,6 +1006,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	       offsetof(struct sk_buff, headers_end) -
 	       offsetof(struct sk_buff, headers_start));
 	CHECK_SKB_FIELD(_state);
+	CHECK_SKB_FIELD(__pkt_encapsulation_offset);
 	CHECK_SKB_FIELD(protocol);
 	CHECK_SKB_FIELD(csum);
 	CHECK_SKB_FIELD(hash);
@@ -1015,10 +1017,6 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	CHECK_SKB_FIELD(transport_header);
 	CHECK_SKB_FIELD(network_header);
 	CHECK_SKB_FIELD(mac_header);
-	CHECK_SKB_FIELD(inner_protocol);
-	CHECK_SKB_FIELD(inner_transport_header);
-	CHECK_SKB_FIELD(inner_network_header);
-	CHECK_SKB_FIELD(inner_mac_header);
 	CHECK_SKB_FIELD(mark);
 #ifdef CONFIG_NETWORK_SECMARK
 	CHECK_SKB_FIELD(secmark);
-- 
2.26.3

