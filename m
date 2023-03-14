Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433096B9E3A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCNSY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCNSY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:24:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F91793F0;
        Tue, 14 Mar 2023 11:24:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzfmewpgFHUqiHp70WDBIM7VhyZTEqPpoi7tA8TcXxqNdLspV4vp4yU0JIx4sW2uzng1fRE03F0ZpfJuzNBNImUtCsGlEi1s+VLVZA9LOqCjEIZatvUiEt7NHChGB47UWTymPfSaWRAr8aCBfbbyOF/0UT4b0OKi3gsnY+FRKkywMvIbhIYChILIbRUnK5qvGmKhMHTWCuA56UHcMDzrp7L9s+loAs/uq74qXVTOjEjv3OqtrNF56bcjtGhSRgT5xrOTqpNApse3FmsgWIUXiKldR8WiC+soqsyO6rvYf0v0+2p2OHC8P6PRM5n+WcxClnPwp8ZfD83QVBZ6EHaJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ji1AQ3axLN5PU8CX5sARaAzzFFdH02wUSgwLO60BNqM=;
 b=aqBtgsUNm7mz8sX4xTyWcU5C4I8xD3QEbHAWYE4xFTnfi9eEcJKn79V8J0CS1M0SxI3UX/nQhQa19ksfmGKGZGrlFZYZ1Zzau2qZbhB7tNcjP32WEGvpCfU8RTrFHnsgRs+itNBHNNlp93MOb3snxASL7sO5hw5b0l/qZNWz+b/LdiSz4ik/o+19WJ+yfnXew6C/bCxcqBwMfkJ2mjdA7S0e9pCWI+cUHatXhT2G4ydJEqERjHvXjH1y0FC7MJjNxAHzQjoDl/uEZV2CBQ+JGFGdSCgo3uocl8TcDYing7iYNjmLI0wCJzwlnJWntTJTMpZFoxC/Yfz0wS82wH5Itw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji1AQ3axLN5PU8CX5sARaAzzFFdH02wUSgwLO60BNqM=;
 b=gx4bQMrw6GhJx1qPX0D+icQJbzLruZ3zgAhNS6t+j5E4e0gS+uU46tCvceCeQZ+8xM1eRj2ll5MnG+YfAb/FVaCeKAPP55Zy7grFYl3z+/lVtMZS/n9drxi81Bm9S0wDh4M1ag1ANFilTNPC22H8tzRDsTQvJb3nxwUVmN52TC8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9104.eurprd04.prod.outlook.com (2603:10a6:150:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.27; Tue, 14 Mar
 2023 18:24:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:24:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290
Date:   Tue, 14 Mar 2023 20:24:05 +0200
Message-Id: <20230314182405.2449898-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:205::45)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: e0c2b817-aa13-4c25-deb5-08db24b95499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFo6opIEFk7fJjNsS7Z93abvTOsCHxMvmdWZFdE89wN1FXYvKp88jYgLAhfcBkPdLQFidugHRj73rtiHc2x5DE2ZVgBVbY1Kzepz7UveiOZZg2DKWuskFqsMoc959RhQFlCLBu/y4F++NxbjiRCJSe/PcfKd3vqNjgtLVz8TJXDU+4c5D4X6vT0rGIxUx0ffwcJbsznL4woqr2vdAIZD0lqTW6ekYFgm9UxCeCbGNJQCW0Vtcxffj0Nq72aYW991+S/BH/APBnoFkFKD+BebL6tSFxeXWu7HwUKp4qrq2vLnXusbf15Dgch53JHFbHx5fKgJZD1tUlCpexF2pOjv630PkWkEXc/q6MIGmdCNPeCt9w4wrAfYgg5FM6zlPGO3TXFI+tzdw0ai9yahrWkC9fmzq7FxVHLq5WIjuOgIHNofW6pRpCSCvkjdqleBbtFbb9aPbXXzDwojttBzotVuusrbT5cEztInEYSItTqrBzfYjaP8vd/0W71QuzmMtqbweSFvZ4QsGoLWaoOcSrhS4UX12DcPhP3sKPxHwvJigck6AVvzHibFp0TuB2qUkZ/OSGiepi8fNZgeT4Ha0l4kjXa9hCwMeOFqyKyKCd/JvRYw/MTNP8SH8zfyhahN2OTEAH3DPLeJVcv/d10EPngmCforzNR8A9R+HeZoUwlapW3KnqpbcZ8D/2A15TxSBKJBG7hdzShkITYnAO0BQj61tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(38100700002)(38350700002)(2906002)(86362001)(2616005)(52116002)(478600001)(6666004)(54906003)(6512007)(6506007)(1076003)(36756003)(316002)(4326008)(41300700001)(66556008)(8676002)(26005)(66946007)(6916009)(66476007)(7416002)(186003)(6486002)(8936002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xa434fnoAUR+ZWlcjGAfK72YiRb4l1GoUaLhzlHcVqs9DgcoN0gk/ychETdI?=
 =?us-ascii?Q?aHu6WSGM/WXLVpeHoNVbbnoGL22+gSo4Pt+K2gG+dXuZ+JmJs7s6tbGiySxG?=
 =?us-ascii?Q?WPjDUvFgq1zbRYvrHuEHA3pddlS8ml9sfRQEsw+1eAHWcygnpfcKhBy01pPO?=
 =?us-ascii?Q?XUoVxrUQFE52gv67h8ZyJuro81jWrwVbKR0rZXwK4O1mRptW8x++lC9N/jMe?=
 =?us-ascii?Q?lUej2PedFYByXVPzx7/okU5E1HqxonqfxKQ9NlAdrx+gar7/7UiUOhoJ9Npl?=
 =?us-ascii?Q?2mv9cGguz7v9eAMwE3aOQBAh6NUdjT50yxggSq5X3o8oTTnXADdXr5EUfNhE?=
 =?us-ascii?Q?avjxTVih0mEhTYdwWaxzVK1gyhSXGLvMp/OYZdwKpKvZGpKzVkbNfYCzeQje?=
 =?us-ascii?Q?QW3U7I0fOMm91aEaQHj0W8Ehe1qVFet2e/Atg9fCFB9Ds2ef16OoQ5KbYc9u?=
 =?us-ascii?Q?TVAxfppIB00a2GRX3iPfk3C6aw6OSpO/mfDiKUzU2PQUq1wBfKHamOtCvZsz?=
 =?us-ascii?Q?bJNFOZ13GwJW89AfFYdI+IytfDkbba/26HpZqOMsvT6qDMZgURrzfpZqgGZf?=
 =?us-ascii?Q?wRzEC5dPeW2f4c0wPFyDj4ytZWAfhBNcfKnOB+n+8QzNudf8shGvcC7erG4C?=
 =?us-ascii?Q?gSYqU1Fpsi9tCqQ770ZI/odH8uIHk5ZyLU6ILjlPq5NZmpwe+6EXZQLc3KkW?=
 =?us-ascii?Q?ORPUO4YlA/mDtCDTQJEvKoEm9X0snLOYPeufmmf2PLwAlW978VTpLg/1bZBL?=
 =?us-ascii?Q?twH9PoLtQqbj9Y8QGRoaA/7KTXiJh4vLowHsDZRgw4h3vZloz7FGRoMyycSY?=
 =?us-ascii?Q?SaTD58ZJ94Lef+Bga3cHX/asVwx6L5511uD83U6eL1WjkyHlWuS6LguAU7kD?=
 =?us-ascii?Q?SCoSXlqD0UDN4nvTYEdI9wtN45VNADyZ7ILeMfhtCyXJOMYT6VuKqP5sV+bp?=
 =?us-ascii?Q?+XoHD3GAcz+JTak1qzr9cq+1SrgOnRpIeLqZ/6AUW1JCUiWOgYhknE+YcBin?=
 =?us-ascii?Q?TSMiGyTldmXfHOF+AWvhKChtA0kCoobmhE7hogJNulmso/HD3DfIM2aBqXfm?=
 =?us-ascii?Q?yk3s3s+FdFF1CPexfd4efw/r4z7Tl49UTAApbVMG0MILYrr0Pv1vlEV0M5q1?=
 =?us-ascii?Q?I73waLwzVkrNx+UDfvz14uda6i/orrHt08G4usJ472mecdJsMidXqI5g6BMD?=
 =?us-ascii?Q?vLQhnnq6WePwYHSbYGMQBHch3wzdTLO0AABiif48f6jDxSGgcxvTYUI6ft12?=
 =?us-ascii?Q?aI7TTa1fXe1cujixnfwrmXqu2LlbnUpR6BdbM3CAdjJqFSnhqMT4oN3I9zVz?=
 =?us-ascii?Q?OdWuqlh6niBoibiOoabINHf94zuHKMczIyEnty67GRT4ohYOatOFTO07SLs8?=
 =?us-ascii?Q?ZVSDM4Zsc+cyD99muEnSvuTEj0dyOgCAw9hbdVfsfcVHB+UjdbWyIFF3ptja?=
 =?us-ascii?Q?vwm+SD1Hrzr6QIT5we0mSQneh8FiGoXilwek7SCNSpVlEVVEPKecixUdZfg3?=
 =?us-ascii?Q?z5m16z8vhPL8xS7UEI9yd33m8p5n3DH7ZbC4N28I9ZIxG4aevc2XHgz+3Enf?=
 =?us-ascii?Q?Ze3XUtIrIKJasovOJ6QvHctFwJeMAzWeen5Bq6MIBm3Ixxdem5WJ5yI2P/I5?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c2b817-aa13-4c25-deb5-08db24b95499
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:24:21.1695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5/85lvSJugXLTepHMHqSfSnXSKxlecHR8xb6QaixrxWR+1CXAlReDhlhYa5oAD+iLta8V4DdObbienSUvQ/bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 3 classes of switch families that the driver is aware of, as
far as mv88e6xxx_change_mtu() is concerned:

- MTU configuration is available per port. Here, the
  chip->info->ops->port_set_jumbo_size() method will be present.

- MTU configuration is global to the switch. Here, the
  chip->info->ops->set_max_frame_size() method will be present.

- We don't know how to change the MTU. Here, none of the above methods
  will be present.

Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290
fall in category 3.

The blamed commit has adjusted the MTU for all 3 categories by EDSA_HLEN
(8 bytes), resulting in a new maximum MTU of 1492 being reported by the
driver for these switches.

I don't have the hardware to test, but I do have a MV88E6390 switch on
which I can simulate this by commenting out its .port_set_jumbo_size
definition from mv88e6390_ops. The result is this set of messages at
probe time:

mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 1
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 2
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 3
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 4
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 5
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 6
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 7
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 8

It is highly implausible that there exist Ethernet switches which don't
support the standard MTU of 1500 octets, and this is what the DSA
framework says as well - the error comes from dsa_slave_create() ->
dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN).

But the error messages are alarming, and it would be good to suppress
them.

As a consequence of this unlikeliness, we reimplement mv88e6xxx_get_max_mtu()
and mv88e6xxx_change_mtu() on switches from the 3rd category as follows:
the maximum supported MTU is 1500, and any request to set the MTU to a
value larger than that fails in dev_validate_mtu().

Fixes: b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a5d6c7bb128..30383c4f8fd0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3549,7 +3549,7 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return ETH_DATA_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -3557,6 +3557,17 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	/* For families where we don't know how to alter the MTU,
+	 * just accept any value up to ETH_DATA_LEN
+	 */
+	if (!chip->info->ops->port_set_jumbo_size &&
+	    !chip->info->ops->set_max_frame_size) {
+		if (new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		new_mtu += EDSA_HLEN;
 
@@ -3565,9 +3576,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
 	else if (chip->info->ops->set_max_frame_size)
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
-	else
-		if (new_mtu > 1522)
-			ret = -EINVAL;
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
-- 
2.34.1

