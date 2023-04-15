Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC0C6E32B2
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDORGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjDORGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:13 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2051.outbound.protection.outlook.com [40.107.105.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347F30C6;
        Sat, 15 Apr 2023 10:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoEzDPcpb6zybCbGCVRxDDAv7/Vyy7RquR9WgF/rvVdeunp/nha9xYWwwtWg3vNG3bRPdzdRLPgqVCD+ZlcILHi5VmMI17zrZVq6t8LE6+Wd0ChZ2WmLyfSDQH1qL1LqqcbzHBVysBgR/F91Kktp2lEIrVM5/It7PmYt56hhlJoG1nqfSk6sIeNQdmJX+/BNcEdkKCuaXqblbwXvWKffG2jJPeN+xO+KqCKOxAPE/+Tv9jb5GjJ7EEFjOhlvzyOBubCpZsgYwHVcnp9RoTdGkP4kUFSQqlZCBff+JRARZgPYG6QsonIuOwBVTNu75CMR31kdQMGM7G12DcbTr5HkUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWkntbgXSv/6lj/Hl4WkY8QQTPipH9GuKxcfWo6w8PY=;
 b=hbTcrbJM2+wAm2XevH/0VqxzUqBGTOWOnvQzWUftk0eFDUsU5y8dHoy0U/BTJsiAJkI+VYokuW0ZSbbjr4rVo/kKcRR/Ed84Qud+sDMmpWfUWqompGQy0UiYMvqJvrns1rGeqzb2eH/nPTDHhQkO8l8rikBFoSEtdS3mRnDPpBLRKoGDpLZ/nuY5Fd2p3bTuNcan25er2KFYu4qOGe6Ob0u3f6IY8sxmfmDkzFSwiaLUKNKhIjCZAnHWScLOSPDv+sBWAWcr4XORaJ8WGRB81+SxOM6c8/DVl/rmSq7Z2GuWBfmv6bf15xbVpt2ckL4/7oNYJXwEZAwATVSM3fxH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWkntbgXSv/6lj/Hl4WkY8QQTPipH9GuKxcfWo6w8PY=;
 b=PGn2xXeLt4rO1fc5VGBM0As9tti9C4TD2p3TIGW5bg9nxqT24FvWyxbVLmQ5/unIlfvgmMc6ZIJJNq6GHJ+qfXUTxChQNFYUdBGjbZ//BJS5B4MwkOaPAzlmTDSsbNkIDh0I5JpdpfyQJHH5D4Gu6COTVu5ilPzSOFuh5DLXDdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: mscc: ocelot: export a single ocelot_mm_irq()
Date:   Sat, 15 Apr 2023 20:05:45 +0300
Message-Id: <20230415170551.3939607-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: caa91a49-87d7-4c78-52e8-08db3dd3b242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MkOfBtsZ5qAtDl5I7SPkEy/9QRAu9IQ8sPswk+JUapUXie155BL/s7raZQi1DlHwYJc14XTsnQNm4CcuwOyL+Gns9+Pv0IBHK8PfPfGEXvg26E67sxYv6Y+RDTor6TZCDRm+sldS4jTQmw9gVV7s1q94dLzDY7s2EOmjTX6mzDrM81hFsL61m4ok0af2AzO24IeEZb7jjLnGNcXLckWtDYKu8Zq1fZAX7P2+Y/4h6+bo+3jegocuLLqmhQiwbqjsRpQoTFnVbZWd9GdPa/YjOdQbYr9LGr6pAycg0dfaOeQem8KAsVwbxFlB+iFb0QAaIz0YUY3sO68xgfGPXF6m/B1UEnyrSOp+d9aH46NTAVf7UFMWpS+TCvs1aYrfl14/289qhbxj31irzoubOrvIxKsu46kw0d2ph/L8nae797IbUIfdVM95cXrhHFWCNjsQPyxpXlcN/jPl07oN2ZMttnVqkRTVGmT3QUyJZGrb/hb3RYFqD1Tg6F0RBAE5Kx4uY5V56uvPOjoucKyb6NKotmxOkbzcHPcxoqEf6x3dMEYUeG0TpF49iXNdubXLLX0rRMvqQpmQ6UAiNvaAwBpszx42xo7t+M6G218EWyYITcroYrmnCOUdiF9IuYfEXHvt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xtb2jnmEp4j8Qtm5+w4KRepmBjJSqOjQJvUlZQ1n3WINX5VYPZE7XXGM+BOY?=
 =?us-ascii?Q?qDoXu49lkn/zk4pmvMb+zKzMnTDnFDKMsbuCFmN5yCYHHvEp8ugSXRY6a/gH?=
 =?us-ascii?Q?pJSkAFbpipgsyw3ZpMGtSNAysq60YEtNLPxMTxf4WW1hPalVHiK71QfhZyyt?=
 =?us-ascii?Q?M3etRQzfZmVT6ubsYQLOjM6EccRyfTvWdr3HpK0fp8MYn5pFVqUBXarAhzpa?=
 =?us-ascii?Q?J1ZDmwknB5jBjwZHvZqu07jAMHeH5uyTJ8WIkaGoBJEOSrfT5ywQEG3k74s+?=
 =?us-ascii?Q?OhREL8Z6NhhqoAc2ae+F/aiwtI0F1P1tL3kSL2r9rttJA7Up3NSZ/9plCwIU?=
 =?us-ascii?Q?dGVUEjsG0dMxBcS5b/GWr9cemBcwO02MXq81LJXF23QG3BPIgiKMU6Eo4Rj2?=
 =?us-ascii?Q?X+Rxq3eyY8sty18wGWdB3+/S9Fzr9YBlqqL8R2oAueZmhPcGym5bEa2o//f0?=
 =?us-ascii?Q?HoXfF5TZ9kZ0J2X8k+hLYWPSWEKU+9B/pEBkCygfJsbrLXm/liHXGw21MwUO?=
 =?us-ascii?Q?wnVJwSO7zSp/u6ZFzSCA4EvgBr4pc/eMRRpJCsgyIMMv0u5a28ZiaVyA6xVy?=
 =?us-ascii?Q?tV53O7oaii7Cinpg2GAZkd/3rhlE3jnLMFcj6QoJy5N6exaj8vd+80+YWkh+?=
 =?us-ascii?Q?8s8h4nJLf5p1iI0KdKYnqT7S8WufibGaiaCLzdMSg55bVjMUhxx6uf4v0i8D?=
 =?us-ascii?Q?j3oD638s7SE+HWaDX/MpEqalaSzwkXO5hQJi52x/W+LdUJDrRAs1lH5O+YOh?=
 =?us-ascii?Q?eBd9a1BgUAhyAWYSwJlJOdq4ktEun/EQsknzQ2oSuorRlmkPUv76vMxpXHgG?=
 =?us-ascii?Q?SZDjT4kyazvTXdyqh6+an62ticAp+aznAOsl2qp4phpfJpp7gpgzv0u3ju03?=
 =?us-ascii?Q?nYxfpuYz+6BNfOiuOTOMexsRfyr/4eRPlSN6oGWWt2MqbQ8vLzAISLGlTyD1?=
 =?us-ascii?Q?/INXbUtahUGE8WlXCEVh7IYKiJM4k9DxA5RTgKIk6kjd1F5OiIyPnToaEUYu?=
 =?us-ascii?Q?XAk8iddfzQQfWPjzreG8110aaSlw9e6/8YHHwVurasmAZ1cURkq4qKUEjWGN?=
 =?us-ascii?Q?n7Ueb9H6lsZmmsbmLVDSmJo5NmXv5AtevJFe62gSA7eBWh5VLUD5lgwKfNpU?=
 =?us-ascii?Q?vsH2btHp0p9OIuhfkZv2aINWQbKOxYcHvhx9gjrFk9s19CHz9KcXoIvdCqpk?=
 =?us-ascii?Q?iGS1qCd8om3QvxjRXpbb1xE6EpNLUqiz5eIuk7woXk4zx+nI5LSyNGM2UHXf?=
 =?us-ascii?Q?7BPrz0rtGMEQhTY5rlDattmtfFx4PW8VzZQUwNRsHYXOCUvT6l5Ahw5oQqpE?=
 =?us-ascii?Q?hjz77ND4nQdxh+ND0bhxpxciHTTtaYcytGy3KytTEXcgd5tjl9xbtzAyV7TL?=
 =?us-ascii?Q?uNReoOsE0S8VPt0Eh/nnpttYmIF2szUDNimIb+LERjYitP0xHzk+3FpNCV/p?=
 =?us-ascii?Q?979ZmfIBSK4jVP41hiGhzet1cDXaS8M3F4PJBvKWEwxgQCv5TlSiTtvbwvOo?=
 =?us-ascii?Q?Aacb3pG92fTlwvlMIvAnygh9PBV5eUIge1qsyF0gQ8A2hvcJCgGcxiNQ1nt2?=
 =?us-ascii?Q?N+ThaZbskTVe8+o5xmd00oDa59xUFZzGMKKxpjgx2JQcE7dSsaNS2VQxDtPm?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa91a49-87d7-4c78-52e8-08db3dd3b242
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:04.3436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbuJD2bI3iiFTw6wSzFAcsEz9HqNBiRl82h9ZmXyye6dmIbZhMarwRxFOkqKOQI0ASKTt6LBfY/xcUm848wqiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the switch emits an IRQ, we don't know what caused it, and we
iterate through all ports to check the MAC Merge status.

Move that iteration inside the ocelot lib; we will change the locking in
a future change and it would be good to encapsulate that lock completely
within the ocelot lib.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Diff: patch is new.

 drivers/net/dsa/ocelot/felix_vsc9959.c |  5 +----
 drivers/net/ethernet/mscc/ocelot_mm.c  | 12 ++++++++++--
 include/soc/mscc/ocelot.h              |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dddb28984bdf..478893c06f56 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2610,12 +2610,9 @@ static const struct felix_info felix_info_vsc9959 = {
 static irqreturn_t felix_irq_handler(int irq, void *data)
 {
 	struct ocelot *ocelot = (struct ocelot *)data;
-	int port;
 
 	ocelot_get_txtstamp(ocelot);
-
-	for (port = 0; port < ocelot->num_phys_ports; port++)
-		ocelot_port_mm_irq(ocelot, port);
+	ocelot_mm_irq(ocelot);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index 0a8f21ae23f0..ddaf1fb05e48 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -49,7 +49,7 @@ static enum ethtool_mm_verify_status ocelot_mm_verify_status(u32 val)
 	}
 }
 
-void ocelot_port_mm_irq(struct ocelot *ocelot, int port)
+static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_mm_state *mm = &ocelot->mm[port];
@@ -91,7 +91,15 @@ void ocelot_port_mm_irq(struct ocelot *ocelot, int port)
 
 	mutex_unlock(&mm->lock);
 }
-EXPORT_SYMBOL_GPL(ocelot_port_mm_irq);
+
+void ocelot_mm_irq(struct ocelot *ocelot)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_mm_update_port_status(ocelot, port);
+}
+EXPORT_SYMBOL_GPL(ocelot_mm_irq);
 
 int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_cfg *cfg,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 277e6d1f2096..eb8e3935375d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1148,7 +1148,7 @@ int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			    struct ocelot_policer *pol);
 int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
 
-void ocelot_port_mm_irq(struct ocelot *ocelot, int port);
+void ocelot_mm_irq(struct ocelot *ocelot);
 int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_cfg *cfg,
 		       struct netlink_ext_ack *extack);
-- 
2.34.1

