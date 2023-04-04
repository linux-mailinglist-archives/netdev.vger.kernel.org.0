Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD836D689C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbjDDQSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjDDQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:18:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2139.outbound.protection.outlook.com [40.107.93.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9312513E;
        Tue,  4 Apr 2023 09:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYKOgU+hVEQsGFhM6l4ITntkxJ5Wp0iz6kK4A+k2i0Na9kPEMN5G8bVcw324WLtdFlOYs6RUYpSDQHex2wF6Du4vg7ciQnhCxa2gtvN23DYm3nRLA314X/tMVr28uf0fL7G5EP6Ruxl82gu6KxGFPSNwl5oIxPjQ23R+eCG4HMkCgaF30EdgyQaCy/AvcsRcPalZYPHf3dr8HfkuU4/JmLX/3EctRDm5v2EfX9eZQdG+VASTmWMtTL4B2R2HtFsPEFa61X3ssTcBxtJ/FUrG4R/9rNoV893AiPKuN8rf5PCz10nASh0LbTjWUSyT8GtLNVRNlFpIr8CRhzZ1AR+r8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFOkOwC67HPC50nukpsX79Oqdf1xEg/Z8bFY+6RDLkQ=;
 b=oIlNlgszDZJfyIj7Wl8Kr3MobBO8L+cN3ugc7ZOQHVhgIsxg/1++qlARnqyxpiySRnDpuhuxICjoWOGwVSfXR9x14SUf13jf5+cXItD7cDjaVoPj0GDl8GxjlAN7BflAfb4jMtgzt3GhCmK1NE1Ov0K+BYS3GFrM4MC1+Z/La56Jp9sOy/NLh8Peu/wCxhXyTJFS9p9wQixL1p2JjNei5GjDYXcrT20vKCKgW6IpO+mA35l2jad2GodxUwEjOqrXdcrmuQYC6VOCyHhNAsAr6P8hk9vHXDWwQe81YauFjNeexryL/W/UZtBtHqxfxa5b9ZxDRTqzKoMm38IVlJg1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFOkOwC67HPC50nukpsX79Oqdf1xEg/Z8bFY+6RDLkQ=;
 b=dfYdgrTI08GAPJCfnqD2TE/Z6N1PCzz3B47rNwn4pb67FsusQ06HlQB2GTHL8I6uqnbEzuVnFWgSuWskOM/REC6I6IJ8OoMp/efXSFhf+Ivp0cLjCFI12htfPqS/G93Nyk/aZSOBeE4B1cmnhKfsehiLcjzVHo5ikwfxwTXzpZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5592.namprd13.prod.outlook.com (2603:10b6:510:12b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 16:18:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 16:18:37 +0000
Date:   Tue, 4 Apr 2023 18:18:30 +0200
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
Subject: Re: [PATCH net] mac80211_hwsim: fix potential NULL deref in
 hwsim_pmsr_report_nl()
Message-ID: <ZCxN1l3rXnmt+2wL@corigine.com>
References: <20230404134803.889673-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404134803.889673-1-edumazet@google.com>
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 540fb219-4e9d-4e71-4113-08db35283e70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AoEzvRiiYXahqgdQWFWFk+yB7WkN3MXpDBGL4UfA8x04J5FJQ9HXiUHNMz5D6J9qCpVxRaADqzj7ynz+EWYdVw0x0Mg0hiDfY0L8MgitOL6Rt6E0a4Bzk+hMhii3pcZXDeshZUDE4I8s+49JLjDfbcFws8zBVdYI8eGHC5fXlOXJEfpaRJMpOgnJL/aT25Bn/a/TK9vBruicbuRpvoR1ackGpLrfDCxQUJEdqJZsQQByJL15ebAEmxp1SrItSNnCCXFeVCu/74jUD3FYbmZeRYn+a2SU/Oi9SVXmaFqtX0d+Z0TEofslZI7W6YpuOxGZc6s5QGHEFInOycwuqDZPqQhreVQhYpwe/aAeBS1rjGg0vJHy/Xo2rEPPcyZSjo24gFTrKYqZvM7uKO6qI9ifKCLs1Aj7yCrq2Dh4bHfcjSyT97v2/dzKtw5yp9MGWddTjfHdrD/D/R8Nat1q+bbvQe2CPsF6B+pg4Icuz3Huqxh7NP6/WpqREDKx0R55THjfrUKBuvv2gPIB/IK4ZTaZI4cnRjAtCjM0iCsWFGtOxwk/eNXjsJPMPoQcM3nncNA+XF0NEsfHDN+2l0GaOaP5MB8Wa6ZOJiDRk0F9J4LuJsZBIFqB5cujd1x4n4DVy9nTNeTTd0jUkY9/hJnKTuKQ7P02+73Hf9o7t5Yf8QcEGv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(346002)(136003)(366004)(451199021)(54906003)(6512007)(2616005)(6506007)(6486002)(86362001)(316002)(478600001)(186003)(6666004)(4326008)(6916009)(66476007)(66946007)(8676002)(66556008)(7416002)(41300700001)(5660300002)(44832011)(2906002)(38100700002)(8936002)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UwAM0MbClrGpgAumR/JXP8K15d1ztcQdWuw6QIDK2VBOVbM0aYsdWmTuXrI8?=
 =?us-ascii?Q?QZphbcJitUbMEaqB0XTXWcjMsmG+RzR9NoZSu2tzoiaQM+ZZhO4Q0GoyGpjD?=
 =?us-ascii?Q?Dsn10zBvl7DpL1nFC4qatNYLSTPhcHru4dv+mxshgZGn1T/HBnPRz1kxacht?=
 =?us-ascii?Q?NSxqxgEO3VzyNfwtwvejcuD+t/4f7GHRVw/LqUgqXrfLXpJK4qwaFtTcVmdw?=
 =?us-ascii?Q?aLe1gd2VJRsuKb70u9ULuDMFr3N5Lk4riFJxYmTwlz3RwDFyRzvwE4NtOfCW?=
 =?us-ascii?Q?o5Mny6C1mvy9+MRnh2clMqFVasbZCwKpkZt1x6Nr13fxImbYoCHOGk7nEJ0Z?=
 =?us-ascii?Q?7Ynmf+6y137W1qrhE2uY5qFHfg5HHX4vwXmDu4MIIjgEnSOFzzsaGUKQ63YZ?=
 =?us-ascii?Q?joXRXBAdtBE7vH38EJuuqbMaxQ2FG4L+T1WOuxBmn8hYD80aiEk2tHvYsG/v?=
 =?us-ascii?Q?W2gaPPLVXcYzxj9nFKIhFmCo3Xg7tkWXLOws4zO7d9njYhAAmLysgmQpsyb4?=
 =?us-ascii?Q?qvaoFldELB6hgY3/GnLdDOvPCJaasKP/MauFS6HyldsOFNcYHzlXyqveqcxb?=
 =?us-ascii?Q?T+RSDKnqlttJ1bMuCsPQKGj4ticp/zX4mtkl3UwzQFT3xx/lFp1UzSEIgH7F?=
 =?us-ascii?Q?BH3tkhbzBpFjWqeLM6fnX9tKXC2cdGCDFLrr3rn0Ee8mThuQDUgdXvLj39Kb?=
 =?us-ascii?Q?lSNEvs7/z9lXIZgTCjMfs5QMFVCraUMGt78CXm4szlMNnfBGi1s+tgVhNLnT?=
 =?us-ascii?Q?mTqOpoGBE7gROrYYBB5VgORm70q3xmw3PFYIzyYpGjy6NaTAnj8Jj2NWZ0Q2?=
 =?us-ascii?Q?GWRjFw8GjBI/3IScOShsnqc9R9qHs/Eqza8Ht3O4xuC+XOqK4URdTYTHPcTK?=
 =?us-ascii?Q?qhmzAOy4QsB9NdEyOHQd9ZCGnJk13+LE8kSe6gv/cSruEco34m4dWaSBOLKg?=
 =?us-ascii?Q?XAt0aWHtW2Wj8DVbg1ZiDJ8DxXVBMML10TF69ezN5vNPUUduo6KiZ3C50FiF?=
 =?us-ascii?Q?DOO6ExbHJyk1JvvRWFbzEsMYNak9lWR3DmQGB/AdU282VR54KKv5TWhrhbka?=
 =?us-ascii?Q?WJl/iPdcw2LtBT+C20gdaIBMinPGSX/jXsCCDNCdEQ9W2rxe8TplsME1Y3uc?=
 =?us-ascii?Q?6Zvt1woGks2S4aNedUgNLGNyNC+ihIRHPXJeynWEMW/55FNvaSSfZTjdE1+G?=
 =?us-ascii?Q?KGVwGKi7AM8GWXo2mUvkmIFhMWjAxfpzDOu2ZEpoy6Y5jLZvlMT4zj8SwN3E?=
 =?us-ascii?Q?rmEdZ7Lrvqmb1ClAI5JZCQRFdr2kSjCWyQ96bYQ1kv5yxVXDzWXRoSOzsxnh?=
 =?us-ascii?Q?EBEXgMNM8r0Gg2Ok+U83n0KlX6DVwo14hK6ecIfpf1ZV5EOF6kcpCkIMeYoo?=
 =?us-ascii?Q?RvogmBWxpqe4/HCRcRiwMHV5+DkR4zu/MHaVnvuSFbnhxisDYQ5zC/AKxK98?=
 =?us-ascii?Q?thZdPRhfEMeFhIgj5dY+iLvmcnka++s/g1rKUJjW/ngkdl/CHLPiUYspGevR?=
 =?us-ascii?Q?AO98t2MAGBca/wulKRw+fs/Pbr1F6YUNIPeQV/NTo0E+DDLuGa18l2K121hg?=
 =?us-ascii?Q?ZxPrxl6t+G06mJOwV1lBLU9X33d8SCZ7goazVqXb8ZfILhYism/1QP1y/svE?=
 =?us-ascii?Q?q4w/U/Vj/ZqlPF3Wzf+KT0EJMWBIGckAG/AmvWpceMb/kk09CooFI2d+KST7?=
 =?us-ascii?Q?j10NLQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540fb219-4e9d-4e71-4113-08db35283e70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 16:18:36.8969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NY22hKkmwMB2IzktKJNNz8tD5aJa45FPxuCiQl2U7Pow2yNlWsLu4molFZR3/YhnxwjxEdZOBUkbztb+gu7Yyc4jUz6+8VFKvddyMzgw4o8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5592
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 01:48:03PM +0000, Eric Dumazet wrote:
> syzbot reported a NULL deref caused by a missing check
> in hwsim_pmsr_report_nl(), and bisected the issue to cited commit.
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

Hi Eric,

I think this is for net-next / wireless-next as
the above mentioned patch does not seem to be in Linus's tree.

> ---
>  drivers/net/wireless/virtual/mac80211_hwsim.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
> index f446d8f6e1f6e1df108db00e898fa02970162585..701e14b8e6fe0cae7ee2478c8dff0f2327b54a70 100644
> --- a/drivers/net/wireless/virtual/mac80211_hwsim.c
> +++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
> @@ -3761,6 +3761,8 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
>  	int rem;
>  
>  	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> +	if (!src)
> +		return -EINVAL;
>  	data = get_hwsim_data_ref_from_addr(src);
>  	if (!data)
>  		return -EINVAL;

I could well be wrong, but this looks a little odd given that nla_data is:

static inline void *nla_data(const struct nlattr *nla)
{
        return (char *) nla + NLA_HDRLEN;
}

Perhaps we want something like this (*compile tested only!*) ?

	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER])
		return -EINVAL;
	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
	...
