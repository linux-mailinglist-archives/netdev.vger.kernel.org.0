Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1601421724
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbhJDTRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:51 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238741AbhJDTRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxHN6lJbayswf7To9j6wJ0H88erHzQhCZEWy0ePfBNSZYuW7xA4pcQC54o9Ito1IVjUb0UFXA5IuPv1j3xdQGmDSYfWFjSwn+rgObfY8Kvji1qtEyXLLsRaR5KmdNqs9QpiT3W69qgBYLdU7Cq0bYHjCLAuv28EWqPEZ9XD19FVrAWIwaQRpHCVVx0Kzh49S4k8WbnIooAmn3aNi6S00y9jZw+/rEs4RJbq4HC+nkSJwJG/GLa3uLQUtsG5TynldYyuqPS5VlZbksN/rjQ3dSPVizUCOcMlA613jbXpKuCvXd3qZJkX7P5yOdhyMGdhENWY7rvQTpsVEqRd9KPce4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQP7iSAnhKghUcqfAdxPrHW+lbwz7EmbO548HV2diTQ=;
 b=M5mFzwEhCRVa9wOSO06g7MVIOV4THe1ROjBbw5IbL07NDAXDyhlgMis6QXiCskFgZa4M4ffUF+lTFTwwHMi5z3pSoH2jzaUtcHuTNIc3ou0gK+V6JCGGcIB0cdu3c2ezTCRzmOqhESTHJlsdNTXdxI1rfSMNbLNRgIEnqJq2qp4bxCAneCTnF/cjj28Mz9CrHNjTf8A7usre4mKIvHvwevR3ORv4kv1pEvsl6k+jIq1W5+A+McXFjlzmNWJHT/BL3jF83FD3LLHsK0LHtbVi5iqPTIBPsr0hCgWAIZpQ6c3sTgBtGKnyW+SHeI9kYUcetWNR7XhTak9K9RdeVBlfVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQP7iSAnhKghUcqfAdxPrHW+lbwz7EmbO548HV2diTQ=;
 b=w6FvBryX0nN5xgn4QlNEG0JZzwFSIv600ej7Sjtv/psFj6HOA+9yrqY9W9D9K0E6NwLRiEooj/e2R+V9y2s64J/NiTBaIDfS8RPMAaESmoJ3jscn1CC9iorlbXaJ0uB9AVGXv5e/ySdMG38SCbpDYwxbfCpubsH41zi6HBmQcNk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:54 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:54 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [RFC net-next PATCH 05/16] net: phylink: Automatically attach PCS devices
Date:   Mon,  4 Oct 2021 15:15:16 -0400
Message-Id: <20211004191527.1610759-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efc22294-5544-42ab-2001-08d9876b634a
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7434553C5B008AA85A9A6E5096AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkPk1HkYR5mArSUx6AlJjsZQvqLUv3tKE7SjBhlgqbcnFWyEVZzVkyWI3DzN/vUgicc4LoX0EbGbdKNI5kjoyQTKuJybKqeDRpttMByQ0R7y4Mk6CD4197kjvsM7qQgopSVCt0DDiYYKUbmzXxkcAuIBOqvAD/8UJVcJAK+Pw6r07MC3IkiGP0KjiWrp0niy9w3jPbXT5pgKrCKn/uE4bNnSeRuzF4ZxXRKXt2rQlayzaVy0Q6U/v01PXwm1fPYJTziWeMmN4s6uee0urd3nU6uDc1a/TeR7/li8kWv8nWOU/dvkURZkoatdYcHBRUJ3iSU47ylYHAHtALVPjVAe2MTouF+QFbG+TUSElHizygVKFmlD9EbsDEeJPjwEo6Qm5ChSpIP7RwPvlV0tkWSx0nC5gYNA/QG3hZ4MCko7vZeJbacqggWSGyGxJO9Xyr1Aj/W87eP78rNQcbFwLwR0HlcUeCKD3DHierMPK42PY9linRidCuiSg83vu8phgpyWlTH52iPywx+gBNR4/OfQ9E67+8JxXA7HFw66Z8K9f6wi+E8imfNKW/DqBZfH2b0KWUkLXTyUt788j4OsfjlgHbB+ZiivPzxr5SywVgnWyS8nrOnLQDrjkKCyMVPUTqcPHduGeNIC6jZJkG1Zs+bmw3nhoa9xeaPi3Wi/Nypv6BZazrDYAwYhVGySuIADzvT5VNE+LzvrLQWWKX2IfIOxPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8CJX875Y8Z9KZpNE9SaMSBkbrMrOVhZIyiPjCHeNn4BjDF7PJZ3M82rBeROp?=
 =?us-ascii?Q?fvKeyTi8/r1I5sXl5iNvdbJYNgvlLLdHQYXHdxX+RbozhJvdd333e5NzMFRD?=
 =?us-ascii?Q?P668z4uFeN6ezTwPB8Cv15bp92sXwftfUf6wWVQTxiO8OkXn+tGH2xh/xHh9?=
 =?us-ascii?Q?wXqywRS6wGRyvezQfwkOnsMMtUPEhjqprcdfJ3YX97nPVCZmRyJRPrhTDech?=
 =?us-ascii?Q?WFL0cuIrfyL0DagznDnZd/7t+3hDwKhblOSudqQQpc2uHG+pEGSdDclVncOv?=
 =?us-ascii?Q?7r0WZQOnDysMoGFpsiJx4vPiSS5COpfDnJqaRCXvnbZCMSm0iw67TTU5u66H?=
 =?us-ascii?Q?0My3RgZ9eJgAmn7SiMtGZcfbHvyah2HSfMBlmgQEIF4m4fqR07vYuVJDVyVC?=
 =?us-ascii?Q?mAZxevyr0CfjFxenn3v5LdVXebTx7Q2bbGbge3b8l3Rhl8or2pLsKn3BKEIa?=
 =?us-ascii?Q?55HKDVQBTWR1f2kkg3wp7rPxkGcBzFYxM0jRoH6DKnDbVfuT9E+ObQvtABqt?=
 =?us-ascii?Q?lRbs6Q42rCh6ZhSQe98Yt1oJptVuQap5rOVL9m/f//3jE6q1cM+wQUmr2nJd?=
 =?us-ascii?Q?ytYjiea8r3wAIbzPK8Xaaatr50jX+A8pKxxVfsC1TpiuhVCqLo+vjGcaqPBu?=
 =?us-ascii?Q?z5niHIbvOVfeeP+k5Pg3JehNLXglUKuzubnEGiuathsn7ZP/Kbj4RArTFMS7?=
 =?us-ascii?Q?nk+EH9Agfp9fz/QclFuXUy/e9Ej7ysWSYUy1Nb7Vr6qrWdLWIwUGV2TvxUpV?=
 =?us-ascii?Q?aj+QswJLEBjLbXP41nhQHFUf6tkEVP/DAymfLrFnCF5a8wpryLmK2SLshFZC?=
 =?us-ascii?Q?uaNQFJ62Ox2SiW7SJEq45oMa9HpgCTqd1WPlCQi0CJMA9ARxRJJH3bDOMrdW?=
 =?us-ascii?Q?pDJp/hNbbLBudShlNElal9gCe2XYQS8+CgSkTDm4gqhsLMsSiUzxNTSmY9p9?=
 =?us-ascii?Q?cyRXRKesdcz6dMePBUT4B9Q8I41y8Z8BxQ90/8k/iWUrinjQHdoVUTaTrT0/?=
 =?us-ascii?Q?+K9uGmiJN4v7xN5Xj6l9ygiKD+9jmqAwH34ksI+rAGFMF1hglVyXFWY4xhhY?=
 =?us-ascii?Q?/UddjHBnt+Mna3oH+CVfwfynhS+es3G9fz49OmIn6Kzs+fFLSYe4c6uz5qCS?=
 =?us-ascii?Q?qW71y3TzgdwQl7AhKVSPjJ5FMH7c1gidWIfYzDOxPE9uyEHGDm9OTenBTPX1?=
 =?us-ascii?Q?ni/DY4HCF7o6/+OvoqAp7/hROkZAVeRPtPLRXobejOct2ZexffCMmh6xdyMq?=
 =?us-ascii?Q?iLLkh5/o1cpQ9IJgppJdS4p7ZuMpKuenkgXdk9yhqn1W55Glv0XkwQ8BXZvC?=
 =?us-ascii?Q?zYYLBPmDfoz3yJIaZuNflqUJ?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc22294-5544-42ab-2001-08d9876b634a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:54.7831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgyMAEOXYg89VNqdW1gjyHJuoapT1wj/4s25HatiR6Ynm/P1WL4OsgUo/UlaW7dsmdVf044DazclJ/mqssNc9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for automatically attaching PCS devices when creating
a phylink. To do this, drivers must first register with
phylink_register_pcs. After that, new phylinks will attach the PCS
device specified by the "pcs" property.

At the moment there is no support for specifying the interface used to
talk to the PCS. The MAC driver is expected to know how to talk to the
PCS. This is not a change, but it is perhaps an area for improvement.

I believe this is mostly correct with regard to registering/
unregistering. However I am not too familiar with the guts of Linux's
device subsystem. It is possible (likely, even) that the current system
is insufficient to prevent removing PCS devices which are still in-use.
I would really appreciate any feedback, or suggestions of subsystems to
use as reference. In particular: do I need to manually create device
links? Should I instead add an entry to of_supplier_bindings? Do I need
a call to try_module_get?

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phylink.c | 115 ++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  11 +++-
 2 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6387c40c5592..046fdac3597d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -795,6 +795,42 @@ static int phylink_register_sfp(struct phylink *pl,
 	return ret;
 }
 
+static LIST_HEAD(pcs_devices);
+static DEFINE_MUTEX(pcs_mutex);
+
+/**
+ * phylink_register_pcs() - register a new PCS
+ * @pcs: the PCS to register
+ *
+ * Registers a new PCS which can be automatically attached to a phylink.
+ *
+ * Return: 0 on success, or -errno on error
+ */
+int phylink_register_pcs(struct phylink_pcs *pcs)
+{
+	if (!pcs->dev || !pcs->ops)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&pcs->list);
+	mutex_lock(&pcs_mutex);
+	list_add(&pcs->list, &pcs_devices);
+	mutex_unlock(&pcs_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phylink_register_pcs);
+
+/**
+ * phylink_unregister_pcs() - unregister a PCS
+ * @pcs: a PCS previously registered with phylink_register_pcs()
+ */
+void phylink_unregister_pcs(struct phylink_pcs *pcs)
+{
+	mutex_lock(&pcs_mutex);
+	list_del(&pcs->list);
+	mutex_unlock(&pcs_mutex);
+}
+EXPORT_SYMBOL_GPL(phylink_unregister_pcs);
+
 /**
  * phylink_set_pcs() - set the current PCS for phylink to use
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -808,14 +844,72 @@ static int phylink_register_sfp(struct phylink *pl,
  * callback if a PCS is present (denoting a newer setup) so removing a PCS
  * is not supported, and if a PCS is going to be used, it must be registered
  * by calling phylink_set_pcs() at the latest in the first mac_config() call.
+ *
+ * Context: may sleep.
+ * Return: 0 on success or -errno on failure.
  */
-void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
+int phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 {
+	if (pl->pcs && pl->pcs->dev)
+		device_link_remove(pl->dev, pl->pcs->dev);
+
+	if (pcs->dev) {
+		struct device_link *dl =
+			device_link_add(pl->dev, pcs->dev, 0);
+
+		if (IS_ERR(dl)) {
+			dev_err(pl->dev,
+				"failed to create device link to %s\n",
+				dev_name(pcs->dev));
+			return PTR_ERR(dl);
+		}
+	}
+
 	pl->pcs = pcs;
 	pl->pcs_ops = pcs->ops;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
+static struct phylink_pcs *phylink_find_pcs(struct fwnode_handle *fwnode)
+{
+	struct phylink_pcs *pcs;
+
+	mutex_lock(&pcs_mutex);
+	list_for_each_entry(pcs, &pcs_devices, list) {
+		if (pcs->dev && pcs->dev->fwnode == fwnode) {
+			mutex_unlock(&pcs_mutex);
+			return pcs;
+		}
+	}
+	mutex_unlock(&pcs_mutex);
+
+	return NULL;
+}
+
+static int phylink_attach_pcs(struct phylink *pl, struct fwnode_handle *fwnode)
+{
+	int ret;
+	struct phylink_pcs *pcs;
+	struct fwnode_reference_args ref;
+
+	ret = fwnode_property_get_reference_args(fwnode, "pcs", NULL,
+						 0, 0, &ref);
+	if (ret == -ENOENT)
+		return 0;
+	else if (ret)
+		return ret;
+
+	pcs = phylink_find_pcs(ref.fwnode);
+	if (pcs)
+		ret = phylink_set_pcs(pl, pcs);
+	else
+		ret = -EPROBE_DEFER;
+
+	fwnode_handle_put(ref.fwnode);
+	return ret;
+}
+
 /**
  * phylink_create() - create a phylink instance
  * @config: a pointer to the target &struct phylink_config
@@ -893,12 +987,20 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->cur_link_an_mode = pl->cfg_link_an_mode;
 
 	ret = phylink_register_sfp(pl, fwnode);
-	if (ret < 0) {
-		kfree(pl);
-		return ERR_PTR(ret);
-	}
+	if (ret < 0)
+		goto err_sfp;
+
+	ret = phylink_attach_pcs(pl, fwnode);
+	if (ret)
+		goto err_pcs;
 
 	return pl;
+
+err_pcs:
+	sfp_bus_del_upstream(pl->sfp_bus);
+err_sfp:
+	kfree(pl);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
@@ -913,6 +1015,9 @@ EXPORT_SYMBOL_GPL(phylink_create);
  */
 void phylink_destroy(struct phylink *pl)
 {
+	if (pl->pcs && pl->pcs->dev)
+		device_link_remove(pl->dev, pl->pcs->dev);
+
 	sfp_bus_del_upstream(pl->sfp_bus);
 	if (pl->link_gpio)
 		gpiod_put(pl->link_gpio);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 237291196ce2..d60756b36ad3 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -331,14 +331,20 @@ struct phylink_pcs_ops;
 
 /**
  * struct phylink_pcs - PHYLINK PCS instance
+ * @dev: the device associated with this PCS, or %NULL if the PCS doesn't have
+ *       a device of its own. Typically, @dev should only be %NULL for internal
+ *       PCS devices which do not need to be looked up via phandle.
  * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @list: internal list of PCS devices
  * @poll: poll the PCS for link changes
  *
  * This structure is designed to be embedded within the PCS private data,
  * and will be passed between phylink and the PCS.
  */
 struct phylink_pcs {
+	struct device *dev;
 	const struct phylink_pcs_ops *ops;
+	struct list_head list;
 	bool poll;
 };
 
@@ -433,10 +439,13 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+int phylink_register_pcs(struct phylink_pcs *pcs);
+void phylink_unregister_pcs(struct phylink_pcs *pcs);
+int phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs);
+
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
-void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
-- 
2.25.1

