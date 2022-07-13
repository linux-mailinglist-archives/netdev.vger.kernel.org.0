Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68301572CEA
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiGMFQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGMFQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:16:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611CED4BE1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6f8ss2HNiWsb3q5OiXPoCqwCASDv5DIAF3bj55NB7NbesZlsTnHTRS2yEuTPUa+f3Hrhj2qYIPz37WlrYQodMZi2/qzra4JpuD1pMtd075fTKmi4y/0i3YqcIw/mNF2UBCDHBRorqrta4UV12G8zkkqq83XV5So/3xxrs8SDiA9Au/kvAT4n245kJbIp3FbV5eF5lAGGCe4SJkbMbcrt5/n+ko2iuhf2Dx29RlcZI0L63jv6bQa/c2AzuG7MTEu4JGX2p4Y1+A7Ve5GgRl5SD+h5Lo8VfjzxaMctHR56aRwRe8X5VRz+nxZd9gk2f5fmlsuZo+V/s/BwTBVtwfR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79mJxXW6QMHsG/feyYRpSsORcwoCDyL0NFF/QmI+MkI=;
 b=D8WYbyWdc5C2JBF4TTW2FJ8XiKyUKsX3to4dU7sHQfhOAlJMsgldsWyqobACbd+otkKnxp9Tz+3oqB+86iPU7yPFY2EMTN8bTYne3y78XEXFVMs76cL8+tWnKDU+ckDjFwgNMjVzxb2CJxBvkBzhy3nDXF/suwH+aHiARe31/KC23jrJvml/HAp/2SNEb5s++PZXZ4w8fW+JTnUqbr7jwODJEAu42TKpsWhyCX0rYvoPdfa7+GAoc9fySQi23QQPv9Of65XHPAoTf9+1MPhjmMQLqb7QsoTD2w5ExWi9BXhZfWzJPOcF/dDJf070Rywxe3ek3BSRf02RZ96PaDKzgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79mJxXW6QMHsG/feyYRpSsORcwoCDyL0NFF/QmI+MkI=;
 b=MdSGuV6GDR6M4YFRUmIX0dydq69JZ8zlcmp7AjOb4kTBmXoWM4gs7O7zu08yVk7Hb6Ku+xiJZmq4xL2t+7I3x7FQ/bJXOUsfDIN/PMh0g5wYTuvyCgNjQDXz05E4rjAgupdnvzquNxFXMF5J2bnjvhGMfZ6iC1VQ58Od+29mAJU4EVXhy0XkwjWacg81X7JD5k0mvZcNHtKfeDEMiMrt4kDzQ250v7ya72ERgam8ZDMVaNszq7sQCmzpmz7OPi5tX/ELIgqRqLY1lGIMjc+eUwzKJDLrNRyWS0nbZl8hmYGaN5gdm3AP7HcgcRxb7/iuGQfXIaNW1t7kaI+3dtAtiw==
Received: from DS7PR03CA0347.namprd03.prod.outlook.com (2603:10b6:8:55::6) by
 MWHPR12MB1950.namprd12.prod.outlook.com (2603:10b6:300:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 05:16:40 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::ab) by DS7PR03CA0347.outlook.office365.com
 (2603:10b6:8:55::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Wed, 13 Jul 2022 05:16:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Wed, 13 Jul 2022 05:16:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:37 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:35 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 0/6] mlx5e use TLS TX pool to improve connection rate
Date:   Wed, 13 Jul 2022 08:15:57 +0300
Message-ID: <20220713051603.14014-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 191f2d36-625d-41ab-0cb9-08da648ede26
X-MS-TrafficTypeDiagnostic: MWHPR12MB1950:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUcUsaeyCbRcWeRL50YMDkA5g9CgqSaEN8y68M8gOzDBtefD0NHJy7i7689T95K7u6GsKP3GUKKBKTjQSMNHh1m7Cs8ChPSN/ajpecq2KkmAybXvThALUA2V0QCOq5+MMn+DrnSvRHEAjGrOGUtsz0wwM+eNaNVi4QciJy8Xz9IYSbdo3zszHwouhOECyMLiQ2lCIZp2Udg6n24grnX4gHmLwCEnCtlsBulxxcXj08mrVoxL3LkJKHqJHDWkSbjRBhXVzKFf3h21+8Iks0+FOSfpc2aKxpRrSODMIQrSpDm6M0LAVKI5wpTIrCBCfeR+eAecNqH7breMyn848RcqZl4PVlSNUGY9tAQDqlDGwtSqStMEKHgXDs1UJNxzTCv7Xma6DRC2fgsbiIotlj5D0qBETcUHPUE0jIJZsoE+5UMdJ02+llzroNr+7bFIXp4w2vtzkHfLSlVfNcK8PD2nCU3ABqNpQcX7lVxDn2RGG5XtkOT1/YQ/UC35yGkVyXaxluw5dEo+6Bgb2ThB3fsTEvjg/hQQkHpcnWNklsWijC1A3TO2dpGfq0ZPeUtW6pN5roT1tqWQ5C5WDcdXlOxYOCt/UUzef8qb6np676g/BxcBTJ5GPFxLkbvddzQ4HOE9N/aa7vmFjljCZI4P6OQ+A4y6vxGHZq10V4fzWAvydqlgCwe3M0BI3/h43oENetwVNT4CM656ZeGKLLNQn8VOx41aeWsOMGsn9g1RA8JRMDjz6MmtmrP0nzE8ONGO36slOsuG0K1JR66hJ0lSjBpjPjtvnA1cbm3fdp3MUYeJAbskHgOHhpXQrYCYgVOsMQOblY0+anQ7iDekcjj7THZVbVJdb9cTh6GlC4T2o758NnFCvDTQj3zURfrMsMw5yIhtGeARigGkiRClXAjHpgqIdw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(46966006)(40470700004)(110136005)(54906003)(86362001)(4326008)(41300700001)(26005)(36756003)(8936002)(2906002)(8676002)(5660300002)(7696005)(6666004)(316002)(40480700001)(82310400005)(70206006)(186003)(82740400003)(336012)(1076003)(426003)(107886003)(47076005)(478600001)(81166007)(40460700003)(2616005)(70586007)(36860700001)(83380400001)(356005)(42413004)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:40.0265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 191f2d36-625d-41ab-0cb9-08da648ede26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1950
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To offload encryption operations, the mlx5 device maintains state and
keeps track of every kTLS device-offloaded connection.  Two HW objects
are used per TX context of a kTLS offloaded connection: a. Transport
interface send (TIS) object, to reach the HW context.  b. Data Encryption
Key (DEK) to perform the crypto operations.

These two objects are created and destroyed per TLS TX context, via FW
commands.  In total, 4 FW commands are issued per TLS TX context, which
seriously limits the connection rate.

In this series, we aim to save creation and destroy of TIS objects by
recycling them.  Upon recycling of a TIS, the HW still needs to be
notified for the re-mapping between a TIS and a context. This is done by
posting WQEs via an SQ, significantly faster API than the FW command
interface.

A pool is used for recycling. The pool dynamically interacts to the load
and connection rate, growing and shrinking accordingly.

Saving the TIS FW commands per context increases connection rate by ~42%,
from 11.6K to 16.5K connections per sec.

Connection rate is still limited by FW bottleneck due to the remaining
per context FW commands (DEK create/destroy). This will soon be addressed
in a followup series.  By combining the two series, the FW bottleneck
will be released, and a significantly higher (about 100K connections per
sec) kTLS TX device-offloaded connection rate is reached.

Regards,
Tariq

Tariq Toukan (6):
  net/tls: Perform immediate device ctx cleanup when possible
  net/tls: Multi-threaded calls to TX tls_dev_del
  net/mlx5e: kTLS, Introduce TLS-specific create TIS
  net/mlx5e: kTLS, Take stats out of OOO handler
  net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX
    connections
  net/mlx5e: kTLS, Dynamically re-size TX recycling pool

 .../mellanox/mlx5/core/en_accel/en_accel.h    |  10 +
 .../mellanox/mlx5/core/en_accel/ktls.h        |  14 +
 .../mellanox/mlx5/core/en_accel/ktls_stats.c  |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 513 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 include/net/tls.h                             |   2 +
 net/tls/tls.h                                 |   4 +-
 net/tls/tls_device.c                          |  65 ++-
 net/tls/tls_main.c                            |   7 +-
 9 files changed, 523 insertions(+), 103 deletions(-)

-- 
2.21.0

