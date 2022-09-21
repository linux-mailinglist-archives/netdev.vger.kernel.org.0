Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC05BFD8A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiIUMNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiIUMMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:12:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE86495E75
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBIltrHyZ2W1ig/CHULebsI0JGsv7KiDLHhyJo6sr3fRO5if35NPxlTdZc9C+NAJG/vAzIxNQwUpv8qpLe2bHro2EaEtCqzYc2rjQQJd04th8acvOzw3RB88OaubS1dqjEobdOhqqwsPBL1KOllUT9B2XA+Qg5w+jeDKAM61gvhtgmwvwHnYzk3oB3ExfgmR5a2qUPpfa9rGVh4eA16X45PW0aXZeIcUDVRRslquRn9D4V4DNRfwJlKEAg0v2iWVIDJZ5IwYv8rkAM9+1vZjov1AgcTue+wxC/SLsmqhOYeR57submXu15qgjzzsZMgvpFZX7ketCMTaQza1ijjY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ss6PC8iPr6TwN3dPelOhV9QzjWYAOl6EQ5sVedPj2yk=;
 b=h7sEqkk059tD2IY6Z2bb0AaZwy1Q373y6r8Fw3/Dd5Fi+OI9SMltTX+KFRgwaI/ju0poMnC5L3RInpEatma9tS2lR+kqGZr7ktWyEhyU3oNEiDCjEMACxLJm8Zdb3W/IUe5KYOr1Dok5nXWW8Yhbse3I6xKk0oh9RfGzqPFYNU4g8VedarXHnXlWOPvdtf3Q4d8pdsE0A2ykD+JXqn6CMyTYgAxGK8NOazj+CEQzPc2DsVL4CMTX+IMGL+gyezJr4huTiHJHrgonb8v7FAGbRKT0JIBRV/Z0E6qAjliuILyd34oXwuZ9oP5Najioge2OJn7G2K9Os/4ah9fP+EAB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ss6PC8iPr6TwN3dPelOhV9QzjWYAOl6EQ5sVedPj2yk=;
 b=J1o3MYAVxq1l/VdZAsVmFgEVgKDppbNmeuAxpw1ogrIoywJQVkXHfK+AV/DASgFX1TekCTy4elMDr/CPJGN8MgAHmp2kKWtu+BVKeBHAm9tYNdrv/Cb4tqAmPAt6csdZQMp2syyapVWncGl/13hBzigzzpKH2r8fucElbeqVCA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5210.namprd13.prod.outlook.com (2603:10b6:208:341::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 12:12:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 12:12:53 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 3/3] nfp: add support restart of link auto-negotiation
Date:   Wed, 21 Sep 2022 14:12:35 +0200
Message-Id: <20220921121235.169761-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921121235.169761-1-simon.horman@corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0049.eurprd04.prod.outlook.com
 (2603:10a6:208:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: b4df36a6-9c85-4e78-8714-08da9bca9be8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuvFqj9bhKOU7vL/6TTxzrtSQFUk1dcdcIiCnXIHUceRAbpNVimpDrsSDrRWBlS4uA2X9RaLvL+vBk7yiwQ6DrCMuP779AkBUHOZBzIFS3An1M0FZxQhHbCsTxRmBsWSOej2Mo9tijU0JwA18ei1hd7ISiy41V+MkrzKSgPb4DaUEfYXHaBwgTkmPqND731AdUtvhsPuwK38wRw3LqyEFaFCIoWXNJlH+fI0MIUqXAQ5Nko0sUzYyTwKVxN8BcA9kV8yJ0AqO6s27m1YVOf9yRnnE2H/1igezLAgN+3TDu23RXU3TMgsLSCo+pWYIGrjdrb5bjiD12LAVz+VH9WbxHkZsx4Kzl9tZkj0FMWEeW4+ZDRkUdT2s9VyPiKMH9bT7+Pz4SDv4xsEr7MSaiyoixMt0Dmb82/nil+tLb77F6mniB8kYMjfvxxvK1MmBKfX+D4HuRnEsQWvgLtJPzhZ1hqZUWFnTWsxdrQb2gx6K/yZg0CruvvaGgICTwAuVaYVA7W9CRM+SytnPG0GcoS/dgX0YqWriaUXK3lfJ+urNXopv91V/bH+cQ97xY3rBdLfZGwAp22urhRa7FGyjZnjG6YHj0usJFmPzWjbm68GPLUBUS9J4QfWao8TAYNtAkBVh8ZAZzdK8Vf36ONnB2yjcnBhLOfyr5y7hcp2jb6eFYbt8xsFSUEeqp/Xl1YRPOAY4GyvPzI6p19diXPdCJehrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(107886003)(86362001)(41300700001)(6666004)(5660300002)(44832011)(8676002)(478600001)(110136005)(4326008)(316002)(66946007)(6486002)(66556008)(66476007)(8936002)(38100700002)(2616005)(1076003)(52116002)(6506007)(6512007)(186003)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EBDgk0mLpQmcwiMld4OD21+egxFv+TEFsfppAiFrOmqxVreyI/oKCjymSsiQ?=
 =?us-ascii?Q?pfTm67DWhlKq1iQb0vrkY8MXPL5xLBK9DPKjLd45RT0O6OlutG35ObZ1qXaH?=
 =?us-ascii?Q?3hCgfmnG+cH7AQVTtaEPauqd4eumkgWhi+hKwQ3+g+1m/FyerDI59cX69Bgk?=
 =?us-ascii?Q?h+hN80FdX75u3L6eAZwDBR8eoYP+BdleNcnbDlrCsrUkatwLAusxKoJ/Plv5?=
 =?us-ascii?Q?Jld+8xUTxPNfc45hIk4Zlv6/hvgj/1VQfawq4yryQ3zyzvUCyGu4KbNihyTx?=
 =?us-ascii?Q?BakfBDG6DoSA5goDVvjGYnmuf13Gzp76233S6MkvDSAQxLky5pD1tyPNlkG8?=
 =?us-ascii?Q?KQAZ1ta2NC8yCTus5Ow38H2wAHdXiU4MvdUwWW4ivrKmXrUZ8b6gl50Be73z?=
 =?us-ascii?Q?2Sg4w4tpAsqEsBjN0rSrZ7HGshRkYat13L1L/UZuqb1Cay6cJmlfPe2jWelI?=
 =?us-ascii?Q?neRIoxbEI89rf7B9c1WFN84bv+RplBlsv/+FUf+eN0Y7dbCUi7fMYSevjQNR?=
 =?us-ascii?Q?lAYUHwcd0G0NqrncJM+ow+HrBHTgJ0pW6E8C5yLGYJ6hr2jJLXiqMNA1kg0u?=
 =?us-ascii?Q?Mt4HvpiBYxS6YjdqDJSlAgSUuOD+vMLf0FzQmwkJziJPx2qkRzQv0l9WJ4NU?=
 =?us-ascii?Q?QbOyCL/M+WdxyiHKktTrLjvKIQrljS5Oz3KWmD0w7OpmuopoVAq2omIoeF5B?=
 =?us-ascii?Q?1w417wCMnMIPBv2q7uWwD+7otsw/yLETtUwct9Sru0C3TR10NttB/7qC790d?=
 =?us-ascii?Q?EXfA0xhX27RyFb92eOdiZyRNsh9t6MH7F9XLNsqByhgPy20FQNqAGEkjGSs1?=
 =?us-ascii?Q?9cY7EkiTqnNid6ERvzr+12OWY0pK5h6K1jQ2B3/b9kMj4NDyvWe9+9sSAkSB?=
 =?us-ascii?Q?hi1kDYlHyDFCJ1914DqfKp9kie8/r+h2UgxWAo0H2mgVY1rbyuixKDGpKZz5?=
 =?us-ascii?Q?iV3famRYFFYIgaSwOIh14aTuKc6KO2o+0TjThNJ25YI/VeF8M2KMDgVL+boS?=
 =?us-ascii?Q?LhuTD923UwPdM9C0uL6CGPBzljc4ugYj++qrTV2aA+zVMtGbHlR3jrN7nQje?=
 =?us-ascii?Q?B+h/cTpKfaBDAovghf+H16Duuvi3exBZrrTgcFwtZqHtACswLuv3nxYR/ogB?=
 =?us-ascii?Q?VHeAWbqAUWrxX0UIEfLsr3YtLL1WB2QZjf9/a0u4ayoc9fRKMdUsbmpT2Ixh?=
 =?us-ascii?Q?tuONtFoO2/pPykSPITx+a4v0oQ4lic9nfJz+tMU/zhJHaL737vB5smC/QA0L?=
 =?us-ascii?Q?Ajqdi1+9IXg14Qar56oNHPOiwbS6HCQpnJCDhVu4FkgwTDFQIR6cBrtbQCNM?=
 =?us-ascii?Q?xzotdVINTWAC4uYgpdcrOr9V6aizfX+6bcc4k8s1dajd6xXyQ+njaTkUI9WP?=
 =?us-ascii?Q?ohHGPI4Tzz6BZV1nK7pX45Q+YcPjeYxEUTyCwXDawTZt2yq9MkcXI3+LiCxj?=
 =?us-ascii?Q?Re/SOZFuOPzhBycZX6Em7yPVK4chTixRuI/ly+v+apURXuELSvxz3b/AbCxW?=
 =?us-ascii?Q?XbNdZZmOu++08lwA9x2W9dheINwuBrUZJ8BliYMJ66qzv1dzXC3Q08+Z2+zc?=
 =?us-ascii?Q?pSEMLOt8t/r9biKetV4L4YoYilQSGTtPm8WJ1tNFoAjyVs/DhFjlNYReQmvW?=
 =?us-ascii?Q?iG/yhuZeLkE0dr1LdKnt/hSlsPJtsFXvZKyM1odsT9VZaHCAD7h72fIVArSQ?=
 =?us-ascii?Q?y6eqqg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4df36a6-9c85-4e78-8714-08da9bca9be8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 12:12:52.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tv0I0N30LIrKlLG66DwBjmaNbkvHj8AniH+EWRNA5mkwsZfCVHwMspEr57FrhbFkWsDtlot0iu44adBhgaXRV3CEkU7CA5BgHZZ7mr4pmvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Add support restart of link auto-negotiation.
This may be initiated using:

  # ethtool -r <intf>

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 00aacc48a7a2..ceda4d0b98bf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -228,6 +228,37 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	nfp_get_drvinfo(nn->app, nn->pdev, vnic_version, drvinfo);
 }
 
+static int
+nfp_net_nway_reset(struct net_device *netdev)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+	int err;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	err = nfp_port_configure(netdev, false);
+	if (err) {
+		netdev_info(netdev, "Link down failed: %d\n", err);
+		return err;
+	}
+
+	err = nfp_port_configure(netdev, true);
+	if (err) {
+		netdev_info(netdev, "Link up failed: %d\n", err);
+		return err;
+	}
+
+	netdev_info(netdev, "Link reset succeeded\n");
+	return 0;
+}
+
 static void
 nfp_app_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
@@ -1854,6 +1885,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 				     ETHTOOL_COALESCE_MAX_FRAMES |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= nfp_net_get_drvinfo,
+	.nway_reset             = nfp_net_nway_reset,
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= nfp_net_get_ringparam,
 	.set_ringparam		= nfp_net_set_ringparam,
@@ -1891,6 +1923,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 
 const struct ethtool_ops nfp_port_ethtool_ops = {
 	.get_drvinfo		= nfp_app_get_drvinfo,
+	.nway_reset             = nfp_net_nway_reset,
 	.get_link		= ethtool_op_get_link,
 	.get_strings		= nfp_port_get_strings,
 	.get_ethtool_stats	= nfp_port_get_stats,
-- 
2.30.2

