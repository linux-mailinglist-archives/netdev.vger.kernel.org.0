Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1628367D733
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjAZVFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAZVFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:05:22 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACAC17CFE;
        Thu, 26 Jan 2023 13:05:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8alJPvY2cI0/AiQhSm2l2ZLVgdfV6ygg6FSEB44KqvJQc+Jv+Zqg8ccq946si9F2d9fofN4seJdynfqcIA6gAWb9fkSxHOyi08uhYCWBKQqwCAn0SL0CUuV31abjKAjRkeTHa9K4s7JW11HSIsjQL/T6+ElZEAk45K7IawIozbAn2JYoJaF2qG7wG6b/YG89XE41CX3onxOz1koukOgL3VBeE/kD9ICs+KNLUNKHDT+PoUhGJRdazXNumIbJYxL7WmHVEfBxf5FrM3bVAJg/3GiQf8YsuqqlU7O6AI//uuswEz3BZhEB1XahnXjpXjIh48vpp6RzcFV+7lj5CJClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnvqYORCSCnaOosmOs7QL7bKWa1KfbbIhZgBUnxGvYM=;
 b=Wv6jXBg6MQgDoqoPpOuMqnORLZhT4rbalZw8XZXP0sMZsbV7tbs+rI0dtjYxfCl50C/P5HXHjf4pRgjc3seK/SoPiOO3fh0HiQor5fOYwa49Q77imo7Ju/601xTdNEAMbYiC0NDxgTXcmRZnG6ZBHDF9MpLod0o4Tssnsrw9WwWyg60JfQaoM4F/IhJ+8qrTNYKnDmvS2xDTJR8MzBHjLLpjnP9z175bmGO5xxoN2JrIk0FwgjxBKwCDBajmirtxJyzfK1fy7jtbBq4eYhHzfudZFG8xyNzluHvE1diN2FCaPfsXaHPig420/rNp9+fzVEWWqgAIMncjOTD/zLBVIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnvqYORCSCnaOosmOs7QL7bKWa1KfbbIhZgBUnxGvYM=;
 b=VRZbcXHmD+VY3B/2Pa+K7wTcpJmb8taP7yVamXGDi1GtIKamXp2dlDvLyE8mAPl3iwgQKGcrY3M1E5hJJ8pRkBGOxii6YysDiidPo5u5xJEI9GgOSGbXQNuD9sy0/u8Hsb5y9EuOKsq5MigqhmyukXws0BO43gTGOB320/qvPM0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by MW4PR21MB3846.namprd21.prod.outlook.com (2603:10b6:303:22f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7; Thu, 26 Jan
 2023 21:05:17 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%6]) with mapi id 15.20.6064.007; Thu, 26 Jan 2023
 21:05:17 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net, 0/2] Fix usage of irq affinity_hint
Date:   Thu, 26 Jan 2023 13:04:43 -0800
Message-Id: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::16) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|MW4PR21MB3846:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f84870c-0290-4104-b941-08daffe1068a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rH/R3u1nyo2BjmxxSNWMHqTi0dcfMQ6odTvbGY1Djf0v4ViCxTEC5Nxog6YuYhoEVx+db2UcB0Xg3cICVwJL3FToIguA5wBskfblKOeUUzmUpiV1JNqC0nRp6sXoneaLk6g2+oquoLJJXUVvJjcRvyAqUr+FjFYIcw8oRuJGAZxOMhzknV/ugu+4+tEA6MMEtGdyYKBXwTT7iBqZ3y+j20/yzbhTD0Wwbgjxrih0GnZ4ovkiWPw3U8fJuksoy2N4aMNPLjPINgP8ZaQBZfrJqmfPy/tyAtKUU1dYvSv3ssyMeoiEbTlZm2sPyDFP0pwUG35jN7zHcICgIw94shWZubcE7BGtSCvKLDgOxXUOrt8NVF2IMy9BoP3J2S4pSXz2qBWg2gaU1SB7TjtRobxD0M6oyeQMJpWd10lqNJItFNJSZed0uEWo4KZI8I1pEMzwFgEQwdx9pmCxQIhjIlUif+LtdaGQc0JtRtjn0d4b0FuwDkYG4x+rP5nEaOSrpzRrm49+IPdu8x0eBASxNxjcHcnuKe9H8L1QfVCdcfWCGhjbVewyXDcab+JYIqS80d6hxr8azcz83jC1BmXuJDdVNvl5zOQH5CaU2bsvzcICmvG4PqYPzt9kNB8hMKacmo2ay2X/dCUeIX/C/T2L6DcToz6h7LawCdHIFqM3+tvte5uFMFeEdGAXqfGPni8HhMhlr4vG/PGBpqaPF2ThI8KnNQZkC/0oJHxiFzyUysHDMotYB06GOJXYuva+xE1ZO2FQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199018)(83380400001)(66556008)(66476007)(66946007)(4326008)(8676002)(41300700001)(82950400001)(38350700002)(38100700002)(2616005)(82960400001)(6512007)(6506007)(52116002)(6666004)(8936002)(26005)(186003)(6486002)(478600001)(7846003)(316002)(4744005)(36756003)(5660300002)(2906002)(10290500003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U3iERmFQLYRnxMsNzApb6dooLQouGqPMAJgoRf/SQHPzjClY36a6szMZ9s4R?=
 =?us-ascii?Q?kjWEd8dLRPg7HOAK2dws6xV7yu21X/zAyIYOeVZZjAbIfg+10Fya5lXeybwq?=
 =?us-ascii?Q?HStomzgAL6DJo5zm0fRdg/pRZpdTKvOhdxRswDmUsRkPKv4RwcJXfb3xnLC0?=
 =?us-ascii?Q?nb+uyMmzWb+T+B0DwOsmMJL4YwVm1HG6i4A3iXUtNwCPcxA3PV47R4FgVIoy?=
 =?us-ascii?Q?AliN1XCD95qZZewEtDm9Qq9xzKFQRZx6ICSYTRNXOdPJ27IDQO8awJos3M/v?=
 =?us-ascii?Q?EkIne6zJa38rWZHHkf3HVVm3crgOsuGJWbsM1zEvNXLvlQs+2Vbd7kUylUYu?=
 =?us-ascii?Q?/aPdTdwhlJR8pBlzsUcnz9nXgLjGY4Dx5VTLI2xs9zcYxG7t/lC3mcAERwqf?=
 =?us-ascii?Q?ElXar5qevQPpn59NmzIJuoWOwGAclQzAMnfJqkYGHnNyuFUIAkqyW4ta/fHq?=
 =?us-ascii?Q?yE4vfBYiXz8F/wmr0IAC0XOXyGKWHqgv2SBaVPo4GriIxU926lGXv6EBPWu9?=
 =?us-ascii?Q?eFOQjroVvitf4DSrk/z7+HCrtpKnXyF6B1Fbd8neFljBMuhOSBle11SRWis1?=
 =?us-ascii?Q?x2gatdT5nFbrbfzopxz7rwIQTWjtOJXy3mKE56741WD6bTiYJMb+45CGFONg?=
 =?us-ascii?Q?vIfokcwQf7Uj4FjL+x5IwSxqI43PedEX3wGCCzuCwaUEmAwcOo+p5q8asBdk?=
 =?us-ascii?Q?tkeqYUHZesNFENyYrM2n4aAZd+Bwmc2Qrr0l5ueoYcewJ17RGdJwDRCN2WIa?=
 =?us-ascii?Q?UbT5Skqj4DYqKtxoOMGLiRWKn42Fd3m8JB6Wl359KWSnQbAJIYhFtgp/kTVr?=
 =?us-ascii?Q?iR+EktLIJ6P0V6BEzhHinvKDLY8slD526L0uGPekGnd8kGOfhKj5t8sUt+gQ?=
 =?us-ascii?Q?hXUZP/25MD3uevepSKNOfw6csoLCCulQN5WfetzQg3L14dJYErBcUHO4OPj8?=
 =?us-ascii?Q?zg6EI4mmtnlLiYvC9aWTBhR9l6FylavVsrhoLP4XSpcJAiI1bBP/w7zJVtZj?=
 =?us-ascii?Q?HlPg2CDgpNIf75dPLm9PfUJrGAh3A7UpOPWlu1r158iUHRRlrlcno7tMWiJn?=
 =?us-ascii?Q?dxmkOmERKlqCEr9gkd/iS2MmfF4e555Y1WONMvMVjGE+oi+90WRzOfTzGSij?=
 =?us-ascii?Q?q7orB/61f/zfriD5cz4ddViUAeS9GVXmTvU2lzKnddfL69nTHyRbKFBcnHAi?=
 =?us-ascii?Q?hapxTpRE02IVRWoc687EmXNy1oUWnlmkvJdjFMjddDCcR3u3JZB3NzBc4rQG?=
 =?us-ascii?Q?BJS9Uwsygqx4e4KP+9wuApu5VrNOPm7P26dp23gsUewdDAAtCdQC/aTp8VLs?=
 =?us-ascii?Q?IE/iJLyN3EHk7SsUM/FMHNTaB63XbT46F7tjj51KcKRizw1bijZMqhuZBF3a?=
 =?us-ascii?Q?wP8m53Bn2lYmhe26MTJjtybtDs31OFxE8HqjCh7kPgOZIo6FgxWopTHs32sq?=
 =?us-ascii?Q?+C1Pq+nt9XbO9aq7hrOA0WUHZo3JF129oYUi0BzAhkBuVQdPZzAvVHsV0A2c?=
 =?us-ascii?Q?vbQZDuRSoDuSeLijE41jrHaBczVtZln3+RibkKutOPbnV46HOzcntb9pKGtt?=
 =?us-ascii?Q?JX5D/NbxchUQw17Wej5RjDJU3BAhkx+VXzLLTptldGDbxOkdKrtttDbBwu6S?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f84870c-0290-4104-b941-08daffe1068a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 21:05:17.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7OiNNF4s3kUsAmCalGRF2qZ8rXktL6rLHjQ2ObkgkJlYmOeeRe6x3C7W2RcXbGKxTVAfaeibaPmAeqpxfaUng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB3846
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix 2 bugs of irq affinity_hint usage in the mana driver

Haiyang Zhang (2):
  net: mana: Fix hint value before free irq
  net: mana: Fix accessing freed irq affinity_hint

 .../net/ethernet/microsoft/mana/gdma_main.c   | 45 +++++++++++--------
 include/net/mana/gdma.h                       |  1 +
 2 files changed, 28 insertions(+), 18 deletions(-)

-- 
2.25.1

