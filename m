Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB934C4BC3
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243504AbiBYROC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiBYROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:14:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9281A7D8C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:13:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCnroQmWw8IAqma5cqXVcbQflD53Pq/2mbQD7RQD8qQDDxxnCACxymq0zV6ubxnwh9X+4BsnqJmw4laOdeapaaxw+9dhpFJac1fj7/da8H21+D/WIbkgyWzcCiPDvzPim4u99Ac2sNpsjYDo6y4HEYHgeVAW9L60dwvAR50jLlruUA2HXxOUvR0zUNm5RpPcRVb0GInqf60qtStd78Qv+TF7DGBZzrmlqma4QKF//u84NLe8xB/jMJh9QRdCyeso5N+w3E/5myLXtDBDvX7thqlwCUme7Qa4mnA/cTck7aHm7RvFfi7+T72J4SxgdWEkMYeoSmHTBXrLsEuuEWHuCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBXf4Lm7mOPGSxMsk4T/qWAEw2KyhMm2Owgi3NIV+wg=;
 b=Jop0vDDAiHNQtTRtoYlfCQ78vl+x9X2bqS4oSJsB8eBArpow590N8lLOVSpB8gCUjb/+Wqiln0FNfX+EXfeKydstcajPyNqP8mBgVL93WeexkLVMHR4C8nyKV428nuNj1tjnQZW2gXI1UV9v3ugrnAQQTKskRecscdl9GsYktS7ZokDaGydhsQdPrSmC7xZQCafwVNYrX60KaVuoTfQLGi70g53hKtYVaKWU8ONe9sT1iKnzkDZVZ8qfaxiU6cgrp2jA0XZZu3fmT25OExzcQ34Mh0RdlWDYi2lmE38YucL0hcNIXQI/0mu6WBSAqjFXfJHgOpLKjITVZ+QbjZd1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBXf4Lm7mOPGSxMsk4T/qWAEw2KyhMm2Owgi3NIV+wg=;
 b=bIAABFFK/VFgDYQ/TRL8XyPhrIgtedr8pPJZv5KlPrFvoofb7/TFnNjryDjKH/DX3nbvAN5NyCYP8z1DXqiKikc6dBjD/jefrVhY3yFg16YC17rrd8Uk/MeoWLWWRKof6CkJJugEsGHpMSKtJ1WhNIYDD9XiKWJjiC9bf+wiW2bZtiYhYqd3RpqhNgFgJrHpDtpKSfoTYb2FilycP/zQpnHcoEY6qi7GodH0K/8iW48bW9XRmFBENkJKE+zZwAV4D3R0ziEMhXb623S47wB1SkIR91CC1ev+RYLXrMFdVVU/ms37tEq/vewA2ee47D0rRSdYA2cQ1ouUpNtLKsYh2w==
Received: from MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::28)
 by LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 17:13:27 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::3b) by MW4P222CA0023.outlook.office365.com
 (2603:10b6:303:114::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Fri, 25 Feb 2022 17:13:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 17:13:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 17:13:22 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 09:13:18 -0800
References: <20220224133335.599529-1-idosch@nvidia.com>
 <20220224133335.599529-7-idosch@nvidia.com>
 <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8735k7fg53.fsf@nvidia.com>
 <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <razor@blackwall.org>, <roopa@nvidia.com>, <dsahern@gmail.com>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Date:   Fri, 25 Feb 2022 18:00:11 +0100
In-Reply-To: <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <874k4meuoj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d963d23e-dee2-4b6b-3077-08d9f88221ef
X-MS-TrafficTypeDiagnostic: LV2PR12MB5845:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB584580D58111C483D5F964B8D63E9@LV2PR12MB5845.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8rkTnBdKi4xxU8C9laWFfFpwURGQIdyg/Cz9yQQLtOXdij1d/KkEhac3Wy12Ki85hp0I+ZO/4iuXEG6GWAFDQs/ygYCBCwHRESmXw+vJG/2tEhpTKB9tn3fNM5CD0NedzK0jww2bEygueJTr/oZrJxccskbzPnRbqvH46agUNUe3JQFF35SPfv2Sa8xMQuNlsjm/xfGe1KgsAtd1oIeCKCWdggghQ4Lsq3HUEtYZ4eXWqHnukj3+/DJoFrm0sW34PX3XnA76YlDFEw8/jMDMhW9SQuwVOESFYyYL9gm2Yv2G4kzKksgoX5b+8WCYIraI09S7I7dNFItwbFqFK8CpBzfpQmNo1ztk0EvqFF5W705DDd5AuXxWFowXpQGO/Eu6TX/Wkp4BW6RU/41nbQWfzZs8Ch/e5iG0g3PPYA607uahu/OxfoCsqEEhGeedYVX5WUOo9q0/vaGltsiPUJOSa4IcEc3kmiNFVA8qxL0AFhmAAU3JqMPyj+cDp8NXCSgfCa2IYDypWB4gAJX14jsJ4rUauCU4H/zKZ13i/DS8qMGZ8JSvmeoMPN+UR+0W+k54K8U/LB4k4zTo58VK/Wo0yBadZpp8l+EpaROxxXn3ELDPnqmcTMBWuSJInXfQFuGL3ZFAFLz6ahdUqmtRwAQEjfcPNgXe9GnhA9YI3Lt0oKJOggy7+Fh+Qc2vtGs29S1lumW0eX3zcAWBd+B+58nsw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(4744005)(107886003)(5660300002)(26005)(356005)(2616005)(316002)(54906003)(6916009)(82310400004)(186003)(40460700003)(6666004)(8936002)(81166007)(86362001)(4326008)(16526019)(8676002)(47076005)(426003)(508600001)(36860700001)(36756003)(70206006)(70586007)(2906002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 17:13:24.7458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d963d23e-dee2-4b6b-3077-08d9f88221ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845
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

> On Fri, 25 Feb 2022 09:31:23 +0100 Petr Machata wrote:
>> >> +	struct rtnl_link_stats64 *offload_xstats_l3;  
>> >
>> > Does it make sense to stick to rtnl_link_stats64 for this? There's
>> > a lot of.. historical baggage in that struct.
>> 
>> It seemed like a reasonable default that every tool already
>> understands.
>
> What I meant is take out all the link-level / PHY stuff, I don't think
> any HW would be reporting these above the physical port. Basically when
> you look at struct rtnl_link_stats64 we can remove everything starting
> from and including collisions, right?

My thinking is that stats64 is understood, e.g. formatting this in the
iproute2 suite is just a function call away. I imagine this is similar
in other userspace tools as well. There are benefits to just reusing
what exists, despite not being optimal.

But yeah, those 120 trail bytes are very likely going to be zero.
I can shave them if you feel strongly about it.
