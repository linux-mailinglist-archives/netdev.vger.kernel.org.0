Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ECE3497E6
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCYRZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:25:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhCYRYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DrkupouP2/Zi8sGjk5iYRUAPxI+cW/yKix3wozOPOwY=;
        b=PoqQRF3R2vCPdu34npePuVnpfVidmkWJkTtEPzz8jGHG+xNDnu+USkIjO1RUhKFtbvFCcb
        Gvl2rVMKeGpdFiPfg/ufhc9GN1RAMJfKuq3PWc1/VmjOF9DsCfgV8gl4Wk+8DqE4d4zrkT
        1tDJV4xl2NWZCB9G7sF1mCiKd7u1Vn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-eIlyTj5kOeekSAYlUSWXHA-1; Thu, 25 Mar 2021 13:24:45 -0400
X-MC-Unique: eIlyTj5kOeekSAYlUSWXHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AB2757210;
        Thu, 25 Mar 2021 17:24:31 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C051C76E37;
        Thu, 25 Mar 2021 17:24:29 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 5/8] vxlan: allow L4 GRO passthrough
Date:   Thu, 25 Mar 2021 18:24:04 +0100
Message-Id: <1a93521d24f50375f78f217d73ec5182773b580f.1616692794.git.pabeni@redhat.com>
In-Reply-To: <cover.1616692794.git.pabeni@redhat.com>
References: <cover.1616692794.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

