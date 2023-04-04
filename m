Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DAE6D6AD2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbjDDRjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbjDDRjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:39:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2128.outbound.protection.outlook.com [40.107.102.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E3A4ED0;
        Tue,  4 Apr 2023 10:38:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJz5A4edCEKWm8dFMyFpwkcMHGRR1S6argEltyz8DIn9iF4OuxwweXw9s/DAHVS3n2vyMczbzhR1GIuxvkJXz8uLWz9/ahogPhVZhyk1SyzOqiH5QovMLIQO+AAgcc+qIRVL9vM+pcVi8GHjXipoGZtLHNp9YBdBNHrAvdKg46yR/u6KwIuDYQEDUv5XnjwkqKh3ubaxMxl1t28/Coorrm2Q97hJT9BkwlT91W5hlcoxlZjcXzYTKkaZzNs8ZT/dTH+OI5+uUOYrkcBIUgDLg9NqrJB5hM+lukpB2nVdjAEb/H98lSw+5QvBCic0XRrXjym6FgA7cYiDKueWc/FdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uctBL9Apv/81uRjVPn9HIO8YKjivC/BORx3Mh/9dzgY=;
 b=h5/R1OykedQcr1UcIFhqTIg297fhpeeMBx+BRrZ6CvcUHw7O4wRc3uxSb7fma+Wm3HfYyGUnhRK9FiNTbBLItsrYncZ5mOrDmdW1kTy3nFI74o+g8Agp4orkYeuaNNivJchBvjdeRYiskMTUCJSKMC1OIMjYvPSqaF9Cyn8BSaSspYsgrjmVQimbV9PHMCFSEw4Tzawq272sNcXyQzSRiwwivt+67chON8AKgZlwRTB3lWTbvQ4beGHxFpOt+PJTrQAxDfP5y520sdKKsiTNR+wLCT/E7PO3lSpzlNoTyjSZRrADaSe5HSr39UN9y1N1/5tNH4db3TxCK0IwGnmudA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uctBL9Apv/81uRjVPn9HIO8YKjivC/BORx3Mh/9dzgY=;
 b=u/NvXqstlou5MKMGaCHphgsoNPUe541St7AYCLPTfrTcQBU6QfgDcI3W4zTCMIef79+ryesfb4VCF0hfRtlfdgTLW3JBJHpxNNYXp1gwXSr2daetbWnvhSmr56SDk1bDNBEDm3ZPfVXFDsLF19qF6cigpLhIo15s6Sll+FCXWGY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5479.namprd13.prod.outlook.com (2603:10b6:510:139::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Tue, 4 Apr
 2023 17:38:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 17:38:56 +0000
Date:   Tue, 4 Apr 2023 19:38:49 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Jaewan Kim <jaewan@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 net-next] mac80211_hwsim: fix potential NULL deref in
 hwsim_pmsr_report_nl()
Message-ID: <ZCxgqWkicKWYDySr@corigine.com>
References: <20230404171658.917361-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404171658.917361-1-edumazet@google.com>
X-ClientProxiedBy: AM0PR02CA0088.eurprd02.prod.outlook.com
 (2603:10a6:208:154::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5479:EE_
X-MS-Office365-Filtering-Correlation-Id: 51966784-1c12-4316-ca68-08db35337760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AxGMlqSa8gPm3WFC9P5WBs9xYLdRU+b8PAGLnxJOKJV1AsWP2MXx3uartcbQNsJvySCZjSOfNiysKGwjHM/+qFP8X7w+Y3gvvb2kSVu001kwhHK0bAh+6QDLTPECWdVwV1Xe2UiCQaMwYfLKC2un2MdGDxOK0IMKPX1CaIPD9jbl3RneWbsP2QHDrezqbbcq37zQff1tp2Q2v7KBh0ackwPg+TuL/VV+Ei9FIkFcSb4GEgh3BGoDXt0Uv4pCB16bkYF3Het3mDe8w20wM7dPvneAmBGjF3IOGuwjpYZ6iWSItOJBJ2NPN6S0u9gt4YYkOwPFkQ6fc9stCBjKFP/VMOOcWxu1IF3VJ0VFAgGi3qviZj4L+vVy1JoTConA2GCZZul0a4wSu4HZloIPfnpmekwund7rBiwOrjHj0n++2MG58qdFA4oTn7ez41z/KQaqnaSfG9mn/p5Ci6kILVuVU16X84JAnlHxfUb7lBt+fxTbK3xgcE7DFCs1L46DH9T0MywScwWVTlV/RtsrTYY5CUE4R7Ru/+Vqnh/9/Aig+JIcZMu/9g1vP9B5G4udWzfensrInr2zHue0jQfOzp1C2tLPXcIsPTNlHJCC4ffISg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39840400004)(136003)(346002)(396003)(451199021)(6916009)(6486002)(54906003)(41300700001)(66556008)(6666004)(66946007)(66476007)(316002)(36756003)(4326008)(86362001)(478600001)(2616005)(6506007)(8676002)(6512007)(2906002)(8936002)(44832011)(7416002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wPDpLNN2jtdcAgM/gyUxqxX6DC6PcBd270z6EE0rdcWgbSurkaJGOZcJyrck?=
 =?us-ascii?Q?fUGYBTNcDGsiwVCwV4qseKZUKq+DVpP37IGqluaAzaG5pXZ7rcuJrJ3CpNDo?=
 =?us-ascii?Q?EDFeFvfmogh/DIcT9hl2KTJvPzUw/GbD2/ebnYsaTMyYFKKy9AcqcxJCU7Gu?=
 =?us-ascii?Q?4vXCcftVmM436FEZMsLb7F/XOFi0Fuyi9xRZ8t3fWglJPSJpCMDTKMWTI/8o?=
 =?us-ascii?Q?XybDz/TWrJfBGbwvLxT5/B9aC0idGnkkTocPr4cLZK4Rv1NZA7FvM9h8QQYy?=
 =?us-ascii?Q?w83EXgl9bQNP4EuljWWukkABIj0WL19xNdrbP4HN77ekJePZ3YyEbVvkughq?=
 =?us-ascii?Q?ZttVX1MvY3eFfEKvzDTnOhctBM1s/H4spwEnuZPJYYBeT/l+vdZ5YNXTl68W?=
 =?us-ascii?Q?hlyKN+hSbPbOG2U01ePV1jS2iIVGy4ixj1bAaPct7728rVu5RnbJ8TD5Zl2U?=
 =?us-ascii?Q?KOly960zC+kenG5zGFlKK6fYR5fabRwQwl1Zn7JOqhqgEpzQNOwAx6bkzI78?=
 =?us-ascii?Q?V8uZ2tiaCScMjw6F7YFFicIhYk9JdcbarAW5LMh19LRDTPyPSSVBEI4a8AzP?=
 =?us-ascii?Q?mUydsl/R+3hBJlO5ZxAC2tBSiSuYOabKf6P7dQzwRS5P3Kps7Txpcl84HgOm?=
 =?us-ascii?Q?buV7Ie8YRQZLIQBvhGlS9MXpr5ylMfEIX14PHp2IZq/cgm9OPRDACeJ/+9Hz?=
 =?us-ascii?Q?AGoFpWSoYd6SZFVHCs+2NnkkLZdu4/iOQuoHs8dPWlTejuTfqzp3iJO9v+Pa?=
 =?us-ascii?Q?R7MqUdbWNBwWQTykg6063uKtdpfbUu/cfTdiHFnxo5Q9Os34FolrP/WfjLgX?=
 =?us-ascii?Q?OzFFpwiglpuS/YPkpHcdYQpgbGLjACHCwthVyTucvzyAEkUWhVHOxa1O9kSr?=
 =?us-ascii?Q?ByyLUhvGN2QOmC16OFDtAYnpCN54dfHo0NPcbgs94Ved167y9OaombEW7e6e?=
 =?us-ascii?Q?dzcM5DdEnVxbaVSz739ZrsBj8DuSOe+VNZiy1b8QToRbm+pENoy1RO4OUU30?=
 =?us-ascii?Q?6dJOxpfKBfHPdToEXo3j0wEjqBQOrKoDmgaT59HwPomIa/BYrRCaFULjdcc+?=
 =?us-ascii?Q?L/K6yinPwQWz/mDrRQW9ZpWgO00obbA58StCHRyS8oLLPeS2xbW2bjYf+QqK?=
 =?us-ascii?Q?ev6jW2NCICPoUmWH01hGNo3+3uDKeMSiW0BqHUFcLHzRKzyaKmySL8mJuqX0?=
 =?us-ascii?Q?Dgv7kh4d34w3bRbsJPjlDwKmJ4TV6iFUBZSE7OOiDhhZwTx6d4N0bHEjiZTJ?=
 =?us-ascii?Q?oX2y8njUeQsE2igsJrtj57cGfTd0qEOovb68qCFRI+24xBYnYe1BU9yl5dKC?=
 =?us-ascii?Q?gm3CUmN0Hu4hn/mAsg4v+6pSvrGQN5EdX7iWAcByp3anBMwXDDZrtnX7XU/y?=
 =?us-ascii?Q?WP34gZghQQlJdZz+Dg9lBHMcGhaixZo/syehtMFv/FEXzKLGDEdxd/z/dMag?=
 =?us-ascii?Q?8iKR5iMcjNB/fUFj6rgHNPXNbhdjDzPgYWygsHLbzuRUgutFotWnkhsIihSk?=
 =?us-ascii?Q?b0J3B7MJfP11T/K/uzwqDkj0opcLP9GhFe6I3EIRZ5SoStR0o5sF40GQfdAM?=
 =?us-ascii?Q?5HPiECZ9KgxMX57Q3qsFNJZTjBZZRAXTggnjVmmT9UhcPyF+YUiol8pV4auw?=
 =?us-ascii?Q?htHlIRpZz4IjzpBl+hQ+GsWFGVDLSl3rv559IOBtOA2VbqCeVeI9ND5Isghg?=
 =?us-ascii?Q?YqMeuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51966784-1c12-4316-ca68-08db35337760
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 17:38:56.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTgc9YgQrkMSb56gZnk1IJTxp010esxxnpmahcQuwBxCROa8g3M/gD/rH/oxLm1g1BNmgLNSyDwI2ZOGVn2m2hlFGXrBlSu0/HAzJNHIoB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5479
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:16:58PM +0000, Eric Dumazet wrote:
> syzbot reported a NULL dereference caused by a missing check
> in hwsim_pmsr_report_nl(), and bisected the issue to cited commit.
> 
> v2: test the nlattr before using nla_data() on it (Simon Horman)
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 5084 Comm: syz-executor104 Not tainted 6.3.0-rc4-next-20230331-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> RIP: 0010:jhash+0x339/0x610 include/linux/jhash.h:95
> Code: 83 fd 01 0f 84 5f ff ff ff eb de 83 fd 05 74 3a e8 ac f5 71 fd 48 8d 7b 05 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 96 02 00 00
> RSP: 0018:ffffc90003abf298 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000004 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffffffff84111ba4 RDI: 0000000000000009
> RBP: 0000000000000006 R08: 0000000000000005 R09: 000000000000000c
> R10: 0000000000000006 R11: 0000000000000000 R12: 000000004d2c27cd
> R13: 000000002bd9e6c2 R14: 000000002bd9e6c2 R15: 000000002bd9e6c2
> FS: 0000555556847300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000045ad50 CR3: 0000000078aa6000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> rht_key_hashfn include/linux/rhashtable.h:159 [inline]
> __rhashtable_lookup include/linux/rhashtable.h:604 [inline]
> rhashtable_lookup include/linux/rhashtable.h:646 [inline]
> rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
> get_hwsim_data_ref_from_addr+0xb9/0x600 drivers/net/wireless/virtual/mac80211_hwsim.c:757
> hwsim_pmsr_report_nl+0xe7/0xd50 drivers/net/wireless/virtual/mac80211_hwsim.c:3764
> genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
> genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
> netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
> genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
> netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> sock_sendmsg_nosec net/socket.c:724 [inline]
> sock_sendmsg+0xde/0x190 net/socket.c:747
> ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
> __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 2af3b2a631b1 ("mac80211_hwsim: add PMSR report support via virtio")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jaewan Kim <jaewan@google.com>
> Cc: Johannes Berg <johannes.berg@intel.com>

Thanks Eric,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
