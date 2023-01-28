Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3D67FA73
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjA1T36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjA1T34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:29:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC752885D;
        Sat, 28 Jan 2023 11:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeMLTuaNjFPIoZZYt379T4cc/v9YTkOa4niE9qoC4iCOyDwgvKtuHxaab2IE4iYuCR8VlRYo6yI3+8/L4DP8HaMC2OjOHNTb9yivBGzDQgp0Oo4r7cozMLBLv0B8rIuYRgko2iyV4H6uabLL5r8pO3Tl9N7jAhCUnpqFA0NaWw3HsXiEJYuAoUjMrJLJx7RaptTzzOBoaY7x5URlqttSEMJE4q5wUc+lOzYPZZLDEb2jUFjvZ9NZmJuC1mp4e4sCazN/hi4CpreE8eyWQV9szjLT2hmeBLCVAWlae890ZwpbrwWPfrXUkD9OSGUyFL5UygJI0ndsJVHTvZjLeX49Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNSPIBaaNuebJAJsNWN8gQDN8WwytA/QAL8Q2dOFkns=;
 b=HNK5Xo9XDILvsWe+ALfcen6/2nt3AXaiqF3vgZMvopfb56VXEDH6JEySTl1UttBj1v6Ax4+SOE4I+t6W0ShBBK1V8gCs30vYEOeNn6oN0VU6F3wJgctmMJRxU2ciM7Qevw7Vy5yuZ/Wrj4KvhiTu4VMn1pajmZxjscrXF1Gaq5vox2shiYRYUwb3fp5NCbZf9dvECkGitG9qsRkx32+VKG8cb744sijKPbOZmeziGh6GVBsAoG2/uWulLOESneRu4fmpEHssIBzGwwuiIsJqw1v4T4A6S9TjjSdyPE7RdieQP0mj1KV5QOv84sGAZ2N0pvSkO231ue/YfYLXAZnSkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNSPIBaaNuebJAJsNWN8gQDN8WwytA/QAL8Q2dOFkns=;
 b=ogpMGNrhlCDL7B7M1DXE1Q1tShrRoIYquPnNog5K33j8V4dm++VGPkeQZtqGDwWrnL7RbtKi/jp/TQJh2nWTgYyMTrTs8splPiVBoyxUgpuN2EsrOxm7eKMMMG+hc6iIqoaCgyc1g0Hz8Ngl2QjIO3zpcUFhp7dH+QInjHYBe+U9bX3CfSbBfz9oZiN3yCKul5E6zxdJju3po+ykZ1iEbX8r6UlQHd9QwsmSoGMhY+dPZmX58QR2njloJg0NURKYDYlQoCl5rQ0NTcKSXuMrclOm0qVVKEUqfQ/AZzqigHy0ipYiOe/JY7FCNHDQpLsc91kzo+9YSKyGvUm8lWhyag==
Received: from MN2PR20CA0034.namprd20.prod.outlook.com (2603:10b6:208:e8::47)
 by PH0PR12MB5403.namprd12.prod.outlook.com (2603:10b6:510:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 19:29:48 +0000
Received: from BL02EPF0000C405.namprd05.prod.outlook.com
 (2603:10b6:208:e8:cafe::3) by MN2PR20CA0034.outlook.office365.com
 (2603:10b6:208:e8::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.31 via Frontend
 Transport; Sat, 28 Jan 2023 19:29:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0000C405.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Sat, 28 Jan 2023 19:29:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 11:29:36 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 11:29:32 -0800
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-7-vladbu@nvidia.com> <Y9U+pW/2qDskLiYc@salvia>
 <87r0veejeb.fsf@nvidia.com> <Y9Vy8Duq8nf/KeRW@salvia>
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
Date:   Sat, 28 Jan 2023 21:28:34 +0200
In-Reply-To: <Y9Vy8Duq8nf/KeRW@salvia>
Message-ID: <87edree9uu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C405:EE_|PH0PR12MB5403:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e1ee80-4b82-4abb-7bf9-08db01660427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqJnDAbKsbt6Xt/eNp8LPngAcQxRzJuZGPo8bmRlTQeL68PpzotrkASVLs6chqBUXvdb6VrxHUlm9zBJucrRSszW/P3V+cHzcmVBu8Yp1Sys8gUr+waCSTElbIgs0ebuId6FhwFop72SW6mUvfh5YAzvPVuq9EL87xhML1i/YHDu2gMyS0BRbWxZ2RaO5ZhsfKxt/po0ZH2kA3kBWf0w2xjo1Ylnggwv+sUaGqSmNsI9m76VVYLdcJQkGx2J4CB53xY8+Lla+2ybyeArrm3nTmIWxkqtxyeYsnMaMx2B95wH63fLD3CHV4v/NTshFJWJZeb5Ne5EjiqL4Hte3Z4s2RUHLo3p9ELi9m+lyfj+Q9Emi9DDX4g5rXhCNq4SqiCKj7p2j5EUua2h27nP3wEoU13sfj5+D2fa7S0f3VqzDEpjk/Qi06jL/slh0fx5kh3CPpygKYhu6rMih11k/hewE0obogb3ttaGpQf9++qo9jAW27x3qf7nZdE9WpL4lvBh1Zyt0b4bk0d9/OGx5/6CYnLCu/56pSkFKyqCuTi/JK5sh1EeufzK05mZq02470V8T94RxJJJagFc6QMKUAohSL1cbttCSWP9yyT2m5khE4xIIe3G+D9OMizXI+RIneC8S89Uid1DrCXgVCnFDpM3Vcay6Z1zJwj/uCsJ3RMgb9ZGz6q1CH6osHv1VJchUCUCPPuoIxnHuxyZ7mlbeYi33A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(2616005)(7636003)(82740400003)(40460700003)(36756003)(7416002)(186003)(16526019)(356005)(26005)(40480700001)(7696005)(478600001)(86362001)(2906002)(82310400005)(316002)(54906003)(5660300002)(70206006)(6916009)(47076005)(36860700001)(41300700001)(70586007)(4326008)(83380400001)(8676002)(426003)(336012)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 19:29:46.9014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e1ee80-4b82-4abb-7bf9-08db01660427
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C405.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5403
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Jan 2023 at 20:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jan 28, 2023 at 05:31:40PM +0200, Vlad Buslov wrote:
>> 
>> On Sat 28 Jan 2023 at 16:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > Hi Vlad,
>> >
>> > On Fri, Jan 27, 2023 at 07:38:44PM +0100, Vlad Buslov wrote:
>> >> Modify the offload algorithm of UDP connections to the following:
>> >> 
>> >> - Offload NEW connection as unidirectional.
>> >> 
>> >> - When connection state changes to ESTABLISHED also update the hardware
>> >> flow. However, in order to prevent act_ct from spamming offload add wq for
>> >> every packet coming in reply direction in this state verify whether
>> >> connection has already been updated to ESTABLISHED in the drivers. If that
>> >> it the case, then skip flow_table and let conntrack handle such packets
>> >> which will also allow conntrack to potentially promote the connection to
>> >> ASSURED.
>> >> 
>> >> - When connection state changes to ASSURED set the flow_table flow
>> >> NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
>> >> the reply direction.
>> >> 
>> >> All other protocols have their offload algorithm preserved and are always
>> >> offloaded as bidirectional.
>> >> 
>> >> Note that this change tries to minimize the load on flow_table add
>> >> workqueue. First, it tracks the last ctinfo that was offloaded by using new
>> >> flow 'ext_data' field and doesn't schedule the refresh for reply direction
>> >> packets when the offloads have already been updated with current ctinfo.
>> >> Second, when 'add' task executes on workqueue it always update the offload
>> >> with current flow state (by checking 'bidirectional' flow flag and
>> >> obtaining actual ctinfo/cookie through meta action instead of caching any
>> >> of these from the moment of scheduling the 'add' work) preventing the need
>> >> from scheduling more updates if state changed concurrently while the 'add'
>> >> work was pending on workqueue.
>> >
>> > Could you use a flag to achieve what you need instead of this ext_data
>> > field? Better this ext_data and the flag, I prefer the flags.
>> 
>> Sure, np. Do you prefer the functionality to be offloaded to gc (as in
>> earlier versions of this series) or leverage 'refresh' code as in
>> versions 4-5?
>
> No, I prefer generic gc/refresh mechanism is not used for this.
>
> What I mean is: could you replace this new ->ext_data generic pointer
> by a flag to annotate what you need?

Yes, will do.

> Between this generic pointer and a flag, I prefer a flag.

Got it.

