Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16C6F1865
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 14:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345900AbjD1Mol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 08:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjD1Mok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 08:44:40 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBE283;
        Fri, 28 Apr 2023 05:44:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaRtnRcwr5tYMr/WeJ6xuzvrPJdhlyweQeOg20DXgGxO4ByjULd6Q1FhIPTkiecsu76rsPwqzIJ/RiVX8VvrYiITWjKw6maPu+h0XTX+6AS89NslkQjdrWIypbmOD39jmxnYgid/FZegmVmmPTG/bJs7i1NYrQk1U1XgedWS9mxKwVLb/ttz7rRX3I591cGMcIy43qAD0J2t0f929xMr73Tne9fqdoC+4lugnYdW3nxikHRC1JYPRmSGyTjoiu9Y3RbX2RwWNsca7kCRaRX7+zwzQDoxV+bR46wV/HMTL8x3Rx3UlLQijuBQT/Y5gQSbgD19WzvSYF//ElxfaMtUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0z80mmXiDUJOV5iQqRBKz0PAw7gI3n+qp21SDMvSl6U=;
 b=enj/zkjHD7BG0io/jV5KLtpzKfZ/PFPkvVX9cXOGTsxq8aYMgZY6PUqfI33UGt7iU8mIIlCoUPrA4VMKdZp2Bvyem0i1+E7uS5McUyXG32DRjqLl1r5ILmWuwQrQksYOzFG8fO8KI1O+Yj/L1QWQGso8KtUHiTJx6nE4vH/lzuh+SnAMA3khpTlh4fWHp669Uj1/GX5mlJ3lzgNWOBtiwZXPcFsAcSc2Hg+zQrRoj9DhWx+LuX31SAdQRIPDbhvSmBs4gpIxH5zwJjoCgXG+Ch1DCMtE5DlUtjDqD1e+5VfdQihAw14Lti7OYlXYrqSX0NOkvCDILzyMraEhjg4R0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=sina.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0z80mmXiDUJOV5iQqRBKz0PAw7gI3n+qp21SDMvSl6U=;
 b=N2jyRVYcieLoDEoYh+g/zipHNqcskZM8DGw1qZ38cg8wRFuswckQZimoPyP0yXWTGgonp1qb7HTfF9R7RV05KCfbnkZyc1q1VzQwySsst/i69GBIEDvHhqnGA9Gmmoy2N/zb14l6ZNw8VcVstFcWpQjguSPLJLIlPaY8yU6ofid3HSIWCFRRrIMgYaACy7QhqLUoovpQNoclIN43Wh7yfJ7XWFT723UV5n0t9cb1VUAYC3a0tjTwzd93JFW2gj+/5TDywyJxOsyH8+j0YnqdFxxagfrwVNylNcUrWM01r3+cC3Y0wQvLbAEhYJqHgl1g2Qfk/yySyPqh6MkZjrX+9A==
Received: from MN2PR15CA0043.namprd15.prod.outlook.com (2603:10b6:208:237::12)
 by SJ0PR12MB6783.namprd12.prod.outlook.com (2603:10b6:a03:44e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 12:44:36 +0000
Received: from BL02EPF000100D3.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::12) by MN2PR15CA0043.outlook.office365.com
 (2603:10b6:208:237::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23 via Frontend
 Transport; Fri, 28 Apr 2023 12:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000100D3.mail.protection.outlook.com (10.167.241.207) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.15 via Frontend Transport; Fri, 28 Apr 2023 12:44:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 28 Apr 2023
 05:44:22 -0700
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 28 Apr
 2023 05:44:17 -0700
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org> <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
 <20230417230011.GA41709@bytedance> <20230426233657.GA11249@bytedance>
 <877ctxsdnb.fsf@nvidia.com> <20230427173554.GA11725@bytedance>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <jiri@resnulli.us>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <xiyou.wangcong@gmail.com>, <peilin.ye@bytedance.com>,
        <hdanton@sina.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Date:   Fri, 28 Apr 2023 15:43:05 +0300
In-Reply-To: <20230427173554.GA11725@bytedance>
Message-ID: <87y1mcqiqq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D3:EE_|SJ0PR12MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 201ce8ef-0e4b-4fef-2b31-08db47e652a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sl/o1/JditHXq3pIA3aZvWi2a9Kxkh46RhB1plSTa5qBSZxnL7nfXGrhKxPruSYKGdidh0kyGjsnD5KX/f6v5+KHu/XFjghwWfCqOb7/k8ur+OsKP0iveHe1Mjy1Nbw8rJIfJ6aby1xajiDV0kNuPI421VKiYATEVyXihk7RMi/V9qwchE6C15r0R1oBMB77YNyfknEpsKUmjL/y8aipabqLIW4LupmZd+vOJqSiJKJPuhyUQS2vEhahXi55FFinDSFR5YxUiJ6fVJkml4O5Ho5ammW398ar3VHXj7TWcRDC7KP15lY0STr9U34hu4rTI3eq4MYyjsm3FWwKjsUdT6tggyH152WH8UvIf6WiEFWouYTetVZWdKZCQ6IYKkNB1RlroAKmjHsD63F158Tsa/2nYx6xoeUj4cRtVHKwNHkPfg+NdyEYUUFf6xoiWJ5438g1pbMGGxHA1A0aW9tTHlLRCa3EWlKLYmbP7d4M5h+STdmOhrk7n9nT6WGkk84HILdTPg+S3Kbc0y75wxJ63NJ8Eo09HJY02WOFThM2vcyAILLMLzeKhZ68iZw/GYOQTqwQLv/EF3MKdxlsDlf3wGWt42+/d3DB3HZjgK3U6VMyVy0XPprM/oi7oAHl7O++g6cvjwvjgAyKxubzF8SS64ki/Ukk0kPPqoSRZacZQdRmL3VD8UlHNzh5XQJ9DS9NpCAfUGzCe93mFFgKvR7AQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(478600001)(70586007)(4326008)(6916009)(70206006)(7696005)(356005)(54906003)(7416002)(8676002)(8936002)(82740400003)(7636003)(316002)(5660300002)(41300700001)(83380400001)(2616005)(186003)(426003)(336012)(47076005)(6666004)(16526019)(36860700001)(26005)(36756003)(82310400005)(86362001)(2906002)(66899021);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 12:44:35.5985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 201ce8ef-0e4b-4fef-2b31-08db47e652a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6783
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 27 Apr 2023 at 10:35, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> Hi Pedro, Vlad,
>
> On Thu, Apr 27, 2023 at 03:26:03PM +0300, Vlad Buslov wrote:
>> On Wed 26 Apr 2023 at 16:42, Peilin Ye <yepeilin.cs@gmail.com> wrote:
>> > As we can see there're interleaving mini_qdisc_pair_swap() calls between
>> > Qdisc A and B, causing all kinds of troubles, including the UAF (thread
>> > 2 writing to mini Qdisc a1's rcu_state after Qdisc A has already been
>> > freed) reported by syzbot.
>> 
>> Great analysis! However, it is still not quite clear to me how threads 1
>> and 2 access each other RCU state when q->miniqp is a private memory of
>> the Qdisc, so 1 should only see A->miniqp and 2 only B->miniqp. And both
>> miniqps should be protected from deallocation by reference that lockless
>> RTM_NEWTFILTER obtains.
>
> Thanks for taking a look!
>
> To elaborate, p_miniq is a pointer of pointer of struct mini_Qdisc,
> initialized in ingress_init() to point to eth0->miniq_ingress, which
> isn't private to A or B.
>
> In other words, both A->miniqp->p_miniq and B->miniqp->p_miniq point to
> eth0->miniq_ingress.
>
> For your reference, roughly speaking, mini_qdisc_pair_swap() does this:
>
>   miniq_old = dev->miniq_ingress;
>
>   if (destroying) {
>           dev->miniq_ingress = NULL;
>   } else {
>           rcu_wait();
>           dev->miniq_ingress = miniq_new;
>   }
>
>   if (miniq_old)
>           miniq_old->rcu_state = ...
>
> On Wed 26 Apr 2023 at 16:42, Peilin Ye <yepeilin.cs@gmail.com> wrote:
>>  Thread 1               A's refcnt   Thread 2
>>   RTM_NEWQDISC (A, locked)
>>    qdisc_create(A)               1
>>    qdisc_graft(A)                9
>>
>>   RTM_NEWTFILTER (X, lockless)
>>    __tcf_qdisc_find(A)          10
>>    tcf_chain0_head_change(A)
>>  ! mini_qdisc_pair_swap(A)
>
>   1. A adds its first filter,
>      miniq_old (eth0->miniq_ingress) is NULL,
>      RCU wait starts,
>      RCU wait ends,
>      change eth0->miniq_ingress to A's mini Qdisc.
>
>>             |                        RTM_NEWQDISC (B, locked)
>>             |                    2    qdisc_graft(B)
>>             |                    1    notify_and_destroy(A)
>>             |
>>             |                        RTM_NEWTFILTER (Y, lockless)
>>             |                         tcf_chain0_head_change(B)
>>             |                       ! mini_qdisc_pair_swap(B)
>
>                       2. B adds its first filter,
>                          miniq_old (eth0->miniq_ingress) is A's mini Qdisc,
>                          RCU wait starts,
>
>>    tcf_block_release(A)          0             |
>>    qdisc_destroy(A)                            |
>>    tcf_chain0_head_change_cb_del(A)            |
>>  ! mini_qdisc_pair_swap(A)                     |
>
>   3. A destroys itself,
>      miniq_old (eth0->miniq_ingress) is A's mini Qdisc,
>      (destroying, so no RCU wait)
>      change eth0->miniq_ingress to NULL,
>      update miniq_old, or A's mini Qdisc's RCU state,
>      A is freed.
>
>                       2. RCU wait ends,
> 		         change eth0->miniq_ingress to B's mini Qdisc,
> 	 use-after-free: update miniq_old, or A's mini Qdisc's RCU state.

Thanks for the clarification.

>
> I hope this helps.  Sorry I didn't go into details; this UAF isn't the
> only thing that is unacceptable here:
>
> Consider B.  We add a filter Y to B, expecting ingress packets on eth0
> to go through Y.  Then all of a sudden, A sets eth0->miniq_ingress to
> NULL during its destruction, so packets will not find Y at all on
> datapath (sch_handle_ingress()).  New filter becomes invisible - this is
> already buggy enough :-/
>
> So I think B's first call to mini_qdisc_pair_swap() should happen after
> A's last call (in ingress_destroy()), which is what I am trying to
> achieve here.

Makes sense to me.

