Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FF960147A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJQRPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiJQRPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:15:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCED58514
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666026937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTPjQ+L7t3QDYthVXhRZFlmlQ11pyMSRL3Ye16AEvZQ=;
        b=fUAWtHoTNdjJko5zSMzfrhcqL93eS7dW8hrO7JpJTuIHrpN4eQhSO1MIj0GCyk3D6vPS82
        UtJQf9a92YxZ49dqJKAyxMZPGeTezz31KghG7wyO0OizD4Uoe0L3hkpWhlOf1KaaD4m/ux
        C1aZ4WOajbWgrplDX4te/F7l9OlYNLk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-456-q7tf6ofYM16Ih9HBieMHtQ-1; Mon, 17 Oct 2022 13:15:36 -0400
X-MC-Unique: q7tf6ofYM16Ih9HBieMHtQ-1
Received: by mail-qv1-f70.google.com with SMTP id v3-20020a0cf903000000b004b4619bb7e3so7249597qvn.22
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uTPjQ+L7t3QDYthVXhRZFlmlQ11pyMSRL3Ye16AEvZQ=;
        b=rccZqgzcaVIvdV2aEu4ZBZGTaO5DdVEJ0kCcpPRVJruXuYi9Xvk44nj02fGr9a2eIG
         +0lhlHwQcIhciuTYHL9Yj4os+tU58JBSThFLgQPPaUulsF74ptI1pb9A+LXWvinSAZSb
         3Bqf4x0YZDO/ZX4yhjoo8htA4sfH4a43X+9AaJj6aX6fCcY3w2AjwZRxtNCuBXFAcQvi
         GP1uNlUW3YPjzYN5+x5N91ifQBcxJ5wPztYCkbvxX4l8j2r2Hy8Hxv/BNS5FXbdOmf42
         pKKcTCfMfONMFcurmOMucP8dS9ie9Ssn5qJ2pZTuqlz+BtmsgQe4k/tfZRJzv2x15riM
         5Ntw==
X-Gm-Message-State: ACrzQf0ECZw48aRwHJLwFoWFyo9O9B1xk/wf9u61ScUp0EAcVhg4MOla
        mxvfTQJ5LoK/vBJwM1t1WlzBIk9VOfBFM6RDZ5/wWm86hIJIw1QqO6ck8ApbTJ6UzDFApjjJu3p
        oEAzkTw3FH609NwF2
X-Received: by 2002:a05:620a:2718:b0:6ed:4883:141c with SMTP id b24-20020a05620a271800b006ed4883141cmr8300051qkp.496.1666026936206;
        Mon, 17 Oct 2022 10:15:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6D09Mm++vFlZfF5Hm+uhiVzI68519YqC9p3nDghGKWNRnT+NNCqHFuLAoJ4bG857jmUtCm+Q==
X-Received: by 2002:a05:620a:2718:b0:6ed:4883:141c with SMTP id b24-20020a05620a271800b006ed4883141cmr8300024qkp.496.1666026935856;
        Mon, 17 Oct 2022 10:15:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id g8-20020ac87f48000000b0035cf31005e2sm203532qtk.73.2022.10.17.10.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:15:35 -0700 (PDT)
Message-ID: <f31aa394b15fe2449f9fc2552e43767f5cbfe211.camel@redhat.com>
Subject: Re: [ovs-dev] [syzbot] WARNING in ovs_dp_reset_user_features
From:   Paolo Abeni <pabeni@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     syzbot <syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com>,
        aahringo@redhat.com, ccaulfie@redhat.com, cluster-devel@redhat.com,
        davem@davemloft.net, dev@openvswitch.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pshelar@ovn.org,
        syzkaller-bugs@googlegroups.com, teigland@redhat.com
Date:   Mon, 17 Oct 2022 19:15:31 +0200
In-Reply-To: <f7th702d1jm.fsf@redhat.com>
References: <00000000000097399505ead9ef34@google.com>
         <c7dd8b101d78c27e1f21ab15f98627e5a5fd919e.camel@redhat.com>
         <f7th702d1jm.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-17 at 09:26 -0400, Aaron Conole wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> > On Wed, 2022-10-12 at 10:43 -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    e8bc52cb8df8 Merge tag 'driver-core-6.1-rc1' of git://git...
> > > git tree:       upstream
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=134de042880000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=7579993da6496f03
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=31cde0bef4bbf8ba2d86
> > > compiler: Debian clang version
> > > 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU
> > > ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12173a34880000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1792461a880000
> > > 
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/4dc25a89bfbd/disk-e8bc52cb.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/16c9ca5fd754/vmlinux-e8bc52cb.xz
> > > 
> > > The issue was bisected to:
> > > 
> > > commit 6b0afc0cc3e9a9a91f5a76d0965d449781441e18
> > > Author: Alexander Aring <aahringo@redhat.com>
> > > Date:   Wed Jun 22 18:45:23 2022 +0000
> > > 
> > >     fs: dlm: don't use deprecated timeout features by default
> > 
> > This commit is not really relevant for the issue, but it makes the
> > reproducer fail, since it changes the genl_family registration order
> > and the repro hard-codes the ovs genl family id.
> 
> I have an easy reproducer at:
> 
> http://git.bytheb.org/cgit/kselftest.git/commit/?id=97800e452e2cea1fafb45058120128e902d8970e
> 
> (PS: I do plan to do some cleanup and then post this kselftest stuff)
> 
> > > 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10d5787c880000
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=12d5787c880000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14d5787c880000
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com
> > > Fixes: 6b0afc0cc3e9 ("fs: dlm: don't use deprecated timeout features by default")
> > > 
> > > ------------[ cut here ]------------
> > > Dropping previously announced user features
> > > WARNING: CPU: 1 PID: 3608 at net/openvswitch/datapath.c:1619
> > > ovs_dp_reset_user_features+0x1bc/0x240
> > > net/openvswitch/datapath.c:1619
> > > Modules linked in:
> > > CPU: 1 PID: 3608 Comm: syz-executor162 Not tainted 6.0.0-syzkaller-07994-ge8bc52cb8df8 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> > > RIP: 0010:ovs_dp_reset_user_features+0x1bc/0x240 net/openvswitch/datapath.c:1619
> > > Code: 00 c7 03 00 00 00 00 eb 05 e8 d0 be 67 f7 5b 41 5c 41 5e 41 5f
> > > 5d c3 e8 c2 be 67 f7 48 c7 c7 00 92 e3 8b 31 c0 e8 74 7a 2f f7 <0f>
> > > 0b eb c7 44 89 f1 80 e1 07 fe c1 38 c1 0f 8c f1 fe ff ff 4c 89
> > > RSP: 0018:ffffc90003b8f370 EFLAGS: 00010246
> > > RAX: e794c0e413340e00 RBX: ffff8880175cae68 RCX: ffff88801c069d80
> > > RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> > > RBP: 0000000000000008 R08: ffffffff816c58ad R09: ffffed1017364f13
> > > R10: ffffed1017364f13 R11: 1ffff11017364f12 R12: dffffc0000000000
> > > R13: ffff8880175ca450 R14: 1ffff11002eb95cd R15: ffffc90003b8f6b0
> > > FS:  0000555557276300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000020000916 CR3: 000000001ed81000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  ovs_dp_cmd_new+0x8f6/0xc80 net/openvswitch/datapath.c:1822
> > >  genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
> > >  genl_family_rcv_msg net/netlink/genetlink.c:808 [inline]
> > >  genl_rcv_msg+0x11ca/0x1670 net/netlink/genetlink.c:825
> > >  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2540
> > >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:836
> > >  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> > >  netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
> > >  netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
> > >  sock_sendmsg_nosec net/socket.c:714 [inline]
> > >  sock_sendmsg net/socket.c:734 [inline]
> > >  ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
> > >  ___sys_sendmsg net/socket.c:2536 [inline]
> > >  __sys_sendmsg+0x28e/0x390 net/socket.c:2565
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7fc51f29de89
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48
> > > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
> > > 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffd99ec6ed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > > RAX: ffffffffffffffda RBX: 000000000000a2c4 RCX: 00007fc51f29de89
> > > RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
> > > RBP: 0000000000000000 R08: 00007ffd99ec7078 R09: 00007ffd99ec7078
> > > R10: 00007ffd99ec6950 R11: 0000000000000246 R12: 00007ffd99ec6eec
> > > R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
> > >  </TASK>
> > > 
> > In this specific case it looks like the warning is caused by the fact
> > that ovs allows an 'outdated' datapath to set user_features (version is
> > not checked in ovs_dp_change()) but later complains if the same user-
> > space touch again the same datapath (version check in
> > ovs_dp_reset_user_features())
> 
> Maybe this should be changed from WARN() to printk(KERN_NOTICE, ..) or
> something similar?  

nowaday it's pr_notice() ;), but even pr_warn() could fit (it will not
trigger a calltrace splat). I think such kind of change it's the right
thing to do.

Adding constraints on user_features change is not going to fly, as
syzkaller could e.g. change the esposed version across different
netlink ops.

Cheers,

Paolo

