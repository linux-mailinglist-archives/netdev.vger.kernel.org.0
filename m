Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F281C06A0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3TjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:39:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34873 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgD3TjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:39:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E4A25C00A6;
        Thu, 30 Apr 2020 15:39:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 15:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8Ws9ps3lVg7IhWMNT
        naQ/4aJYXRu9Os3jYNOpTZ6jvA=; b=v99v1/6soCGfESBw9ZMkohNduywqGF+F6
        ckTokBbPqazQ/k3wQjp2vnp1jEZr4m91K3UfXV3S4rR/u+fJNDTiW1iq4KxBvv3X
        bKKZhrZfLxnNq+Sj0S++HH6YrUgfE3l/Zbb8hAPFoIm04R6hNykmMnOp7WNGzlU5
        XXbaW5QCYH0NGuFrBtj6PKS9Pm5gG9czOlgYZ/NTgLEqG7wdtr6ziupTb+VdbDzM
        whemRMhBXLdPmItICFUesqxIldjOhxLzqmbn/aUO2nWBIZChJd1icoVH8hUKe1ME
        HqKevSt3LbWSYLjyHm0twnECLH1y3irIBA3tu0L+zSBoK3O5LOpoQ==
X-ME-Sender: <xms:ZimrXrrTFgoolFxSyIqIy0My11wJva-iEf_-WHAkSo9ZmceZUcK9Vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudektddrheegrdduudeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZimrXo5K531afULx2976cWxOFdXvGa_xPcq6Uxj1dkXUVDQNLyVvLA>
    <xmx:ZimrXhrWKDA7Vl2Xzt9jshTwy_gq22BaqZFlLcmfu6wWGbImKg9bvg>
    <xmx:ZimrXqgAGIip1LiU7kkxYOtXPIABlPIOQeF2ztO2SZwVPWOSaoxoBA>
    <xmx:ZymrXjhdSpEvCPDJu3dTD0UobX1I6UqIack_CfyBiXURYY7I7-LLvQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id E299F3065F40;
        Thu, 30 Apr 2020 15:39:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, s.priebe@profihost.ag,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] net: bridge: vlan: Add a schedule point during VLAN processing
Date:   Thu, 30 Apr 2020 22:38:45 +0300
Message-Id: <20200430193845.4087868-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

User space can request to delete a range of VLANs from a bridge slave in
one netlink request. For each deleted VLAN the FDB needs to be traversed
in order to flush all the affected entries.

If a large range of VLANs is deleted and the number of FDB entries is
large or the FDB lock is contented, it is possible for the kernel to
loop through the deleted VLANs for a long time. In case preemption is
disabled, this can result in a soft lockup.

Fix this by adding a schedule point after each VLAN is deleted to yield
the CPU, if needed. This is safe because the VLANs are traversed in
process context.

Fixes: bdced7ef7838 ("bridge: support for multiple vlans and vlan ranges in setlink and dellink requests")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
---
 net/bridge/br_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 43dab4066f91..a0f5dbee8f9c 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -612,6 +612,7 @@ int br_process_vlan_info(struct net_bridge *br,
 					       v - 1, rtm_cmd);
 				v_change_start = 0;
 			}
+			cond_resched();
 		}
 		/* v_change_start is set only if the last/whole range changed */
 		if (v_change_start)
-- 
2.24.1

