Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4540651B3E5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiEEADR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358125AbiEDX7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76013522C6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcHZNUfZP/OOLgb7NH2jKrqeV7WXAhbgnesS/hQY2G0tU/t/Cm/BI90Fpid8lYC8Ur+0Ruv/ksKVAiXXaDqp8nwaJPkwlz3vbwvyTxgsvRm/JESM7gHKDTf6pnH9kld9M32NShYy6zDtuMfK7stGSmP5VmZxF0+6ktyOr7ZS6Id7JZ/FaCOXrwFNhQvr8yu9BClIGqWyemclI8IeBWP+VR5GApk1yK6MzbfWjf3L5Na2A9sqPXZ/8wBU577KzuKieruEcBvbDeLXZdSqTe3zlj36fhWWZgper36jb09k3DL5mhITjq3cAUVD5cjZvlY5B+ccjppYmq9bbVMLrQ9kUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYjXlOf39zijHQxPf3Rm9+UQze/WnYn0xWK/jpXi5p8=;
 b=clZJoIgNKb3WwDv82ZQSaFaXaBt4NCXPhfncMf4T19jX3W9XBLu2s/lAh6IeHlwOEjcahhsjjMx58qDPeqsMrIXcg5amU5ChbAn1AYkL6sJsTP5tmiRlO00igqNFPt5wo+QnQuzk1ZX1ex0h2E3Pr8qY8+98QN+nqZjZVJxZrH9OE8pSTQ7FfHPbnrm+kATcnpegW/qrxzjCY4b8g81BIUEr+PXxhhaUwB+Cyh8x5uxyhoJf5lV+oXTYzZ2WXsloSNFDbKbtkPePumr3lXxEQy5qrp9AS3cA6ivetP5K33UyvEQOtHTYnWx2WznGZO4Vuvyg0suyz+AR0cCNZ321ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYjXlOf39zijHQxPf3Rm9+UQze/WnYn0xWK/jpXi5p8=;
 b=N4/EljXjr7RP8bgcYA4VTuRbTIXax7PMYEqR3/15A+MmdIKzW262KQuwbphvhZmvrWrnIpWOH3SG1No8sDcxDc0UJSWT4jdbfHeENiOd6EviAkLWYeNyU9zQVdp6JoZ/YUyffemi56YaPR164SPitDtUC4HLXQIi5SnO2VrKnkI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:54 +0000
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
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH v2 net 3/5] net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
Date:   Thu,  5 May 2022 02:55:01 +0300
Message-Id: <20220504235503.4161890-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
References: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0227.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3df7d114-9922-4e56-32ef-08da2e29a031
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4683D380785BEC4A926EDE19E0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFveZdX+HOxmFRQJLdKtJvLuA0RiX6k2CAqsbA9Pix6CVZrFTHUhBtlK1hr/76DxZkDTUQdHqYfdRwlKtb+/efNzQSxsy2Fykq6V0IqVtMPI/NhsHxt1evx/JHswXAF2Fxuh6zh0KuXkzpuQDUhcZfNnP/4Y/EAfRnSOBwzuTPyz17nXQISiREdmO7djZ9NGkBUUtKvxDyTN6mDkkdtkz8u6dBeBF2h85zHlPWwJ0hUpkabgpwC7euJvCGrslzJ4p4QBoo6a0PJqe/oJ13Rxzm+TdRz4Bq6MCqaF6JAuA0sXtZ5t9RvKAofL63kIbcOmTSvX3cnOyfXZOwiwgtVM5iLF3kDGn28fWiCCqX8hFWAV7IeOg7SWZBynpkwaZ9QHGTgEcYhv23xn+/PrKx4X2AMCh7LPr/NcICdyM5bLedHUHajFHw9eHZBSLqqubbB2NZz+DxjTEu9L2epxBOtLa6RjCN/TaIWqKqhSRsyMnI/Q3K+zxUDuohOXjCbVzAU0IqG/Cr9/CnndlNEBQoTqcby6ZAcJqTxkAoTGb5054wWdFt5PG48efHTgJr+PICRXjTql/irwBQapdaSNr1U+HDZHeMPqpmbs6YcwzJGky8WgQR+RzbUHZGF90YurPLYwGfxNBrIp359dEFr/zAdplTswe04onSCr9b+K0RI/TAfclvY729FNnqmb/0YHqGWJpH8MCR8dDTwbmTStyw3yfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(6666004)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+is8+x7u77QqXEWj4woE2DFzOZvf/FhMbZCjEInTeXp2U6AEFZky6OXpBIgs?=
 =?us-ascii?Q?2kbk8rAdvrTjuHM2I7nDjtRPdJeT++Gu4mjQhjRMkf5fubGeo4w9btygdJWK?=
 =?us-ascii?Q?AQDCqwdgr9kV6dwfeURChkNyKeR36EsUAOCHX2jSCKD4yX6AnI5UxpWQOpxI?=
 =?us-ascii?Q?mgH3a4LNRLSEk5GoStd69D/39LH9KuTK4uTEjfd8EiI7e3yHKPkYZdsA0MMd?=
 =?us-ascii?Q?/f05JlEqHP+80mGWmSPCpddLwkEWbPNrl1vVI/LbPUo6J2Lq1OOkajmXG0Ky?=
 =?us-ascii?Q?oc4228jmzPHPaT82vgqAtg+tYdmOuYbXciEs7WvYyFKuPculohoGPj4Ha2kK?=
 =?us-ascii?Q?hM8ey9ZR9A5bV31XFfDCcDuD4neTSJiyV/jaUX3IKFy2hcL9rKzhV0gkd80l?=
 =?us-ascii?Q?D4NL9pY23JcWsiG9Is3yieJmCBcnlfMNP6NoHT76Cw70IJNMv7yXtHANWsHu?=
 =?us-ascii?Q?OdXV88/Uz9ms5CipvA/LNkSQS1ZmQx9ugwI6/5XGbn+3s8ExWVU2mGaLKBaC?=
 =?us-ascii?Q?eIr9mbl3b7wrASqjCkNRU3YOszSVLlk/jpzExFczDt+V6gHTuW9LTPp6JiR3?=
 =?us-ascii?Q?pYq54hbRbq2R0uhwE9VL9e/kw2qxScQnG1faGYCEUHHHdVv591ljtMxyG2j0?=
 =?us-ascii?Q?P+XjObfHhnu4A1hVMsFOoCUzZfFEIDbwEDDMkLIQN2OkASgkSmW2PzOpx9pq?=
 =?us-ascii?Q?PDnUHz8GzSpwdRBTRVPt8BSWVoLAqQpN2Z2azZ6tfKGzBO9TG1FLHRyE/jkP?=
 =?us-ascii?Q?qXpnVI5+UCpzp6b3WMaVGz+jh2l3Z5OrMk0C5KCtzqlSrLOZgWwiFFN6qp7q?=
 =?us-ascii?Q?es5nL7xWR+HW4Bts/AqqnhDLgepSyyvFhE63k3F3nzxfupCiNwc8JAxIYZln?=
 =?us-ascii?Q?U7FHMf1R+IJxdKLGgJA3BXP3Q/o1wdwotXqW/1KT54tqMk82zBbXABw1TR06?=
 =?us-ascii?Q?suAyGs3x1BlLcPiUhyn4vt88/PO7DngFrQQKZjXOEkZ5Eo4EgpOEVcOmpLXZ?=
 =?us-ascii?Q?S9g2exiW1pEZw4U9Vkr4Kz1z/4oNuD14dXxMhe7Rx60F2xdt9HnGl559I9y3?=
 =?us-ascii?Q?VfLl62DwzBk/4ykYf2q+x6FMzChg3Mhqfl34wMbNCqB2bFDAkUNuppbrQz5W?=
 =?us-ascii?Q?rof5rAMSZYcTyWAvk2sL9sCKqFkDGrXCekQox/mxjWgx+9nCOBOQiLdyV/5T?=
 =?us-ascii?Q?h09Lfu5FQhQ6+m47zMdy7CDWW0Wb+HFaaXQ8Ho/7yLfi++etZsTtgxjNr80y?=
 =?us-ascii?Q?/Hk3heLuT4yW3trwDamB+/0OJ0LBCRR32DXIiBPbBsBS7d2o3no44nxVNB9E?=
 =?us-ascii?Q?egIKHpkQqPT/VLLX2AFU4JOCtLV12oK/hgmJbhEwnbRIHxGdEiMAS6P5wWEW?=
 =?us-ascii?Q?0Gh0rAQun+9ReBY8nGgpWFYbpMhzU3ih5tJAGZAybHiBG+wV2oIWePWAuauG?=
 =?us-ascii?Q?vRTQgcUCTy48voMUw3YxCA6aoI+SVubetzzQst015YGapDx8NXM1GZMJaF6l?=
 =?us-ascii?Q?/axjRKzF5rKn6vN7Em85euUaQxxEGLqHr0ewT8JWhirduDUvf6uw/V1PlLOP?=
 =?us-ascii?Q?xnLP92Fm80lRv8xyZzkdy3/ylcQ963YX/Ui/ZuYzQeESsJCdMi419xQ0ZTZ9?=
 =?us-ascii?Q?JnzXqrmsAdX3O+dSZdaFKYgovcg/X4xdVNrzZbuye2K/7lJZhve99fbVsFib?=
 =?us-ascii?Q?tx0a/19g2jIhkoMpn1TcsHcROQplrNwD84bLiPiBCUlVVsuWcjCSoGGXz3G/?=
 =?us-ascii?Q?9TQS2g4LWqIUuGlRXzMH7yk9DhNr5Wo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df7d114-9922-4e56-32ef-08da2e29a031
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:54.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMyoKUKN+VRqi3DVf24YVGTUXJ2JWsdhfTgUz0SVWRuoHRokNa5KE6GDI4CGnyFAAiu1gWUkHtHJcs7aNRwH5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VCAP IS2 TCAM is looked up twice per packet, and each filter can be
configured to only match during the first, second lookup, or both, or
none.

The blamed commit wrote the code for making VCAP IS2 filters match only
on the given lookup. But right below that code, there was another line
that explicitly made the lookup a "don't care", and this is overwriting
the lookup we've selected. So the code had no effect.

Some of the more noticeable effects of having filters match on both
lookups:

- in "tc -s filter show dev swp0 ingress", we see each packet matching a
  VCAP IS2 filter counted twice. This throws off scripts such as
  tools/testing/selftests/net/forwarding/tc_actions.sh and makes them
  fail.

- a "tc-drop" action offloaded to VCAP IS2 needs a policer as well,
  because once the CPU port becomes a member of the destination port
  mask of a packet, nothing removes it, not even a PERMIT/DENY mask mode
  with a port mask of 0. But VCAP IS2 rules with the POLICE_ENA bit in
  the action vector can only appear in the first lookup. What happens
  when a filter matches both lookups is that the action vector is
  combined, and this makes the POLICE_ENA bit ineffective, since the
  last lookup in which it has appeared is the second one. In other
  words, "tc-drop" actions do not drop packets for the CPU port, dropped
  packets are still seen by software unless there was an FDB entry that
  directed those packets to some other place different from the CPU.

The last bit used to work, because in the initial commit b596229448dd
("net: mscc: ocelot: Add support for tcam"), we were writing the FIRST
field of the VCAP IS2 half key with a 1, not with a "don't care".
The change to "don't care" was made inadvertently by me in commit
c1c3993edb7c ("net: mscc: ocelot: generalize existing code for VCAP"),
which I just realized, and which needs a separate fix from this one,
for "stable" kernels that lack the commit blamed below.

Fixes: 226e9cd82a96 ("net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index c08cfcf4c2a2..6de0df1815b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -374,7 +374,6 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
-	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
-- 
2.25.1

