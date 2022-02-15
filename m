Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981624B77FB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbiBORCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242105AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84907119F32
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IESjTV0ImMNwX9Aex8ZXw0LJhpYCyzQatLB082wvGn101dUKQGPFIr9Q2Z2LxLS2pvQX7laxtFSh1IQWPkJ4tOFUkP39RzBHooIvh5gNtchb4FJO/XhUOnsHWLRl4UJ+452Np4CKKk552BW+RP55K/DedpNKughzHx751EZK5jKyg6oMBYQuIsNiPispBH1CJlCV4Msv3IqLYQbHKpdAKEScCgxbGLl4XIotgtxMQJU1H/0yhi7+RzfnDxqpj1qO30HwY3Jgq9VXOEir89NjyEDIff4740SsWruZbt/lXt5Ut8Va3b7mwIJtxM6GmJyWEt21qx3725lgDpQOIq00gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzXYeFKepwFsGZp5HSiP2ewosXhoLsI6Hs+5v8mCWuU=;
 b=H5EHeBW5XHZzp2qLoZt2zZSi0/zDleYFo6Yxkq51EPUtCBi5EemcgzJoB70WGNNOivwsAvdzyhhtovo7TFqRb2gzjiPM6sgelnI/lUHoJg7L78SniPmAyFHAvuoVd+CpZpQmOTA+3nUCpcvw+nJgASM6OFSe/TfkG8p1JJcL42S0eD6E33FlZzkFRq/Ff5N43Ik1ZZaVvfVHjSG6/TPE1EcO/ZP3armQ4icEPBX406L6m82EN4PVRzdgA5W6Fqdqr7TyTAsPbhUeWPsgvmBQNTHazwXqL/PWb+fPXFs8tUn1Lc6kpKJa4DkxZnBWZ6c8te80QOusmpN+P0E4VBtiKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzXYeFKepwFsGZp5HSiP2ewosXhoLsI6Hs+5v8mCWuU=;
 b=Lc+xbpBBdaeGKQVo0CsRm6ltEnC+aGL5FXtzCwdxlGRLX8Qf+L9fWScezZaPCicjDuXKhebvUGSPzUye7v1qa+GhKUTDoKlFcXFQqo8NgJCgFMIo+PqO55jE2SDRt8Ji+9L2mKeFmVXi5Qg6OpTJuJ8VxWq/VWzpQnJYbkpecto=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 04/11] net: bridge: vlan: notify switchdev only when something changed
Date:   Tue, 15 Feb 2022 19:02:11 +0200
Message-Id: <20220215170218.2032432-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a5071e6-bccf-4227-f2b0-08d9f0a4f32f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB53425F300DC943651BBD4135E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZYTgip9hgw13O3iUtcaEDvsOoj7KzD5/z9PT/WV3U+ZV8NoYGqt+cX97tmYOGnF/+URLXGWyrljhY3BuibtYx/IcJEOXTbABXsOGwk3o5aE2aY1fDQfIfEhTxT2PwuPILtRu/ljrCoa8ZhfACxrQjtw03nZXD/1tMOf1OAG0KESlHX80ZKUlD4IdS96yDcS8EZiCn03jKWUMtBe0jdhcO97+yro18ENEBydRwgcu6dfhLvC1ttzJH8LmYeFnCzyK6hrxKiZlLOjsETQE0MiUxLwv5YRBg5WNFdxV7SHFcem8jKD7YqAiUpiuEhgOGfL4bo2zW+zMSwmADj3Bqk28VYoUJeHQDrT1bQ3lKqbsJOEUUVR4GQpG2jHO9w3WEfuWNIvaDckHmxye0xB0P6FG3fx6Mu9LY+h2ICIspqyHI8rGllqt0Si4cymzjqy7moJk3SHEkk/yoeaD0fY9pSTCdIbmIrClIUyum2vL8OLb9ceTr3sDkd2EIDIlvVnTZ/reFxIuT2+9ggddzP4UItBd7vRJulr4RW7Zx8VMcQQ3SSCXopk4RGn6RV9QK/A+VUDdhj5CQjKGeJ2aUBUCLVtmYf2k2aDQD/dWLQOewImjFvOz704+1kMpoWYCLhkUN2P1x7IYLU1jGgymIqG9ZJW5qeB3cZs8QXI51ZWZl2QWGmzLdeGKRlXW1WE9GgguvLIWL5T1O1ErGsAMHsVbqi28w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yRyafyBLb/G1GuKNuIFDsFHz/Z0t+jHhVNDSzAyRZtTqUtNyG2USrjHFHaxX?=
 =?us-ascii?Q?YWJCFJ151cJ77rKXjaBRQoW6MdQF8T8ZkHb4qA4URCEwcZuepLAVOcmSdmPG?=
 =?us-ascii?Q?Tmg3CEZ6hKwaoje8MJsHVynB6Yug8/rbJwccO9tB08R3s+5N+v9DbLw4yW5r?=
 =?us-ascii?Q?eCJ4TRdK87rRAID0S5b7XiRgZ5V45hHQp//9wsl1AU+TcOnrfyEj0UFhKqNM?=
 =?us-ascii?Q?OeyuiKk6BvNgRHwsibJt1iTA6QDq9lt+UdMTeilQCBwBlbNypGra8SMpPsX2?=
 =?us-ascii?Q?u4NL4hsrKvqwADZtZeVP/CyU9S7ygRvGjmZnQtGtJcXGFwSGSlwvXonSf2aS?=
 =?us-ascii?Q?j7oZ7eI0YyuTBpVmgxvWuuemXZaFJrWrK1eLAay/+QYPdhZIjHc4WFPgu9Co?=
 =?us-ascii?Q?MySh3+WtgMM3v4GpnqiT/1nzFRcqaRyc4Ks071moBQx9e6QlmHhVtuh/YVSw?=
 =?us-ascii?Q?MjDGsBvswRvRlmZGtfnIEzf8wFsQOf5RWWtktxe0QkKKYBux9+eFpNVH6xzM?=
 =?us-ascii?Q?Ob9RULnGPMaWyb8TgMC//XScLVilbm/SWZSCTiZa1k5Jg9jsxxkpQ0n+5lF6?=
 =?us-ascii?Q?J+C0OCCYxMbBg7u1xfX8+8tQb+9RLigdraZT+EFMubd6lRoActZLPaC3koaB?=
 =?us-ascii?Q?NmIOUozwMAXcwJxr/F93swCag5zpwE6h5RFV9seAyzDl2AatNB7hPsZZlQRp?=
 =?us-ascii?Q?3Lcb5l3lcCxwA2B9TwmkVAz15kfMjUQEswy2jjYAR46GuxGKmRaD3dYHe79V?=
 =?us-ascii?Q?a1yXIWzsfgFY5RjMXrx8M9vBkd4FlfiTFy35W+E2jirlpqSi/cXt0UEVppMZ?=
 =?us-ascii?Q?5VbZIsEwn44MjYNqRwElNthtK855djzj1QUv6OuHtyYOSlGaLk3uC74PZf1N?=
 =?us-ascii?Q?lEQF7WoVS56+OfX3NQhBwdiJywfwvAB3iwzIzK3TcrJg2S0CwyA9IxcPAhw2?=
 =?us-ascii?Q?RqaRcz/KwAc0ixXkMqahDHiwP/dv6+tljyc29UFqPnypyHRq1v8Ne5fdaL+M?=
 =?us-ascii?Q?1SPYs3CvgPJrTmSIInHpYZ1jc3X/FB9sL1jGI6dgiuo1mooLBfFUSBtnrwit?=
 =?us-ascii?Q?nRKA3/JA/9UNOY9oQip8o+6o9qwRKT0ET84kYgtNjrbcjDW0nx/6QhMMd6jA?=
 =?us-ascii?Q?Do3w1wS/7bzqpqQ5zfP6DnJMelF6ZUYEK2b41sYZDF68uqmcH82UPdqq5MoN?=
 =?us-ascii?Q?3qVb33ZuEGMGVNmEgbbKq9Wbgs5Rg2EnYet+38Lgvrwed5nUbwBO6FI3/L1S?=
 =?us-ascii?Q?28rjveavBxM7Fsabn6DculuPsAgvmdenJf19Phgfen3dLhUPiLtbp9xAKXbY?=
 =?us-ascii?Q?Ck2Zc42q0UHi2NVmQW0XDBJLEavdXFTFJWWGhApAdRY7qznIXN49eC+sP9f5?=
 =?us-ascii?Q?0gwQPHenAreOcr9CK89N6CkdoupvIcscUfPn7cqVHLqLLFV2nqiCJXO9V7a6?=
 =?us-ascii?Q?SJLN1eztibCgrVsNDN9BivV9SOh8QSG85Y6B/ZwpHa8rQSTCDwwttOxi6bn0?=
 =?us-ascii?Q?NmBQgIUIauewkiDXgBXCS1dtCPa+35B7GARxr0PXVa3bPWVdzcLS51OqL6jr?=
 =?us-ascii?Q?2NZhc54E7naH7vLA9DahNTcmaRe1zEmVlV+q0eUK/M0+fMEqkyHBlZ9WCgTR?=
 =?us-ascii?Q?mhnn1LgoUU7Z5gx3p7zwQm4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5071e6-bccf-4227-f2b0-08d9f0a4f32f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:29.6819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYOc7OEgiVVAvcg4jtFZXzIHvJ9XrYCiISasvLl2FzAQOaXK4B1NI6byo47UdmAN6KvXlo+UcuUqg9fNpAG69A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a VLAN entry is added multiple times in a row to a
bridge port, nbp_vlan_add() calls br_switchdev_port_vlan_add() each
time, even if the VLAN already exists and nothing about it has changed:

bridge vlan add dev lan12 vid 100 master static

Similarly, when a VLAN is added multiple times in a row to a bridge,
br_vlan_add_existing() doesn't filter at all the calls to
br_switchdev_port_vlan_add():

bridge vlan add dev br0 vid 100 self

This behavior makes driver-level accounting of VLANs impossible, since
it is enough for a single deletion event to remove a VLAN, but the
addition event can be emitted an unlimited number of times.

The cause for this can be identified as follows: we rely on
__vlan_add_flags() to retroactively tell us whether it has changed
anything about the VLAN flags or VLAN group pvid. So we'd first have to
call __vlan_add_flags() before calling br_switchdev_port_vlan_add(), in
order to have access to the "bool *changed" information. But we don't
want to change the event ordering, because we'd have to revert the
struct net_bridge_vlan changes we've made if switchdev returns an error.

So to solve this, we need another function that tells us whether any
change is going to occur in the VLAN or VLAN group, _prior_ to calling
__vlan_add_flags().

Split __vlan_add_flags() into a precommit and a commit stage, and rename
it to __vlan_flags_update(). The precommit stage,
__vlan_flags_would_change(), will determine whether there is any reason
to notify switchdev due to a change of flags (note: the BRENTRY flag
transition from false to true is treated separately: as a new switchdev
entry, because we skipped notifying the master VLAN when it wasn't a
brentry yet, and therefore not as a change of flags).

With this lookahead/precommit function in place, we can avoid notifying
switchdev if nothing changed for the VLAN and VLAN group.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- create precommit and commit wrappers around __vlan_add_flags().
- special-case the BRENTRY transition from false to true, instead of
  treating it as a change of flags and letting drivers figure out that
  it really isn't.
- avoid setting *changed unless we know that functions will not error
  out later.

v1->v2:
- drop the br_vlan_restore_existing() approach, just figure out ahead of
  time what will change.

 net/bridge/br_vlan.c | 95 ++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 89e2cfed7bdb..990fe0db476d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -34,55 +34,70 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rhashtable *tbl, u16 vid)
 	return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
 }
 
-static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
+static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
 			    const struct net_bridge_vlan *v)
 {
 	if (vg->pvid == v->vid)
-		return false;
+		return;
 
 	smp_wmb();
 	br_vlan_set_pvid_state(vg, v->state);
 	vg->pvid = v->vid;
-
-	return true;
 }
 
-static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
+static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
 {
 	if (vg->pvid != vid)
-		return false;
+		return;
 
 	smp_wmb();
 	vg->pvid = 0;
-
-	return true;
 }
 
-/* Returns true if the BRIDGE_VLAN_INFO_PVID and BRIDGE_VLAN_INFO_UNTAGGED bits
- * of @flags produced any change onto @v, false otherwise
+/* Update the BRIDGE_VLAN_INFO_PVID and BRIDGE_VLAN_INFO_UNTAGGED flags of @v.
+ * If @commit is false, return just whether the BRIDGE_VLAN_INFO_PVID and
+ * BRIDGE_VLAN_INFO_UNTAGGED bits of @flags would produce any change onto @v.
  */
-static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
+static bool __vlan_flags_update(struct net_bridge_vlan *v, u16 flags,
+				bool commit)
 {
 	struct net_bridge_vlan_group *vg;
-	u16 old_flags = v->flags;
-	bool ret;
+	bool change;
 
 	if (br_vlan_is_master(v))
 		vg = br_vlan_group(v->br);
 	else
 		vg = nbp_vlan_group(v->port);
 
+	/* check if anything would be changed on commit */
+	change = !!(flags & BRIDGE_VLAN_INFO_PVID) == !!(vg->pvid != v->vid) ||
+		 ((flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED);
+
+	if (!commit)
+		goto out;
+
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ret = __vlan_add_pvid(vg, v);
+		__vlan_add_pvid(vg, v);
 	else
-		ret = __vlan_delete_pvid(vg, v->vid);
+		__vlan_delete_pvid(vg, v->vid);
 
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
 		v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 	else
 		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
 
-	return ret || !!((old_flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED);
+out:
+	return change;
+}
+
+static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
+{
+	return __vlan_flags_update(v, flags, false);
+}
+
+static void __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
+{
+	__vlan_flags_update(v, flags, true);
 }
 
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
@@ -315,7 +330,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		goto out_fdb_insert;
 
 	__vlan_add_list(v);
-	__vlan_add_flags(v, flags);
+	__vlan_flags_commit(v, flags);
 	br_multicast_toggle_one_vlan(v, true);
 
 	if (p)
@@ -675,17 +690,29 @@ static int br_vlan_add_existing(struct net_bridge *br,
 				u16 flags, bool *changed,
 				struct netlink_ext_ack *extack)
 {
+	bool would_change = __vlan_flags_would_change(vlan, flags);
+	bool becomes_brentry = false;
 	int err;
 
-	/* Trying to change flags of non-existent bridge vlan */
-	if (!br_vlan_is_brentry(vlan) && !(flags & BRIDGE_VLAN_INFO_BRENTRY))
-		return -EINVAL;
+	if (!br_vlan_is_brentry(vlan)) {
+		/* Trying to change flags of non-existent bridge vlan */
+		if (!(flags & BRIDGE_VLAN_INFO_BRENTRY))
+			return -EINVAL;
 
-	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+		becomes_brentry = true;
+	}
 
-	if (!br_vlan_is_brentry(vlan)) {
+	/* Master VLANs that aren't brentries weren't notified before,
+	 * time to notify them now.
+	 */
+	if (becomes_brentry || would_change) {
+		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
+						 extack);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	if (becomes_brentry) {
 		/* It was only kept for port vlans, now make it real */
 		err = br_fdb_add_local(br, NULL, br->dev->dev_addr, vlan->vid);
 		if (err) {
@@ -700,7 +727,8 @@ static int br_vlan_add_existing(struct net_bridge *br,
 		br_multicast_toggle_one_vlan(vlan, true);
 	}
 
-	if (__vlan_add_flags(vlan, flags))
+	__vlan_flags_commit(vlan, flags);
+	if (would_change)
 		*changed = true;
 
 	return 0;
@@ -1250,11 +1278,18 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 	*changed = false;
 	vlan = br_vlan_find(nbp_vlan_group(port), vid);
 	if (vlan) {
-		/* Pass the flags to the hardware bridge */
-		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
-		if (ret && ret != -EOPNOTSUPP)
-			return ret;
-		*changed = __vlan_add_flags(vlan, flags);
+		bool would_change = __vlan_flags_would_change(vlan, flags);
+
+		if (would_change) {
+			/* Pass the flags to the hardware bridge */
+			ret = br_switchdev_port_vlan_add(port->dev, vid,
+							 flags, extack);
+			if (ret && ret != -EOPNOTSUPP)
+				return ret;
+		}
+
+		__vlan_flags_commit(vlan, flags);
+		*changed = would_change;
 
 		return 0;
 	}
-- 
2.25.1

