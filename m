Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7271734D135
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhC2Nfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:35:54 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:20449
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231183AbhC2Nfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 09:35:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My3ORfmPIulsQhhKtfrkipBPyQkhrdVKABhJNKeOn8+/iwbw+L1oqjvZecr1WN0MYtaDr9SX34LidHtJ9Ve/rsnDT5nmnaPduHd+XklrHV9aR8zYNBDClGiXsQAm1QbeGgMm9XBfeKsHDmxYV9dovCe9uCIGnQA/aeEu60Nnji6jJuAIUFs03osIzHoa79G4I5I7i2T4hJVngcVviMQeW3Nf71hghf0NnIbLmqiIDPMfrwLg0HF1LG1HebjmlXUEG5NwGBfvYNwkOandRRKbJ0q6FNEYM+ZuQEKK6caJXjVjZTE+1a7YxBari7l5XuQl3a0pYpMYG3IhaSgGn4GXKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQIWTKHPPV+dsvh2PEBe+tOKRSYXejX1sLhFrZWln/M=;
 b=eOCPB2EkQety9g4cGVT4JqUxZGS9GhN/PatYXKq3eTAHHcAcxn6mukhTYmwjK1h2kuw08m/0tiNlq0FRQ9DG6zflgT2lIQ7+HOZRic+Y5S1QE4SK2vCqwe6NlHbK8trLK/AFYlxCCxCCO35AAYc9CLVXlwJD/5kvVGclNASw8Lsm9EaGuebXM0bu6enTyU5/9PqZR/LZH7A3ud5MV8YKN7lhXRCo+yq+M/wgbbjdtYJWuHciu/GSrgzSs3BOS+I8bskj+M2h1tJAMLpYnTYAPXHvsjW5UpZ0xJG1PleOczn/F8PC8en++DyvUOGbMi6QjlPiPsg4XkHHa2B6Gy1wmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQIWTKHPPV+dsvh2PEBe+tOKRSYXejX1sLhFrZWln/M=;
 b=iouQ5lZIa+aVhI7lQ+PtNvEo6nU2v3FiZfeDObhu/awq34PrSYDe03DAwR/y3a7gQoIuOL7t5XZLa4Q4tQiNYN+Bx+6gMxqWbhXoYDbi35cJOK1b858d5ofxnFNfPeS5m6b5tXm+S8gB6hdalgTFfbnjCUPk/KsKDcnWKEM2AII=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7473.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 13:35:44 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:35:44 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] enetc: Avoid implicit sign extension
Date:   Mon, 29 Mar 2021 16:35:28 +0300
Message-Id: <20210329133528.22884-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:208:122::40) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0027.eurprd04.prod.outlook.com (2603:10a6:208:122::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 13:35:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab841056-a5ad-4e3e-b13a-08d8f2b78d45
X-MS-TrafficTypeDiagnostic: AM8PR04MB7473:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB74733D26DFB44F72518352FF967E9@AM8PR04MB7473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZWgO4gwnJVDeJdQSvaAVVmbQ5kV4nJpMP9bJO/5CeOT30fFqQjd2ItncG6VPe+oaLx5DGNLn2wCHKT+nFBkttWt2hsEZSaLn5ybUxPLEbb5CrjjB4ldxVrlqWsVIK9xqbS5l8M2uZ6Q1qJrXUm/guhZOq/3hv4d95zm4H5ZhskZVJ+Z6RuCFysDxzUuBANDJ7qNS8MUs9+ZZ7Xk5eSXiqge1VSxV1lYEoAZ/cuyK89XLs3QkgGj4/2nSS7PcyePzi9iGrucNI5CXuSwzCt1pP2H0vZtz1F8N/uPajj2Gw/1bZ1agOPiGRog22//r46IcSKxKoD1g6YtYZh/3GOrnz4rR9/CyFh3QTF38sSwifCmwGohqCihMdOH9CuHwo2zjMnEhhaF5dUX/7+7LB45DC+grY0zOxKwEjwTP1NUO1i4208XRhMM8hBzrKNg5MeLdlUo3WmyKhqgBNoc8a+/31ibTLXDL2AuCfrXl59wNMnCJMepRUbu5YE/+fB70M5vqS/q8dCNdOPGV3lmKHcjD4ZS7FFaG2YqoTBMo4MYggdOKgfZPPe0k9LNWiGq0JdAXEK4cr9zkeJ9OJ9sby58VCioUpkl9f2tCpe8FmoRdPW28FKzvgfmIA9QkwcAnJ9oh+F5Z/eaIBkbHZWYV2DWxa4D7rlsye+McMXR8YwQXFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39840400004)(376002)(1076003)(8936002)(2906002)(83380400001)(478600001)(8676002)(26005)(186003)(6666004)(2616005)(44832011)(5660300002)(16526019)(38100700001)(66476007)(956004)(66556008)(54906003)(36756003)(52116002)(7696005)(86362001)(6486002)(6916009)(66946007)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3ttuudZ6i+gLHoS7F7ICwinqqverXrqck2gSDpasQrL6lIVqHsAr4W7TMyI+?=
 =?us-ascii?Q?GGtSKSb5eLFF587d4sTKMFA9L/xUwAFgdF4c98UM1/jewcEvFK+Y9GAl0k5R?=
 =?us-ascii?Q?dVqCCMjgyipewBuSLlwK+nrgMOw9Jsvr0ofM5O3xed/IkjzeqFvowWj27Shs?=
 =?us-ascii?Q?NZ5fAbtiYV6KIhtideCtjGmHkH2wNQFUKGgYokEcrKkuZ5lsb/ceHaqdyKQW?=
 =?us-ascii?Q?LtZ3QjtX06QNSujMRFFqA9cnO9dQ+J2YdzszOQ5wJTq2L555xCC/rqopBuXr?=
 =?us-ascii?Q?BlBuckSMpY05svUwDYt5+/p0kviifpQ6GYXDnT4MgdKHfrfXHb2xWXztnQLP?=
 =?us-ascii?Q?zjgEVPtV3szhHQamC1bUBbKX8sHDtd3LzPc97prt+2WWLPixCMo4rodlG2UC?=
 =?us-ascii?Q?b8FvGFFRz2Av32OVgHSUYaDlWuQZhypL2yBTycEL3fHq4O0qDmwkzFhTqRrM?=
 =?us-ascii?Q?OdMvk9KZsLPxDP16I7qoFiW0IHTOknbI4DN/j21boqS9UnnSWyxiKFK9arUd?=
 =?us-ascii?Q?vWFywhocN3pfpwYMIMtXBipdjE1B1RBCY8JJo4yor7t6xL+3gmY5wv/R226p?=
 =?us-ascii?Q?SZCeHtQ3jmgV0B6qZIHYWYvwns3sGfA1X9Z6vasb4wEctrhEwpXFlMR4MWuN?=
 =?us-ascii?Q?Ss1Bd1PQ/S15ZLr1qIVYbBG2UXsVoNqmN/FR3du2dr0wick5FTacMH3yI+2K?=
 =?us-ascii?Q?pDHpok7PuzEbwQ62TNPMlrb8xRgazibh+gOVoFdaCeitsFV6iR13cWD3feL5?=
 =?us-ascii?Q?1r42Nfr+F0SqtT7q5FhcYYckbxGOYjLPl2rewiCQGweato+rlbSpNmlXYGN1?=
 =?us-ascii?Q?Y+UeWTSe1ZlQstioUSKrLEDmedv2MyRcESzw2N4269FiL1Tqzvh5x0v6KWtL?=
 =?us-ascii?Q?8pyP2QHBDtLMvBRY7UCtaJzN12NqFpmp5CnzxlFf7yve8s6bAV0cBb6nli0J?=
 =?us-ascii?Q?1pB3kEunoP6IynokVhpom1rH9JTjLHDZv7jYcFRRcGJA8r1dnh0m5YglBPD1?=
 =?us-ascii?Q?b0orQFROJKfWV8hGPdWA1ylmX4Z102ulNR/y3o6bP/Cz5pHcD0lTz0wqh+ZQ?=
 =?us-ascii?Q?SX0W4IIgKmnUiXzWPZGGyNdLJWQWGN/cgvG7Xop+GYFEaMkmCcg1bQisRMyM?=
 =?us-ascii?Q?wuufvg9l9+on6Ox7dmL7jG1rmmCNw6pmHMZgWNNkdJGoh8M6+iNcp434ya0z?=
 =?us-ascii?Q?z9DSJBsenixW4je6oDRwNRbpF7O9s4o0wvyy9FeJjW557UVkj2rJtiJS5OLi?=
 =?us-ascii?Q?iqFli3q+S8xaFphiutrrZJ5I/sHNs1e61B5J1So4vRfj5+fxlUC31hBT7vAO?=
 =?us-ascii?Q?kqX+UhfCmIC8durFEFpH3J1W?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab841056-a5ad-4e3e-b13a-08d8f2b78d45
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:35:43.8985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z47BhtMbtqlY3gaPeu3ss6T1wrd1jNqcIKyzOI6k946Y6Zp2Ro3dBHdrpjqyHxPmZQz7SjZntRTiEDVU5Atvmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static analysis tool reports:
"Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
then sign-extended to type unsigned long long (64 bits, unsigned).
If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result
will all be 1."

Use lower_32_bits() to avoid this scenario.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 00938f7960a4..07e03df8af94 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -535,8 +535,8 @@ static inline __le32 enetc_txbd_set_tx_start(u64 tx_start, u8 flags)
 {
 	u32 temp;
 
-	temp = (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
-	       (flags << ENETC_TXBD_FLAGS_OFFSET);
+	temp = lower_32_bits(tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
+	       (u32)(flags << ENETC_TXBD_FLAGS_OFFSET);
 
 	return cpu_to_le32(temp);
 }
-- 
2.25.1

