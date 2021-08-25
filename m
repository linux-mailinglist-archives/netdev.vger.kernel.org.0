Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63033F72D3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbhHYKVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238333AbhHYKUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20EFB611C9;
        Wed, 25 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886806;
        bh=tolNUiiS7yzrmrh4kO306EfFqlA5Ja532ptidkOGHhs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hrFlzdVSYCXouIsdVMBvmUDERwVjcPK5knDo+iYmqpIcN9JD4zvmWwtJOLj7eU0hJ
         K5mNwkVI6UQJINJxc+ODf02XSfam1pjaBTaK2qu+hirwiYCRza7hdCrqR6ZfltvVgH
         pCNnq5fmDyYTuntJIuOmjqS2+UmEoNEKntIGI/8aasjy9ObTJ0qzpku1cWA+RJcIaI
         XRNPc6jMaFlSHBAOnIQVPQdhUWszgWaN814zSi7yC9Ua90DIrY42hFdy0dGvSq1ZvZ
         oLgxe/oIWyMeqBsJLovuP997lns/+EoUYqDF03lEPm1uR1IA8OcVAfTPzBfprWU2Q9
         OahseDWVa55cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12D2E60A02;
        Wed, 25 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict' to
 'quantum'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988680607.8958.11412108638466709432.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:20:06 +0000
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
In-Reply-To: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     liuhangbin@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        petrm@mellanox.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 00:33:48 +0200 you wrote:
> While running kselftests, Hangbin observed that sch_ets.sh often crashes,
> and splats like the following one are seen in the output of 'dmesg':
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 159f12067 P4D 159f12067 PUD 159f13067 PMD 0
>  Oops: 0000 [#1] SMP NOPTI
>  CPU: 2 PID: 921 Comm: tc Not tainted 5.14.0-rc6+ #458
>  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
>  RIP: 0010:__list_del_entry_valid+0x2d/0x50
>  Code: 48 8b 57 08 48 b9 00 01 00 00 00 00 ad de 48 39 c8 0f 84 ac 6e 5b 00 48 b9 22 01 00 00 00 00 ad de 48 39 ca 0f 84 cf 6e 5b 00 <48> 8b 32 48 39 fe 0f 85 af 6e 5b 00 48 8b 50 08 48 39 f2 0f 85 94
>  RSP: 0018:ffffb2da005c3890 EFLAGS: 00010217
>  RAX: 0000000000000000 RBX: ffff9073ba23f800 RCX: dead000000000122
>  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff9073ba23fbc8
>  RBP: ffff9073ba23f890 R08: 0000000000000001 R09: 0000000000000001
>  R10: 0000000000000001 R11: 0000000000000001 R12: dead000000000100
>  R13: ffff9073ba23fb00 R14: 0000000000000002 R15: 0000000000000002
>  FS:  00007f93e5564e40(0000) GS:ffff9073bba00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000000 CR3: 000000014ad34000 CR4: 0000000000350ee0
>  Call Trace:
>   ets_qdisc_reset+0x6e/0x100 [sch_ets]
>   qdisc_reset+0x49/0x1d0
>   tbf_reset+0x15/0x60 [sch_tbf]
>   qdisc_reset+0x49/0x1d0
>   dev_reset_queue.constprop.42+0x2f/0x90
>   dev_deactivate_many+0x1d3/0x3d0
>   dev_deactivate+0x56/0x90
>   qdisc_graft+0x47e/0x5a0
>   tc_get_qdisc+0x1db/0x3e0
>   rtnetlink_rcv_msg+0x164/0x4c0
>   netlink_rcv_skb+0x50/0x100
>   netlink_unicast+0x1a5/0x280
>   netlink_sendmsg+0x242/0x480
>   sock_sendmsg+0x5b/0x60
>   ____sys_sendmsg+0x1f2/0x260
>   ___sys_sendmsg+0x7c/0xc0
>   __sys_sendmsg+0x57/0xa0
>   do_syscall_64+0x3a/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7f93e44b8338
>  Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 43 2c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4 55
>  RSP: 002b:00007ffc0db737a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>  RAX: ffffffffffffffda RBX: 0000000061255c06 RCX: 00007f93e44b8338
>  RDX: 0000000000000000 RSI: 00007ffc0db73810 RDI: 0000000000000003
>  RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
>  R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000001
>  R13: 0000000000687880 R14: 0000000000000000 R15: 0000000000000000
>  Modules linked in: sch_ets sch_tbf dummy rfkill iTCO_wdt iTCO_vendor_support intel_rapl_msr intel_rapl_common joydev i2c_i801 pcspkr i2c_smbus lpc_ich virtio_balloon ip_tables xfs libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel libata serio_raw virtio_blk virtio_console virtio_net net_failover failover sunrpc dm_mirror dm_region_hash dm_log dm_mod
>  CR2: 0000000000000000
> 
> [...]

Here is the summary with links:
  - [PATH,net] net/sched: ets: fix crash when flipping from 'strict' to 'quantum'
    https://git.kernel.org/netdev/net/c/cd9b50adc6bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


