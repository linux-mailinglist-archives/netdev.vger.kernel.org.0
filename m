Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684464C4174
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiBYJa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238185AbiBYJaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:30:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18511965E5
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:29:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkVkZxeftG/8TgvDsLAQ7c2acuMSl+HF3LvJLoxGojb88+q49vTuUlr2IiuyiUGB4MTST15/wZAtZ19g2qrpzioOp8lt5IAGU4Y8JXx63H/rU/C/bWgmnxGvYRnnMfaXFWwfn+k/0LgYN/Y5+povTlre1l87g2LB5jE8VaLBC5NdUH8JCmPeXGKVTiGq3KkPwbRIfaNla1h7yaNG//+umpPVMBzccPsDv8HrscGZ6wql6kC4IhM6fqH/AW7FWo64eyQBJBb9iRIJChGOPyyiscwK9YIjyot9OuwgNsYXKeq2UN0Mgguk05/BFCiaW+O42vF2SpUy09qtAUG0hyz9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GJQJwOa9AcqQeg2mgEA1Vq8jDcziFeNA35x5pmC8Mc=;
 b=mQC/y97xq47vw6qvZJ/qMI4GvR1pQsqi3MPNEOWe361U3gf++/reWBaoDRx/PFi6oy0ZYk+FzAZBmVknU/4vGkOGb9WTQeqCOgBURudSmwXdo4SFDikCQUnLI613FvJ5O9Mgt+OEBjCEZcQCcRZCpdR6NynzRu8DhSpm9S6A8fU/7k9UXgMedQRWa4tbqzwSLL6GDKavtkfGIxI6KD/TrtVHRkwEBAWST0X6JwV9L5jn4uaF9di7H9FaaxSxrVaaw0zgPJ87BQkwAfNfXx7XbVfmz3kZgntjgFXWl6jeQwIzBiKdpD6Cbdx3xGn/4J7Mp1/fRyv1xAju5jKNRT0v0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GJQJwOa9AcqQeg2mgEA1Vq8jDcziFeNA35x5pmC8Mc=;
 b=mQZYOWxc44fEBDXqYPdnVIlXSEBbdyBv4SVEEUwFDiVQ1Q3o9f/u9jHFxnJ1JFeXA/aSTvB78vEcZo03wpEw2jADFnPyn8sh4QYIDWEWyTEs6IpcSoIVxZwEqPaTAIESRxJLzeh9SyQHxStZi29zwcgl6AaUJq+4A7j/XYx3M58DmOaXI+hFfoPbinAmSpgD4F6a7u++tqxJu6AAunwZrrYyDYynxoWa3K/+Tosn4FW6wfzNxRc7KgZcZyHVVCUuzLtY0b0v+2Ofj5wTRhEGZbXm0WSCXH1D1/oIv3sPRZ9kvLUO2+XFvzaZ3a0W2Rk6+XtoH2XV0PbiJoF9L47J2A==
Received: from BN6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:404:13e::14)
 by BN6PR1201MB2546.namprd12.prod.outlook.com (2603:10b6:404:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 09:29:51 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::a8) by BN6PR13CA0028.outlook.office365.com
 (2603:10b6:404:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Fri, 25 Feb 2022 09:29:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 09:29:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 09:29:49 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 01:29:46 -0800
References: <20220224133335.599529-1-idosch@nvidia.com>
 <20220224133335.599529-7-idosch@nvidia.com>
 <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <petrm@nvidia.com>, <jiri@nvidia.com>,
        <razor@blackwall.org>, <roopa@nvidia.com>, <dsahern@gmail.com>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Date:   Fri, 25 Feb 2022 09:31:23 +0100
In-Reply-To: <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <8735k7fg53.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7a06626-196b-45c7-0796-08d9f8415f8b
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2546:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB25464E4264E8187EBEA835E5D63E9@BN6PR1201MB2546.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0B7cpr/LUAnhPkbjm2c/TUQflEWgr6x4GCqDZRb2Bk1THPIpB2BrkxYaqag06Y9eweIBYcwWZjsagNTPc9LW8k38l0SEa2t12lMp3IgEnbZVJwQ8JHja41HA7udLbl11kajU8a1uFSZSH9wyzpKogUJPmKI6krut3XfKSWSVvJbFGT15izDYlHjGdw+o00gTh6avWdAmMDC1tXPbQNY9iBU3Mr7Rk6ATjfL1PJCO1lIsazLSXCAc9uhRQNAbgkJc/TA2OJPA5JUliutGQ2HzFrV/erD48ornhwvdyG9A/upW+IQQsvgOJ4sAytpR72nN4xk7bkT8+5ohMLhYSNPiRhMsI5GYFUcbplwJvF8gIbbYbZ/Coka/T1nrHnBiq2n5s/6NbPhy8KSjUzI3/fII0s+lnEKYl3BClMUdcIkguixBkeZFV+8gt98Te4SuyVZZ5cFr8Cj6lkrlsm80KRlAHXCqnuJMuLf5XiYYyf7cGxRAMK35FMipS8GtOZXcCGhwnRG4AprzVseZl55XPWGQUcmmPccmbEcTp9ompVqm6Q+zTN4Iv3rNCrH4wOiLCKW42WTR5Cbd6GrzPEl2xPOTfNyD/KUHlVZMd/HalfbocIAhnVJK+PwlDWsJlyGCkg5kyGDywhlTfapgrc7UY2M+fYWDMMy3K1+lFeBlx2SvZpLGmcTL/Py5fwS+ktXfaZFICVr2Q/ODv8+LSCt9OfyJQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(16526019)(86362001)(70206006)(36860700001)(40460700003)(316002)(6916009)(186003)(4326008)(8676002)(70586007)(508600001)(54906003)(26005)(47076005)(107886003)(6666004)(2616005)(36756003)(336012)(8936002)(81166007)(2906002)(82310400004)(426003)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:29:50.7270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a06626-196b-45c7-0796-08d9f8415f8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2546
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 24 Feb 2022 15:33:27 +0200 Ido Schimmel wrote:
>> From: Petr Machata <petrm@nvidia.com>
>> 
>> Offloading switch device drivers may be able to collect statistics of the
>> traffic taking place in the HW datapath that pertains to a certain soft
>> netdevice, such as VLAN. Add the necessary infrastructure to allow exposing
>> these statistics to the offloaded netdevice in question. The API was shaped
>> by the following considerations:
>> 
>> - Collection of HW statistics is not free: there may be a finite number of
>>   counters, and the act of counting may have a performance impact. It is
>>   therefore necessary to allow toggling whether HW counting should be done
>>   for any particular SW netdevice.
>> 
>> - As the drivers are loaded and removed, a particular device may get
>>   offloaded and unoffloaded again. At the same time, the statistics values
>>   need to stay monotonous (modulo the eventual 64-bit wraparound),
>
> monotonic

OK.

>>   increasing only to reflect traffic measured in the device.
>
>> +	struct rtnl_link_stats64 *offload_xstats_l3;
>
> Does it make sense to stick to rtnl_link_stats64 for this?
> There's a lot of.. historical baggage in that struct.

It seemed like a reasonable default that every tool already understands.

Was there a discussion in the past about what a cross-vendor stats suite
should look like? It seems like one of those things that can be bikeshed
forever...
