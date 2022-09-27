Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574C15EB92C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 06:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiI0EZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 00:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiI0EZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 00:25:01 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2619443331;
        Mon, 26 Sep 2022 21:24:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y8so11583141edc.10;
        Mon, 26 Sep 2022 21:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=Qhij+rjILZXDr+3dJvPrhS9Wzmxt2vE9xc3gwCW9y/4=;
        b=MO/JQMEj73YcZ/TIrS8pPfV+iuy3VJR8dRpw29+9WYGZDSonxZc/74EYBxh5ZUaZfX
         Mosu/tmNVv6t1j22MBYa343rFWbWNOJfVLGu6c0u0sesxklANU2pCqJRN4NjMwRu9w+d
         TykOZ6slxWujmmXB0oxj5n+sJIElWZOHOSuugz17Fr2+8m1heUncxI1VjjPYVPCju61K
         XweLR7MQY71toSelqK1k1lr6MoNUPSBA807HsdjGOv8B04VHpylCmkg+xUoD124vgA51
         H1/CQ21ktsXoVHPBBV3ZGThPxyacV7QVVIYbRUkU8dZ3XrG9sz/2UIR556brZXgYGW3b
         G8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Qhij+rjILZXDr+3dJvPrhS9Wzmxt2vE9xc3gwCW9y/4=;
        b=JcOUE/jk4WPN+dGodew+MNdJTeXFoon3PfQus4Y8eL/JgR1ScqpuA/sqzLdkM8WTwL
         q9Bo5RERyhZW00OhtcEbmtu9MCZiKgGH22K6JyOiK6izLkgPm8/PwFho0JHej+xVVY0Y
         +wSnSShqbMTOU/UJ3kLBQ+OL7rJ9c/VEerkyZHQYlc+TG2KOtXPZsDwThcgNJ54WZefK
         diMx3js+10O2ZYFlFz5lKvyEQIoRneH+EX/ODYAkLwu02FFBuSpW+pSM+ISPl9sGbdS7
         KoaZnj0dVM/ly2uEKvV3tfAMvDDa9LB1zEig3RhY2uUjaFo/pvEUDcMlEy1PbKwMwsyi
         VoJQ==
X-Gm-Message-State: ACrzQf02M4Ny53y+iZnGymZmciaR1e5soDKt93qZ6qzQckAOYkb7d9t0
        btrLcObZ5Dppvp3swsBshSA=
X-Google-Smtp-Source: AMsMyM44RQ84B1aDVXGrsKZWMZ75w4JYXnkVyZ6xfoLOwA+BhvLmo6gdR5iABqiuOKBEPYVAIHIjDQ==
X-Received: by 2002:a50:fb17:0:b0:457:1808:8471 with SMTP id d23-20020a50fb17000000b0045718088471mr12993300edq.338.1664252697661;
        Mon, 26 Sep 2022 21:24:57 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906329200b0077f5e96129fsm110839ejw.158.2022.09.26.21.24.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Sep 2022 21:24:57 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220926151939.GG12777@breakpoint.cc>
Date:   Tue, 27 Sep 2022 07:24:55 +0300
Cc:     Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>,
        tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3AF0514E-57AB-417A-A800-A68FCF65749F@gmail.com>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFp4H/rbdov7iDg@dhcp22.suse.cz> <20220926151939.GG12777@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian

Apply v2 patch and upload on sever , after 4-5 hours work server crash =
see log:=20

Sep 27 04:15:53  [35863.462862][   C28] ------------[ cut here =
]------------
Sep 27 04:15:53  [35863.463590][   C28] NETDEV WATCHDOG: eth0 (i40e): =
transmit queue 18 timed out
Sep 27 04:15:53  [35863.464567][   C28] WARNING: CPU: 28 PID: 0 at =
net/sched/sch_generic.c:529 dev_watchdog+0x167/0x170
Sep 27 04:15:53  [35863.465799][   C28] Modules linked in: nft_limit =
nf_conntrack_netlink pppoe pppox ppp_generic slhc nft_ct =
nft_flow_offload nf_flow_table_inet nf_flow_table nft_nat nft_chain_nat =
team_mode_loadbalance team nf_tables netconsole coretemp i40e nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si ipmi_devintf =
ipmi_msghandler rtc_cmos
Sep 27 04:15:53  [35863.471915][   C28] CPU: 28 PID: 0 Comm: swapper/28 =
Tainted: G           O      5.19.11 #1
Sep 27 04:15:53  [35863.473036][   C28] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
Sep 27 04:15:53  [35863.474179][   C28] RIP: =
0010:dev_watchdog+0x167/0x170
Sep 27 04:15:53  [35863.474875][   C28] Code: 28 e9 77 ff ff ff 48 89 df =
c6 05 63 57 c4 00 01 e8 de 59 fb ff 48 89 c2 44 89 e1 48 89 de 48 c7 c7 =
08 c7 ec 97 e8 52 c6 13 00 <0f> 0b eb 85 0f 1f 44 00 00 41 55 41 54 55 =
53 48 8b 47 50 4c 8b 28
Sep 27 04:15:53  [35863.477517][   C28] RSP: 0018:ffff9ae9806b8ee8 =
EFLAGS: 00010292
Sep 27 04:15:53  [35863.478320][   C28] RAX: 0000000000000039 RBX: =
ffff96ad92269800 RCX: 0000000000000001
Sep 27 04:15:53  [35863.479379][   C28] RDX: 00000000ffffffea RSI: =
00000000fff7ffff RDI: 00000000fff7ffff
Sep 27 04:15:53  [35863.480439][   C28] RBP: ffff96ad92269bc0 R08: =
0000000000000001 R09: 00000000fff7ffff
Sep 27 04:15:53  [35863.481499][   C28] R10: ffff96b4dae00000 R11: =
0000000000000003 R12: 0000000000000012
Sep 27 04:15:53  [35863.482560][   C28] R13: 0000000000000000 R14: =
ffff96b4dfd207a8 R15: 0000000000000082
Sep 27 04:15:53  [35863.483621][   C28] FS:  0000000000000000(0000) =
GS:ffff96b4dfd00000(0000) knlGS:0000000000000000
Sep 27 04:15:53  [35863.484809][   C28] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Sep 27 04:15:53  [35863.485681][   C28] CR2: 00007f87fae3d2e8 CR3: =
000000016063b004 CR4: 00000000003706e0
Sep 27 04:15:53  [35863.486743][   C28] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 27 04:15:53  [35863.487802][   C28] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 27 04:15:53  [35863.488862][   C28] Call Trace:
Sep 27 04:15:53  [35863.489289][   C28]  <IRQ>
Sep 27 04:15:53  [35863.489653][   C28]  ? pfifo_fast_destroy+0x30/0x30
Sep 27 04:15:53  [35863.490313][   C28]  =
call_timer_fn.constprop.0+0x14/0x70
Sep 27 04:15:53  [35863.491033][   C28]  __run_timers.part.0+0x164/0x190
Sep 27 04:15:53  [35863.491706][   C28]  ? =
__hrtimer_run_queues+0x143/0x1a0
Sep 27 04:15:53  [35863.492414][   C28]  ? ktime_get+0x30/0x90
Sep 27 04:15:53  [35863.492969][   C28]  run_timer_softirq+0x21/0x50
Sep 27 04:15:53  [35863.493598][   C28]  __do_softirq+0xaf/0x1d7
Sep 27 04:15:53  [35863.494175][   C28]  __irq_exit_rcu+0x9a/0xd0
Sep 27 04:15:53  [35863.494767][   C28]  =
sysvec_apic_timer_interrupt+0x66/0x80
Sep 27 04:15:53  [35863.495510][   C28]  </IRQ>
Sep 27 04:15:53  [35863.495886][   C28]  <TASK>
Sep 27 04:15:53  [35863.496263][   C28]  =
asm_sysvec_apic_timer_interrupt+0x16/0x20
Sep 27 04:15:53  [35863.497054][   C28] RIP: =
0010:cpuidle_enter_state+0xb3/0x290
Sep 27 04:15:53  [35863.497822][   C28] Code: e8 12 25 b0 ff 31 ff 49 89 =
c5 e8 c8 80 af ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 cf 01 00 00 31 ff =
e8 c1 cb b3 ff fb 45 85 f6 <0f> 88 d0 00 00 00 49 63 ce 48 6b f1 68 48 =
8b 04 24 4c 89 ea 48 29
Sep 27 04:15:53  [35863.500462][   C28] RSP: 0018:ffff9ae9801cfe98 =
EFLAGS: 00000202
Sep 27 04:15:53  [35863.501266][   C28] RAX: ffff96b4dfd26800 RBX: =
ffff96ad80bfa000 RCX: 000000000000001f
Sep 27 04:15:53  [35863.502324][   C28] RDX: 0000209e1cf6d09d RSI: =
00000000313b14ef RDI: 0000000000000000
Sep 27 04:15:53  [35863.503387][   C28] RBP: 0000000000000001 R08: =
0000000000000002 R09: ffff96b4dfd25704
Sep 27 04:15:54  [35863.537016][   C28] R10: 0000000000000008 R11: =
00000000000000f3 R12: ffffffff98222da0
Sep 27 04:15:54  [35863.570647][   C28] R13: 0000209e1cf6d09d R14: =
0000000000000001 R15: 0000000000000000
Sep 27 04:15:54  [35863.603939][   C28]  ? =
cpuidle_enter_state+0x98/0x290
Sep 27 04:15:54  [35863.637176][   C28]  cpuidle_enter+0x24/0x40
Sep 27 04:15:54  [35863.669424][   C28]  cpuidle_idle_call+0xbb/0x100
Sep 27 04:15:54  [35863.701075][   C28]  do_idle+0x76/0xc0
Sep 27 04:15:54  [35863.731736][   C28]  cpu_startup_entry+0x14/0x20
Sep 27 04:15:54  [35863.761417][   C28]  start_secondary+0xd6/0xe0
Sep 27 04:15:54  [35863.790449][   C28]  =
secondary_startup_64_no_verify+0xd3/0xdb
Sep 27 04:15:54  [35863.818324][   C28]  </TASK>
Sep 27 04:15:54  [35863.844969][   C28] ---[ end trace 0000000000000000 =
]---
Sep 27 04:15:54  [35863.871638][   C28] i40e 0000:03:00.0 eth0: =
tx_timeout: VSI_seid: 390, Q 18, NTC: 0xa44, HWB: 0xd18, NTU: 0xd1a, =
TAIL: 0xd1a, INT: 0x0
Sep 27 04:15:54  [35863.926113][   C28] i40e 0000:03:00.0 eth0: =
tx_timeout recovery level 1, txqueue 18


Sep 27 05:44:05  [ 5136.419612][   C14] watchdog: BUG: soft lockup - =
CPU#14 stuck for 89s! [swapper/14:0]
Sep 27 05:44:05  [ 5136.420830][   C14] Kernel panic - not syncing: =
softlockup: hung tasks
Sep 27 05:44:05  [ 5136.421718][   C14] CPU: 14 PID: 0 Comm: swapper/14 =
Tainted: G           O L    5.19.11 #1
Sep 27 05:44:05  [ 5136.422842][   C14] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
Sep 27 05:44:05  [ 5136.423990][   C14] Call Trace:
Sep 27 05:44:05  [ 5136.424417][   C14]  <IRQ>
Sep 27 05:44:05  [ 5136.424784][   C14]  dump_stack_lvl+0x33/0x42
Sep 27 05:44:05  [ 5136.425377][   C14]  panic+0xea/0x24b
Sep 27 05:44:05  [ 5136.425875][   C14]  watchdog_timer_fn.cold+0xc/0x16
Sep 27 05:44:05  [ 5136.426549][   C14]  ? =
lockup_detector_update_enable+0x50/0x50
Sep 27 05:44:05  [ 5136.427343][   C14]  __hrtimer_run_queues+0xff/0x1a0
Sep 27 05:44:05  [ 5136.428021][   C14]  hrtimer_interrupt+0xee/0x200
Sep 27 05:44:05  [ 5136.428660][   C14]  =
__sysvec_apic_timer_interrupt+0x47/0x60
Sep 27 05:44:05  [ 5136.429430][   C14]  =
sysvec_apic_timer_interrupt+0x2d/0x80
Sep 27 05:44:05  [ 5136.430176][   C14]  =
asm_sysvec_apic_timer_interrupt+0x16/0x20
Sep 27 05:44:05  [ 5136.430970][   C14] RIP: =
0010:queued_spin_lock_slowpath+0x105/0x1a0
Sep 27 05:44:05  [ 5136.431822][   C14] Code: ff c0 41 c1 e0 12 c1 e6 10 =
41 09 f0 44 89 c0 c1 e8 10 66 87 42 02 89 c6 c1 e6 10 81 fe ff ff 00 00 =
77 48 31 f6 eb 03 0f ae e8 <8b> 02 66 85 c0 75 f6 89 c7 66 31 ff 44 39 =
c7 74 75 c6 02 01 48 85
Sep 27 05:44:05  [ 5136.434475][   C14] RSP: 0018:ffff9eaa80450d20 =
EFLAGS: 00000202
Sep 27 05:44:05  [ 5136.435279][   C14] RAX: 00000000003c0101 RBX: =
ffff88c800ce4800 RCX: ffff88ce1f9a73c0
Sep 27 05:44:05  [ 5136.436345][   C14] RDX: ffff88c800ce4804 RSI: =
0000000000000000 RDI: ffff88c800ce4804
Sep 27 05:44:05  [ 5136.437410][   C14] RBP: ffff88c7e8cd28e2 R08: =
00000000003c0000 R09: 0000000000000000
Sep 27 05:44:05  [ 5136.438477][   C14] R10: 382ecf75f888481b R11: =
68035d3c9e84f0bf R12: ffff88c7f91dea00
Sep 27 05:44:05  [ 5136.439543][   C14] R13: 0000000000000014 R14: =
0000000000000001 R15: ffff9eaa80450e78
Sep 27 05:44:05  [ 5136.440610][   C14]  =
nf_conntrack_tcp_packet+0xab/0xbb0 [nf_conntrack]
Sep 27 05:44:05  [ 5136.441505][   C14]  ? dev_hard_start_xmit+0x95/0xe0
Sep 27 05:44:05  [ 5136.442182][   C14]  ? =
hash_conntrack_raw.constprop.0+0x89/0x100 [nf_conntrack]
Sep 27 05:44:05  [ 5136.443180][   C14]  nf_conntrack_in+0x32f/0x500 =
[nf_conntrack]
Sep 27 05:44:05  [ 5136.443988][   C14]  nf_hook_slow+0x36/0xa0
Sep 27 05:44:05  [ 5136.444556][   C14]  ip_rcv+0x65/0xa0
Sep 27 05:44:05  [ 5136.445053][   C14]  ? =
ip_rcv_finish_core.constprop.0+0x2c0/0x2c0
Sep 27 05:44:05  [ 5136.445883][   C14]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 05:44:05  [ 5136.446641][   C14]  process_backlog+0x7c/0x110
Sep 27 05:44:05  [ 5136.447257][   C14]  __napi_poll+0x20/0x100
Sep 27 05:44:05  [ 5136.447826][   C14]  net_rx_action+0x26d/0x330
Sep 27 05:44:05  [ 5136.448429][   C14]  __do_softirq+0xaf/0x1d7
Sep 27 05:44:05  [ 5136.449009][   C14]  do_softirq+0x5a/0x80
Sep 27 05:44:05  [ 5136.449554][   C14]  </IRQ>
Sep 27 05:44:05  [ 5136.449932][   C14]  <TASK>
Sep 27 05:44:05  [ 5136.450312][   C14]  =
flush_smp_call_function_queue+0x3f/0x60
Sep 27 05:44:05  [ 5136.451083][   C14]  do_idle+0xa6/0xc0
Sep 27 05:44:05  [ 5136.451592][   C14]  cpu_startup_entry+0x14/0x20
Sep 27 05:44:05  [ 5136.452220][   C14]  start_secondary+0xd6/0xe0
Sep 27 05:44:05  [ 5136.452826][   C14]  =
secondary_startup_64_no_verify+0xd3/0xdb
Sep 27 05:44:05  [ 5136.453607][   C14]  </TASK>
Sep 27 05:44:05  [ 5136.565092][   C14] Kernel Offset: 0x3000000 from =
0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Sep 27 05:44:05  [ 5136.621741][   C14] Rebooting in 10 seconds..


> On 26 Sep 2022, at 18:19, Florian Westphal <fw@strlen.de> wrote:
>=20
> Michal Hocko <mhocko@suse.com> wrote:
>> On Mon 26-09-22 10:31:39, Florian Westphal wrote:
>>> Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
>>> kernel BUG at mm/vmalloc.c:2437!
>>> invalid opcode: 0000 [#1] SMP
>>> CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 =
#1
>>> [..]
>>> RIP: 0010:__get_vm_area_node+0x120/0x130
>>>  __vmalloc_node_range+0x96/0x1e0
>>>  kvmalloc_node+0x92/0xb0
>>>  bucket_table_alloc.isra.0+0x47/0x140
>>>  rhashtable_try_insert+0x3a4/0x440
>>>  rhashtable_insert_slow+0x1b/0x30
>>> [..]
>>>=20
>>> bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, =
this now
>>> falls through to vmalloc and hits code paths that assume GFP_KERNEL.
>>>=20
>>> I sent a patch to restore GFP_ATOMIC support in kvmalloc but mm
>>> maintainers rejected it.
>>>=20
>>> This patch is partial revert of
>>> commit 93f976b5190d ("lib/rhashtable: simplify =
bucket_table_alloc()"),
>>> to avoid kvmalloc for ATOMIC case.
>>>=20
>>> As kvmalloc doesn't warn when used with ATOMIC, kernel will only =
crash
>>> once vmalloc fallback occurs, so we may see more crashes in other =
areas
>>> in the future.
>>>=20
>>> Most other callers seem ok but kvm_mmu_topup_memory_cache looks like =
it
>>> might be affected by the same breakage, so Cc kvm@.
>>>=20
>>> Reported-by: Martin Zaharinov <micron10@gmail.com>
>>> Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for =
kvmalloc")
>>> Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: kvm@vger.kernel.org
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>=20
>> Please continue in the original email thread until we sort out the =
most
>> reasonable solution for this.
>=20
> I've submitted a v2 using Michals proposed fix for kvmalloc api, if
> thats merged no fixes are required in the callers, so this rhashtable
> patch can be discarded.

