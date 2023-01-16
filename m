Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF5866C3F7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjAPPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjAPPcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:32:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21918B2E;
        Mon, 16 Jan 2023 07:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD7361001;
        Mon, 16 Jan 2023 15:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB26C433EF;
        Mon, 16 Jan 2023 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673882946;
        bh=7a330a17Z1uu7izXrb4SAEzyi7d8G4tr45dHBjsd2hw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=s6+766aYmdjyi+Ct4qcqyNxJjBIsuvHhSbklxmt2AmNeJ1yq1EGEuTTaCqJZB/V26
         mRQ0HD8DOHhX+x9m7Tc7yHsENMY07gUiuiEICq7J2fqKUq2as8DnqEw2yVjHkns6/f
         yXpsTLLeNFgMC7LlkEw4+IlQVQiD/PVBOvIvHvrS878JE/0zRG6oGP5Xf2kLzvfmtp
         xiBoU8uJSvwiFN+LaXSEjTYWt8bKQlFkZlXJo1VY6L3VRx1dPLSAvf/BQJgMGPC9tF
         77IcZVWtOm1LA5x8hwFsqdrzO4kYsQeHcKG39XYZmuENwUy+cpAe5uEAomwW1E93ij
         ie9Ryr3XI8g7w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] Revert "wifi: mac80211: fix memory leak in
 ieee80211_if_add()"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230113124326.3533978-1-edumazet@google.com>
References: <20230113124326.3533978-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167388294128.25993.17967935961425220437.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 15:29:03 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

> This reverts commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293.
> 
> ieee80211_if_free() is already called from free_netdev(ndev)
> because ndev->priv_destructor == ieee80211_if_free
> 
> syzbot reported:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 0 PID: 10041 Comm: syz-executor.0 Not tainted 6.2.0-rc2-syzkaller-00388-g55b98837e37d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:pcpu_get_page_chunk mm/percpu.c:262 [inline]
> RIP: 0010:pcpu_chunk_addr_search mm/percpu.c:1619 [inline]
> RIP: 0010:free_percpu mm/percpu.c:2271 [inline]
> RIP: 0010:free_percpu+0x186/0x10f0 mm/percpu.c:2254
> Code: 80 3c 02 00 0f 85 f5 0e 00 00 48 8b 3b 48 01 ef e8 cf b3 0b 00 48 ba 00 00 00 00 00 fc ff df 48 8d 78 20 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 3b 0e 00 00 48 8b 58 20 48 b8 00 00 00 00 00 fc
> RSP: 0018:ffffc90004ba7068 EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff88823ffe2b80 RCX: 0000000000000004
> RDX: dffffc0000000000 RSI: ffffffff81c1f4e7 RDI: 0000000000000020
> RBP: ffffe8fffe8fc220 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 1ffffffff2179ab2 R12: ffff8880b983d000
> R13: 0000000000000003 R14: 0000607f450fc220 R15: ffff88823ffe2988
> FS: 00007fcb349de700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32220000 CR3: 000000004914f000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> netdev_run_todo+0x6bf/0x1100 net/core/dev.c:10352
> ieee80211_register_hw+0x2663/0x4040 net/mac80211/main.c:1411
> mac80211_hwsim_new_radio+0x2537/0x4d80 drivers/net/wireless/mac80211_hwsim.c:4583
> hwsim_new_radio_nl+0xa09/0x10f0 drivers/net/wireless/mac80211_hwsim.c:5176
> genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
> genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
> netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
> genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
> netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
> netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
> netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xd3/0x120 net/socket.c:734
> ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
> __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 13e5afd3d773 ("wifi: mac80211: fix memory leak in ieee80211_if_add()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Zhengchao Shao <shaozhengchao@huawei.com>
> Cc: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless.git, thanks.

80f8a66dede0 Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230113124326.3533978-1-edumazet@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

