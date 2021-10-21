Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA04435E31
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhJUJtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:49:08 -0400
Received: from mail-eopbgr1320135.outbound.protection.outlook.com ([40.107.132.135]:58842
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231542AbhJUJtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 05:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uxiq4xNKf/qG569zFdraAiD+WMbA8KtQ1+rnAQEJEIqu1dRSPxr/BIMy36vFq7ilCtwy7qIP6f4Y+6Rb5ZdPIol810DEY4vc3gA76wVkSKQI88R0fuePLuxPIgXHQ3SMsRWiqSIc/n/7EvlqstpvB+62hJXf5AA/HjRQszm4JwIgfz+FFUvX2ue/BTu1Wf3lEy+MoEZBWLag+qCs/m1J8T5lDmgY/q41scGDD9/YQLHaULB4+OXCvRA0dTuVYd9QPyLtZwELnPCx9dK8KI9Pd5pBHVsjqhRgu4KueadluCS0BZgAt1b72+j+RcDNGcD9ngbhkYwq+xT3llKg1vcIQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKt2wK4Fc99juyDsluA4UYf+2a4pW3JddyZGqiAXjeM=;
 b=WS54SGt4vgngf3CrtIPct0Tk/maP50l24gvY6RojuW6mayGv5I6h5HpqO1ZQ8YsFkT3saXITz73wBgu6Efpp4NR2YqcJAlBK7aebCvIIJEZhjUSIodhjCblx08clBxCrY8yi/LXfHymwufHBFq28BI7H+Q4CcQarQUd3Fadn0XdWQ27DoZ2OhlM+gu6WjuKdgIfnF1PTe9d4dCSXCepMi/xcaFbILgWcKqkFupenL9RDaanS4HHh1nIOjmi1ZzVUEnpFC7tXgcn1hPNBqR/uufibVRRPuZPxK/zdyiu8lad4+a4l4vZxco4gusB86Pp6tdNl1XlKBxFRBJF6YD3aMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKt2wK4Fc99juyDsluA4UYf+2a4pW3JddyZGqiAXjeM=;
 b=DN/K77DQgmASfUUid95PCHlPN21JpJkIV9+3FxO9GBOxxhYgA9HfRjNqv4KAAjckNQAmNnV1CqzlzExjAPGrX0fdYsr9Xcwagc3SbDJlQYWm1XdxFchOPM6uzxHShBgsUad7hoiIE88W+aLHt2U94HNPwSofFNfD9eE6EtANsgY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3078.apcprd06.prod.outlook.com (2603:1096:4:78::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Thu, 21 Oct 2021 09:46:42 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 09:46:42 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: dsa: sja1105: Add of_node_put() before return
Date:   Thu, 21 Oct 2021 05:46:06 -0400
Message-Id: <20211021094606.7118-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0067.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::31) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HK0PR01CA0067.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Thu, 21 Oct 2021 09:46:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f31210cb-1440-4822-b1a0-08d99477af9e
X-MS-TrafficTypeDiagnostic: SG2PR06MB3078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB3078D6F9633A4705E8FAC0F9ABBF9@SG2PR06MB3078.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtm1tK0YCDb5L4fN9SqPF9wJRIWDLI5NVg2RZUmk8oH0DtFkhm7t6PwkgIwp8++MPmrZDMnKrBj61i3WcZBqFWgDaS3X/HDl5FO8ZaW7sNwOApx7h5GtQlDMUwCJZL7i0y4VprtaiU9/sgqEs/2zieB1VegQa4XB2UqrrRtVoaV9kWYPYcckmMUkjB+YWLpsSd93jmF2l3imL39NB9TTBXXEtlh6BQVq2bVBfjdqV/YGymLUF1VlHiBKRT4tAaj18aSzxlkDGDaPsUrETxl/jONJaEAAz00OoPFZyR4tu49fnJFK88mhg1YiSHq1erPVk+AxsgnZE2sfJyKsRRXVkahm/G5OWuARqCMxes67lEfBto1YjnJhlkUHT/FBUR+bA7A5ixl5+W0M1+5FFE8b8LHFaBwJt2mcDs/DzLPSfBr1CNLc+rB8pxWexB807xlNmr/GyCOercsZIkv2b99KkW0qmPHFCiWsIa8P6vzcZVd3Wn2A656J1i943jiAzv16ttoDI1TqEZOaL0/kt1KF+xSq8l9vT3+4cQKiHTDNekJUnoVZh90NaLIB5vJL+8vvPTevTtfStQEhL+H4xePnn4omm2On7UJWt3yRh8EiV/rHEji0QExCNQE3LVMRXRlE5a6gdpZqygvm/4M3TDFiOvEA9BiO5TZs7dEzEuMWBsPYK0fQQl3XAuSljwxd/K9wK2ag/jaDYFXPwKgmTeNt5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(110136005)(4744005)(36756003)(86362001)(508600001)(1076003)(2906002)(186003)(6512007)(4326008)(66946007)(6666004)(26005)(52116002)(5660300002)(6506007)(2616005)(956004)(6486002)(66556008)(8676002)(66476007)(83380400001)(38100700002)(38350700002)(8936002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5yTD858mm9RAoM95AS14IJzBrmvOyPLw5csu0RK7jkFGziBfqwdnVHXCqsyx?=
 =?us-ascii?Q?HCv3rrfYSRTcf639livXNnzInPXsyN8oqyuCnZvxdsZnmjPHUpihM1eFox4T?=
 =?us-ascii?Q?Q46l0NHU84jxzbh4YiXT36os+dc3ClFGRlt/1dGMPQ47A8ku5DiBU1ipWJXg?=
 =?us-ascii?Q?Oo4+n8M7+v1t3UBll0EgKI1lQuRzyZ5vDSIx7T5jWFnEC9FXZH8+2gqk7jzl?=
 =?us-ascii?Q?m9rPpV3h2n8YI+I6XNTXFypHoOA17of278+2YRFMYystiNb5LlzAP4Icmmfn?=
 =?us-ascii?Q?dALR3orzvcX2MW9YXnlNJnOx3B7+rf9MuYVadl0wHqrd1pT1IGF/lsBhA0Cm?=
 =?us-ascii?Q?8dAbrOlVwxy8YP7G3x/IiJ7IqNLvPd/l36cZZk46GFgW7ZbE2lm7mcaE8E/L?=
 =?us-ascii?Q?/qIGrJJWNJT1PHWcQQ4WVpeD3nn7sLyhFAKG+K//gBq40ITcg7HLAEVPNnh+?=
 =?us-ascii?Q?zOWmZP+nUdIKdaX7RpdvU764pCJe6yajHsT9GtWJ/gFbX2VNM99T6HsC4dFp?=
 =?us-ascii?Q?u8yfv3jbwAPAUjeMg8w7qO4C64CpN/YXmVOuUyNYhGcUhrEvXnUFXWUfBeQW?=
 =?us-ascii?Q?QPigGtbTIsmHFbHvFqkoE77zE7ZWW7LLuxcVBeiNvstsL4owAeo+TTGGNKXu?=
 =?us-ascii?Q?ymwatyS9zbOJflUAsCE1R/9Ik1w/Sym7JbaxJIX5kY4Ewctacosi3rrD8oW7?=
 =?us-ascii?Q?gqhFXMJqI/d0tbSy7pnFMPXvIpiLwftyFrVGeppkSxIWSPxYQfp5X5ogEMqi?=
 =?us-ascii?Q?MvhHy3AEcGrF8xXSsOxobzdB8WRNuxMrACVVGhkBIJFDSe0zvrS0zn5wRQxF?=
 =?us-ascii?Q?RZZmKd8JU25KQbfEjLmHS9DJVXzaRHXIhP6LcUawMafbwy24Mh4m/pzXqpZ3?=
 =?us-ascii?Q?Jf987T7KPXpIOWG4t3syfKD3THGZPVBuHhPv4/EtYjhsp0rw910lnyYPT/Z8?=
 =?us-ascii?Q?6HnYr2v5JP62Y+d/gZkd6mKQEgGwO3U9TtEL4z5eXmQp0eyb15za35IYFbEi?=
 =?us-ascii?Q?5UxW2VHLbo//FGMEL8kl5fcHGrz16GVczl2PZ3xRW3uzTXTt+2M8ZwJeFUdX?=
 =?us-ascii?Q?fogUP3Wy307DH1V+UnZWOqa4r92RmsgxDDM9tW0sCSJmdu0TQHUzGzGbz90I?=
 =?us-ascii?Q?RI9PdYVTgN3b6VurDScG5hR7Ws8LeWBXfN2qpjLW8iZ1B0P4xE82CGNO8EQg?=
 =?us-ascii?Q?lBPCbzYahAmdqiGEZP9cED27RJ7Eks4rocGGH03ZlT4C08JYC4ntX9rPgj2Z?=
 =?us-ascii?Q?KgpjP68xtkheAUW+TnsHiiNnKGnuiAD27UNmO5NZn/Gb4ytK5xqTxowBpYuL?=
 =?us-ascii?Q?zamye2Q/HE5i/ihyM6porbuJ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31210cb-1440-4822-b1a0-08d99477af9e
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 09:46:42.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11126903@vivo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/dsa/sja1105/sja1105_main.c:1193:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before return.

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1832d4bd3440..70ece441b3b8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1233,8 +1233,10 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 		priv->phy_mode[index] = phy_mode;
 
 		err = sja1105_parse_rgmii_delays(priv, index, child);
-		if (err)
+		if (err) {
+			of_node_put(child);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.20.1

