Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3418A1DB
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCRRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:43:16 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:49028
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727301AbgCRRnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 13:43:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3V6JaHF9LV8gxVMg91FAOVIOTxyn4fAK/NWV3loPeiPBJc/E3AjixH1ErWPqq2ikPoUto1wyKmifbMOTj7Oc16It3hBoK9IQRIGoPIPYXcIgvqL1vSml6ssU9s5g7ntDJXcgXKcDFONF5jjnzflshKXpehBd0BU4O8Rmxi8qMNlgrH0DXmvGW3QEogIfxTbi/sjcfQvLUO4HVhEnboKCvEq1K07JX6EnMGXXhLDuiIE3cLF1vLA5p4B2SHljej7w6f2lYAyCzCwwx3gLP7Dsz6g7+a8HDr8Q7p4Vv5RYC8HGAz+jzaHeUIPppALiqZUq4yMUugjcvlQ8EJb+1U3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54TTxzNq+OedpnXp5du7xTQNdyNv1fc3oa4bgNIW8+U=;
 b=nd1im/iAfkh6ZPHtdapQeJLBlWbq3JloCu4cRNKtWpQwJxh38r1nSXSBjJcqrGAh6g5IxTDIvk5E7Bkc80cO6u8GHUDxummbmMMMHUvINayCDqhY3CmxTJc63+8L688HPCZQgMxOldPlgKzYKKtGyH81K42eO0wtqiHxMfcy8xOh9EjVveAe1lr50KHIwNAVkVFHyAWq3C+bduEhxFXcb8LrLdg6tSq6YflWklNeAchmyaCwzuI4+kZZGyLQ4V9KazkqDcCjSkWDVMUGvQo76RJo+L+g03AG0X6flwME8X9NtM8bQnmcDT95TMXM7ujX/y+HUd9aeCrDwAqtDIE0Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54TTxzNq+OedpnXp5du7xTQNdyNv1fc3oa4bgNIW8+U=;
 b=Z8OdZn2GfkbA2wHDatkT0MFtW8hK45drpj3rci73DKbGMmPV1HA0EGiG9oAcW6MH8UGX3kaSo0AuCJDBUmJx5yT4DbdLah9ELdvCZNPnaMA+r3zmnv15iiALzGt+HYRjaEGGS+z13f/cqvpgJjAJDAUq3oyaRa5T98NOCicmOxc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com (10.168.18.154) by
 DB6PR05MB3511.eurprd05.prod.outlook.com (10.175.235.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.23; Wed, 18 Mar 2020 17:43:11 +0000
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651]) by DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 17:43:11 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net-next] net: sched: Fix hw_stats_type setting in pedit loop
Date:   Wed, 18 Mar 2020 19:42:29 +0200
Message-Id: <20200318174229.25482-1-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0010.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::22)
 To DB6PR05MB4743.eurprd05.prod.outlook.com (2603:10a6:6:47::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0010.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Wed, 18 Mar 2020 17:43:10 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 51051e6b-91ce-4a20-14e0-08d7cb63d3aa
X-MS-TrafficTypeDiagnostic: DB6PR05MB3511:|DB6PR05MB3511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB35116B492C9C95340F0E8126DBF70@DB6PR05MB3511.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(199004)(4326008)(5660300002)(36756003)(6512007)(6666004)(478600001)(6916009)(86362001)(2616005)(16526019)(186003)(956004)(26005)(66946007)(66556008)(66476007)(316002)(6486002)(54906003)(1076003)(8676002)(8936002)(6506007)(81156014)(2906002)(52116002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB3511;H:DB6PR05MB4743.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yq/7z8Z/wMlipUcWfWEDVirbQaUqZKW+uTZY+l+GAsTZDt23gFmalIo6+hKtEidzCz8fo0dcADAlSyT9TRRJ7J4eAgCKRb1msM3yMw56KgIqs+G2VV7MwiQqbfZP7XslFkPj1RzxPZTLbCatv0GbN1CbJinRcDg7CBGrcOju2bvsPnM1HTRU0LuybTx+AzXnBrJ0xRf1f14W+PqRUKO/dlzOtYUbDxkvgsv7BGj5MSUgV7UztrfucG5TWjn6vrVf3bpbfy253s5dfAQ5n0dF94w69ghW1ZH1oeTJGfH10icutGLducUbwS9oN5QRZl/FiYPJyAYCfQpHY+UF8NLvA3NMEOq3ZkTrCxMaGMbz/pwdidGrJgOew762WBtzPXfptW/70RErIoPWxG6/nOEJBEObFBOS1RknVmxHV82a3xD5UYz0eYUnoklVRJUUgN2c
X-MS-Exchange-AntiSpam-MessageData: 60wTrcHe353LwSEjLfJFaSM/2VHjPBmDdffvtaLhfKgf6vNwz2aRHtz68qUeR8d+vrL5ojHnTci6W3jl+un9sNIDRHcrlNuz37SRKOBbKBuiDTfHjIuRVm3Es2X/gzCKRiyqKq10oVVB98xoJgH/Ww==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51051e6b-91ce-4a20-14e0-08d7cb63d3aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 17:43:11.2522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMchdrJ5pR7rvaQEXZ8SGWW+qNaO7E2XfnFpjv1OLlANxxMNx/UmQq9J8i/mvDZaa1lmngqylS1Ae0Jq7KqGvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3511
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit referenced below, hw_stats_type of an entry is set for every
entry that corresponds to a pedit action. However, the assignment is only
done after the entry pointer is bumped, and therefore could overwrite
memory outside of the entries array.

The reason for this positioning may have been that the current entry's
hw_stats_type is already set above, before the action-type dispatch.
However, if there are no more actions, the assignment is wrong. And if
there are, the next round of the for_each_action loop will make the
assignment before the action-type dispatch anyway.

Therefore fix this issue by simply reordering the two lines.

Fixes: 74522e7baae2 ("net: sched: set the hw_stats_type in pedit loop")
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 259a2e51ef3e..ca46290c5809 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3613,8 +3613,8 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mangle.mask = tcf_pedit_mask(act, k);
 				entry->mangle.val = tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry = &flow_action->entries[++j];
 				entry->hw_stats_type = act->hw_stats_type;
+				entry = &flow_action->entries[++j];
 			}
 		} else if (is_tcf_csum(act)) {
 			entry->id = FLOW_ACTION_CSUM;
-- 
2.20.1

