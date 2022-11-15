Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66022628F22
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiKOBTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiKOBTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE6815825
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYH3A6rtTN4JdcO+G0NA56SoL67mRVF+zOrTeV/GU/31xPn1IgyjMw004Bfw1100xPnWDnEUJ5bjArdIiwZ5tahE7Uttg1TJ11yIOeNNr4uvuWpwJWcBnMjw7+WP44BIzG5iSM+RGHVVn6i0albxKHzLe+JYtYOt0ijPwtbh7rAo30CXrOnd/yBPa8v3o+w/6qm0yWTChkQlRaOpox3QvfFrtGOQTRl4dOUtwIJAJrr1WHcDk7vMithUNs3/LIiRlC7yZ5t+N02PNWirB62mavjlGi3bqp9+L1Ieub7siA0tVJcR1Ls/2E+AKyNHG7ItgCOaHIkkRuqasuEREDc6zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCNUfh7YOdvwv3wlQPR+iqvpp+XCnhzc1VrkZreSfPM=;
 b=aTMEiE3p/34j6RN5WpdgDLQwfuqEeMNXEDF/6O1zHZvJYpnPRYBCsRRXez6De7sefSIodP7ufx4UEQnSpH8cGiPIkrKofLd15y/YbhOTSg6luGuY93FTAmB09HaDCmEz/72uxdWOQsawR+io/Gw8eP/IteIG3xi7HDJq9wvDx/SyNP9yK6RczDtfx57I9SDInDlcMoA6UZemSCN+BLQzA+UfxIeacT3fAcKV9EqQB2J2fb+9IhpY/HPm2TbzC2o0AYUqGBZw99HVTF1PFa5uxymQJdOJqkCaHsAKrRs+HkdL38sa35iEB4Uwq33NJprV/IZuNkY49Q3XDq1fDDuD+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCNUfh7YOdvwv3wlQPR+iqvpp+XCnhzc1VrkZreSfPM=;
 b=Ctw0bEzKtFHc/E28iqJJpk9JQc2nWyA/8rxhgepJZdfZkqQUrbhQQLlD7B33VCTkhxZi8eLE7UHbL25hwHhhrBaQ6tCksnANHkUtoJznLcQj+AeuyCzJ5J/IseXxTIqHcIwcS7vrQ4MyKmjyDGHlF3xg2kRKbsBzTHZwL44zmnI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:19:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:19:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 net-next 4/6] net: dsa: strip sysfs "tagging" string of trailing newline
Date:   Tue, 15 Nov 2022 03:18:45 +0200
Message-Id: <20221115011847.2843127-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 47ceeb32-c12a-4ff5-8b9d-08dac6a76111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gGTxkhfzWH/sB/aJRuZDxpA3fZ660eO8c7YUHPR8URA5/2GtWICcVY++wH044TF7U1qS5l1hvbPK9WGF0hQXmY0Dv0qtcMLzpi7abFExA+BpT/LJ3iwZngkW4uRTc3zId4+8lkC6YzM7jOFpZqMsrSpnSQjOv26Qs6T2SaNzi6QbdRgAf5IdkTeBq7MwjLFvD0DooS1zttdBRKjjRwI7TDAm14/nNEkGyaPcrpxZp6jKwd7Q3hdk9/C6+n0TC8nQjyXehrm5n9hRhtR9auDv/2vjrvJmX0SKyZbxZnFtfAm2cJ2W7X9PukE98uHM3x8BdNkpE7Rav8Qo2eIykBABr7u1SAfL/FAly8UZ+E8Ee3TkMRw0j7nmTZr/p4evJ1jCNTo5d0BDuMO3+bEJ9XVsX8BOtLrkKxMwoHAPqZQwhOxsdT7ANseMLmOcRuSVs+vBPRXGOi9yrAnR1QsKAEXSZljLalIr1q8+NMFF5F4nDKnUeRBsb7inh4bZxjFqdI/QRk3T0rJnZXw0irTGyadIGkW702DLTmgIdDvAhUvxhvSAAje9mlfkZQhWge+LmWviFZnu07/D+UTWKv5fUzY3RQz/wTlCTL17hvvQ4gNNsQi6V4I0CVMUkOubmDchYQrsd7nr1H2nLhoGQlZzNQRVORrP8+B6bzPh6DLIMEwUAmGkNqigNk3wviS9tMj0S2IdqpfPaEhZkZGIYNZmmHVpSrxk4HG30Z7PUTKIjoXxxoCVMYYgxYJTxUeGeWLthzg1JSc2yR5BNEQ0J7UG+OvXOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ew5WCeDzbsVLNmP7AX2zUf4zxo7lqeUHrtaQL7RSvwzbqAYiHlakI0SShbmD?=
 =?us-ascii?Q?hS2m2xn62wvTeimmgJGZuZAPWMqwdCsi5VWxOhYgJjLYZFzBav6yS6GyJ9bX?=
 =?us-ascii?Q?0pitpdX87zFI71VVxAw5XHiKqSnks0MZ4h8ohl7jfJ6/DDiXiZ7+gW/OXeq/?=
 =?us-ascii?Q?O9fVsgsDhEgM+kjFlwO7TK1yAKKVXKUCJiZx1Vprg7cNIfFF4GR+f1ks+MuM?=
 =?us-ascii?Q?wMAB684ofNbJWAU45OP7MFiW89rHvYNgzHx0t9ncz4ipS+jg8R/tMxaEHB8b?=
 =?us-ascii?Q?4uxLpxyI8O/LIim+hWNZn2M1e4s5q0anhTGdEo5UOgADgK0lKnDrG2PYdHTF?=
 =?us-ascii?Q?JMNBI2XX52p8s5wvfmi+bJNTGENvTlgt2Aef+u3YJF99wDRiQhOY4lRScl9B?=
 =?us-ascii?Q?u0tqULv1+straYIZ6yoZntLZFAY1pdfNB7msuHklxWh73u6aK8VURlT0d4Tb?=
 =?us-ascii?Q?B1ZXIbz/+7Vhsa2YsM9g4F1lamt7fZ7mafUP98szIYLIhPasY0ePRpUYEMP3?=
 =?us-ascii?Q?1OoWDjCPR0v+HvozED4WWCSbn0MdzvMpvJ3kdXHvNJAhmuNe2wAE+hBBwFqp?=
 =?us-ascii?Q?WW165aVgMv8kW71ZGzrKxkHQ/2hp0CZsKRQ4vbaD9w/a2xlPsuzSRJCPyTyR?=
 =?us-ascii?Q?1u/jrtlq3zyz9NA1j4GWMAsFuDrakGIEOnmViguas+sc7tKFMNJQVDAlxTEJ?=
 =?us-ascii?Q?kTkMMYWab6r0DtISaXObxjLDPWKyr3C88IjbuNsd6yFcfZvYW9sTT39KC3dn?=
 =?us-ascii?Q?VFWLHHn07XvE1PW6wAH3ix0xaE4BEBs8TJrTlgWW2p7yNaXy1cG/m/i2SMR0?=
 =?us-ascii?Q?tZ5yunu6b+qCQ3RR5skg+vTDknleith4J/QGVmNHPmmpHobWTDzjc13VjqSk?=
 =?us-ascii?Q?q+cXkMQUzW7K4zvHrNwyN2AnILfwZyDmS/uUDLFx2YXP2SE/QRecBUux+zjZ?=
 =?us-ascii?Q?OQjCNfcOMjDNvL3FcWAA3nMM8gnku6NHyB/9oPgFgJzvwv6FpW6LJFLDdfyT?=
 =?us-ascii?Q?9krjSiL1DV2vxdBIsBsXII9pj0GxkGtED9fNcykHQ5/srCIsBrAmaosQGCet?=
 =?us-ascii?Q?DE/GBxw30laJof1MYeJ3zMKIqVWW56oHGx3lfsgWBcR0lPlmd++B1tYmKrbD?=
 =?us-ascii?Q?j2zHfpVsN7cHsmZve6tTlO2iMbKCbLso+eUMt+N8lXOTYRllidK7k7PTLdkb?=
 =?us-ascii?Q?Cxu0BF4pkK8TbSrLPpXjQKVv2d4vtHXTYWaAWRCDw8y/iTMwD5OJrY+d4Zx2?=
 =?us-ascii?Q?YIiYZceElOUpI6DyQZzIJM8CYWnuGFntY9PE0BAHPiuu5ZRoQI5P2PNQCQ0o?=
 =?us-ascii?Q?k9210TCzxkMLAhplCZvsVXSrMjMq6WHOgNzqC3WcScYJpW99Cce18K1jfG8i?=
 =?us-ascii?Q?qMOH19J0V2PmOEJUHXQyjlkEmV20iE87jjwptYCuHAlJsA+exmslQBlI6Ko/?=
 =?us-ascii?Q?fP2QuSnhNYZTHAbcWQgDAXvZtnsgvdvctkf829Y9B16gB54ivrbrT1ZyPypL?=
 =?us-ascii?Q?EOHLJbMamd2yJZ1rm/YdGQdQrWHi2MLaAcbyK91vJ30aeNzdLKVVdCS7v5tm?=
 =?us-ascii?Q?HyaHnRZtEoZWhuscZpfU4+2Z3BBdLT2CSlVPDivhhSM3ZUuS76jQ76/yYBr5?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ceeb32-c12a-4ff5-8b9d-08dac6a76111
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:19:01.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEd59SH6mG6f1fH4st1SyWmllDbakLlcezQa7G3GT+Mxw7Zo1irm/Ce6lIoNNUF57Okk5cTu6y+26QMbVPsW9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, dsa_find_tagger_by_name() uses sysfs_streq() which works both
with strings that contain \n at the end (echo ocelot > .../dsa/tagging)
and with strings that don't (printf ocelot > .../dsa/tagging).

There will be a problem once we'll want to construct the modalias string
based on which we auto-load the protocol kernel module. If the sysfs
buffer ends in a newline, we need to strip it first. This is a
preparatory patch specifically for that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/dsa.c      |  4 ++--
 net/dsa/dsa_priv.h |  2 +-
 net/dsa/master.c   | 13 ++++++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 38c64cc5c0d2..e0ea5b309e61 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -78,7 +78,7 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 /* Function takes a reference on the module owning the tagger,
  * so dsa_tag_driver_put must be called afterwards.
  */
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name)
 {
 	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
 	struct dsa_tag_driver *dsa_tag_driver;
@@ -87,7 +87,7 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
 	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
 		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
 
-		if (!sysfs_streq(buf, tmp->name))
+		if (strcmp(name, tmp->name))
 			continue;
 
 		if (!try_module_get(dsa_tag_driver->owner))
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b4b8fe4ed9bf..9fe68d3ae2f5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -245,7 +245,7 @@ struct dsa_slave_priv {
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name);
 
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 40367ab41cf8..104eab880076 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -300,12 +300,23 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
 	const struct dsa_device_ops *new_tag_ops, *old_tag_ops;
+	const char *end = strchrnul(buf, '\n'), *name;
 	struct net_device *dev = to_net_dev(d);
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	size_t len = end - buf;
 	int err;
 
+	/* Empty string passed */
+	if (!len)
+		return -ENOPROTOOPT;
+
+	name = kstrndup(buf, len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
 	old_tag_ops = cpu_dp->tag_ops;
-	new_tag_ops = dsa_find_tagger_by_name(buf);
+	new_tag_ops = dsa_find_tagger_by_name(name);
+	kfree(name);
 	/* Bad tagger name, or module is not loaded? */
 	if (IS_ERR(new_tag_ops))
 		return PTR_ERR(new_tag_ops);
-- 
2.34.1

