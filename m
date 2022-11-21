Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253D8632479
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiKUN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKUN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:36 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB28C4B4E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhlTQaAp3GVT+K6VpEM0SK+JHTtPIl045SqfAhXJeUd3+N5r/RwUAcc7dsmwysziem76MmggJFl+BwIX+GpAqZMx7Pe8WUiS944Bj2yHdc2ZoV5+DYSaAvPag8v1EWYh5cKc+KdC534DrCfpgWom4zdKbHSZu4oCLRjL5/0Wp6VCpu6qJc4Xb6glcDjsjMMPeJf+eltnQuSTi3xhP/2PckarZJwhaAtChprsbjB1v5Y408X5Jhmx9rWpxlrDmJwQbEoWjgU8g9LhfNt+YV4j9Y+V6iUrq5qihIEyiH3J/CI6fKmJJbN2uw2eEdgZzA2vRIKUQ1RbIG4+1zBbnqUKnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uIpctzKPnI7v32PUbCXr6fBpG+kwpoPiKGAss231Zk=;
 b=P6xB2CETb+GnAmlSNvMlfcpwjd6dk5egOK2cxCUbG2/f0jreh4JB3gsgZ6ThWehDEGdoWscsMft5NJ/yn/NgaqNj8tm3Rd2J4s9FJ2wANY6XSgoWQCK6x6XewSwC980kXGWk08PTEUFYV80afut9gdHrRTlQsT5HFiK7hACCd+xitbVSkzZZn+PBlIJrfeumuxbnQNvMfeG8KJSnst535nLI5ju+Mvg/O9Q8Zynlx4qsrwn/8uyIaSdmYi0ZMyn/Wu6FPv56q0czU1sKGMt/Gj0GSYWEIIr5BMqV48MEZDijipdLJnE6JD+XlnXU4ytnm3rXO//SmYDZ1HzZ59n6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uIpctzKPnI7v32PUbCXr6fBpG+kwpoPiKGAss231Zk=;
 b=UBcZYcHfnchsfz1ohdztavrz9LZsM8QLSA983Kwcm/fJ5SvqJUizUZPTGa8VoUOfYdzR7UEeoxD7jT2/D1RAedHk+Vkh2soBCC5jFMi6ephVEUCUq2IJJHwRknc/rDULuYAz2ugdAyqj30Ko1MOMMVTGREK/yLpcDMwVMEIW1nI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 09/17] net: dsa: move tagging protocol code to tag.{c,h}
Date:   Mon, 21 Nov 2022 15:55:47 +0200
Message-Id: <20221121135555.1227271-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 594ab9e8-0593-4250-8932-08dacbc829fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RJY0jJFgCN7+9VVIVVtcjN+K8T0Cm1OG5LLeTjUhtFVSfejGImj1jpq6VIhbrFhwElVLrGFna1Aw5e0rofgBmSR3dWQDnQaILIkyrjdICK5tm+33kZCVNJSeu+1i32wjgb9docD1FAijMYWKZUiyCPS2KduII1HJN26CmkqjNoi3llYgpHsGZ5fM82eDrBNMkv0SuoS8pgIhS1ZO8QFO2uvwP6bdq+rkAwcdJ0RltSpwh+Wtpxn8uz2OO3pKDoBCGRyT+tio6RfeXEvkicVjSbG1V6EqSNDnBGNBjOdWvISL02FoYjPWkGPPEhgXMn+sWJriXpX5z0Ncuq8FvEWEfeRORtl2P8y2T64RycNTkyqp5OqSn7HKCHRS6hmLqATVfLjPIfJW3iQ8LmOfMGfXp3WP4uQFmERDQ2ab+f80MlVFsw5jJp1W349i0rjm2HhB5EL/ZBxjJF/6flPJ0wewK7djNPtHKyYqmWc6lt1pRxqgIrDSwp/Ye5qYGWl29wSq0M3RDv1Q9+1jmeRLAzeBtDOSf1bM6cgvDWaoQfQnoLoRc++OBGNcDBm7z/s5CJzsRm4lc+A2/5+tb8Zw5J62BIg2TAdoTzBsFVwx3qMlcG4rVG/TZAKPiGsPhmbi6GAciNpQXHl7itZw9OrFxPQkdiIK8tpSKhWHheTF7xcYHSSuHVqkaDAKyfzOtKQHUE3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(30864003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?prGOu/iueYfFnPMRmoE7FutMEDOxQ7OLKpKGuCvoVFc8h6rCIUdWeMYp9j82?=
 =?us-ascii?Q?UVD7FGZA8YKeausDba2Q99f0UtTuR618lgfBQLYfIocmUaczDL3NzjFmDQwG?=
 =?us-ascii?Q?zfg+ZxtFnVtarI5vRU0Ud5Lirwq9O11ySwqK9hoSUIzV3jnYwKguyiF+glRa?=
 =?us-ascii?Q?t5vHLdPeXFS0TlAN+u8Hqs0w2J/LL9xGAkWuLVQj+wlhHX2laFBZ7ZrN14D3?=
 =?us-ascii?Q?Ji7gbQvspMIvmDQYHP5dAry+Q8cCJu35J5ebDct61ugfP+ItlNZCY92RTNxl?=
 =?us-ascii?Q?vrehdtBa/kaIHqJ1b1MxKVVeZd34C6eNLmeIz+r3P3sj00O9g+eTboyh9fNw?=
 =?us-ascii?Q?tzvVH437x2tMqdrAKQsdgYTQuUDqD2RutfkYYumJk0/HUtNrnRVZoMLR6TRq?=
 =?us-ascii?Q?ZdvvsaxCD+TTMn2UdrL+SItQk7ToQAWzHII3Wg0eaIGFjBfWZi+lKSNT2squ?=
 =?us-ascii?Q?k7coL0MuaKR/UjSQ9ibyjs4QKzNUVIIGHjpMPlMxx9acnJxHJ9JDELF+YE0P?=
 =?us-ascii?Q?K1COjPCiWb65BpbgLmFZYIl6uAH2W7F0WFqxO2iipgIvQBGt099hc8LZRyzu?=
 =?us-ascii?Q?3B3husZfKCHw2MWNCuXOgRSHk6e9b5zrgKue78JDzrEPUabzsdQvO6/chAmp?=
 =?us-ascii?Q?6PbouJl5q5/SIiHoVBhHOACHaZwwG18UaCf6uxEffTSXQLCQASC5ardyJWO7?=
 =?us-ascii?Q?nt7UfRcOkat/3cGv006zJmpii6MLzmfBYeT0Y4DiBhu9CDmLb20I8zloFq/y?=
 =?us-ascii?Q?scg38HKuR6JsP3y+gLFLW6mhzAbrKpbvMC4xVe4JAh/Cqui9u7BU4k/dO7Dv?=
 =?us-ascii?Q?PNY8DDQItpZyikxEnaAlHbz1p64P9ofKouEg5LM6oEWLIeTEgTA+GUHxZOwQ?=
 =?us-ascii?Q?LQZHJ3Ntxery8bXzHgOLoOskQ1jCTilk354PtVRl+yjReDJvqjhQD+zxAKEg?=
 =?us-ascii?Q?pzzpDIHm+7DXjokRThnCLeh2yvNCzLJ+RW5Eqt4IKm1dR+EGMMzNHY2fioTG?=
 =?us-ascii?Q?Hyi3HjhAEYtHPnj0efzU+no50UDjoVWYZxHQSRfmGNaJhE5grgylstZTu3+W?=
 =?us-ascii?Q?8OlvzdIXSfujImCV3ooaqM76WUJiAUi7z2CN+AJLYG5Srv3RCLDnqEwTEAjE?=
 =?us-ascii?Q?92LhnW9jdl7hquFvfv4XySemQ6nw8Y2HSEddH3okb2K2Qzsd7kG7hfu4ynet?=
 =?us-ascii?Q?EI5Mur5tbiyGweokIwoHJkeJaflbchpYGXpSdzZgQoPbuYFJ5eH7GslTgy8q?=
 =?us-ascii?Q?JZaBqk2wsxvI+bemTlGHmkGOhhPvltOEbMnfbmyGjH7VQ5eHbwaOg6QOV4WB?=
 =?us-ascii?Q?ikmyIT0OLrnIMJV+VOy7wg9UvlYoHUcn3FU5LTNakQG359zygfaxlvA3HwhW?=
 =?us-ascii?Q?TTpkepm9d6AZT0nQDhpLTKv72hMAg1bIXPxls2t1H5ELLPmB6lWtu4Tq2xp5?=
 =?us-ascii?Q?beXh3m4ef+JfaXRvuEtiVvvJGSkzsfBHCJjZCuJchIQ1W99og3bVRp6davjG?=
 =?us-ascii?Q?Dz4KlcomC1Ny/y5ozvM089iaF5156Jw9vkCjh0pdTYXiMmW3aFvXIxk1hxGt?=
 =?us-ascii?Q?uHvGL36xvJDy9zuxxaXuvndr+JHN08cNYlG7VQ+KrqRUNVKpLlaNj0wIdYZQ?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594ab9e8-0593-4250-8932-08dacbc829fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:18.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cY1VBvQcD9bMX5NIatXnMQ7XfAcxuj9rmj+wZdZ04HjPVbnVv3KcnG1GvVWE6UmlXgyxo+T340SMD/HeiSJnKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It would be nice if tagging protocol drivers could include just the
header they need, since they are (mostly) data path and isolated from
most of the other DSA core code does.

Create a tag.c and a tag.h file which are meant to support tagging
protocol drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Makefile           |   1 +
 net/dsa/dsa.c              | 229 +--------------------------
 net/dsa/dsa2.c             |   1 +
 net/dsa/dsa_priv.h         | 296 -----------------------------------
 net/dsa/master.c           |   1 +
 net/dsa/slave.c            |   1 +
 net/dsa/tag.c              | 243 +++++++++++++++++++++++++++++
 net/dsa/tag.h              | 310 +++++++++++++++++++++++++++++++++++++
 net/dsa/tag_8021q.c        |   1 +
 net/dsa/tag_ar9331.c       |   2 +-
 net/dsa/tag_brcm.c         |   2 +-
 net/dsa/tag_dsa.c          |   2 +-
 net/dsa/tag_gswip.c        |   2 +-
 net/dsa/tag_hellcreek.c    |   1 +
 net/dsa/tag_ksz.c          |   3 +-
 net/dsa/tag_lan9303.c      |   2 +-
 net/dsa/tag_mtk.c          |   2 +-
 net/dsa/tag_none.c         |   2 +-
 net/dsa/tag_ocelot.c       |   3 +-
 net/dsa/tag_ocelot_8021q.c |   3 +-
 net/dsa/tag_qca.c          |   2 +-
 net/dsa/tag_rtl4_a.c       |   2 +-
 net/dsa/tag_rtl8_4.c       |   2 +-
 net/dsa/tag_rzn1_a5psw.c   |   2 +-
 net/dsa/tag_sja1105.c      |   3 +-
 net/dsa/tag_trailer.c      |   2 +-
 net/dsa/tag_xrs700x.c      |   2 +-
 27 files changed, 581 insertions(+), 541 deletions(-)
 create mode 100644 net/dsa/tag.c
 create mode 100644 net/dsa/tag.h

diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index bc872c0d7011..93f5d5f1e495 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -10,6 +10,7 @@ dsa_core-y += \
 	port.o \
 	slave.o \
 	switch.o \
+	tag.o \
 	tag_8021q.o
 
 # tagging formats
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 422f8853d1c4..6f87dd1ee6bf 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -10,127 +10,10 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
-#include <linux/ptp_classify.h>
-#include <net/dst_metadata.h>
 
 #include "dsa_priv.h"
 #include "slave.h"
-
-static LIST_HEAD(dsa_tag_drivers_list);
-static DEFINE_MUTEX(dsa_tag_drivers_lock);
-
-static void dsa_tag_driver_register(struct dsa_tag_driver *dsa_tag_driver,
-				    struct module *owner)
-{
-	dsa_tag_driver->owner = owner;
-
-	mutex_lock(&dsa_tag_drivers_lock);
-	list_add_tail(&dsa_tag_driver->list, &dsa_tag_drivers_list);
-	mutex_unlock(&dsa_tag_drivers_lock);
-}
-
-void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
-			      unsigned int count, struct module *owner)
-{
-	unsigned int i;
-
-	for (i = 0; i < count; i++)
-		dsa_tag_driver_register(dsa_tag_driver_array[i], owner);
-}
-
-static void dsa_tag_driver_unregister(struct dsa_tag_driver *dsa_tag_driver)
-{
-	mutex_lock(&dsa_tag_drivers_lock);
-	list_del(&dsa_tag_driver->list);
-	mutex_unlock(&dsa_tag_drivers_lock);
-}
-EXPORT_SYMBOL_GPL(dsa_tag_drivers_register);
-
-void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
-				unsigned int count)
-{
-	unsigned int i;
-
-	for (i = 0; i < count; i++)
-		dsa_tag_driver_unregister(dsa_tag_driver_array[i]);
-}
-EXPORT_SYMBOL_GPL(dsa_tag_drivers_unregister);
-
-const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
-{
-	return ops->name;
-};
-
-/* Function takes a reference on the module owning the tagger,
- * so dsa_tag_driver_put must be called afterwards.
- */
-const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name)
-{
-	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
-	struct dsa_tag_driver *dsa_tag_driver;
-
-	request_module("%s%s", DSA_TAG_DRIVER_ALIAS, name);
-
-	mutex_lock(&dsa_tag_drivers_lock);
-	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
-		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
-
-		if (strcmp(name, tmp->name))
-			continue;
-
-		if (!try_module_get(dsa_tag_driver->owner))
-			break;
-
-		ops = tmp;
-		break;
-	}
-	mutex_unlock(&dsa_tag_drivers_lock);
-
-	return ops;
-}
-
-const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol)
-{
-	struct dsa_tag_driver *dsa_tag_driver;
-	const struct dsa_device_ops *ops;
-	bool found = false;
-
-	request_module("%sid-%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
-
-	mutex_lock(&dsa_tag_drivers_lock);
-	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
-		ops = dsa_tag_driver->ops;
-		if (ops->proto == tag_protocol) {
-			found = true;
-			break;
-		}
-	}
-
-	if (found) {
-		if (!try_module_get(dsa_tag_driver->owner))
-			ops = ERR_PTR(-ENOPROTOOPT);
-	} else {
-		ops = ERR_PTR(-ENOPROTOOPT);
-	}
-
-	mutex_unlock(&dsa_tag_drivers_lock);
-
-	return ops;
-}
-
-void dsa_tag_driver_put(const struct dsa_device_ops *ops)
-{
-	struct dsa_tag_driver *dsa_tag_driver;
-
-	mutex_lock(&dsa_tag_drivers_lock);
-	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
-		if (dsa_tag_driver->ops == ops) {
-			module_put(dsa_tag_driver->owner);
-			break;
-		}
-	}
-	mutex_unlock(&dsa_tag_drivers_lock);
-}
+#include "tag.h"
 
 static int dev_is_class(struct device *dev, void *class)
 {
@@ -168,111 +51,6 @@ struct net_device *dsa_dev_to_net_device(struct device *dev)
 	return NULL;
 }
 
-/* Determine if we should defer delivery of skb until we have a rx timestamp.
- *
- * Called from dsa_switch_rcv. For now, this will only work if tagging is
- * enabled on the switch. Normally the MAC driver would retrieve the hardware
- * timestamp when it reads the packet out of the hardware. However in a DSA
- * switch, the DSA driver owning the interface to which the packet is
- * delivered is never notified unless we do so here.
- */
-static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
-				       struct sk_buff *skb)
-{
-	struct dsa_switch *ds = p->dp->ds;
-	unsigned int type;
-
-	if (skb_headroom(skb) < ETH_HLEN)
-		return false;
-
-	__skb_push(skb, ETH_HLEN);
-
-	type = ptp_classify_raw(skb);
-
-	__skb_pull(skb, ETH_HLEN);
-
-	if (type == PTP_CLASS_NONE)
-		return false;
-
-	if (likely(ds->ops->port_rxtstamp))
-		return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
-
-	return false;
-}
-
-static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
-			  struct packet_type *pt, struct net_device *unused)
-{
-	struct metadata_dst *md_dst = skb_metadata_dst(skb);
-	struct dsa_port *cpu_dp = dev->dsa_ptr;
-	struct sk_buff *nskb = NULL;
-	struct dsa_slave_priv *p;
-
-	if (unlikely(!cpu_dp)) {
-		kfree_skb(skb);
-		return 0;
-	}
-
-	skb = skb_unshare(skb, GFP_ATOMIC);
-	if (!skb)
-		return 0;
-
-	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
-		unsigned int port = md_dst->u.port_info.port_id;
-
-		skb_dst_drop(skb);
-		if (!skb_has_extensions(skb))
-			skb->slow_gro = 0;
-
-		skb->dev = dsa_master_find_slave(dev, 0, port);
-		if (likely(skb->dev)) {
-			dsa_default_offload_fwd_mark(skb);
-			nskb = skb;
-		}
-	} else {
-		nskb = cpu_dp->rcv(skb, dev);
-	}
-
-	if (!nskb) {
-		kfree_skb(skb);
-		return 0;
-	}
-
-	skb = nskb;
-	skb_push(skb, ETH_HLEN);
-	skb->pkt_type = PACKET_HOST;
-	skb->protocol = eth_type_trans(skb, skb->dev);
-
-	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
-		/* Packet is to be injected directly on an upper
-		 * device, e.g. a team/bond, so skip all DSA-port
-		 * specific actions.
-		 */
-		netif_rx(skb);
-		return 0;
-	}
-
-	p = netdev_priv(skb->dev);
-
-	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
-		nskb = dsa_untag_bridge_pvid(skb);
-		if (!nskb) {
-			kfree_skb(skb);
-			return 0;
-		}
-		skb = nskb;
-	}
-
-	dev_sw_netstats_rx_add(skb->dev, skb->len);
-
-	if (dsa_skb_defer_rx_timestamp(p, skb))
-		return 0;
-
-	gro_cells_receive(&p->gcells, skb);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static bool dsa_port_is_initialized(const struct dsa_port *dp)
 {
@@ -327,11 +105,6 @@ int dsa_switch_resume(struct dsa_switch *ds)
 EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
-static struct packet_type dsa_pack_type __read_mostly = {
-	.type	= cpu_to_be16(ETH_P_XDSA),
-	.func	= dsa_switch_rcv,
-};
-
 static struct workqueue_struct *dsa_owq;
 
 bool dsa_schedule_work(struct work_struct *work)
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f917e695d38c..5373edf45a62 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -22,6 +22,7 @@
 #include "master.h"
 #include "port.h"
 #include "slave.h"
+#include "tag.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index fcff35b15dd4..eee2c9729e32 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -11,85 +11,8 @@
 #include <linux/netdevice.h>
 #include <net/dsa.h>
 
-#include "slave.h"
-
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
-/* Create 2 modaliases per tagging protocol, one to auto-load the module
- * given the ID reported by get_tag_protocol(), and the other by name.
- */
-#define DSA_TAG_DRIVER_ALIAS "dsa_tag:"
-#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto, __name) \
-	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __name); \
-	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS "id-" \
-		     __stringify(__proto##_VALUE))
-
-struct dsa_tag_driver {
-	const struct dsa_device_ops *ops;
-	struct list_head list;
-	struct module *owner;
-};
-
-void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
-			      unsigned int count,
-			      struct module *owner);
-void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
-				unsigned int count);
-
-#define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
-static int __init dsa_tag_driver_module_init(void)			\
-{									\
-	dsa_tag_drivers_register(__dsa_tag_drivers_array, __count,	\
-				 THIS_MODULE);				\
-	return 0;							\
-}									\
-module_init(dsa_tag_driver_module_init);				\
-									\
-static void __exit dsa_tag_driver_module_exit(void)			\
-{									\
-	dsa_tag_drivers_unregister(__dsa_tag_drivers_array, __count);	\
-}									\
-module_exit(dsa_tag_driver_module_exit)
-
-/**
- * module_dsa_tag_drivers() - Helper macro for registering DSA tag
- * drivers
- * @__ops_array: Array of tag driver structures
- *
- * Helper macro for DSA tag drivers which do not do anything special
- * in module init/exit. Each module may only use this macro once, and
- * calling it replaces module_init() and module_exit().
- */
-#define module_dsa_tag_drivers(__ops_array)				\
-dsa_tag_driver_module_drivers(__ops_array, ARRAY_SIZE(__ops_array))
-
-#define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
-
-/* Create a static structure we can build a linked list of dsa_tag
- * drivers
- */
-#define DSA_TAG_DRIVER(__ops)						\
-static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {		\
-	.ops = &__ops,							\
-}
-
-/**
- * module_dsa_tag_driver() - Helper macro for registering a single DSA tag
- * driver
- * @__ops: Single tag driver structures
- *
- * Helper macro for DSA tag drivers which do not do anything special
- * in module init/exit. Each module may only use this macro once, and
- * calling it replaces module_init() and module_exit().
- */
-#define module_dsa_tag_driver(__ops)					\
-DSA_TAG_DRIVER(__ops);							\
-									\
-static struct dsa_tag_driver *dsa_tag_driver_array[] =	{		\
-	&DSA_TAG_DRIVER_NAME(__ops)					\
-};									\
-module_dsa_tag_drivers(dsa_tag_driver_array)
-
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
@@ -223,234 +146,15 @@ struct dsa_standalone_event_work {
 };
 
 /* dsa.c */
-const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
-const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name);
-void dsa_tag_driver_put(const struct dsa_device_ops *ops);
-
 struct net_device *dsa_dev_to_net_device(struct device *dev);
 
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
 bool dsa_schedule_work(struct work_struct *work);
-const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
-
-static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
-{
-	return ops->needed_headroom + ops->needed_tailroom;
-}
-
-static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
-						       int device, int port)
-{
-	struct dsa_port *cpu_dp = dev->dsa_ptr;
-	struct dsa_switch_tree *dst = cpu_dp->dst;
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds->index == device && dp->index == port &&
-		    dp->type == DSA_PORT_TYPE_USER)
-			return dp->slave;
-
-	return NULL;
-}
 
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
- * frames as untagged, since the bridge will not untag them.
- */
-static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
-{
-	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct net_device *br = dsa_port_bridge_dev_get(dp);
-	struct net_device *dev = skb->dev;
-	struct net_device *upper_dev;
-	u16 vid, pvid, proto;
-	int err;
-
-	if (!br || br_vlan_enabled(br))
-		return skb;
-
-	err = br_vlan_get_proto(br, &proto);
-	if (err)
-		return skb;
-
-	/* Move VLAN tag from data to hwaccel */
-	if (!skb_vlan_tag_present(skb) && skb->protocol == htons(proto)) {
-		skb = skb_vlan_untag(skb);
-		if (!skb)
-			return NULL;
-	}
-
-	if (!skb_vlan_tag_present(skb))
-		return skb;
-
-	vid = skb_vlan_tag_get_id(skb);
-
-	/* We already run under an RCU read-side critical section since
-	 * we are called from netif_receive_skb_list_internal().
-	 */
-	err = br_vlan_get_pvid_rcu(dev, &pvid);
-	if (err)
-		return skb;
-
-	if (vid != pvid)
-		return skb;
-
-	/* The sad part about attempting to untag from DSA is that we
-	 * don't know, unless we check, if the skb will end up in
-	 * the bridge's data path - br_allowed_ingress() - or not.
-	 * For example, there might be an 8021q upper for the
-	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
-	 * from the bridge's data path. This is a configuration that DSA
-	 * supports because vlan_filtering is 0. In that case, we should
-	 * definitely keep the tag, to make sure it keeps working.
-	 */
-	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
-	if (upper_dev)
-		return skb;
-
-	__vlan_hwaccel_clear_tag(skb);
-
-	return skb;
-}
-
-/* For switches without hardware support for DSA tagging to be able
- * to support termination through the bridge.
- */
-static inline struct net_device *
-dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
-{
-	struct dsa_port *cpu_dp = master->dsa_ptr;
-	struct dsa_switch_tree *dst = cpu_dp->dst;
-	struct bridge_vlan_info vinfo;
-	struct net_device *slave;
-	struct dsa_port *dp;
-	int err;
-
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->type != DSA_PORT_TYPE_USER)
-			continue;
-
-		if (!dp->bridge)
-			continue;
-
-		if (dp->stp_state != BR_STATE_LEARNING &&
-		    dp->stp_state != BR_STATE_FORWARDING)
-			continue;
-
-		/* Since the bridge might learn this packet, keep the CPU port
-		 * affinity with the port that will be used for the reply on
-		 * xmit.
-		 */
-		if (dp->cpu_dp != cpu_dp)
-			continue;
-
-		slave = dp->slave;
-
-		err = br_vlan_get_info_rcu(slave, vid, &vinfo);
-		if (err)
-			continue;
-
-		return slave;
-	}
-
-	return NULL;
-}
-
-/* If the ingress port offloads the bridge, we mark the frame as autonomously
- * forwarded by hardware, so the software bridge doesn't forward in twice, back
- * to us, because we already did. However, if we're in fallback mode and we do
- * software bridging, we are not offloading it, therefore the dp->bridge
- * pointer is not populated, and flooding needs to be done by software (we are
- * effectively operating in standalone ports mode).
- */
-static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
-{
-	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-
-	skb->offload_fwd_mark = !!(dp->bridge);
-}
-
-/* Helper for removing DSA header tags from packets in the RX path.
- * Must not be called before skb_pull(len).
- *                                                                 skb->data
- *                                                                         |
- *                                                                         v
- * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * +-----------------------+-----------------------+---------------+-------+
- * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
- * +-----------------------+-----------------------+---------------+-------+
- *                                                 |               |
- * <----- len ----->                               <----- len ----->
- *                 |
- *       >>>>>>>   v
- *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- *       >>>>>>>   +-----------------------+-----------------------+-------+
- *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
- *                 +-----------------------+-----------------------+-------+
- *                                                                         ^
- *                                                                         |
- *                                                                 skb->data
- */
-static inline void dsa_strip_etype_header(struct sk_buff *skb, int len)
-{
-	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - len, 2 * ETH_ALEN);
-}
-
-/* Helper for creating space for DSA header tags in TX path packets.
- * Must not be called before skb_push(len).
- *
- * Before:
- *
- *       <<<<<<<   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * ^     <<<<<<<   +-----------------------+-----------------------+-------+
- * |     <<<<<<<   |    Destination MAC    |      Source MAC       | EType |
- * |               +-----------------------+-----------------------+-------+
- * <----- len ----->
- * |
- * |
- * skb->data
- *
- * After:
- *
- * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * +-----------------------+-----------------------+---------------+-------+
- * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
- * +-----------------------+-----------------------+---------------+-------+
- * ^                                               |               |
- * |                                               <----- len ----->
- * skb->data
- */
-static inline void dsa_alloc_etype_header(struct sk_buff *skb, int len)
-{
-	memmove(skb->data, skb->data + len, 2 * ETH_ALEN);
-}
-
-/* On RX, eth_type_trans() on the DSA master pulls ETH_HLEN bytes starting from
- * skb_mac_header(skb), which leaves skb->data pointing at the first byte after
- * what the DSA master perceives as the EtherType (the beginning of the L3
- * protocol). Since DSA EtherType header taggers treat the EtherType as part of
- * the DSA tag itself, and the EtherType is 2 bytes in length, the DSA header
- * is located 2 bytes behind skb->data. Note that EtherType in this context
- * means the first 2 bytes of the DSA header, not the encapsulated EtherType
- * that will become visible after the DSA header is stripped.
- */
-static inline void *dsa_etype_header_pos_rx(struct sk_buff *skb)
-{
-	return skb->data - 2;
-}
-
-/* On TX, skb->data points to skb_mac_header(skb), which means that EtherType
- * header taggers start exactly where the EtherType is (the EtherType is
- * treated as part of the DSA header).
- */
-static inline void *dsa_etype_header_pos_tx(struct sk_buff *skb)
-{
-	return skb->data + 2 * ETH_ALEN;
-}
-
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 6105821834a2..e38b349ca7f8 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -14,6 +14,7 @@
 #include "dsa_priv.h"
 #include "master.h"
 #include "port.h"
+#include "tag.h"
 
 static int dsa_master_get_regs_len(struct net_device *dev)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2cf83892072f..a928aaf68804 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -26,6 +26,7 @@
 #include "port.h"
 #include "master.h"
 #include "slave.h"
+#include "tag.h"
 
 static void dsa_slave_standalone_event_work(struct work_struct *work)
 {
diff --git a/net/dsa/tag.c b/net/dsa/tag.c
new file mode 100644
index 000000000000..383721e167d6
--- /dev/null
+++ b/net/dsa/tag.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * DSA tagging protocol handling
+ *
+ * Copyright (c) 2008-2009 Marvell Semiconductor
+ * Copyright (c) 2013 Florian Fainelli <florian@openwrt.org>
+ * Copyright (c) 2016 Andrew Lunn <andrew@lunn.ch>
+ */
+
+#include <linux/netdevice.h>
+#include <linux/ptp_classify.h>
+#include <linux/skbuff.h>
+#include <net/dsa.h>
+#include <net/dst_metadata.h>
+
+#include "slave.h"
+#include "tag.h"
+
+static LIST_HEAD(dsa_tag_drivers_list);
+static DEFINE_MUTEX(dsa_tag_drivers_lock);
+
+/* Determine if we should defer delivery of skb until we have a rx timestamp.
+ *
+ * Called from dsa_switch_rcv. For now, this will only work if tagging is
+ * enabled on the switch. Normally the MAC driver would retrieve the hardware
+ * timestamp when it reads the packet out of the hardware. However in a DSA
+ * switch, the DSA driver owning the interface to which the packet is
+ * delivered is never notified unless we do so here.
+ */
+static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
+				       struct sk_buff *skb)
+{
+	struct dsa_switch *ds = p->dp->ds;
+	unsigned int type;
+
+	if (skb_headroom(skb) < ETH_HLEN)
+		return false;
+
+	__skb_push(skb, ETH_HLEN);
+
+	type = ptp_classify_raw(skb);
+
+	__skb_pull(skb, ETH_HLEN);
+
+	if (type == PTP_CLASS_NONE)
+		return false;
+
+	if (likely(ds->ops->port_rxtstamp))
+		return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
+
+	return false;
+}
+
+static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
+			  struct packet_type *pt, struct net_device *unused)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct sk_buff *nskb = NULL;
+	struct dsa_slave_priv *p;
+
+	if (unlikely(!cpu_dp)) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
+		return 0;
+
+	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
+		unsigned int port = md_dst->u.port_info.port_id;
+
+		skb_dst_drop(skb);
+		if (!skb_has_extensions(skb))
+			skb->slow_gro = 0;
+
+		skb->dev = dsa_master_find_slave(dev, 0, port);
+		if (likely(skb->dev)) {
+			dsa_default_offload_fwd_mark(skb);
+			nskb = skb;
+		}
+	} else {
+		nskb = cpu_dp->rcv(skb, dev);
+	}
+
+	if (!nskb) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	skb = nskb;
+	skb_push(skb, ETH_HLEN);
+	skb->pkt_type = PACKET_HOST;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
+		/* Packet is to be injected directly on an upper
+		 * device, e.g. a team/bond, so skip all DSA-port
+		 * specific actions.
+		 */
+		netif_rx(skb);
+		return 0;
+	}
+
+	p = netdev_priv(skb->dev);
+
+	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
+		nskb = dsa_untag_bridge_pvid(skb);
+		if (!nskb) {
+			kfree_skb(skb);
+			return 0;
+		}
+		skb = nskb;
+	}
+
+	dev_sw_netstats_rx_add(skb->dev, skb->len);
+
+	if (dsa_skb_defer_rx_timestamp(p, skb))
+		return 0;
+
+	gro_cells_receive(&p->gcells, skb);
+
+	return 0;
+}
+
+struct packet_type dsa_pack_type __read_mostly = {
+	.type	= cpu_to_be16(ETH_P_XDSA),
+	.func	= dsa_switch_rcv,
+};
+
+static void dsa_tag_driver_register(struct dsa_tag_driver *dsa_tag_driver,
+				    struct module *owner)
+{
+	dsa_tag_driver->owner = owner;
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_add_tail(&dsa_tag_driver->list, &dsa_tag_drivers_list);
+	mutex_unlock(&dsa_tag_drivers_lock);
+}
+
+void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
+			      unsigned int count, struct module *owner)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		dsa_tag_driver_register(dsa_tag_driver_array[i], owner);
+}
+
+static void dsa_tag_driver_unregister(struct dsa_tag_driver *dsa_tag_driver)
+{
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_del(&dsa_tag_driver->list);
+	mutex_unlock(&dsa_tag_drivers_lock);
+}
+EXPORT_SYMBOL_GPL(dsa_tag_drivers_register);
+
+void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
+				unsigned int count)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		dsa_tag_driver_unregister(dsa_tag_driver_array[i]);
+}
+EXPORT_SYMBOL_GPL(dsa_tag_drivers_unregister);
+
+const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
+{
+	return ops->name;
+};
+
+/* Function takes a reference on the module owning the tagger,
+ * so dsa_tag_driver_put must be called afterwards.
+ */
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name)
+{
+	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
+	struct dsa_tag_driver *dsa_tag_driver;
+
+	request_module("%s%s", DSA_TAG_DRIVER_ALIAS, name);
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
+
+		if (strcmp(name, tmp->name))
+			continue;
+
+		if (!try_module_get(dsa_tag_driver->owner))
+			break;
+
+		ops = tmp;
+		break;
+	}
+	mutex_unlock(&dsa_tag_drivers_lock);
+
+	return ops;
+}
+
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol)
+{
+	struct dsa_tag_driver *dsa_tag_driver;
+	const struct dsa_device_ops *ops;
+	bool found = false;
+
+	request_module("%sid-%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		ops = dsa_tag_driver->ops;
+		if (ops->proto == tag_protocol) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		if (!try_module_get(dsa_tag_driver->owner))
+			ops = ERR_PTR(-ENOPROTOOPT);
+	} else {
+		ops = ERR_PTR(-ENOPROTOOPT);
+	}
+
+	mutex_unlock(&dsa_tag_drivers_lock);
+
+	return ops;
+}
+
+void dsa_tag_driver_put(const struct dsa_device_ops *ops)
+{
+	struct dsa_tag_driver *dsa_tag_driver;
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		if (dsa_tag_driver->ops == ops) {
+			module_put(dsa_tag_driver->owner);
+			break;
+		}
+	}
+	mutex_unlock(&dsa_tag_drivers_lock);
+}
diff --git a/net/dsa/tag.h b/net/dsa/tag.h
new file mode 100644
index 000000000000..7cfbca824f1c
--- /dev/null
+++ b/net/dsa/tag.h
@@ -0,0 +1,310 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_TAG_H
+#define __DSA_TAG_H
+
+#include <linux/if_vlan.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <net/dsa.h>
+
+#include "port.h"
+#include "slave.h"
+
+struct dsa_tag_driver {
+	const struct dsa_device_ops *ops;
+	struct list_head list;
+	struct module *owner;
+};
+
+extern struct packet_type dsa_pack_type;
+
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
+const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name);
+void dsa_tag_driver_put(const struct dsa_device_ops *ops);
+const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
+
+static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
+{
+	return ops->needed_headroom + ops->needed_tailroom;
+}
+
+static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
+						       int device, int port)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds->index == device && dp->index == port &&
+		    dp->type == DSA_PORT_TYPE_USER)
+			return dp->slave;
+
+	return NULL;
+}
+
+/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
+ * frames as untagged, since the bridge will not untag them.
+ */
+static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
+	struct net_device *dev = skb->dev;
+	struct net_device *upper_dev;
+	u16 vid, pvid, proto;
+	int err;
+
+	if (!br || br_vlan_enabled(br))
+		return skb;
+
+	err = br_vlan_get_proto(br, &proto);
+	if (err)
+		return skb;
+
+	/* Move VLAN tag from data to hwaccel */
+	if (!skb_vlan_tag_present(skb) && skb->protocol == htons(proto)) {
+		skb = skb_vlan_untag(skb);
+		if (!skb)
+			return NULL;
+	}
+
+	if (!skb_vlan_tag_present(skb))
+		return skb;
+
+	vid = skb_vlan_tag_get_id(skb);
+
+	/* We already run under an RCU read-side critical section since
+	 * we are called from netif_receive_skb_list_internal().
+	 */
+	err = br_vlan_get_pvid_rcu(dev, &pvid);
+	if (err)
+		return skb;
+
+	if (vid != pvid)
+		return skb;
+
+	/* The sad part about attempting to untag from DSA is that we
+	 * don't know, unless we check, if the skb will end up in
+	 * the bridge's data path - br_allowed_ingress() - or not.
+	 * For example, there might be an 8021q upper for the
+	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
+	 * from the bridge's data path. This is a configuration that DSA
+	 * supports because vlan_filtering is 0. In that case, we should
+	 * definitely keep the tag, to make sure it keeps working.
+	 */
+	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
+	if (upper_dev)
+		return skb;
+
+	__vlan_hwaccel_clear_tag(skb);
+
+	return skb;
+}
+
+/* For switches without hardware support for DSA tagging to be able
+ * to support termination through the bridge.
+ */
+static inline struct net_device *
+dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct bridge_vlan_info vinfo;
+	struct net_device *slave;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->type != DSA_PORT_TYPE_USER)
+			continue;
+
+		if (!dp->bridge)
+			continue;
+
+		if (dp->stp_state != BR_STATE_LEARNING &&
+		    dp->stp_state != BR_STATE_FORWARDING)
+			continue;
+
+		/* Since the bridge might learn this packet, keep the CPU port
+		 * affinity with the port that will be used for the reply on
+		 * xmit.
+		 */
+		if (dp->cpu_dp != cpu_dp)
+			continue;
+
+		slave = dp->slave;
+
+		err = br_vlan_get_info_rcu(slave, vid, &vinfo);
+		if (err)
+			continue;
+
+		return slave;
+	}
+
+	return NULL;
+}
+
+/* If the ingress port offloads the bridge, we mark the frame as autonomously
+ * forwarded by hardware, so the software bridge doesn't forward in twice, back
+ * to us, because we already did. However, if we're in fallback mode and we do
+ * software bridging, we are not offloading it, therefore the dp->bridge
+ * pointer is not populated, and flooding needs to be done by software (we are
+ * effectively operating in standalone ports mode).
+ */
+static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+
+	skb->offload_fwd_mark = !!(dp->bridge);
+}
+
+/* Helper for removing DSA header tags from packets in the RX path.
+ * Must not be called before skb_pull(len).
+ *                                                                 skb->data
+ *                                                                         |
+ *                                                                         v
+ * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * +-----------------------+-----------------------+---------------+-------+
+ * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
+ * +-----------------------+-----------------------+---------------+-------+
+ *                                                 |               |
+ * <----- len ----->                               <----- len ----->
+ *                 |
+ *       >>>>>>>   v
+ *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ *       >>>>>>>   +-----------------------+-----------------------+-------+
+ *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
+ *                 +-----------------------+-----------------------+-------+
+ *                                                                         ^
+ *                                                                         |
+ *                                                                 skb->data
+ */
+static inline void dsa_strip_etype_header(struct sk_buff *skb, int len)
+{
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - len, 2 * ETH_ALEN);
+}
+
+/* Helper for creating space for DSA header tags in TX path packets.
+ * Must not be called before skb_push(len).
+ *
+ * Before:
+ *
+ *       <<<<<<<   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * ^     <<<<<<<   +-----------------------+-----------------------+-------+
+ * |     <<<<<<<   |    Destination MAC    |      Source MAC       | EType |
+ * |               +-----------------------+-----------------------+-------+
+ * <----- len ----->
+ * |
+ * |
+ * skb->data
+ *
+ * After:
+ *
+ * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * +-----------------------+-----------------------+---------------+-------+
+ * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
+ * +-----------------------+-----------------------+---------------+-------+
+ * ^                                               |               |
+ * |                                               <----- len ----->
+ * skb->data
+ */
+static inline void dsa_alloc_etype_header(struct sk_buff *skb, int len)
+{
+	memmove(skb->data, skb->data + len, 2 * ETH_ALEN);
+}
+
+/* On RX, eth_type_trans() on the DSA master pulls ETH_HLEN bytes starting from
+ * skb_mac_header(skb), which leaves skb->data pointing at the first byte after
+ * what the DSA master perceives as the EtherType (the beginning of the L3
+ * protocol). Since DSA EtherType header taggers treat the EtherType as part of
+ * the DSA tag itself, and the EtherType is 2 bytes in length, the DSA header
+ * is located 2 bytes behind skb->data. Note that EtherType in this context
+ * means the first 2 bytes of the DSA header, not the encapsulated EtherType
+ * that will become visible after the DSA header is stripped.
+ */
+static inline void *dsa_etype_header_pos_rx(struct sk_buff *skb)
+{
+	return skb->data - 2;
+}
+
+/* On TX, skb->data points to skb_mac_header(skb), which means that EtherType
+ * header taggers start exactly where the EtherType is (the EtherType is
+ * treated as part of the DSA header).
+ */
+static inline void *dsa_etype_header_pos_tx(struct sk_buff *skb)
+{
+	return skb->data + 2 * ETH_ALEN;
+}
+
+/* Create 2 modaliases per tagging protocol, one to auto-load the module
+ * given the ID reported by get_tag_protocol(), and the other by name.
+ */
+#define DSA_TAG_DRIVER_ALIAS "dsa_tag:"
+#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto, __name) \
+	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __name); \
+	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS "id-" \
+		     __stringify(__proto##_VALUE))
+
+void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
+			      unsigned int count,
+			      struct module *owner);
+void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
+				unsigned int count);
+
+#define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
+static int __init dsa_tag_driver_module_init(void)			\
+{									\
+	dsa_tag_drivers_register(__dsa_tag_drivers_array, __count,	\
+				 THIS_MODULE);				\
+	return 0;							\
+}									\
+module_init(dsa_tag_driver_module_init);				\
+									\
+static void __exit dsa_tag_driver_module_exit(void)			\
+{									\
+	dsa_tag_drivers_unregister(__dsa_tag_drivers_array, __count);	\
+}									\
+module_exit(dsa_tag_driver_module_exit)
+
+/**
+ * module_dsa_tag_drivers() - Helper macro for registering DSA tag
+ * drivers
+ * @__ops_array: Array of tag driver structures
+ *
+ * Helper macro for DSA tag drivers which do not do anything special
+ * in module init/exit. Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit().
+ */
+#define module_dsa_tag_drivers(__ops_array)				\
+dsa_tag_driver_module_drivers(__ops_array, ARRAY_SIZE(__ops_array))
+
+#define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
+
+/* Create a static structure we can build a linked list of dsa_tag
+ * drivers
+ */
+#define DSA_TAG_DRIVER(__ops)						\
+static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {		\
+	.ops = &__ops,							\
+}
+
+/**
+ * module_dsa_tag_driver() - Helper macro for registering a single DSA tag
+ * driver
+ * @__ops: Single tag driver structures
+ *
+ * Helper macro for DSA tag drivers which do not do anything special
+ * in module init/exit. Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit().
+ */
+#define module_dsa_tag_driver(__ops)					\
+DSA_TAG_DRIVER(__ops);							\
+									\
+static struct dsa_tag_driver *dsa_tag_driver_array[] =	{		\
+	&DSA_TAG_DRIVER_NAME(__ops)					\
+};									\
+module_dsa_tag_drivers(dsa_tag_driver_array)
+
+#endif
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index a6617d7b692a..ee5dd1a54b51 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -9,6 +9,7 @@
 
 #include "dsa_priv.h"
 #include "port.h"
+#include "tag.h"
 
 /* Binary structure of the fake 12-bit VID field (when the TPID is
  * ETH_P_DSA_8021Q):
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index bfa161a4f502..7f3b7d730b85 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -7,7 +7,7 @@
 #include <linux/bitfield.h>
 #include <linux/etherdevice.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define AR9331_NAME			"ar9331"
 
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9e7477ed70f1..10239daa5745 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -10,7 +10,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define BRCM_NAME		"brcm"
 #define BRCM_LEGACY_NAME	"brcm-legacy"
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 9fe77f5cc759..1fd7fa26db64 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -50,7 +50,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define DSA_NAME	"dsa"
 #define EDSA_NAME	"edsa"
diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 020050dff3e4..e279cd9057b0 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -10,7 +10,7 @@
 #include <linux/skbuff.h>
 #include <net/dsa.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define GSWIP_NAME			"gswip"
 
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 03fd5f2877c8..a047041e7686 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -12,6 +12,7 @@
 #include <net/dsa.h>
 
 #include "dsa_priv.h"
+#include "tag.h"
 
 #define HELLCREEK_NAME		"hellcreek"
 
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 37db5156f9a3..0f6ae143afc9 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -7,7 +7,8 @@
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <net/dsa.h>
-#include "dsa_priv.h"
+
+#include "tag.h"
 
 #define KSZ8795_NAME "ksz8795"
 #define KSZ9477_NAME "ksz9477"
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index 4118292ed218..c25f5536706b 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 /* To define the outgoing port and to discover the incoming port a regular
  * VLAN tag is used by the LAN9303. But its VID meaning is 'special':
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 8948c4f99f8e..40af80452747 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -8,7 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define MTK_NAME		"mtk"
 
diff --git a/net/dsa/tag_none.c b/net/dsa/tag_none.c
index 34a13c50d245..d2fd179c4227 100644
--- a/net/dsa/tag_none.c
+++ b/net/dsa/tag_none.c
@@ -8,7 +8,7 @@
  * tagging support, look at tag_8021q.c instead.
  */
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define NONE_NAME	"none"
 
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8cc31ab47e28..28ebecafdd24 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -2,7 +2,8 @@
 /* Copyright 2019 NXP
  */
 #include <linux/dsa/ocelot.h>
-#include "dsa_priv.h"
+
+#include "tag.h"
 
 #define OCELOT_NAME	"ocelot"
 #define SEVILLE_NAME	"seville"
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index d1ec68001487..7f0c2d71e89b 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -10,7 +10,8 @@
  */
 #include <linux/dsa/8021q.h>
 #include <linux/dsa/ocelot.h>
-#include "dsa_priv.h"
+
+#include "tag.h"
 
 #define OCELOT_8021Q_NAME "ocelot-8021q"
 
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 73d6e111228d..e757c8de06f1 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -8,7 +8,7 @@
 #include <net/dsa.h>
 #include <linux/dsa/tag_qca.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define QCA_NAME "qca"
 
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 18b52d77d200..c327314b95e3 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -18,7 +18,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bits.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define RTL4_A_NAME		"rtl4a"
 
diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index 030a8cf0ad48..4f67834fd121 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -77,7 +77,7 @@
 #include <linux/bits.h>
 #include <linux/etherdevice.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 /* Protocols supported:
  *
diff --git a/net/dsa/tag_rzn1_a5psw.c b/net/dsa/tag_rzn1_a5psw.c
index b9135069f9fc..437a6820ac42 100644
--- a/net/dsa/tag_rzn1_a5psw.c
+++ b/net/dsa/tag_rzn1_a5psw.c
@@ -10,7 +10,7 @@
 #include <linux/if_ether.h>
 #include <net/dsa.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 /* To define the outgoing port and to discover the incoming port a TAG is
  * inserted after Src MAC :
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 3b6e642a90e9..8f581617e15c 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -5,7 +5,8 @@
 #include <linux/dsa/sja1105.h>
 #include <linux/dsa/8021q.h>
 #include <linux/packing.h>
-#include "dsa_priv.h"
+
+#include "tag.h"
 
 #define SJA1105_NAME				"sja1105"
 #define SJA1110_NAME				"sja1110"
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 8754dfe680f6..7361b9106382 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define TRAILER_NAME "trailer"
 
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index dc935dd90f98..af19969f9bc4 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -7,7 +7,7 @@
 
 #include <linux/bitops.h>
 
-#include "dsa_priv.h"
+#include "tag.h"
 
 #define XRS700X_NAME "xrs700x"
 
-- 
2.34.1

