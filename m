Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E57682878
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjAaJO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjAaJNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:13:55 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1298838643
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:11:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emzf748vGn167LI7ujQPgX22lk66lKvOH2yZgE9nyKWzJ//2UgTXdzSFVQc7w39U4UL70utZCislKbja/AIrTf+SwcEnIY+CXESiBbH2mdOjCk0QDRxFpAbthqatBGPthcm0A9EItV6zjnsQwou0JuAXcq/gQuPR8Pi0GW3LtfiGaCJaFXTcEi7rI2wIEOBcbyty7xeD0Y25XuoHf2HvhJAQlEqDmpWt7dU64HkhS1LCKzYO4iXr/SFuxcNjqCqel8ivi9chLONncqbH3NzB4TStFxV3YPz/E/elh1MLpTstou2G29eZIASu8LeBfOtDU4LK/ot1NtFdeAAcg3L66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=Ur3JMBzXcpSioEKu9e7N1d9R6eLoYoe5pPu07Rkb/eGZ0BeESZ0qGhySZCelcj3klQvceBrSxswiW/a0U0BlTqaqsB3ksDuGbI6n6j3xoMz1fxa5MJYMa63qUiXFf1+XwdM7AFUjUkYqg+w9jBZUPBFVugL9Ge9NeIfwbWrfyG5YHbOpC1KCsEoRA1I/5uTUkoXAp7UOJU0XkOW3RYiDrLVnwRHBIHeNKP34VXc3RXx05bwl4VwkHNUlf0k+J+QnU2z+F1exPZbUTjqt1/8jJ6pO6aCqGUvbprG6vsPMW55fuIPtX64dIAFB9aFmv9TellUcRkRCL2zq/EaHb2p4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=N6xV5NA0RRmeyy3sq768/D9g02a+9AKANJkTZJ/gpOGfa7pwidrofE+Di03usuqzZkZpo0Q9izPNGPvneUl1FdiaGUZuMiR39AkaetHM4vCSX0X4ivQyUcADfrJ36y53yX62A49/sr1uabn4ah/kz4JNxr+GJO3uWl8y1sADQHpTgjjL6mqzKC6R+zExI+g3b1fPKt4pCNlDGU1dhw7k43kg985SycG+o+AJtPZCYD66PaUWywXEO1/J4vTvotoyRpJBQXv1/rgv+8YpWO7vuTguGFYW3CySCj3c63wxAHI92QrIkZGHnwesflbLotEeaSVXKn7BANRIr6FoHEDvuQ==
Received: from BL1PR13CA0306.namprd13.prod.outlook.com (2603:10b6:208:2c1::11)
 by SN7PR12MB7979.namprd12.prod.outlook.com (2603:10b6:806:32a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 09:11:09 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:2c1:cafe::f) by BL1PR13CA0306.outlook.office365.com
 (2603:10b6:208:2c1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Tue, 31 Jan 2023 09:11:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Tue, 31 Jan 2023 09:11:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:54 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:54 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Tue, 31 Jan 2023 01:10:50 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v7 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Tue, 31 Jan 2023 11:10:24 +0200
Message-ID: <20230131091027.8093-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230131091027.8093-1-paulb@nvidia.com>
References: <20230131091027.8093-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|SN7PR12MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: f7957cd8-1f86-45fc-f3a8-08db036b172c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otg4f71Cu4245GE+GPpsQsvr35kWMyh9cxi/xvsSuSVoQzlyZBg6BlJthgzrko2MQ0CsrIpAfq92bPjGBR25WWNan5rBC0VOj5c63fpleJTsVfJEb5m/I4rApwrzhZ9gLsVheirVZW8p1dZ6yqV+RiOYPlIaGuuBWqmbkXimTk3LXEM1VsyFZpthsoRUl8p+wXkrppotut6WxDQ9/0qWvuruj15hHjBbRQJwjD9qLUrzL8xevoR7bAMGOM8XmV19+3JnjN/ZuIA2+Tb0fU+DG0RFC7IhMChVUCEFTxW7ukniJjJOpFIZWh7zjtTLSdOVqRd9nakudrtlmIgKkiVKkLk9cpfgmwLQbfMaP1WuoLg+j1Ik62PdR9G5cYj0K8TvmKXxC1iIxJDvmh9QPlOSMv6m43phu+T8wn1WqzrLa5WDk7SiaMyfwJcnFAz8sDyViTLfzSc7Aovu3YJn4EHNOGCm1SP6lOpH7iRbrmVXLwrdAxSTdEpv/vsuZArtpTWUTprzMLCAUhtzUkxynjy+xEOg/Bee+bBCTf3lXWpTmibbutcjZ+ViEwZIPzb/jqeTVEgBsas5+c3nQ5TU0kCb36WutpmGEK38p/xdV2hU685sPyV+PuKYQ+/9JbM0p7hkmr65xXI2zURpcaAad/hOqOSSf6BMt5kh27F4f7BLawZ918sGiQ6TyfY9ZjGxAY9qntrbxF9hsK5a6GptRTvP0g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(83380400001)(336012)(47076005)(86362001)(2616005)(82310400005)(7636003)(82740400003)(356005)(2906002)(26005)(36860700001)(36756003)(1076003)(40460700003)(426003)(186003)(478600001)(40480700001)(110136005)(8676002)(8936002)(41300700001)(4326008)(54906003)(5660300002)(6666004)(70206006)(316002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:11:08.6231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7957cd8-1f86-45fc-f3a8-08db036b172c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support hardware miss to tc action in actions on the flower
classifier, implement the required getting of filter actions,
and setup filter exts (actions) miss by giving it the filter's
handle and actions.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 564b862870c7..5da7f6d02e5d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -534,6 +534,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 	return f;
 }
 
+static struct tcf_exts *fl_get_exts(const struct tcf_proto *tp, u32 handle)
+{
+	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
+	struct cls_fl_filter *f;
+
+	f = idr_find(&head->handle_idr, handle);
+	return f ? &f->exts : NULL;
+}
+
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -2227,7 +2236,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3449,6 +3459,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

