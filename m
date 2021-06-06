Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87239CE79
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 11:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFFJ4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 05:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhFFJ4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 05:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 644AF611C2;
        Sun,  6 Jun 2021 09:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622973266;
        bh=YekKXP1pkSo7SHw+mBLIiuMO3ujUvMuIzKGlQDhi5Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k6jp54aFSlIzWZH1KWJfsrpSrKUKm+biDUQ3r/caAVhIsuQGMh5vKYmY+u8IHGs5V
         DypvLLgQCa7BJY5whjQyzR6rYkwIl0Bo+OFu3b5n2NfyBTrg4UOgzdfX+tC6DEyZQd
         ZRa57oXbONxZQl1fWBnli8gjOO44MjntqCMCCF5U=
Date:   Sun, 6 Jun 2021 11:54:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Leon Romanovsky <leon@kernel.org>, SyzScope <syzscope@gmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLybTrAP/6kroNJn@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
 <20210606085004.12212-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210606085004.12212-1-hdanton@sina.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 04:50:04PM +0800, Hillf Danton wrote:
> On 2020-08-02 20:45
> > syzbot found the following issue on:
> > 
> > HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
> > dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
> > 
> > IPVS: ftp: loaded support on port[0] = 21
> > ==================================================================
> > BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> > Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
> > 
> > CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x1f0/0x31e lib/dump_stack.c:118
> >  print_address_description+0x66/0x5a0 mm/kasan/report.c:383
> >  __kasan_report mm/kasan/report.c:513 [inline]
> >  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
> >  hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> >  l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
> >  hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
> >  hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
> >  hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
> >  hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
> >  vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
> >  __fput+0x2f0/0x750 fs/file_table.c:281
> >  task_work_run+0x137/0x1c0 kernel/task_work.c:135
> >  exit_task_work include/linux/task_work.h:25 [inline]
> >  do_exit+0x601/0x1f80 kernel/exit.c:805
> >  do_group_exit+0x161/0x2d0 kernel/exit.c:903
> >  __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
> >  __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
> >  __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
> >  do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> To fix the uaf reported, add reference count to hci channel to track users.
> Then only channels with zero users will be released.
> 
> It is now only for thoughts.
> 
> +++ x/include/net/bluetooth/hci_core.h
> @@ -704,6 +704,7 @@ struct hci_chan {
>  	struct sk_buff_head data_q;
>  	unsigned int	sent;
>  	__u8		state;
> +	atomic_t ref;

Please no, never use "raw" atomic variables.  Especially for something
like this, use a kref.

thanks,

greg k-h
