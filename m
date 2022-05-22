Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E700A530211
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 11:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiEVJ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 05:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiEVJ1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 05:27:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8019FD29
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 02:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crUkIrZ1+BV4BGczXs60cTxTgk2hgsKhdTmAlIdCWHFIdCF98WFejZFWb5Pr9158wdWIjnY2I5rKgX9Pquq0ncfm1C5csM0Z5gP42vfPHsTBJ9AZpUjQrn4WmRa/KhSSRthVb5S+S7Ko3oxN3ZSA6Y8ozDcts7YRylk01XibtphRgSSZiee6vOsoD7dhLhgtftAfj2G8r8sEJB9kCH6DWfH+FbNZDlNh2zC3hmULEC/dzDFtTeXETX2GWLaRSue+DUKgxe8/mpdg06n70F7SIzh42WSx6F2+RyK3br1qwjCeUCcxlk7wDV5XeqEB9m9IoI5kddzILpnoXf8Q3pdsnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65J/BYNPDgXC4GPd3fdP0DOG3ki93wJjwfit2ILjbEU=;
 b=TTuDm596obJ3dpdNcmUOh7Pz9g1Sodjyo/H2X/l9ajl7EcrTcaXw7grDSKrVe54Cc6BYD7DCBYTYN2BObyR7JICrDjlOhpYI64bnHS6P/T132LC+nNswAdSsQQpUbDBIktLmA1d3Fr16mrXjnHvGPJZLCNIEFJUx/MT33KmKn0oJLy8t2bl77j9HS+yfB46ZRB5Pn+bb7CPHNJw1Z5BI01Xi5MUsP5cBC2bYiuBgGeqQHMWF0tRfyoHumHUXF49ADIUzbHwhZSnx9xoQu0xv1tSf0+z4ak4hkM7ocnDju1un1HbtBb2Cm8sbXuFlIFB4minoASZtfIuGuSkYvJZtdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65J/BYNPDgXC4GPd3fdP0DOG3ki93wJjwfit2ILjbEU=;
 b=oJ5RK+d+I7Z/wBKISQ9J1OYh4vvhbkeiR5jkE7sdiLWsNP+kUxyvSk1olFoNSQKWo5yKZLyxCb2WiR/CkBnf7lu04Ri6Qe8GMRhRGwanOWZz132BxgLNt2oworrA8x6lmw7Br7SAZbmAzccD7MI+CW6nBPE1UWOYPejhjKpVhP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0402MB2820.eurprd04.prod.outlook.com (2603:10a6:203:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 09:27:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 09:27:12 +0000
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
        Colin Foster <colin.foster@in-advantage.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next] net: mscc: ocelot: offload tc action "ok" using an empty action vector
Date:   Sun, 22 May 2022 12:27:01 +0300
Message-Id: <20220522092701.2991605-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4214f0a-70c1-4087-3ab3-08da3bd54081
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2820:EE_
X-Microsoft-Antispam-PRVS: <AM5PR0402MB282074FE2EE881493DD7B778E0D59@AM5PR0402MB2820.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahvgc6WTsc/xWhccNhWsKCjE6ov9suAzCmZcrV6qZ+WxCone/JWW6F6g+2xgJnRkufI0Sxdu4Holcs+EcE4kb4d2kfXKVBTUlU33w+xGv2W7NDrE4rDb3YoQeNMM+XHFoKVnRauIk6kiLbyyUVn9dGdK132iChLHFPnByT6TQAph+L3k5DzSFsyAvO2WsI5LnQhx8GICPU+7FdjhmwSi0fvb/5Cqt9AeYU217DgbFHnmqsdx54Qaj6Pb+Tp7Bsyos25c7YrOMifc7ZzNU1qyydihHYCtteCVg3ibhSvl8rfsqW4x2f1TzQpauDrDVVVf/GFXUxnd0abNLrCXcqBX/bAp3OLovqqzWY9BmnQCeNAMAZLmhCU9Fx+CaTA/fFpB/QpCQn6y3fCPkBLpSYeRTrUiVHR7Dha7Q4bWWeWH7zNQpqDPt8s3PEDgqFMvyPol9odFd6C76AilAMgUrkjVIRyfgf0aqvEelIXv7CAmracPrk9N68zGwhqWc/buhVAUP62iQy3/T+IisAkbG2a3qQU9fPkQ34QXLqwUTH3KFpXhS+xOL8PVeeMPXf2KEgRvreomvKJ0i7HFkwrUoWx6Hw4zo5NJDW0QnwMga4oWus2PakR7cGAEh0t5R7+s7t4z6bOUCpsoyC76N3cHd2xRCmOPHVhdiIHdnc/nr5Puu/cIdVUj0QBUQxZXRfi2IFwwhLfnOLsBXFZFi+ZEsC6vyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(508600001)(6486002)(2906002)(36756003)(26005)(7416002)(5660300002)(6666004)(52116002)(8936002)(6506007)(6512007)(186003)(1076003)(6916009)(2616005)(54906003)(4326008)(66946007)(86362001)(38350700002)(66476007)(66556008)(316002)(83380400001)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tL1bcUpFczYnQPd+hAvVwJd8TdRorCGwH8LPFjkYqesPBbGuritMJJ8Hyo8P?=
 =?us-ascii?Q?6Aj6pc/TwQvm+LjMBbruRTuAxXuHM//tcBTQQBR+YYNwR5/ruhr4z6eWMmHM?=
 =?us-ascii?Q?7gXsNRzKsu7bSK+67kU7IkkKxabNh+lS9WEGtg2L0U9XJVeASTQDkiNfie6g?=
 =?us-ascii?Q?hJz7187YU8gbErJSNcQAw0yTvzePdnVVyZ8FIascVBwjv5LpCkvnTd1Huwkh?=
 =?us-ascii?Q?cYuptYdZKAM38gBwWAkQHgNj21q5zZrd7/P2yOp8w34qutz59x4fkjCmBgVR?=
 =?us-ascii?Q?Y6VheoAnW9FafepVtsIScmDu5+JqQXq8fq7zpjFYZ0LFp3r+c/HHOt1lb0KG?=
 =?us-ascii?Q?eeHbkvaqK9KL0SVNARzizC635WrRFce2e7uAKs+3LybOMbOle32RXq/5CEdC?=
 =?us-ascii?Q?8/OijzxMQOulv5x6wVpWMXh/IO3wUKa5EEFxcukwcWzm93TRlI+DYqzP3xkL?=
 =?us-ascii?Q?skeixnkCuxldMM8EAMuNQyjqXkoW1GStApnpqXCQl/TsvaJa/JNqoAuhEi6c?=
 =?us-ascii?Q?ZTX8niKkXB0LGBKJT0HHu5T3/QIBCWLnwkzY3AjnL7Ny9RQtSOZGExlDDCdY?=
 =?us-ascii?Q?fyvG4hPjOsniYbMu9BJkf1NteTJwRmN/5RRLxSBspcvhT6PV54mtbzwq3JkU?=
 =?us-ascii?Q?YlREfE7Bj7NrD3FYpwgxaWYyZ20ROYQs7QWf+AIPkAiR3qadfNzlUZhjmtNX?=
 =?us-ascii?Q?NC3I6lg2D6/9vOBkaiDc4fZv0XqXlwTlxA/2pidfk7DI6W88wGFevUgANIPh?=
 =?us-ascii?Q?6qS5h9u9KLTDxb89gEwz2vrrZAh3ltbYgLb3X7jjCOpt3y/bSf9AhpfrEHpv?=
 =?us-ascii?Q?KTH+JK+KYeopCga/8Je0CaPbXMCq5ADEx5ad3MjD5WduG2wWutAlMfzAQfKC?=
 =?us-ascii?Q?WoRdEMfKWWjUN34LvUaVj2pxRCmMplbO0+W4BNF3iJ3bsJatsyrEhgzbtOqD?=
 =?us-ascii?Q?BVG8WiNJDfO8a4WyxFMtAgYS2yGGAC71Rux2rJNxfZU4iSRvuc7juwdFaxz+?=
 =?us-ascii?Q?7KD163dmnnahcBJs+hERBu1OXK3+B3j2SYp9obM62M/0422F1ug4TcCOtVFB?=
 =?us-ascii?Q?4hd8VGIV4/Kxz89Pf9jmnxFkR8fmdw1JKk9DwMhyDgS/VwGXfXe0dbni7wXn?=
 =?us-ascii?Q?NNaXDiqr8WQgM2blqW4rJWUPuPJWjdmnDKeRB12DobC1VgAZQ613osct6R0U?=
 =?us-ascii?Q?F3yUKDFEHhAHKvNP9yfsaAUZjJEAsG6YrntcWmRbyuj7RoQnoJgPtWrWDa7C?=
 =?us-ascii?Q?eLIBu4dZMoL9WU7aQndrB53aAR3XT0uIh+2AFzQwRrsrro3+rp6UADZ1H7v2?=
 =?us-ascii?Q?V0id9vRojpnJYw5CFNDTrHVhYcDxIK9ZIxBuAGUU55IoSV1+eduNqGZjfVau?=
 =?us-ascii?Q?bdMfJ/DpcZpp4RDqlRKJsVUeiZG8xlnBNXzsDlSmay1xZyfkhDQB+p7oz5cp?=
 =?us-ascii?Q?E6cX1K2m2WSEp3C1WjUy2wzn06rZLMEFpNFBxC5eTjam6kq1JwehHAqCKA14?=
 =?us-ascii?Q?0nV/uH5FFC9Ir3xQtWKhmDOEudvgL8tKHXw2Dsu2Xz/GcTa8KBwbziE6zAyZ?=
 =?us-ascii?Q?0DfENTH8Gn+7dCOBOL1912AQDFwbAdLNMBmRT77nVYoigiqM9yK6WuyPVxcO?=
 =?us-ascii?Q?zvZlRXzBazSFvjixNHp3DmpWasJWvLvPSTsRQJXjLdJeHMAqFyOFvaaCayqL?=
 =?us-ascii?Q?TVC+hn3WByoV0FsdxR84vkySYNsfXhLXlcr4BW/3OGYuSbGcruWX4KcXOlhM?=
 =?us-ascii?Q?ElMw1sGsMF6YIYRled5DiqBKJ6JrkN0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4214f0a-70c1-4087-3ab3-08da3bd54081
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:27:12.4973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2trFc2AEGBW90ltcbcVD9LEzFjAUVdUAvf7IkSXH/HE1pC3ma45qZEYJv8vwU8pjPAR6plb5dbEzfltdQOSwow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2820
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ok" tc action is useful when placed in front of a more generic
filter to exclude some more specific rules from matching it.

The ocelot switches can offload this tc action by creating an empty
action vector (no _ENA fields set to 1). This makes sense for all of
VCAP IS1, IS2 and ES0 (but not for PSFP).

Add support for this action. Note that this makes the
gact_drop_and_ok_test() selftest pass, where "action ok" is used in
front of an "action drop" rule, both offloaded to VCAP IS2.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 51cf241ff7d0..7c0897e779dc 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -279,6 +279,22 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.pol_ix = OCELOT_POLICER_DISCARD;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_ACCEPT:
+			if (filter->block_id != VCAP_ES0 &&
+			    filter->block_id != VCAP_IS1 &&
+			    filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Accept action can only be offloaded to VCAP chains");
+				return -EOPNOTSUPP;
+			}
+			if (filter->block_id != VCAP_ES0 &&
+			    filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_TRAP:
 			if (filter->block_id != VCAP_IS2 ||
 			    filter->lookup != 0) {
-- 
2.25.1

