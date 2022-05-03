Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5482B5183CE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiECMFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiECMFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0480B30F65
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6O1udftpKBGlAOuB/rSfyhD42EriYM9hEOO4DDrMQxSbE6P23FQQn3b0HZCQdbTCyOm428JtGlC9ZWB8+nC0gmNGi6cSPCAhsD6HXZ0HYovKAKgtO/hpwM7aWMd1v3K+dmLGkORhALTBZKYcEmKy//J3PY7xhpewYrbzGmMxjEW94dHWNW/T87T3b0NdxOTlEyjjuIxMiy9dxzGSfTlaKy1ioSGRZ3Ok6It57UG5llEWHb6UBpCXK1n0IJ4oGXqtzotp74OwBCTZ4IBcL8g6qB24sIij6G6Hrr7aePfOfdWLPDBNQAltToDUU3RBm76sXu1+dGgKBuwIa9gnhffpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKsAlMERbmoYOzddlnEZCgUcF4QpJohETQdWLY1WOIM=;
 b=EF67CIbi2G7/yc+i+wATR/rq3KP0VhOiK2+3ZaE6W8gMFu83+hDVxnkWRx8orrZOUiOBoe/96G/CtbB1mjtzHyS06HK7UQCQ9USWDKbiClQlrsV7KDyp9GfqqMRya+Dywerq2I/rwRBNLiBe6W8DchlRjAdrfqy5/dPA9J3dYUBH0Z1P3GfeauvyR8CT19zPvEdBygEtxKY9h3eVSaiMeNIK65d6juMcdvqHksxq4jGc1bt2barb28AzHvXJ6zQnAefeHiXNGxrCmri1T7C7Api1JRCyXYn9X1TbjM/sQm5JYqpd3mD2mvPJnJAjqJr/KYO4BXHQE+hCdCrQrDvY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKsAlMERbmoYOzddlnEZCgUcF4QpJohETQdWLY1WOIM=;
 b=UHdOqz6derI7QPRelM5jFRJhXoUnZTZLUJyrYhgKqK2q7NIObx8bX316Sm7qUA+r3qRZaBMQsYd/+6yQWxr5yO+Sc98gDsgC+EaV3SZu+TrqxQBVdrdkM22MlMGN4o47jC8kEcCghrD4t5oRYtsCZ8RQ9TqJTWhNVOoaZoAEcC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:07 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 3/5] net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_filter_add_to_block
Date:   Tue,  3 May 2022 15:01:48 +0300
Message-Id: <20220503120150.837233-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 914add22-7fb6-43ba-9157-08da2cfcbed4
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9480F0DD71BA9D8964C42F69E0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxLQ/wKh4M5bJF4eN+mgedbPYoqLDHINoYei3z2iKbBbZV44lHUI/+zb6Ef29sNmX/edNEAP1JGS2Tb0LZBpHsduv5IvVgOCH0V/ePngxr91rfx2Pq5VQX6i1pmCgZ+cSvj29pB0jkG4AMkURwC2ToTb/XwVdY6q7RfNvdGaDbRdli8qA8n11f4J/otvkSlI0ytzSUee31OPKSqdf9/AIbAB4d9VrR9a+0Vp6sLuoC4K0vdjQHV16tp3SvyYobn2n1aoFQvPJrRqeM0lbQ6OF973quN/oZOK2APpmXc/Q+snMcIL1Ej6yQldc+yVZ9mfzmEL1zSoM9BWTqo+yFGAbGs9tNbUKG4l0ywJ1RigIAlCh972lsYtcwFr2wGPaawi0k5fvwExGld9rS77Dm6HweXEMvv8JUyJXEdFuMGZEZ5nOLwQ27DMnDi4T3idmD7668HtNcu34fI1wSYPZH2aug3qZJswbza10hMqM+zkWISR6H9P11vlKJvxKSHiY4I6HCW9AWmLd7SBzqW2C20ez7cgC+6COhJbSDW+sbUls8juznFbk6mLZib9oJYdffDCTghnU2NGKFUxluj2gm+pKyNkucjobGxip3cPoWckBLnxmF8UWsNwHLTjL3zTfDNrbjuI6cHhTeLz0l2WHhLWgu25ygb/qBgxHJLkpccMt8pmZ2AOv6/4rVlaG0SKlwuGFKAYYHQd51ANom1gV3/jkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S6Jyy3DlNLgUOJkuNzqLnFxieq8FBU5pm10LuNlKF5bXAgdKW5ivkSgZOsMW?=
 =?us-ascii?Q?uhJXsXsnsiY7AEIhY0jIkSee2jPV5d6VQJueosRXkbo7HXwvLBIEWXCf2YCt?=
 =?us-ascii?Q?iG/fYf54dMhdTVabtO5M6jpN8P3V+s8b0zMJD/NlF6r013IFDdbjB8pr5C0y?=
 =?us-ascii?Q?WxIeaOqQYYw7gFmcsbfTRQ6mX1srfuYZJZXgyQjpjlstyIb0bE7Z46qVZQI0?=
 =?us-ascii?Q?wGME2EOc/6taBlojhzY+7/vIaHO4wMMcYysO9KPJdD5BDZ+AjZQ+P6PEfaIY?=
 =?us-ascii?Q?7EwCPlIxCdLkW8htSGQ8sw45sl4WSZqaxVYeLceOfpltmMo4u2yXru+tzxQ2?=
 =?us-ascii?Q?5oPBJTTZSCIVpYzV+z9lISqaHh5YUf/uJcSCHQ3uQC3q58elHGxy0kK6uxmf?=
 =?us-ascii?Q?BGHAXnUQ7fmPYnsLwEEPdSfQUh2znMQzQlPgP3MEd6f+HuZP+pMXAviCkI1g?=
 =?us-ascii?Q?vVrDy4Avlyz7QzhMeq7j6nfvzh8ke9B3BB0tA7r+FsKCi9eOYjLBEvhN15cT?=
 =?us-ascii?Q?m8o1hkwx7JJ3+Iuqd5s8VzaoT/Li/rC8agMqf93eQBa9iw0ghSffNJzKUqWS?=
 =?us-ascii?Q?M192wkubst6wpbZjbs8buum6VpgFNmE6Ddbvi2DVAux9JhTrc9XpZmWuTZEx?=
 =?us-ascii?Q?FnkmuoD9bqBl5QMdiA8cQ79+NMfQeYOs2h3iMG+ORzfjf1MZu4Vl8+EKmM2+?=
 =?us-ascii?Q?WBslgNjeKkp/6GjSaFBLbaLvMHkMWpf1EQ74+E1xb41RFb2bfT+nYWucouBG?=
 =?us-ascii?Q?yxIYxorK+OH3yjn616StOhFEfuVQlF9+LVSIeaGlGkZj6rRca6VEOxkxsz1h?=
 =?us-ascii?Q?X8zCVVdPI+3fjXYR2Ubfr9HSDLD/fqQXJyxyEM/PYnE5sBb8ltiIa94OriTQ?=
 =?us-ascii?Q?FKuFKJeieYn1A1I7tTydJAWUYUbEjf/gzjMh2ETja+Vco9JnhctmSFNvUZqc?=
 =?us-ascii?Q?7T9UPB46p9FxmLtib0KkBUvLLuhyvoXbOFsAVf0OyTULaA+I5bMMSPnFW9JR?=
 =?us-ascii?Q?/80UNMDUZ4vP+wWGe0yiqPdT/dVFbtH6JOr42aTuJXYHML3QAay8wZw6ymdJ?=
 =?us-ascii?Q?Np3Ge7x3XivSkkomrl/xRQM/unNskcwNYxSurbc4Zn8F9BhouRdQXIG9z2so?=
 =?us-ascii?Q?CGBRFv7qABvXM0Xz57wYhNHmOc1S4euk+0UytO3+2YOw4U5jM3h9GLUBBqWA?=
 =?us-ascii?Q?zPQJ2XmQonxWJjZiLXiH1pvE8m+huVi+ZXIenrw9y+nsh4QmeZZZAxO4zWLf?=
 =?us-ascii?Q?96CqOqWQMx1cmJyrYOwOy05kDwOlsFhYDjahAU9d9kcCVjMYNgPkqI8Isq5M?=
 =?us-ascii?Q?4LI2cDrVx98ptTZlpdY+ojyT5bd7rfBZdFXUJ1QJfFtlHbvSA3wCfK4aoXS4?=
 =?us-ascii?Q?DDUmx8LUt9auEe6hRBRg9GEBoFkUOUfh6FegtQpnRoJtK9zagXxBOUrvLryo?=
 =?us-ascii?Q?EkY79ICvqGm9CdW6/rOqcxzf+oRfcC5L014NvwUSAv21qQxKThCaIKrxnB+G?=
 =?us-ascii?Q?9CHAZHsDe3qtiLvA/6kuqMm+5oj3woPWXAe3ck3H8GV5RA/wo5JoF6e40lTe?=
 =?us-ascii?Q?+8N5jDw5OpSu4ka+kFcOIJ/dVNEQDMKfgkRRWGCBIR1dw+sk5JkENYG0nOVg?=
 =?us-ascii?Q?sBASQksUmbQGLGJ5zQrZ9l8d+lUyM+Cf3SD9AR7+dksOTeUDmScXrUpy+MAx?=
 =?us-ascii?Q?bRrl+dWZZKfUlV+d6DwtG1AMUfFbbPq/+GOEjbMAwALgCObQCo8WKZ08UPra?=
 =?us-ascii?Q?MXMeKw7M6qHFZhgiDwjnQNXMRK7u1uE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914add22-7fb6-43ba-9157-08da2cfcbed4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:07.2735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r25B469AeBdr+zeIZiWOM7OH7OZeSdNrtDzjEKRUPjOQNvAmEo0FnMrxVq5B2R38AEc78h3ZWmBXEuyADtObOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unify the code paths for adding to an empty list and to a list with
elements by keeping a "pos" list_head element that indicates where to
insert. Initialize "pos" with the list head itself in case
list_for_each_entry() doesn't iterate over any element.

Note that list_for_each_safe() isn't needed because no element is
removed from the list while iterating.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 3f73d4790532..e8445d78a168 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -992,8 +992,8 @@ static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 					   struct ocelot_vcap_filter *filter,
 					   struct netlink_ext_ack *extack)
 {
+	struct list_head *pos = &block->rules;
 	struct ocelot_vcap_filter *tmp;
-	struct list_head *pos, *n;
 	int ret;
 
 	ret = ocelot_vcap_filter_add_aux_resources(ocelot, filter, extack);
@@ -1002,15 +1002,11 @@ static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 
 	block->count++;
 
-	if (list_empty(&block->rules)) {
-		list_add_tail(&filter->list, &block->rules);
-		return 0;
-	}
-
-	list_for_each_safe(pos, n, &block->rules) {
-		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
-		if (filter->prio < tmp->prio)
+	list_for_each_entry(tmp, &block->rules, list) {
+		if (filter->prio < tmp->prio) {
+			pos = &tmp->list;
 			break;
+		}
 	}
 	list_add_tail(&filter->list, pos);
 
-- 
2.25.1

