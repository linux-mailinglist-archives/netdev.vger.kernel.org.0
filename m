Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27683679AF1
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjAXOBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbjAXOBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:01:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA8147EC8;
        Tue, 24 Jan 2023 06:01:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQprz+TiAEH4pdhSmdF77ocNYOy30ag05TXD+mxssOV1kMc6eSDa//Lbf4yglcnk1HEh0WcIRGmkTFA1FvTnpT5ctMpoJjUex0A7HzK7La8S9J62vzUnGgMPV5KVHtC63pp8r9o1nkREqT4tYYKo5O4la/CuA0EuBguaTrcG+oQJ2Bu5zMUUYzntxabK8QpYZ/RkQc9PzSYQy2t9wr9BfoDW5AtW/jND5nSljSgM/vty7jE9mkwknJHxl9+FS9Zits5+GlwHurtp05tb5uFYrbOaz1eEueXoqgZsbMNQaey8oh3FYKixlUclFtKSL8Rbsk0/u1HARDsG4r221TBOtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SM18aQLSNxN6UBjaagc6U3PhaHLHlrf+yJzro0vZb5U=;
 b=byYEkl05V8k5s6zAoNEM6FbxseSVU5DXCSa28bVxftv0hfd8nvzbc9SvJcqYyfrlNBssyum5hi1Z5SCgCN9unonqbxfJA/sP20CZjMxU+lO6COEhU+rnT369b/SGAptIktCCXd5OqqTGU6f+shX4Z4y7btQQjldINeMdaHSvBlvYNfP2ps+XJYF3MTDBHmJZqhmz1lQVhk0YJ0pZ7TdHApDP3Eecl4oX/gxFYUctCss8dvEcR9paKRSWt9/nbptH+OnxYc58ik+FFZcV2okJKjjil6MPFCuM5NM44gPrWJvf9QVk3j1FI/m7WrK7zMp85Ez/gmay8otSWsS5wfuayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM18aQLSNxN6UBjaagc6U3PhaHLHlrf+yJzro0vZb5U=;
 b=MVxOjov1P0eqDjXIxo0ujHJfhz/DtpAS+1hNTEfWk7gNcXi+vQ1jKcFWc4oWHY0XytAOrBbK1vATzBHFWnjBDuSdZEeTKt57raPqedbQ9xQoQ4xZrEe/x2EOIZ9f2VBEP/4hOx+spDTj+q0SHdBKfbrnuh/HtgEdwd1SQt0YUXUX4S5DWSYPZw0+FWCmohFXSOfUoqxbSQT+WKCh7TK7wdjfvb8SD7cbUQDb4IWE1Fmd+mhk0FL3wGe9ldda7l0GlFFBwNrXP2FPIN3+v/Q+30vOB+lioGZYmZsMc4NW6wr5qSDh/gmDXmS3oNNJelagzLuLdg+cFKBJfx3L+p4YCw==
Received: from MW4PR04CA0141.namprd04.prod.outlook.com (2603:10b6:303:84::26)
 by PH0PR12MB7838.namprd12.prod.outlook.com (2603:10b6:510:287::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:00:38 +0000
Received: from CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::e0) by MW4PR04CA0141.outlook.office365.com
 (2603:10b6:303:84::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:00:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT094.mail.protection.outlook.com (10.13.174.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 14:00:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:00:21 -0800
Received: from fedora.nvidia.com (10.126.230.37) by drhqmail201.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:00:18 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-5-vladbu@nvidia.com> <Y8p96knLDtxnRtjz@salvia>
 <871qnke7ga.fsf@nvidia.com> <Y8+Zny8S9BQm7asq@salvia>
 <87sfg0cmnw.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Date:   Tue, 24 Jan 2023 15:57:17 +0200
In-Reply-To: <87sfg0cmnw.fsf@nvidia.com>
Message-ID: <87o7qoc9sg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 drhqmail201.nvidia.com (10.126.190.180)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT094:EE_|PH0PR12MB7838:EE_
X-MS-Office365-Filtering-Correlation-Id: 99425598-4d2f-41d4-a228-08dafe135efd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjZyQwQN1u1qINRcFGMfklvhwoMmv5Pj19/B3OMGLqWvorIigGSHwIoptEKBGpNvL61ZCTBh+ggpq1/N5a8fRwNl0UkV35G47CF0KFpkYWgVA0exxKUqvsSd5VfD9+qQM/qG/L0/TpEqjZ0QrolG4n2G9lom/S2WqWLNL3T8OaYNiUzVAPd5Yv2Hr07alfmwALpdWoehebjTWEzR6MBwRmqkGWSBD45Bqvgj8TY+CQKIsfiTMk6dR1e2zOdkX4RsLO81ApyPt4trM3TF6iTd+wMzYN860fuoNIGVTXb4R86TDUUMMtZvBybAmeL8uZcKnz3Ntzd5tRTmQT0E9zDA55ZxZjbdUGkPda8pnYLhWjUoLpU4MRGXFNXVm5SHYPGg5WJHA2i3mxHV8nGY+qaZL5y9+SSWA/6UEzyKjtEq+bI0Az1/yMEvImjsurf5xJ5etNjuLrLc7SNDf5ywqsgLnXhwlUhkBcPAxqgIO1MfPJvjhEXjOsM4iPJQD1G0HgzhW1ZsjoxEmpRS96nORIKzaPl7X1TVSaBnQAceP5TxNYQE/kNDFM8y3ICYcf4m64hl8c2feSTmHeWpIBoN+Ly/Bf3ULxxEdZWqBb2TH6J66bF76dbWk1CrapOjGksl+Onelf6OPPDsjyfmdQ3ZqkcMh7AQTTps7BV5TJF2/FBlTmT1Oe8A28mxggFFWR/8c4jNLsTLW0rVe+x1TLXiWc40hw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(36840700001)(40470700004)(46966006)(7636003)(82740400003)(40460700003)(36756003)(40480700001)(356005)(82310400005)(86362001)(478600001)(316002)(336012)(6916009)(2616005)(16526019)(8676002)(70586007)(426003)(47076005)(4326008)(70206006)(7696005)(54906003)(2906002)(36860700001)(83380400001)(26005)(41300700001)(5660300002)(7416002)(186003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:00:37.6766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99425598-4d2f-41d4-a228-08dafe135efd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7838
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 24 Jan 2023 at 11:19, Vlad Buslov <vladbu@nvidia.com> wrote:
> On Tue 24 Jan 2023 at 09:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Hi Vlad,
>>
>> On Tue, Jan 24, 2023 at 09:06:13AM +0200, Vlad Buslov wrote:
>>> 
>>> On Fri 20 Jan 2023 at 12:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> > Hi Vlad,
>>> >
>>> > On Thu, Jan 19, 2023 at 08:51:01PM +0100, Vlad Buslov wrote:
>>> >> Following patches in series need to update flowtable rule several times
>>> >> during its lifetime in order to synchronize hardware offload with actual ct
>>> >> status. However, reusing existing 'refresh' logic in act_ct would cause
>>> >> data path to potentially schedule significant amount of spurious tasks in
>>> >> 'add' workqueue since it is executed per-packet. Instead, introduce a new
>>> >> flow 'update' flag and use it to schedule async flow refresh in flowtable
>>> >> gc which will only be executed once per gc iteration.
>>> >
>>> > So the idea is to use a NF_FLOW_HW_UPDATE which triggers the update
>>> > from the garbage collector. I understand the motivation here is to
>>> > avoid adding more work to the workqueue, by simply letting the gc
>>> > thread pick up for the update.
>>> >
>>> > I already proposed in the last year alternative approaches to improve
>>> > the workqueue logic, including cancelation of useless work. For
>>> > example, cancel a flying "add" work if "delete" just arrive and the
>>> > work is still sitting in the queue. Same approach could be use for
>>> > this update logic, ie. cancel an add UDP unidirectional or upgrade it
>>> > to bidirectional if, by the time we see traffic in both directions,
>>> > then work is still sitting in the queue.
>>> 
>>> Thanks for the suggestion. I'll try to make this work over regular
>>> workqueues without further extending the flow flags and/or putting more
>>> stuff into gc.
>>
>> Let me make a second pass to sort out thoughts on this.
>>
>> Either we use regular workqueues (without new flags) or we explore
>> fully consolidating this hardware offload workqueue infrastructure
>> around flags, ie. use flags not only for update events, but also for
>> new and delete.
>>
>> This would go more in the direction of your _UPDATE flag idea:
>>
>> - Update the hardware offload workqueue to iterate over the
>>   flowtable. The hardware offload workqueue would be "scanning" for
>>   entries in the flowtable that require some sort of update in the
>>   hardware. The flags would tell what kind of action is needed.
>>
>> - Add these flags:
>>
>> NF_FLOW_HW_NEW
>> NF_FLOW_HW_UPDATE
>> NF_FLOW_HW_DELETE
>>
>> and remove the work object (flow_offload_work) and the existing list.
>> If the workqueue finds an entry with:
>>
>> NEW|DELETE, this means this is short lived flow, not worth to waste
>> cycles to offload it.
>> NEW|UPDATE, this means this is an UDP flow that is bidirectional.
>>
>> Then, there will be no more work allocation + "flying" work objects to
>> the hardware offload workqueue. Instead, the hardware offload
>> workqueue will be iterating.
>>
>> This approach would need _DONE flags to annotate if the offload
>> updates have been applied to hardware already (similar to the
>> conntrack _DONE flags).
>>
>> (Oh well, this proposal is adding even more flags. But I think flags
>> are not the issue, but the mixture of the existing flow_offload_work
>> approach with this new _UPDATE flag and the gc changes).
>>
>> If flow_offload_work is removed, we would also need to add a:
>>
>>  struct nf_flowtable *flowtable;
>>
>> field to the flow_offload entry, which is an entry field that is
>> passed via flow_offload_work. So it is one extra field for the each
>> flow_offload entry.
>>
>> The other alternative is to use the existing nf_flow_offload_add_wq
>> with UPDATE command, which might result in more flying objects in
>> turn. I think this is what you are trying to avoid with the _UPDATE
>> flag approach.
>
> This looks interesting, but is very ambitious and will probably be a
> bigger change than this whole series. I have an idea how we can leverage
> existing 'refresh' mechanism for updating flow state that doesn't
> involve large-scale refactoring of existing offload infrastructure,
> which I would prefer to try first. WDYT?

Update: to illustrate this point I prepared V4 that uses regular refresh
to update the flow and also tries to prevent excessive wq spam or
updating flow offload to a state that is already outdated.

