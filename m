Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AC834E573
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhC3KaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231574AbhC3K37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DrkupouP2/Zi8sGjk5iYRUAPxI+cW/yKix3wozOPOwY=;
        b=dLLIapTr6XVRI/5LqULqFlNXE3n8DX5YgkgMcqPEPmXudRB4YlmdoNXXNCJhhuuEGlSYuQ
        6U2mcqVBbeSC9+d7ty0M7rjvhvXJ9IuQQ3Uox9pvUWfvNV5AkBGBc5ifp2d59grAj6t/go
        M4HLakQlP9ElkOAQbvYNzcI/Y9e/keo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-pjN85JCNNwuLV5tv-DcsbA-1; Tue, 30 Mar 2021 06:29:56 -0400
X-MC-Unique: pjN85JCNNwuLV5tv-DcsbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20F6A835BD6;
        Tue, 30 Mar 2021 10:29:55 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9048019C45;
        Tue, 30 Mar 2021 10:29:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 5/8] vxlan: allow L4 GRO passthrough
Date:   Tue, 30 Mar 2021 12:28:53 +0200
Message-Id: <e3d9aacc43a90b294d181fcda7f598b81d8eba53.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When passing up an UDP GSO packet with L4 aggregation, there is
no need to segment it at the vxlan level. We can propagate the
packet untouched and let it be segmented later, if needed.

Introduce an helper to allow let the UDP socket to accept any
L4 aggregation and use it in the vxlan driver.

v1 -> v2:
 - updated to use the newly introduced UDP socket 'accept*' fields

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/vxlan.c | 1 +
 include/linux/udp.h | 6 ++++++
 2 files changed, 7 insertions(+)

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
index ae58ff3b6b5b8..ae66dadd85434 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -145,6 +145,12 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 	return false;
 }
 
+static inline void udp_allow_gso(struct sock *sk)
+{
+	udp_sk(sk)->accept_udp_l4 = 1;
+	udp_sk(sk)->accept_udp_fraglist = 1;
+}
+
 #define udp_portaddr_for_each_entry(__sk, list) \
 	hlist_for_each_entry(__sk, list, __sk_common.skc_portaddr_node)
 
-- 
2.26.2

