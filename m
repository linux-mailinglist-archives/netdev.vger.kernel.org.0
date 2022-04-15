Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79132502A98
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349845AbiDONBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 09:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbiDONBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 09:01:41 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2115.outbound.protection.outlook.com [40.107.255.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6339CA0F4;
        Fri, 15 Apr 2022 05:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1mwsSWqcxMWPJ9fQAzHr/xZzgf7akY78cBjhxNlCad9J0Jk3XO/F5lZzjmsem1mFw3YBK0ggnH3w3VCeJUsm51vKqmTkYXTcqxh+yqjmXW2qwwK+VdGy9S9xUSQS21rrAWGJHdQeQnJ9YiDJNgM+Q50QrK6mL5qiYTfz83nQjORKFvFgozqtfOy74ltiz0XsENtr5p+RxgYCtatyWntoqjFZbtCLuI0yu4oC2+NIiZjODqyTUJlcYPRme2UXtNLJCjhmEduhQoCs7uWunlXrVGiuDcseamLpuaL66OM9S0JJmR2QOalwLM/p0JQZPNp5m2Hw6eQxD6dNhWf3n8z2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XJ0+rZEpZm625Pbo1AOKnqBYmgN1k75xwNX1itQ6Ds=;
 b=j4VvruaK8C+cm1FqByqlWx2VqNgTjhUj3K1AMOtWaOwfdUiK6s6xMCKoT8XueZZPAqNpMuYA5GxVNN3Tuqz4FjT6aX/+NvfFsRiPwzjS5RS1mvAwwp1WF637oWc6+JlYeoT5NTUz4kRbbqszGz1MYTaFl528UrurFYFlCO7a+8V9nWYHhr1BHvF3cNpFLklZuMl8LpEzYXZPoOsJx/b4KzHoqTePg1XAHn2PBDnbDZuAzSfZgzJlVpGVA7NVlo+M1tbAaEOby85aImsgMwYqr5LGQ22Axuar1lqhPHc6z5BQsT5osM7p+Ov8k8ju16VLjHuOc/h/u139wM7FdkzLYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XJ0+rZEpZm625Pbo1AOKnqBYmgN1k75xwNX1itQ6Ds=;
 b=UYT428jpPFXjvNnvQuGmtpdpP3ZyhVQGR1EYI4+qOs8micwikaf1WJQ7dvbKe6kXfkRcJi4VJPzwUQke6dsNllfnjzY5O1+OOOl8PC3zqy9VmI3n+cfvw47CET7Aqxg76lrMOU5o16zZ8IqMY8qrGrYwu6W5sE4EMeAa5R+Vz5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by SEYPR06MB5013.apcprd06.prod.outlook.com (2603:1096:101:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 12:59:08 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:59:08 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH v2] ath11k: simplify if-if to if-else
Date:   Fri, 15 Apr 2022 05:58:53 -0700
Message-Id: <20220415125853.86418-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2331a2b-9160-4ac5-3625-08da1edfba9a
X-MS-TrafficTypeDiagnostic: SEYPR06MB5013:EE_
X-Microsoft-Antispam-PRVS: <SEYPR06MB50134245105144D77972E374A2EE9@SEYPR06MB5013.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxDoJwl0LEFXutK89PCBs1FYyZ8m1FjwGoIztQjAHPlkAhkukrwIujMdgW0FM4cWSvMs3KnbtROdqaQ2bxNfLLcfRe+/i8LlQPzs2dS/8xBWUZLpRo5WbKHDZsZtNmU+YcXYEa/HBISe0QohOuSXXzpBtgh3cWJKJ4ZPBcJH/aSEERnSyb0j5UEP8Hoq4hKkQCSRXf020vURumo+Ghhd11ey8pETC4DkLQPW2b7n3Zi7ZNpMlmBryXW2Z267XV7Y6g28X0MjqEx8h4I4SnzbyFaANfbGhGhj57Q53tniXXwaJJXrL0i1m4sfLpYgwoNZ3FeDxzrHBfL+cK8L1tt1xU0rg5m3dg2VzDxkL/PIq1wzXRsItZWGdYYUfnwYxScBXZQJlZe9lBnK4seALfl4IXpUVJU2TLUFft8Zjf6YlJp2Ll/G8LT+OGWV2cfJMVlkxDHVN1i5ualBSHAvTwCvfVhsMrVawqxVva1GDBPYxBXgYcNhgU5wisKYCO9hN9VzSds5/yruVemUra/MwM/1kTqK/8FiJQ043ce9Ic/dvLPQAYTkN5r6H3kBb1VbvNAAwaHpxhiX4nFrWjaOW87X8UeN8t0tLiFyhx0mdde2HXATeAfT962aq8BQLlzzu1oZiGg1yBcN/8O4cw6OMu8Ysx02+a/EBhT3zJJY9pm102DN0on5xzxGZJvqnT4obkqCzfcOfjtJUqWr26CvRMe1SbUT6tljnhqhd7BwEgxgOTeN2/d+Uybedkow4AuAtj4Ftc3a/ebKYQQfJk0z8SQmiNpUu02duwdWLgDDaGeFeAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(38350700002)(52116002)(966005)(38100700002)(1076003)(2616005)(6512007)(6506007)(83380400001)(186003)(107886003)(6666004)(6486002)(26005)(8936002)(2906002)(5660300002)(316002)(4326008)(86362001)(66476007)(508600001)(66556008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NUr2jmoAKwngzD8NOw/Cj1hCx/Rh0i8X9g237f+slc+JUC+hNNcHCCswZlb1?=
 =?us-ascii?Q?pKQ0mxTVVurJ3nF5Nh3+nMtqihAUtU96/oFggQEjWiwAxxTwe1H76gHbxug+?=
 =?us-ascii?Q?SiES+ftlY+egkibjKJRY+wrqE9TlwXzWRa+3P7bloyeTP3hcEMdlHRQik1Mc?=
 =?us-ascii?Q?9g1U+sosYPKS3qEytrUMOKKYN0uwnNL5HKWCWDsOC2nrDL2ZCB+rMH8kxWcV?=
 =?us-ascii?Q?A7c6TOUZ9tnh1U+SseCBa3Ndtgfl/yAntpvysCIL8k/3huSPBtdRGa3SsCMr?=
 =?us-ascii?Q?G8m7EvPkaJ7eWB+LK2GqnuuVtCFvzqYFSzj6N5E9x1JUcMdS89EHgOQyMCrU?=
 =?us-ascii?Q?R9k0rpwvvP+uQ52NP4MLOx57031T0BR8uVmtr4Pj2xR36hr6fJR2Ro6QdRtE?=
 =?us-ascii?Q?YfbbaIR4wZoMj6Zn+UcD202MJKZ+8kuJ+lwy/gPt4uGRd3JbAnUnOYKsXxw+?=
 =?us-ascii?Q?14dKEjooEg1Pn2My262mxOmZd9wLKUcM9ZO3GvkKSafZA0tG5aBnGUTVod9A?=
 =?us-ascii?Q?RNu9oSUnXlcnGx93YfUrj1hsP5dTCcqxhvyYZQCOoXBYJuVahkvVNoCRv0rf?=
 =?us-ascii?Q?0AvrB8bmx6yyELvPI3OxCCs4K+8wspgaHvxUXbIc7zFv57F4909pMrZX8eK9?=
 =?us-ascii?Q?iBlnI8VMqKEb5OBPqIEe9HkzTQv900ujUoBZtZqDzgSMNaKiq03/W+YNwDAh?=
 =?us-ascii?Q?unmCg4Dcinj21L1YK/ohHlEk4YbqbjLZJ747jknLzjf/NN+jK7gVIG4PACQP?=
 =?us-ascii?Q?e+AsUwbh6YTjfFXTA0JhmWREJDX7kugRiJO24TUR0SmpktSspjKOrCe/5IdV?=
 =?us-ascii?Q?D2DKgNH1odYerulilc9XML8bqhG/MLInP+MaS6WZXREjuz8RIVPz/BCPfgaK?=
 =?us-ascii?Q?95OnPZeifcLyluYfWe2gnPo4dLeZQIK9WqmIWuDSuXehJBC2jbLAT8dlx1rw?=
 =?us-ascii?Q?AfLFrIICPSfFdIn0VP0saz/Eg4cVcv452RMeWJ2LWPqeFMXhRRcGRtLd91L0?=
 =?us-ascii?Q?WOtROJ60PyIHTCxKT38ZBRVNjq2xo3g2cmHBHDbM5G/KKKV8EAnRgxCzJ4kM?=
 =?us-ascii?Q?o+DybHjk1ANyx+9vLR/oWZow4D2tKmoyuUhE2QicqZ3mGTQjtfYSlR2aBkmZ?=
 =?us-ascii?Q?SWoG5flBSP56bh+nGwLpMLV8Isro1Rbj4Ub040W8HTTtFxRDiT6DmI3w/7En?=
 =?us-ascii?Q?wpBL7uZ/xuztf/X7ZuVPlK+CGoUA5TFaP1acj6iKXy5YsrUCnUttos4w86IE?=
 =?us-ascii?Q?1WoZtbq+lrEM733KqeVF6Izsqda5KSfZiLRnAPD+p/6IDr636LeZicWuqT8S?=
 =?us-ascii?Q?2BRfBFRG75DK7EJTnqxXNShqJgVq6GbTgdmvv6dm3I1RmYgi9VYlVkzh4fL4?=
 =?us-ascii?Q?y2euRyVgssUm11hKh5wOFsXMuJsjfOHTF/M9dscpLA6Tqx0DQhDYOhzRqZeH?=
 =?us-ascii?Q?okRkUTmATdUZiH02EkBZi4kYvK85QuP1jqPpox66YAbYVlug++bbohOl/9dQ?=
 =?us-ascii?Q?EmbjgQCeLqLHrK29TSR/tA432aMrLvFMnFCaMXnzsLbJuF8jHpZtUo9q2whA?=
 =?us-ascii?Q?GgU5uXsfiW6EE5jBraTkCF96Nhx/KEDR1UUlRCgHd9GbaddafRniuhw3G4X1?=
 =?us-ascii?Q?aLoVVF5MsvxDoYgNs/aB0Vl/kyA0NmxO6bms/V9GY2vPAM9hFLU2nnc0Di9V?=
 =?us-ascii?Q?WYBuGO+439dTFT2lULPq0CoDXn2vZ+U3oELA4/tNyWzt+aGbWEpbxJ/3P5i2?=
 =?us-ascii?Q?1C2UIyQWgQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2331a2b-9160-4ac5-3625-08da1edfba9a
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:59:08.5586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F8ISDJfWJhnbECTeOiR4DnTpyWucw4ZIIhiDbRHee077T3kddZJGt+xODZsTCVdVmK/xPiJdyfovjp9r8vjqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5013
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace `if (!ab->is_reset)` with `else` for simplification
according to the kernel coding style:

"Do not unnecessarily use braces where a single statement will do."

...

"This does not apply if only one branch of a conditional statement is
a single statement; in the latter case use braces in both branches"

Please refer to:
https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
v2:edit commit message
---
 drivers/net/wireless/ath/ath11k/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index cbac1919867f..80009482165a 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1532,8 +1532,7 @@ static void ath11k_core_restart(struct work_struct *work)
 
 	if (ab->is_reset)
 		complete_all(&ab->reconfigure_complete);
-
-	if (!ab->is_reset)
+	else
 		ath11k_core_post_reconfigure_recovery(ab);
 }
 
-- 
2.17.1

