Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1603D1471
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhGUQE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234881AbhGUQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=975rAEQBbYHaPZ9GmjrYnlMR6WbR6sF31REUntWo2Ro=;
        b=fQiY+MAKf1wvX+lpjDBBC1rtrZ4KF4PZl0wbTwlXAlUUqO2rg5vk9zVR2jE14nqVjzZfhU
        U27g6VuYkD3I5v/NRl5xo5xBbuDaqXD6UQHNeIadDgaqcqbnI2ZmrgLAjdR40TaoEJ/MTA
        EHnxLAqXmEtacxsASWXS62KP49uVWWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-kzK07x3jNqanuoWCuAyCvw-1; Wed, 21 Jul 2021 12:45:26 -0400
X-MC-Unique: kzK07x3jNqanuoWCuAyCvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79FD7824FA0;
        Wed, 21 Jul 2021 16:45:25 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF4A3797C0;
        Wed, 21 Jul 2021 16:45:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 8/9] sk_buff: move vlan field after tail.
Date:   Wed, 21 Jul 2021 18:44:40 +0200
Message-Id: <fcc82c64961666cd10c5e275156f80396a709205.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Such field validity is already tracked by the existing
'vlan_present' bit. Move them after tail and conditinally copy
as needed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 10 ++++++++--
 net/core/skbuff.c      |  5 +++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3e756575aa7..7acf2a203918 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -897,8 +897,6 @@ struct sk_buff {
 	__u32			priority;
 	int			skb_iif;
 	__u32			hash;
-	__be16			vlan_proto;
-	__u16			vlan_tci;
 #if defined(CONFIG_NET_RX_BUSY_POLL) || defined(CONFIG_XPS)
 	union {
 		unsigned int	napi_id;
@@ -955,6 +953,14 @@ struct sk_buff {
 		};
 		__u64		inner_headers;
 	};
+
+	union {
+		struct {
+			__be16	vlan_proto;
+			__u16	vlan_tci;
+		};
+		__u32		vlan_info;
+	};
 };
 
 #ifdef __KERNEL__
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 53b8db10e567..c59e90db80d5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -996,6 +996,8 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	__skb_ext_copy(new, old);
 	__nf_copy(new, old, false);
 	__skb_copy_inner_headers(new, old);
+	if (old->vlan_present)
+		new->vlan_info = old->vlan_info;
 
 	/* Note : this field could be in headers_start/headers_end section
 	 * It is not yet because we do not want to have a 16 bit hole
@@ -1007,13 +1009,12 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	       offsetof(struct sk_buff, headers_start));
 	CHECK_SKB_FIELD(_state);
 	CHECK_SKB_FIELD(__pkt_encapsulation_offset);
+	CHECK_SKB_FIELD(__pkt_vlan_present_offset);
 	CHECK_SKB_FIELD(protocol);
 	CHECK_SKB_FIELD(csum);
 	CHECK_SKB_FIELD(hash);
 	CHECK_SKB_FIELD(priority);
 	CHECK_SKB_FIELD(skb_iif);
-	CHECK_SKB_FIELD(vlan_proto);
-	CHECK_SKB_FIELD(vlan_tci);
 	CHECK_SKB_FIELD(transport_header);
 	CHECK_SKB_FIELD(network_header);
 	CHECK_SKB_FIELD(mac_header);
-- 
2.26.3

