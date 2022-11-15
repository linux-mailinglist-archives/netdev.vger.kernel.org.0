Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371E1628F24
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiKOBTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiKOBTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:15 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF99186C9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/AC82sGsVjLkK7/vEbBWKphk3cVLh9gn7HqtzCRJOsDoD3S7xNonGJnmEISGVsaChTLiCRhqWyfDs5KMBdJN6eEJ6SiMM5jtllFWaEfLUKiwsYS/xT4hPHp9JM569wQnT4jW9zPsjFziFr2MV1VqlYR7RaPK5ksJuM1JPXfFGuhu/tf/zqZe0pUhLPj3cY7ps/yWvOPxWOot+0gcR7enxQ9Rp3HHnHeOqEqAa+TkhmpcyTPf0g6PcbmCanLaZ2/nTGoiDKCMmC4NAWpsYOwFm5h3gjP7rMNw5x79LyC1NDhZEtHx3Z1M2uVS/5PR19uU6dXnH5+gAJ4DTKBGoxN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aZhbjeLIe426QGapPcbB1YXKE+rnddTiXIZ5tl1JTI=;
 b=KuFg2fO1SZZecOVFSxYa3wL5mzVs9RyoK2WmLKbz8UcCbCSd0HrHP5wJyeAGhGtSaUmMjZGb4Bmhli40FoVSr309o/fXuK454S4ItYvlrYHlpQ1R0ydDAG/MvYPbYabUMF5VNH0dKEpZ+X5pJHE16OUTnmy44I0dyEehXQradN/luv8VFqxZBZT+lYE9ZTX0FlhUME+lPmiXC0ne7Lc+h6W77nyF5TLkcF7P7qUM0BzSTeNZl5/cNfY+SH+ZDsbI850EGX1SkSMg1nM/zqMsueStW4UoYy6pFBVWTh+7yrRfJI4mcLTL/OpyZgX4swUJV4/qlo+OSJxfc8ok5IFb5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aZhbjeLIe426QGapPcbB1YXKE+rnddTiXIZ5tl1JTI=;
 b=CD8WgrKaW8+cfELHFhPcQ3smvQxm5A+v+JozOnjIsvpjjdDM8iGNpb7lD8tWqGhZS4sCVcqKT850QLXp6rjGvo5mkSSjIEFLUxJXqruxsVNMRTSWFQ8k6onyjiW5tM5T4m8J/oMvBZ8K8LOl8Rds6zyE64J253K6eSXDhPlLHUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:19:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:19:04 +0000
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
Subject: [PATCH v2 net-next 6/6] net: dsa: autoload tag driver module on tagging protocol change
Date:   Tue, 15 Nov 2022 03:18:47 +0200
Message-Id: <20221115011847.2843127-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1aa79189-3f93-4e87-6142-08dac6a76272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QgEcb5WEKyo22u+XEfzG6qTmdz1H3ZVkmK2F6upiQsfVWS63LQN6dCb22Ddh3kpl7PwnGXw6QDl84ROLupEyJaN+sebE6hLLIewjNDKIltgLY53TNX3RKZWHFWsP0XF3LflGRs2M7Nw3/sPv0O3QhOzFupJ3HatiqnOkphAzHFRn0MI315iGlHk219p5W+x7QfbnvbuHSsRY+VSjnwm2yhFOK7z7tfWsUiGetJX6d3JqhZkbYg6OSd2S6OB67TVS5BpcboqTM6Ls0EN0sJkb374dSaitGwJqXETNPOCY4hPUmb2YrEUsZGO2S+g3U4NJO1xTZJ3Htn9D38R1JUhYaF2zBLElaamm3WReU42ujyT8/V83W/X+qmjDPYWbk0sRnznPNbNfSZlflDS7PjWKoGxF6H1fpcbmYpyQBcdzgSyeqGQ8v8Z84AFqw86dK5gNfmxtu7Kl8M4rGgMIAVs7pWqiUTgRguazGijdkjKuFQAypZjeo8qjGV1BEeKJa3sS+pFYzk3ygP6Amgp0ZqPia2OOh2qg/E2gduN06H1Ly7bA5BG7H+Ff80R+zmflK1fi9LIAXeX8KYtLRhCEb5WOW07KR9+hd5WRm3dfIfVe8BY3ztJlx8mDHK9+T1rmQqh32sWj2hJAUKpDNWxMewB6tdhTSmf9+YwEiJGKElg0NyaZ6KmYuCWZg03K+iziF/tdmv5ZKxv8mqbbyudAyTdMdgirLdXkn96WMl3XID03tTti3NLI285JbfHpWmgbKe4lIORAX7S9d+F90OfQGN12azrBJczuIZKpqFfe2h6F9Sk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(966005)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X739IUw+9n1UlOgwZr9jypCWc5VNLUN+OnJKOaf94xzJ/HFg7PmzNE99+IXA?=
 =?us-ascii?Q?6q6L9a4horLnDHlmGRR+MWObrgq7fc81XCj+001x5uiSgUfutBc1F7pdY293?=
 =?us-ascii?Q?yAODcJuLZe2SQMJ++WOxQX/h2YX6X8MoeeFEpCeKNcmG2L1+crme5iMB5A6l?=
 =?us-ascii?Q?D3n+tw86ClmxF78iwU4eZinygXFc4oMrFFea1DdDVMMNmYGogvk8+QqImTMz?=
 =?us-ascii?Q?/0Gek1H+Fd3akccxVuqQCleG72F7FkMFvdHHkxY1vQALBC8fXKLKyfAGfbOV?=
 =?us-ascii?Q?ZUHxEmi6iEvFLe6sLwSA8AEGlUoFo696GeeE0RUyDgb0rEU7QLr65UqCZsXf?=
 =?us-ascii?Q?BF2JiLcKgXt9HU5wRILVKGrZIlpw05JxK+PEG24OXlUWKlKpVGipVaRMsOeg?=
 =?us-ascii?Q?mbQqYyfzfTKBEtbXw9XN9rjpE+r2hJLg3uF4PxJpP52+Dja6sBjZ4dGpy4Kf?=
 =?us-ascii?Q?IKzWLRcmoo3uirKnYZ/oF/R4Utly3sGeh9ZxZUCzVJdH75lP51gP7HkaOtLo?=
 =?us-ascii?Q?sESVX33wpJFO0cDfb0YyhQ/nbj76kOuSAvOTmzgRhrtRAJM43Ew2DrJLOKqJ?=
 =?us-ascii?Q?TB/rmwDD7aTPpPLDBW0EEfjUJICc3do6Sl2o7YwypzOGDqYl87IREQFEioGb?=
 =?us-ascii?Q?CffO1QHaA0TObumwKDqwEqBMfvjjjISeTM0Q9AeOHMoEGfv2ZnOOrPv4U4hh?=
 =?us-ascii?Q?Nm+9nECgpQY/TxIfhkAOBBC/qIbEVraDq6fsyBEIrmQDkG+ZANAPoKkF9hBP?=
 =?us-ascii?Q?MWCcTIa2Jsx70RnCC33IMWA1QSii8f/uO6CVTlyBQNt7u1vgkbRHf35IfsMh?=
 =?us-ascii?Q?79HAwdZRdYm3l/HoH8IU9eH48BA16AiNM4RR4sGuJcqBQ1E0EsIXU+9cC7r/?=
 =?us-ascii?Q?k6HHbhOdAfgewp7h/OqByMd4g1qzW6YdbIH60+BFqRHGqMAgynR3RfZuc7rQ?=
 =?us-ascii?Q?qCUFOR//P7Hew/z53LGhXOsKbAPU99UZ05e4GnbY53bnjA/6TgZNVS9YPT95?=
 =?us-ascii?Q?t0VrAvzLQO9UL4KIQuxjav52PyPWRpoCzmJUdurZvKXjrYqJlcow04V2aC6e?=
 =?us-ascii?Q?/dSU4SMnRXM/7OwFuURhkjpJXHRPksqSlHvIndretGpgOdvJ+frixLnJv36P?=
 =?us-ascii?Q?04NpZHIr3dICqQHP03q3D/dAI7sIBO+G5cEMzi/ojB6USv7TRwK1D9URidxG?=
 =?us-ascii?Q?s0TG6BqcA52L9PrQhqN3JyKtBbNxf323ziGmnQRxaZVOt6atWGJsbbphyAuz?=
 =?us-ascii?Q?3I0t28E/cZ+v42v3SApSTHEg+svwZYjB/QxJzVwBROUsRnYD7fY7e5rugnst?=
 =?us-ascii?Q?xazIOttwCbgrWLxyl9vKSZIUHKOi7reSPWaFcvpkCGVlky1tdU+RbgiOozu+?=
 =?us-ascii?Q?CfEa/G820yB3UuK1d2M2/EPuAeBNBNRMYWUDX/EWIXzsvKgL9QL/OWG+16Ss?=
 =?us-ascii?Q?pPrMATwSOzWRDjy9DtVOTBi9VjCuR6WtqSAdjikpAdkr1jQsz2u/hbOizlF5?=
 =?us-ascii?Q?DrLiMVMVG5hn0XcmFO45gM/jjItG6ILxrvpXB+9nCslfP9Fmc86nBD8Y1+qf?=
 =?us-ascii?Q?H+jZhhIMLT/NKfx6opkrOBX/bJE5hmecIbsCjCa1pj7ZRkyDocRgkx7xT6pl?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa79189-3f93-4e87-6142-08dac6a76272
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:19:04.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9jl01ido/lEF5/VwgZLllC3OWkbsOnNcok+TyOr5BvF+ad/PjZWnWk12C5NBJGv81TH58Lea10RIB/ZUuEeKg==
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

Rename dsa_find_tagger_by_name() to denote the change in functionality:
there is now feature parity with dsa_tag_driver_get_by_id(), i.o.w. we
also load the module if it's missing.

Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28 w/ ocelot_8021q
---
v1->v2:
- don't call request_module() with sysfs-formatted names that end in '\n'

 net/dsa/dsa.c      | 4 +++-
 net/dsa/dsa2.c     | 2 +-
 net/dsa/dsa_priv.h | 2 +-
 net/dsa/master.c   | 4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index d51b81cc196c..857d07c6d0cb 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -78,11 +78,13 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 /* Function takes a reference on the module owning the tagger,
  * so dsa_tag_driver_put must be called afterwards.
  */
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name)
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name)
 {
 	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
 	struct dsa_tag_driver *dsa_tag_driver;
 
+	request_module("%s%s", DSA_TAG_DRIVER_ALIAS, name);
+
 	mutex_lock(&dsa_tag_drivers_lock);
 	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
 		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9920eed0c654..1bcf8a2d4a95 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1424,7 +1424,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 			return -EINVAL;
 		}
 
-		tag_ops = dsa_find_tagger_by_name(user_protocol);
+		tag_ops = dsa_tag_driver_get_by_name(user_protocol);
 		if (IS_ERR(tag_ops)) {
 			dev_warn(ds->dev,
 				 "Failed to find a tagging driver for protocol %s, using default\n",
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index e128095f9e65..d2fefc40bc7a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -244,8 +244,8 @@ struct dsa_slave_priv {
 
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
-const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name);
 
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 104eab880076..56ed7af89ac3 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -315,9 +315,9 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 		return -ENOMEM;
 
 	old_tag_ops = cpu_dp->tag_ops;
-	new_tag_ops = dsa_find_tagger_by_name(name);
+	new_tag_ops = dsa_tag_driver_get_by_name(name);
 	kfree(name);
-	/* Bad tagger name, or module is not loaded? */
+	/* Bad tagger name? */
 	if (IS_ERR(new_tag_ops))
 		return PTR_ERR(new_tag_ops);
 
-- 
2.34.1

