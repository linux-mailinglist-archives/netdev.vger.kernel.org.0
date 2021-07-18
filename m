Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F73CCB21
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhGRVta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:30 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:15454
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233564AbhGRVtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cbok55cRY3l7Oa1k2HQfTe8lqYO2bCEA5RUGpjk+P7QdpKZVoiH8KdQI39EdWejYrGxtSq9SI+UqxO21LURlW2lJ+K7JFXws+BGjF2KXRgdPMvuzbRgX4NBV/gmntnklt+qX4e2isnE6Uw0Sas+GMlieneda5GkZH30XOU5RGtthrZUtsada7PVQyc4mGcxVJNLQxruKK40auCu6Ya4QgpF8z2t5oOr0UrczUlfHrNpMmW15dfTGWHeFI//WMOs4isNeaVcFrNKBh6U02XDSI8KDyaaktxHRBpppLvz00Y5+1SJSUhbN3yyAOsuJdFcV/LihEI5iM8NOSZhrV7plnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpXyt2PXHF7+V8kLQBMsqSrFhyu/EgM7vwyFVIoYviA=;
 b=PA9lYy9ahh8W5m7jy2O6mLnYOBfUMKdzMdjch6HmpwRCFc9aN4rBZ9M8otnNPWIdPbo6iuDnp2MQ51M6Q4exqDCvme8xfNABBxHVhietd3kwvDeQI7boIYPnGg4dOU0659CiItb/UWA4b2ceXf5tUivhC+gcPbiOFgbwvrPWbpqiCGEsN0DgMLMTIPX56Ho943Ijt0SgcashxJwZnMv2/ZrUsAUPEeAXkQ6znZxhEVYFuNuqihFCGgYcM3bPxJ2KlW4UYmqWtGnoLRlH9G+LE/lQZFRXaU7/mrVsUT412Mc4Ph2fnblh7Gn1xYw5IYygsU8qJ2JSoVLuSPrfeHe+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpXyt2PXHF7+V8kLQBMsqSrFhyu/EgM7vwyFVIoYviA=;
 b=lKdTRo4V9/M0qcsJH02/Ik+3hF+rE8D+I8SZoyLzUYZqqilb97u7BhwSmqLvZW+OIRA+koy4vk3ZAjg2TqUFoXDPTfW4mL+iRi4UKlgzn2SYOV/R+ux2Kp76flKdY5Vdhjt4DTep1x8vYAwpc2YdATWHRq/JuzGamnFGus0czSU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: [PATCH v4 net-next 06/15] net: switchdev: guard drivers against multiple obj replays on same bridge port
Date:   Mon, 19 Jul 2021 00:44:25 +0300
Message-Id: <20210718214434.3938850-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f641c11e-17a4-4de0-df03-08d94a357783
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7325F4450EEE2302550E99A7E0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBB0WGDwX+I7N4Kb7u/4HC3spbfTCYyFHxudqV4IAGVYhhFK/5mo3TviKVVp2pGxdIQuUekYGJUOF8OIMYvhpKS0w6Se8x2yu2kDlmyOvQlX4V8/TKvu/ORg34BNFbU62ZDW9mliXRZ2bcW85Dcfq/HP7Pyb359eg7PsNBlG4OXg6sAo+hbLb5AuVXOOzkXxZIp7jrqWKG6FQh9lkYsVP9suQXjOgwiejkD4AsPNn1LHgb842MpzrACAKvmj9lBbmmSRjxHQQLOuM8sLFofNIkKzBMwdWqJXi6jVZm85Wzv3gwEFPebiSUgKnhf3papfHGSd7ec3W0gRh3XC0VPpqiWD+ftncoLOy+ljnBWBKuYM2ytvpA2OMf4SXt717A25io8gHgajmPYXsF5iX2v7Pl+qJ6qrJvn5wRbCv2nWQ6ax2uQGCiN5CKLTAIXtHwuWC1fAJigWsigKblWzhDeGVONlRFt38y/FS2qs7A8r5XxpbMe1adoiT9Sf03TOQ/cqtpkiELvOfUj1L39fmcDCJcriDcLveo8fp5HH6EogtdC/DH6QzPPQb8mwBf0FI3tB61jP+fuuTDn0LJo7nMdgBmL24N7qgeuvpYdWXqgJ6J/mjnOrIh0CyIC+tMW0yRao5m8O/+NFJXyZgCythpuUqTKBtTZbS99o7gslZ7u6jGHPzdWoxTaOEHJtjtZDDAibdPGKuRPJsfkimEaNfdmlEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DtvaZTaN66MyI8KJUUEo3cdNPretgjNw4nrq9BA03CCayBO7JcSgYJkLzATz?=
 =?us-ascii?Q?2Hc+8WKlA2uRoh6F9leax6qi+CYB1+r0IV9ffhTS1UyEmtX5UdFaCYba6bvC?=
 =?us-ascii?Q?TO7i74sq7695eRIV2A7JQrLiv8AraQ5NA09zmGbeWqxm8h09kKvTPhkf+UDx?=
 =?us-ascii?Q?rtAdH7qsLiwH3i1gimv2DBxzLYDqlw4Hn34hFtGH/qhRvwOeY7r1N3fIuHFv?=
 =?us-ascii?Q?+gjyScrbKf3Y4vb5/c3kLI9ZAH4ITrEaYmO9FMJKWra3FiTzch4ODrG4jvWY?=
 =?us-ascii?Q?Xde6AqYsZzAqwJWFvJeL9AfNQCbhkVWhCuy16rUcygAxEvcbvE2tZdyZbQAZ?=
 =?us-ascii?Q?PNr3b3909AcjCYobhkEw6ljVGcTV3UoaAXlZByY8DKGjiA1eX7xulnRsOpBj?=
 =?us-ascii?Q?V2gfXPF8zRWkasBiNWxaZe9WXuW4F3xAfxvuWECK/OF+yyuTfVTrWi1hBesZ?=
 =?us-ascii?Q?qcWhpvo7L3JVmHed670/HkQEb28mwbX7UWKcarGIK0jLRAGLvgkiZuuOHjuf?=
 =?us-ascii?Q?sgmYRPswuBAoYho2oO6/vW/gzCXb3o/ryOY9LdKlfNGs0/A2rhc75EflO9uo?=
 =?us-ascii?Q?s2Zun13WvWP9/uoCdIB8gDz4enigru0SuiEGIwDfU0/nTv96DgIdnpMLTdab?=
 =?us-ascii?Q?zRyq5h2bffObBUmtfJU2DEb8DdLR3otbEjAG/pM6/fT2n14PJUiQxw5n0f51?=
 =?us-ascii?Q?N+O59VtGaEfrmbLyEFwidertvthEHHHd3siQ2N8jHxWjvACLiaxj+YO6Sb2k?=
 =?us-ascii?Q?jhxmzHKMXU+Ybehx9usTw9gUg2pMkjM2GvMo7nX54GBdHGHKleFBk/6dT7/a?=
 =?us-ascii?Q?B56AfWBW3ZkcM3s6SIwf4HjdGB167pqDrr+zSXMIjR+ODGEobvF+/JDXyaKG?=
 =?us-ascii?Q?uBU4d6yLMhWCYYod1YMMQPRN9pppeHCX4R4B6hql9KpD/8D4X9Bfew4Zrntm?=
 =?us-ascii?Q?NlIwQS+gbmuLKBdru06j3b4IlO315ZjTcEUW35UMrONerQ5eFFJYODyjoAsf?=
 =?us-ascii?Q?gbJRa5ELuxByKg1nA36IGksH0tKh6giwZtVtJj+sKijqDkV2ELJIAcQoWkTs?=
 =?us-ascii?Q?wUjtiJkdZsLjKdlFOmcjC6SrH8tA2IPZTLm5eVdwGVFKH3jDWQFzd0RlMMg1?=
 =?us-ascii?Q?2kOnqeXdAdRaD7lq/VQglue4yKv3yHfwYQIBT9YfQhUJkRsZfG/z0du51dvV?=
 =?us-ascii?Q?ZSNZldPok+aLHXfI3FjQWs+bxoihEwUCms2L4chtFBsW5ON0b2O4x3kNGzzp?=
 =?us-ascii?Q?eWbU+MKAidjMNHcsv+PKQKJDbyxlyQMvpTG8tbJhrv6rF/SlryrXYXE2Ct45?=
 =?us-ascii?Q?OQ+9lnv80xzr5taSWYLqfV/Y?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f641c11e-17a4-4de0-df03-08d94a357783
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:15.0068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKC2vDssc9zl+5hjV9jdT3L52unHByhfEDX24ZamV/wzeBnNEqNteHG4cSOJ6UIWyQ/G8O+eJ5rUg3otz2l2pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare the drivers which support LAG offload but don't have support for
switchdev object replay yet, i.e. the mlxsw and prestera drivers, to
deal with bridge switchdev objects being replayed on the LAG bridge port
multiple times, once for each time a physical port beneath the LAG calls
switchdev_bridge_port_offload().

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: squash mlxsw and prestera into a single patch

 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0b3e8f2db294..a1fc4ab53ccf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1047,6 +1047,9 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1083,6 +1086,9 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 61911fed6aeb..5a0c7c94874e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1772,6 +1772,9 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev, const void *ctx,
 	const struct switchdev_obj_port_vlan *vlan;
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1920,6 +1923,9 @@ static int mlxsw_sp_port_obj_del(struct net_device *dev, const void *ctx,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = mlxsw_sp_port_vlans_del(mlxsw_sp_port,
-- 
2.25.1

