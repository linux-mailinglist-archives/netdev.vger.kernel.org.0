Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51C3D931E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhG1QYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhG1QYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03zyxcpyFQ3z/dlAQUsY54cVAItX7uVxV1tMy1518Os=;
        b=Ntw+YE+nr6PeXxy1pnxUg0pJRvHLJn1jtVdjhOvAAy7LA+L5qjqofEeB/SDulIIZ0G+XO9
        6NET5uztcDyEVI1h8WphlwF0wWFtRK6IA9MDqyoYJ1Scgajz9hA1u5XxVYYGTFDl18EHJf
        oiigqWgZv5A7Nw0RchlOmSwmTwENT0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-qKtxpsmGNO2D8YMYB0hhWg-1; Wed, 28 Jul 2021 12:24:34 -0400
X-MC-Unique: qKtxpsmGNO2D8YMYB0hhWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 999031006706;
        Wed, 28 Jul 2021 16:24:33 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 822EA5C1B4;
        Wed, 28 Jul 2021 16:24:32 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/6] sk_buff: introduce 'slow_gro' flags
Date:   Wed, 28 Jul 2021 18:23:59 +0200
Message-Id: <075a3b28299ad4a0b00c28ff5886b9b4fe475392.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new flag tracks if any state field is set, so that
GRO requires 'unusual'/slow prepare steps.

Set such flag when a ct entry is attached to the skb,
and never clear it.

The new bit uses an existing hole into the sk_buff struct

RFC -> v1:
 - use a single state bit, never clear it
 - avoid moving the _nfct field

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f19190820e63..3ff18300d210 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -689,6 +689,7 @@ typedef unsigned char *sk_buff_data_t;
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
+ *	@slow_gro: state present at GRO time, slower prepare step required
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -870,6 +871,7 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
+	__u8			slow_gro:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -4216,6 +4218,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	skb->slow_gro |= !!nfct;
 	skb->_nfct = nfct;
 #endif
 }
@@ -4375,6 +4378,7 @@ static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_conntrack_put(skb_nfct(dst));
 #endif
+	dst->slow_gro = src->slow_gro;
 	__nf_copy(dst, src, true);
 }
 
-- 
2.26.3

