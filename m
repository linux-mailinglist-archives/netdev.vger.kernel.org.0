Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6D343394
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCURCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhCURB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjdMYcyRSXe0nrjd6bX7T+6s21/5YIV3yRxFQZ0nyFw=;
        b=gL+CukPCmWHn4FRsuj+eJcbzP+t6Uxu+Fp7d6YW6CA0vHPyVRPr3a7bWp+rpjiyBS110P0
        2Pm64wEetwLRHsE8jnIxb4fByKn/1r4xSKUeOR4lSSOUGvao7MB8LJzFNiPfmo0MEd0/F/
        NEvRjGu6pkvIH8IP5FFxq3fFrKV0cgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-TpLFCqmnM9aGXqTGNf58RA-1; Sun, 21 Mar 2021 13:01:53 -0400
X-MC-Unique: TpLFCqmnM9aGXqTGNf58RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B07801817;
        Sun, 21 Mar 2021 17:01:52 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 968AD5D6B1;
        Sun, 21 Mar 2021 17:01:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 5/8] vxlan: allow L4 GRO passthrou
Date:   Sun, 21 Mar 2021 18:01:16 +0100
Message-Id: <a92d536898ba23065e86eb26675fffeadba66f12.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When passing up an UDP GSO packet with L4 aggregation, there is
no need to segment it at the vxlan level. We can propagate the
packet untouched and let it be segmented later, if needed.

Introduce an helper to allow let the UDP socket accepting any
L4 aggregation and use it in the vxlan driver.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/vxlan.c | 1 +
 include/linux/udp.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 7665817f3cb61..39ee1300cdd9d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3484,6 +3484,7 @@ static struct socket *vxlan_create_sock(struct net *net, bool ipv6,
 	if (err < 0)
 		return ERR_PTR(err);
 
+	udp_allow_gso(sock->sk);
 	return sock;
 }
 
diff --git a/include/linux/udp.h b/include/linux/udp.h
index 6da342f15f351..0444f2fb6002e 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -137,6 +137,11 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 	return skb_is_gso(skb) && skb_shinfo(skb)->gso_type & udp_sk(sk)->unexpected_gso;
 }
 
+static inline void udp_allow_gso(struct sock *sk)
+{
+	udp_sk(sk)->unexpected_gso = 0;
+}
+
 #define udp_portaddr_for_each_entry(__sk, list) \
 	hlist_for_each_entry(__sk, list, __sk_common.skc_portaddr_node)
 
-- 
2.26.2

