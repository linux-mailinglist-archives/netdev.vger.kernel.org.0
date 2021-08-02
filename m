Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770E53DE274
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhHBW1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhHBW1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 18:27:17 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00416C06175F;
        Mon,  2 Aug 2021 15:27:06 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 575466C0C; Mon,  2 Aug 2021 18:27:06 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 575466C0C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1627943226;
        bh=4vOxhABUf2GSQcf+nhnqwDcWoOoe2YSDjuwBmM5jQf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cO2TcQRAbg/+UAvo3Fttdu2pLrmAHRS+n9cYdITZ2CCQKMcR/ru1XZG2BSBloaRr8
         zo5SMDFiYJoMzQrvA0prN4S5yf4VUza7OlM99c8iJjcJIG69ZYk6RFzc1wg2V5Umqd
         /pr9NpnQvLPJlwItfOA38kiPexzNiTDgLMaAz2LI=
Date:   Mon, 2 Aug 2021 18:27:06 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     syzbot <syzbot+3405f46cf7078134383e@syzkaller.appspotmail.com>
Cc:     anna.schumaker@netapp.com, chuck.lever@oracle.com,
        colin.king@canonical.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        martijn.de.gouw@prodrive-technologies.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, trond.myklebust@hammerspace.com
Subject: Re: [syzbot] WARNING in remove_proc_entry (3)
Message-ID: <20210802222706.GH6890@fieldses.org>
References: <000000000000d4ce1205c754aa4c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d4ce1205c754aa4c@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 10:02:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7fef2edf7cc7 sd: don't mess with SD_MINORS for CONFIG_DEBU..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=147c3b3c300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=957eaf08bd3bb8d6
> dashboard link: https://syzkaller.appspot.com/bug?extid=3405f46cf7078134383e
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3405f46cf7078134383e@syzkaller.appspotmail.com
> 
> bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
> bond0 (unregistering): Released all slaves
> ------------[ cut here ]------------
> name 'use-gss-proxy'
> WARNING: CPU: 0 PID: 7951 at fs/proc/generic.c:709 remove_proc_entry+0x389/0x460 fs/proc/generic.c:709

I'm probably missing something obvious.  This says we're calling
remove_proc_entry on a name that doesn't exist.

We're doing that removal from a pernet_operations ->exit method.  As I
understand, those won't get called unless the corresponding ->init
succeeds, but that means the proc entry was created.

There's a bug in gss_svc_init_net that has an extra unnecessary call,
but I'm not seeing how we hit that case there either.  Hm.

--b.

> Modules linked in:
> CPU: 0 PID: 7951 Comm: kworker/u4:2 Tainted: G        W         5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: netns cleanup_net
> RIP: 0010:remove_proc_entry+0x389/0x460 fs/proc/generic.c:709
> Code: e9 6d fe ff ff e8 f7 d9 85 ff 48 c7 c7 20 d4 b3 8b e8 fb 96 3d 07 e8 e6 d9 85 ff 4c 89 e6 48 c7 c7 00 2a 9c 89 e8 92 86 f8 06 <0f> 0b e9 a4 fe ff ff e8 cb d9 85 ff 48 8d bd d8 00 00 00 48 b8 00
> RSP: 0018:ffffc9000c8efb48 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 1ffff9200191df6b RCX: 0000000000000000
> RDX: ffff8880341121c0 RSI: ffffffff815c9ca5 RDI: fffff5200191df5b
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815c3aae R11: 0000000000000000 R12: ffffffff8aa28e40
> R13: dffffc0000000000 R14: ffff888000102000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f38761a8740 CR3: 000000002c23a000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  destroy_use_gss_proxy_proc_entry net/sunrpc/auth_gss/svcauth_gss.c:1504 [inline]
>  gss_svc_shutdown_net+0x196/0x8c0 net/sunrpc/auth_gss/svcauth_gss.c:1992
>  ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
>  cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
