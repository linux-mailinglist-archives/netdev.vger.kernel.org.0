Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20114B8B81
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiBPOdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiBPOdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:25 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B3C28B623
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBlM389KWvXFsF7TmFx143qq6SS+JCgyxfHy8g234RmSfM7HkwmsVRYKfMSIt23ZWqjGlL9r5BgIJMMKxEUnccLjviL2Sh957IqSLTfKHA6Aq+SwjPda0ap52H8xo2TO1JLqYwT0Asu1wTjQEjEvgOyheBshos0vqQmIw363In7Fg+d1vW1KdkS1HKzRfo9iFp/z9GEkcciFFcBWiC9FrbWW/sfvMDQ4e2WFnYCjmG/3a86D16Wyz5KGOyycztFmr0sVhcERnvxeuQW0LMZDPwiNQG/+tICIEaBd+G0gKk/r48384yLnaYcWOOy9P2Qq+zke7zxU+0aCRsTPFafzIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaUnOrL8WLG+OwtdLhJYlwXTOOAhK8f4ZMEYJkzD1Hk=;
 b=RqLL1ozKQR5Gt3n6m32k0nHX9+IoWguWPCrKwA1RTcBPq5qTkFInY54YjWhULMMlV/5d43U5jn3cjNOnFV/8EXoEg/6rd3KLAwv5hq4Hkz4gU6Ax/eWN5CnK/Yiqbnk0tCsr4lxdk6tIpwU0BU0h/DNCrZSPddi/s+sYJENn95ZYNeBbOBA+sW3vsqKxVt40wqb+J8vWbk/ku0pzlNxr047BnW5cUSBfOdfj4ALC7k35E0Rd6pc6nnfXS0/N+/WQSNYa0spakM914bWyqtDjrV7cY2O2Rk5Z8Z1ZQXUQris8CzAvoOnm5uyaSBU1gEnggPJk72yEbLaXIAxS8DpFqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaUnOrL8WLG+OwtdLhJYlwXTOOAhK8f4ZMEYJkzD1Hk=;
 b=Ph6qZV+61V4yBzKed0BZYxee+eBZJpyZ4z5jtskjupFzqHhti1JflLvKctTEE6PgtTeacV16MsNs8OoKKcats8EHZNnPv+3k9ghcLarLdxJEWJOT9fTVfWy/4F/CPOCSKlXwKWsPNXSjC6fJJC5rmxrC3LiVYQ6C5TGMHIz/ltQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 11/11] net: dsa: tag_ocelot_8021q: calculate TX checksum in software for deferred packets
Date:   Wed, 16 Feb 2022 16:30:14 +0200
Message-Id: <20220216143014.2603461-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d6591cc-502a-41ee-6388-08d9f159351f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB68159020D2298754623C0119E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StNQDy1h00iKHYk39AfLT0rGUsU5eUmilk2ghFsFJhhpSQ69e3QjnZXSSJjwy3BM0OXWXzX/3NrRw1v41U7FcjBG0Uz0QhRnE7s/fDjdDjW3MpQsIShryFuXB7xfub0qiivNfMXASDjhIp/SO7SgEn/wz8LqakOALbTc25ipuf9xkbxUNFIdkHOYvBlbb32VDM8UliXart/2fjK6/PyhPMLrg4AxAibMvlFCusdQPjPjusOIkzo9+rGtiZPaWSl/cS1Li/v/t9ib1YC70/43Xf8JL1hrB1+KbFO5Xa7/O2ArGES+XdRhtf0C2JpWaS+DSXHYQwc1Hbt3uRqS/nKxYNY9rl2X8itVhAr+aGry25m7WndA37E1UJwfWCtWTu0Zd6hZYEYJEXKpscHEP+23N9RjLRHZfhgApGW4KjccA+X7DnWaHxj1htwifpLSf0aYk/90eBR1FDD1dfkZ12UUvbFm51F/K/7AASpLG2Bl9kLDQR9HZnuNqOFnAdPhKVol8dVJi3AFPca6zJu5UBR9QQPIIrYV9Dj3AojKpkP6C4x3BibG15wrWQprFzWdwsbQqodJXe4pU24bGD7CXrmky0Ios0/hHSBpB2nZT5up3Ki+iHgQTauK8VBkef1iOsnz3cK4JYhsQlp8kJFeuNjHrv/aPrCo3aDHuvEOdcf3bRPK1Lje5s5aDectql6UsXjXl6vhySGLpTB5r9rG+6MiDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WcqMbkgDwrky3wEIfLQCad8+3BMvh1SrnEVLKAy3kzWDkep9Tb/n20JMmEW8?=
 =?us-ascii?Q?e0gCwNaYOA8nKX+MP+bhhfj3WUjeppO8+j8wL8IvUOTJlwEaULpBs7FRd6zc?=
 =?us-ascii?Q?s9RxFI42Jm+S9+WcV7i0/0LHynJLbuZrxOvXr0X2WSdrTIZSFTTjnWw7Juen?=
 =?us-ascii?Q?LCLrQsa9v6/KcdpMe5IroyJsQn3n9iMVc8pZPiANftPvvOEtKzCw1a5u4A2+?=
 =?us-ascii?Q?wTYhsA185gPMVted3F5bdUUwGX1HrLcgcT3cTuUIWKLUcyMPox+jJxLM8PJn?=
 =?us-ascii?Q?xa33iEMl3A1SdMrjKN820trm+vQrZRve7Gy6s9wSTTrSSVm422VS6oKeuT2F?=
 =?us-ascii?Q?exk68rHxKmz/QQMY279v3VMmFl4+8sFHsT1O/8ZKsqWcJiEQbXmJetAjIIMB?=
 =?us-ascii?Q?txvN+XIDElQr4c58dsm1fHdXAB23tz3b+n4XRkD9Kxtkb4t1tynfinN3eqoT?=
 =?us-ascii?Q?3kB3NG4ZrpQx5NZXe5Zqk5Mt24IXV8HiqEwEWNECHRNk/tE54EqHCWxZw3VQ?=
 =?us-ascii?Q?cm1pA+qRAjjbXU4HoSsYaugbHEbinPa/qsu5fcnfz/g0Xn5OPIoTCEaJdlID?=
 =?us-ascii?Q?TxMYf1aL779TeI+yorGQszFxjfzEECSwuHNiCu7DYu+IkCcqkg9zV74fTvlb?=
 =?us-ascii?Q?AMycZ8K2ujLDrwAMttl2DT27HTBVFvcZ3N3YNhis/hQHHEkqXkW0lKG6sGN/?=
 =?us-ascii?Q?bqNsczi0Lj0WC6/UmfBStB2fcvSUXMis4zbryc8gCqk5Wf8YHkVcVTL9Shs4?=
 =?us-ascii?Q?Izh0MVzrj8w/0xkShSxPcq1f6Cvx2XryjsW/X84dKOHQwpsjBtZbNc8JJ5/D?=
 =?us-ascii?Q?4aHFBip4kzrqyCsfsxE6u1E1fbdbjbsL4Sk5fch6Q9TSk/A8qs5EdIVi5/PS?=
 =?us-ascii?Q?DbLe+Jmn27EaB53OFHIT9c2vvDo7Ir0f/sc37xxDfkoz6cYFVwtc2JDMniYd?=
 =?us-ascii?Q?Ps4qV7mZBR91C0PRf3vY6SIKIiaXM8m2R9Is9we8RslX3pyTzIAYexDlrNkt?=
 =?us-ascii?Q?ExEkhKzSl/95eEd9hvnZYTFlp1AcmsAKBMUjsn7WC/UzEa3sFl3yDv1ldM6P?=
 =?us-ascii?Q?h8TD6uZXQr4Pu0sYH/aTwnQtghtmCLLY1sfYykE9poU5gfxvFJKWA7NEGjrM?=
 =?us-ascii?Q?RuIar6mMcCQXJpEBfwyKxIZYyQSDHzWcj2n6HMs0L/fGoa+UM3uMSVGu5Ck3?=
 =?us-ascii?Q?ZcDzcwxFZ91ANNJpRNxWas6WV16fMjxAh5ywT9ukbYH6LbJqitvPxEryVuhz?=
 =?us-ascii?Q?GuTbtGeFcQjrdcmiOdylYvlBDzDiH7g/KkiolSbZYYfY6u9Cp21hP7779gor?=
 =?us-ascii?Q?9rRp/s0gjILwdzJ+mZaKhlftMFF3Zihc6n7Ci3snqLFNWaOdCivizuT+gtX7?=
 =?us-ascii?Q?iG4I8IhxIgvQ94IefmimbzjIK9NJQIDYn+vbtUY7xtSpHKRNL6u0AHOL9vs2?=
 =?us-ascii?Q?T2Awk+RpSKPzrlAIKFnNVVWYYB/ZyHBJqlcIaPe+kwFoAjzg3nAQSp6ZWKpo?=
 =?us-ascii?Q?Z6HkCp77liYrxKCsf1J84tlVyeGnhZLkZHcm82BmKTfsewkOM6Agnv8BeSGT?=
 =?us-ascii?Q?bSFive9I/HmtMlLlY4JKoFRcFpOJQhTiRKZ2B11LZtl9aeWGAj3J9N2ETNbF?=
 =?us-ascii?Q?JI3rPD7+CxExk71xI098SLI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6591cc-502a-41ee-6388-08d9f159351f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:49.6987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvfh0mHPgrTawpWCqy6Cn/AzbbiGYNxENqh/oxu6yGVprbOdI75XAfCPtxCjgFn5oVg8iVRhRo43ylw0Vr+zGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA inherits NETIF_F_CSUM_MASK from master->vlan_features, and the
expectation is that TX checksumming is offloaded and not done in
software.

Normally the DSA master takes care of this, but packets handled by
ocelot_defer_xmit() are a very special exception, because they are
actually injected into the switch through register-based MMIO. So the
DSA master is not involved at all for these packets => no one calculates
the checksum.

This allows PTP over UDP to work using the ocelot-8021q tagging
protocol.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot_8021q.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 68982b2789a5..bd6f1d0e5372 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -32,6 +32,13 @@ static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
 	if (!xmit_work_fn || !xmit_worker)
 		return NULL;
 
+	/* PTP over IP packets need UDP checksumming. We may have inherited
+	 * NETIF_F_HW_CSUM from the DSA master, but these packets are not sent
+	 * through the DSA master, so calculate the checksum here.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
+		return NULL;
+
 	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
 	if (!xmit_work)
 		return NULL;
-- 
2.25.1

