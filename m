Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC54C673F
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiB1Kpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1Kpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:45:30 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2122.outbound.protection.outlook.com [40.107.95.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A402D54F85
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 02:44:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy4dGUuqxkhyNU1oUbc9LHv5TDX9iZYqLhdRmVc1UGJJdV/ThDB852oYFHF1stdQ11Jbfnhq56dTZW62KdwNv7gMitjs+dj1ADxrdbX0eAyRqbULFCgs6detWBweH6z5niJP2K7ISMdIwHYresFk5W9gySAsGfstoayAJj7ikSUwj146a+R33mjK4wobV7Poh6NW9ffFkj+8YIXgsQqbZD1bWDryrEq4mipbPEWe+4ud8DkMYOj7I/oECfhcOONzcXqoKe73hATK5Bg/dSK3O1ugwwewA2TaCOMCmxyIDBNh+4wAK5o7Sy2Rrqj0pevPfMb/jEHlf9r5wT/KXBUOWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRJt76SNeun8QukpyriQjhr/InOyCHYPxR6bcFmeoto=;
 b=VkhdpGRUVBsopjk+BUCt4hEh/nWTM6YM8EhmFN/8LPJDgo8/mM+Ar5GKVr2DMxDdg2HZgwf35/xVgF30wwV/O8DcXxNCnZf8rGlwpchiIya2CyRlJARv67dGHsxZcdzhkGFgzwM9tdhU5OhxaWZ7EHwOUzfDmVfPArRoHNn1/+YXQ2+NX4Y3Imj+eGAz+s6yYny5IYixarpub37zyDlz+5sQijX5eawSpLR3CB3ehaJPdey9wPPOq/klxQFkPiARiUR+g+mxubtZTTas59P9dNzh7vigLqhv3mWJlzCPPPQTwd0nfuOJZaCyfY+H3NpgTMe0XY1C0dX2m6hVI0Hn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRJt76SNeun8QukpyriQjhr/InOyCHYPxR6bcFmeoto=;
 b=hZwkutMtCQAJLM8yk4yNKqkgpLDh7+A1LwReohx/Uj28xruxKQNuYuLpTBhLLy80LjpxCV85Pe52TwZ0Bi7xuejYLD/e+MnoqvLrCukxP9JAtJzvbBwGXJrD3h5n/kVDuGtdPEOdK9g5mwi5A8bPjwarku1hkUgmvRab7YkM124=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BYAPR13MB2293.namprd13.prod.outlook.com (2603:10b6:a02:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.12; Mon, 28 Feb
 2022 10:44:49 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5038.013; Mon, 28 Feb 2022
 10:44:49 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        roid@nvidia.com, oss-drivers@corigine.com,
        simon.horman@corigine.com
Subject: [PATCH net-next v1] flow_offload: improve extack msg for user when adding invalid filter
Date:   Mon, 28 Feb 2022 18:44:15 +0800
Message-Id: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 2.5.0
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0045.apcprd03.prod.outlook.com
 (2603:1096:202:17::15) To DM5PR1301MB2172.namprd13.prod.outlook.com
 (2603:10b6:4:2d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 154a7eeb-cf7d-4369-7765-08d9faa7580f
X-MS-TrafficTypeDiagnostic: BYAPR13MB2293:EE_
X-Microsoft-Antispam-PRVS: <BYAPR13MB2293B15B91B64821491B319DE7019@BYAPR13MB2293.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UYUnar+3r/vDMqmFds3DGtbEdxHl7iL5z9K5GtyaY7kQCOtiP38V7bdKf9NyW5XpVYYlxZOT/thvLnpZ13+hup/OCLZewhFIidgMjFTQdYROIs+deKUCb5EwHmyVO10qUxea1I3KZYifSWIEiv+iDHgL/NEAnfU95esAUdQyL9LgQQ1nGQvFC2LAQ6ghdTK94qqgVGVMCIh3iwKxbVnohRqZ/k2UDdLZAqdv5GAJ2yNa8HKOcobZvj0AQLHDf/eX83KZXQQ7LvHmHaJYJo9TSnfDMYyeq4kamcF623v2qIfPQZUXqvEQLsG0iZdGkGiyMFNzk0yzlGqvy7RHNYAGu5kgKGK22ceYMZb3m3OxGIJu3BZjlqoPpKM6ffXF2K4X3CxKxcwnHwlMFg+q+toXGC8nj2aLNOOmIJF8l+FGBDxfSlF8AUjyEHythJ6nKXz9753JtXoeOp6via02ybUCRznRIR0AtMxy6ozUixmJAdoPank4uoVcXM7z8d3HLou8tbh8llv2jrxOTFclxydQ9jtN2lL2PFaL9jDEVdQCrUlPMhKZ45cxPbkXOM3KLC/7TZIwi3YNcs6D6wlvvJ/hF6sAjjNeitIAu08BJL+CDJgRbFmgTaTOfOp9q26jzJBPbwudJcG8qyD9HAcSztvPsi4cabHMrovExjvI48JT6g59hq9oU4eFwyXe0rXk//PZ3bEJFVId1mxjF1yOt3RzxTx28Mhvw5sTFlAUlfEQyyW9FpKeCIXh9Y7f/tj+Huq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(366004)(376002)(39830400003)(136003)(86362001)(83380400001)(38100700002)(38350700002)(66946007)(66556008)(66476007)(107886003)(8676002)(5660300002)(4326008)(316002)(4744005)(8936002)(44832011)(2906002)(36756003)(52116002)(6512007)(6506007)(6666004)(26005)(186003)(2616005)(508600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A1hmablouWr3Sx5+DIVlRfLxvBDGDtMw+KNHremuJgD6nPcyUsk835aBqk3C?=
 =?us-ascii?Q?faSaVASmE8VjrI3pAtxKa68iSUgECshDCwN114n2mZBnCWQcu6lZvoEh+axP?=
 =?us-ascii?Q?Cngv9kc4NejtPacgvuLaCKWI0DtSmtraz58gzXlE7siebHvlQtTprua17r1m?=
 =?us-ascii?Q?WIHKvXGLSiIW/fRjdeMl8f5n8M5WmHoYPXBdTRdfqL8BEce0Zr67+F/4T4+S?=
 =?us-ascii?Q?8Ep9dM3z9ToQS920oH2zhhvQfLgcx3UVBtzIUcx0ro7Ku7bDKJ0XpsVDBnVA?=
 =?us-ascii?Q?7BHFbrkagUyyr7byYkOPOCMKp92CbFUwXphEO4tAimMSHq9XqEb2bLIp8ZI9?=
 =?us-ascii?Q?edXob2DvaTYWUs4Lm+YY3xhyzmBqO8EtOFdNWAFbAwwG76V8w7ELZ9f5dTtZ?=
 =?us-ascii?Q?whdJkvlz4PTjYRQ68htWKvFqX1lcY4KQRalmYYt7jfL9bLOJwrUcTCBXxqDB?=
 =?us-ascii?Q?j6wlItxskXd2EQhcUPH94/VFTCrx1vAQ0h36WIUf4KvX/dtS/gwkIE05CjvF?=
 =?us-ascii?Q?P0h89ozqL0HFrZCRnQE5On8UFm9pF9p2aQJWNnBxCOn0UlBPABQCz+Tl4wRe?=
 =?us-ascii?Q?DKKFUQTZAQYJQP049NmY8n9z2fe+ukch5RaiosBhU0MkuW4D3BudRSuunik8?=
 =?us-ascii?Q?SCHgyOsmcQ2ahjU86Z67ERUzBBHz2fkqe6FkSpCsPWAMBMyfJ3OGKg2KSXI2?=
 =?us-ascii?Q?IhRWzTrpMLFbWDWJziQaFmDf7hhbD64SwtWdC+QIPiJh93Wg06sXkhyPQfO+?=
 =?us-ascii?Q?2A7N+Q9Mbx4zGXDvh9Udq2xK/kUyazzUWg717tW/V27k/6D6hRgMBJK3vtel?=
 =?us-ascii?Q?ZS94wsMsjnwZ5BT0fJeoi+IcV9N+N2C/Q9P3F1r8TyFBTMFfphX2jfWIKcBx?=
 =?us-ascii?Q?le/k+8ol9vpj/JCOoQQRx2U/YQphXweV55+YiM/oITfJixM4OdqsPA/piPDM?=
 =?us-ascii?Q?GaUsPV/h31r5DyRehzag/vkUUNLIEy5z8wM7rXvt8Z9ar1v03tLsOmwo7yDa?=
 =?us-ascii?Q?NbEnyf7pjUFmWhUQP+8qXhz7e8c5Nl5Xy4Ev4d3PFqlcW0pRJO9HDMN8lEcU?=
 =?us-ascii?Q?/g5d+BR5AnnLr7qB/C+2zwC9aSJ55ixCcnsCN6K7TZk6NeS+WAFody0d1q0E?=
 =?us-ascii?Q?kGm4IqW0Df+/p9/UBwWza7lJEzZsgw7r1pIfWWek8bqSDd0CyKbPAWKZwZUU?=
 =?us-ascii?Q?NgrS5SM1z50r9H6krLe/4qKAY4nxVk4G5pS/wESfSgHl7ExKzE5dtfaLXVYC?=
 =?us-ascii?Q?wIODfBvIxKgqWMnjhcq3cUN/+Bgb0xX1K3/1SoAoeCABWw7geOJhwqOl71zc?=
 =?us-ascii?Q?IEKuajJgof8zXns0ZY+D5SZNPZUI9Q6LNK5tBCdYQ6dOskzMMjwRh/8T3Ut6?=
 =?us-ascii?Q?lsLmV0QsU94kg+VTo5S+ZK7kAEuLjhK2cWqoDC4k20aPrhPXdX9C+tpOcpV4?=
 =?us-ascii?Q?4aL6EvHzf5b00+yRq66npBkJFCUM6km4mpys2cqL4nZ3yj8x5FEI+eQUoSPT?=
 =?us-ascii?Q?eaybPpyaJSJUsV9DEM651EwUvE5rFBhXjoWvetnwoMGWAM06Txl4zydCOyxd?=
 =?us-ascii?Q?FwgfXGqxxy5fV7o5ifEsKFRU1BiTFt7DgPSRtOqikxThksuNqhjrXtrTXwz/?=
 =?us-ascii?Q?AWa6xnASRFI86KZOupaT2atPYenAuHCXenMCLkyh97QeLZnsvkJ/HeurWylw?=
 =?us-ascii?Q?AY28wQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154a7eeb-cf7d-4369-7765-08d9faa7580f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 10:44:49.6964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MRN6M323OiM5WMuxedPl7BJHCOC1Q9G+BJc37Z1SKLXimvYt8wM672USplpc3E6USpIvBt9eiAfEMZOrDpK6L7ZDYAy6UjNSnQXJ52exL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2293
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack message to return exact message to user when adding invalid
filter with conflict flags for TC action.

In previous implement we just return EINVAL which is confusing for user.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
---
 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ca03e72..eb0d7bd 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1446,6 +1446,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 				continue;
 			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
 			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
+				NL_SET_ERR_MSG(extack,
+					       "Conflict occurs for TC action and filter flags");
 				err = -EINVAL;
 				goto err;
 			}
-- 
2.5.0

