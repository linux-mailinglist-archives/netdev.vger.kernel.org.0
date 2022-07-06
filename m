Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAA9568480
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGFKDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiGFKDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:03:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1166524BE4
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBdTF8m4Y4AIy2Wfn1a21E5iNlezIibdhIL5OIs43qOp65F+WS25Oqeu9fOcKgLSVE1Wz8ChBLEnAI8EqyV5TMlge+eC3Nqls1uHVTKxP0n5Z/zm8DujkNBs37hkXP8Jb2ItIkQZjfPLe+/1uRK5LhkMvbDHz8VObMjfiTO9ezqvhUt3lmmCOzRukAG5KnCTJfEhsBnTejo7SgeSsIsrfSeTlhAY1lo+3g1KKQpr2kHULIWNkuGS5CXSvirDQ2igmC4+ohyt1RuYuuv/CTEIxaK7R8xlkykYaU62gp/ouOJ7gPsWP3QIU6aVzrQwC+GvPVa1A6+BKsxULAxd3OAKtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djoQE/AwckL8Uo7+TUjVkucp0uZ5yjJKpnn9XFMhy+E=;
 b=Iln/fEXq3cNSU1KvruWjH2yTNFWi+xuyVSGVzAJgqJ+w3X4WnXxqEf/EwCRd6e2IedDKp95zdPW4rehn5hqNGEhOImFKhRZRL1lSYPkmwkcuV2yWjyuk7SIHeLFKzr0cwmT/eAir4MdOMtDJRb6o4lukGsa4xboer26Pp48uEpCc6SDiTkhfnTT9EIxrYv7Fbw9l7hVz8FnGuSVJKXOtu5/FW97qF/uU+WISZHx8gBH7l+VFkd4Nt578mT4nUQ0gxKlMRWyj6BZ10Ht8e19EiZCgvAPV4AGMoJpEjIzMm8PCP3pnOb0/03blUfv/4xyDdbA9jIeFsZuh1gbaQk2HuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djoQE/AwckL8Uo7+TUjVkucp0uZ5yjJKpnn9XFMhy+E=;
 b=JuIPsC8d3cY5GQ/OOCLrRD5Q/u4J+N3wfoZqGPoxyIdF6BjAXuzonXbm5mareDJhOygxDlZAyITCWIiYhLv9IXLpeOzb+8qJlMau4cL9QOxLWsJZuO2biFAZybKORt7hhxxrbAwaP2lRkKZk7t5ocRfI76l9JlwPtNQ2vjaNHhpyroOcUbpy3sKRDBsq4tql34yDdzXmyV5iVmbxGIWmcQlmwUYEGfTh8JQKopEOFA9NnhdyHUY/9qolp4ZPDWH8iqnVPuEkMX2xjRMM9YN7md95SDy9eVp2heOSTGTcntZKgWgW14XCvyDdN7+389eRDSqNpgfTCoC8CQs7H3s+8g==
Received: from DS7PR03CA0319.namprd03.prod.outlook.com (2603:10b6:8:2b::27) by
 DM5PR1201MB0074.namprd12.prod.outlook.com (2603:10b6:4:57::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.17; Wed, 6 Jul 2022 10:03:42 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::d9) by DS7PR03CA0319.outlook.office365.com
 (2603:10b6:8:2b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 10:03:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 10:03:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Jul
 2022 10:03:41 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 6 Jul 2022
 03:03:34 -0700
References: <20220704204405.2563457-1-vladbu@nvidia.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <rajur@chelsio.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <simon.horman@corigine.com>
CC:     <jianbol@nvidia.com>, <idosch@nvidia.com>,
        <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net 0/2] Fix police 'continue' action offload
Date:   Wed, 6 Jul 2022 12:57:48 +0300
In-Reply-To: <20220704204405.2563457-1-vladbu@nvidia.com>
Message-ID: <87wncqa77w.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f97920d-4830-419f-8b97-08da5f36cec1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0074:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VucU5AYVQwSJpX9mfGyKsZwBC5tX6DJu4LGFP/Cri+He+35gof/ECyXh0Tdg?=
 =?us-ascii?Q?9WaneVTytVrSZanIaexw2Fp9SjEEY/ODGtIqXnlEzErRhSX/cWKU0G/gc/Wa?=
 =?us-ascii?Q?GahG/L6j5vO6Qhax/10KV0fROhhM8szpqypBE8Acays2qOohT/HuKjM+Nsjq?=
 =?us-ascii?Q?NIjXUodkD6Niy6Zr1PEet1H9wKHQAOi5bOZLX50WVYOm3hfz+yxZXuq6+vUF?=
 =?us-ascii?Q?ZJ9PmrH2vBJqFDWWdv8GnQFdMXR3aE0M44GMQCZtp4qOcaQo9zKSB0yYF381?=
 =?us-ascii?Q?WR7I+bihxvO+laILeHWSATFqMzDCcsdOL32P76RKrBe37R3565XXnrCAz/wa?=
 =?us-ascii?Q?MrWI2fg5/40zWmnSFvyTK05dJUUAEFfid+KAobEWgAWRQRX/6MkfBCaia5ZC?=
 =?us-ascii?Q?EwdwF47CiHbVbFCF9TJRrRF2C5oN8/f9CuqJA7oshCO0Y5IgxzVV2o69Pg8D?=
 =?us-ascii?Q?kN6klmsVOUg8XVLeIM4omVP2uc4itco4EkrYJQY1U813YpLE1P9xxn2P+mtC?=
 =?us-ascii?Q?H5Dk7in39WyAxRoFvfSaWqIuiT5zPyYued48LdDoV/+x65h9fbMyp5uIzCJk?=
 =?us-ascii?Q?pCHPFvJzppvbWgLzNorrvQrLLVvna41N+9W3Ut4/MCWyet9VxTAX7N8rMZlv?=
 =?us-ascii?Q?uj/iHAzIB+KrE/44PRzbU2jNoxueHk9ztVaOdJmC8ahqqvfOKLu1PmMzeTfq?=
 =?us-ascii?Q?rt5kkF2k2B5aL5TV4UgP/ZeXLr/hg4AB1vU4jZOFkzUa9i7ff+cmzZReouHv?=
 =?us-ascii?Q?eeBT9LrxJESA7YvLcMH+ERpa7aPdeNB76LYV/YiIRNbRT77Uyi0XVFwimHB4?=
 =?us-ascii?Q?GeVkQuuHWNsZ2B6SsZitD6LMqxCyLbNuRJPEc+iHlznjYo1xb4/NoNeAMR1Y?=
 =?us-ascii?Q?NoL6/GZA9qPHleHbmOYtO9WP/7Bp+UHVvsnr7h1cBIghCNkZ+YOPNdCczJiJ?=
 =?us-ascii?Q?djnv7moPRsUSt4KazCtpHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(40470700004)(36840700001)(41300700001)(6666004)(36860700001)(5660300002)(47076005)(82310400005)(8936002)(2906002)(7416002)(40460700003)(86362001)(966005)(356005)(921005)(478600001)(4326008)(8676002)(81166007)(70206006)(2616005)(70586007)(82740400003)(316002)(107886003)(16526019)(110136005)(186003)(40480700001)(426003)(54906003)(7696005)(83380400001)(36756003)(26005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 10:03:42.6603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f97920d-4830-419f-8b97-08da5f36cec1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0074
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding maintainers of other drivers that might have been impacted by the
validation change. If your driver supports 'continue' police action
offload with matchall classifier, then you may want to also relax the
validation restrictions in similar manner as I do in patch 2 for mlx5,
as I also submitted OvS fix to restore matchall police notexceed action
type to 'continue' here:
https://mail.openvswitch.org/pipermail/ovs-dev/2022-July/395561.html

On Mon 04 Jul 2022 at 22:44, Vlad Buslov <vladbu@nvidia.com> wrote:
> TC act_police with 'continue' action had been supported by mlx5 matchall
> classifier offload implementation for some time. However, 'continue' was
> assumed implicitly and recently got broken in multiple places. Fix it in
> both TC hardware offload validation code and mlx5 driver.
>
> Vlad Buslov (2):
>   net/sched: act_police: allow 'continue' action offload
>   net/mlx5e: Fix matchall police parameters validation
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
>  include/net/flow_offload.h                      |  1 +
>  net/sched/act_police.c                          |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)

