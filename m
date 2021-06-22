Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529C43AFAB9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhFVBzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 21:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhFVBzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 21:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2068B6112D;
        Tue, 22 Jun 2021 01:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624326777;
        bh=OuG81/jvGpv48xqTCK1F1n4Jfr3bjUFjkNZPUXlcnD8=;
        h=From:To:Cc:Subject:Date:From;
        b=fRFbLEkkqbBDuqGy9XG+BqJRsLXl2/SrE/0BOhAisLC8kxR0KTg5qZ91dvhzW7TAX
         9iwBNEnBOaki0ziVFkmL3mKEkkgR3nWRZNfBa035f9q85m+RyHe0/DnPyruyfuiQz1
         YnHN0CtN2dgQqDVLylkR4ZhDOfiBG9LLO+OTjEkfYKZqPDYFHCa0TltdxHCkgFt72c
         D/GrZ7NVuxckpWb20wPmopxTwcGpm9CcrYYx09HmKF0/R9R//taYGEQZ88WZx8FgTS
         yaneLg3BROKgcC7mR4/l9gXo9KrxhQtPDsES/moCi7dHOveqNnboAsRXN1N/D1LWhA
         Iq7mrVX2EnLQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ip6_tunnel: fix GRE6 segmentation
Date:   Mon, 21 Jun 2021 18:52:54 -0700
Message-Id: <20210622015254.1967716-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
its callee ip6_tnl_xmit(). The latter is also used by GRE.

Since commit 38720352412a ("gre: Use inner_proto to obtain inner
header protocol") GRE had been depending on skb->inner_protocol
during segmentation. It sets it in gre_build_header() and reads
it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
the protocol, resulting in GSO skbs getting dropped.

Note that inner_protocol is a union with inner_ipproto,
GRE uses the former while the change switched it to the latter
(always setting it to just IPPROTO_GRE).

Restore the original location of skb_set_inner_ipproto(),
it is unclear why it was moved in the first place.

Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 288bafded998..28ca70af014a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1239,8 +1239,6 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	if (max_headroom > dev->needed_headroom)
 		dev->needed_headroom = max_headroom;
 
-	skb_set_inner_ipproto(skb, proto);
-
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
 		return err;
@@ -1377,6 +1375,8 @@ ipxip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
+	skb_set_inner_ipproto(skb, protocol);
+
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   protocol);
 	if (err != 0) {
-- 
2.31.1

