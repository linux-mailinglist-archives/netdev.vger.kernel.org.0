Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7339F52FFA3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346981AbiEUViT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346669AbiEUViF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:05 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6007A527F0
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4R0lJFMJa/W/cn60w6wH/xcInSuyK8n4rVRFHoTHHVlWK0+TDJI+b+Cgn9cjjbEKOwpy/irEmbDdoO1t+p7gaQ15paTgDhYcHPFAvAKwNcmrGWsK23IWKeEs9795la5+K7FkRhTUMLYgkDtsa3rmcn+GNJjiqxM51d4oO0vbDMl9GgrKK5JuhegAjvrrhXDhdacT0qhZDXCvFmv8BnCPDxI1kbxvOYq/HVZIo6CSUB7yDxRpvxkZ2FqFi278n1EATcexXcu35NGtFSf4q5IRIGjsnSsRHqlkZvlw9Wgd62ipCPwJxY/BXNN39fUnjJ0pWuPBmbcPEMvt2nH/LgrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX05ylXEkLGh9XCM77Hye08h/qx97TYDeNAuvyPtAOA=;
 b=cSjyuwkzEefsTuf4ZBZiI5hNDy50hZ1PR1tTBe3pz/XRrBv2IpYHoOaAyiZAIc/LelsfeySRbLWNdrtro3mpwDZawXaIOIYbG42zhsB7v8I1AI3sD41P2B2tI39l4RGT6dQkp/NbtfcwbPCyWhM8GkE/vKLqFz/BCQCMljkQlmyoVvJZsM2l8X2YzCARhbvmIezpYLM/Z799A086/ZevbGWdP8VssYWlG0kmML58gufnmrOlFfxULxwAngdHBJJSqoTH6G7htIH0yHkErmTcO6TJULQK85DqY4oO0W7oKQkDKp1dy35lF9ACK1ZfURmuhIVTcouC/0n9kzJ1IyqASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX05ylXEkLGh9XCM77Hye08h/qx97TYDeNAuvyPtAOA=;
 b=KE9qa0iX2niFmQ0kiih7ifju1g41WJCB4VsdboWg41kzED0kgVtY3J9CQA5iLzo7e3BGjrxTxz7GYgO1LKO4Qt/tRBBknLCZYRFCm00y7K85wjucin34rh2rpcxtrP9RR+zyqSz+4hnaIFAnWZFeB+aH8EZE4gvEIFug3MQLMRA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:38:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:38:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 3/6] net: dsa: felix: update bridge fwd mask from ocelot lib when changing tag_8021q CPU
Date:   Sun, 22 May 2022 00:37:40 +0300
Message-Id: <20220521213743.2735445-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd8ee22d-e5e8-469d-e84a-08da3b722e6e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6275EB5ACBB9B6AC550B0BD3E0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EaC7MWkYzH5rYd4nHO9Cmu94BE+fdojpkyGltyoEIBKG2mLn1pRM0WxOiwBjSEhFggBP0RrSR3dynycHUiKZaQsj8GGS50uScY5WyjD5vrnEjSYKucmauCsfcxw0bDRbDDyRIzHD/QxiL/YnHwPMjRyrWs5fgO2xN0eRwJX3PDfZBYEvt4kWBaxDGR3X6uc99uCi5xI6BMbqv28CEu6rxTnMEjmzNYsij634pRJKvGf2dg6E2dbsmXP4sXK21LJJSnOZZv3saqWPiA/2lM/4V8b6l/zlmPbwucUhPZ0b705Z4qcJpFqUSJ+TEWlwCgnAPHtkf7mVY+7q0h5d7W2apAg0JLp9BiqoDY1ZoT5NCqz3t4vbe8iw6jtd1kZ+h4PFTrmrrXMZxFaIu8jhutf+HGkbsNn1GPmBud0IXtwnvwVdpsDbSm4G84Gi+JzRrw7hLGC0C/txTPuPKtFi7XhLJcw+/0ZlxNtgCYWRrQfGT+dBt9b7Rmeba2285I2FxW2owckaPBuPWf6sdqtLe79UKAViqBVklmRNbo1AdNLuesw53pO5Zi7/DVc50Jy168jAGuU9EuoT4oIh2qytFo274PKzaKr4/ErSZEIdk5756hvdFByGdUDQ+CIsx1h4tmEtiLaELhULnk6GxLX4SQvL0xkxthCForib8oN3MG+fFx20IDRqPumHOwpqHCANSBtzZ3tmv/l0lZDKNv1Yp4aE5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(15650500001)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cS7XLiGka1OmZGJg5Urh2F2tyK7nvJDZTpOQ/QG3L+fg9B5KbAO4y5naqiOA?=
 =?us-ascii?Q?CojYSFhzIvoBTSueUmn6QxXBb/ssgsqZIgv/4qfEh2x3tfo+/D823RP82voC?=
 =?us-ascii?Q?R+VmslOsiJauLSeCgBHmWOmpFNrY0+dynngJeEyRwb/wGdiw4TLz5Exl6x05?=
 =?us-ascii?Q?2jSgIn+6HVy4d8GqhOEvNmQVJpxN0ZWA+7NjCk+jH1n6fBlhJ0Vb9HU9xjpt?=
 =?us-ascii?Q?sMHrkcG/TY+4jP6NREz5QOtXMW88PKtO8J4MnSfx6vjszJVFeHmrYolzueGa?=
 =?us-ascii?Q?xEZC2Z/ccfUulOfVaiiye3ULXJrW4DP5D+/JaL06PfzRnJfWAR+BpHVl612c?=
 =?us-ascii?Q?U1Ag7dUQDbmOLTO4SsaCGQrML0ZIW74u8ro4McXh7oW6//M522insRuqZDz4?=
 =?us-ascii?Q?hd9spEWOh4+2Zw/jVUPLOCvmIlYLBvzZGRoKSEa5UD2Fuui4g+AOQIzgtQ96?=
 =?us-ascii?Q?Acc03DPK3YMyM4oRsnCEXbYNwf1I4pzOJLxjIfbf0l64BnXiSa9/UKS1qnJz?=
 =?us-ascii?Q?QvIR6DpGLxVAXzST8DUzzPTVnZQbiDR3NvRhm9uWMXYTTNYXuFic4y8MLhQJ?=
 =?us-ascii?Q?Ol5CsNq2vBnk8jrVkRN88j7yLmpw65RPqI/p1c5IU4Q3LMKCYwPIXTM/B17A?=
 =?us-ascii?Q?xMzM0kkP9RVyV2SPGq8HJrj+NCsWaUUsUOdxRVcpgLJqvUsGbMpv/iwiyRD7?=
 =?us-ascii?Q?AyITLgjEi03JJr5V9Vlc4MfFPMgWj4ZaAYNxFuf9k7q6Vp/Nvsl6LFWe19Az?=
 =?us-ascii?Q?NvDAkSdCHNR7AkiKThmdL1eVFFZb6KoII7T3qAleFCRuj54wTEfwIf2qclUQ?=
 =?us-ascii?Q?lJXUrtRzjOc71rBxIZOKpR4NAIzpo/IfepivbPZR5VQeuMl42xtBtsTU2LSu?=
 =?us-ascii?Q?ERPFOuqHBxM4XIzvoNIRRUavKZK3oMQE5PS84+VoPivWQ2vKk3tRdjLX2LeL?=
 =?us-ascii?Q?XfpuHjfM+t1MUbDvKqflCj26+AyzgNVsCfuw8Ha+mnuO02STP952lblBjnsm?=
 =?us-ascii?Q?tL1DyrxVzCiViNRl/ISb/ICJesuOTqsvyC3BKcs3j2ZD/ZzqFmSJLvG9avPV?=
 =?us-ascii?Q?cOmj+VLdb0RqATZrHfmtIS5folhMOCpB6TkRjPqFpONt/7c0hU8jNjJGAD5G?=
 =?us-ascii?Q?CnwSt37P9iK6pf0gtkE0VU054vneu2aReQ/wOrFUUKf3loBOJM5cTUp1WYNU?=
 =?us-ascii?Q?/J+WaF6WP+MtuBF2NvuGEFZEgD9VI4y7HHHawJ229eRazjchxeCQsMFsoZn7?=
 =?us-ascii?Q?V8nsGqoqGn/AmEiUk/wlDMSN3e5WnsNAHXDDKpEgmrKiCp0ShwsHAEj7U/oa?=
 =?us-ascii?Q?0QDUGdCIsLolvEAWigE6ppaCPpQdb/BdmZ9sGAMT26mGxiJUc+FqH6fK3VfI?=
 =?us-ascii?Q?/GZiT2ueYiEmlH5KN28R3DblosZI7jmVrUGMwjIuoZlcbOAGh4bp9P3yaBbJ?=
 =?us-ascii?Q?kdv0ObXtELKQ2KHEF7LHup95XjsW4t8EB0lpSoBsRu0d1BPvcgXx0kN9HPPk?=
 =?us-ascii?Q?7XS1hviqP0cQaGb/y89+5z2KlxAaa1iYCh5J9hgIMfOkcr1d8+3Xcf2jGmui?=
 =?us-ascii?Q?vD/V1sx9qODWisSuBJIwPYrl3Q1Y+fc5LaPppy5GWeBdiURJ9NuPfhoYnK+a?=
 =?us-ascii?Q?VmPPIP/sWoYlnXEOcgCabuCm+I3IwcEMg5kOGLK+V670vTx7y12/qRUQGZY6?=
 =?us-ascii?Q?yqyTQcZ9Vd1wCO0uo627/q+Et8wkjwguWttc0/Y+F6WtvBzKog9ZyokyLZxW?=
 =?us-ascii?Q?mZHcQrmyURnzbdmuVBmF+p4SbfC6508=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8ee22d-e5e8-469d-e84a-08da3b722e6e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:38:01.9239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGk2qfgkuWvLnEn4hIELB7DzGdd3LUR4QcGaraomE0m407Mp7z3Xs7cJknUeKRv/0B0nTtkT+kQynISB5cr6Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more logic to ocelot_port_{,un}set_dsa_8021q_cpu() from the ocelot
switch lib by encapsulating the ocelot_apply_bridge_fwd_mask() call that
felix used to have.

This is necessary because the CPU port change procedure will also need
to do this, and it's good to reduce code duplication by having an entry
point in the ocelot switch lib that does all that is needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 4 ----
 drivers/net/ethernet/mscc/ocelot.c | 7 +++++--
 include/soc/mscc/ocelot.h          | 1 -
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1299f6a8ac5b..b60d6e7295e1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -253,8 +253,6 @@ static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 
 	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
 
-	ocelot_apply_bridge_fwd_mask(ocelot, true);
-
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
@@ -264,8 +262,6 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 
 	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
 
-	ocelot_apply_bridge_fwd_mask(ocelot, true);
-
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ac9faf1923c5..4011a7968be5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2094,7 +2094,7 @@ u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL_GPL(ocelot_get_dsa_8021q_cpu_mask);
 
-void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
+static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 {
 	unsigned long cpu_fwd_mask;
 	int port;
@@ -2163,7 +2163,6 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 	if (!joining && ocelot->ops->cut_through_fwd)
 		ocelot->ops->cut_through_fwd(ocelot);
 }
-EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 /* Update PGID_CPU which is the destination port mask used for whitelisting
  * unicast addresses filtered towards the host. In the normal and NPI modes,
@@ -2202,6 +2201,8 @@ void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 		ocelot_vlan_member_add(ocelot, port, vid, true);
 
 	ocelot_update_pgid_cpu(ocelot);
+
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
 
@@ -2215,6 +2216,8 @@ void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 		ocelot_vlan_member_del(ocelot, port, vid);
 
 	ocelot_update_pgid_cpu(ocelot);
+
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3b8c5a54fb00..2c90a24ca064 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -880,7 +880,6 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot);
 u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port);
-void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining);
 int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
-- 
2.25.1

