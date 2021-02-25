Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6357324A44
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 06:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhBYFxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 00:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbhBYFxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 00:53:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E26C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 21:52:57 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id u20so6779628ejb.7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 21:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xNO2ZHPDHz8Q7FCtoB8DJumL0rJ/VUMFnUyOmZZyixk=;
        b=GAnAa72z/a7E5JVLpyQyKl/fGsjSpWk2wpUVPNr6vFT5kjmpZJo+XyLu1Z9eBJEZAE
         z3/SKlMm+9mL3BY+o5d/o4lhwVn2dTt92Jpwbe38ScRvAOz4cEilr3F3u0Afl7x4W17s
         g6tjr/E6cm/iUoqAVrOOFZX/YeKGLtXvmNVMnUrZ1k7P2w2k62Qj7+tuK7GJT8kDrbj7
         EtcBCT3AZywfL93n0x/6+O3hZOkyWeirAjQSlvw/omgkMzytcxIhiXczcX2tlDh9HbAe
         /zEkOmQXym7Ff5INXMOW3OJogZaChJtOEtoQGeKmm1dxooKtXmA8LmtgdyYdAewee/ov
         ng5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xNO2ZHPDHz8Q7FCtoB8DJumL0rJ/VUMFnUyOmZZyixk=;
        b=j8gGJ3XHK8Vrl37X2Lsf9arymcGosVN8+b3TeijqG9yruYX/loXKKnvHOVpbZz4FEE
         UMR+T6+Ic4/EK/rBt6g6NP5N7EvnaWm3BorgB08dRnzId8dIDqn1jxdELkZPeLghDly2
         L+V3/5Dt+GUv2C7lJSuKG1n+u5NaqOfDSZdOHD4W0bzQJN2+6NngeDOuTZ+r96dVVWs5
         p0Nr7YC+K1H9eXFCPM0o8rfXzPIIFaB6g7XU1UvYCaFEezc8N25Cn9IuQS/VZDNS7aQt
         O2/C2O/odNu1rhG3JJSfHlsFrjmmVtjhUJU+tdPD0EWzoKbnA4sHVAutXen3Mm7gQrH/
         OJvg==
X-Gm-Message-State: AOAM533jlyM8uaLLpQAdktb6dO59Bn+dbYaMTeMB9XUCA7WRS0Jz6Ldb
        VCehcxyO5TnDt0dR5KlQ6Vo=
X-Google-Smtp-Source: ABdhPJxd4lHQsMSipe5oaDMRQ8mnHm1ZiUGKVQrSpuQJiZCwB9NyjtZlP0QXM9aaXaacSsrhda2ofQ==
X-Received: by 2002:a17:906:dc8e:: with SMTP id cs14mr1144701ejc.66.1614232375749;
        Wed, 24 Feb 2021 21:52:55 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id f22sm2364018eje.34.2021.02.24.21.52.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Feb 2021 21:52:55 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.10\))
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
Date:   Thu, 25 Feb 2021 07:52:53 +0200
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D71DFB7-F35D-45DA-A014-34950548C4BE@gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
 <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
To:     Wei Wang <weiwan@google.com>
X-Mailer: Apple Mail (2.3654.80.0.2.10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei, Jakub and Eric

I have attached the new crash log below.

@Wei  I try to use external driver from sourceforge ixgbe and build in =
kernel internel driver.
With external driver when machine boot immediately crashed and reboot =
system.
With internal driver in kernel 5.11.1 one time get Bug info when system =
finishing boot and enable threaded. Other time system boot without any =
errors and after 1-2 hour crash and reboot .


2 crash with system reboot :


Feb 25 05:12:26  [20079.489376][ T3787] ------------[ cut here =
]------------
Feb 25 05:12:26  [20079.512029][ T3787] list_del corruption. next->prev =
should be ffff94e5c4bfe800, but was ffff94e5e2265b00
Feb 25 05:12:26  [20079.557299][ T3787] WARNING: CPU: 17 PID: 3787 at =
lib/list_debug.c:54 __list_del_entry_valid+0x8a/0x90
Feb 25 05:12:26  [20079.602545][ T3787] Modules linked in: udp_diag =
raw_diag unix_diag nf_conntrack_netlink nfnetlink iptable_filter =
xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat ip_tables  pppoe =
pppox ppp_generic slhc team_mode_loadbalance team netconsole coretemp =
ixgbe mdio mdio_devres libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp =
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
Feb 25 05:12:26  [20079.786930][ T3787] CPU: 17 PID: 3787 Comm: kresd =
Tainted: G        W  O      5.11.1 #1
Feb 25 05:12:26  [20079.832711][ T3787] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 05:12:26  [20079.878486][ T3787] RIP: =
0010:__list_del_entry_valid+0x8a/0x90
Feb 25 05:12:26  [20079.901452][ T3787] Code: 51 00 0f 0b 31 c0 c3 48 89 =
f2 48 89 fe 48 c7 c7 38 f2 34 84 e8 8f 43 51 00 0f 0b 31 c0 c3 48 c7 c7 =
78 f2 34 84 e8 7e 43 51 00 <0f> 0b 31 c0 c3 cc 89 f8 48 85 d2 74 20 48 =
8d 0c 16 0f b6 16 48 ff
Feb 25 05:12:26  [20079.970301][ T3787] RSP: 0018:ffffa3af46073ce0 =
EFLAGS: 00010282
Feb 25 05:12:26  [20079.993714][ T3787] RAX: 0000000000000054 RBX: =
ffff94e5db11a158 RCX: 00000000ffefffff
Feb 25 05:12:27  [20080.041094][ T3787] RDX: 00000000ffefffff RSI: =
ffff94e9a6800000 RDI: 0000000000000001
Feb 25 05:12:27  [20080.090577][ T3787] RBP: ffff94e5db11a158 R08: =
ffff94e9ad7fffe8 R09: 00000000ffffffea
Feb 25 05:12:27  [20080.141361][ T3787] R10: 00000000ffefffff R11: =
80000000fff00000 R12: ffff94e5c4bfe800
Feb 25 05:12:27  [20080.192432][ T3787] R13: 0000000000000005 R14: =
ffffa3af46073d08 R15: ffff94e5c4bfe800
Feb 25 05:12:27  [20080.243987][ T3787] FS:  00007fe4f6383d80(0000) =
GS:ffff94e9af9c0000(0000) knlGS:0000000000000000
Feb 25 05:12:27  [20080.295701][ T3787] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 05:12:27  [20080.321667][ T3787] CR2: 00007fe4f6309114 CR3: =
0000000151a82001 CR4: 00000000001706e0
Feb 25 05:12:27  [20080.372339][ T3787] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 05:12:27  [20080.422779][ T3787] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 05:12:27  [20080.472894][ T3787] Call Trace:
Feb 25 05:12:27  [20080.497205][ T3787]  =
netif_receive_skb_list_internal+0x26c/0x2c0
Feb 25 05:12:27  [20080.521674][ T3787]  busy_poll_stop+0x171/0x1a0
Feb 25 05:12:27  [20080.545845][ T3787]  ? =
ixgbe_clean_rx_irq+0xa10/0xa10 [ixgbe]
Feb 25 05:12:27  [20080.569820][ T3787]  ? =
ep_destroy_wakeup_source+0x20/0x20
Feb 25 05:12:27  [20080.593359][ T3787]  napi_busy_loop+0x32a/0x340
Feb 25 05:12:27  [20080.616508][ T3787]  ? ktime_get_ts64+0x44/0xe0
Feb 25 05:12:27  [20080.639370][ T3787]  ep_poll+0xc6/0x660
Feb 25 05:12:27  [20080.661570][ T3787]  =
do_epoll_pwait.part.0+0xf3/0x160
Feb 25 05:12:27  [20080.683715][ T3787]  =
__x64_sys_epoll_pwait+0x6a/0x100
Feb 25 05:12:27  [20080.705454][ T3787]  ? do_syscall_64+0x2d/0x40
Feb 25 05:12:27  [20080.726932][ T3787]  ? =
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Feb 25 05:12:27  [20080.748279][ T3787] ---[ end trace 51046c7b7172e5a4 =
]---
Feb 25 05:12:27  [20080.769384][    C5] BUG: kernel NULL pointer =
dereference, address: 0000000000000008
Feb 25 05:12:27  [20080.810675][    C5] #PF: supervisor write access in =
kernel mode
Feb 25 05:12:27  [20080.831353][    C5] #PF: error_code(0x0002) - =
not-present page
Feb 25 05:12:27  [20080.851636][    C5] PGD 105b18067 P4D 105b18067 PUD =
1024cf067 PMD 0
Feb 25 05:12:27  [20080.871706][    C5] Oops: 0002 [#1] SMP NOPTI
Feb 25 05:12:27  [20080.891182][    C5] CPU: 5 PID: 37104 Comm: =
napi/eth1-691 Tainted: G        W  O      5.11.1 #1
Feb 25 05:12:27  [20080.929470][    C5] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 05:12:27  [20080.967621][    C5] RIP: =
0010:process_backlog+0xcf/0x230
Feb 25 05:12:27  [20080.986894][    C5] Code: 01 00 00 41 8b b7 10 ff ff =
ff 8d 56 ff 41 89 97 10 ff ff ff 48 8b 08 48 8b 50 08 48 c7 00 00 00 00 =
00 48 c7 40 08 00 00 00 00 <48> 89 51 08 48 89 0a 0f 1f 44 00 00 48 89 =
44 24 08 48 8d 54 24 10
Feb 25 05:12:27  [20081.044247][    C5] RSP: 0018:ffffa3af43420eb8 =
EFLAGS: 00010286
Feb 25 05:12:28  [20081.063017][    C5] RAX: ffff94e5c4bfe800 RBX: =
ffff94e5af961e50 RCX: 0000000000000000
Feb 25 05:12:28  [20081.100074][    C5] RDX: ffff94e5af961e50 RSI: =
0000000000000002 RDI: ffffffff836e3601
Feb 25 05:12:28  [20081.138274][    C5] RBP: 0000000000000040 R08: =
0000000000000000 R09: 0000000000000003
Feb 25 05:12:28  [20081.177716][    C5] R10: ffff94e36e9d2ac0 R11: =
ffff94e35a0a8660 R12: 0000000000000003
Feb 25 05:12:28  [20081.218624][    C5] R13: ffff94e5da7b2c40 R14: =
ffff94e243ce4000 R15: ffff94e5af961f50
Feb 25 05:12:28  [20081.261329][    C5] FS:  0000000000000000(0000) =
GS:ffff94e5af940000(0000) knlGS:0000000000000000
Feb 25 05:12:28  [20081.306019][    C5] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 05:12:28  [20081.329045][    C5] CR2: 0000000000000008 CR3: =
000000021d4b2006 CR4: 00000000001706e0
Feb 25 05:12:28  [20081.374528][    C5] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 05:12:28  [20081.420343][    C5] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 05:12:28  [20081.467189][    C5] Call Trace:
Feb 25 05:12:28  [20081.490382][    C5]  <IRQ>
Feb 25 05:12:28  [20081.513088][    C5]  __napi_poll+0x21/0x190
Feb 25 05:12:28  [20081.535582][    C5]  net_rx_action+0x239/0x2f0
Feb 25 05:12:28  [20081.557602][    C5]  __do_softirq+0xad/0x1d8
Feb 25 05:12:28  [20081.579133][    C5]  asm_call_irq_on_stack+0xf/0x20
Feb 25 05:12:28  [20081.600495][    C5]  </IRQ>
Feb 25 05:12:28  [20081.621370][    C5]  do_softirq_own_stack+0x32/0x40
Feb 25 05:12:28  [20081.642058][    C5]  do_softirq+0x42/0x50
Feb 25 05:12:28  [20081.662354][    C5]  __local_bh_enable_ip+0x45/0x50
Feb 25 05:12:28  [20081.682435][    C5]  napi_threaded_poll+0x120/0x150
Feb 25 05:12:28  [20081.702239][    C5]  ? __napi_poll+0x190/0x190
Feb 25 05:12:28  [20081.721585][    C5]  kthread+0xea/0x120
Feb 25 05:12:28  [20081.740384][    C5]  ? kthread_park+0x80/0x80
Feb 25 05:12:28  [20081.758773][    C5]  ret_from_fork+0x1f/0x30
Feb 25 05:12:28  [20081.776646][    C5] Modules linked in: udp_diag =
raw_diag unix_diag nf_conntrack_netlink nfnetlink iptable_filter =
xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat ip_tables  pppoe =
pppox ppp_generic slhc  team_mode_loadbalance team netconsole coretemp =
ixgbe mdio mdio_devres libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp =
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos=20
Feb 25 05:12:28  [20081.924344][    C5] CR2: 0000000000000008
Feb 25 05:12:28  [20081.943038][    C5] ---[ end trace 51046c7b7172e5a5 =
]---
Feb 25 05:12:28  [20081.961529][    C5] RIP: =
0010:process_backlog+0xcf/0x230
Feb 25 05:12:28  [20081.979654][    C5] Code: 01 00 00 41 8b b7 10 ff ff =
ff 8d 56 ff 41 89 97 10 ff ff ff 48 8b 08 48 8b 50 08 48 c7 00 00 00 00 =
00 48 c7 40 08 00 00 00 00 <48> 89 51 08 48 89 0a 0f 1f 44 00 00 48 89 =
44 24 08 48 8d 54 24 10
Feb 25 05:12:28  [20082.033915][    C5] RSP: 0018:ffffa3af43420eb8 =
EFLAGS: 00010286
Feb 25 05:12:29  [20082.052231][    C5] RAX: ffff94e5c4bfe800 RBX: =
ffff94e5af961e50 RCX: 0000000000000000
Feb 25 05:12:29  [20082.089750][    C5] RDX: ffff94e5af961e50 RSI: =
0000000000000002 RDI: ffffffff836e3601
Feb 25 05:12:29  [20082.129164][    C5] RBP: 0000000000000040 R08: =
0000000000000000 R09: 0000000000000003
Feb 25 05:12:29  [20082.170336][    C5] R10: ffff94e36e9d2ac0 R11: =
ffff94e35a0a8660 R12: 0000000000000003
Feb 25 05:12:29  [20082.213161][    C5] R13: ffff94e5da7b2c40 R14: =
ffff94e243ce4000 R15: ffff94e5af961f50
Feb 25 05:12:29  [20082.257809][    C5] FS:  0000000000000000(0000) =
GS:ffff94e5af940000(0000) knlGS:0000000000000000
Feb 25 05:12:29  [20082.304448][    C5] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 05:12:29  [20082.328708][    C5] CR2: 0000000000000008 CR3: =
000000021d4b2006 CR4: 00000000001706e0
Feb 25 05:12:29  [20082.377167][    C5] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 05:12:29  [20082.425510][    C5] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 05:12:29  [20082.473439][    C5] Kernel panic - not syncing: =
Fatal exception in interrupt
Feb 25 05:12:29  [20082.497657][   C36] ------------[ cut here =
]------------
Feb 25 05:12:29  [20082.521414][   C36] sched: Unexpected reschedule of =
offline CPU#12!
Feb 25 05:12:29  [20082.544949][   C36] WARNING: CPU: 36 PID: 0 at =
arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x2c/0x30
Feb 25 05:12:29  [20082.591983][   C36] Modules linked in: udp_diag =
raw_diag unix_diag nf_conntrack_netlink nfnetlink iptable_filter =
xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat ip_tables pppoe =
pppox ppp_generic slhc team_mode_loadbalance team netconsole coretemp =
ixgbe mdio mdio_devres libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp =
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
Feb 25 05:12:29  [20082.792688][   C36] CPU: 36 PID: 0 Comm: swapper/36 =
Tainted: G      D W  O      5.11.1 #1
Feb 25 05:12:29  [20082.843263][   C36] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 05:12:29  [20082.893782][   C36] RIP: =
0010:native_smp_send_reschedule+0x2c/0x30
Feb 25 05:12:29  [20082.919265][   C36] Code: 48 0f a3 05 f6 f2 62 01 73 =
12 48 8b 05 4d b6 36 01 be fd 00 00 00 48 8b 40 30 ff e0 89 fe 48 c7 c7 =
20 d4 32 84 e8 3c 95 7d 00 <0f> 0b c3 90 48 8b 05 29 b6 36 01 be fb 00 =
00 00 48 8b 40 30 ff e0
Feb 25 05:12:29  [20082.995368][   C36] RSP: 0018:ffffa3af4397cf18 =
EFLAGS: 00010096
Feb 25 05:12:30  [20083.020383][   C36] RAX: 000000000000002f RBX: =
0000000000000000 RCX: 00000000ffefffff
Feb 25 05:12:30  [20083.069872][   C36] RDX: 00000000ffefffff RSI: =
ffff94e9a6800000 RDI: 0000000000000001
Feb 25 05:12:30  [20083.119633][   C36] RBP: ffffa3af4397cf68 R08: =
ffff94e9ad7fffe8 R09: 00000000ffffffea
Feb 25 05:12:30  [20083.169439][   C36] R10: 00000000ffefffff R11: =
80000000fff00000 R12: 0000000000000002
Feb 25 05:12:30  [20083.219384][   C36] R13: ffff94e5da7b3b00 R14: =
0000000000020dc0 R15: ffff94e9af8a0dc0
Feb 25 05:12:30  [20083.269795][   C36] FS:  0000000000000000(0000) =
GS:ffff94e9afc00000(0000) knlGS:0000000000000000
Feb 25 05:12:30  [20083.320848][   C36] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 05:12:30  [20083.346500][   C36] CR2: 00007fe4f6368414 CR3: =
0000000151a82004 CR4: 00000000001706e0
Feb 25 05:12:30  [20083.396487][   C36] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 05:12:30  [20083.446178][   C36] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 05:12:30  [20083.495481][   C36] Call Trace:
Feb 25 05:12:30  [20083.519343][   C36]  <IRQ>
Feb 25 05:12:30  [20083.524266][    C5] Shutting down cpus with NMI
Feb 25 05:12:30  [20083.542492][   C36]  try_to_wake_up+0x5da/0x780
Feb 25 05:12:30  [20083.666286][    C5] Kernel Offset: 0x2000000 from =
0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Feb 25 05:12:30  [20083.734632][    C5] Rebooting in 10 seconds..
Feb 25 05:12:40  [20093.758840][    C5] ACPI MEMORY or I/O RESET_REG.


Feb 25 06:16:25  [ 3732.006467][ T3768] ------------[ cut here =
]------------
Feb 25 06:16:25  [ 3732.007210][ T3768] list_del corruption. prev->next =
should be ffff9a80f49ad700, but was ffff9a7fd593f158
Feb 25 06:16:25  [ 3732.008527][ T3768] WARNING: CPU: 0 PID: 3768 at =
lib/list_debug.c:51 __list_del_entry_valid+0x79/0x90
Feb 25 06:16:25  [ 3732.009798][ T3768] Modules linked in: =
nf_conntrack_netlink nfnetlink udp_diag raw_diag unix_diag =
iptable_filter xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat =
ip_tables pppoe pppox ppp_generic slhc team_mode_loadbalance team =
netconsole coretemp ixgbe mdio mdio_devres libphy nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si ipmi_devintf =
ipmi_msghandler rtc_cmos
Feb 25 06:16:25  [ 3732.017363][ T3768] CPU: 0 PID: 3768 Comm: kresd =
Tainted: G           O      5.11.1 #1
Feb 25 06:16:25  [ 3732.018450][ T3768] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 06:16:25  [ 3732.019591][ T3768] RIP: =
0010:__list_del_entry_valid+0x79/0x90
Feb 25 06:16:25  [ 3732.020392][ T3768] Code: c3 48 89 fe 4c 89 c2 48 c7 =
c7 00 f2 34 b0 e8 a6 43 51 00 0f 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 =
38 f2 34 b0 e8 8f 43 51 00 <0f> 0b 31 c0 c3 48 c7 c7 78 f2 34 b0 e8 7e =
43 51 00 0f 0b 31 c0 c3
Feb 25 06:16:25  [ 3732.023055][ T3768] RSP: 0018:ffffb362c489fce0 =
EFLAGS: 00010282
Feb 25 06:16:25  [ 3732.023865][ T3768] RAX: 0000000000000054 RBX: =
ffff9a7fd593f158 RCX: 00000000ffefffff
Feb 25 06:16:25  [ 3732.024934][ T3768] RDX: 00000000ffefffff RSI: =
ffff9a8726800000 RDI: 0000000000000001
Feb 25 06:16:25  [ 3732.050484][ T3768] RBP: ffff9a7fd593f158 R08: =
ffff9a872d7fffe8 R09: 00000000ffffffea
Feb 25 06:16:25  [ 3732.101572][ T3768] R10: 00000000ffefffff R11: =
80000000fff00000 R12: ffff9a80f49ad700
Feb 25 06:16:26  [ 3732.153197][ T3768] R13: 0000000000000010 R14: =
ffffb362c489fd08 R15: ffff9a80f49ad700
Feb 25 06:16:26  [ 3732.205130][ T3768] FS:  00007f70035a0d80(0000) =
GS:ffff9a832f800000(0000) knlGS:0000000000000000
Feb 25 06:16:26  [ 3732.256908][ T3768] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 06:16:26  [ 3732.283060][ T3768] CR2: 00007ffc9012dd58 CR3: =
0000000137d8a001 CR4: 00000000001706f0
Feb 25 06:16:26  [ 3732.334006][ T3768] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 06:16:26  [ 3732.384341][ T3768] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 06:16:26  [ 3732.434478][ T3768] Call Trace:
Feb 25 06:16:26  [ 3732.458838][ T3768]  =
netif_receive_skb_list_internal+0x26c/0x2c0
Feb 25 06:16:26  [ 3732.483356][ T3768]  busy_poll_stop+0x171/0x1a0
Feb 25 06:16:26  [ 3732.507593][ T3768]  ? =
ixgbe_clean_rx_irq+0xa10/0xa10 [ixgbe]
Feb 25 06:16:26  [ 3732.531658][ T3768]  ? =
ep_destroy_wakeup_source+0x20/0x20
Feb 25 06:16:26  [ 3732.555290][ T3768]  napi_busy_loop+0x32a/0x340
Feb 25 06:16:26  [ 3732.578556][ T3768]  ? ktime_get_ts64+0x44/0xe0
Feb 25 06:16:26  [ 3732.601494][ T3768]  ep_poll+0xc6/0x660
Feb 25 06:16:26  [ 3732.623816][ T3768]  =
do_epoll_pwait.part.0+0xf3/0x160
Feb 25 06:16:26  [ 3732.646157][ T3768]  =
__x64_sys_epoll_pwait+0x6a/0x100
Feb 25 06:16:26  [ 3732.668097][ T3768]  ? do_syscall_64+0x2d/0x40
Feb 25 06:16:26  [ 3732.689774][ T3768]  ? =
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Feb 25 06:16:26  [ 3732.711306][ T3768] ---[ end trace 4a3b032bd7c76cab =
]---
Feb 25 06:16:26  [ 3732.749411][    C0] BUG: kernel NULL pointer =
dereference, address: 0000000000000008
Feb 25 06:16:26  [ 3732.791034][    C0] #PF: supervisor write access in =
kernel mode
Feb 25 06:16:26  [ 3732.811904][    C0] #PF: error_code(0x0002) - =
not-present page
Feb 25 06:16:26  [ 3732.832354][    C0] PGD 105979067 P4D 105979067 PUD =
133337067 PMD 0
Feb 25 06:16:26  [ 3732.852769][    C0] Oops: 0002 [#1] SMP NOPTI
Feb 25 06:16:26  [ 3732.872440][    C0] CPU: 0 PID: 10 Comm: ksoftirqd/0 =
Tainted: G        W  O      5.11.1 #1
Feb 25 06:16:26  [ 3732.910862][    C0] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 06:16:26  [ 3732.949036][    C0] RIP: =
0010:process_backlog+0xcf/0x230
Feb 25 06:16:26  [ 3732.968335][    C0] Code: 01 00 00 41 8b b7 10 ff ff =
ff 8d 56 ff 41 89 97 10 ff ff ff 48 8b 08 48 8b 50 08 48 c7 00 00 00 00 =
00 48 c7 40 08 00 00 00 00 <48> 89 51 08 48 89 0a 0f 1f 44 00 00 48 89 =
44 24 08 48 8d 54 24 10
Feb 25 06:16:26  [ 3733.025756][    C0] RSP: 0018:ffffb362c31f3da8 =
EFLAGS: 00010286
Feb 25 06:16:26  [ 3733.044533][    C0] RAX: ffff9a80f49ad700 RBX: =
ffff9a832f821e50 RCX: 0000000000000000
Feb 25 06:16:26  [ 3733.081729][    C0] RDX: ffff9a832f821e50 RSI: =
000000000000060c RDI: ffffffffaf6e3601
Feb 25 06:16:26  [ 3733.119967][    C0] RBP: 0000000000000040 R08: =
0000000000000000 R09: 0000000000000003
Feb 25 06:16:27  [ 3733.159415][    C0] R10: ffff9a835b65eec0 R11: =
ffff9a83428d7620 R12: 0000000000000031
Feb 25 06:16:27  [ 3733.200430][    C0] R13: ffff9a7fc1d5c9c0 R14: =
ffff9a8359740000 R15: ffff9a832f821f50
Feb 25 06:16:27  [ 3733.243461][    C0] FS:  0000000000000000(0000) =
GS:ffff9a832f800000(0000) knlGS:0000000000000000
Feb 25 06:16:27  [ 3733.288289][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 06:16:27  [ 3733.311467][    C0] CR2: 0000000000000008 CR3: =
0000000137d8a001 CR4: 00000000001706f0
Feb 25 06:16:27  [ 3733.357178][    C0] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 06:16:27  [ 3733.403142][    C0] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 06:16:27  [ 3733.450233][    C0] Call Trace:
Feb 25 06:16:27  [ 3733.473595][    C0]  __napi_poll+0x21/0x190
Feb 25 06:16:27  [ 3733.496875][    C0]  net_rx_action+0x239/0x2f0
Feb 25 06:16:27  [ 3733.519867][    C0]  __do_softirq+0xad/0x1d8
Feb 25 06:16:27  [ 3733.542374][    C0]  run_ksoftirqd+0x15/0x20
Feb 25 06:16:27  [ 3733.564322][    C0]  smpboot_thread_fn+0xb3/0x140
Feb 25 06:16:27  [ 3733.586069][    C0]  ? sort_range+0x20/0x20
Feb 25 06:16:27  [ 3733.607479][    C0]  kthread+0xea/0x120
Feb 25 06:16:27  [ 3733.628223][    C0]  ? kthread_park+0x80/0x80
Feb 25 06:16:27  [ 3733.648796][    C0]  ret_from_fork+0x1f/0x30
Feb 25 06:16:27  [ 3733.668921][    C0] Modules linked in: =
nf_conntrack_netlink nfnetlink udp_diag raw_diag unix_diag =
iptable_filter xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat =
ip_tables  pppoe pppox ppp_generic slhc team_mode_loadbalance team =
netconsole coretemp ixgbe mdio mdio_devres libphy nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si ipmi_devintf =
ipmi_msghandler rtc_cmos=20
Feb 25 06:16:27  [ 3733.835634][    C0] CR2: 0000000000000008
Feb 25 06:16:27  [ 3733.856445][    C0] ---[ end trace 4a3b032bd7c76cac =
]---
Feb 25 06:16:27  [ 3733.877035][    C0] RIP: =
0010:process_backlog+0xcf/0x230
Feb 25 06:16:27  [ 3733.897229][    C0] Code: 01 00 00 41 8b b7 10 ff ff =
ff 8d 56 ff 41 89 97 10 ff ff ff 48 8b 08 48 8b 50 08 48 c7 00 00 00 00 =
00 48 c7 40 08 00 00 00 00 <48> 89 51 08 48 89 0a 0f 1f 44 00 00 48 89 =
44 24 08 48 8d 54 24 10
Feb 25 06:16:27  [ 3733.957692][    C0] RSP: 0018:ffffb362c31f3da8 =
EFLAGS: 00010286
Feb 25 06:16:27  [ 3733.977756][    C0] RAX: ffff9a80f49ad700 RBX: =
ffff9a832f821e50 RCX: 0000000000000000
Feb 25 06:16:27  [ 3734.016952][    C0] RDX: ffff9a832f821e50 RSI: =
000000000000060c RDI: ffffffffaf6e3601
Feb 25 06:16:27  [ 3734.056124][    C0] RBP: 0000000000000040 R08: =
0000000000000000 R09: 0000000000000003
Feb 25 06:16:27  [ 3734.096738][    C0] R10: ffff9a835b65eec0 R11: =
ffff9a83428d7620 R12: 0000000000000031
Feb 25 06:16:27  [ 3734.139326][    C0] R13: ffff9a7fc1d5c9c0 R14: =
ffff9a8359740000 R15: ffff9a832f821f50
Feb 25 06:16:28  [ 3734.184006][    C0] FS:  0000000000000000(0000) =
GS:ffff9a832f800000(0000) knlGS:0000000000000000
Feb 25 06:16:28  [ 3734.230851][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 06:16:28  [ 3734.255442][    C0] CR2: 0000000000000008 CR3: =
0000000137d8a001 CR4: 00000000001706f0
Feb 25 06:16:28  [ 3734.304596][    C0] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 06:16:28  [ 3734.353227][    C0] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 06:16:28  [ 3734.401522][    C0] Kernel panic - not syncing: =
Fatal exception in interrupt
Feb 25 06:16:28  [ 3734.425941][   C10] ------------[ cut here =
]------------
Feb 25 06:16:28  [ 3734.449850][   C10] sched: Unexpected reschedule of =
offline CPU#31!
Feb 25 06:16:28  [ 3734.473526][   C10] WARNING: CPU: 10 PID: 0 at =
arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x2c/0x30
Feb 25 06:16:28  [ 3734.520834][   C10] Modules linked in: =
nf_conntrack_netlink nfnetlink udp_diag raw_diag unix_diag =
iptable_filter xt_TCPMSS iptable_mangle xt_addrtype xt_nat iptable_nat =
ip_tables pppoe pppox ppp_generic slhc  team_mode_loadbalance team =
netconsole coretemp ixgbe mdio mdio_devres libphy nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si ipmi_devintf =
ipmi_msghandler rtc_cmos=20
Feb 25 06:16:28  [ 3734.723018][   C10] CPU: 10 PID: 0 Comm: swapper/10 =
Tainted: G      D W  O      5.11.1 #1
Feb 25 06:16:28  [ 3734.773886][   C10] Hardware name: Supermicro Super =
Server/X10DRi-LN4+, BIOS 3.2 11/19/2019
Feb 25 06:16:28  [ 3734.824595][   C10] RIP: =
0010:native_smp_send_reschedule+0x2c/0x30
Feb 25 06:16:28  [ 3734.850148][   C10] Code: 48 0f a3 05 f6 f2 62 01 73 =
12 48 8b 05 4d b6 36 01 be fd 00 00 00 48 8b 40 30 ff e0 89 fe 48 c7 c7 =
20 d4 32 b0 e8 3c 95 7d 00 <0f> 0b c3 90 48 8b 05 29 b6 36 01 be fb 00 =
00 00 48 8b 40 30 ff e0
Feb 25 06:16:28  [ 3734.926375][   C10] RSP: 0018:ffffb362c34fcf18 =
EFLAGS: 00010096
Feb 25 06:16:28  [ 3734.951428][   C10] RAX: 000000000000002f RBX: =
0000000000000000 RCX: 00000000ffefffff
Feb 25 06:16:28  [ 3735.000932][   C10] RDX: 00000000ffefffff RSI: =
ffff9a8726800000 RDI: 0000000000000001
Feb 25 06:16:28  [ 3735.050766][   C10] RBP: ffffb362c34fcf68 R08: =
ffff9a872d7fffe8 R09: 00000000ffffffea
Feb 25 06:16:28  [ 3735.100642][   C10] R10: 00000000ffefffff R11: =
80000000fff00000 R12: 0000000000000002
Feb 25 06:16:29  [ 3735.150651][   C10] R13: ffff9a8359acac40 R14: =
0000000000020dc0 R15: ffff9a872fae0dc0
Feb 25 06:16:29  [ 3735.201238][   C10] FS:  0000000000000000(0000) =
GS:ffff9a872f800000(0000) knlGS:0000000000000000
Feb 25 06:16:29  [ 3735.252469][   C10] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Feb 25 06:16:29  [ 3735.278217][   C10] CR2: 00007f1ef4480828 CR3: =
0000000246356005 CR4: 00000000001706e0
Feb 25 06:16:29  [ 3735.328368][   C10] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Feb 25 06:16:29  [ 3735.378197][   C10] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Feb 25 06:16:29  [ 3735.427739][   C10] Call Trace:
Feb 25 06:16:29  [ 3735.451761][   C10]  <IRQ>
Feb 25 06:16:29  [ 3735.452551][    C0] Shutting down cpus with NMI
Feb 25 06:16:29  [ 3735.475047][   C10]  try_to_wake_up+0x5da/0x780
Feb 25 06:16:29  [ 3735.612306][    C0] Kernel Offset: 0x2e000000 from =
0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Feb 25 06:16:29  [ 3735.680997][    C0] Rebooting in 10 seconds..
Feb 25 06:16:39  [ 3745.704638][    C0] ACPI MEMORY or I/O RESET_REG.


Martin
