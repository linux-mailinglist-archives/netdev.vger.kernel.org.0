Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AA56756CC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjATOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjATOSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:18:07 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D92CC5EE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:17:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fyi5HMyn6UsGS81mfbfODVFOydUM1mxfq1FQPhiZAdoYtCd1hpESOMYovsV9ACN5BlRx+/OIT50Jx5LvpvDQc1ofZMQHvc8zfDpAOoj/a8Ke3lrH+LIW3y0+sboEiGYVFhY8WnUVFyKlPdz9G6tNifMyv0GJMWLJXuAYQVuIQI84RdmHlSUqCJENs6arCYxvFGXCldlRJb9c7t79Ua2AnF+Y9HKOyuBvjXz7wdpmkR/yP8ZqIQ364MIqRAmpedng3RYBpysSau4SjS6/YCNY5zSCizAWRqG8QfmhBof/nn5EQVCu17Q35tAXYYYoqXsUQvjQghkY2lfomnqfMwMPog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llWXD2mJp2RTrOjmxQzU/cy1jrZ4LQkNvvF/nOX1hO4=;
 b=J56spy4LhypjdLNFTLsXsld5vWWcKJKEHDIBygf0h9iICOBHlHVH8bpv9h9vmddPL5EyBEnDwA4UjDQ46V6oOA4U9vqdJk7DWcpz+rC7fRryVE1NSAFVKFSOlwB8QtWWDrwzTx8lRdk6JvREoJCN02hcdgkVaYYKAtEEXfxF0dKQ3T2jipGPeeV7xyBJzdk9VLHATAEi+x6TBiU6Mn5nq2zuQcXXNz3VWHJihl3AtHzESe9sAvyTl6dWtVOO2PLV/PvSdPQaxmLksA1sFccfnyYt45zF9I7lTNuGm82UG2UEMpoDWnffWt7DUwmaKvBx4QtO2OBqaVJgIuJCOMoNHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llWXD2mJp2RTrOjmxQzU/cy1jrZ4LQkNvvF/nOX1hO4=;
 b=FQuWDYMgBON0S2jYYoxghlCeENOicnF7rNaKmVEPCAbExphQkst5pCGN6KoB/GUCkvUrkDNh8RTXyJ54LypRAJPwTnyQa9XJFcf2+uRN0JKv9MdwPYld4q2ONo0/3N9GiH9iblVgIbbq30Op6llctVg00deONrfpDZg9/Yfev80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8837.eurprd04.prod.outlook.com (2603:10a6:10:2e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 14:16:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:16:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 09/11] net: enetc: act upon mqprio queue config in taprio offload
Date:   Fri, 20 Jan 2023 16:15:35 +0200
Message-Id: <20230120141537.1350744-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8837:EE_
X-MS-Office365-Filtering-Correlation-Id: 86faaeaa-a2f6-4bfc-ab01-08dafaf0db91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KR3/So9riFsObkPJS9OaSpa7d27LRbqRRF0UAVXexcyFGh3c3R5Bb8gU7hQRjLbmi0Gpx7cWyc5rxprL3FRHNwsq5eBpjY9vCWxM4lQgx/AWySzBvIc2rcIWkx+Lrw4U9eFw98qAfVhOzG24xDPIwQcMPj1CXKzTXFvVPfx/caDHOTsC5MUU3fHj0CQsWqBjhzL1h8ewBlpUMKAj2a5mrinhmgOWG+S5sRyN/496M0WcFFDimBJuDEuPoGzovQwCiF9+UFcqHWW1+f6jHmOlXa8AbOCJCN0axXm8TmxeR5ExQWi/Ig8qI4skqfb2S0Y7Ld17NcszC81ALMJYkd4cRAEArp4swygrAZQpb+deDGVopvQY860UmQ/ypy34UZ6DC7VASCtnyTSs9v2bio3Xd2o0VJproAT84vzifLEs5ftV9vy8qGMyQ8WtrurH4JJ/zgFJduGiKYGmNMRdSpBX5cugugTpZdrDrPAnye1LmR+Bz3fROC3hF5KGQJIyqy1vu1oq+70AFqoT/ofZwI4B3lFMcWqTGvN6E5R0ZsWxvEenunZkqNmTXmJtQO8jJgeUzE/oqWPAZCkiDdiW2T07f0TUH+7pFJfSkje29xMzWo7HDoUcJQPEX9QVEEqkIYxZvOYh1fVUbay/k7dWeRG+N2oTigtJvAa74UFCa1GBxBKk+bog+Ba6uG/JoOwAcp8VztN6e2az3dZA/UAWmhJ0Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(86362001)(44832011)(8936002)(7416002)(5660300002)(41300700001)(38100700002)(54906003)(38350700002)(36756003)(478600001)(52116002)(6512007)(83380400001)(6666004)(186003)(6506007)(26005)(4326008)(66556008)(316002)(66946007)(66476007)(8676002)(1076003)(6916009)(2616005)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yINbfHbkAhv3Y9qHALvI49ijFlYpDrnn5vZxgcmvQj66lY/wPzvnyeGVmsA3?=
 =?us-ascii?Q?pce0W/CRTFK4zLr9uZqaUiLjZ0Gc7uDIuzLvy7Wb/YcsD2F06rSZ2Y48JJk8?=
 =?us-ascii?Q?tRjgg8oG3LgoULDX6Am0CJoiAiVcTcVoMy5SFe0RIvm70RtuBBzcq4uxU+r/?=
 =?us-ascii?Q?uThhnuURMDML+hASl0zr31cBLgAcIHNDwy529GAk+jtXdwYIJP/PRHfUAQ1R?=
 =?us-ascii?Q?AyTZTiftC96D0ElcklfzKH7TUNkpR0knFGklYO93ULw03zmMJh1B05n1f+cR?=
 =?us-ascii?Q?W9dZetmPSATlNoNUPYkq018bG4/pr6gZdiuAn3x+X67edTW2ULFhah9YIna+?=
 =?us-ascii?Q?GeTjnUXj125TiNlOA7+Q/AkXh5uMW+Z1TNzA6kmikmGkCJlWVq9Dwws+TNS4?=
 =?us-ascii?Q?LNiW4K58GzIDACEzAPpsgmh3ooDKXIcGZPTZu8KZqeVdrmRy7Pa5QxfTL0VV?=
 =?us-ascii?Q?bADw8wXxH5v4rv7utoQXCDe/pozJwltPFcKSlYQQ/0zrJMZcwqFPeWEWioJu?=
 =?us-ascii?Q?5nrrY0hIlz1uNbrckWVL7G5BjFsdcPWbarAMlsQY8GwW1xSDqZtKaTebxZZ8?=
 =?us-ascii?Q?+fWkpD+p9w70NWlJ9i8d1b49hxh4h5ZEOhj+r0l2qT0AdKMq7GoEHol+Iytx?=
 =?us-ascii?Q?U99ro0PAukw0pcMOVq25jGRAMaRL5sreEz2CBkVDIpArpDVAij+N1h3FXrNs?=
 =?us-ascii?Q?2zS2feZgumxL03RHMnTSyn2/0XzU/OcS0ApVnjs4dFSUbSYgOk6U+noRc0fP?=
 =?us-ascii?Q?TdkiRO7GXVZIAU6SuTEIdp7BktIN6QfV1TygYSAV+P8tIYTmNv70PePgihJg?=
 =?us-ascii?Q?0VDxV0xcPNd9vrL+oFCFMAGjUi7/PNy/CG+t8GlEe3oLFz/8XixbPBkjFWMZ?=
 =?us-ascii?Q?HWuKmnw2tPGV4FmCxet/P2t+UTMPE/sDLTuYD57ldcpccBoOGT+x8W6x9pCA?=
 =?us-ascii?Q?HZlRNXAQMChov2kPPmkKpVO+3j/pJzjOg+x2ToOoBE1eVko8YzTe22mCb8cx?=
 =?us-ascii?Q?qBuzXGBPETnXhvoXRtdHIGdPIDGhDMIb/t2rJbg7DrwVfL++z6yLQhjBz87G?=
 =?us-ascii?Q?r2NvCbdMxHk61GIkmwWHZAyMCH8l6OSWCuu6uqhBj3ARolexx7eNlsBI7Ymr?=
 =?us-ascii?Q?6KkyvyzEmXilO3YXE25/WJgTkSPdz0itMGlqEnJeR5Ri+ZKH2wlUhpd9rTeD?=
 =?us-ascii?Q?z8peRlW3DtpZnXETSjhG/QzOAZyGJb4y+n1aDdFup0iUXLaOZTZBKU1Ff3fM?=
 =?us-ascii?Q?dZhGw1m/iEPDcywFKCORmXwB8CZgM4+N+EJN/bFp/F3ymX72LjVBPY+uxxWe?=
 =?us-ascii?Q?f8biFje3G0Yg58FuQjU88Zst4nG14Zl7wfPvcJMVuZ+q1WpengLk1qdhDllG?=
 =?us-ascii?Q?YTS7F8Od13Quo7pGx7Qf6EhvVcNoRkpvVUA68/gbfkcbGWj64jLnR3ujtkBi?=
 =?us-ascii?Q?Skm3Q3YAwCvI6kF3MWHuo1UR1G04ThGDhkR5GuSzD1PuwaOyVopahokc91IM?=
 =?us-ascii?Q?O1mh7qHYQP5eFl853q+VisE1RuomWQKrw19m4yK3KEasGdiI6nPkb1ANXV0U?=
 =?us-ascii?Q?Aam/iLrh9GdOHEaTOOm/Nv25dNvEgkPvxM1SarezOsZy8hNuBiE4+jJV2TMM?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86faaeaa-a2f6-4bfc-ab01-08dafaf0db91
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:16:01.1229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWPcdiJfSawWNzDs7imih0dfClJSFbBX4yTLCKujLsi/lzZXsEw2e6T0Sv8onG9ROe2QmruCe2oPA8EzrzlTWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8837
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume that the mqprio queue configuration from taprio has a simple
1:1 mapping between prio and traffic class, and one TX queue per TC.
That might not be the case. Actually parse and act upon the mqprio
config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6e0b4dd91509..130ebf6853e6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -136,29 +136,21 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
-	struct enetc_bdr *tx_ring;
-	int err;
-	int i;
+	int err, i;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
 	for (i = 0; i < priv->num_tx_rings; i++)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = taprio->enable ? i : 0;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	err = enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
+	if (err)
+		return err;
 
 	err = enetc_setup_taprio(ndev, taprio);
 	if (err) {
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = taprio->enable ? 0 : i;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+		taprio->mqprio.qopt.num_tc = 0;
+		enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
 	}
 
 	return err;
-- 
2.34.1

