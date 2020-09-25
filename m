Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA2F27947C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgIYXEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:04:47 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:28545
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIYXEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+R24nCPifV0/KyHL9Uw1wDzYQlZPjAt1lOzWL0/W830a6OdiW6sQ/te1I7BW0QprOxOnoTiyjJU07qRXagrOpBCvqC/flMK8HHBGiiqvrTPNtR2G/Zzv39Pag/zCCTmx38bxVsgLG+24jsyZ7ZmbvalfVIQjm3WIKUJhkNb/9xTWnG/Qy67DZSM289s6qik/AkXMlfIuXkkPmze//e4FFYrdHAVw6itIR4vOgRE/yfHL0wmo1IJyiffkOJ9VBH0GQd45fp6o+DxW+dqyhKydpXIxhGSSiKqtI1XjkKFk0xuFcR+d/8wZ5N2/g4OueZnSaZNVTS5feRGvBkwsE64gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cU5mvOsDUh3Gj8Zcj2DfbcjfgBlNp/K94elCFWI8/o0=;
 b=R+Jn9i+rtCDi6zQ2IOiK8jaVy+X2SzANGrfBwFEgs02QVT4xJQYC/jxAN2gCOOcwEzGpPgGbbyi2BjjgMsHMWPizx0Dv/XJhPbjqg9288plAO0pR0dLf7RxyRucZfa2E2I23wSOsKMu2f705RNwdqKVcGTrkPeULpdjHlkkkM2vyGSLmcMKQtRE2E7YQGRD4YTv9eUVsEuVEpq/eZkNEd9BkPPONei0vtLaDvooi0/rB4b+/V+moI6Y0a9V/Ea1wjii18pGccJLlLBIipCc0CnHNRViccm5vcSCTBSJHdTYTOdSjh0dSWrpFJGhDreXBnqF66WTUnJOVvzLhjBO3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cU5mvOsDUh3Gj8Zcj2DfbcjfgBlNp/K94elCFWI8/o0=;
 b=lAdQi5dbLT6vnhH6HZUssD1WLOKsbCTnAdkTU1IFkR984DfYUTwE5KdtB6VIrgmO27lX+tSil9P+7mE196jkZSdIC2fn/N8bEg5LuZnmZSMPHZ48VPlwMNAoUI6lDhCvnqDgYo8O+bgA9sQqx0ECf8MTAXWxGYMY308g7hjtQrg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 23:04:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 23:04:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, cphealy@gmail.com, jiri@nvidia.com
Subject: [PATCH v2 net-next 3/3] net: dsa: sja1105: implement .devlink_info_get
Date:   Sat, 26 Sep 2020 02:04:21 +0300
Message-Id: <20200925230421.711991-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925230421.711991-1-vladimir.oltean@nxp.com>
References: <20200925230421.711991-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0169.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::26) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR06CA0169.eurprd06.prod.outlook.com (2603:10a6:803:c8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 23:04:36 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a385b0ab-37d2-44e3-a3db-08d861a75fab
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39681826A16C08EE2A2296E9E0360@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIj2OHeYAyIFdJ7665+G0ADt0+bGBa6RvF82t4RX5rIGNPTCC0Uz/AZPdFs3CAMYTK4T3B7jGRIhvisUSPeBhUv1sAp8In5Z+TpcL0OcdXMwsFj+xoRfbOlGDO3B/3Dveyet51xf58rXwNu0lBPscwicfZfAE33kPN4BIgwLOJ8t9BVwqIFyr1CTl54wyEBBkj+bwZR2RKye0A8RSJ43q2j7mZc3xNWqDpffQjkreOtBBLlKJ/pETLBzHNDyFL85153S/jihum/7Jl8eK1HGZ49i6IIuQTcDTnYyF4IS7JEBUR8O9MObj0uYG0pzaljqR3GgweXQNWAtPYLYJdx866SaZVqLO7q84Iqs/Ea3PTCvOo+LGmWNYkzpTziZ12BRyhM1+jB+v6WVzx/JucD4xgLbW0QGxZGEKjxv217skMR7YgiYLJg0zQq5HmZEY21KLWR9Slz5r1FR/nemPMwktw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(478600001)(5660300002)(86362001)(66946007)(69590400008)(1076003)(316002)(6506007)(52116002)(16526019)(6512007)(36756003)(66476007)(66556008)(2906002)(44832011)(6666004)(8936002)(8676002)(26005)(4326008)(2616005)(956004)(6486002)(186003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FbUVB6cL5AA9HnrmM97yaOqQZmgqsIwXIXjxoc67XYm40kRL5QUfiY6sH5+UFvbRAZrtG2iAT4GoYU5dhMmp5JBJvo7FjvWqFmE37nsXOky1CAVcNxcMwYGuvDuqhJPOeLWPoS6dlUIM//qCPT+dOPFS5sLqbiOQe20hkTfzFRXyQEFx043NMW1oaPsI1AHv1OZzGHSpd+Z5astCq9X4hkSRnNaTmAX3dSDVHRIc3VFqUZu4MtI4oKhkj/4GGDaC/NHDXyD2qiG9nCglKOXqXQnJMq8vZ0IU3N1B3v9xF5UDEjAqPVbBVtO14H8HYwsAmGpH4MLA61zm6pWEDfuhA2OutWjnblDSz32RrqK82Ml3q8BpnoSFyGEWU50bkPQl38QVz+XWvXe5DmtErhzFZKyw9c+bhicdGKnbgndwY8hlXNsqjBhNVlSZj9QWspzSqx0XTkkFoxc3jBTXIFDBVZ/X/4yAtDUhrj2tgGZ4S6URvmG+02vKRKAd2KEBmBGVnTOy51ZaNewIKRrwlWfxbcNBnGZ3Fogw5KBCBSFuLWV3/7AxKkUPaPnARUR3TdVKYqcaJ77h0oYDx5p/hed8Ili1betIGmX4c+6CEnlbGG6YrkflbBCgcNCV6GnFWXwMPLxpu+BvekqEdEdLNGi6mw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a385b0ab-37d2-44e3-a3db-08d861a75fab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 23:04:37.0968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujWe7AsP8cxcJffthh66V00HZ2zZAf7bRLLmPC6n2UViPZQ0uSoxWhXPfmySGPYyQRTtJR/t2j0gsUbrmQwYRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the driver name and ASIC ID so that generic user space
application are able to know they're looking at sja1105 devlink regions
when pretty-printing them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h         |  3 +++
 drivers/net/dsa/sja1105/sja1105_devlink.c | 17 +++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 4af70f619d8e..d582308c2401 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -255,6 +255,9 @@ int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
 			      struct devlink_param_gset_ctx *ctx);
 int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
 			      struct devlink_param_gset_ctx *ctx);
+int sja1105_devlink_info_get(struct dsa_switch *ds,
+			     struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack);
 
 /* From sja1105_spi.c */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 07ae6913d188..b4bf1b10e66c 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -214,6 +214,23 @@ static void sja1105_teardown_devlink_params(struct dsa_switch *ds)
 				      ARRAY_SIZE(sja1105_devlink_params));
 }
 
+int sja1105_devlink_info_get(struct dsa_switch *ds,
+			     struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	rc = devlink_info_driver_name_put(req, "sja1105");
+	if (rc)
+		return rc;
+
+	rc = devlink_info_version_fixed_put(req,
+					    DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
+					    priv->info->name);
+	return rc;
+}
+
 int sja1105_devlink_setup(struct dsa_switch *ds)
 {
 	int rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index de4773e99549..547487c535df 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3316,6 +3316,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 	.devlink_param_get	= sja1105_devlink_param_get,
 	.devlink_param_set	= sja1105_devlink_param_set,
+	.devlink_info_get	= sja1105_devlink_info_get,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
-- 
2.25.1

