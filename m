Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4796B29DB4C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389272AbgJ1Xs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:48:59 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:53220
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgJ1Xsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:48:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVNzg9BqOVEW50k0MoMOObyjFaTjHZksy+Wwc17+D1J2/8eLme7XCkVH1uT848s6rsHQLMGLk2is66UHk/Gr4XBc8CfVv7D/7LEAg1UVbU034eGl5re7vO9bj0RvZD8NoU0NOQNCrENS9XJOXaXB8PJyMYzWKgI559Q9+V3e+Xco5td84Z+CJLBEL2sp7WKi6MXkTln8WL5HhUxBWUVjTQLoDhuHK/wmpTTPQsoRFhZZjY91V4up2qy7EN/EIbIkt37Uq2ABGLgxYCksK1j6sh1pfs8A6QNhF8OlynU7C/QDhHHyX6G0KIckuaU5yDy8TitJSk6DVuv/Z+6/ENXSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq9gweTp7WIVGQXVtTj5MBcqZ9A9FPIrRwsOGnrPKZY=;
 b=RrzWGNnYlrEtU9nVYbH+oFdArScN7l93ft6dtTk8ZtBIUJ/24Pyl+SMNjS5XTL+NgLPR/CbKiVTqI3KuyOnTs35eTHdZVqEgXwuhnw4WXd2AFQNjRcjJ4kLmsbjF8mDf8/HlD9XEGTVD5gUYOMcdDcV2e5qWvJ9/BZliGL6r3q+W2sIs8GiUXS+WvZNz4Jl54hhQ//ZOl4V24mkhE7T30t8FBxAB55rqLSNLTlIE+kBkvgI/VMBVckeF63Bwn78RGquvX2oGi9Xj9pJDiuGbPbHs9/2m3iLxQwX2XVGw0eHwQu7auSe1oBN9txFULZfz17ndWH+cfWunxJIkObogtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq9gweTp7WIVGQXVtTj5MBcqZ9A9FPIrRwsOGnrPKZY=;
 b=emmQbmXFtosq8IkVmUd/E8VNZHP3Jfcd7MF4G2hNqSLh/Rr1e3vcePnTlsfEvBK1UoBPEKXtfnSmXVzIk1S6oqJCU8sJsaVAYMkEpUlkv83SDSAwSa4MRvb7/c1F1RC2cFr27phqFb1g8Qi/aeOvmNUxVTXWBizoIodcafElrhk=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Wed, 28 Oct
 2020 23:48:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Wed, 28 Oct 2020
 23:48:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: bridge: explicitly convert between mdb entry state and port group flags
Date:   Thu, 29 Oct 2020 01:48:15 +0200
Message-Id: <20201028234815.613226-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR06CA0152.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::45) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR06CA0152.eurprd06.prod.outlook.com (2603:10a6:803:a0::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 28 Oct 2020 23:48:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0f95ac9-fd03-4322-1e67-08d87b9bf74f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6269DC299370A85405D2CAFBE0170@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oy0M/+raGDgQqN6DlUiL7tNoB8BU+SLByoz3Tjrr9Zu209ir8znqgaZGz2M/HQnV2IwRWtfOUWIEd/LJGNMG5iAJSg91lilO3SatcTqelIMIc/rKGzoVi4HFtdZw1vEBFKmZxLsPvRHUIupG4Ea9REzS8GfUnU4qHnbIskxOMqLO9CMChmizJwHoo7bN+56cxHuGYc794C0aktNw9RhYeMkdic0DjTsJIOlLQdFychTIiwB0C3K0TTZm1H/uOwEvmBJipO2AvX9GqpRl+iS0ElzE3f+7w7XggV/yi1lYmhiapTIGRXTJ4CtmAvj+ahlCBnRUliroNRxuRcU3kMM6O8Aep3GccRkqi4rzJ9pFwtuDCgVX23v0/+RVfy9qJiXy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(36756003)(52116002)(956004)(2616005)(6512007)(1076003)(66946007)(66476007)(6506007)(478600001)(66556008)(44832011)(6486002)(83380400001)(5660300002)(2906002)(16526019)(8936002)(8676002)(86362001)(26005)(110136005)(186003)(6666004)(316002)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bNEqOFzx44zh5F8iJ8bIcmKS4u4v/Pqk0TLJ4F8QzenL1hz2Lk1lKEHZsoKK9Lsht5TwGR06+0behx1vrYo2rU7VBjU1moi1L+8NsGuns9uL2UOnKkUGJD2ihauXqmQFMZxay3IyuiYLSCQ5KspaVFf2n/Dzhd5iAMlSJXWRpTIP06TMUdYE5PnCB0nbDL6JfmRdTaYyYdBJRsDgkEdF2Fawl1WBp3iaBf1Qd2ubAtSZz5Fr3h5RrU2eMRVoyfA1esyOQ99851xHv/LaAclJhfNRGHNkHj3zXNrJxKzoDdUG1gmm+WNXmy5QVPneVi/GhiUJUmjOSNP6mtxU82iGVQOGpvLZ+z8+ZuY+CXt/6MG4vjrWxFAVOubRoZYcW3l0k75osc77TrgUp5O21PlpfioFocC9Qe6coJ5IOWCOOHxEHeMhRdS3Zu4sp3uFBRi72LIRmtKCNLh0VWU+cKSPNp7w4NhEEzvQMfi9aSbG7Q6ijqgCE/5ye/Zmh8sFilrHprHNpYbIB197nzutrqUTTHQuv/q3zsh3ukn8whgHNZKK1Rm6YOfwt1/g3aqKPodh8PCTu2QwYdhOeviB0MePvsGjTYS+WF1jL5pFGZuG1Ib1wi1SpTgoOGWC5TXvAcBmumAXCvUsShqbspKJw7jAWA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f95ac9-fd03-4322-1e67-08d87b9bf74f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 23:48:27.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGagFnhLjTvww+h3G6dxlr7emRoMAkqKaQ9de/wFzieLAuY7ZB7mzZlE7xbuCYcBdzPD/Gz7p66yqRNTyHLipA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a new multicast port group, there is implicit conversion
between the __u8 state member of struct br_mdb_entry and the unsigned
char flags member of struct net_bridge_port_group. This implicit
conversion relies on the fact that MDB_PERMANENT is equal to
MDB_PG_FLAGS_PERMANENT.

Let's be more explicit and convert the state to flags manually.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_mdb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 3c8863418d0b..8846c5bcd075 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -846,6 +846,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	struct net_bridge_port_group __rcu **pp;
 	struct br_ip group, star_group;
 	unsigned long now = jiffies;
+	unsigned char flags = 0;
 	u8 filter_mode;
 	int err;
 
@@ -904,7 +905,10 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	filter_mode = br_multicast_is_star_g(&group) ? MCAST_EXCLUDE :
 						       MCAST_INCLUDE;
 
-	p = br_multicast_new_port_group(port, &group, *pp, entry->state, NULL,
+	if (entry->state == MDB_PERMANENT)
+		flags |= MDB_PG_FLAGS_PERMANENT;
+
+	p = br_multicast_new_port_group(port, &group, *pp, flags, NULL,
 					filter_mode, RTPROT_STATIC);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
-- 
2.25.1

