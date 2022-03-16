Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845E24DB9A4
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358038AbiCPUn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358063AbiCPUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A886948B
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:42:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZOMIAwxpM0TcC8LwCK9WqMbwzkVWG59RPAMn3e7dy31THi652xbTnkTWYasLinHPcMq/2ctKbWBtxiTBWQzQ511BRm5re8+XvTY4mx7fJgFlVJpKvH8acxqZ06t/f9DJCB8ruy5lg/IgoFEhOz2+t7OTv2Kx1u4LQ8n99wcPVzOhKNWQuzhviGnfZy3uOUoyCfeZMabqrGV0Y4Oz5Rm+ekUbGKxm/20Db+b/UuLqORlq95Qi3wpgMArZ8m2rT0fjKc7hYmqk7SoTdxxisVxc+zI6wnglT4uhqejB5xGYaWqyeOnFok69L2f8VEYQ0u8ZHMiSlENG261Wbc15PTMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lm24Q4k4WVHwa7P1em5q0ffDwzvnS+WVbf3JInAM1FE=;
 b=dvakgkaVfC6GPND3u2dMavolZXCuCeOCB7uhuABSQcmfhkDuIxTeWCoPhZb0ZfdN6O77sjHS44EGaNptaKESVheTAI/hYZqpjIfdHgKrtrb3IcVf9aFQXJx1UGhoPDj/COkx334ULtBoT60yqZuZl3rg77CfpdoF1Jf+2skIHDJi7jRnjiLoAfhoWOU4F8BQskNHck3nsBJZ1jXR92ZLPKOYsqPPt7E8utuhW+zur0hP2ox3XkiDgHV3CPhHSJWstRVsiuQutxS2lYwixnl50yTU+snHiIS7wU2RJmEwBctmHwytBLk3rBRc9efw8ih6M49xdQCMCuzuP8nP4szooA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lm24Q4k4WVHwa7P1em5q0ffDwzvnS+WVbf3JInAM1FE=;
 b=WhNzvMx9UFm/nPw5yGgg7VA4KowR9ibYJGhmibgRTESFkMHbd/w0YXbdDbrJBovFyFT7OICGy7WRW3Zos5+yeO5ldnbqf4f6704IKGfS2ouUbYOOP8615dcThFuaempUcdZIBsIUwBQhckqvEGikD4t9z/+SZVX4gba1wOKFE9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB3293.eurprd04.prod.outlook.com (2603:10a6:802:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Wed, 16 Mar
 2022 20:42:01 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:42:01 +0000
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
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 6/6] net: dsa: felix: add port mirroring support
Date:   Wed, 16 Mar 2022 22:41:44 +0200
Message-Id: <20220316204144.2679277-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eb3d898-01bc-478d-2f74-08da078d6ab4
X-MS-TrafficTypeDiagnostic: VI1PR04MB3293:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB329345F817CDF6800AFE3D4BE0119@VI1PR04MB3293.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eV6/x0my7SIbpYklEZ9zPoKRAB0LeG/+wHQlLNGqQubHCC9lwdyxqqYJ5NV2EiZ37etXVd87sXh5XJ60K0yxtWRUvjOljVDAxiFQqkneMonaJSlWSe9cjRZuYpjLa5+qVt1OzQOQsAcrRTqWpbOQ83br7d1lz+jM3z8xXdN7RASNdetMkziOZ1VtHl32fKXBu+Tj/dpMijXwUFLCoJnOn4rgVuzW5cXV33b6H1LkIcaZ0rmN5jUjmMPQWqbUKj2m4752zvam8RAC9Po+g8mFX3s022+d8+NtRJ5S4leCspEtaUb09DkocGCFd4MJzsmbJe6uoS9/i0n+xaTqX+Xzb3u9220J4pySK0XjW7UdAfTrWxwhF0OmCkxoaWTTvJu6R8cAaCLVxkrtGtoFUUA/QGc2nMIu0aLb02w/eFLZ1aiYBwQmKDITi6z+lpnqE6XBukhKfisSGsLv5FRXXFnersiyehqMkYRW2L8QNAPc2kGf52N095f7d8TMN2Qie9bbHhBKiz+thtQQlq/e6FOidmkxa8gh1hQG+efplq9U8LX+DL0MSeHKCRDuZqvelx3NO3NsdgsBIkTafjI2W+AnpDNA19SmFIGFYggNft7PQGmo2OEPINYNM5Fis0OE4QkABYYB9yN9zmivsfmAVHUEgJEGPxh9Ubr38KE6DZRqzsbEqw5J7RE5mZ5P8QmfxBS8fTj9MzY/GkjKhnS6JwGAXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(86362001)(6916009)(316002)(6486002)(54906003)(5660300002)(36756003)(8936002)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(2906002)(2616005)(1076003)(6506007)(508600001)(6512007)(6666004)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?foVxljFSq64QHm7d/vHEfJVQGRwdfv3la07UplACj6BgPkXnXHNI31D+KUZL?=
 =?us-ascii?Q?jrGYCXOT3qIK5g4SdKZYyPNQWZfcXCpE9VUgBEDz3U34Bcfz4+iG87BAxApe?=
 =?us-ascii?Q?lZRL3Z6qOGNN/taQ+FAjofrjh+ZRl1c0OM8Yh3i/nZcKzHf+sMAMyauzqWlt?=
 =?us-ascii?Q?d18fc6VKJJiYZtI6MvUWt7me02VflDFNQCzS7t8c8CZ+47eEYiLWiT/GheAl?=
 =?us-ascii?Q?ZjfxvkaxdfB5PLgIdqe4R/iSSCs2wOQNSbj0xI2FZ49uP4alqGSztpoTYIz1?=
 =?us-ascii?Q?CPNZNau9SSw9oXPVXyAgZ1aCHhWeHBXP+rJfgSnqdXQHmD/kG9miXJBassTK?=
 =?us-ascii?Q?0SUw+BUFIkXUh8Xt2MioJYH73ujHZTGaSpKu44MyOqgr9m8BzGHMFFRLdM3Q?=
 =?us-ascii?Q?Hxc+j0Me1pDcyDjSukWNt4vnSrPblXCdHfgnLIc5fkpfINTNN9HSYfuBg3FL?=
 =?us-ascii?Q?i797TssE8Wi+EhMRQIF5RKQO9MHVdfCj8m5wvUcT/SVkbUg4tlylASFxcM15?=
 =?us-ascii?Q?LFtArMRBaQXkuVjG3LHVPL0XSmeCJ1O8DJ4NEGQMBZMQwNRpdJ9g/Iqw2yTR?=
 =?us-ascii?Q?hbmxtLN3n1P/EfhGGJ85JhZgu8vytKQXGcFWu/HeecJgLDftXaDpdZ9C7sOG?=
 =?us-ascii?Q?T3VqqZVW9q2JmeGEu2vhHuzR3kImKHx+zPp2f/Ys/TPO9AsHvXETpdkbwV16?=
 =?us-ascii?Q?vTlDG6qwVJpwyMEh98et1XriWMJpGkeb+VuvwSnNIC82Y/Wa6KXpCIEkk9FY?=
 =?us-ascii?Q?vu6fusZ1HkeMCjOsAsDOQqxNzeXfm+BqJB5T5HY1Zg+sGaZfybbczc93bATh?=
 =?us-ascii?Q?7LdYI14IdU9vwDQmazR8oiuNu3hPIlV3VKCwgzLUZH+LanQGJapZlLz5if44?=
 =?us-ascii?Q?Tnvc26zTH8lOZ5NlaGGPFkDOOq39W+Xomf0sXg11ahWB3lsKuYU+1nowtxEx?=
 =?us-ascii?Q?nmbRKQwYn5m58zj71yPxwsdVXLzpC6ckubtAGDWRsK95A/RjZqBZct0VxF65?=
 =?us-ascii?Q?fFyRWS7fkioltnCRelW07lUJYg1yMHkpUtZcUQLztQcKyYyteFYUiZSw9f4J?=
 =?us-ascii?Q?q3v2KmMSKNvPcTDe3kOLNqYJXra1hxgUdaoDPxEpQkKGHirN/Z+H1/YgJ8I2?=
 =?us-ascii?Q?S91jVCxzRYSeI6o0EVMVc6ND39IqM7BXRU9ggPYljnl0FchT2CK9HKI0AqPJ?=
 =?us-ascii?Q?aQtI1s1wjBeuFjtRhPhTKkrucN+36HIYecXAWsdvGTlg5slfgjdgcB9m65C6?=
 =?us-ascii?Q?VEKzOsHIeOAuo17WSEqpCjzxsXxTPJaJ8M3NgNrV7F17AJskpmivlEoiYX2D?=
 =?us-ascii?Q?d2FBGKuJ1OQcqmbA7fUCPa5EY3o8JRsx7qMXGwzXRcPJEsB0sAojFvWv5XLo?=
 =?us-ascii?Q?CQgPDWCzfJzWmRk6oVehFJiHgEK7ivd38WBlXZDQDYI1JK+3cDafgzQmIgnG?=
 =?us-ascii?Q?prlk4JmEUVwvAmtQP/Y9IJMr9Ffn9JxtP7zv1d30YtkV8AQzYTRE1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb3d898-01bc-478d-2f74-08da078d6ab4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:58.9885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rSJh5Zy7InARnrW44WF7qaXTW+6fJeNLmtMM8jsYYXsV7HADdUU9m5m1WWFaPs0YolNaC1UWEYpW+9vhcN78g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gain support for port mirroring using tc-matchall by forwarding the
calls to the ocelot switch library.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 13d6b178777c..413b0006e9a2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1650,6 +1650,24 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
 	ocelot_port_policer_del(ocelot, port);
 }
 
+static int felix_port_mirror_add(struct dsa_switch *ds, int port,
+				 struct dsa_mall_mirror_tc_entry *mirror,
+				 bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_mirror_add(ocelot, port, mirror->to_local_port,
+				      ingress, extack);
+}
+
+static void felix_port_mirror_del(struct dsa_switch *ds, int port,
+				  struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_mirror_del(ocelot, port, mirror->ingress);
+}
+
 static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 			       enum tc_setup_type type,
 			       void *type_data)
@@ -1880,6 +1898,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_max_mtu			= felix_get_max_mtu,
 	.port_policer_add		= felix_port_policer_add,
 	.port_policer_del		= felix_port_policer_del,
+	.port_mirror_add		= felix_port_mirror_add,
+	.port_mirror_del		= felix_port_mirror_del,
 	.cls_flower_add			= felix_cls_flower_add,
 	.cls_flower_del			= felix_cls_flower_del,
 	.cls_flower_stats		= felix_cls_flower_stats,
-- 
2.25.1

