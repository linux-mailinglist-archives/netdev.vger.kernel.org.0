Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2154A6EF45F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbjDZMcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbjDZMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:32:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10hn2247.outbound.protection.outlook.com [52.100.156.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF7F5FF1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:31:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRfNgk64KE6dd8pDh7hmustFk3+DeBJHCwKRcswC9Htx2MV4NI8xSImWfnkiB2U5PJg1iNr/aOGa5H+2y3y6pEA3nCvfWmsA4suu6+mFWgClAy/Lx4jZ+axqfg4HHxYv96BMPJrRcS7olVpS1Yv4/gwt+rAasbGoYxUmNnx96Wuye809o97soUvaftH9UEKB/SVBNA0P91LDqlK79mJ8s7Nj9Ux7lnnnjFI/dn21fQrKyUwK6GJyHUVJePIkeQkz217k51mj1kL4t3TYg5G5ZLygaNnAKPJf492WIZRO5Pe6MxlHHi8qWBVzl25D7yGQZzbinvYI84P8YnErOCftVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdX2XLr7zdbTvoRUPSd3z9hNqdJWovMXCWokoXqILt8=;
 b=Rcrh0oTjUnTCc2lUY8gV1Yhxif+pfEltfjxR3erR9mw4EblrdrlgZsXkypC/VPzqiLJGDBD86U1UrU97taH1ukewZMyjpf7VT73+o7k7U2cNqojj+Y+04Ok4dJ/36uchXWS2njTdpQbB8n2sA8SG16pLSopHYbHsnCXx0SGjlRsTviY2Y6Fw/8QVx2lceJmfAy/cqZpLbduQ0nLafcTG6GX2oxRoHDUPEDKnqiLokTxri7QZ6L+o7MzsZmoPT4sCeH4iRjvSSv1fscrBm72zc7cvLDP/mpqs5kIyJqGPNQzRqnS22bIElqfQNFaG3Pz8BISi2HxBq0KN/CZl65m8mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdX2XLr7zdbTvoRUPSd3z9hNqdJWovMXCWokoXqILt8=;
 b=cByiQnHBdq7yEMmCVKnangT8mUdPyIHzi+l/DktQ3bToMjALjkX18XWnDrNw3UUxYAv/7fhYj2AzUOfO3p2msHV76HA8Te6uvXY/hpO1QpH6Pg6ME53ZVpdy+mssMIzPP5oRu0aPXjSS3mmzHO/wcvWw9AGx3WlrzR+mjh9KOibU4mZcboSuQiLVEz/AufxrT8KNFRapgHA328bICC92nx0ofH0FETD2SrjLpjKjVGIgN+Vw9Rh5issuKKEGZTl6ZUu6FWhkPTNL2OKCg+Oj1WH/wLiJG7jX7ouD0ieXFOGhLvwYAcDiJVah+36VP75IBOI6NUHqG+OnOydwNhjwng==
Received: from DS0PR17CA0004.namprd17.prod.outlook.com (2603:10b6:8:191::12)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Wed, 26 Apr 2023 12:31:47 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:191:cafe::fc) by DS0PR17CA0004.outlook.office365.com
 (2603:10b6:8:191::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 12:31:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 12:31:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 05:31:35 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 05:31:35 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 26 Apr
 2023 05:31:32 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <pablo@netfilter.org>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net/sched: cls_api: remove block_cb from driver_list before freeing
Date:   Wed, 26 Apr 2023 14:31:11 +0200
Message-ID: <20230426123111.2151294-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT032:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a58ee92-2bb9-454f-5d8c-08db4652337a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ow17l3HLGL0rsWcLVlqtPm2E4Cb9Oxr7y3AQF3huFf3Y8t3YY/oHevhJx14OEMocpQSRcR4+MUGsYLg+V7XmxRb3edpPwjyT/I5TjUxaMeLZV7HtfkziPfUgXiMnLB0CNx4GAGEVtLMu185oS2SGgLSoi36pVRBWlU90lh/1VzjOIiEcJJ5atws6JmQKH7WOINs8rVUG7clGlmmwipOuWgUxmzNucowBEGa1AClgiPrjLjuDcgc3OwIhQfENaETKTyn3UwmHw4AwlU9nvL/nClz2KDoK5H+bw5kGOZQL94PsK6M+AwEFuMOlIYTGr9REoa30GOleRe8sYbv57XYtyvRsT72ANx/33xMCUutbhQNqKHHQ0WjylwzF9/9/y2WVlN37z5D7S2LzlGp031DclND4OJrzQs4um01yseL7/BB7LcuTWNyaOz5aSLnUF1PsshasjvzJ/Oe2J70V7SCAcFp7XiLqBqjkGAu2CTK0evkLrwSBERxcgbkAE5az/QOUG2v63jqJLQrbiyD5WvEa4e2QBHSjIxfoZg2pRplq4dAkMQGtuicgymMD9s60o0O3+i2YEnabFlfBQ3BquLZZzhh1fYM4R9oA+Lof09LVP/8+/pILGq9Heg/EAoWAXnKUOxOYaWrdolfB9SXexypShSSwWVdZBpN5G7saIhsX1/C8BqJ/RQ2KaLWCn3X8/WGEOEEE39TI0+xy5tJF8m8aw8sbepHZgMnz1kqH3jvYHc5Fq/3VvckwB88ntvN2Vh3QIXFguv/28iWAG2ojpjy+Ug==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199021)(5400799015)(46966006)(36840700001)(40470700004)(7636003)(356005)(82740400003)(40480700001)(36756003)(86362001)(40460700003)(82310400005)(5660300002)(2616005)(26005)(2906002)(1076003)(107886003)(186003)(70586007)(4326008)(70206006)(54906003)(6666004)(478600001)(7696005)(316002)(41300700001)(8936002)(8676002)(47076005)(110136005)(36860700001)(426003)(34020700004)(83380400001)(336012)(66899021)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 12:31:46.6570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a58ee92-2bb9-454f-5d8c-08db4652337a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289
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

Error handler of tcf_block_bind() frees the whole bo->cb_list on error.
However, by that time the flow_block_cb instances are already in the driver
list because driver ndo_setup_tc() callback is called before that up the
call chain in tcf_block_offload_cmd(). This leaves dangling pointers to
freed objects in the list and causes use-after-free[0]. Fix it by also
removing flow_block_cb instances from driver_list before deallocating them.

[0]:
[  279.868433] ==================================================================
[  279.869964] BUG: KASAN: slab-use-after-free in flow_block_cb_setup_simple+0x631/0x7c0
[  279.871527] Read of size 8 at addr ffff888147e2bf20 by task tc/2963

[  279.873151] CPU: 6 PID: 2963 Comm: tc Not tainted 6.3.0-rc6+ #4
[  279.874273] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  279.876295] Call Trace:
[  279.876882]  <TASK>
[  279.877413]  dump_stack_lvl+0x33/0x50
[  279.878198]  print_report+0xc2/0x610
[  279.878987]  ? flow_block_cb_setup_simple+0x631/0x7c0
[  279.879994]  kasan_report+0xae/0xe0
[  279.880750]  ? flow_block_cb_setup_simple+0x631/0x7c0
[  279.881744]  ? mlx5e_tc_reoffload_flows_work+0x240/0x240 [mlx5_core]
[  279.883047]  flow_block_cb_setup_simple+0x631/0x7c0
[  279.884027]  tcf_block_offload_cmd.isra.0+0x189/0x2d0
[  279.885037]  ? tcf_block_setup+0x6b0/0x6b0
[  279.885901]  ? mutex_lock+0x7d/0xd0
[  279.886669]  ? __mutex_unlock_slowpath.constprop.0+0x2d0/0x2d0
[  279.887844]  ? ingress_init+0x1c0/0x1c0 [sch_ingress]
[  279.888846]  tcf_block_get_ext+0x61c/0x1200
[  279.889711]  ingress_init+0x112/0x1c0 [sch_ingress]
[  279.890682]  ? clsact_init+0x2b0/0x2b0 [sch_ingress]
[  279.891701]  qdisc_create+0x401/0xea0
[  279.892485]  ? qdisc_tree_reduce_backlog+0x470/0x470
[  279.893473]  tc_modify_qdisc+0x6f7/0x16d0
[  279.894344]  ? tc_get_qdisc+0xac0/0xac0
[  279.895213]  ? mutex_lock+0x7d/0xd0
[  279.896005]  ? __mutex_lock_slowpath+0x10/0x10
[  279.896910]  rtnetlink_rcv_msg+0x5fe/0x9d0
[  279.897770]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
[  279.898672]  ? __sys_sendmsg+0xb5/0x140
[  279.899494]  ? do_syscall_64+0x3d/0x90
[  279.900302]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  279.901337]  ? kasan_save_stack+0x2e/0x40
[  279.902177]  ? kasan_save_stack+0x1e/0x40
[  279.903058]  ? kasan_set_track+0x21/0x30
[  279.903913]  ? kasan_save_free_info+0x2a/0x40
[  279.904836]  ? ____kasan_slab_free+0x11a/0x1b0
[  279.905741]  ? kmem_cache_free+0x179/0x400
[  279.906599]  netlink_rcv_skb+0x12c/0x360
[  279.907450]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
[  279.908360]  ? netlink_ack+0x1550/0x1550
[  279.909192]  ? rhashtable_walk_peek+0x170/0x170
[  279.910135]  ? kmem_cache_alloc_node+0x1af/0x390
[  279.911086]  ? _copy_from_iter+0x3d6/0xc70
[  279.912031]  netlink_unicast+0x553/0x790
[  279.912864]  ? netlink_attachskb+0x6a0/0x6a0
[  279.913763]  ? netlink_recvmsg+0x416/0xb50
[  279.914627]  netlink_sendmsg+0x7a1/0xcb0
[  279.915473]  ? netlink_unicast+0x790/0x790
[  279.916334]  ? iovec_from_user.part.0+0x4d/0x220
[  279.917293]  ? netlink_unicast+0x790/0x790
[  279.918159]  sock_sendmsg+0xc5/0x190
[  279.918938]  ____sys_sendmsg+0x535/0x6b0
[  279.919813]  ? import_iovec+0x7/0x10
[  279.920601]  ? kernel_sendmsg+0x30/0x30
[  279.921423]  ? __copy_msghdr+0x3c0/0x3c0
[  279.922254]  ? import_iovec+0x7/0x10
[  279.923041]  ___sys_sendmsg+0xeb/0x170
[  279.923854]  ? copy_msghdr_from_user+0x110/0x110
[  279.924797]  ? ___sys_recvmsg+0xd9/0x130
[  279.925630]  ? __perf_event_task_sched_in+0x183/0x470
[  279.926656]  ? ___sys_sendmsg+0x170/0x170
[  279.927529]  ? ctx_sched_in+0x530/0x530
[  279.928369]  ? update_curr+0x283/0x4f0
[  279.929185]  ? perf_event_update_userpage+0x570/0x570
[  279.930201]  ? __fget_light+0x57/0x520
[  279.931023]  ? __switch_to+0x53d/0xe70
[  279.931846]  ? sockfd_lookup_light+0x1a/0x140
[  279.932761]  __sys_sendmsg+0xb5/0x140
[  279.933560]  ? __sys_sendmsg_sock+0x20/0x20
[  279.934436]  ? fpregs_assert_state_consistent+0x1d/0xa0
[  279.935490]  do_syscall_64+0x3d/0x90
[  279.936300]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  279.937311] RIP: 0033:0x7f21c814f887
[  279.938085] Code: 0a 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[  279.941448] RSP: 002b:00007fff11efd478 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  279.942964] RAX: ffffffffffffffda RBX: 0000000064401979 RCX: 00007f21c814f887
[  279.944337] RDX: 0000000000000000 RSI: 00007fff11efd4e0 RDI: 0000000000000003
[  279.945660] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[  279.947003] R10: 00007f21c8008708 R11: 0000000000000246 R12: 0000000000000001
[  279.948345] R13: 0000000000409980 R14: 000000000047e538 R15: 0000000000485400
[  279.949690]  </TASK>

[  279.950706] Allocated by task 2960:
[  279.951471]  kasan_save_stack+0x1e/0x40
[  279.952338]  kasan_set_track+0x21/0x30
[  279.953165]  __kasan_kmalloc+0x77/0x90
[  279.954006]  flow_block_cb_setup_simple+0x3dd/0x7c0
[  279.955001]  tcf_block_offload_cmd.isra.0+0x189/0x2d0
[  279.956020]  tcf_block_get_ext+0x61c/0x1200
[  279.956881]  ingress_init+0x112/0x1c0 [sch_ingress]
[  279.957873]  qdisc_create+0x401/0xea0
[  279.958656]  tc_modify_qdisc+0x6f7/0x16d0
[  279.959506]  rtnetlink_rcv_msg+0x5fe/0x9d0
[  279.960392]  netlink_rcv_skb+0x12c/0x360
[  279.961216]  netlink_unicast+0x553/0x790
[  279.962044]  netlink_sendmsg+0x7a1/0xcb0
[  279.962906]  sock_sendmsg+0xc5/0x190
[  279.963702]  ____sys_sendmsg+0x535/0x6b0
[  279.964534]  ___sys_sendmsg+0xeb/0x170
[  279.965343]  __sys_sendmsg+0xb5/0x140
[  279.966132]  do_syscall_64+0x3d/0x90
[  279.966908]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  279.968407] Freed by task 2960:
[  279.969114]  kasan_save_stack+0x1e/0x40
[  279.969929]  kasan_set_track+0x21/0x30
[  279.970729]  kasan_save_free_info+0x2a/0x40
[  279.971603]  ____kasan_slab_free+0x11a/0x1b0
[  279.972483]  __kmem_cache_free+0x14d/0x280
[  279.973337]  tcf_block_setup+0x29d/0x6b0
[  279.974173]  tcf_block_offload_cmd.isra.0+0x226/0x2d0
[  279.975186]  tcf_block_get_ext+0x61c/0x1200
[  279.976080]  ingress_init+0x112/0x1c0 [sch_ingress]
[  279.977065]  qdisc_create+0x401/0xea0
[  279.977857]  tc_modify_qdisc+0x6f7/0x16d0
[  279.978695]  rtnetlink_rcv_msg+0x5fe/0x9d0
[  279.979562]  netlink_rcv_skb+0x12c/0x360
[  279.980388]  netlink_unicast+0x553/0x790
[  279.981214]  netlink_sendmsg+0x7a1/0xcb0
[  279.982043]  sock_sendmsg+0xc5/0x190
[  279.982827]  ____sys_sendmsg+0x535/0x6b0
[  279.983703]  ___sys_sendmsg+0xeb/0x170
[  279.984510]  __sys_sendmsg+0xb5/0x140
[  279.985298]  do_syscall_64+0x3d/0x90
[  279.986076]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  279.987532] The buggy address belongs to the object at ffff888147e2bf00
                which belongs to the cache kmalloc-192 of size 192
[  279.989747] The buggy address is located 32 bytes inside of
                freed 192-byte region [ffff888147e2bf00, ffff888147e2bfc0)

[  279.992367] The buggy address belongs to the physical page:
[  279.993430] page:00000000550f405c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x147e2a
[  279.995182] head:00000000550f405c order:1 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  279.996713] anon flags: 0x200000000010200(slab|head|node=0|zone=2)
[  279.997878] raw: 0200000000010200 ffff888100042a00 0000000000000000 dead000000000001
[  279.999384] raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
[  280.000894] page dumped because: kasan: bad access detected

[  280.002386] Memory state around the buggy address:
[  280.003338]  ffff888147e2be00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  280.004781]  ffff888147e2be80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[  280.006224] >ffff888147e2bf00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  280.007700]                                ^
[  280.008592]  ffff888147e2bf80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[  280.010035]  ffff888147e2c000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  280.011564] ==================================================================

Fixes: 59094b1e5094 ("net: sched: use flow block API")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 35785a36c802..0cbe01209076 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1589,6 +1589,7 @@ static int tcf_block_bind(struct tcf_block *block,
 
 err_unroll:
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
+		list_del(&block_cb->driver_list);
 		if (i-- > 0) {
 			list_del(&block_cb->list);
 			tcf_block_playback_offloads(block, block_cb->cb,
-- 
2.39.2

