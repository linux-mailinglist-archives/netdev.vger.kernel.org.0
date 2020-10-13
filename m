Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B3E28CF79
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387954AbgJMNtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:32 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387886AbgJMNt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRchHkkRop/hmbRkl8BkpdBfi/4MZC+ErWHSpOdGt6bAsSK2oOPPtXnNjIH0Ik71VSdJY4ipXd33kLFkyKfCS5dhF/ek3DGqW+aERetTJ/yK8FN0ksSvjzxB3/oK1mg/54fDOUUki+nOUcp3FigIaBaA+IBE1oiuZ5AT3qiI110OdXzvHiLVBZqEvbNc+vtJoriEnv2jkb8aTk1MiRCGBokP3ZF4Rwqe4PsaUT+7NXk/0fM5brT7sfCrT0/Yro6wdmKzS8J9fuektUn3IF9LqbBVnGluwkvZ2gta54Kkjj6rRnJEVw8Kjq3PneivKG8sPUfNHf1rviLBW5cgGhQJgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9Cj0ihlJLOunYA4o0pVHu5G+zqkaU27IaFQOGbH8Eg=;
 b=T6YY5yzUak5ryW8I3H2MNuvzmE1h6n/8jVqxSTlgaYcRJTUCJMuZDU2lo8ZMX82l5hZ7d7Q9zqVTRsv+mLiwTC+p1tzHRgnbUFJDBEx5setj4ePN9dQvlo3Qw6hq9NZL7Wfn6vAxkSKRTVRXZlVYHvMrLLDT+y7FUEgvCwy07UsV1jEZMWX+/37PlZNzEbaS0F9o/b2etLEs1CniS4h+4AXHlDhwIz/R1XvVu504Deg2eBtjoPgwwCHq2pKLhQKb5AWPxJu3JxMOinrOf+mam02JLxFFXHJbrbd4rXTPByB0H4BZeBjMBmHGezCfqOYWUDXFnwl1aIQBg5b41/dCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9Cj0ihlJLOunYA4o0pVHu5G+zqkaU27IaFQOGbH8Eg=;
 b=bMMMDrmbJqvfBQVu1En4NwCcOBH/FA+ybjIlRAhiJeCgslnTVIs6+aYvoIcAjd4XxRA9yoT374Y07NbsziGbsNVJ31MvKtD0rQIHvu/u4BoaODEu5wATO48H/aaD3n3FOq65nFPWLIH5kq0snPf+krNCM8YvF+A8F+B+cEMUgVQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:16 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Tue, 13 Oct 2020 16:48:44 +0300
Message-Id: <20201013134849.395986-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ac36954-28f2-4940-4edc-08d86f7ec642
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104E654A512C5AF56BFAB61E0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rt31Cn787oj3th9mYl4si06oEEawakngsZ1m4rI3/p7QNVs6xkXbe7M3MULMlXrmB8U32wM72phLODv3LMyW4ISR8Hk/O1dfKGHb+GS9a28Uj0IqAOi6x1rBCY9WycMIzxgTiqDunniwbHjl5F1R6NDkHWAqG3awJKa7mlPKNzL+wznYeaviIf1/UFnSh7Uw8eeVB9k0Fx6jKMqdjCGW061PeL0cPhCTKn3k8JyI6cmHdcZMiwZeclov2G/C466DRTvTcZuK0vNyV44iM496QaYtdtr7gKNja3vPfFcbOtmH10EwxgW8JNTJviN6HndpgpOnk0Q/90wP/5p+4BPPkS3WBojtJF3gNK+s5/qBWwxHDYu0lxusHmrRNJhf1Aph
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RoZVC13OZDfMSlzWCm2FYLHKuGGYkVO3UX86Ia/Iwexnk4A2XeL6hufSuTCGchqIy+DDeFtijGwf7aL8ACsEo+7Ir1iqXwn0MyXKoIuDTJ8gXk6QtUN5KTs9Pwm22UVHXC/PpRhN01h6WndhR1wfAWzqct7ZIajkf0BiFjn4hDyRq9N6fBc6QTxhMU2kPW7NDfVCf7RhaLTA7bR1yPbXch1E/VG+4Ci3AaiQQr/jqciDXEoxhBtYZHwWv7OVN6YaOr7rYgTW2YpeywsQ9uEeJjnpgEGH+EnEU8wz8FHc+YLvPGAJljARJdObG77K5WyDl+aDzaO8iQ+9OtF+i7HVgKT3nDI7d7pNVUhi1xSCFoc11Vwn2pz0Nn2JKasg+S7lNre8GaXkuBzaJATj7YPplJCzaYJyxz9e4X0I+HZ1vOO/Z7pAu7q8OWZ6PTCor+4Gt/8nwJB+5PijeUBZ4uJA+DoKw0diLtyXBd/ZujSO/xllW3bvjdOpfEBucB1vEt+vgbgJ+OQM84cg4CONghNc19/FzQE4H02h8cXYKGWoCnApaJpbonmOtE+gK6HC2gnb6UfYjLxCrG2tTBCE+mx2lMnbEzlIOo8X+oWwPbPZ/LGURci1RI9+tk5Pb/bqzSPlap3/3TWk20fbgLt7CZgr1Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac36954-28f2-4940-4edc-08d86f7ec642
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:16.1578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4hgq70xg4fEkwokb92NeavE+14YIKrfsl8vkwiDIPQ5CGnsoBPtbHPwDr21+BiVmRllpHxvh1QJ0QUujjnBmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general it is desirable that cleanup is the reverse process of setup.
In this case I am not seeing any particular issue, but with the
introduction of devlink-sb for felix, a non-obvious decision had to be
made as to where to put its cleanup method. When there's a convention in
place, that decision becomes obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 184e3f79f579..89d99e0e387d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -626,14 +626,13 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	if (felix->info->mdio_bus_free)
-		felix->info->mdio_bus_free(ocelot);
-
+	if (ocelot->ptp)
+		ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_deinit_port(ocelot, port);
-	ocelot_deinit_timestamp(ocelot);
-	/* stop workqueue thread */
-	ocelot_deinit(ocelot);
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 }
 
 static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
-- 
2.25.1

