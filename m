Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4004C59881A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbiHRPum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344051AbiHRPth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:37 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FA65A829
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5LpgE3Hq/ekgenfbtacVqjog4/ofH/Rf+nEjNChz8bC23b7tNg76kqVLWCpd+QarEnu1GH3vQe1gXJNPO5fRFC75mJmCuMnVPU6Pz+tX9NM2T8t7vdH7lji1D5FUaN8pFdGN+p8jBE7Ezk7ryrzE+crviRz1IYk7tUYpuCFy/jcf5l8tznmEw+nIxgn1P9aX6HdKfx09C8a9zLtM/P1r1O3CNcBjdO1ev0qI0SxxFrnu7QtlEHx/HYc8ziBqdrOXWjScHK7XSEoTZDkWWY0tysm6kGiPBFZw+gXQKWaynD1cPFVmGGgiHnH2ctflkSS4zgKOmpqGDurn6DG5XyxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMTqYlAn91fcGSBKU8rqJMsHvP8D31s+4om3Sfkn31s=;
 b=WqYxcUFAeiVZ32C+RodH0qCOkgsPqlHH/Pk8qLdnzVP05cQVzaAIS6D4HFHEBs8f617PNYJ3sGffWK3S/1x6L1w2Uae998MMwoA1RUIJrGjbcNTsEEt1hCakxa7AK7f+ZydF0uyaojJLyrUDN+X63tdLj3Yp8N67HPRfFXikrHyNhcGn5uOK5AxvWy9sJuFgGys2xYYGfgGZL4+tK3c0skMnonnm7weAbI0+SLTuVV+Xv/UoirjZCxkdIPjwr8uS6UI1Y4vbME4ZXSbTSb8JYwaSISODpFYD2mUvf8srJo1EW1DCf1i66qR66ElEDa99Vpc4A/QhqLdGx/4L4yIUnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMTqYlAn91fcGSBKU8rqJMsHvP8D31s+4om3Sfkn31s=;
 b=PEN4m5ml8NZFEIy+dWJ0bZXlzeEALQ0+SuW1O1UhHN4d94Oyjj/wYvxqYujow3qNymxb4qQ+zgwWbTD/CqS3Z8T8hXqKaT2vlS7lmqaD1euQDGeL4Uug8SRjQ9sRJ3PdabUJmK9n1qxrCIQMGME/5XZXfPHniAlEQIAos6/y1Rw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5648.eurprd04.prod.outlook.com (2603:10a6:803:e5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:49:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 03/10] net: dsa: introduce and use robust form of dsa_broadcast()
Date:   Thu, 18 Aug 2022 18:49:04 +0300
Message-Id: <20220818154911.2973417-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3478c426-4d06-4c64-0d63-08da81313cd0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5648:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSd20UFGuiOH32WF2aZUEmqeFbQ8jG4U5RuZW/jsV5Jh1aRYPi4v38MU08mEHE6zZjBmUKhX0LQyLJEXMJqtqxbaz35gnZf0ZvEohxio1gpjZFuONj3b/eeKlY8ymsvP2jlw9uaoyWnupV/eCmBTTCaiHUCm3U1khmiqKIJWYCwD/XQmrDSWwsdaKgDBf93Abl+7qz1a4r/9vH6jz5bvjCnApZvXfgINzeYFswMapjVWAVP4cMDC3iO+I8O+5yjFkEyMlKEGMs2JpCHcrf78n1eY0vSG/2LCQo6M1WEFiNYUoqGfxUku2oal8yUUA9ChPxcvTMEgLNb32jOFqPu+4PKHaRHT10lZUKFnKnFfUYRYQH+1OBsGI4f680ccIP+JuDOF+795euBWXi0oBb/Yt79UQzqF46TYLj3HuMd+W14kEpRHPaQVC4GxMFKVDD4pFB7KINt8z5eL1ph1sOb3joCcf+mAZixGwS9V41P+R6eU77ss3mB3X9rj8mBCmtYLw9z3rZ864f8UjZD7tqC5oiEPSvwavC8z6Nmo1SZvgsKqu01G2R6EQjmAiGrhn99OTBbJ1MDZym6YNqNyYXFwQMcPDs3nG4OIuNr0WXJ2BL4wHfZoEKoIxuulU2aEgH7If8I9Yz+bqsjRIOFaTgiIDf0HkFyhBhkxx+5yj+UqNupu5Vh49pidRHeDPyWemmw3BadzCQOHHNhK9RU2G33iadXQ/5N/+Ai4PGr1Yi1KubHfuRii0Q+g7CWlnpdNrcrru/jGj5MBQNZUfbg2PI+N7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6486002)(478600001)(38100700002)(38350700002)(83380400001)(6666004)(186003)(2616005)(1076003)(7416002)(5660300002)(44832011)(36756003)(6506007)(52116002)(2906002)(86362001)(41300700001)(6916009)(66476007)(4326008)(66556008)(66946007)(8676002)(316002)(8936002)(54906003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eE3PXjDtID5ov3zBG1uV18UsHQBBHxEnE88JFQ4fKSMTnYrUYN7q/ohUiXV7?=
 =?us-ascii?Q?2u2j1URRV52n+cvk4S/+JgcVAvddVJfT4EEDeNI18BlTqNyhuxarCXB9kM+T?=
 =?us-ascii?Q?crCjhbHOYjLahUp7aYeILzcw6cPEwRIuQZlFQSdXJCBCCWZCWiuCtpveDWr7?=
 =?us-ascii?Q?XVHRwAuDHqyRJhNwN3Ee2zN2jpsdaLeeZhfu7f4Mu26GjHzo+3IbE+gYn+hQ?=
 =?us-ascii?Q?ubLvO5P5XHv/H5V2PtEVucCJdNOb3+7PWIe2+JmqqmxDA8CR61cXZbIW3m7R?=
 =?us-ascii?Q?kwa7Lxu0TUOwXgJGF3M8Z8yFH3OoUhjwcgMDCyHhAuNZV5te/HiDaMfKyCR2?=
 =?us-ascii?Q?amOTGLbMSRsPyJBc97tjg31MlNSDcg2UAiK2fup0/Nd+92Iq9960eTDMHSWU?=
 =?us-ascii?Q?Ppk4YZwgSUzjNvJJO0hma7nnCOdqxzMAMomlpxm2wbf8/cMgHVZ421LFVjSj?=
 =?us-ascii?Q?wXiWEJl1b3qyoCaREfLBsIk2qFBhMM/amihtbJk0cErsGipTm964yZsBplRT?=
 =?us-ascii?Q?OcQN4XxwBNKI8BY3FhKqK9CPOYR/M2IHjVGTDrB3LEjDpuFJGo7zx5Kym839?=
 =?us-ascii?Q?nTdzPns+sY5MlNySuCEF4mCjunpI9zaEesG5oltA1+/G3TOt9GpwF8fSMxUt?=
 =?us-ascii?Q?qthWChMprMTS0GmRulgxAha0Nw+09+UN12Ea58JNX1xsS3SgRTZO6tmfUvXk?=
 =?us-ascii?Q?7Rd94CwK7z4rCV/H67M44YiS3pAV5ax6qoCaN1+izXnWS2NuOjnxPTK4bRNW?=
 =?us-ascii?Q?9UCYjqtV2/tc38uRafreERSOUlE6LFm262GbvC97Jc9g3fGwLLy+BdD0mPqZ?=
 =?us-ascii?Q?w22f++QznS6M7vDJnnBsSxo8cWjF+Z0+R7R6Kl+5bWqoFTEpQUgLD5b9+Hn2?=
 =?us-ascii?Q?gXwBAXINvJmXWzH/GsS9Et6pyHmTk1NyEVCqDMvbwI6z4XqKjEO7CfoF7tg6?=
 =?us-ascii?Q?1UCdytheMUz40MeYL4gizIvI3pjoNk4+5+fmeL8vrNpF2u9PCUT0dq29kxY+?=
 =?us-ascii?Q?hEW8okoaI4dXxl22MrwNGFLjqq5ZIHiwDnoi0z6noH5wm0rFNYJm12tAsvoL?=
 =?us-ascii?Q?vZi1Z4qpwISQm+DqdIcilNppbkTQn2WxniRjCegwHBZElwlXpflBJDN0JTM5?=
 =?us-ascii?Q?tE1aDwYNdzho/hch7vUWiaNkbAZjfNzgM98WQDP95wg0tAihK4mME679SWDM?=
 =?us-ascii?Q?SsehxIa8eGSni2IuLuCIZyPHZhZYn2C3I5Axnd4IbfB2NhqFGYcVhYSC1b+w?=
 =?us-ascii?Q?hHNNgHwNcKMzkaL/CXaMtC9degNAl9VUrql77Z4FcWTg7JhqxqAV6/Fq4JwO?=
 =?us-ascii?Q?XCNDnVXEOgNbYYyYu4chyNWAlSugbduywWQ7SeQJXTioQQ1kU/lWykptrKT1?=
 =?us-ascii?Q?czUiHUwGOSUubnypBBelmIt3zhxjydGscHmgifObMOClNqtTu+urwgm65C2k?=
 =?us-ascii?Q?HlZZ8qPDxyTZMogSECqmpvpFgCiTPlt2YOjx0nfGi3zq0MLSY3dqfGW0U+Rl?=
 =?us-ascii?Q?RJGVBR03N5LR5fLZbHrHZxVlVomi0d87ZKlSb9o/IAQljv2oCaMJtc280h10?=
 =?us-ascii?Q?ZNupnbE6re7fsQNCSAx3DZsh1CHmoQwzwPFQu8hqLUw+KUk/buEfDUqv1nFS?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3478c426-4d06-4c64-0d63-08da81313cd0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:30.1244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESCO4FvjrIsB9CXijdYjrb6Qk3/xa+Brm7uPufBYpwK+ptbEBRBjwivbp80UWEPynAQo5gPcyk+ZHN8l9G/M2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce dsa_broadcast_robust(), which uses dsa_tree_notify_robust(),
and convert the bridge join and tag_8021q VLAN add procedures to use
this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c      | 31 +++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h  |  2 ++
 net/dsa/port.c      |  6 ++++--
 net/dsa/tag_8021q.c |  8 ++++----
 4 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 50b87419342f..40134ed97980 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -94,6 +94,37 @@ int dsa_broadcast(unsigned long e, void *v)
 	return err;
 }
 
+/**
+ * dsa_broadcast_robust - Notify all DSA trees in the system, with rollback.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ * @e_rollback: event, must be of type DSA_NOTIFIER_*
+ * @v_rollback: event-specific value.
+ *
+ * Like dsa_broadcast(), except makes sure that switches are restored to the
+ * previous state in case the notifier call chain fails mid way.
+ */
+int dsa_broadcast_robust(unsigned long e, void *v, unsigned long e_rollback,
+			 void *v_rollback)
+{
+	struct dsa_switch_tree *dst;
+	int err = 0;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		err = dsa_tree_notify_robust(dst, e, v, e_rollback, v_rollback);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(dst, &dsa_tree_list, list)
+		dsa_tree_notify(dst, e_rollback, v_rollback);
+
+	return err;
+}
+
 /**
  * dsa_lag_map() - Map LAG structure to a linear LAG array
  * @dst: Tree in which to record the mapping.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9db660aeee93..b4545b9ebb64 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -546,6 +546,8 @@ int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_tree_notify_robust(struct dsa_switch_tree *dst, unsigned long e,
 			   void *v, unsigned long e_rollback, void *v_rollback);
 int dsa_broadcast(unsigned long e, void *v);
+int dsa_broadcast_robust(unsigned long e, void *v, unsigned long e_rollback,
+			 void *v_rollback);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2dd76eb1621c..6aa6402d3ed9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -480,7 +480,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	brport_dev = dsa_port_to_bridge_port(dp);
 
 	info.bridge = *dp->bridge;
-	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
+	err = dsa_broadcast_robust(DSA_NOTIFIER_BRIDGE_JOIN, &info,
+				   DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		goto out_rollback;
 
@@ -1738,7 +1739,8 @@ int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
 	};
 
 	if (broadcast)
-		return dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
+		return dsa_broadcast_robust(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info,
+					    DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
 }
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 01a427800797..d20b9590a2e5 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -205,10 +205,10 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 	struct dsa_port *dp;
 	int err;
 
-	/* Since we use dsa_broadcast(), there might be other switches in other
-	 * trees which don't support tag_8021q, so don't return an error.
-	 * Or they might even support tag_8021q but have not registered yet to
-	 * use it (maybe they use another tagger currently).
+	/* Since we use dsa_broadcast_robust(), there might be other switches
+	 * in other trees which don't support tag_8021q, so don't return an
+	 * error. Or they might even support tag_8021q but have not registered
+	 * yet to use it (maybe they use another tagger currently).
 	 */
 	if (!ds->ops->tag_8021q_vlan_add || !ds->tag_8021q_ctx)
 		return 0;
-- 
2.34.1

