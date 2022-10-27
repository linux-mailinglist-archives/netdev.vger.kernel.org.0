Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5278F61041F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbiJ0VL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiJ0VLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:11:20 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2058.outbound.protection.outlook.com [40.107.247.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D786322
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsqLf2B/kC7aqczubDZFBhGg6n6QvrRbwPpR/62xQZKyG0MQnBIfT5JWP3FtUHJc0X82njv4SciUyHvdUlghItvn9QD1d2y3j/TyCx3Qqt/i3l8c9MI/oUh2rqhQ3sIkUTZOoLAd48eE3C9k0pI53OA1yDIkaCnvwkx88DZpJh/hHpUFABwacmHw+zUAxna1gHYEQfB1KUCTLhYDjEGIR8X9lczcIbqCTQm+qvxxbBZ4wJ0gX7JAUlCSEuS/45d7hJKJ/QlEuo6GedY6ACagwdoNs73Edxw9VPtIXUhZbfxv76KK9Bm7CSbJaF2VjoCqYBzL1kYFPxcDRURafx/Ufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuinzKCbqDDrLyYMzCTjr85N2LUgpK/yP3UyVUcFTYo=;
 b=A8T4seXazloe/ZUf/qGI3vEMmRnWxjs25yDWqFkB1v7Tb+1UyCCv3BzVoJvyj0JqQKCw2o7b+UP0nB1SG9G4ToIMAKsw0SYZ4U1znW9kmegqAVx58B89/ogG2u4KVdPV3AAGdZH3m90iWP7fIylsJYQtoY0B+6dEBdC1VA+7GRF9ecYvsZkxHnLC9mYR//ohXEsNNX7yDIE8z/DkjzRHPX1cW+1XeMMl+kOWnh9reytDdt8f9sCc4VTVht/WfZ1hlCBOO7YKuH7RIidfyxhJQQMlzhbjoHAdGQ5mpEGEsB2dI4u+pYaCbX9DG4gPXyh+q18QzfFmDnzl/tWvys6y2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuinzKCbqDDrLyYMzCTjr85N2LUgpK/yP3UyVUcFTYo=;
 b=s6qrukAJ3WQ6AxfxUm4wqEG3uF7bkSwFHX/2UPBz+IeSiUVPHVs/d2p9m+H2FB7L00KfpqU1LqVr03KFtxNqQp1OPTJ6hN3l9pPXM48NqWAPzyvUouuzTxBPuUitzxo//qdfKkLhwMFAHR+kcmHpHQMHZZHohUNmKK2RaViF+QM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8575.eurprd04.prod.outlook.com (2603:10a6:102:216::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 21:08:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 21:08:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [RFC PATCH net-next 3/3] net: dsa: autoload tag driver module on tagging protocol change
Date:   Fri, 28 Oct 2022 00:08:30 +0300
Message-Id: <20221027210830.3577793-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d768b12-a6af-4e11-d9a3-08dab85f6f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvdWJf6w3QVdAwH7gikBjVTQC2b9aJ4l6Gd8jH7LRHyawe5yL72iFoBTjGeWypIxYhrVV3+1cPUQjcqHDLbm8U5NLuUuDy/eRyp/KGp7LxWCh+fTXsDkxVAParM5T3Ke+G/0ql2Ropqm3PX9n21CQlCviMkBXiV6eAKKpN5fsrTjWPCl+xDfV8XgDK6A7yxpDHdy4Iusii/PL+TEV9mFQCx4GKpVdfTcaIQ6U1sNc1oKLywKWTGrBHJO0N00wDYyMdM6+OmLiRpus8KLkDII8kmhgjz4mskPK9vb3MwQCDuoq7/9dwU2qNlooCMIk2y+3NSMUDbBwEKEwNdLH9LEfjQ5GkTTwbCybOOFPcR5J/atKXLCuuMQeiFVU/5GYFv4/6tpOraX807SCQirsZQ87yJqLeVgVsduBRsSWYZBsf1ZKYT7uwP/x2WNhekfNZTfyyse2mlD2zXy4WT2XoR4I1IW5Ln60lCrWBMho/Y7R5TsAanmmqjgwIeve7P8rBY/GeHNeEWHH0oB+sWixEw2bnx524YucUiijhSQzwNifBYa43vgey9I6F0LigM4ynjyS0y11TLthSpwfpGATDIkpk6Gta8WcJQWJ4j/xCuh0pCgTPd58OlkJ/1JhUrzhGKQtl8IjVlbFG3XYifMPXS9RHhgnaInOHBzmMCHtumTiTJK92GXRpPP1dSQ9tbsaCWlrSZbqVaAsd05AhU3mbsQHRbXN3AOvPVMFe+/vEHCAxNAf7RDBiJI1qGTy4XlokZTdmrJz5pxr1pl10WFdKxgnpHFuf5b+g28wFYOB6oNF3E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(41300700001)(86362001)(38100700002)(6512007)(38350700002)(7416002)(5660300002)(2906002)(4326008)(66946007)(66556008)(66476007)(8936002)(44832011)(6506007)(52116002)(6666004)(478600001)(2616005)(186003)(54906003)(26005)(1076003)(316002)(8676002)(966005)(6486002)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8R7PUEjbvM8NDGk016/97cEfPSgVlYxA3/sRC4BNQUbwAms/X5n8ReW9R/UO?=
 =?us-ascii?Q?a/MAtbo3OXNkJ4tDQBld+TtrlFJBCJs3DI4MZdTk/FxwgfaAS2c2g/XgWthY?=
 =?us-ascii?Q?jzLjdA8J66gW52fqIEEG85j9ScIuCHRopsL+8Ljarht+dyDBcHwvnwTTuv9U?=
 =?us-ascii?Q?Q3W3HGOQPpRyTGyJa4V4z+gGbObkZSmSXd0/IIvBtzG//QaFe2uNoCup/vBH?=
 =?us-ascii?Q?+TxS9Ij2Ro+ccxBhy6lw8t17BzqqpYIMweL/edI7+pKXQFXTUUnBo8rHifRh?=
 =?us-ascii?Q?TmIjpBhxGEybW5dh2Pe3dcZHoYmI0iEdsB+AdYQ/RZNuOeweGSOyoHxm3eHv?=
 =?us-ascii?Q?rQeBZwTfW+c0Ll1sDMFxz/v3yDzfM5z6eMIIOqABN8oSk5L4BBp0jXnRkWS0?=
 =?us-ascii?Q?F8KmiwKSGwRXOIuUVYJ40xCdTKCCT/232cpv+cbLCvX/K2pdXBUDcZijs105?=
 =?us-ascii?Q?0J+Kf7mroGSpLFAWTgs16usZUQZHYYUFZesuUd6Ww0TUiXOuwsteCbnVROn1?=
 =?us-ascii?Q?q+KMSgllgG02Q0VfZ+Q9sGZVgW6w0rk1fkXToiq9EsNK/ARvpXQC6Hpeap9k?=
 =?us-ascii?Q?v6aJ4fw6OglWNaI8nnSP9kbFsQGY3UuOkqnoKWbXf39l0pN1t1hXWHGbENsT?=
 =?us-ascii?Q?n3o7Js/Q45jzYqoObln87bQtMDeuwQdFEFU1hweksJucqqHIpChVb2ocD7KH?=
 =?us-ascii?Q?A9a0Sg/CEGs/mf8G9PmX0WSO6TFB/TUlYIbk20h/CwspuCP1g/28bBVUFgVH?=
 =?us-ascii?Q?/Tl5JKpZUK8vOnZxJkpzTbB4uCX2xOBUN9BYbGriO1by1+BrPHkfPW5UIKFA?=
 =?us-ascii?Q?R56OfneCprguR6QKlipySRb3ESKnnF4jOAjJofmQkrMg8du5mCySRlXY57Fj?=
 =?us-ascii?Q?fUzQVx3mSigDgNIhjE05Tmj+O5XFSa4nMZHPGFjarkeSl3pYcgQvDleynu++?=
 =?us-ascii?Q?KsSB/wJ9nNf+2dfzyJmNl4Ghp3K2y8041qvi7QXbSEgZ1phCerXi9xYiiUpe?=
 =?us-ascii?Q?C04A6xUeQ6rVON8O2WZdN5WaMvw9ZH3D/g/WoL6lsMf1xgB8n5UdWywaEWUr?=
 =?us-ascii?Q?xvLixY41C/uh+mkYD++u6016q1hoSfYIcZt1kdmepI67N14yEicIFtathZ0Z?=
 =?us-ascii?Q?3akpb3C1IMidWsoGHudv54r7cCGg3EJtVAsLT1oXJRtit/b+vB9Pss8njPIM?=
 =?us-ascii?Q?eC/cZ9pjnEQd1Ol5lk2sgxUP4xynTkrk69pBGNWTi3EjszS2F5hfKiSz5OwD?=
 =?us-ascii?Q?y7brod6j+lKlKxxzkWveBzCIAPSNCY8bMNpj0UlfxJY845+NqyfaF7aOwy19?=
 =?us-ascii?Q?GLpj66i+7P6xL8CPGcT7pquctm61bxo1WzOCk/rHLghLiweH/o3Nlqiy1+i1?=
 =?us-ascii?Q?YhcwelW0+UzG3KYhCaQw6SjdGHS5FHK2vNQNj+02MU87iahoyv3RfjwEv843?=
 =?us-ascii?Q?WTCgT9RgKIS5vMJD8e/F54ylfnMEtafZUzNB0fueDN3nuyo/n0KtuU3cgwjV?=
 =?us-ascii?Q?Vm9tPO3Q6w6KaatT34cZe524Ct9Y+UWQgRUJaZz5DiiQs0+YJMkQFpY03nNt?=
 =?us-ascii?Q?m3xNbbzN1IbJoO6pyRsPxo38kd8vKxlukmiExYVv+KgnjxqoHr6l8qnwjM0w?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d768b12-a6af-4e11-d9a3-08dab85f6f44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 21:08:45.5939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qajvjt+pgpp+pqr++p6mdPtc23/I8IMgN08ZyNYzeKnJ4CAJYOYpokAhyhOgQL3OMvaVf2oYzm0slCrbj9wl7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue a request_module() call when an attempt to change the tagging
protocol is made, either by sysfs or by device tree. In the case of
ocelot (the only driver for which the default and the alternative
tagging protocol are compiled as different modules), the user is now no
longer required to insert tag_ocelot_8021q.ko manually.

In the particular case of ocelot, this solves a problem where
tag_ocelot_8021q.ko is built as module, and this is present in the
device tree:

&mscc_felix_port4 {
	dsa-tag-protocol = "ocelot-8021q";
};

&mscc_felix_port5 {
	dsa-tag-protocol = "ocelot-8021q";
};

Because no one attempts to load the module into the kernel at boot time,
the switch driver will fail to probe (actually forever defer) until
someone manually inserts tag_ocelot_8021q.ko. This is now no longer
necessary and happens automatically.

Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      | 8 +++++---
 net/dsa/dsa2.c     | 4 ++--
 net/dsa/dsa_priv.h | 4 ++--
 net/dsa/master.c   | 4 ++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 64b14f655b23..20af0759052b 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -78,16 +78,18 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 /* Function takes a reference on the module owning the tagger,
  * so dsa_tag_driver_put must be called afterwards.
  */
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name)
 {
 	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
 	struct dsa_tag_driver *dsa_tag_driver;
 
+	request_module("%s%s", DSA_TAG_DRIVER_ALIAS, name);
+
 	mutex_lock(&dsa_tag_drivers_lock);
 	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
 		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
 
-		if (!sysfs_streq(buf, tmp->name))
+		if (!sysfs_streq(name, tmp->name))
 			continue;
 
 		if (!try_module_get(dsa_tag_driver->owner))
@@ -101,7 +103,7 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
 	return ops;
 }
 
-const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol)
 {
 	struct dsa_tag_driver *dsa_tag_driver;
 	const struct dsa_device_ops *ops;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e504a18fc125..cba07ddfbcca 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1433,7 +1433,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 			return -EINVAL;
 		}
 
-		tag_ops = dsa_find_tagger_by_name(user_protocol);
+		tag_ops = dsa_tag_driver_get_by_name(user_protocol);
 		if (IS_ERR(tag_ops)) {
 			dev_warn(ds->dev,
 				 "Failed to find a tagging driver for protocol %s, using default\n",
@@ -1443,7 +1443,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	}
 
 	if (!tag_ops)
-		tag_ops = dsa_tag_driver_get(default_proto);
+		tag_ops = dsa_tag_driver_get_by_id(default_proto);
 
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6e65c7ffd6f3..4d5b631bd39a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -168,9 +168,9 @@ struct dsa_slave_priv {
 };
 
 /* dsa.c */
-const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *buf);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 40367ab41cf8..3fbbf51c8e97 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -305,8 +305,8 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 	int err;
 
 	old_tag_ops = cpu_dp->tag_ops;
-	new_tag_ops = dsa_find_tagger_by_name(buf);
-	/* Bad tagger name, or module is not loaded? */
+	new_tag_ops = dsa_tag_driver_get_by_name(buf);
+	/* Bad tagger name, or module does not exist? */
 	if (IS_ERR(new_tag_ops))
 		return PTR_ERR(new_tag_ops);
 
-- 
2.34.1

