Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEE243FEF9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhJ2PHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:07:22 -0400
Received: from mail-bn8nam12on2119.outbound.protection.outlook.com ([40.107.237.119]:28512
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229542AbhJ2PHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 11:07:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ne5+MFz0THuAhrCXKNgugucAbuNxlMd6iMjdY+oezLbZ6PtZLk3sn90I55SxLjZ/QM1DsaQDq7Ll9XuUBwYoB4ttu7QLAimvRFP+VyEcQSJQ3iyLEPkXm+2BLZ5j+gybxebZ9NTUgJBEz1P/hHLcMVR1OSB81iSVAIyCBzbkozR5huhbKn+8pbL/vII27A2D4M0pPf38faWOwz3ZSpJsMX0xhgLj+gjsl/IydEUcdd25tg+mMh3nYnCfi3axwB9g3lCdtHu4g2BtgL/IhdMSrSXEVtWddnR8ij70Vcs2DffFLmV/PBqupV3qIfYMVFvH3Oww34zGpby3CYRhrYJJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jiwnx1IxTNCRKfKlVlVSn9yKlaWjSp3ypJUPoydXEOQ=;
 b=VYh9l0BsagkU/bHAD1ekhf7qp4OUY9kWHRxjRlC3FV6NinQDIc88sWxgQH6m2i9NKYzsV+JoryrVwt5moBwy6gt8R+pXpgXC6f+scYbNUbyfRTt47uYJynj8y00FCrj5fImZcBG5fUtGzqz+yinezEzYWsfZsZnBSxGfJM2aR0S0vG+HKe3eL8aCAsGJCABJhlNzM1+3DYQ8VkExXlALayGq7DMobQmDkQmj5eQ/CZ+2ei0IRbP3+XE/PHGuBO3JK53bF3F3aLYKbtooYdCl19RyVjt9yVdQQ3hdGfEpcOLNuINjfdAmvw1U8a6BnwVx3g7gdgfabwfec1XYpk/psQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jiwnx1IxTNCRKfKlVlVSn9yKlaWjSp3ypJUPoydXEOQ=;
 b=sczbaKSm1WpVtFPYnpcSXyXYkR6hpg8v5TSoix/s738HwCQaqiZN4aepehOb30gPjYAoKeOGuQumwMR2G39WWcsatg2HeMjC7qSD0SE+QBmkLARumbtbvchjGzXx1PCOX249+yItoL9c25aMizMePMvoKyPuCPpg/C1GdwfZdY4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5681.namprd13.prod.outlook.com (2603:10b6:510:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Fri, 29 Oct
 2021 15:04:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Fri, 29 Oct 2021
 15:04:51 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: Allow ipv6gretap interface for offloading
Date:   Fri, 29 Oct 2021 17:04:29 +0200
Message-Id: <20211029150429.23905-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 15:04:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b77760a-ffb3-4717-ce43-08d99aed750e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5681:
X-Microsoft-Antispam-PRVS: <PH0PR13MB568174AE01BE57EC447C596FE8879@PH0PR13MB5681.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRPnPNl6i53YrjWIn26cqQmd7QmRrpjVCa9sINTdV3qlJ22th+Ri3uwADw1/U2IC0IGvA97zALWOIXa2WHKL+BQCPjte2xdiw1w4z1a/+b3IcbkbPZLsMwOFwJX6/h5m+VPJYgurwX8i5zGySRBHNz1SsApY6G/VsqGJfnP7Y+TdM9sdNxmlya13flWaT8kefxdoFJie0kRpK8iTFOxPPfzlFr94Gbx1zF2vI1NIeMLeUkEcCzWhlWIikGdSu8bvst9sHUFzREqp10Cb16WAvEoZylCLpWmOttaW6VnGC2AxgUn0ORkTfDLOqgkLm5i86NhX6InTObHudhw+6/S7uAvHBY3AmxmL3XpkpTZIyqun1ASJSAvkXL6hlMErWmQsEPNBVE7tdCACbf5WNjKVwV+s2a3accfAD6BoEEWPxMBfsOA5u3Fm+1h9eYYlIrhmzI9EkoSKMWEbgv7NuMCFODE5VVZXPV+feQAejn/I0V2KRoQcUwkXK0jeztdRlZlMqjLQsRnbsfaP+wGWijzqP4xVWiptltEHMIM5NjawdQDR6lABo1YDy29N3bSLJluusQtgvetvqyj1qhrvUIk8dMGGZqpRfXPCjDGt3VbYOmCcoeFJNb4muXgxejhcuHdFwnGHpyO6OsMnjVq81Ful2DOUXba7JlCiL3va8278lF/ET4M2CUxqnvzw6IMsn7LnSJtNG0I1om7OS8gOcHFOZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(376002)(136003)(366004)(396003)(316002)(1076003)(38100700002)(8676002)(8936002)(6512007)(66556008)(86362001)(66476007)(107886003)(52116002)(4326008)(2616005)(6486002)(6666004)(6506007)(508600001)(44832011)(83380400001)(2906002)(36756003)(110136005)(54906003)(66946007)(186003)(5660300002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0wqefC41cK0OaUiwPQ2CNLUwjRCVjxhv2p+atCiWeQE5aOs+J7YQhhkJz5kF?=
 =?us-ascii?Q?fBvHVuuKbavF7Jo+3qPW0aUbnxKTPwgKm7aQ0q8+Xg22Rdlqf5d9ocXbKN7I?=
 =?us-ascii?Q?XcsfRMdobDc4vBIV6EurQUZxDid1coa8xcHu8aZ84T78tiPZZoyAN/7uaUeI?=
 =?us-ascii?Q?P4pRNBjFKQ6d8i6m8Gp7MIoTmFxYxF7hlFkD2iwzBcEorltqLuk/O/pT5EfV?=
 =?us-ascii?Q?Iowqb245r3dqqwbBKyb66rGSD5ZV5Swg0KII1Ll2bRrPifEzJefCulCBvQQP?=
 =?us-ascii?Q?6SGkJLA67lDIbIMftrMd1ptWIJOg5e3j7juKrK+Zk30S9H0i3TgcsJQYDfsI?=
 =?us-ascii?Q?J8THe6uMx5Rq0Nn8u3C9eMQg8pOg5Yar5dmnmrJ6olLrPF2r5ucc7+I2X8k6?=
 =?us-ascii?Q?U2va1ltRlPbwSko2MIk01e9VH2544qgLsTiSPujajeLa1mefoE+qPn2oy5Sr?=
 =?us-ascii?Q?nUk6sV5JCqQS2mqipHG7UpaNokmNscYP6Br9bq2Kj2Smv+8PwRHh0BcIRLES?=
 =?us-ascii?Q?mMo4R/awxOuBpGnYae3+PzE8hqCFZU65x94Gw3QF5YtFu23wELUr0Nb0tNyZ?=
 =?us-ascii?Q?rjUAbfQAvfgv/XQ5QGDqhT6H1ZtRvrciRged92IbimG57C75m5mR/k40ol8R?=
 =?us-ascii?Q?U6OtS+M2nT17AsSnE5kFlO9gIWn2FjQ1fjik/pwxz8+Bi+SCrJhFs80ZQenc?=
 =?us-ascii?Q?u1K7meKkK+3t/E6ImWohZcvkSJgPb4LA2dvoHP0ahZXMqC1xY6vquU5cXHzd?=
 =?us-ascii?Q?o6q7BOtOZM2lnoS22wDVwUZJdFjRIiSyIhHaYOR9zPqCUeQCU96pAOWI5/7Y?=
 =?us-ascii?Q?pPR5l+3IeTvUrrE4sVuk1JowIPG0cmVZYwvmbztiKZkboXB7Gh7kn2PJtY84?=
 =?us-ascii?Q?hPW6v3dEn0NWj1r/matr3GFuEJZrf7y2FnAWwXmdJm2ox2C0pM+ARbEJCiLj?=
 =?us-ascii?Q?2bO4YvKK9Q28sE2Fz2Bo2FGxPRt3rxdI4YYMpXz6cqWXSVtGi1hLFJON4IBn?=
 =?us-ascii?Q?hlcVcra2gMO2mHxuagEAHomtv/oqJNU6hVQZXN73MNn0byHzCQC9YBnaBd6U?=
 =?us-ascii?Q?79VupH/RESiszlikuwRMr8bYOnPrMNbpBX5aidq1pRP+wd3ljrU7tfFwEimm?=
 =?us-ascii?Q?3sbu0w8PzQqI42j+qXohnRCURnu2ViUup/ZJJIPaGRJB7KCdafomXvJrTYFH?=
 =?us-ascii?Q?xZ+TzJcuyX4oicivlPmCxFRYIkGXxcIAWvzWpMwUV0XfqyMdcY0Nt6tMfibU?=
 =?us-ascii?Q?sYP6aGoBwV8mL7kIVtJ4EUciscXZ5zlx1SXY6apBCkkgT91oeQcOjNCkM5Eu?=
 =?us-ascii?Q?ydL9TO5pzct8Hmm1+nKGXffrvfGCCykpUQDvp0yFZrNK91EKftuqUucSaRZo?=
 =?us-ascii?Q?8FYG6CLIVyBzMWzO1hmCS1wsq/ojor8czk1sQsG6AnmVRR7KPHyaw7LqEgyT?=
 =?us-ascii?Q?0lo5ak9tTN2vfp2jtlYCg7LrwMe9ZahKtvhgqd2UAwhqGsfF8gcRGs81jHY4?=
 =?us-ascii?Q?/wjQ+KBzV0UMTOuF99ZYb9jozr3jh8CzGWLeZOHl/4qENaD7GPZc2O7YNzYE?=
 =?us-ascii?Q?NxoiQpd5Lu/XDjD+k2Ft3gLSgFi6BW2pluWoSar4jUvUIjv2OalA3aIuhkMz?=
 =?us-ascii?Q?kL8FS/7qGEWaVmCe0jWufoa16k10f2bn7sAtL+wvDUEv8nCnRu9+R1XqOZcx?=
 =?us-ascii?Q?0WDmW6agPvITVM4A+b1qpiWSlJssIpnafo7xxTmDJhroHstSTQL4itOswxzk?=
 =?us-ascii?Q?Om3l1KxNlgMBf5e112dZFRZp4VZw8g8=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b77760a-ffb3-4717-ce43-08d99aed750e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 15:04:51.3488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 185lWb0X9UXjoYr1JeHpXl5MRCekV+HWc/6gNE99H4EdT7KARQHM2NZzpUZcaldBGr1XipfkLtUKefOexHjawoyMCFrRl61CwMRkRRkZsGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

The tunnel_type check only allows for "netif_is_gretap", but for
OVS the port is actually "netif_is_ip6gretap" when setting up GRE
for ipv6, which means offloading request was rejected before.

Therefore, adding "netif_is_ip6gretap" allow ipv6gretap interface
for offloading.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c  | 3 ++-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h    | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 2a432de11858..a3242b36e216 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -272,7 +272,8 @@ nfp_flower_tun_is_gre(struct flow_rule *rule, int start_idx)
 	for (act_idx = start_idx + 1; act_idx < num_act; act_idx++)
 		if (act[act_idx].id == FLOW_ACTION_REDIRECT ||
 		    act[act_idx].id == FLOW_ACTION_MIRRED)
-			return netif_is_gretap(act[act_idx].dev);
+			return netif_is_gretap(act[act_idx].dev) ||
+			       netif_is_ip6gretap(act[act_idx].dev);
 
 	return false;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index a2926b1b3cff..784292b16290 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -703,7 +703,7 @@ nfp_fl_netdev_is_tunnel_type(struct net_device *netdev,
 {
 	if (netif_is_vxlan(netdev))
 		return tun_type == NFP_FL_TUNNEL_VXLAN;
-	if (netif_is_gretap(netdev))
+	if (netif_is_gretap(netdev) || netif_is_ip6gretap(netdev))
 		return tun_type == NFP_FL_TUNNEL_GRE;
 	if (netif_is_geneve(netdev))
 		return tun_type == NFP_FL_TUNNEL_GENEVE;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 64c0ef57ad42..224089d04d98 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -360,7 +360,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 
 		if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
 			/* check if GRE, which has no enc_ports */
-			if (!netif_is_gretap(netdev)) {
+			if (!netif_is_gretap(netdev) && !netif_is_ip6gretap(netdev)) {
 				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: an exact match on L4 destination port is required for non-GRE tunnels");
 				return -EOPNOTSUPP;
 			}
-- 
2.20.1

