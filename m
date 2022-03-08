Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556274D1329
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbiCHJQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345299AbiCHJQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:45 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10065.outbound.protection.outlook.com [40.107.1.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709BE40E58
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFi+H1ecUixSb0Ogan1zJefqgV4ZJ9ro4E7Abn7gA6dP3YLtTHQkM2svcfFvlDi1jKjb9XNCH3ob0hnYbVxfDGWjrhvHBM1cbcS128gwb0kXPcccOiMP+AWnUNUOapKhBH1EsDlPqt7oT1AYezGUTXOiLvgwtlhmCyeWqYwmRGj6apKQOLJIF/BC7sIEA/7/SOQV7u1X4wQaZ7gULMtraPip+99T3WFS0zPflFzCWEXD/EbLm+g7CKnoCm8PxpoPqhO+rm2P0S/JkEqY19e7Hl0YVWfjQ2QldpUA+oipBIhJ15Yx2nJ3PVXfNCaOwDvHOvFTPD1CZXj++fod40JQiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awO5iKU6x8+G+0X+K+8nDVJC7IYFWAALSMSuXf2llSs=;
 b=OKOvpmFxwXLTdXNWt+tBvftc3M8FERQ4gLdFwglDf+ZQ2CjkXW3tlqlJ0NUHFT6727BtUqai2/zmSHBm3Cs8KfDy4dt6mUx9hPaEQ/iMV57GMvPGuvdYV1p1AHzA+YFwL52z0KXgcoiHZmrejS7dxq5BW9CwMZL4dtfA2DQWBULy/Ei8a1f46iYZL7TN6rzgYmbcsRxUUEpwb+zVM0cDmx51SCAPxAqiieNdZ2KUHtsoj/Qb4xxe06uINQ91TnymwGLEikSBRPy9DYOr2LZohwDknPdiUiXd2iZgtNEW0vWq2qd5+SyxICmzRQvYNtdCFzpI4jgz1Xsrr1kxVLKgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awO5iKU6x8+G+0X+K+8nDVJC7IYFWAALSMSuXf2llSs=;
 b=ZiiXB8Cdo4guprWgO+HgauUkLNN6hMZLodGa4WzBFZTihJ1dp17Ghum0ZuBLbfcHzq2XLbrFmJrc79twX1Kon+e9a7+0MJm5RdHeXRSKGu/CsRONScla1BJY572m3FL/nhEZf+R16y80CiMDEaEmOVfqQ4fQTIgU8jWGEmxJOqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6461.eurprd04.prod.outlook.com (2603:10a6:803:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 09:15:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 6/6] net: dsa: felix: avoid early deletion of host FDB entries
Date:   Tue,  8 Mar 2022 11:15:15 +0200
Message-Id: <20220308091515.4134313-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8c3be90-c0da-4bf9-1d9c-08da00e43405
X-MS-TrafficTypeDiagnostic: VE1PR04MB6461:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB64616E0EBD01E3A42177A3C3E0099@VE1PR04MB6461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sc31Two0GMSTvkkWeah+izkMN2Pd2HtqeVCQX/z5ovxWY8TQc8OYo6LnLMYZd45bBHs3HzkwMmuZucyyA6PjIkg00pY4TyW1pr5eHVUyDrb8Jsf50WzqOut8I3UC0xzn7H+RxdaaulyuXlIZQkKI0RcB1aQo/1ZIsjxm7jfzVqTBr0+eYv9zsDxApnJFXaU5dt8TGdnhZ2rCM5trwBC8BstTVMeoreO6zj5vi+8/Oh3fQzpPvNF7YyZCq4lpREv4y+E9eUpOY4VPA9w9ybHPyuruEXfMgNozlNBCURcQBrzIsrvCUlX31Sp6p3/q60oYsTjvf/EpxSXn4huBiU+SkeTU34sDVp/PLF25wu4TLib+9DbFuhgmFE5sdJX7qsGadAK14VQjA6ZGbr7vFyW5dM+5wEqZ/IWFMQsHuRoYyCNWugG9xPD/eP9Ynh+qNioPFe33RAaY0cslksmX7fnC2jqqr5ZvIjV2cLLGrj0ixEBDSkgL+b094FJxBGLC2HeV6K9ywMVe09yNZmEQUj6UjeV8BwmtstDiv+NCyudNuFrhDht0Vl+n4S3vSn9VIKOxM3tuwEjB5lU0QnEq95/ULe7eymrGz6ABomb4x6bOhsOBWK4M7I7UzH2rPHdtkDtSsQhN7OG4HRHmNCycqTY1qlNAg+KOTa/poQPH4xRck/XuJ1wLx4aBHq1kPe0FRW578b2OGkcr633sAP08iZKsHoryPhsxaE0TSh7PtM0bu/0CVI5iS3L+GiFLUQjgAKUFt0rYiVwQ86KOF8h15noKDsv4EUF0jlCt5IOQhS5CmLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(186003)(26005)(508600001)(2616005)(316002)(83380400001)(54906003)(6916009)(6512007)(86362001)(66556008)(66476007)(44832011)(66946007)(52116002)(6506007)(8676002)(4326008)(36756003)(2906002)(5660300002)(38100700002)(6666004)(38350700002)(6486002)(8936002)(966005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NGLDJ6g16rd4zf2YRJi+12hDXUDSKh+nC+RA82f7DHcnS44LgvMmTHpUPct1?=
 =?us-ascii?Q?6XVoKbu2gzI6piLwNGMe0l33ayOhe2yp/+5GfMYyqngmfkdkDGUN+hhccmUN?=
 =?us-ascii?Q?R/3xstwpXfEV6nf+UO1zjpVBymwPjWGIO3VIUNbChhcuHi0iiQg82jkGblSM?=
 =?us-ascii?Q?cT24AYH6dmgirShuTNb8IQu+pd+GyX1oG6FRrCQevjqs1fZqtRgcwDsEgEZR?=
 =?us-ascii?Q?1o+nBeQV3mGYVHGNiq8Y+54ezneBiG7+tkmKwVDVZQ2TyFdEYpPwCZxpPsGG?=
 =?us-ascii?Q?IKQfuNuCDgPlxPzkgFGc8vZ2v/9U8f62YKf/jWqQyCxFeeYW1wbTVbHghiiW?=
 =?us-ascii?Q?n+oj4q3KcmmhJv8TAfGYFK323twCtkzRTN1Iq0T+aDEcAuGZys+cuLBmVydh?=
 =?us-ascii?Q?Vpdoye+GE6QlJcyV8Qgb2f4hyQccYP/yqOncodnRXKMDY6u8yJJijXhaRLKd?=
 =?us-ascii?Q?GwAlTt7k/pokZHiTjN95mwwLbnNjnnI486A61g60zbMrrKHUfxXIJFbrqT2d?=
 =?us-ascii?Q?ccfTkYio9IvV72XUMRhbaZmNlRJ9OjRAXWkVZ7Z8JkET9rfaUSNLEn9Omy/n?=
 =?us-ascii?Q?F9R2PUbk91dr4Yaq3yVlbnct6emoH/ralIU71bxspLeCkvzstXt5wCdEkKDh?=
 =?us-ascii?Q?UDvgl9MUeafIlulrPJySbBIK9laVb4+JMvVBe0dhcS3mNfvbXD6nh0DjtJCx?=
 =?us-ascii?Q?42Ub1DskEhe0Eks+wRBVzvYiUQ0jbnEmqJmVapuDsXVf/hOTk6bgK/oTZycX?=
 =?us-ascii?Q?oDpmjNbtUaEfg+g16kEsWxigToNGjoMkTsn+LNVA+/5/mYLBTgwIjFdFf+vS?=
 =?us-ascii?Q?e6UyOQ5TRf3LEz+E9TeOTLpqqskPnRHUEdN5lTb1wN1alz/vHPNOpKAnM7a0?=
 =?us-ascii?Q?D7nekfuQ5aEdQZ1/AZ73a9FIVisr2Axb8jRkLRj1kSieQZgZGPqr7TDs/+qy?=
 =?us-ascii?Q?oa53dHHJ/icQCExFFQQrbrHRZqyiIj7Nxj7Z8FXHTd+ep7wB4uFN3uSeFIxZ?=
 =?us-ascii?Q?ZNOQpJOI2MVIZYuR8/lHKYctLgVIJ/Ruvui7unq0t6OqqUTPKPuL1KBwshaa?=
 =?us-ascii?Q?dm/nQrWRTjUBrVqfe3EVboazkNDDA2GLb9PXeWN/iZTjcgBwE7+zoBuJzp2n?=
 =?us-ascii?Q?GvN9dYDiQDeUrOaSn+HZG8cTZdkYZ6XeOf2Z7Uml0sHyBR0cAwthUIuWlHHa?=
 =?us-ascii?Q?6Hap5s7jNiNvUQ+0F+et/4sO/VmbuwlY/XWAwgDoPuwUBfCargasIGuADav7?=
 =?us-ascii?Q?eFz1ZZw3tftpzfXZJ1PnZ4XC1odvKEdzg+fzLH8NmLmoamUati+3TisZ0M4I?=
 =?us-ascii?Q?rZ+qnuHSf0ArnH9yJzqjmQJ0LlHbfBYMuvVDgEIFLZkNtKrbYayHLV5WAK8B?=
 =?us-ascii?Q?e9Ci6F3QjUcYQuhsWLdFGBDnXZz0MVmtBBqzeaHf+O4PV3flYSu/aHQSZAAS?=
 =?us-ascii?Q?Cqqdjozh0blgkg5ih+z1nouYtbUuSoLxchr6B8QH8MvSQkNoB8okLHKMR3yx?=
 =?us-ascii?Q?h8ltwyJawbtga13WWkmN4r3Zx0oEh/8RZidf1BOPqwgO6N6lsAXs+tOyZ/GU?=
 =?us-ascii?Q?zaN7lJoYWGnF8UFX8asLv0QZtOFEQKNdBHO6VlSSQ9r99ViwlyrN5dGaYOOE?=
 =?us-ascii?Q?WssmZ//P+b70lJrTOJ9FF3s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c3be90-c0da-4bf9-1d9c-08da00e43405
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:35.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3Q+iC9H2Vgtm3GdAg/qze8Vamz5uyBRDsv9HUHjj40ZK0HwXNuIMxvrZaIT+weFX0jXw3tN/wwQFcrNZ3iWnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix driver declares FDB isolation but puts all standalone ports in
VID 0. This is mostly problem-free as discussed with Alvin here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870

however there is one catch. DSA still thinks that FDB entries are
installed on the CPU port as many times as there are user ports, and
this is problematic when multiple user ports share the same MAC address.

Consider the default case where all user ports inherit their MAC address
from the DSA master, and then the user runs:

ip link set swp0 address 00:01:02:03:04:05

The above will make dsa_slave_set_mac_address() call
dsa_port_standalone_host_fdb_add() for 00:01:02:03:04:05 in port 0's
standalone database, and dsa_port_standalone_host_fdb_del() for the old
address of swp0, again in swp0's standalone database.

Both the ->port_fdb_add() and ->port_fdb_del() will be propagated down
to the felix driver, which will end up deleting the old MAC address from
the CPU port. But this is still in use by other user ports, so we end up
breaking unicast termination for them.

There isn't a problem in the fact that DSA keeps track of host
standalone addresses in the individual database of each user port: some
drivers like sja1105 need this. There also isn't a problem in the fact
that some drivers choose the same VID/FID for all standalone ports.
It is just that the deletion of these host addresses must be delayed
until they are known to not be in use any longer, and only the driver
has this knowledge. Since DSA keeps these addresses in &cpu_dp->fdbs and
&cpu_db->mdbs, it is just a matter of walking over those lists and see
whether the same MAC address is present on the CPU port in the port db
of another user port.

I have considered reusing the generic dsa_port_walk_fdbs() and
dsa_port_walk_mdbs() schemes for this, but locking makes it difficult.
In the ->port_fdb_add() method and co, &dp->addr_lists_lock is held, but
dsa_port_walk_fdbs() also acquires that lock. Also, even assuming that
we introduce an unlocked variant of the address iterator, we'd still
need some relatively complex data structures, and a void *ctx in the
dsa_fdb_walk_cb_t which we don't currently pass, such that drivers are
able to figure out, after iterating, whether the same MAC address is or
isn't present in the port db of another port.

All the above, plus the fact that I expect other drivers to follow the
same model as felix where all standalone ports use the same FID, made me
conclude that a generic method provided by DSA is necessary:
dsa_fdb_present_in_other_db() and the mdb equivalent. Felix calls this
from the ->port_fdb_del() handler for the CPU port, when the database
was classified to either a port db, or a LAG db.

For symmetry, we also call this from ->port_fdb_add(), because if the
address was installed once, then installing it a second time serves no
purpose: it's already in hardware in VID 0 and it affects all standalone
ports.

This change moves dsa_db_equal() from switch.c to dsa.c, since it now
has one more caller.

Fixes: 54c319846086 ("net: mscc: ocelot: enforce FDB isolation when VLAN-unaware")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 16 +++++++++
 include/net/dsa.h              |  6 ++++
 net/dsa/dsa.c                  | 60 ++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h             |  2 ++
 net/dsa/switch.c               | 18 ----------
 5 files changed, 84 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e475186b70c7..35b436a491e1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -739,6 +739,10 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
+	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
+		return 0;
+
 	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
 }
 
@@ -752,6 +756,10 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
+	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
+		return 0;
+
 	return ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
 }
 
@@ -791,6 +799,10 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
+	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
+		return 0;
+
 	return ocelot_port_mdb_add(ocelot, port, mdb, bridge_dev);
 }
 
@@ -804,6 +816,10 @@ static int felix_mdb_del(struct dsa_switch *ds, int port,
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
+	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
+		return 0;
+
 	return ocelot_port_mdb_del(ocelot, port, mdb, bridge_dev);
 }
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 759479fe8573..9d16505fc0e2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1227,6 +1227,12 @@ typedef int dsa_fdb_walk_cb_t(struct dsa_switch *ds, int port,
 
 int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
 int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
+bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const unsigned char *addr, u16 vid,
+				 struct dsa_db db);
+bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_mdb *mdb,
+				 struct dsa_db db);
 
 /* Keep inline for faster access in hot path */
 static inline bool netdev_uses_dsa(const struct net_device *dev)
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index fe971a2c15cd..89c6c86e746f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -507,6 +507,66 @@ int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
 }
 EXPORT_SYMBOL_GPL(dsa_port_walk_mdbs);
 
+bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
+{
+	if (a->type != b->type)
+		return false;
+
+	switch (a->type) {
+	case DSA_DB_PORT:
+		return a->dp == b->dp;
+	case DSA_DB_LAG:
+		return a->lag.dev == b->lag.dev;
+	case DSA_DB_BRIDGE:
+		return a->bridge.num == b->bridge.num;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
+bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const unsigned char *addr, u16 vid,
+				 struct dsa_db db)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+
+	lockdep_assert_held(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->fdbs, list) {
+		if (!ether_addr_equal(a->addr, addr) || a->vid != vid)
+			continue;
+
+		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dsa_fdb_present_in_other_db);
+
+bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_mdb *mdb,
+				 struct dsa_db db)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+
+	lockdep_assert_held(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->mdbs, list) {
+		if (!ether_addr_equal(a->addr, mdb->addr) || a->vid != mdb->vid)
+			continue;
+
+		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c3c7491ace72..f20bdd8ea0a8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -182,6 +182,8 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
+bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
+
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c9e16ccdd29a..d8a80cf9742c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -154,24 +154,6 @@ static bool dsa_port_host_address_match(struct dsa_port *dp,
 	return false;
 }
 
-static bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
-{
-	if (a->type != b->type)
-		return false;
-
-	switch (a->type) {
-	case DSA_DB_PORT:
-		return a->dp == b->dp;
-	case DSA_DB_LAG:
-		return a->lag.dev == b->lag.dev;
-	case DSA_DB_BRIDGE:
-		return a->bridge.num == b->bridge.num;
-	default:
-		WARN_ON(1);
-		return false;
-	}
-}
-
 static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
 					      const unsigned char *addr, u16 vid,
 					      struct dsa_db db)
-- 
2.25.1

