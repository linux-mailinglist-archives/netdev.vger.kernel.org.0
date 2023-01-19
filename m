Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20496673866
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjASM2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjASM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:57 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6DE78A9E;
        Thu, 19 Jan 2023 04:27:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaqQolBh8AArE7tEzPD2bUy2maxN+U4/PNftbLZMFiKZMf9+IXmRx9HCP9BaraL4agYJFsLovQDuotm9rYnov17fk6hntxLdhTKl0g8UykzQe2bP4OCZM432BmqESKa53nJQf0uZ4cljI6WfzkqmYoMQmVdSkmk+Am1MK2XXtuE8gLh3XsuhkHTeA2rvfZKyOb06KFDzQnpaT4IaY3dyHOTL51fAINbs83DtlZmb+NOXDSuVLdkLeCqoomSLxj0YNrk7ScZaWpykX1JXDUhd3sqonME5GII7RfrmaKBb2J2svdi8Fehhk4bedG1h2F8qwSdVzYtbU9dcLqEIJWSXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8VZ1bzQJWNxKiTHPMyICcY5kpOd9iIjikDdZvWhfQ2A=;
 b=Q5W0O8dBQ04yAYnDLBEXT2TnE6pZlT9tljuLFubeYPY+CkYf/xWmXSaAUkKJlyXWIfZ0CfQBLPsww+IhovT/2ps1jWKD1/n9oWM6KcTSs23xAF3VkcVNYCaoP4jDDzIBnMAsXy/os4Co8ro+40KomoVksZZqmwseEGMrxnHPBnfr9ljeWY5xfYSA857z38Ytubml0P9cIHqL4OveUDa5BBnY9UpJUM/7CRm6eayysoRFsPRj2oecIY+WGm4Yw1qSXmK9aQ/CtVWdgpmT/mit/i9T4ECWge4EiHjk7RhDSjLJhi72ghbUxrxSfc/TxzidGG1cO0FJSAMq3HqgByobAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VZ1bzQJWNxKiTHPMyICcY5kpOd9iIjikDdZvWhfQ2A=;
 b=s9ijbTuX2BK3H2GehcVwTmxQD6echZYISAEkMW/BPw8vuWArhVD6FK33i+e+IhKR8cnZzhiBcCbYs1bqr6zz61Ogw8yCrDSJjIfkY0RuZutaxfqKqY1k8vERkSfy76/A4KS6dsVm2W91U52UMkwXoKsLGLZfZ1jzD2gFX2m+ywA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 01/12] net: ethtool: netlink: introduce ethnl_update_bool()
Date:   Thu, 19 Jan 2023 14:26:53 +0200
Message-Id: <20230119122705.73054-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: 01459fc2-d1ed-486b-b30f-08dafa188e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C064C50L98v1VwG0X8gzLtSO3p6dID5CD/6b+bbIoStsIlDtQbc7BiHjp1rXilhJdWPC4BSFXWO9Y/c7Yn9QkxcUEVSEO/MHalLmbRuGs8sWuU0WdibamVz9TokgeIUcn+DrN3GfXSzzrJyR0c05yfD7I0zFhJPx9vGY6GM1BFX13uppsqNBYzw1VdxE2ZzaQiVRc8GEE7gu54OMh2Ni6lEEzBW/3IWH9DsIP9bzdWlQAd6522K8YY5nRv7GmbAAVg/77QQ8kqTIYEw3qBT3ohPAeR6a3EDDaMmYmgdLWSJNjPYxhpy+7+uUYQYTxbiE4qOdj/PBqDy8LOt9/k2ENONyZbgBNnXowiF/4gZu4XSsVxARuR76KQ8AMJNj9qaIj9DytdFsNuYBSQRS1h7S4C6tu7vM9GPMDQ4QuLbFlNQGDHMVUgjSE4tu+LqhZNfWXkJJmD4qrp9WW/wmYcUDvtA5XV/RiTGrnvZi6Jodx++uAy9S0eqnDLygmztgJ0dI0m43IAxJy/ecwpvgyHzKpQcqy+FTI4sjbvsb+i8AFdl04m+a/lAC17hkeKYYxjqS8ejbWRtT8Et3xqDi9oXndMUyfE+mQ2JC1FWRbQK4V0NC6Rxot5qnfrjBfunzEfOR03IqF1D5P7qhapzhh8xSziL5pSKcJrWq12lwV/tz6F4mHYJPMGlCQow30EXWueqoNxoS+GYzu8Pbgk7Aq+0vRVke01MQ/mm3RxsYs1TF1lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t1O+m+canfJghtQVAeLHujY8/CCupuaf4TLLRz/yykjf/SNgbUxxdB6MQL5U?=
 =?us-ascii?Q?OyEgNKZIzyZYIWCiyhC4+7npFDJxzBuCDZQw4OiR5NPkOJPankiIZBTu/upG?=
 =?us-ascii?Q?9A2I6ndi5NfSei99nOlGllR9ndSq9z8p1vQTMrJC2d4lpEiyoAwJ4fcgd4ko?=
 =?us-ascii?Q?yhDpq4uXZrzYpM54r089wJIqYgd1Al8rqSqd0VjAOhuVJ3DpP0bgYmtbMBZy?=
 =?us-ascii?Q?pvZF543r/3AFKNVuPvj4k6CDLPBUKhmvJFST3TGrC1GE/Kko5O3JejRZct5U?=
 =?us-ascii?Q?av8lQkuTSPEh3wRlAftHLrdveBRSY5cnVq7j99ZXat7TLYa7AcxJOrT+acQU?=
 =?us-ascii?Q?Su9DNtZ/pR7/6aYhxRhBw1hV8EOk8alzCf/smjrAsH6NrJFZqLbo+6fNzRkC?=
 =?us-ascii?Q?hIEswCO0bgJHvTpeSxSt3+FIVvM5LxxSfuZiyRs/v9V32IGxEaR9R3dxQbzn?=
 =?us-ascii?Q?sih1lPuTwpJJyzhjvWm1YmTC0uRNbRs67c1xaA7VOu1QT9v5vgYpWgw8zVFt?=
 =?us-ascii?Q?ZiG380T2wz6PsmGQYd71fIAb3HaMFSiJyNu9r0f/5kH4KGFTfodAcj9V8E79?=
 =?us-ascii?Q?n8cD5ALWsnFTVqn2YLwbMqN6w9jXn2BtHoIJ/LpiD2X2HRIAdiEIN53mGMw+?=
 =?us-ascii?Q?96V5decqXQxorDhvG9XpdH231Qsjec3ZYXXvOk7hXMiFIHRUlPL8MCpkZFe+?=
 =?us-ascii?Q?tsPEPpHfKACFjOzU+FtAxIGTASNMxiBO5GQZ88m62GbOiQNfhSmhkHTEUqiV?=
 =?us-ascii?Q?eUrdU5UiD2UvslqviNB7AcWeE4V6hF0t8Oa35MY9GHObdzi043VU0gTuXzHh?=
 =?us-ascii?Q?/7hAj+d359uu5gfJT2iSBZPGkzBP0yND1UEi4zaWF2DTtQA3NafETctW8fP2?=
 =?us-ascii?Q?j96kdl7AjnJQJmZvktnJ5idK3xxPaw9koFoRRs7lKWbzLX/l9SW6OOj3Sj1Y?=
 =?us-ascii?Q?79lpkdDYfdIY/7hoVcsVZjc6uB69O0JBxjkv0HCg5MxtsF6VgNJq8YUJgL5l?=
 =?us-ascii?Q?mUi7XwjTHc8MTm15LalbocCFaoAU/nUlC/6WkTDAEIzp0pK3zOhtTrIqp8RD?=
 =?us-ascii?Q?bq1PCXF++Mg+a5f2AVXDOo3MFh3PAoofmK8s202QS5N9zVbIUv5k+Wz8yaHR?=
 =?us-ascii?Q?Y7DnoU5ytIUcQVuoYeBoGrFTM/FkSjqGRaTzO8iITPFwHLcWOEj5LKOV7eo1?=
 =?us-ascii?Q?4catXYxVXDFFQqhwtiotNSxQmkpdmC73h3osH6jbtHQg/mquccKuTxtQSJr6?=
 =?us-ascii?Q?SyiDvaNrOfuxAYz8rX3HFFO6tVjJeLL097ZXU4D4tGAruOQzsgnF7aiVT8+V?=
 =?us-ascii?Q?d3zuEqBgxoCxdox9NCkSRJCsDuiyelOezTpXIrZcYoAXHPA1/0oUGuSYGc7g?=
 =?us-ascii?Q?A/k1Rp6LOMeDdOJ6UUklSZ0OTUiE4KTKNBiWnySFBhKvFbrYYzuRpVlkom0V?=
 =?us-ascii?Q?RYA1UvXaAh8aTdXjWHuddwiB5p7dNUJ3Yob8MXZg2fpT/n8A5NjTN16Z4+PN?=
 =?us-ascii?Q?zAuauUmxJzs5pHVtT2YGuSQN9LxXOKe2Stwoeut9wd+p1xuAT8EKC9JQHDtE?=
 =?us-ascii?Q?pu1u1rzTOHIvvOMWNFeSG3mP+db1dCSXvCofOAhDlNkLoLIAhqsJdtYh0Stg?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01459fc2-d1ed-486b-b30f-08dafa188e20
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:40.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: necYRrzVgHbALeF4mNyxezOKvBtIGf/Whs0+FEPH9W+6iF+cqLI2ul0YL+AoWztDpEp6KGQYNXIM4iHPhOTFxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the fact that the kernel-side data structures have been carried
over from the ioctl-based ethtool, we are now in the situation where we
have an ethnl_update_bool32() function, but the plain function that
operates on a boolean value kept in an actual u8 netlink attribute
doesn't exist.

With new ethtool features that are exposed solely over netlink, the
kernel data structures will use the "bool" type, so we will need this
kind of helper. Introduce it now; it's needed for things like
verify-disabled for the MAC merge configuration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: rewrite commit message

 net/ethtool/netlink.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f271266f6e28..f675f62fe181 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -111,6 +111,32 @@ static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
 	*mod = true;
 }
 
+/**
+ * ethnl_update_bool() - update bool from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variable
+ * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @attr is
+ * null. Bool pointed to by @mod is set to true if this function changed the
+ * logical value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
+				     bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = !!nla_get_u8(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
 /**
  * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
  * @dst:  value to update
-- 
2.34.1

