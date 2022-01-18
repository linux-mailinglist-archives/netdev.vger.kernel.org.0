Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078DA493011
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349466AbiARVmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:42:47 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:7967 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349436AbiARVmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:45 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBseYa030788;
        Tue, 18 Jan 2022 16:42:26 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rt8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mz/m22+5qzy9HeY9jdJaA86p1I05W/glSt1sO8sw1E0KZQNejFebwd+cslzmW80tVM1DTZ9/32p7LyS7+bytFWH52nzz3J2th/00JRZRbuq8F+l89fOj9zUk0w9fSaDlBzajkmfMtdDi46pQHMUwzijMwJQCViFhZ+Ie695Y0vm1pU5tyvwsqVJS1vzPU4I6ts1fbfJDWJ0VcThdJl8uQoewPYux+PCJ4qnen35yUkcOcbKNLGMarkQLDHmlF2UtqzeLL6f/k64qD1Y6XOfYCpjTSvYRQ1Gox6TwWElQxxrQHsuwL0xrTVUJRp+jIdIj3c+v/idRABcKaG/SwKvvPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQDwv7K5I92pVNAUfKU/K6FGICV3JjVTyK7hQ+R2BWI=;
 b=Efx5wus724uJmWwcxweHwC86vU9IGiJ72lmZCOTag77G6t2GUoSReCcOSEeuo93MNfbAMKMOyWrZdizkDOmWkvj4Es5y02J1G8Xd8jdND6czRz9aUsdQYx40XePhX0Anzxjx0uJvuPPqsoQyptqim/3CcEXV8QQuarXHYqnWxlSxknzXGJPIdXMxSbk9uTvPuLXI0uJCoVALJfrNgKubxA9osmtmOoid2r+igbfW1DS1Pm1Xhi0Uq9pnmz/QlxrevTF2EbjFnqHIgO0s6d7aqllTrIQPztGeVjzgcJRCbRWeVcBJ0K/aRe1NZX1WcleCzZ5oD/XfTKclZcE/+00Sgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQDwv7K5I92pVNAUfKU/K6FGICV3JjVTyK7hQ+R2BWI=;
 b=GKciGDdrrCP3DqGS4Ryt//YIhk+kdIbqMjhbHP51lclVw3c49t3u4+e0bdh44sXpbE47Ywqprp5mw5XX3/FHUsR+JLCeFaxSWIWotDRvFbv+XUf9GrctlEyfR847diDA0ae0u/9j+gndfc/IDDrU1KUbzKLyRB/LjenGr2Quk5w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:25 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:25 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 3/9] net: axienet: reset core on initialization prior to MDIO access
Date:   Tue, 18 Jan 2022 15:41:26 -0600
Message-Id: <20220118214132.357349-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 497c4ec0-5ea2-4271-11a8-08d9dacb6ab0
X-MS-TrafficTypeDiagnostic: YT3PR01MB6003:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6003B6BED434F94CA98A0884EC589@YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leB7gjbBqZECx73x8PSxXdAO3Dse8gx4NxL7OySF1Exye7DmgFb7XNM5hIu4SaSkCkAAZkrQm9VI8HUGCWrJEWceKhP4F0Oakitp//L11ngEWfrYav9EF0sW80Z/iAVYAVK9iQ6ciinH/9pEk3r7MCZYIDkpmAe8QZVLGhlP3D43JlMbjIYUCm3hXw0XXcG8a1G2ovVq4gIYdAJ4pV/qnztIKkcCOqZLplSUfDA5J+OIEcXICOexB7hXhrHop2E0Kqixal8FRSd9lXxisAK2AFW0Szc2JUdFmY3bUDMOXUvveVvhmPu9wCjVIT5USh6yZFMYyLePZT1qOctHW1588AprkFFb2ts8r8eFSYlHhaf83hinATqOBukTu9JVg6L9JWplR8N9HNNYTE6fqkKx63use/df+41w9y22hi4bHrH1YNQQtNG3QzyBsluzzfemjG8ZgwFWi8KjsD3Z7mze6GnLQFJIQlVxtdOF8j1/ShtFYmUIf/6hfdw14fkRlALervuOKNe0CL2uK7ak3llzgs028XaF6upVTWKDX76tXe+BdTewO0A2iKrjwmgJ8wX98kqKEfjBH3oJeBqXxtB34CibXtuV2mdDaUuUSsZaMq8EgL9R7928oQKoApI9z3a4UJWB4yLlMdGbPxLmBFWsp3MzCOzWjDhQQzDAH2oJQ/+VsIyvAy0ZJrZujegM/UP3lS46bYAoqh+t5pqMEBQO7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(1076003)(66556008)(6486002)(86362001)(66476007)(8676002)(38350700002)(83380400001)(186003)(66946007)(6916009)(26005)(2616005)(4326008)(36756003)(508600001)(2906002)(8936002)(38100700002)(52116002)(107886003)(44832011)(6512007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wY8mMLWhtieIBBFjxYgEAyWlda2uLgf51yW3BcMTzOVX0UaoDN0nUzf84mM4?=
 =?us-ascii?Q?xk8Y0JyVu2fdnhKCv3G6yebh0l6Oag8X3jtBWMTxPcB7YuCKfPJcZM/ankyI?=
 =?us-ascii?Q?YiD9Cpc3Y1CNWqmEZ7p3OHrNhfiYA9jZepvE209D6+/4dhdiErJ+QzEKli8W?=
 =?us-ascii?Q?SKCJCr3AlkjLBrVRGcWsGuj2gKaLeJL7Kza6iSlVTtPgKMbhXvOW1XKPasNI?=
 =?us-ascii?Q?yQQZ9y2oMOxidZwEjHIsBJX0cPDDIIv02xXhscAfc9IQbhFB5r5zFehdTsl1?=
 =?us-ascii?Q?+ytyPogJb+T/xWDKy/BHrMUx/1eN2COnqWDKsyanbBHZKb2lRWK6bs5P709a?=
 =?us-ascii?Q?73IXDDUhtbOKoAJJ748E/K7qsRDU/gu711i4a6k3QDq0DzF/Qsy1SDaKFUKy?=
 =?us-ascii?Q?Dk6RkE8qfszchhRlaxX0nJ4cz5h0bHAF9OwrXcL9W8mGmKrC7gpolD6sTAh6?=
 =?us-ascii?Q?hAKkyCmHYPQ3Eu9Ho5doUuMpfjvKjJcgheM7YWSUpNKydfyaSCiD7Flz87AA?=
 =?us-ascii?Q?0NeIl3nRDnCadayjMJ6Id8mc4D5KwIOwFndD2YkjJpmVSKtOyBwwd+NpjxLU?=
 =?us-ascii?Q?wkb4XPYEnFB6zaQi1h4LSvBEYYnJf0c6DIULByVXw/e2O7IOl4zsjvk3YhOC?=
 =?us-ascii?Q?eUm8MGp7Uzj7b9SOhDP3dsUzqiyEa3H7UPlVoDJfs+OIsupKW9ok9i3g9OGO?=
 =?us-ascii?Q?T2GaUuA8UrWeYdH5ZUTH8BaW5yAaTWMClabqbvDAIxUSupKZFOIMJfs5iwHU?=
 =?us-ascii?Q?rPldp1KKVmpFH2rwJUfvdCezz+ilucEMDWJYMuv3gNHQ4Sr8ALdm6Wa/svfd?=
 =?us-ascii?Q?fuaaDyaR4CURyJ6pHj4dm9xusA+VKG1niF1DxR1Jt0IX0m7tTtoW4wpc2ZBd?=
 =?us-ascii?Q?fFQlfpU6fvx/5DpVOzIKhkLO+cZKLmK2cEqAXZ51iBq9lJV6gTyqMYwzNkrr?=
 =?us-ascii?Q?rAv1Xo7pEk2cYHtpZNjQyJbztpHoFzo/YHGAIo2wgBZwPRKAIhGgFrvuTxsJ?=
 =?us-ascii?Q?ixySERZI54PCXOTLwJlyOPV45XZkes1bYzSyJz7mOyUgdAOupiy9h4AZdQKy?=
 =?us-ascii?Q?0DwPO7dr070ZaUWVj95vP2miV2lJ4qZt71SCD4mcnvQoIJSftZnKfq1nIxq7?=
 =?us-ascii?Q?/Uv4pJ50POI7HMbU33jr4q0ndJEjCJ42Pvtxdj90et50fHidhBSpHIvww3rA?=
 =?us-ascii?Q?f5dD7XRG0iPeOaNbu00w9N1NEev7lWF5gnd1Q5MvMJq5vkrciCO0rHCkR/Lk?=
 =?us-ascii?Q?KacSorGW44zDLVKlNj8wutZw2gj14mWME45EfEXpSa5R+YYzlFEJDOCI8Iki?=
 =?us-ascii?Q?k7PwUfVfRVtRJj3gdBvgbzP/BdhvvK8cnEbtMrQjLnPThzcKVGX/3uUYR1g7?=
 =?us-ascii?Q?/YiYE5IAsaPYmVw5mpCqwsqBtThLo4efnDXRlvUZeu16wsxFhX/PxAels0Wc?=
 =?us-ascii?Q?RDGoKNWDtXSQ7GQcKutzwNSstQ6utUxo9NG8sgy2Zc72VCNhqZTJJ1vSj6Jn?=
 =?us-ascii?Q?Sj+j7s9YHX80LIgNjUMIQbSuEawsClaAaLv4IHqbblDVHibEhycJrtLYUNVc?=
 =?us-ascii?Q?zu2uMvZMBKXif+Bk30CX50dtAJJBXDQRxMyv7+9CB08si+n8+rBUlDr17AbB?=
 =?us-ascii?Q?Ufmqkx21epVASLNhaK/39axpweegZt+S4pAqgcnyUIZVWMNGgJunDQuR+tls?=
 =?us-ascii?Q?AbweFiSVbPEX/WLGuwm+sud0awg=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497c4ec0-5ea2-4271-11a8-08d9dacb6ab0
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:25.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yv2Q7OQd5zn5vV8BF6WXSAe8/Eg37ETfgAvTVdlmdAB8KG5Sn/gxVa6Raj5Cj2S7lFFR0NJ6SGQgzUPZj1QXUTcTkr+tIZ8titYAo/ZrKkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6003
X-Proofpoint-ORIG-GUID: kJuxFHgu2Qlihe8GHfcT5sIOQkmzBieW
X-Proofpoint-GUID: kJuxFHgu2Qlihe8GHfcT5sIOQkmzBieW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases where the Xilinx Ethernet core was used in 1000Base-X or
SGMII modes, which use the internal PCS/PMA PHY, and the MGT
transceiver clock source for the PCS was not running at the time the
FPGA logic was loaded, the core would come up in a state where the
PCS could not be found on the MDIO bus. To fix this, the Ethernet core
(including the PCS) should be reset after enabling the clocks, prior to
attempting to access the PCS using of_mdio_find_device.

Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3a2d7e8c3f66..53ff38cbc37b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2036,6 +2036,11 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
 
+	/* Reset core now that clocks are enabled, prior to accessing MDIO */
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		goto cleanup_clk;
+
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
 		ret = axienet_mdio_setup(lp);
-- 
2.31.1

