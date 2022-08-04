Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5DA58A1F3
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiHDU2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 16:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiHDU2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 16:28:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936C42AC77;
        Thu,  4 Aug 2022 13:28:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gh5433pSExDsUiDaTBjHgs/hHM4qVQ8RM1+y/qDhT0F6sQrgahD+q3j/S3YswF5sGEgBu3vQ/EApCQJZMuXEZ4NfqWG9Lid67mN2842W5/6xjLTKdT2laQ904dJgu0sUEx6jqvLX1Ia9h46uXHAXcCBxEyn+QW9av3ZtWineSQMUTdDhrG23gVWbb7wUN8w0Ji4dkzVe6SkNx9c/+NJAIhl1CNUiZEzVNvxOXKsIp2hjKTJp1WhyAtTrs1PtIL2hm2aIp5xC5mOZt6FBldnvL+3t9zrQyq5NSf4mSY4xfe4PdbDeoLMhbGGNHihP6nLCON/Htt4F+49zted8no2kyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksSaNHgP1ft64PCx5rmbwfFEkl4jwtkW7mtaBCTCSl8=;
 b=fRcoVFTMyrQXnTjaoKaFBx3acK4ODfxFm+/rk5nIQWy+oQlij0/7S6dZCrUhDjE2tsBYMtHVy2D/pIheKm8GfIADfq/DMqnTlHEbxVFLgTuoxKXhadsFXdfOcZPaXtLtVeYsHim0hpX7w95k+qHY5l/MgbDY8mijjZy7/TT4DdLeA0mzy39vYpREbRtxdASFzn4ks+Xb0oDfQLkNVYGcPWts9EmsIOw5k6YnJJAhTZhzzJqT/b7c/44U/zaoKvs4t7S4+dmjwDzd/1rBIkaUDN8Z3OCN11Y+BTRcsmAYBfbhZbYC5Fj+/OF7bCTxly+AlxF//1d3JyMJ+G6mlXjigQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksSaNHgP1ft64PCx5rmbwfFEkl4jwtkW7mtaBCTCSl8=;
 b=EnhQ/GcbWbG5FvxTWdgSG+HqhNyrjgM6Rqc0aIjOxbw/OPTU20KsjxZz6RUq4ieWFQ/QkTM0zDSAmFD+UEvinn2XNZYtnm8UWH5RHEX52RqIJNxFZioeSnSVi2P5ucFyJxFkB+w7/GvdN1js3YbXgBHE1OkUO+LW/4ycDehVB94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5114.eurprd04.prod.outlook.com (2603:10a6:10:23::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Thu, 4 Aug
 2022 20:28:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 20:28:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: felix: fix min gate len calculation for tc when its first gate is closed
Date:   Thu,  4 Aug 2022 23:28:17 +0300
Message-Id: <20220804202817.1677572-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0025.eurprd03.prod.outlook.com
 (2603:10a6:205:2::38) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b572595-c1da-4593-13d6-08da7657ea2c
X-MS-TrafficTypeDiagnostic: DB7PR04MB5114:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xv2tD1chgwhJo37eoGGvmfLeMHymn6Eg8DhrJDsvz/c4PMC5MpEMvjw/aOyIpNDuZ8XJwU913h0vrqyTTBHPohPawjHj0dXdbvGyKzc0EceCa4J7lMygIurQa5yy54TXklQs26yd2bqHpeJcMPWmRqdDVA5SbVbJT2rtwBFi9rW/mgwbOMLjGHCUrLT+j01pgHBDJN1zNAt4XWWr8RurzIUs+p4x8OQwvEjnmZsRnEO04ZErflMpmBPteR/OqrzvTpLNLal4zAx2ARtcmxIm2SnOwVlvOxglCT2inKPiN50kM+1gSC1Njx1CnUg+Gh9RU0iqjZBHT0bgMDejyAMNc4i1/Na7n7yH7xEPjHioR0fZzsL0QwIbBIAkOSnvIitOfeCyNhvdMOHk5KW65gtojaRII/7tN/xn5t2g4OSSCFdv92VbyOwtI/Fj3NpAlRKesid3CWeOM/CWKeBve/kUlfHTmkjd6Dxhz3ehzFKOu+SZWzgVYrZXPADZ9j5dNdR1gYUYBLaVuIXcl80mKFqNeCgJDKD3UqCoGHPl4tYNLbINFRXW9/RhuG6W4ewWwXMxlJKafoZco/gYCY6vSCs1uLY4bmy6i+36R8ks8LQhJ/fsJHfzXn2bj75RZIx0PsF1hhjahJcDyt1dXhGADHJ0Im//aZjj9Wk1okqdpkToFxftioiVMrsqxRVhLmxxp+vwqNveu8bJa6xUUPHdlsqrgtMs1YlfxZlDyC+bXC26nA59kNwpGbvrwslIHdwWQbNOQ49xLKQFkt4r0pm3FVjHpkz7jEwzBs1ktkwDNDtXzO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(83380400001)(1076003)(186003)(44832011)(8936002)(8676002)(2616005)(66556008)(5660300002)(7416002)(2906002)(66946007)(36756003)(478600001)(6916009)(54906003)(66476007)(86362001)(41300700001)(6666004)(6506007)(52116002)(6512007)(26005)(38100700002)(6486002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nd/I0MrQ6L+mzMnuoIzg5KR9kx9q4FZMgQcuB2+28wsS583NRi3siuw7AgMK?=
 =?us-ascii?Q?em65XqjUpwAh7tHKYYMhNEOeJK++HiEtiJaH0y0tNxai5FX3kBLlddiNCYgR?=
 =?us-ascii?Q?U5O+ELxy7A5hxDmutn3v4eElN72JZ/MaJv83+SGmEM6OKvapu5RJurvyEYPD?=
 =?us-ascii?Q?DWMtx0NsKAqHC4YbLNpb6UlSjHAwd+3Z8KN386dOUGp1KE1UcAS3dF+nzMtv?=
 =?us-ascii?Q?IkXQR6qzrmfQFJRLF0xSCoqCNjhdprwijP/r7oJiAs+mOIcPGaY5tx3/xD/W?=
 =?us-ascii?Q?0V5Hf8WsFjWRUUkaL8C8J4iKIq9Mj+K8X91SlxLyk2q2syKht6TKeK5+DPam?=
 =?us-ascii?Q?WpGPuEJ+egW83DoETGcx0clS+xRVg+/OVEQnQtsAH2MAWwCfNqQQa0BLKm0r?=
 =?us-ascii?Q?YvICL/OucqOzn6vlQ6ChJPM+bjM4p6GTub+rARsbSYqb0E6CzHbMPFkhTXD/?=
 =?us-ascii?Q?zHl4MaDyol/V5W+b9yCalZkElcy4fdAG2POssj/0GbazIKOeMhVcEglZbKID?=
 =?us-ascii?Q?hZJdm7EVwTiLcD4pLl47f8wJA2qQL7wREIdiUVdXUQ+NosnBL5WP/aTO3XcQ?=
 =?us-ascii?Q?uP1eDN+Xsj6bHbLHvg6g4WtfWdYbOZgYvAHKEqdBIryfN1JS5dyhhLF+uOBa?=
 =?us-ascii?Q?sr9dr0vuKc/VSd1zip6TRwAXutYCYRG7WaVgUQWYMN9aL9ypU9AaJYguCSE7?=
 =?us-ascii?Q?DSbw+lB7xzvUY81TUg0Eh7l/4De5kKblSsWW5pYxp0rYhYw+g6XDP5N7I4LP?=
 =?us-ascii?Q?2hKDpym2pPj3en5A1YB0kBKskmUV7DMqJf0Yj8gwj7CZR/tFXF4cfbGhbIbY?=
 =?us-ascii?Q?PvG7QqWpNfrIROYYK2ezhsl0KpQYkroGqoYNA8HrbYmo7vOAIHfDaFZiDdJT?=
 =?us-ascii?Q?uM0T4JTc8B8KKISDX3/5CEMfB/RTdqoD2V6P7l3Wy5sWORjhdNuhI+01kHs9?=
 =?us-ascii?Q?5TGUOmxJrxeiyNS5YiNWDKXOjNHp0aWMUwXvvfXy2Gg0i2C5tul1FeSS5CeT?=
 =?us-ascii?Q?UM1p2vx/i/BXIiqi6JA4zhX2T58xH89rM5D33JNhriVdUk84PShFzpC3Z/0x?=
 =?us-ascii?Q?kHUAKqAKJujqhe8kosbBxWDDrxh5MUyXSn6qbGNM7fJiLeqi+PxfygjALZX8?=
 =?us-ascii?Q?cZDlLZt4zKIt+dc0MEYxnXyOYI9w9kARQ+ZCD8apPJXxCPK9ba9I1UnH+mD0?=
 =?us-ascii?Q?ubFB9JVNzMYSol4Ak9Uprkptbbm8m56yP+2XbxFYUNFHTA8yolaygOBow9+Q?=
 =?us-ascii?Q?4g21lfw0Otoi1rt8EIAcsXDMOK9wNv0A9hKWfVjqnEsJd6e5LjQwHh8IwH1P?=
 =?us-ascii?Q?I2VVneo0wz4CHMBYy/mOVB7UVKeL7pn7uhXcLQEvOqiwBlfu0aEUAF5KBfly?=
 =?us-ascii?Q?fFOO4KMKJ4/GdiTXGDoQObhco6gpzUjyLeUIYSsBBNnhnfi9JqYdMI2JkHd5?=
 =?us-ascii?Q?gEb/Gj8iq11ffZjt0/SoNqOnJiUcckIzyOSOifnpZ9v7x0V2nncXJp/s1kWJ?=
 =?us-ascii?Q?R3CU03Q9OIe5h1cIH12C6TF9YDBj7nBfDtZWmDt8mrjj0zTt2Klom7qgYh1D?=
 =?us-ascii?Q?qa4R2OcgTDJqAbS9p4tjncCRmEhTzLGqrGviVgQ61LsruGotFIVkOvqymqAb?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b572595-c1da-4593-13d6-08da7657ea2c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 20:28:39.2773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxcIeA+o1lRPy42UD9mTrtp3Qx50wPF69XzqtmPGVYoUJbd5RgZUXp3s49r10WBuV+/HQv9oCWFftAmGJkbmDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

min_gate_len[tc] is supposed to track the shortest interval of
continuously open gates for a traffic class. For example, in the
following case:

TC 76543210

t0 00000001b 200000 ns
t1 00000010b 200000 ns

min_gate_len[0] and min_gate_len[1] should be 200000, while
min_gate_len[2-7] should be 0.

However what happens is that min_gate_len[0] is 200000, but
min_gate_len[1] ends up being 0 (despite gate_len[1] being 200000 at the
point where the logic detects the gate close event for TC 1).

The problem is that the code considers a "gate close" event whenever it
sees that there is a 0 for that TC (essentially it's level rather than
edge triggered). By doing that, any time a gate is seen as closed
without having been open prior, gate_len, which is 0, will be written
into min_gate_len. Once min_gate_len becomes 0, it's impossible for it
to track anything higher than that (the length of actually open
intervals).

To fix this, we make the writing to min_gate_len[tc] be edge-triggered,
which avoids writes for gates that are closed in consecutive intervals.
However what this does is it makes us need to special-case the
permanently closed gates at the end.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index c09acbc0804f..0cbf846a29bf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1141,6 +1141,7 @@ static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
 {
 	struct tc_taprio_sched_entry *entry;
 	u64 gate_len[OCELOT_NUM_TC];
+	u8 gates_ever_opened = 0;
 	int tc, i, n;
 
 	/* Initialize arrays */
@@ -1168,16 +1169,28 @@ static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
 		for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
 			if (entry->gate_mask & BIT(tc)) {
 				gate_len[tc] += entry->interval;
+				gates_ever_opened |= BIT(tc);
 			} else {
 				/* Gate closes now, record a potential new
 				 * minimum and reinitialize length
 				 */
-				if (min_gate_len[tc] > gate_len[tc])
+				if (min_gate_len[tc] > gate_len[tc] &&
+				    gate_len[tc])
 					min_gate_len[tc] = gate_len[tc];
 				gate_len[tc] = 0;
 			}
 		}
 	}
+
+	/* min_gate_len[tc] actually tracks minimum *open* gate time, so for
+	 * permanently closed gates, min_gate_len[tc] will still be U64_MAX.
+	 * Therefore they are currently indistinguishable from permanently
+	 * open gates. Overwrite the gate len with 0 when we know they're
+	 * actually permanently closed, i.e. after the loop above.
+	 */
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++)
+		if (!(gates_ever_opened & BIT(tc)))
+			min_gate_len[tc] = 0;
 }
 
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
-- 
2.34.1

