Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3525745F305
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbhKZRfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:35:02 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:26784
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233384AbhKZRc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:32:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHMpq+kYk4SKAtDI68Z2BITkUQLJ3eMqDhsit9id6YiBC8cqa3gRTgnoBC8nYeDK82wNQQYWRjq6s/ZuVktVqfeqbzswg4uOOzIz0bItkVLByUNcXrrxM5S8sLOVrJ/gK1n29lYJZ/x1GEOxghoPn86/a8Na09EN3iLKhCWb93xBxcTMYUxuu1xpOKyEViYgQb2vJJ8zBMM2P8ILOfbHFv5L0k3Lj5zcLpREDX+XKnlqBCLvj1MUrfhivL6bpzCw6hOCR3zBO09Rz71a0ep5IOPpyTLtL2dyupqvv0PjL2AF83p3s7R5Y4PGKy6NygiaQbOmLmw0KrxZJad/M9gfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VP5tOnT1Xc+t5HTkDqtEUMCRGbzRxM3LBSLrbBgILuM=;
 b=goxAjlN4xcz2pRzfgaQgoD/hP++K/D2EX338m0bherpCfD3yRDcXW0krCaaUlNh2oUuNEIbTEgzCspsrT1hQO4Y2cR2atobAxV/KdfvT1WCt2cYtAtuuVFyhmloXwJI+RV8y97m8JRZ8SzI6/QWPHfQHOsy1mrN/ornm90/NZJf90QxO4YkDIgi4hSVY4Z5qF6T2Y+0tlIzzS0RmKC8PQii23t2NtoPpHFoQMf5yrnYBnog6hxWOdXKQ372yfiIu+vVVsW/YUXFHphE9UYg3ccRCmSfNPQnkCNkgWmFoHi9iQ27+1DXRpRghYJB/6trTMgnK43+E7cqTLEdgpPDkAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP5tOnT1Xc+t5HTkDqtEUMCRGbzRxM3LBSLrbBgILuM=;
 b=MYiMxP6jsSmv96abxWU5NVv0/jSc4qluIiOuKWUzB2CtCYaZkUkZlnVv4u8keHj6GJgSiYeWcge9UebNHNurUm7ik/H1iljcigLyA+uYELYqYYKShAbKRQCbOLGMxUPviXfaaVb90pF7gODwqFrSF8wddyjTAFZ+t3LByLc5VNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH v2 net 2/5] net: mscc: ocelot: create a function that replaces an existing VCAP filter
Date:   Fri, 26 Nov 2021 19:28:42 +0200
Message-Id: <20211126172845.3149260-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:29:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f777040-87fd-4a4d-d908-08d9b1023e33
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66393E717AF7D7B8DC2CE52AE0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6Dg7YGSRTyNZK/zyIZKNmqpQo2loLLJ2RSw6yxihOVgjfFvKWxnwV64P5G/EpEBWylus3Sdb3SwGe7BZbhrmb1jJoX9UlN/AxfKIY9j0oaOvoujzH1oIzgP99y+1NWYnJDe1wrBleOausx0LoTIwCuw8MQhnxH8AcWaIKefEgyofW/aX8DS5RXUNYzv1EIXS63fW6dLMXfCXNmpVQ3eTalRnx8GRJDTqbeEdU/WlDK6K7J7iflyG9BsJBtv73uwZkyiiDYepHxPt8mI7fETrC5M1mIGr69f5JOnxCIiwiEgKjqLcrmIqAWmZfBqPjFKPyPFlHI8QB3h3AMfNdIYFcJ84SU+Tz9DoF/O0wILHcuPCa1BwAs03WWosJ1XF1NXLbENZcII7AkruK7ulVFBn0y6Gl7DyMfPEb5draYjrlpUy6XerKjHAOoKNr3C6XW142b/8iqe0rh+1WaeXi7nx60oBs+CiW9L8iTgoeWyVv81NvB5BF4XmFpI6XTavklZiyVxvU2/I1B3EpbP0Qc2ZdkGXestcDqTlkWwEHl/xcGIDYYTHOHHEm5C5AEB5PmVIhA/7dNXi8uKFGpqbtQTsFVpCHi2TFzf9aznIXDxXQrXtvSqLrNOJtkdtAo0av9nRzOTKSd+hd8xJl1uXbvTCSgLmjzzNcoeieGMlVGBeBoXE8vC3MDOgD8ZSWqBMqdA8497X/+VPwDC5KBtFI3jeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(66556008)(83380400001)(2616005)(5660300002)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hlr8JciKBtDuRoR003k6AUfyR9jl3RphItV4cdGHaQgG4uEWY3F2+Qjh3Usz?=
 =?us-ascii?Q?3hWxMYDAnt6MEqWouWHPgaHIeoto6k7CMITWjKMD5ceDjm4NyWuqvFkoeZdF?=
 =?us-ascii?Q?UT0GeKmJv8JnNiYKQtSluiLqJAVamRjyLrjvtnx5mMY2grXddWPGpy6005lm?=
 =?us-ascii?Q?RU/bhRUqDjykuEAmR8jhZgQxLSp03sPI5YgjpPg+9dwN90OjmHXO1A/EBiCm?=
 =?us-ascii?Q?ol53KckCxq9MKkdAQ2KaYdw1eXQtawTEa3RaAY8kkrKwLssDIXUaelGwZRJz?=
 =?us-ascii?Q?EKPPGWl9rzyNWc2wmFTOZf5o/anuXyRxpiCBi4RNMSv1KLgkhpECvkiA00sK?=
 =?us-ascii?Q?0W+shMueGld88vn897Re0pO3CKXMcqiwFHbwPTCy1Iuud5AbI2x7nR2smvT8?=
 =?us-ascii?Q?60OWpv5N0noeXDl61ImWHtj9QYyP0W7v1b/CRIenLefTBl4f+GPOpFnFJuLJ?=
 =?us-ascii?Q?VCkjX8eNn4fPw0pWX7QYuPzJp3/HromOlvamhGW8NYpBA3CjAFqAomtK2eFW?=
 =?us-ascii?Q?miHSD0Wn9juU+SfhkxeE8zHPhzLnkOBAQYxeI/QgTRDEgDmHxmkOT+gSdzqr?=
 =?us-ascii?Q?8sogT6m9ZIJMLroiotf33y8ZzmQldKIwfyKhSO+Zbo2nW4bLcC1NfjfTR9+S?=
 =?us-ascii?Q?K8SFHNVm+08Q5U5FNegNdmXN7tThcQn98zM/ZDuTseHZrmfdtMlSotuiDImY?=
 =?us-ascii?Q?ZdGZV1+VVwtCKReyx7UnfxDyJmcvVO8JLmH2htHO+LDQ1j6mc9mBeJKeOw7s?=
 =?us-ascii?Q?Fr5cu0ahux6QczIIMr80Enhz6GXwo1vpZYoPsevhr/5G88Uf69af7qMtsyJe?=
 =?us-ascii?Q?jZ3+z1b99TmuW3TJNxx5CTvzyImBTLBO54o/VT1llMtnerebxGhEi56UgzFs?=
 =?us-ascii?Q?6TW8MyoSxNGwOaMqcjulN8spQIUW1fPzm6RdFX3L7qChYNiekjh7WGgX5g/P?=
 =?us-ascii?Q?Kl7enlGFwMc2uZ2tgNllst3Ii/Hnpz4bpXqEb3mUKketvd5OFH9C/BQqv//w?=
 =?us-ascii?Q?AEXCDsiBixjUa9wJWmheO4l4TFDvCAX834iXsRkYFwjLQFlwDHst+HjxvoWX?=
 =?us-ascii?Q?WUfDHXqIZSpF9afHc6f2sVG3u5N7lZsOC/QPxiSwv82rULOWNZKX6gEYSm/y?=
 =?us-ascii?Q?fUEyda5BlO7FS5DKFSiTPrmbcUvtdxwrQN0O7RrCFAKqEaoDOg5gJt1AGS6R?=
 =?us-ascii?Q?Ge5TuoZO3Junfx4TolZjjToyVN3GCnJpTlpQQbK2vAP7zTa205j8A4GQkvmK?=
 =?us-ascii?Q?OyX/S0JEmpZlzp2zFyH9Dbba0yPm794rmge7J9owFeZOwJ9fhNBtgaai8NK3?=
 =?us-ascii?Q?XXMQMcYTPZ4ccP1sWYRAD8z/gWSbKhQ7NMfaOVFYZC4Hh8IorbezZygOvnG0?=
 =?us-ascii?Q?sjjRG/PH8DxsfcTi8P9cENuMc3mjMSaH6GAQsWuojcHj4O4CJAHv9IRUvHFE?=
 =?us-ascii?Q?IHoc2xHpaJRprpWyhxnoQPjAcW+yCRW6RSvcCKWN3o01Ijuo6O8OwMNFYyof?=
 =?us-ascii?Q?YA7yUb8bR59lxNRyHGOQ8rn++SlZ2WmcDXvq7a4c5twqO9XcMzkrqb+QDDZg?=
 =?us-ascii?Q?wQ0DY5e0gjuta3m8XkZzGZNtIUx8QQEcQn4qWU39dXCRPM0VnLSPWCUSs8fD?=
 =?us-ascii?Q?4+rK0cnVtSTAUgi/sPELULI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f777040-87fd-4a4d-d908-08d9b1023e33
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:04.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+K6sYyYl0aNalCoBmm6xzX3XCgknV0m9s52LrOy3UmMTncqyt6H9oNIrZ5LTO+e6uegplFdaDlexW1Cc4FrUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VCAP (Versatile Content Aware Processor) is the TCAM-based engine behind
tc flower offload on ocelot, among other things. The ingress port mask
on which VCAP rules match is present as a bit field in the actual key of
the rule. This means that it is possible for a rule to be shared among
multiple source ports. When the rule is added one by one on each desired
port, that the ingress port mask of the key must be edited and rewritten
to hardware.

But the API in ocelot_vcap.c does not allow for this. For one thing,
ocelot_vcap_filter_add() and ocelot_vcap_filter_del() are not symmetric,
because ocelot_vcap_filter_add() works with a preallocated and
prepopulated filter and programs it to hardware, and
ocelot_vcap_filter_del() does both the job of removing the specified
filter from hardware, as well as kfreeing it. That is to say, the only
option of editing a filter in place, which is to delete it, modify the
structure and add it back, does not work because it results in
use-after-free.

This patch introduces ocelot_vcap_filter_replace, which trivially
reprograms a VCAP entry to hardware, at the exact same index at which it
existed before, without modifying any list or allocating any memory.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 16 ++++++++++++++++
 include/soc/mscc/ocelot_vcap.h          |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 99d7376a70a7..337cd08b1a54 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1217,6 +1217,22 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 }
 EXPORT_SYMBOL(ocelot_vcap_filter_del);
 
+int ocelot_vcap_filter_replace(struct ocelot *ocelot,
+			       struct ocelot_vcap_filter *filter)
+{
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
+	int index;
+
+	index = ocelot_vcap_block_get_filter_index(block, filter);
+	if (index < 0)
+		return index;
+
+	vcap_entry_set(ocelot, index, filter);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_vcap_filter_replace);
+
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index eeb1142aa1b1..4d1dfa1136b2 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -703,6 +703,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack);
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
+int ocelot_vcap_filter_replace(struct ocelot *ocelot,
+			       struct ocelot_vcap_filter *filter);
 struct ocelot_vcap_filter *
 ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
 				    unsigned long cookie, bool tc_offload);
-- 
2.25.1

