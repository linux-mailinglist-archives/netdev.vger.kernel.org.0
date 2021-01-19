Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DB62FBE2E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390931AbhASRq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:46:57 -0500
Received: from mail-eopbgr60117.outbound.protection.outlook.com ([40.107.6.117]:28545
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389168AbhASPKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O17bhMdIAOttFprxtFFVwd0GTA3Ltfx5VQcMcgCxpLTxevCXacVrRRABwSs9djVyWSgu9tvAgNKaXt78seI0jwLRFGDGUDudfQjg5qu/woHRMg0OzW2JLFJdutf8uRalaNkKwHnorjOn9CugoNwr2t7j0oy+C805lntP4ui3iyEjBmfTHjz3Xaomk6DbkqtY+pA/CY4iq4GR90GRe1Tv4w4HlfYklhqz3ngATqdVE0YRjMVWaqudTt72Prw0sGS7C1MGEI+LhWwPqAGhYmkRHKX8RDc0nTH33Ku/++y14lduCNghSz0iHTTQFu//dn0Yy+Zq9FUjQMpEsReS2vq0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lBctH3herRrtuw/MJm5z2mIo2l5pPOAKd+vYAiDEZs=;
 b=ejVLR6NNyoqXjineak9frdTFn1UGUOW9l06QL7LEy/Nlx8jwEvIaplpaYy7VI/OXpSGssenjPaqGMXXRx0K5L7V96d1wVDhXAkr95BFNcHRmsM6wvLzGgtCR56BCoaSVIG/0pcplq8FHvAe6NQU4vqGtWFyyvZ396WAeaICM8UlGeYUsKBNX6cdTXFBkYdKG3dZWcEMyOhHl5U3PQXphw7kVHVkivekx40Uxi21WQFUevzYvq0l2Y630aSn1pHr6V/Raeib66AaTqX68idNJUAskPJFJijqxKRICpcAeuzUcg5PolY7jFEWnskfJUfUbm+uS5NU1V1k8tVMWjWEsJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lBctH3herRrtuw/MJm5z2mIo2l5pPOAKd+vYAiDEZs=;
 b=dvo9OVZ5hqK8ISzT8mSqOGFrdWwBEynl3SNPe9c9QgoSqfTOtQkgJ1oTTYD8/sGKQ/KRxMhlic9gfezqLCryJnvwf1Ce5BghzcMYF9223Tlk7hH8BPk3EjPWcxPrn+s6pBg0+QJJ/7Wg/IHGPfPsqqpRmpM6Xwg+MiSlkTx4U9c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:08 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:08 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 07/17] ethernet: ucc_geth: replace kmalloc+memset by kzalloc
Date:   Tue, 19 Jan 2021 16:07:52 +0100
Message-Id: <20210119150802.19997-8-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b9c0b4-66f8-4644-4090-08d8bc8c2b5b
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3681B7B8B379F405A254708D93A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rEW/+G89UEH2i537WBvplSMcZZIUdg2o2dPMJ2bWv2blfE5pNsx+38aWh8sfTamZSb8+kJhuCvVO/Lz/cIHS9jtt/IfJgCiqb0EbUbB+i7gs8Iv+tKW0THjedPTBS8Xl8W3iklu3WRxE1lwtdpI5JJZfU71sODyawyZZFUmbdvGQJwOBuasPmqNeVXRCLcTtiowvvOC4dDbKHPxJ2QV+24GI4WN7EMYOIFs54MdL17NgNMdCA356EZ4BxsLez00grX0/k5JllyIVIVu+KyW+Gs5/n59AdzD9q/HxjANSwqeabXfyylSec5cGht10o/HE+3uMUfzrQWnwjF7QmXpybWr1ZjxF6fC9yOoxdlV5jA4EvGw+mr8YO9artxR3mryT1WjZ/s0VXorSfZpRI7Blg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?z7dpzBOtVDjG1afbsb3NxG2l4sII555ZRnpqfLSPaF4i5wqOwtXwCPO1E4BI?=
 =?us-ascii?Q?zjOWTB4M0YLvy6bTSxyTJL7eT7Ek7mSRUj5ScZMGxYJXV59OqVSzggaX5V3d?=
 =?us-ascii?Q?FazoXa1URZNq7IILPph81WukL+5CAhNsmvO2WGrj0ZlUwBvpiTtffRM9wPH1?=
 =?us-ascii?Q?yPW3O6RX0EYebUey8gvGjpappDLFayvEQVKycId17+nfG1zWbMXVlkw4SI++?=
 =?us-ascii?Q?V8eyWM8Bp8XA+rGwNazqSnyEMsFmKBlnLeoNy2wzFvaLvbF8KaObYqubYqWg?=
 =?us-ascii?Q?qFUlO0tr/Mp6ngxXvPauz9sElztfoWmKV27d7RdjNB03S1CD9Z7uZUoGTHVN?=
 =?us-ascii?Q?TRLmsa5q+RE5A7MX1RbQY1HgTp6X1FNUv7Qw5Ko1e+gFcAApLNF7ikNnWt40?=
 =?us-ascii?Q?2Y6rymCt3GUWsehSlk/czPsCZ9XwXPKclirDw0O2o3qLFTL3gJ4J0i7aB4B3?=
 =?us-ascii?Q?dOjAv6+78Y0RNGmiiaVDY0cOO2lI/VQ3DsXC6bC5w4Q9DDhT6XKMcAU+Ax7x?=
 =?us-ascii?Q?cQTfcSq9eeanvDG7rJ6pasrg98RL3yJShCTS3UNJqbrji53LlvfFolU9bVbP?=
 =?us-ascii?Q?AWbNcpyaOOLto3dQLN/J5y7g8/6vEBykA1opTFFmklQtIXBAS5Hb6X8PBBGm?=
 =?us-ascii?Q?kmN3SzGNshh9cht3CiS2xAFmwwFnDzmQxo9NF4c6OOsec+Kbfc2wPidfwa6Z?=
 =?us-ascii?Q?fVsTQYxZMZaXOrAxo+5vNjBH9cAszIf0q0NfMwUgn+si0J4SBEsLXyY25hk+?=
 =?us-ascii?Q?Ie/D+E7hNU1H7SxHygADu8ZtSUO6lBzPvnnOH6LKe4y6k/l5jZkQ8/oRUqam?=
 =?us-ascii?Q?hGnLWvs6aQNJMJinOei756oc+3U/Irw5IwBq0+5z/DE/RutmSxXwMfEHBw7G?=
 =?us-ascii?Q?y7/VAtaVS9HIdRv+VI9i3wiveBEGZ0/GoEVcotXiEZ21JaBOqwRI/7z9kYNB?=
 =?us-ascii?Q?Ulyd5MZfvxS4oSl6nkubPPKg+uZ4ios0wdsTkQa06wxgTpsV6vNGcULhuvfJ?=
 =?us-ascii?Q?yZ4i?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b9c0b4-66f8-4644-4090-08d8bc8c2b5b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:08.3847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF9K++eAM4o+JYMCTb56mLybpxMQMBn9vlK3RNAzoStis781bC/7wtMAy5Ezz+/2RIgSQ72ntOKRuTcmXYgPhH+8BqgmrZ8klrOcef1A7hA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index be997b559577..74ee2ed2fbbb 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2904,14 +2904,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	 * allocated resources can be released when the channel is freed.
 	 */
 	if (!(ugeth->p_init_enet_param_shadow =
-	      kmalloc(sizeof(struct ucc_geth_init_pram), GFP_KERNEL))) {
+	      kzalloc(sizeof(struct ucc_geth_init_pram), GFP_KERNEL))) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate memory for p_UccInitEnetParamShadows\n");
 		return -ENOMEM;
 	}
-	/* Zero out *p_init_enet_param_shadow */
-	memset((char *)ugeth->p_init_enet_param_shadow,
-	       0, sizeof(struct ucc_geth_init_pram));
 
 	/* Fill shadow InitEnet command parameter structure */
 
-- 
2.23.0

