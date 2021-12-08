Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4174146DE6C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhLHWgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:33 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233209AbhLHWgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPDEseEuqPhVOfFYdqifsuH4k5n3c93QPdhp6QHav67+LpgFsE5cNLKyqR0Lzly4VWjZ1rRTHd4v5125H1VNFJx/5mmn8aC8162eWmwY7YiYU90TfFLr8mDAuKlTUSxJcJsIPwUNYc3L2+hg36i/Bklc23do7znLp/uyHYvjY5NHlpJIEPOe0TQFL4HPnd0vwHSh5vJgQDE94Y1/0bQ/KxfYMkvD6W7nRIWEs/DttTN1KeVirx97w3Hoq2eR2oxnncZaYo5Xiz3sp/e3zDtT7/UdfEyGQ7327VKHmr6MLE1ugIzwnzbbxhxYG6v4fUOpF3w2/iDUdzGuj5OgvFYh/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uL/MdOtMkkNWf/fR1XSPEHkw5F0MO2l8ELzlYqfrnyg=;
 b=Bnxy21M37qjeJBqbBSG0Dhdwc0WadPTnexji9ucvT2Cu5KzfxgiUe/3loIscr4ab2f+/99SozabUq+e0JPnWfjgKhxK2UHKxhBbCgClceIyzSapt+saez9X4J28qwOntqI2ppWSjlTp+MZi/tLADiFs3NYeTyLVe4ykmEyAR12urOS6pdODvLxPVO2Kc7YbySh/CyOAMkpIuFSarGYB/lA3CV4GmcOtulSxRvAyQKV1jqNNM/UHTILsuCKMwJwJqh8B83bT7TSBMPra/wLQb8D0JRqun1eHkr7bb07Lt6kTVCcjSrYTetae7baWCO94H/DGVu7JqxKXJwT2FAWZqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uL/MdOtMkkNWf/fR1XSPEHkw5F0MO2l8ELzlYqfrnyg=;
 b=VFa+qLElZGKSLi983wOpDp3eucRmFRQ6yl+MAyYci+QwUmmMYmdJ9BH7NKm7k5M8Yg2ExX1xsJRtt5OCCUsuUNb1ItIq/o5+YCjrSL66hRVBf0DREYKw2Lp2vH7vgvh57zL4ah+/xEV58rPcWkf9IHNQc2hp8ZtTzEA6juwVU/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 6/7] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Thu,  9 Dec 2021 00:32:29 +0200
Message-Id: <20211208223230.3324822-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12642327-0343-4cf2-841a-08d9ba9aaad3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408108B72157282803E0595E06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: COaPtjU86ykIRXUIBbPnWOcnxCNyGAKuOBhVO6zyq6eqMM80LdmH4H/bya1JwinVB6g/QNwzALAtMsWiXUSmUjdVdzZM7RB7Y6f2qY55e588AP1h6w5DT8RqOGrXPO0tL+uVrhj/rKhMvQgyXEneLvsW/++jwSwgPajLz1l/yNTsx5/Arq59RQ5QlcBIngo2B2gXN9OdGWV1MRchrIrVq39Jbwqbv3GT3JAq/7l56eph+mEZ9ubYDzQLq/pgbEh/Hj++L+BEQ0l0sSV5hTNjcjFDt5ZnZ/h22Zc9nqcRhsLgADyXmS5AA3w43RCfhoXjxbbUL2/FqmbN4rFN0HKxhOv41MTE5pW/3vUObF04lK4XKVRYWIQKkbrZVvBltU5O9T0dD11p4DBxoIcfuCJRH987WrencLKA0dggGCXynBTjtDAEn/5AB2iSZ3aItbV+omXlPbikiiaioHxtnCdf4Tl5pTKRYZHqZ6cRk8UxOd9OWUMt+uaDctHSFEJlzivrQ2fKGyAEQ9VvlM29HU3jYUSS66GGtAs+14xhKvnhhTm9VtQcWREQGiPyYW2TbSgMv+YxjFIneaJ/0PQs6y0f8BU8gVagRb6S8FZV9dcoKxLecGg+dBm7eNmphrF5UuGOZsyA2HifMJ8T21YPSVRNA6lP2MrUl/ITBBjxVhErfnqM7YrBqbNfNmyaqNsYLd3lMeNf3gWB4tSzs36QQqMWIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LsQjrzxhpLc+ahmMOOWHtedNLWOMs/Je88yAMsNV9Kl2+XS+eySB937nflQ?=
 =?us-ascii?Q?ur1sOu1vyjNGmYeNRLuZWTO4LDee8nIfklg+MN2Ko6vmUMfrha7wJKKarHDD?=
 =?us-ascii?Q?Big8qlPaVtzMNXQugufXe7zFSTE9WqmxYEselNTjMh9kuTUJHpTMcg//aqY8?=
 =?us-ascii?Q?c2rtUI9etYusIOrbsAAHUszoYlZnNTDz3pocEE004O85U33Un4moblRWFIGa?=
 =?us-ascii?Q?zFNTZckyxQD2EJU6pk5j9vVH6PkgZgCgxZWdoX5uMy+nzrt8+gj+jRh1eJNw?=
 =?us-ascii?Q?Dx3he/ht1GIegxlulfCZpdzHgt/TAGFNdngjXqzsRwXHyxnEzlazPIODP2gr?=
 =?us-ascii?Q?+xHbRZtHCaaD+okjA5D8KbVx0glqyUyAyWytv1IquLTZUv8oGQTTnX99lI4x?=
 =?us-ascii?Q?k9+63CglHxvzzHNKaqCQn6IY5xbU3bUDxRH3JfTOcgOPdZnLL1ImVHnNVKzw?=
 =?us-ascii?Q?+P++Qzyo2QVIH58McaI1fVTvYaiv3rdIfZuumJ27WTOgKZAt84KqneVIkiEd?=
 =?us-ascii?Q?6EKigA62qC+aiFQNtxq4lderoM8UJlA0vbB4XMfFCQ+Gd7c2VVULrEf2Kes4?=
 =?us-ascii?Q?A+XP8oS6r3kjT8ohZl8+bVJJ3QcwVG9Jv8SEQR0PMP4RJ6nX0FWU6zAJ4xHG?=
 =?us-ascii?Q?4FZFBcnUnP8zSfJxwoK5Xta7lbEy8m2tE2/EUIoRT61A7TodB33hRTi3dAm/?=
 =?us-ascii?Q?A1UZBDTnaGIp6Go8akBM6wfaZDwwQwEvgGqqYUPjWvy1sxHrAjImS7e+cWUb?=
 =?us-ascii?Q?cLZivVWVd1us3J+OCRKq6vWLobPIsE8hvLSok9N1Rq4tQztZBBVYtRC2hf7/?=
 =?us-ascii?Q?R0ri3e5H+btiJ5CT6uSkV0rbgiuGqaYNMMuaw6GIarJwXXOD4z91SzSxs4GU?=
 =?us-ascii?Q?o1urPk/sQJHR/DBX9C6h5FAOP2a4cF03zFLxvU9KyvwR8yGhOEErQ5auXYZI?=
 =?us-ascii?Q?0EwMjX3CbRtL+faw8HEEWY6yx0EsRcb3P6OScELDX6f9BFqgQbtUO5wtmNUm?=
 =?us-ascii?Q?kXzh4DxqAeGjjTNSp1pZpXlY3z4Xe2dlO0LkIlk7ztppBME+LALjAiL33rsj?=
 =?us-ascii?Q?oI68BxR1lXfxvr81cF0wV05PQpN5jDMD9vlXQq3TBucz1QL+k/zonVbA4gIl?=
 =?us-ascii?Q?489QbRQf4J+SF/3td1aubUIiimzux3KHS1qVm7x7TruBADUFFXdzs96W3Dh5?=
 =?us-ascii?Q?QmLjaXvIsuYgKoVvuD/iRKx2lDCV9RzJEXPSCrFvU7uglhkNcMkaYnUrZHwM?=
 =?us-ascii?Q?eJLrujPHWX4GcJbzjq1Ww5uVa1gio+LcYBivfGiDux/ZwavMsFRKJ1Oy19Uq?=
 =?us-ascii?Q?EgWA4jBO52FlxgCr1o1p8Wle7Bi5gFnVQhKp/vuu+AdvZjzV6diMXWxlV5hN?=
 =?us-ascii?Q?RJHi4ER+zt364oWE5r+KY1Ic62NURsTFjcYCy/39QX6Z6tKbTrLAlDO6viSA?=
 =?us-ascii?Q?fJAWaTib5OUGLucJtpygaqbpLg2V9UJ4aTKOj+uZir4PqEoyPnwqe1XM/fYL?=
 =?us-ascii?Q?kpIKsVondTtM1NWJ4QrCyAChIbtf+q/oHwP0gq5ELb0qxXiAA6zJ62F/cmka?=
 =?us-ascii?Q?feIiufd2cJK9XFt/fk8zAxQzDFCvXiDsFqy+NECQ1SciNpKk5rWoSXlBqAmM?=
 =?us-ascii?Q?fP+dCKb9nnS3prXG+B7JJFU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12642327-0343-4cf2-841a-08d9ba9aaad3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:50.4916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+K+C68B9J38vclg+w9K8oCerYespJV1gHeb3pvD1eARbHKO3xm2XksDPGu7eh6oCbia1qH5gbRbX+oKXnjYNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_up and ->master_going_down calls
are made in exactly this order. To avoid races, we need to block the
reception of NETDEV_UP/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index fe3a3d05ee24..dc104023d351 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1015,6 +1015,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1023,6 +1025,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1030,9 +1034,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.25.1

