Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2944793B7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbhLQSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:21 -0500
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com ([104.47.55.109]:6446
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229502AbhLQSRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4h8yAaJfDBYhJ/WsPE3UoWpSY9ALeG0+r1GSF0K1r13gomq4vUkrAwLtIHh7fr5BRu2eZPMCFppWszv4V9nIQfEbsz751qQK+1rbGSujj3NjPXVC6yc2HM1Mpg0f3vvT7z/pyhWH77ofdjKLjnSPhw0GSKiHx7JtOF+V4j24PWbzuk5mJZB//BMs6nhKAmzJivgXsbHYWaDJ2R4q3wW8gayElDvujLICJVqWEXW3oT55pxrxBs25kIQ2uiUAZmAJCmLIMmLOLXKWEvHWZjrZ8pQ8gZFmHGW2r+VxKCB/F/61yAF7M8VtAc3qBD/UXss7a3Qggt6RFoLrAGvwN59OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hs+dKXZZSvKbfLQWptjH8Rwe19bdXbG1jYOuLoqdAlU=;
 b=W7qwANJ1FYLZZ0h/39bUsemjHkBmg0KyF88IisGdlK+sXsCtqPPM88RfDhlhJ72cmVpDBUEoiVTE1Sl0zXS1+AutC1RH0K4qqp8/o1P+9tz0g4gyqvjPkECkWCtmti8lD0Hce6Au4oWFzvJMds9udkgqOmoH7+KGt4uhd1vaTeczIfoKzs06VnQzc8nZX3LRMNNXgTf3cgkXo4zhDdhkhmOuIlJxvNcCI8JEpCb7gkJb0D81MUtVkAj8/rRRFpxaPTWQ1sHxfDLzaAMLc62QBFkX7gYy5M4NJq1RSIW4Vag3iPJvKpixhkN6K4hF+QJywce/DNV+0m704b5K8ylJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hs+dKXZZSvKbfLQWptjH8Rwe19bdXbG1jYOuLoqdAlU=;
 b=k/i0GanZEZ5HEEPV0fjJ/MkK0cVCnxpb38fKoftWuAwAnNDDGIJvdtdESbWLZGq7Q6dFLaeP9FRCxceSv743Wt85C/cP/ERznMq7DdWeEbPE55YbZw75yf/ta7fvPG3HoI/n+JnFvhZP1WeNTaaD9RvBiN1XmF+vnDl0uAtQkY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Fri, 17 Dec
 2021 18:17:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 02/13] flow_offload: reject to offload tc actions in offload drivers
Date:   Fri, 17 Dec 2021 19:16:18 +0100
Message-Id: <20211217181629.28081-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35b7d463-b0fe-4282-6f7f-08d9c189748b
X-MS-TrafficTypeDiagnostic: PH0PR13MB5004:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5004EF43DC9EF7BDE9212E8EE8789@PH0PR13MB5004.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R706omUMCWnkWpOkZd9EljwXwbN1enVc1AP9wkVojKLS4XXtey5rcCyVkPSy0cV4c1wIMByyPlMigA8T5qNT8p/MBOadAajmSq6v4ZzwSBgoNsvyhmME3pB3sDvwhzn6jVrrgczQp+//UsBRuwVRIk3sp/JW6ca5f93o3eKcrdAdRrsiUcyAXyochmdoKoR5w0Ja/gPKsci8AAzu2arPZ85uea6OySUntrfdiPh39p7VsJgNmeShmjOrhOugPrSFFlNevR9hRic/YQMbj0Y+Cak/t59TZWyuBIT+12+Jzk+u1CxP1AU/A2T/m56SbT1giHRx+XBy3EN85WtCIQNCajksZT6sEH54TNGxP0/YtMcsi9/1GH6HLty4ysmTRVU46yXTYJyIwXOUhYT0L41wOmXbBQ/T/dvjSodhVShdrF9ysgodVtZwsboz8mUmqKnOFRAKNleIg6Y0gcJvtURWDpfkogWjwLSF4NDCW/WHVrHSzYoalsqxKyWOQmbP146bRvD0PgNO0/KUdQWMWTTiO8SZonoBXFFCKHYE1TrxEkBHccSxooBlfZ/dC7PH8CGv6QulyGDcIkHGXBmGjGJTUu697ctXJV/pAqHYTqZOd+aaQfL1uBv7vYpmvShp2khdAyTXdz8GVhakzM/Bk1XIcVI8E/pgDvwBBzHAlQW5J4aAtwfYpTihpvuqCUbtCWTdmfI/qgdj+cdkNTZyv80L2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(346002)(39830400003)(376002)(366004)(508600001)(36756003)(6486002)(7416002)(5660300002)(186003)(6506007)(38100700002)(2906002)(44832011)(52116002)(6512007)(66476007)(83380400001)(8676002)(54906003)(110136005)(86362001)(107886003)(66556008)(1076003)(2616005)(4326008)(316002)(66946007)(8936002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QHvc1v8WU43aVf5i3Vh2erUS2RjYwTjM1mXh5aJDfLaplRmGVgoeZALvc0nv?=
 =?us-ascii?Q?dkM3xsbufszxWwUlmOpV4jcNECtEBl4XhhnRdYh83YYi6bGflb/pEftPuadb?=
 =?us-ascii?Q?gFpS9tP3PlyGY6WQDLyYlNzFfAkY3M5Bj4OZ1rwF/Uv+4knaDe1qtW3UbFY9?=
 =?us-ascii?Q?zW7trLe/x9Nm3z2C3Cbsk487aiNsBupUkkm9yzFECztKrJWpwG4fagcHM+8A?=
 =?us-ascii?Q?Vn24qvTkgFuapZVBQfROq/2KIOmWdfhajHzv3jHLqLUsVuNmVdbJji2V7C5S?=
 =?us-ascii?Q?W6+Hf463X4rJFJ9Lz6A/Fdqn/kpaKVJdZEo3bAVY3SzVHHbecVrqe/OgB7hy?=
 =?us-ascii?Q?HduXKdjt9CKJt1P0Dr6YuldURIlh+3uP2/Arbxh8YSd5t0efc7Hp6huPqKhF?=
 =?us-ascii?Q?xSXJKABGeAPVLXEV7vXhvwcAEr4RcF5PNk4pa1YX5DZZ3aT/G5NG0fNe6l32?=
 =?us-ascii?Q?eiRNbTktqqr49s2rx2YZqHofIPnI+IWjGEdbWaGpj1i+ZI5Gd1NiF6RDFES+?=
 =?us-ascii?Q?RvPWYqBq1sC5ilqus8a9NQtFB4PIQ5UsW35KMunIr4X9RUFOkdEbzy9u/bGb?=
 =?us-ascii?Q?UFDmFJUOIWafN2wYkyl/HJQ1eIjqrHbBCbHIZr49FG7bp4E50Ih8D3Il6Bwo?=
 =?us-ascii?Q?xwh5zILPNXC1unpzFpt5MhKdMTL0erPg0BAYaiQakz2CQyExs1fKXhL+qYEb?=
 =?us-ascii?Q?JzT/1A4XFwpcOS3/0fY4Kqs5r2UmnOAUl3kplXaTHpB36+mux+jlKT6Yn2gY?=
 =?us-ascii?Q?kG5fdKU7M62jNpwkgzg5/gGvFii2qwlzMw3PchMgSRXCB1xBcEfo4RIwW+v0?=
 =?us-ascii?Q?TQxUuZAg/cecrnERNHcPIWoWg+VW20O5NT2WeSnbMGbO6xK6bmchWto9xCaQ?=
 =?us-ascii?Q?77dgLiniWgJc9is5Cx23msdT6FJVZXzUYE/Kq1MmyC8yF/xm4+wAPXibt7Ql?=
 =?us-ascii?Q?JKX97XqLdRfDq0MmqQJRKj+VffBkbYiJO8aNZbPmghvezmoYTAr3bYciP3p8?=
 =?us-ascii?Q?Zs+XxpzcFgB4SycnZICbfnPPMYZv3vO4umWfpOYqgsYDD6rLqBQBN9cXVGKQ?=
 =?us-ascii?Q?wheI926F+sfwP2Q1IxR+p3bh9iUQ97zarsXH6Fc6FAPPvHMrVBspCLM0bwI/?=
 =?us-ascii?Q?H7qv20EWorhsdfMMjmLmTQcUVu/FY/bauyA9zLr4ktvFER8QBqigHQDg6dQp?=
 =?us-ascii?Q?WeIQiXUaTpuOdjNKGA36C+1GbnXDvhUefpae/x5ZnpLL2DMNHRoxRCxcEpGt?=
 =?us-ascii?Q?hooo1BVnUPM9Hr6QsZJCYNSd4cmP0BoZjF5CVQMfqwM1Lip5uIXU2MISsxjB?=
 =?us-ascii?Q?fMMzcQMh1RU+Ehy5zKE59PeFSM7RlwOYL/YGBuBO+XvZJTSnbmB6mS49rtEX?=
 =?us-ascii?Q?esyNk/OnnOykziJlcoW8v2UwSY6RlAtmOkCDyw+5vuLwy8W4wTiiuVMqHmFI?=
 =?us-ascii?Q?ZwgtuUkAGqivjeMC87bJSKHptHW3NsYj5eMy3ZYR4A9tKVAqLx7QP6NEzHts?=
 =?us-ascii?Q?8QMJI9dNsi70U27H7Gq70O2cKOyikV5n6o2IEvYPmECWzRBnH96A9c1Hban3?=
 =?us-ascii?Q?r723E49R3PoyM+PGCXxWTIk0qNE8RdGm5+25S/qOuHIUF7yga+TCAMcT1Au+?=
 =?us-ascii?Q?EyeXvSnefN8XFkh1E0c94/CZnfi6z63p/mVaiR5Pu4mhVIBphdEJ6RVBF92Z?=
 =?us-ascii?Q?Eh9tQqwEDBXpn5QH0Fulp47Hrsh6E4vOmdD2m1k/0S8nk9FcsTG6cWgKA0ON?=
 =?us-ascii?Q?VVAxK5Oly6MmyUolxdaPOnKyYVyUoQE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b7d463-b0fe-4282-6f7f-08d9c189748b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:16.1652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HATiuVADgdf+dXfo+Wdiaai53GFG64VHeGBKT1JA4pXZ5xvAuDydmYt4p9DPnI92Sh8VZyJgb7kqT56HMI0sLB8/obKXDtxan3pdWYEsHXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

A follow-up patch will allow users to offload tc actions independent of
classifier in the software datapath.

In preparation for this, teach all drivers that support offload of the flow
tables to reject such configuration as currently none of them support it.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 1471b6130a2b..d8afcf8d6b30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fcb0892c08a9..0991345c4ae5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -517,6 +517,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 224089d04d98..f97eff5afd12 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
-- 
2.20.1

