Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6C7515903
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381781AbiD2Xe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358365AbiD2Xe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:34:26 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2109.outbound.protection.outlook.com [40.107.101.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDD3B0D20;
        Fri, 29 Apr 2022 16:31:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+6hI6Xn4JTbsqCZ1MFXK7CCu/0f8GFtjWLTKHHD0fARYAPgR2EUtdXt/l56z4pF7iXzFUEgW+H3CgKPq22Y7uFxZZ0YhXLdqpUZhcFMaMxG0ivY67l1RsYlQvb95hAwWTaa+5zxGKV3b49jJW3HdKfDrmbBz3KGYbQzp9Hns0GzIWKvhwjSvyCRjHLXtZzoixD2elzDWgtNICV5/vQSDwSX5H6e050rkWLpbOt/onGdTK35dPlNHgVkyMsNk5CPGhR5IiEt3zVM4JFqt0VHC7LeLHKqApfC2xSTcwcB+3sWROK82l5vlCF4ortN0F9sKSkH/fO7GNMgMwXaU485RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRsb6dJVe4CoeJbOLOmOJgUiLZR2pP08TVhRIdTISmA=;
 b=eQpdYrpspn2eunnnSLsJJEcQ3rw5aHNdU8lYmt0cAIg24vTMxJW1DNI+gtxRIqQ4kKz1OGbwZZcmFeDtrSwZUSeVDWrqRNohwlZTi0DX38rqvgWdrx3JhCsyKWOAs3nGN9k0UsCRrQJUgkCKk3Q9BZgW/PqvuF3Id39twP4k49QzMFw9p/OVVZh0mTzvKWDghkPpyijH5ZmFLnXjnuAbs0YnIuIj5APOZJx+DKmApBrOloBcgEJSSRdn0GVZQ5qRaij5612hMeoWTQd2RuwFI4lL874KhSp990/E9ZlGndsusMmUGd+ChYt6v2y4NgMLb8L8Wz6aHWt/VRkDJY16Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRsb6dJVe4CoeJbOLOmOJgUiLZR2pP08TVhRIdTISmA=;
 b=vjW7Jpfy/7rvv2gUIhAzThF66+XWTwhlA+YIISo47gIOgjY+lafpzEsnaeE5boI+Dzo+otcZAAbCoAze0Z2jBLWKzqU5boN+WBFvr9VHx1Sb1uuiok7GIKVphu52Vsb8vvAijxu9bYRf+XVEGHsab6ZDEV4z7kjFMqNkRjWbwQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5483.namprd10.prod.outlook.com
 (2603:10b6:510:ee::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 23:31:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 23:31:03 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net 1/2] net: ethernet: ocelot: rename vcap_props to clearly be an ocelot member
Date:   Fri, 29 Apr 2022 16:30:48 -0700
Message-Id: <20220429233049.3726791-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429233049.3726791-1-colin.foster@in-advantage.com>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 475fcbaa-1fb0-43ca-fa97-08da2a38534d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB54831B9C1EEC121AF1DACA70A4FC9@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu/wZpNjuWnH7EwnwlV/neRE3lkftzINku8ps30jpiPOjAEK0Nr/DQU2xTYYw8s4QjcXHig1bOe+g5tLZOK2h2m0O2DZWujxR+mIgF4yEFnXEjT9aiD++9XvgvZKhevozqn+o7yGyP2HdRYFxMaZfcB0g4Cq/jkAUJMJAplFh/hiGEG/tSvXtkMfNfqMF7VljZb6C3W7YbkrWpxffdJ45xJZ6VY3slRhkD+CT8ywVHt55EqMMAX8TU3jkIhpIbWR0bnoT01ehnMDb603+cQbsk3F/sNvaVnJbSkhMhbfKNg6MjRvqFzAQWY9y3/9Xzb96WiipIemprp7YjNPJhIn9VuIb/IgyCqv0FKiEeyItccxtpEMf/WceDqrwvCCdcSc7x6nzyRm3o7VAvUCjWcU/H2JvZeAvO+JhzDpodhrgNNhcWKCjnnq72NarMuEmbdLRIk/DqIj9SmuamJ9NVZr4ZzqUHtT9QhaeoGCO3K1gPUOJuVGuNLTAEUEylvf0riJx8dFjUrAa5fQBSuCgOtFEraN+MH4+/4rqzubULcCi42spp+0ioujh1KA68HlvtVz7a1A79WyUF+cz2L8j1HjnbOlfvZU9zFEXUfVDWKgUgaKmJl9sB2PyA3XppkNjZtJVHanX7vAOgFsUqM9dlxfP77w9sNCZjGcCmuKr2uko+gMk6YffGJma4Vf947QWxVdy4fISFSvFtLN8cqc8wcFCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39830400003)(366004)(346002)(376002)(508600001)(86362001)(44832011)(6512007)(30864003)(8936002)(36756003)(7416002)(6506007)(316002)(5660300002)(186003)(6486002)(83380400001)(6666004)(38100700002)(38350700002)(52116002)(2906002)(2616005)(26005)(1076003)(66946007)(4326008)(8676002)(54906003)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O141oc6xOuo+ugy7UsnzrJSkGgJa/zUDpHTuDqBL0lzLwdEthup1ktalTtsR?=
 =?us-ascii?Q?jwhioi5aJJdYbEq2wegavzH3nR1h4ZhAd0JAQF9f65LsFBI0hwiSjN0PHq5u?=
 =?us-ascii?Q?AJK1qZLevilWTI43h1pI7+V8YSiTob9KTEKATYxVqmfUtZFKCPN0Yu47kLJz?=
 =?us-ascii?Q?JENoGLwWCnAdZMjeNuTZF1d/Ij7b+U52CtA/m2KEm3V8Zm0EUBx1H1fx3ymG?=
 =?us-ascii?Q?TXUZnIuPaAA2lg31zHNuEeDBQez+wK+If30YySw/TuXknJV/91DEiBrudahe?=
 =?us-ascii?Q?VkOlOTLbbiuglt0xErWqxtwug3dw9+34lBgVdFz6ECyhHSMTHDLFGeDA5JGP?=
 =?us-ascii?Q?YSjkEEZYl+EClYduVnw6GuVqPKFAtc7BSqD71QtHc0lI4eU8chlBXMYtnc3+?=
 =?us-ascii?Q?bnVL4fI9JFzQcFeOgvoqOTi2bSGjQx5HwL8uZAaaBpfsnoiKSQhwWYEJLgnP?=
 =?us-ascii?Q?5vwpwRCNXNptNPko3NTqlpdNJYPg17kbwF/7TVEFmR7bL2UmjI+S5vHCCFkY?=
 =?us-ascii?Q?DhkWpzxdybW8cwfIAmODKSSTZo+qTBQ9KLMbvmsQmu4nlpvcnjyLw6FvYdRx?=
 =?us-ascii?Q?dmch1ep3fUXbkWMGRJ2Fid6ObiBv2mNF5tzPINU6SpBHIp6JJ8lrAHpfVYey?=
 =?us-ascii?Q?FxPN4Cd9MPs7dRgM4D8kJwH/2keKkiCjMvx9vRvTjGYUVrwS9cFrUVN+g/yH?=
 =?us-ascii?Q?rrzn4v+hcPthYdGyMOQxwZHPB/OuByu73XhKiLLxLCZo9bhgKuOcj8O5PAD8?=
 =?us-ascii?Q?i9xnBLapJPXk2p8wDy9gGOu8JfuHVgR/tMZH636Df9ygLoLhYZ94qH/vOyJz?=
 =?us-ascii?Q?8tBXEBnbho6dfawO/AGtIl7nRfwd8JzHtGlyJhlteTG4ubtoBHBaJ4QhLPyR?=
 =?us-ascii?Q?pvtBlRYxIwZq4KDqn6Db0EkPBaENhR2L3rbw1r/r6wXTQYJOHV05sCXPrgj6?=
 =?us-ascii?Q?XX2bb3tSiXE1GMbPePdolaMNT8cHlkM9hyYaWyb+hV1KBafwfZDdmFeTuzpL?=
 =?us-ascii?Q?XMPh2OcH+TcQQ7QwH/RMwBWh0YQzRGSy0PSVbcZYyn3H09UWXhJdtIA/VcvI?=
 =?us-ascii?Q?SePOYwWISzJpHdbf05kePq0n/igAESJOglp7B2Ev4tgfleBjcmAJG8wxKKl+?=
 =?us-ascii?Q?R+VYnPmWSZs40lscFUkC7GydxlJqX6BZeJjf/KLD9kFZJjAke9NnrY2qvXV6?=
 =?us-ascii?Q?k3YfUVs4g4rrtWdsrIzPLZj7A0tdV7LFClYY6+pyT1EefsLY2UB4wUFVl7TH?=
 =?us-ascii?Q?2K2DWHqQiIxSS7ukZhnreZxPxQXu9Mcuri54am9mSq3Tcmtq+QsK7lzg9nvH?=
 =?us-ascii?Q?cRlHjXhXpx9mWb4FFjZNHGkvftwLVnLAW+GGkv/TQxxFP4yREmL/3Q4eLJqi?=
 =?us-ascii?Q?hsNuDVmWjUavhyRPY/tIbcCs+CC0F6sDnGpiGXDiaVbTZKw9rUBhXWX+v/PG?=
 =?us-ascii?Q?saTLXJ2HuuWMXBcIP4cSDDUB7CNK23dejuobiuj2W+CiiKkXB39qkukSjSxF?=
 =?us-ascii?Q?kVwiZnZHhiRguC7yS+DLe2Sv8n2C5hYpiX3LW65mhTtvS8H9ATilg+mpmcjf?=
 =?us-ascii?Q?WrkWWoha2m1B4lqqyFVOLCXXZMEft64XzSXC3nkFuP+UGvUzLL/pZQQZ5lT1?=
 =?us-ascii?Q?+jA0REgUFNmY5YHe/COqoQhvocx0wnSdP/nbNE22mV3n55G0Oz87Acr7NqOZ?=
 =?us-ascii?Q?m8a9XsMkoiAzxOZugaYPL4U/aPSDRfmaTfFq0AcGTRoZN4yQvrrlBihYR/Hm?=
 =?us-ascii?Q?87+hHTvxvwWxe5KG91aMfVq1py+t7pAegpNolISv3R/tYycLcot+?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475fcbaa-1fb0-43ca-fa97-08da2a38534d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 23:31:03.3000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1kjPJDCEKHZ7ShDaDroIP6O2/TZ9mXWMn5mcLAKbko9Tq8pV7PJ62QoTyh71eeTSWnKsxprVxDE1DopL0bykrcpk1lNd1qfmAQAuvY8Dyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vcap_props structure is part of the ocelot driver. It is in the process
of being exported to a wider scope, so renaming it to match other structure
definitions in the include/soc/mscc/ocelot.h makes sense.

I'm splitting the rename operation into this separate commit, since it
should make the actual bug fix (next commit) easier to review.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.h             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c  |  4 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 54 +++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 +-
 include/soc/mscc/ocelot.h                  |  2 +-
 include/soc/mscc/ocelot_vcap.h             |  2 +-
 8 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index f083b06fdfe9..d6cf5e5a48c5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -27,7 +27,7 @@ struct felix_info {
 	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
-	struct vcap_props		*vcap;
+	struct ocelot_vcap_props	*vcap;
 	u16				vcap_pol_base;
 	u16				vcap_pol_max;
 	u16				vcap_pol_base2;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 52a8566071ed..a60dbedc1b1c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -845,7 +845,7 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 44, 32},
 };
 
-static struct vcap_props vsc9959_vcap_props[] = {
+static struct ocelot_vcap_props vsc9959_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 68ef8f111bbe..2fda65fb21a3 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -829,7 +829,7 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 50, 32},
 };
 
-static struct vcap_props vsc9953_vcap_props[] = {
+static struct ocelot_vcap_props vsc9953_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 03b5e59d033e..59b040ad1fee 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -504,8 +504,8 @@ static int ocelot_flower_parse_indev(struct ocelot *ocelot, int port,
 				     struct flow_cls_offload *f,
 				     struct ocelot_vcap_filter *filter)
 {
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	int key_length = vcap->keys[VCAP_ES0_IGR_PORT].length;
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct net_device *dev, *indev;
@@ -786,7 +786,7 @@ static struct ocelot_vcap_filter
 	if (ingress) {
 		filter->ingress_port_mask = BIT(port);
 	} else {
-		const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+		const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 		int key_length = vcap->keys[VCAP_ES0_EGR_PORT].length;
 
 		filter->egress_port.value = port;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index c8701ac955a8..816c8144e18e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -47,13 +47,14 @@ struct vcap_data {
 };
 
 static u32 vcap_read_update_ctrl(struct ocelot *ocelot,
-				 const struct vcap_props *vcap)
+				 const struct ocelot_vcap_props *vcap)
 {
 	return ocelot_target_read(ocelot, vcap->target, VCAP_CORE_UPDATE_CTRL);
 }
 
-static void vcap_cmd(struct ocelot *ocelot, const struct vcap_props *vcap,
-		     u16 ix, int cmd, int sel)
+static void vcap_cmd(struct ocelot *ocelot,
+		     const struct ocelot_vcap_props *vcap, u16 ix, int cmd,
+		     int sel)
 {
 	u32 value = (VCAP_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
 		     VCAP_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
@@ -79,14 +80,15 @@ static void vcap_cmd(struct ocelot *ocelot, const struct vcap_props *vcap,
 }
 
 /* Convert from 0-based row to VCAP entry row and run command */
-static void vcap_row_cmd(struct ocelot *ocelot, const struct vcap_props *vcap,
-			 u32 row, int cmd, int sel)
+static void vcap_row_cmd(struct ocelot *ocelot,
+			 const struct ocelot_vcap_props *vcap, u32 row, int cmd,
+			 int sel)
 {
 	vcap_cmd(ocelot, vcap, vcap->entry_count - row - 1, cmd, sel);
 }
 
 static void vcap_entry2cache(struct ocelot *ocelot,
-			     const struct vcap_props *vcap,
+			     const struct ocelot_vcap_props *vcap,
 			     struct vcap_data *data)
 {
 	u32 entry_words, i;
@@ -103,7 +105,7 @@ static void vcap_entry2cache(struct ocelot *ocelot,
 }
 
 static void vcap_cache2entry(struct ocelot *ocelot,
-			     const struct vcap_props *vcap,
+			     const struct ocelot_vcap_props *vcap,
 			     struct vcap_data *data)
 {
 	u32 entry_words, i;
@@ -121,7 +123,7 @@ static void vcap_cache2entry(struct ocelot *ocelot,
 }
 
 static void vcap_action2cache(struct ocelot *ocelot,
-			      const struct vcap_props *vcap,
+			      const struct ocelot_vcap_props *vcap,
 			      struct vcap_data *data)
 {
 	u32 action_words, mask;
@@ -146,7 +148,7 @@ static void vcap_action2cache(struct ocelot *ocelot,
 }
 
 static void vcap_cache2action(struct ocelot *ocelot,
-			      const struct vcap_props *vcap,
+			      const struct ocelot_vcap_props *vcap,
 			      struct vcap_data *data)
 {
 	u32 action_words;
@@ -170,7 +172,7 @@ static void vcap_cache2action(struct ocelot *ocelot,
 }
 
 /* Calculate offsets for entry */
-static void vcap_data_offset_get(const struct vcap_props *vcap,
+static void vcap_data_offset_get(const struct ocelot_vcap_props *vcap,
 				 struct vcap_data *data, int ix)
 {
 	int num_subwords_per_entry, num_subwords_per_action;
@@ -251,8 +253,8 @@ static void vcap_key_field_set(struct vcap_data *data, u32 offset, u32 width,
 	vcap_data_set(data->mask, offset + data->key_offset, width, mask);
 }
 
-static void vcap_key_set(const struct vcap_props *vcap, struct vcap_data *data,
-			 int field, u32 value, u32 mask)
+static void vcap_key_set(const struct ocelot_vcap_props *vcap,
+			 struct vcap_data *data, int field, u32 value, u32 mask)
 {
 	u32 offset = vcap->keys[field].offset;
 	u32 length = vcap->keys[field].length;
@@ -260,7 +262,7 @@ static void vcap_key_set(const struct vcap_props *vcap, struct vcap_data *data,
 	vcap_key_field_set(data, offset, length, value, mask);
 }
 
-static void vcap_key_bytes_set(const struct vcap_props *vcap,
+static void vcap_key_bytes_set(const struct ocelot_vcap_props *vcap,
 			       struct vcap_data *data, int field,
 			       u8 *val, u8 *msk)
 {
@@ -291,7 +293,7 @@ static void vcap_key_bytes_set(const struct vcap_props *vcap,
 	}
 }
 
-static void vcap_key_l4_port_set(const struct vcap_props *vcap,
+static void vcap_key_l4_port_set(const struct ocelot_vcap_props *vcap,
 				 struct vcap_data *data, int field,
 				 struct ocelot_vcap_udp_tcp *port)
 {
@@ -303,7 +305,7 @@ static void vcap_key_l4_port_set(const struct vcap_props *vcap,
 	vcap_key_field_set(data, offset, length, port->value, port->mask);
 }
 
-static void vcap_key_bit_set(const struct vcap_props *vcap,
+static void vcap_key_bit_set(const struct ocelot_vcap_props *vcap,
 			     struct vcap_data *data, int field,
 			     enum ocelot_vcap_bit val)
 {
@@ -317,7 +319,7 @@ static void vcap_key_bit_set(const struct vcap_props *vcap,
 	vcap_key_field_set(data, offset, length, value, msk);
 }
 
-static void vcap_action_set(const struct vcap_props *vcap,
+static void vcap_action_set(const struct ocelot_vcap_props *vcap,
 			    struct vcap_data *data, int field, u32 value)
 {
 	int offset = vcap->actions[field].offset;
@@ -330,7 +332,7 @@ static void vcap_action_set(const struct vcap_props *vcap,
 static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
 	struct ocelot_vcap_action *a = &filter->action;
 
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, a->mask_mode);
@@ -345,7 +347,7 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 static void is2_entry_set(struct ocelot *ocelot, int ix,
 			  struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
 	u32 val, msk, type, type_mask = 0xf, i, count;
 	struct ocelot_vcap_u64 payload;
@@ -647,7 +649,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   const struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
 	const struct ocelot_vcap_action *a = &filter->action;
 
 	vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA,
@@ -670,7 +672,7 @@ static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
 static void is1_entry_set(struct ocelot *ocelot, int ix,
 			  struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
 	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
@@ -783,7 +785,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 static void es0_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   const struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	const struct ocelot_vcap_action *a = &filter->action;
 
 	vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_OUTER_TAG,
@@ -811,7 +813,7 @@ static void es0_action_set(struct ocelot *ocelot, struct vcap_data *data,
 static void es0_entry_set(struct ocelot *ocelot, int ix,
 			  struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
 	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
@@ -856,7 +858,7 @@ static void es0_entry_set(struct ocelot *ocelot, int ix,
 static void vcap_entry_get(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[filter->block_id];
+	const struct ocelot_vcap_props *vcap = &ocelot->vcap[filter->block_id];
 	struct vcap_data data;
 	int row, count;
 	u32 cnt;
@@ -1313,7 +1315,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 }
 
 static void ocelot_vcap_init_one(struct ocelot *ocelot,
-				 const struct vcap_props *vcap)
+				 const struct ocelot_vcap_props *vcap)
 {
 	struct vcap_data data;
 
@@ -1332,7 +1334,7 @@ static void ocelot_vcap_init_one(struct ocelot *ocelot,
 }
 
 static void ocelot_vcap_detect_constants(struct ocelot *ocelot,
-					 struct vcap_props *vcap)
+					 struct ocelot_vcap_props *vcap)
 {
 	int counter_memory_width;
 	int num_default_actions;
@@ -1421,7 +1423,7 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 
 	for (i = 0; i < OCELOT_NUM_VCAP_BLOCKS; i++) {
 		struct ocelot_vcap_block *block = &ocelot->block[i];
-		struct vcap_props *vcap = &ocelot->vcap[i];
+		struct ocelot_vcap_props *vcap = &ocelot->vcap[i];
 
 		INIT_LIST_HEAD(&block->rules);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4f4a495a60ad..12c739cb89f9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -344,7 +344,7 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct vcap_props vsc7514_vcap_props[] = {
+static struct ocelot_vcap_props vsc7514_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b4e6c78d0f4..42634183d062 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -727,7 +727,7 @@ struct ocelot {
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
 	struct ocelot_vcap_policer	vcap_pol;
-	struct vcap_props		*vcap;
+	struct ocelot_vcap_props	*vcap;
 	struct ocelot_mirror		*mirror;
 
 	struct ocelot_psfp_list		psfp;
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 7b2bf9b1fe69..05bd73c63675 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -36,7 +36,7 @@ enum {
 
 #define OCELOT_NUM_VCAP_BLOCKS		__VCAP_COUNT
 
-struct vcap_props {
+struct ocelot_vcap_props {
 	u16 tg_width; /* Type-group width (in bits) */
 	u16 sw_count; /* Sub word count */
 	u16 entry_count; /* Entry count */
-- 
2.25.1

