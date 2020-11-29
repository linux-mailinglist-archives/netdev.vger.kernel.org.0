Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0942C792D
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbgK2M4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:56:39 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57233 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387444AbgK2M4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 07:56:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 93C3B5806E2;
        Sun, 29 Nov 2020 07:54:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Nov 2020 07:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=iWTDhUIR4ugGXK7WcUprQ8CylzWjyKf/EccpaE0QNXU=; b=aOJcJysB
        Jr0FQ+USbbYun2NZfGWT3Rve3gFGDL9KLQm9Crwt0jxHtws0NCU+ZuAfPswYayZS
        sY9d4RhTjm0HrV+FkknLVbPkSvHwNv9ARJQaljfgWlpjrO6l9Vudqrq3l6u1/Foz
        uncZU/xFvTqk92VQT4sbosTFYCVRHsPCJvwVWkE+rSkOP8cCMuPVW4xWJdectBJI
        x+FUu6zI8xO1Fn0hUUB2y4ea9RdqXOpTnfwWcaeYTnzL2fBrhcN1tz4TUNePk0cb
        4BZavA10ImfOgwkMSPollAwQmTarxZ4tyaNHg/++0kCvVXsdyd6/ZTf7jmxWRQrM
        Yg2EA7nEVEvAbA==
X-ME-Sender: <xms:H5rDXxqyEuA25ETcuoSL3XWtcVYHkqLpLvvtmkHaAC51YsdjK_WB7w>
    <xme:H5rDXzpN5zcGXqIEQJTIj4fmJnS3sAFAqsd_G1hZ4SZprn-6dWYgSN9t0Sz9NM74j
    B1WvKrbUX_6OCc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:H5rDX-NVthEdyt8T7KOm7ga0tfRf5YbeEJDmsYIa8-PPbsNUMdZ-Kw>
    <xmx:H5rDX87v86eERFK8_hNfHoPrQ_jp9YHTW2cR3BXw7AsjVQ62z1GKDA>
    <xmx:H5rDXw7ze54catU413eWmtv1Qcc0X139IcZF4esYCeuwASpeQqvgNg>
    <xmx:H5rDXxGgPJNUfTpe6AWTCrLFV9cL7DRyUBRt-s-v543mJ7IIc3iF-Q>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7701D3064AAA;
        Sun, 29 Nov 2020 07:54:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] bridge: switchdev: Notify about VLAN protocol changes
Date:   Sun, 29 Nov 2020 14:54:05 +0200
Message-Id: <20201129125407.1391557-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201129125407.1391557-1-idosch@idosch.org>
References: <20201129125407.1391557-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Drivers that support bridge offload need to be notified about changes to
the bridge's VLAN protocol so that they could react accordingly and
potentially veto the change.

Add a new switchdev attribute to communicate the change to drivers.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/switchdev.h |  2 ++
 net/bridge/br_vlan.c    | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 53e8b4994296..99cd538d6519 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -38,6 +38,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_PORT_MROUTER,
 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
+	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
@@ -58,6 +59,7 @@ struct switchdev_attr {
 		bool mrouter;				/* PORT_MROUTER */
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
+		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 		u8 mrp_port_state;			/* MRP_PORT_STATE */
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 11f54a7c0d1d..d07008678d32 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -854,15 +854,25 @@ EXPORT_SYMBOL_GPL(br_vlan_get_proto);
 
 int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 {
+	struct switchdev_attr attr = {
+		.orig_dev = br->dev,
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
+		.flags = SWITCHDEV_F_SKIP_EOPNOTSUPP,
+		.u.vlan_protocol = ntohs(proto),
+	};
 	int err = 0;
 	struct net_bridge_port *p;
 	struct net_bridge_vlan *vlan;
 	struct net_bridge_vlan_group *vg;
-	__be16 oldproto;
+	__be16 oldproto = br->vlan_proto;
 
 	if (br->vlan_proto == proto)
 		return 0;
 
+	err = switchdev_port_attr_set(br->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	/* Add VLANs for the new proto to the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
@@ -873,7 +883,6 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 		}
 	}
 
-	oldproto = br->vlan_proto;
 	br->vlan_proto = proto;
 
 	recalculate_group_addr(br);
@@ -889,6 +898,9 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 	return 0;
 
 err_filt:
+	attr.u.vlan_protocol = ntohs(oldproto);
+	switchdev_port_attr_set(br->dev, &attr);
+
 	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
 		vlan_vid_del(p->dev, proto, vlan->vid);
 
-- 
2.28.0

