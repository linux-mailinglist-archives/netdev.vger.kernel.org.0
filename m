Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EA66DB595
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjDGVAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDGVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:00:40 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AAD8A6B;
        Fri,  7 Apr 2023 14:00:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLoXAXVVUgKTVY5Larb9etG/rsQb9jtWMHDrzOy0DUVSKCZ8M7ueSkgZUbU2KWhk2Q5G1Kf7VB3epGRfEV2qa98CEgRWjIoXgEwD3OEUbmKECvH+2Auy4oDvoko7GC1Iz0xwlfFuh8XMxHPGL4YErbQOP4CRhdoob1TrT2L0c0W8ZQDflraUjmwzFun7DIXsRS4Z3TDcZj8L+XyvAa0jZx9Na6iejbMFnUp3dgFTIIH/R7I+/wQ4+dGskLaseNR42TRgLkr5/bGeSBcuwfQ/c4xmu0QtovL9KNguA8tAYJwkXqh+Jy96PVsH1xz/gk0vURYCLfWoqO/Q5fK9DKhmXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TufQZ6K/gOT/Ch/sTBms4so5EUcXvVR411OWR/FGhEs=;
 b=Pn2tLxnNPR2fjdqMLfJ5lhs7crzivqKh5c7QPn9lqOhJkh/G+nbi9x0AP41+IU8c1NCSLr0gj6RUBSzOtYlRySK77u2nuET7bYRYbxDFRh4Ce5w9kXLytiW6W1u5aXSih9mlYqFUePS3sMv2Y531MZ9gxx9Gho3/gHkdwAxQyxKH9uXT/ClnHH55AeyKiUM1aT/frL9oME4NXerjVaRZAx1SKw9iyILCgMjZhflCGzbOmXLk9aiu6xbktw0lkAqICt5Fs1Dl407lA0JAmyhjOoYTHTk8agjXd70RNFDn82msyTrz08BsjOUI4A/ijqHkeSi1G+WTIDcabx2f+zhuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TufQZ6K/gOT/Ch/sTBms4so5EUcXvVR411OWR/FGhEs=;
 b=ENDolZDDfz3r70jbwpP0cePs/LMwllSXFT7yHWJu65oX7wOZxlZs/3loer8AJBTY0sKt2p/9yl0yeSZzCjEh7fsmQ8Ng0aLY2FsxDIu19xSOh84msJQQXJndmjazsZcogxka4s8PTN+fvW9hEid0wZNH3+1O/JMY0lyaiyDAZSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by PH0PR21MB1895.namprd21.prod.outlook.com (2603:10b6:510:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 21:00:30 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 21:00:30 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 0/3] net: mana: Add support for jumbo frame
Date:   Fri,  7 Apr 2023 13:59:53 -0700
Message-Id: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:303:8c::22) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|PH0PR21MB1895:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e2c967-fcdf-42ab-e59d-08db37ab1edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UHyMUOq6BjMCy5QnMqUHjBQL1OIHJat735IRqtuFRQQ08T6uDTF79Rm+B9/1EHxngcwSx5PwS2RrpScEKx4/4V8h+MhZwMPtKC4uGqomSHkRMIcVTmNCmkUqfj0lgZ9lSoNfCMMGdKAsNn6zgz7J18+yX+Xf6WlX+araG366DR3YWk7SYOUUfEHftEeW0Kv/5K1hnptyg8cuoGEzn8SRXdtCC9als/52B240053rK0yyp3rUnCAuvZEend0O7UdTsnS72qbGRhcQXv9ugnEEOG98OnWDY7nqEEpgmTZrjtQL4UbxfvCLxciuArZZ66cKF10+NiqKfx/NLMnCzAcj9Qv7wqgU357ahtA+Iqg280Bm41Kd0Z6MGLlpZ0dKLSTi1NpJLt2cXj/eB8rN1tDWLUST7GlS6bmSWCqBLtabRi4z+chIt+MbI7akxuqStIIVaQAkhhuWWONogt+Fn/VkwRe4pHy2Dd2rOz4lA49V8mZUfdu158bc6o5lw8BwHv74ZVQM+x3ygAABeh2aQaGkZnyqirsfBVWC+70xPU8DHAiOkASkTiWB+jnG61zPpzvKsAVZaSibv2K95GOD/R7eTO3Heh8xmbwD+HUpTirsJ/jyCoilM+/+6Nlg9HSCJ7nCH+d2JYT74vTbw3pJuEF1LTsjmRn+r9MUZOPrk6jQnyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(6486002)(66476007)(478600001)(8676002)(4326008)(7846003)(66556008)(41300700001)(786003)(316002)(52116002)(36756003)(83380400001)(2616005)(6512007)(26005)(6506007)(6666004)(8936002)(5660300002)(2906002)(7416002)(10290500003)(82960400001)(38350700002)(38100700002)(82950400001)(186003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7NzF8OIVuzJr08djRz1zT5XZgNu3Dpg/WGOY3h6z2cfnRAkoRLSN3LnhghFl?=
 =?us-ascii?Q?tNfIqdmOB2KuDCHI4P7kpBM/Up1u0zmWykEjZp3Y1TENk4O3+yZSsqXqqlFl?=
 =?us-ascii?Q?Fzt3hp4ehSD1WxskcVpjnRqlwU/8NXVEHA4h34poRzD+LatrNpLuRMk3ZUbf?=
 =?us-ascii?Q?5bIYLRqSIOXnrgGYY2PbY0Q/n3KVIgyrJGIApc1OdFF+GQ1rGrVS5YNiLZz8?=
 =?us-ascii?Q?fP5LKFrlmc6MDbYyPJl1eJOiMn3XKjEgXrpuoF/WPMPojO9nPvCzS4tOQkZG?=
 =?us-ascii?Q?gxf/Lh7chEo38Qnm3mT7m/yIPYCa9e1sCKV4t0avNY9SCi88z4l6k8TW1vi4?=
 =?us-ascii?Q?wfqqdGUAiggOCud9XAwLlEvRMDFGJQ0+wqo3+15vmK3UmU6ByTyPE9NkWeqD?=
 =?us-ascii?Q?O0ZIfsNAk1CcuUEHNET+GfwGJ8VkOX86zMtc7Fube+Xpi6eux8kNHslVI+F5?=
 =?us-ascii?Q?Bnco3PIPSmvZe1UIVyKf789jX2WHCRhgI19IknLNQlvFLMQipbv499IvlR0m?=
 =?us-ascii?Q?YHAvjKp45y0nqyWb2YPi9xsfCPjf3tPKN/aVbvkolZ7CdXeFJzdJnP/qCVBf?=
 =?us-ascii?Q?tj9wYBXpJnZmVpE4gW3qN4rfvUxBSqcdk6Cyw8sH6Q0FVxM4tiw5MweXTFoi?=
 =?us-ascii?Q?uHrWgufg/0pkHKgfayJuJxCeiBIUcz+pCw5EUnIMMO3Ew0zq54pdQ43rAXAC?=
 =?us-ascii?Q?I5odELp+3yjUXhP0wOXf7r81ucDqaqkXmO51qspzpq2AlTpzWALg4VtsOywH?=
 =?us-ascii?Q?ti4x6QeL6/wmYZ7v/ixMoE98t+A0oNdCs4Y34xVv+LzDfAFoHAcMNOTzGDfA?=
 =?us-ascii?Q?sZZnOihpqAy2OdTW87pKf10f5V3o0xepmffSI3btQJ/0Ae66PbGhLyzZ6/Ia?=
 =?us-ascii?Q?KmoxBFf5ok7uUwPconNHhY/bRxYo1wLvdmsEPA6zJa+uyB5ZcXXdWE3bfG1n?=
 =?us-ascii?Q?WB6TsFT2mtVzVaEViWTRcTrMKdenfHH/DQCLTrAWvbEk2gwupy+oYiX+pbU1?=
 =?us-ascii?Q?zzSMV2rWbMPI2j7o726jC+sKk6NrN4Fatt8SSwek2fUH6gLiLJpdikd7mJZL?=
 =?us-ascii?Q?J6bU66hpY0Vo/n3QrEdWF6+U+28nZswtwSzdjPGWz6D88pS42Fm9umWvDUMO?=
 =?us-ascii?Q?w3O9UEI6ofWWzGchwnSojcAxTndKNjrgBsIqbncRW5EUjNWWQDiHIZsGmeLn?=
 =?us-ascii?Q?Nzn63distEUw8z3+OwPLvlEGZHjM1e6F2Jbhge62tIJ+eowLgnVcB8ksHDBS?=
 =?us-ascii?Q?EPaoTpwFl+oy2VVZKQOi7CbJ43czjQb+EwFmZ+z6Z3NjvUYAxvsnSN19HFXx?=
 =?us-ascii?Q?GyOtGgrp7cqlp+JUK1iWEJU7Neh3LorVRoURSG9UfFM65SdnCFVUTewq310p?=
 =?us-ascii?Q?M1JgbQmlTBYnBbUtPYu0oA2J3nCd0/yi96Bsuf4ZyFBxoUQ6HvTGVyr2mCBk?=
 =?us-ascii?Q?VjHfcTL0gEa9asOroIOQYNVQcwkQ1PkKAsAyvkEjlUhX5X8OTTHXKe4FN/dK?=
 =?us-ascii?Q?hQiPkNCE6yH2idILdF62U8Zzzie1OcfPjBN+b6Yl2nTO/5KEg9gUuI8cskgF?=
 =?us-ascii?Q?P0ci3667HFR01BpN6/J6nLnK119ViXP2gslV9Cik?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e2c967-fcdf-42ab-e59d-08db37ab1edb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 21:00:30.3581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAjhuru8Lfu6EFuM7S153EAGy/obyOw39W03qiNj8TS/a31mtveKQcVPSO6XNazzVHLOcbQNxIoE3hxF0rqybQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1895
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set adds support for jumbo frame,
with some optimization for the RX path.

Haiyang Zhang (3):
  net: mana: Use napi_build_skb in RX path
  net: mana: Enable RX path to handle various MTU sizes
  net: mana: Add support for jumbo frame

 .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 383 ++++++++++++++----
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/mana.h                       |  27 +-
 4 files changed, 346 insertions(+), 90 deletions(-)

-- 
2.25.1

