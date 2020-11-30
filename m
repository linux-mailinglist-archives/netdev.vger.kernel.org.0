Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA12C893F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgK3QT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgK3QT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 11:19:56 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F74206DF;
        Mon, 30 Nov 2020 16:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606753155;
        bh=bRIcaHhHqlvo/8O82d4WzpQWjZzJF1oDZVrAAKxtczQ=;
        h=From:To:Cc:Subject:Date:From;
        b=mFt99bCe6y1uKUXZaGARAfQrGdoPimyc0aooJkHegue9TYxme3FS7NQbI0DU0KZyt
         kL5BtJYym98hfKE+fvAEQn9n20MZGmPnyt+3PKZ6ptiBHVuZHtoVij409MGYNRLSYt
         NUbmnXrXsnDiI0Rk1qbOUMYebxixa0hhOvfOSNo8=
From:   Antoine Tenart <atenart@kernel.org>
To:     kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Maria Pasechnik <mariap@mellanox.com>
Subject: [PATCH net] net: ip6_gre: set dev->hard_header_len when using header_ops
Date:   Mon, 30 Nov 2020 17:19:11 +0100
Message-Id: <20201130161911.464106-1-atenart@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller managed to crash the kernel using an NBMA ip6gre interface. I
could reproduce it creating an NBMA ip6gre interface and forwarding
traffic to it:

  skbuff: skb_under_panic: text:ffffffff8250e927 len:148 put:44 head:ffff8c03c7a33
  ------------[ cut here ]------------
  kernel BUG at net/core/skbuff.c:109!
  Call Trace:
  skb_push+0x10/0x10
  ip6gre_header+0x47/0x1b0
  neigh_connected_output+0xae/0xf0

ip6gre tunnel provides its own header_ops->create, and sets it
conditionally when initializing the tunnel in NBMA mode. When
header_ops->create is used, dev->hard_header_len should reflect the
length of the header created. Otherwise, when not used,
dev->needed_headroom should be used.

Fixes: eb95f52fc72d ("net: ipv6_gre: Fix GRO to work on IPv6 over GRE tap")
Cc: Maria Pasechnik <mariap@mellanox.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/ipv6/ip6_gre.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 8cf659994412..c3bc89b6b1a1 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1133,8 +1133,13 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 			return;
 
 		if (rt->dst.dev) {
-			dev->needed_headroom = rt->dst.dev->hard_header_len +
-					       t_hlen;
+			unsigned short dst_len = rt->dst.dev->hard_header_len +
+						 t_hlen;
+
+			if (t->dev->header_ops)
+				dev->hard_header_len = dst_len;
+			else
+				dev->needed_headroom = dst_len;
 
 			if (set_mtu) {
 				dev->mtu = rt->dst.dev->mtu - t_hlen;
@@ -1159,7 +1164,12 @@ static int ip6gre_calc_hlen(struct ip6_tnl *tunnel)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 
 	t_hlen = tunnel->hlen + sizeof(struct ipv6hdr);
-	tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
+
+	if (tunnel->dev->header_ops)
+		tunnel->dev->hard_header_len = LL_MAX_HEADER + t_hlen;
+	else
+		tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
+
 	return t_hlen;
 }
 
-- 
2.28.0

