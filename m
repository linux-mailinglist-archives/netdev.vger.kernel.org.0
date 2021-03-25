Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37B43495BA
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCYPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCYPfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 11:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C58061A1F;
        Thu, 25 Mar 2021 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616686537;
        bh=xXMwrTissq5NCSjVtNk4wB9CZ91/Komtk/Xvj4pRcLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix3OzNIOkYUPOs8uKzv/SFybkS+/zXl8UEIbGmyicTiB0nefkRQm7fpibWyQyyUXW
         CFi1LjGyLZAb2W/kqIWxSxXDKB1YxI3CzU0jMtoOXVs1nPJT4B9MtLVdgs8ETQ1mYv
         3obiFchEf/d+eZKDBDkdz+sJHJZwPuyO/QZ1dMeL5Bk8dGQz4g0T4eBrYN2aHiZAfw
         9ydIGucJ31O4UO1JxgnEdaU07hYdlputRmj/v5zDk03f6Q6CIIqZfReqWjP9iVbkEf
         gdjcTiWx7ea+tFjWhR0nY9A/CVPKePvxqZZkLfLwLCzeoUiCYt7QHbuaUJ062kGDQv
         oIJehLZ8G1I4Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net 1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Thu, 25 Mar 2021 16:35:32 +0100
Message-Id: <20210325153533.770125-2-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325153533.770125-1-atenart@kernel.org>
References: <20210325153533.770125-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the interface is part of a bridge or an Open vSwitch port and a
packet exceed a PMTU estimate, an ICMP reply is sent to the sender. When
using the external mode (collect metadata) the source and destination
addresses are reversed, so that Open vSwitch can match the packet
against an existing (reverse) flow.

But inverting the source and destination addresses in the shared
ip_tunnel_info will make following packets of the flow to use a wrong
destination address (packets will be tunnelled to itself), if the flow
isn't updated. Which happens with Open vSwitch, until the flow times
out.

Fixes this by uncloning the skb's ip_tunnel_info before inverting its
source and destination addresses, so that the modification will only be
made for the PTMU packet, not the following ones.

Fixes: fc68c99577cc ("vxlan: Support for PMTU discovery on directly bridged links")
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/vxlan.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 666dd201c3d5..53dbc67e8a34 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2725,12 +2725,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
+				struct ip_tunnel_info *unclone;
 				struct in_addr src, dst;
 
+				unclone = skb_tunnel_info_unclone(skb);
+				if (unlikely(!unclone))
+					goto tx_error;
+
 				src = remote_ip.sin.sin_addr;
 				dst = local_ip.sin.sin_addr;
-				info->key.u.ipv4.src = src.s_addr;
-				info->key.u.ipv4.dst = dst.s_addr;
+				unclone->key.u.ipv4.src = src.s_addr;
+				unclone->key.u.ipv4.dst = dst.s_addr;
 			}
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
 			dst_release(ndst);
@@ -2781,12 +2786,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
+				struct ip_tunnel_info *unclone;
 				struct in6_addr src, dst;
 
+				unclone = skb_tunnel_info_unclone(skb);
+				if (unlikely(!unclone))
+					goto tx_error;
+
 				src = remote_ip.sin6.sin6_addr;
 				dst = local_ip.sin6.sin6_addr;
-				info->key.u.ipv6.src = src;
-				info->key.u.ipv6.dst = dst;
+				unclone->key.u.ipv6.src = src;
+				unclone->key.u.ipv6.dst = dst;
 			}
 
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
-- 
2.30.2

