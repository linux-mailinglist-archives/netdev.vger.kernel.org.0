Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46DB43DFC2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhJ1LJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:50 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:43800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230216AbhJ1LJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hehkYJMzWHK+T98CjZV7DXqmhsbr/0MVZanGnAys0CvJIHGnEUI/7PBZlDrDkHkHwnbThWYQlXOQ7QfuQNrUiCVDNq2wh8sIstlN9rQxUHm5/gavcfPRxwta6PbPCP4rX+cNfyH0Nt8SsMDxiOGeNX+G2jcngCsGfXP4oE+AiGXEvlkIboCJvjrfNM4oUxXYDcLlv+f338hnO/zl99tIorPbEVE5no0v7hasJKoWcEM1f0zB/ZX+5BhBuJtR6WyRNJ7Fn4zu4EmyacUR0TyVMMGNfc0XtNw0ovyeCqJGBi3fz8a+RK4PRUc7RG3mQKoPea1upSxX+o8ICUVaR2v9Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgmXNN/J8Y5zBrMApUOnW6EM0EVb5xkPdro/B9YtWXc=;
 b=k9lXMev3/rF6Iaw+MzO3etd98jXCv93xsrf6HybSuiJDalh2b55dytSJ5nwnf2wBUuCnrIfB6F096zZ3ectw2Dt+u8uvDqDm41vEPpNiSSDw1HkOXbKtTcN4keaIBbTHoVIK7x1aHLu3tVPMGBnFpki4+Snzztp+WSPw0pX3agGO1UBv2FegcBGiPDwyoY+67ZdIPho2Q7ph6xmDO7rkrGEJRedCDNNb70BkYdX7otH3Fj1tJ0UHl2naycVjxkDr9kwdtnDCv3F6Ttcmdmp23kdFte+uO3jMY4xdaEfjiircTrjyB8PaHSBD9kolKrAl+Y2BB6wyYBw0LnTXtEa28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgmXNN/J8Y5zBrMApUOnW6EM0EVb5xkPdro/B9YtWXc=;
 b=XYA1naCSZrheO35kVDNvOyfiSa0Oj/zCFeX4Q0VTAUzsTe24uwBccD0Cdbds4yO+QzJdviBnGU90Ial2ivvVDx4d/cgeMkQIX/BHwWhmgPKqUxwfo+EuqlNY4Ipqqmp46fBDWh99sc6FgPncAVc4Rlafyso3YtN36Bm7WEOq04E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:18 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 6/8] net: sched: save full flags for tc action
Date:   Thu, 28 Oct 2021 13:06:44 +0200
Message-Id: <20211028110646.13791-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0eaa22a-83d7-4e2c-ab4c-08d99a031ae2
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB49562ADDE91B4954A1102679E8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n37ts0mE2e94Q1L4FgKEq6EDt9TTHZgKc6kbwgkAIKz5V8FaSIyAbKLfnbFSLsc2H8xqGv6wzOpS15yNonbdCCl+Hw/jOQD9P7OpINBj8CEuKkgB7noSb8F6y8oh+ZIGJGimwvANepqc9H1AzWygCXpzTtcMxlZy1Ky1qI5mM5U14xVF2rnDeR6W2J8Kpzg617dwuIhFV7VPu3jNQvkkf2B0W0bn+ebPeC6VWNUcmX+EXWkxLaNqWAdMxqvnCAW8VuaJAGtRh5p8oF7lrtNwB3avyuN/QgF2TMLujKO4CbsQE68aA13hpEeffxQTjTk45MxNRKNbTfaEHd73IeFDOZtuFeyEQS4kkfVfg7cn3NCeMmzT2Nf8iaOFUVydur+PtHdErlUI4f3lPn4Pp4E+GSo/1x0BV100rpwENgS/dSoFhkMZ76uGOY8VM5eN3RelgbMxQwAEPpYFyr16wV8Mma5kQLE7HBS1gahDzPKo3nujaHY5AokB0/oxjAgtOnhZyuA2wimKkkRnofC/k5is0CoWwBJZrvSTfnsiyFJlk3cI7o5Y6mM8meNa9o67mi6e9UE7MxjlkEEajdD4Y6pX7BKwX5umFKhqp9oQFMeIUcjTjumzTyb+wo9wRdf+72CLHVbxSd+uE5rjUYA1yBpY2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DZqO/GMBB9MqWXNX+I5PZCz7GpNK2MsSwxk7+iKoAqBxgG423ARH0GxnLKMt?=
 =?us-ascii?Q?cboqQo2pwTcJojRrX5uZjIxIgg7QYPZPLXs9y1wHZe7WVZKzCXmXworiVGQn?=
 =?us-ascii?Q?TFVJtf4VXXGru0hy1cwE2utD2HnqT5z9rNqrftlbRagpokmnhHlKd53QLE20?=
 =?us-ascii?Q?qc7U6txTJMliXQsqO41qWhJidkBKUOl6eb7i5yPjaW/iFPErTGHDgNSdXVPF?=
 =?us-ascii?Q?oQR5SykPJnXvfrF5c0WRX0VSeSHFkuyuLHzwk9qhG5pxPHs6BKC1HyGbpUnx?=
 =?us-ascii?Q?Ljz8M1iGu3CHAQpIZCpKuKS1ayYpXp5q+W2/Biv12kC25XMnWkCK47WsQmDT?=
 =?us-ascii?Q?hlvbhi2FhqFYp/IFgmrX/dzmTmDdnkkFRzkWuy3ELR8HqNqG4PJaZ0hjVj3f?=
 =?us-ascii?Q?/nPKAWATpVmzITMLqnufV62tyHKSJMEpXLxxRx9FKXa9ZB7dhsAvMoXE2WFw?=
 =?us-ascii?Q?OHP/hMOasIUurCyWpPaa+7yLRE1f1NotUdIX1//2wPqJsTo+U5b1FlaCFmGz?=
 =?us-ascii?Q?+jaIKzAIRobTu+EriIKfATAv83SSiBOV1ApPR5Yd3o7jGr/+LfzZMNbd8KCt?=
 =?us-ascii?Q?BV3+4PwdgM9ZNmfWwWJ6p5cKMZ3PiE6Ec0gJWyapEFxAmp00TOqVfprjE4Op?=
 =?us-ascii?Q?ITCngoxKB6DAJCepVQejEvrxBEdbZqIxKS/l4guSfPRq0h/PDWhkdd5ZLf0m?=
 =?us-ascii?Q?OF/T4CA81CANnXgKwrXoNgdpfF9h2VBkTZjYkqCuFWOXyKhRgKmuvIP9yK7s?=
 =?us-ascii?Q?JLhM4rru4qfK9UZR3fLeWQNMDVhg929xHc4nSXFdDoAM50WQiqNfpkVRknE/?=
 =?us-ascii?Q?peB887lWWZD6JVLhwyyYzaAOKJZJds4A3AghrKbISMNLa92+DuXC1HmvOkRQ?=
 =?us-ascii?Q?kflk7TNAYysX17VOTFwTyATNRvlV+GOdk7A6cr3Cb9t0/uD/gooa4EtsbyFC?=
 =?us-ascii?Q?ofZlh48RvlrUUtK3AdF0coizlNdUn6aQWvqx5la3znAYN3ncGW6CR2NSKaPz?=
 =?us-ascii?Q?cx2LdHPLZKNJzXQiSS2yJjMDxXjti9a8EzHibA5hOOZnDNOJhDiIOmn8/r6l?=
 =?us-ascii?Q?ZmBJREv4+mGOZ9O2OD9+qGRoSnM2oMRSu5hPedtD1Na2kf1s8FYQImPEWGFU?=
 =?us-ascii?Q?2Os3pVk/0I6BPlO5TIDGSDYvRMucwF1PAyHXAyJPiIZflpsF24z6rCbuJCST?=
 =?us-ascii?Q?aOZ8vPFRp5DEznhWCxYMfZiGaV/O0gtlIOlaTe8I8U8yxW7Nj751SSuy51Gh?=
 =?us-ascii?Q?wlrjKCT1NpDfPgRsDjE1Qwnay5fezqkF36VkCYonBfaSKc6YTVx4y6LG2R4r?=
 =?us-ascii?Q?NT7x8vpz+Ayotx2xKQ3h83tIzD9lys4fPQTb1v6UI0pOTM0OAxR9KLR0n/ta?=
 =?us-ascii?Q?RYGrHNoL5RRtdkc0ii0Zr6qohTsJP0HXB/byWqdAsybP68B22hWGCq8ZpxUE?=
 =?us-ascii?Q?BFjnZ/Mhn0H8jVSduvmesMDtyFpDPvo5IomDS3DLwkJI2ZzXthXVYfk8XMOe?=
 =?us-ascii?Q?ShjU2KekjPQ0+ZfvtF+GYmCpSe+giltEDtNOd7CZ2v2rHe+nvXglPNFIVx2I?=
 =?us-ascii?Q?2nMnWW4x0XmXXbPOocXomDt1lqmxnZd+6uHseo0Z6b9MwpYfjhAvukwbDOQ0?=
 =?us-ascii?Q?h8NPbjoqYhf5XxrlwfPOzKUowkh6nMXWRxozwuI9lrfu3+8rFl5smX5zROuA?=
 =?us-ascii?Q?ouLmdeBr++382RmMdZUf4f5RZCPVDl208wFD6yvvfJVS4MdAD/gxtuB87Fr6?=
 =?us-ascii?Q?fK62HlRZwCByjCVOaBm+nyAZ9fg+gpA=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0eaa22a-83d7-4e2c-ab4c-08d99a031ae2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:17.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8F6l0dP6UUe8lAo9tsidkfd9ts8qyrL/j2ECas6WLX1ORxXNQYw4xXaLZwcHMPB8Y91CVeuRnGF72NN8E6hLL1w+WXF1pT9SnImlTFK2BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Save full action flags and return user flags when return flags to
user space.

Save full action flags to distinguish if the action is created
independent from classifier.

We made this change mainly for further patch to reoffload tc actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 881c7ba4d180..3893ffd91192 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -513,7 +513,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
-	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -840,6 +840,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u32 flags;
 
 	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
@@ -854,9 +855,10 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
 		goto nla_put_failure;
 
-	if (a->tcfa_flags &&
+	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
+	if (flags &&
 	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
-			       a->tcfa_flags, a->tcfa_flags))
+			       flags, flags))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
-- 
2.20.1

