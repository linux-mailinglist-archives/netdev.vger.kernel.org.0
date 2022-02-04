Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2EC4AA373
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352885AbiBDWqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:46:51 -0500
Received: from mail-eus2azon11021026.outbound.protection.outlook.com ([52.101.57.26]:40838
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234792AbiBDWqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:46:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqzp90ls9KDmRGOqnQ0njWv/GmBxzxwpHp66qL31FIrND7aHF5pIuRscYebYeunD9NzgC8Z0+AIIzZggmgyTpi0po2oKjO0LD9HOXdQKCNqymwngR6OU2ttC9mBtwMzfSjI+XLlETm0jNf/FmKZ8a3kTlHuYW1eIdWzMkkWjmYP0pZ75udnQ7kPRGD/59qqiphQ6nVudbyIEz1iXV+T3WYlpPf5zzim/RO4ck/lh8q8B9OG4cfu7qFlfnOvhlynyt2QuXm0OjhWuCwuuBhCIvuxaghQQgBGiKnEuGYdgSxBpG9fSoPuPkTvU11iXbsNr5YfXqL9Ir7KCsicifX2o6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Db2DHyD0ql1jqulKAeTr/KEj9AYoKrJEY0mijVcxgfo=;
 b=KVU2E18evcGgrzwJUfUfFmgCCQr/gpkN7qvVRv3R9TK4NNKDa0uggtLg+E3jKiDtwXrX6sNr5wNKVKsqB00rudnpJtlfc7ELhdDTimSzUCoEhprb+6FqLLCZBJmptetCcRCGBtjJo1Maa7DO+l21wgZl2xkMc2VxS5SNq80sahTn0wGgEirplSFqQoGFZgc89Gd7ax5+bI6gPxCsOomajE90YEl9DET+M8UGdjmP4q0oU8KmX89yKv64vGqJVPeTl5YQKdcTB+ejXokyYjzWezjYUIwqe0VP0K94tkwBhreqjnOBfw5xzAT3k6yuN8esKoQmPIxOxtSbXw2C317aGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Db2DHyD0ql1jqulKAeTr/KEj9AYoKrJEY0mijVcxgfo=;
 b=Xq7OMnQsoAs86CSEG1/Z8LroMNlP5+mb4LGoaxZZ8usDEWrWDTfo2pEErR+HOmClWWtQOXGVg/bKw/UvlZjivYZpk0kId5x5yQls8PWndmaso72HxeAMeHQEQl4YswVD+Lqa4G5emlFGrk0AyoUh+6tCY7WiQx1RRXBuxpgaQmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 4 Feb
 2022 22:46:44 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%8]) with mapi id 15.20.4975.005; Fri, 4 Feb 2022
 22:46:44 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 0/2] net: mana: Add handling of CQE_RX_TRUNCATED and a cleanup
Date:   Fri,  4 Feb 2022 14:45:43 -0800
Message-Id: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b522c3e3-5971-40f3-37ac-08d9e83037b4
X-MS-TrafficTypeDiagnostic: BN8PR21MB1155:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <BN8PR21MB115544312B4C146506FA219EAC299@BN8PR21MB1155.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e43o6cqJwT6Wi/uxR1ZCG55qGHBjZvPRST5/+zURaslXQtlvIOykDdJKwi4c5KDyCNh4ooQpcFmIOnxfa2HeFTdq0G1lVE1Iotb91G1x3iorUWRU8ZmjgtDra/W0dU5HsufZ1y4n2x9B4f9K+/LlnwoCTA9yINqe7PZhYWFjSVV4FHL2fetye8Odq82DBQwYW69S/Aj+clTLPwPiqK8Ds++a0Y+SmA5VE5RHI2IlVm9/W2UBOO/cr7WrYZ2xfkR51w+eMjSqQefmEHADj/BK3AH5UcYSoih/zPnDhahr50zrFhFwu36dhLBIrueMeDZ7ruB+eH82pEAM4F1lMbdSfYcSwniLA9EIxV+zmlMv/pnP/1EzN2LSU5u29dFrssAbKu1u/N7jFiBvr/Rv2Jpi8fcu7DJgf52RVsGqsyXKTU2GpmspGH8G5uimoG53Bi+SKP/yVNQDFhiV7AqpdEakV/IxHKI2vVwDD7jTvMs77wJwLx+i+qntiVLTYGp6YT46mSgfUykD+doSTzmOXj1R5Mclu9iOAGpmfZh4nOzN1FU6hGEMgTZSEpeW8li+8qLExfYizZm2qdNAX83S4E7o2fV2cZ3+rxeO9+JBj45+mvpdrtTRTBF2EqftDI57T4I76WG2Rqsbd9TN7D5VzQ1P8BYb1kpEgAnI/8s7BjbVMPWU45HHZYV+UHPvuRHeMzkNqXOhlJ+AZlyW2u+/LN0+cVuZPbDIYCp0y4eVCicWtBtiQK9viivyfqGUJLNc155t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(4326008)(83380400001)(4744005)(2906002)(5660300002)(8936002)(36756003)(2616005)(316002)(6486002)(8676002)(52116002)(7846003)(6512007)(6506007)(26005)(66946007)(66476007)(82950400001)(82960400001)(508600001)(66556008)(186003)(10290500003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KtEaHJWQ+kHelI1iSHGLvWn6XWrkjIr+UMooFEvd5I+zPRog4Df9hczplviF?=
 =?us-ascii?Q?en3Ng7P50DGmVQn4hJ06MLQc+4TF8FcIZ7BBhBSkthhyyPYu33+iblZYprxq?=
 =?us-ascii?Q?qT98UFLv9nsNN0d6Yi9tPVt7bP6a6reDgSU/oTjk4v+4UFAZFLiicR/WXNX8?=
 =?us-ascii?Q?ZnYk1qLVh9/pi88pu8V1RMePcWRbsduT59NthoVm2a5wlqAL8o9IARW1XegI?=
 =?us-ascii?Q?9a+1OQym91WS3clY6cLHldWkX0h8Tg8DK0ikjToNEutlNK5o5IfxReQV/iVT?=
 =?us-ascii?Q?vMHFaK3JXOJ+o9T0eakQ0XgPqAUXH41flIV2P6osDeXkM9xnmqui0rY/fMPZ?=
 =?us-ascii?Q?GN2XU90xdnVxfuXLCSZ+OQDViKt0YEe+I7VAJEcHIcoo6qIMPs3ty6IYOUmL?=
 =?us-ascii?Q?HjLMTZ4WD6qBnNjvx4lrxiVjm20wA/zz10obm0WSiBy1O/vSx1qLdCMbUxDJ?=
 =?us-ascii?Q?vtL2p1VgWlULw4mgWNhWy64OPFrEal+rcPoV79tiHbx6sEPd/UQNe19VYSRS?=
 =?us-ascii?Q?uG8bTHkAWk82jxBJHyLDqNiQ/NHIuNU5fUvO+x7Y74ogmV9YKZCiajc4v71X?=
 =?us-ascii?Q?W6B86iyo9MuB4h9Dqtt8saD1jq+cQa1iG1KNcGgL/3mKnJYsKHKyuvERIzez?=
 =?us-ascii?Q?m/f+zMCE7EK15pAZjjI4TFrmpHgxMT3j/RD7ir1eLV8kqKK5IijnT9R7uF8a?=
 =?us-ascii?Q?1wOQ7J7lAkzSFPZOWioK0Odq5svbKEKo7SlrD/qEy/ippiPLjqpJx7FWdlFZ?=
 =?us-ascii?Q?pqPYQZeeDE3gJzp7pz1SRiVOZ61W5e3A8YNxLqRhhoRR/Os2fTxoGPTuVY7C?=
 =?us-ascii?Q?ajwpai0erFktqTvMFZRoI7U6OS7pwrombNvtY7Z/REhcJC9tCAFPdO4xzq1u?=
 =?us-ascii?Q?rf8hHb+ElJ96nJ66Jah0XJOjxxWk6FTksCmQYp8w9TqXzL/K/y72JBbek/eZ?=
 =?us-ascii?Q?Iej+czcjWcLuAEaq8s9r+mzv9Kxtd1yWYO+EjR2mPs0n1QVR8viFoDldbx+W?=
 =?us-ascii?Q?gE6Ylwq3WjFkMPjfFx1+3J6VmiIOYEmdveQHUZ3bhzUEs/PM9H2OfuF+Z+2t?=
 =?us-ascii?Q?LBauldDCDqKNBV/T7GKo0SuhOoI9259/WFbOuPk0icT2TcTJXQey//8aGmI7?=
 =?us-ascii?Q?Y+QZzhG6fvlSg6wkwC57G0IRCF1T+Dcybzh20Nx/zn3gMr9glciemzXqrHN8?=
 =?us-ascii?Q?oehPKTdoDmNdoKmh15L3khTMV00gTMnRX92ZEXrhZTn5AZCuPtbhklIL7B6j?=
 =?us-ascii?Q?6+e6wrQvUKMQ9Xdij+tuvAWzuTuLGfYqmh7kJhe5ovDSBjvzWMqiHPNen4Ol?=
 =?us-ascii?Q?S/p3lxR9UlHu1oA2Wz7EGjcJW+lzEySfhQOaczDnt6u5wn7cyb1otZuqggn5?=
 =?us-ascii?Q?lEQapFGBqwRwDtI4v0PZv1IiXpiZlCYfjQTT/RH3zEiVhUV7dkFCIc+Y9qCo?=
 =?us-ascii?Q?LFUerZhfnQ+JdpvTuhbFjMaLXRor64V9n6xfSy+JfVOsyCu657Fc2kMbY+b/?=
 =?us-ascii?Q?AairX2jPjeWKxpbt/LY8NlsYz/tIpYaSRcpHDJU7ZdAz5URW6iTelGqNWCb4?=
 =?us-ascii?Q?bl9VpNMnP1qLj7mtZIX6JdmoCi21ItFoeSF/kke5tXQJb9IBh+1wBUFHu64W?=
 =?us-ascii?Q?fy6qO/uKEut4ZF6Y7EmR4CM=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b522c3e3-5971-40f3-37ac-08d9e83037b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 22:46:44.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JsuSrGywDYQtGmFah+hg1TjU4KAkeA69PKtGD/M+YjlehORZ8e0ub434l+cQ2OTqmXBnDXSo1OjzSE36NHNBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling of CQE_RX_TRUNCATED and a cleanup patch

Haiyang Zhang (2):
  net: mana: Add handling of CQE_RX_TRUNCATED
  net: mana: Remove unnecessary check of cqe_type in mana_process_rx_cqe()

 drivers/net/ethernet/microsoft/mana/mana_en.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.25.1

