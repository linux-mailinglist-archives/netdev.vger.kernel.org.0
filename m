Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7C67F969
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjA1QDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjA1QDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:03:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0D8C17E;
        Sat, 28 Jan 2023 08:03:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgyxQRf2NhyD6PO+GN2Aplmi5KII6aVw/XoVRCMsLt0Z7fS7oPmDmlzcGCzw9NNihrJ1eLD61tJ0xQbU7c3FOg0O7mvkBpOilyhtgP+tPE14RuMcPtQRAdzrkJzYJzSUidySnN/vV7o015GW7baY1TH0tYEv9KFZXTc4/VjguvEjle5YSej5dQ1YgO9hNHZrwUdNNLoECrCiWis/BhHsawqKLYULwX1tj6EEBq/xb7RYElLY0CBAUJjmGvhPX+bmkg1KFP3JHUNYnw37noZ1e1rLceA+whAHm7Gl12bYBD7CM0elOPvCfBB0kPi/6XIFz530Kgr1kt4NRAHhlUX5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZIMRus20zSsysvxZegG+NYEcIfpEhpMgYMDdXMrFpU=;
 b=L3TZ+ScDDZRhAX+rBrtog6b4U2Vgx5T58kBDCospKDNFyQE0pKs+Om1omT8T1QiCVYWSz1X3pv+hqtN1Dkv1R98yxaDx84LaU0fqyedKXGTM7DoGimjF9HL2PrWN6l8pDId1A8/mbH+5n9T922/8atnSJCN0sWvbXPkytzyq/HEHmx7EDZ5rp89NETAJVZCHx3fAqVpuHV52d8hxCF9qXsdZwltG+5VZagbiq1+pq/k0Q4MRNlTRrWGMspN3apTVqkTfEkSpF+5uYgtCkrui0bR3o55oxMKBxyVbThAsbBsOjiSUKKaTZ+sF629EOmLtOlkMGLdps5RbXEwcYn4QHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZIMRus20zSsysvxZegG+NYEcIfpEhpMgYMDdXMrFpU=;
 b=D29NjcPfDMzCe7I0OLvigmvbi075b6tZTSHaIQ3pYkgiiBy/Sxb7uegB3luKm8iYQReYjsnWHsmSWZU70I4/uL6ecSWYqZPmv37riMbKfNIi3jVa1/gzikVNRiBens5uo2bE97YxnrIUi6eXzSzLXYITZ3P/QYMPENF24ACx4/6lgGWGesFQSNEZetZR/wFYAqf11S2dRsGwThhJt5YeH5nJYzyTvfMmciELBqzB95W5fjVxbo67xI1OqzJlgKH0zcHMDmiIPjrU6X5vqSTzuZ++c7IPYjncEDB2/2vAEZmEtH4bAk5HHmFkxVj1Te2gnpLa0dVTKct0xdJPlEdUnw==
Received: from MW4PR03CA0285.namprd03.prod.outlook.com (2603:10b6:303:b5::20)
 by MN0PR12MB5956.namprd12.prod.outlook.com (2603:10b6:208:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Sat, 28 Jan
 2023 16:03:44 +0000
Received: from CO1PEPF00001A62.namprd05.prod.outlook.com
 (2603:10b6:303:b5:cafe::6f) by MW4PR03CA0285.outlook.office365.com
 (2603:10b6:303:b5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28 via Frontend
 Transport; Sat, 28 Jan 2023 16:03:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00001A62.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Sat, 28 Jan 2023 16:03:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:03:32 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:03:29 -0800
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-7-vladbu@nvidia.com> <Y9U+pW/2qDskLiYc@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v5 6/7] net/sched: act_ct: offload UDP NEW
 connections
Date:   Sat, 28 Jan 2023 17:31:40 +0200
In-Reply-To: <Y9U+pW/2qDskLiYc@salvia>
Message-ID: <87r0veejeb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A62:EE_|MN0PR12MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: 2863465d-c86f-4b59-353e-08db01493a2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nBGc2thj1pfLdJALqyiy/pbjxf4HqW6TZl364vFI9ib8eqY425dYFurjADfkrN1OhFI5QH2tPYN9CBIEsTsorQH7ykk3qnF8j1a3BAxjJc63u3U+jxFf+OMUvVVrC8Azc6OWPObl4cAE0xszH+2V6R4AfBkVFi/18fcv0nhVaUYIOCnA56jmyYc1TOMwd4dbx+3nKOHPqcUQW7griUcxd9BU8vBA3CfAGRH/HUKxVuCCXlMWyHbDB3uWucEnlEpdBXSHZpzgzzHUXf5LiZtXJRSKOH9UKJLzg6QJ8HUGhy0/cKwSm/YLjXAOid0aHl8TkJDSrvp0IoVPxH0F4yyWssSAEVU+hBsW9NnpMQ1NwQSV70XOQtG8UMYxOxtrz3Yz3gYtGR5bSkF/TL7D1rbQ0+i3ufPbdHrAPGYgmxcztvOsTJtW7GHx/ksrf8ub7ovsRQwRoS9NnLfZ+o7GkajFtBU/hwRA0O5IYlVKAJavcnitxwvPGJnHdWHEpxwMp+kJzgCtR1SGOt5nuAKmKBEntGTsRjhb+SxF26RS8nrRXDjeqiWSaTRiQqeB27fm326zpmbzrisVizzmtJRQET5S0wKnDx8FUJy0es7qT4nALrn2lijlwsIDDYk1ex0UH41R15CaRwvM98MBQGaH8+c1VfK2FXQjIOdnP5acPJCprGZTHNcmzQxTcYb5uUYLMwz7ANiHmWeG2/51Ydr9Qc0UA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(356005)(478600001)(40460700003)(7696005)(2906002)(36756003)(2616005)(83380400001)(426003)(336012)(47076005)(40480700001)(316002)(54906003)(16526019)(86362001)(186003)(82310400005)(82740400003)(6666004)(7636003)(36860700001)(26005)(7416002)(5660300002)(41300700001)(8936002)(70206006)(70586007)(6916009)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:03:42.2270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2863465d-c86f-4b59-353e-08db01493a2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5956
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Jan 2023 at 16:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Vlad,
>
> On Fri, Jan 27, 2023 at 07:38:44PM +0100, Vlad Buslov wrote:
>> Modify the offload algorithm of UDP connections to the following:
>> 
>> - Offload NEW connection as unidirectional.
>> 
>> - When connection state changes to ESTABLISHED also update the hardware
>> flow. However, in order to prevent act_ct from spamming offload add wq for
>> every packet coming in reply direction in this state verify whether
>> connection has already been updated to ESTABLISHED in the drivers. If that
>> it the case, then skip flow_table and let conntrack handle such packets
>> which will also allow conntrack to potentially promote the connection to
>> ASSURED.
>> 
>> - When connection state changes to ASSURED set the flow_table flow
>> NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
>> the reply direction.
>> 
>> All other protocols have their offload algorithm preserved and are always
>> offloaded as bidirectional.
>> 
>> Note that this change tries to minimize the load on flow_table add
>> workqueue. First, it tracks the last ctinfo that was offloaded by using new
>> flow 'ext_data' field and doesn't schedule the refresh for reply direction
>> packets when the offloads have already been updated with current ctinfo.
>> Second, when 'add' task executes on workqueue it always update the offload
>> with current flow state (by checking 'bidirectional' flow flag and
>> obtaining actual ctinfo/cookie through meta action instead of caching any
>> of these from the moment of scheduling the 'add' work) preventing the need
>> from scheduling more updates if state changed concurrently while the 'add'
>> work was pending on workqueue.
>
> Could you use a flag to achieve what you need instead of this ext_data
> field? Better this ext_data and the flag, I prefer the flags.

Sure, np. Do you prefer the functionality to be offloaded to gc (as in
earlier versions of this series) or leverage 'refresh' code as in
versions 4-5?
