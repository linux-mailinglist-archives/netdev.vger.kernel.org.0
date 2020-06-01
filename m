Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F71EA454
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgFAM7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 08:59:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40401 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbgFAM7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 08:59:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DC5B25C00E4;
        Mon,  1 Jun 2020 08:59:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Jun 2020 08:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=TtufirPfAlwtsi/lMsOIpkLe1a0WGgVE+djF/ZRXPqs=; b=wppzBLTp
        VX0l2POvdP+5PTua0389W4ZWQpiLFs33Z8/ypxscfEKYt08UyAVVTyPlDYN4Yq4V
        t4eSFauHFJb5CFAGQk5pxxQH8yd1mokMcToi/RCVoDuHNud/ksKbVdlPh0cbWReB
        zx7/RS+0QLaX12FWTrDAgSILT1D+pBez7Mn5NyyHyJCwdcfqLLVIryza6Uy7kEio
        VREEGBDq+0XFXKBlngREKDp7dsyA/lweFiOoYVOuB8XoVm318wRofCcZZM2uBDN0
        p7k2DDbCzCBS8wm5simBTyBCaJYz/q19Hv1INUaaHxpjmtlWDAO1VtQG+xWQqKrM
        66weqNrrYClDxA==
X-ME-Sender: <xms:svvUXrajsQKrlNGGzI1BieiMFdgiu_FpkxwNpUDg79UFZo0Nu1ASyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepteetjeffgeeljeduffelfffhheeule
    eltdejvdevgfeuleffvedvteeiteefhfehnecuffhomhgrihhnpehivghtfhdrohhrghen
    ucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:svvUXqZUdsaMJ0Ed7EQdubDWW61O1wjgaS0KEHAXNAlCgkjy-9aTSQ>
    <xmx:svvUXt-G18TNSk1Bht_qo42Lfzth1o9CzT6JA0iRZipgApht1r02_w>
    <xmx:svvUXhozaG_06Ya_cM-mX1U4uO8JFxDWh0oSIba9ohRl1x0OLqpEHg>
    <xmx:svvUXjBZvtMxNFAVlmLMJuBKh-2IZfxLwcDV9jr_eRtA5ZScMo3BjQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED1EF328005A;
        Mon,  1 Jun 2020 08:59:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, dlstevens@us.ibm.com,
        allas@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] bridge: Avoid infinite loop when suppressing NS messages with invalid options
Date:   Mon,  1 Jun 2020 15:58:54 +0300
Message-Id: <20200601125855.1751343-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601125855.1751343-1-idosch@idosch.org>
References: <20200601125855.1751343-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When neighbor suppression is enabled the bridge device might reply to
Neighbor Solicitation (NS) messages on behalf of remote hosts.

In case the NS message includes the "Source link-layer address" option
[1], the bridge device will use the specified address as the link-layer
destination address in its reply.

To avoid an infinite loop, break out of the options parsing loop when
encountering an option with length zero and disregard the NS message.

This is consistent with the IPv6 ndisc code and RFC 4886 which states
that "Nodes MUST silently discard an ND packet that contains an option
with length zero" [2].

[1] https://tools.ietf.org/html/rfc4861#section-4.3
[2] https://tools.ietf.org/html/rfc4861#section-4.6

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alla Segal <allas@mellanox.com>
Tested-by: Alla Segal <allas@mellanox.com>
---
 net/bridge/br_arp_nd_proxy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 37908561a64b..b18cdf03edb3 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -276,6 +276,10 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	ns_olen = request->len - (skb_network_offset(request) +
 				  sizeof(struct ipv6hdr)) - sizeof(*ns);
 	for (i = 0; i < ns_olen - 1; i += (ns->opt[i + 1] << 3)) {
+		if (!ns->opt[i + 1]) {
+			kfree_skb(reply);
+			return;
+		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
 			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;
-- 
2.26.2

