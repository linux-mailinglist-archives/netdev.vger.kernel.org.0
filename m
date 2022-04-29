Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9413C515908
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381836AbiD2Xeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380711AbiD2Xe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:34:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2109.outbound.protection.outlook.com [40.107.101.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719A1C1CA3;
        Fri, 29 Apr 2022 16:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axX0d2FdYGngqaTpWDmEG/TXSG/LYhhkeSB1MukbXtD3WG3wgwt+2VHkN1X7eKlAehwwhxKNYzzjmHYuSFIxEsPQyDl0PYTu+pZiaPnn8TX+xEnVhWYRpijMk2l4hI3dxOWcEtheQw2hHyImlELZLXQe69RC+EA8vYaxxZA+U7XairyFSlZU2jjuCtza/VG8wwWDui89cy9ME5W7Q0wW3oyF4cg2eRk9mCpSunmMxm43IxnsnO4sYYjNS+1/4FEJRXgQUch/o0ikJCpg/Y6oMxRneyUFM/SzBvq6XsuyrFTtRwioxS+ouUFbeMT425dSeoD4yfebMB7pAn9aGepGJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rZGRA6+G/vzVk+PgixnEzL+UQ6MeT+IAJXg366OR78=;
 b=EsXtVENvnmFysba5JIxcnAoYc9rI59ulBASgBPLVnPBgNzaCv9Qp1e48DOpl7bfVlmq0PM6wsuw6Qpb3T6ETYJZ57ss8tadTWcL1Y6YUZpW3No2LnB00DhL8ENxgg4Uiol+ECvYbZLZIizCRaw0na7WZa7SsXH/NgeI+4ukPkd0A1S4dM4KiWLKiWLHRWuAncmtogwILi7Hf8pCWsP14NN+fM9hejOXssfPhejTnFJD7MaEx09BS35pxT0AaNei23pRKWRdXbVtBtt8PRkJ67KD5lm1JGTq4BmimsjqvftNTEqP5CwmrWQwlgqLK2EMv+gukfylTj3EkC6kGx0MTMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rZGRA6+G/vzVk+PgixnEzL+UQ6MeT+IAJXg366OR78=;
 b=YBstt23Duw96rzkBUd0bH6vuwLfK4iQtM1+CBRSmD0lPw3NAJ9plAxhIkTVO9DObTui5FLlEJQ7fh17/JTjUwWLsdQZwR5NxYfRZJeTkNsHGBxEKKLl2RsjH16jP1NPfFgjLyH5scxASuG5jqkzDGRedCKYxih1/9/GJoTmJy7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5483.namprd10.prod.outlook.com
 (2603:10b6:510:ee::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 23:31:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 23:31:04 +0000
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
Subject: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory conflict for vcap_props
Date:   Fri, 29 Apr 2022 16:30:49 -0700
Message-Id: <20220429233049.3726791-3-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3a3279f1-47b2-4dcb-2a13-08da2a385403
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5483E6B1531FBE4A67331215A4FC9@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DVfc9UtZMBtN8mp4NOQxdYXsy8yyg5Myax+H7sMZhthhol8ZfAZIzHB5uz3nfYo0bz3hg1zkWSjrtkdRV0093jRazDNScAok9MNTRy/8f0WEY4hq8k7LAnoGtxw9WmhPVTvmff3R5ShN7KTiSZggsWOAgdgj+DLYUFPJAxI5FaL8ZWxoZ3reyoENulRmf3MuPe5TYPGN7CCazC5aZiFJf+bns4WYw5sU97FZfUnas2sk6Oqpw5UOh4ayDNGAYeW288i5P/dMuPPvYyJCeCZ2zXbx8h/S0sTbICRaVGfUd4EteYUYqxkoTbLEHT77igPvQnk9pCBOYKoT5lyynymgQBFonD9RO0T0lr/aJNFXLTAE3O8d5CDa9XrFCx+oJMgEOuQhsCne9DW29GLiDQVYylbTWrdPcspgfF5RsXltp/coyZ6teGR8RndMCyhvhJx3ocBxZwilT8vSJNSi+aLaJzu3QimY9wPfVc7rLJRp9+yHq5+1Woqgzl3bRdKGTGYSyvgv32XutdskqkMHxe+otOEMGVYzweR7IrJ/fIv2DI1unVZfIyOotVdmRbJIpAdTjAzfSPYwEu46D/xqaebyQl4Tz5P2P2yfF0AflTAe5K7eQkh6R2c9OGldaL4dCnm9yme1omLh+GZ84V//pAE6eglBUuWZ70aOOPj9hQF1VBpVIi877Du5sRZcqTjWZdWiswiHtxuqEdpQFqJBK4Txw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39830400003)(366004)(346002)(376002)(508600001)(86362001)(44832011)(6512007)(8936002)(36756003)(7416002)(6506007)(316002)(5660300002)(186003)(6486002)(83380400001)(6666004)(38100700002)(38350700002)(52116002)(2906002)(2616005)(26005)(1076003)(66946007)(4326008)(8676002)(54906003)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2tFEFMBDl3Ld5SrlwLFMdokf8r2OsEpzFDMLlcsoVie5ksiZedBwrmGT5B+P?=
 =?us-ascii?Q?wDCyBO6ZWPKL+sJoNVXpGa274MD3H/+gXq7BB0NKdQ/BP9BydvASzRoPkXZn?=
 =?us-ascii?Q?D4CZcutQIOsUOX9+HgZJgYVg52E6QPVSCniDNUQxyEWxljuuFc5PlPeSWcPh?=
 =?us-ascii?Q?/stMt+4TBRC6gjuwccq5beXZgFD3rYvpqJAuooE2HVHmD1Lr7Fe95iP9PS7j?=
 =?us-ascii?Q?x30QFb/UKqxFjAJG+B3xiaCDH51hYuutwDZ+D9Es99J9hWAHjR43lC4hOJeF?=
 =?us-ascii?Q?YSvNOSIKEPTbcSG604UUQr47zDhgU3u9iVkyqKG3EZtJTHdoOR5Avg9blmeL?=
 =?us-ascii?Q?yIqcsg13HxahmDTYuVnGmxtDSlLRBfYSFRYkCks45wycBfyXdwYEEfz3aOj3?=
 =?us-ascii?Q?vDgyNguzMIDDtg24hf8XEmPtbUNrDX6o25zAoyNAj7RhfBaVBrYTbB8HcVe/?=
 =?us-ascii?Q?J8TDxrajM1scQGxx4zLJ8YRzib9ur28v/duQbTEYES5uYjT6fBE2C7F1y/g7?=
 =?us-ascii?Q?E3DAYKgqCPzJbQJxIdvJeYsfzxtzDwlZ0EWOE3dpn4V2VShFxkZnf7hUue5K?=
 =?us-ascii?Q?ZGRI/XmQefi83teIWVT2pap5dSZeTuzhfwoHkfGBUMt3gwuhWSToczDbjWh5?=
 =?us-ascii?Q?v+HzXV4Vn1tvRljJudfAxMtqwk+gC2JBjuOcPuaheH2gwgE7bLbYN4YaGmTI?=
 =?us-ascii?Q?EdTgWy24geBf80EiP7I0S+j8N7UMmbYKcgYFbNEn6S0LcKjVEyhWX+fyBtqu?=
 =?us-ascii?Q?FQA1ZuvIF6IZtlEK1XadojEdmJXbkKCEPHOO52NPabYtRWaZ/3dZQ0qgRspW?=
 =?us-ascii?Q?OGRS35LTXMCUF9rYS3uZVc0TShtwo04cRgvUxrQXnnRx+YmxhSqh1csZ4V4B?=
 =?us-ascii?Q?6Fk3NvJfaBhzokQ1mqeXpL66bKL1CWGfz6uGd2goEWtskxxNUJISo9jBd8IF?=
 =?us-ascii?Q?yvRoHPmbtWSBifqVDe+H6lO5Y7vBo1M8+BR6pEoXBnkIGJxoifKTbzC9z7P4?=
 =?us-ascii?Q?7r+wttxcei7XX4DpKyZdEEM1VBBA4HG0/gmZgfFa5Bzg0M/O24ebx+F/BCgV?=
 =?us-ascii?Q?coyi63omoikkiiVBHyivVhFV7Z88PZYtrFLv7Frgd7mPYl0RfZVklpC2qIYG?=
 =?us-ascii?Q?jmSVICBJnx3H9ntfySWMLPWS2Cx8XQtEWmz8HPShrqZv+OoAzBNB/OMj1XFl?=
 =?us-ascii?Q?IfmcrhzfivPStpzpBOULAV+yc4xMUSZKIE8cT4HLhjavMJN7kBCCArGETsN/?=
 =?us-ascii?Q?moA1MC8H5QsZK8BF6RMPMI1ZymNpVD9CC11T/uYT/jK3cGyB5CBC85BUt0iG?=
 =?us-ascii?Q?uzO+UTfheyyxq6MZZplGo5O5siUJI7wWmPOmNayp2O7iYqTzYjXIqJO4wJoS?=
 =?us-ascii?Q?N6h181u8CAvgxmwDP4fhSMBLb4QmWvUMAYsKUeU1yxks1/6GoLQ8ly+kQeJq?=
 =?us-ascii?Q?h9Q2cYtHveCS2s/AqvZLfD2Mj3fXkxJ/oWJ2rvMth44CalmT21fCPMHf9J0s?=
 =?us-ascii?Q?6i9ugVJp7jvemEuPXKQX5BQ6o1SopwjGDvzR2jtc43b88HIuAJbHiI3Thqns?=
 =?us-ascii?Q?ce1dntD0GFDjyH5vq9sGaJzyshl2/eN3x52oJ8SKVSf0tgtZv01wzfatqu+r?=
 =?us-ascii?Q?fgqDtnaWD/DCSPoasjjX484xUQWWV3UbDqUsk+Rd5W4zaH5Lyb6nTtAAHSyc?=
 =?us-ascii?Q?u8pvu6SNhlPt6teWyULsUHYWDLIb2KHcUgy5uqXz6gw/Wqtj/MGivdrlv+iQ?=
 =?us-ascii?Q?8FvjTgPIuJXyvm0P/YqlS1Z+3SXu1oB41TYO+iv+VDryZrjR+BSk?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3279f1-47b2-4dcb-2a13-08da2a385403
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 23:31:04.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQXQ2lnFDgF/Hb0SQy3qjcm12+9pgLhaQ+hd5TJQWwOV8OU0g6CUKpelKecUXSAxA4JWisX4uhJ4xhseGQmRppKUhYn/jLJDFu4I05RLgtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each instance of an ocelot struct has the ocelot_vcap_props structure being
referenced. During initialization (ocelot_init), these vcap_props are
detected and the structure contents are modified.

In the case of the standard ocelot driver, there will probably only be one
instance of struct ocelot, since it is part of the chip.

For the Felix driver, there could be multiple instances of struct ocelot.
In that scenario, the second time ocelot_init would get called, it would
corrupt what had been done in the first call because they both reference
*ocelot->vcap. Both of these instances were assigned the same memory
location.

Move this vcap_props memory to within struct ocelot, so that each instance
can modify the structure to their heart's content without corrupting other
instances.

Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
constants")

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c             |  3 +-
 drivers/net/dsa/ocelot/felix.h             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  5 ++--
 include/soc/mscc/ocelot.h                  | 34 +++++++++++++++++++++-
 include/soc/mscc/ocelot_vcap.h             | 32 --------------------
 6 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9e28219b223d..f6a1e8e90bda 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1199,7 +1199,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
-	ocelot->vcap		= felix->info->vcap;
+	memcpy(&ocelot->vcap, felix->info->vcap,
+	       OCELOT_NUM_VCAP_BLOCKS * sizeof(*felix->info->vcap));
 	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
 	ocelot->vcap_pol.max	= felix->info->vcap_pol_max;
 	ocelot->vcap_pol.base2	= felix->info->vcap_pol_base2;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index d6cf5e5a48c5..fb928c8bf544 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -27,7 +27,7 @@ struct felix_info {
 	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
-	struct ocelot_vcap_props	*vcap;
+	const struct ocelot_vcap_props	*vcap;
 	u16				vcap_pol_base;
 	u16				vcap_pol_max;
 	u16				vcap_pol_base2;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a60dbedc1b1c..ddf4e8a9905c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -845,7 +845,7 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 44, 32},
 };
 
-static struct ocelot_vcap_props vsc9959_vcap_props[] = {
+static const struct ocelot_vcap_props vsc9959_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 12c739cb89f9..4fe51591afa8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -344,7 +344,7 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct ocelot_vcap_props vsc7514_vcap_props[] = {
+static const struct ocelot_vcap_props vsc7514_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
@@ -638,7 +638,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->num_phys_ports = of_get_child_count(ports);
 	ocelot->num_flooding_pgids = 1;
 
-	ocelot->vcap = vsc7514_vcap_props;
+	memcpy(&ocelot->vcap, &vsc7514_vcap_props,
+	       OCELOT_NUM_VCAP_BLOCKS * sizeof(*vsc7514_vcap_props));
 
 	ocelot->vcap_pol.base = VSC7514_VCAP_POLICER_BASE;
 	ocelot->vcap_pol.max = VSC7514_VCAP_POLICER_MAX;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 42634183d062..b097b97993b0 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -525,6 +525,15 @@ enum {
 	VCAP_CONST_IF_CNT,
 };
 
+enum {
+	VCAP_ES0,
+	VCAP_IS1,
+	VCAP_IS2,
+	__VCAP_COUNT,
+};
+
+#define OCELOT_NUM_VCAP_BLOCKS		__VCAP_COUNT
+
 enum ocelot_ptp_pins {
 	PTP_PIN_0,
 	PTP_PIN_1,
@@ -583,6 +592,29 @@ struct ocelot_vcap_block {
 	int count;
 };
 
+struct ocelot_vcap_props {
+	u16 tg_width; /* Type-group width (in bits) */
+	u16 sw_count; /* Sub word count */
+	u16 entry_count; /* Entry count */
+	u16 entry_words; /* Number of entry words */
+	u16 entry_width; /* Entry width (in bits) */
+	u16 action_count; /* Action count */
+	u16 action_words; /* Number of action words */
+	u16 action_width; /* Action width (in bits) */
+	u16 action_type_width; /* Action type width (in bits) */
+	struct {
+		u16 width; /* Action type width (in bits) */
+		u16 count; /* Action type sub word count */
+	} action_table[2];
+	u16 counter_words; /* Number of counter words */
+	u16 counter_width; /* Counter width (in bits) */
+
+	enum ocelot_target		target;
+
+	const struct vcap_field		*keys;
+	const struct vcap_field		*actions;
+};
+
 struct ocelot_bridge_vlan {
 	u16 vid;
 	unsigned long portmask;
@@ -727,7 +759,7 @@ struct ocelot {
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
 	struct ocelot_vcap_policer	vcap_pol;
-	struct ocelot_vcap_props	*vcap;
+	struct ocelot_vcap_props	vcap[OCELOT_NUM_VCAP_BLOCKS];
 	struct ocelot_mirror		*mirror;
 
 	struct ocelot_psfp_list		psfp;
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 05bd73c63675..96ca1498f722 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -27,38 +27,6 @@
  * =================================================================
  */
 
-enum {
-	VCAP_ES0,
-	VCAP_IS1,
-	VCAP_IS2,
-	__VCAP_COUNT,
-};
-
-#define OCELOT_NUM_VCAP_BLOCKS		__VCAP_COUNT
-
-struct ocelot_vcap_props {
-	u16 tg_width; /* Type-group width (in bits) */
-	u16 sw_count; /* Sub word count */
-	u16 entry_count; /* Entry count */
-	u16 entry_words; /* Number of entry words */
-	u16 entry_width; /* Entry width (in bits) */
-	u16 action_count; /* Action count */
-	u16 action_words; /* Number of action words */
-	u16 action_width; /* Action width (in bits) */
-	u16 action_type_width; /* Action type width (in bits) */
-	struct {
-		u16 width; /* Action type width (in bits) */
-		u16 count; /* Action type sub word count */
-	} action_table[2];
-	u16 counter_words; /* Number of counter words */
-	u16 counter_width; /* Counter width (in bits) */
-
-	enum ocelot_target		target;
-
-	const struct vcap_field		*keys;
-	const struct vcap_field		*actions;
-};
-
 /* VCAP Type-Group values */
 #define VCAP_TG_NONE 0 /* Entry is invalid */
 #define VCAP_TG_FULL 1 /* Full entry */
-- 
2.25.1

