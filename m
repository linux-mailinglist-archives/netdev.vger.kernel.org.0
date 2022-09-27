Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C35EC902
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiI0QHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiI0QH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:07:26 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7CE1C7724;
        Tue, 27 Sep 2022 09:05:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z13so21718829ejp.6;
        Tue, 27 Sep 2022 09:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=hur60TA3vBzsSCEH1ei3xONSXo86HYaAOAalhr3WfXU=;
        b=fBd6XvVnT6LLMYN44XhzTPzxkNY9JjSjGd6hMrIedVI2EJ0gTQ0npfpyWAPT+Ft5w1
         ozOCH+fjkMvz87ZjJttEIaKdhQ/rPNoT7cRzaDl7NV+cvPcYn9E39NdFoAxVxIFVwSUq
         GGxQHyPBdpul/qV37Y/LqMt531UxG/lu8begrodiXcsuqby3RMQzn+pGCzlitqS+WBrt
         KnTu2Y6MVeftA9agH6AW8PldF22mooNt20AnZqWTSI+kdrovhJG/7EztX0iVNqABrRu/
         EW2IEwEPnU6DCPyOn4Rj9V949o76mpLyvuJTpwn8PNCsAZfaffn4y8qIjLxD8uKEEQJR
         h4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hur60TA3vBzsSCEH1ei3xONSXo86HYaAOAalhr3WfXU=;
        b=M4Sd7/PVb8I0ftDKcRhU7fdWRrAeq8XRBWopVdDIISxV2RlC1QEGRsl7Gp2rzyHjuQ
         dIDS+VYty9bBjeB5hjxMAqBU3FkAAvoDK9N+9Uu+HWEmwP8X51rVRS2ecsL+MPsNl9aV
         FxE627xKObzWmko1pJBXYpJVzeIo0e50OTFxByo0Z7NFqlTN8kqarCk/sfDzkb8c4040
         c06fdKbR8a5dDknVWHWoi1adigk48F0Dp7aD0wgQJKw8+BX+W1PKkj9XAgNTCsXhgbhf
         M1SAmertgH3NKAwZDV/E02Hnn39bTQr5D6IBGrxCeDkq7mkJt87ed2ZQ7fTm593n4E8/
         0JYQ==
X-Gm-Message-State: ACrzQf1RxaerKBMedTxNiQSJRl0UbHQfeOhmKISmHaEbp4rahe4iSo79
        jZD/W4mg1iCeTvWHQvNGYuA=
X-Google-Smtp-Source: AMsMyM6uVbIXhZhSaEri9jUq0C6Dbw2qkXge6Z7XXpdPPtYMfxKbyVCGxaXkjTUtrl4J/VVwFuZERQ==
X-Received: by 2002:a17:907:1dcc:b0:77a:c5f3:708b with SMTP id og12-20020a1709071dcc00b0077ac5f3708bmr23659349ejc.331.1664294747437;
        Tue, 27 Sep 2022 09:05:47 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id e19-20020a170906081300b0073cdeedf56fsm986569ejd.57.2022.09.27.09.05.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 09:05:46 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <D304A05C-D535-43D0-AC70-D5943CE66D89@gmail.com>
Date:   Tue, 27 Sep 2022 19:05:44 +0300
Cc:     Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>,
        tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, david.switzer@intel.com,
        Intel-wired-lan@osuosl.org, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <43A13D50-9CD8-41A5-A355-B361DE277D93@gmail.com>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFp4H/rbdov7iDg@dhcp22.suse.cz> <20220926151939.GG12777@breakpoint.cc>
 <D304A05C-D535-43D0-AC70-D5943CE66D89@gmail.com>
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

And one more from last min
this is with kernel 5.19.11=20
super simple rull is added=20


Sep 27 17:44:21 [ 1735.081099][T89195] rcu: INFO: rcu_sched detected =
expedited stalls on CPUs/tasks: { 8-... } 2159 jiffies s: 16725 root: =
0x1/.
Sep 27 17:44:21 [ 1735.083787][T89195] rcu: blocking rcu_node structures =
(internal RCU debug): l=3D1:0-13:0x100/.
Sep 27 17:44:21 [ 1735.085608][T89195] Task dump for CPU 8:
Sep 27 17:44:21 [ 1735.087666][T89195] task:kresd           state:R  =
running task     stack:    0 pid: 1464 ppid:  1456 flags:0x00000008
Sep 27 17:44:21 [ 1735.090542][T89195] Call Trace:
Sep 27 17:44:21 [ 1735.091502][T89195]  <TASK>
Sep 27 17:44:21 [ 1735.091887][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:44:21 [ 1735.092660][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:44:21 [ 1735.093432][T89195]  ? nf_hook_slow+0x36/0xa0
Sep 27 17:44:21 [ 1735.094034][T89195]  ? ip_output+0xa3/0xc0
Sep 27 17:44:21 [ 1735.094598][T89195]  ? lookup+0x64/0xf0
Sep 27 17:44:21 [ 1735.095125][T89195]  ? ip_output+0xc0/0xc0
Sep 27 17:44:21 [ 1735.095686][T89195]  ? =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:44:21 [ 1735.096476][T89195]  ? process_backlog+0x7c/0x110
Sep 27 17:44:21 [ 1735.097122][T89195]  ? __napi_poll+0x20/0x100
Sep 27 17:44:21 [ 1735.097720][T89195]  ? net_rx_action+0x26d/0x330
Sep 27 17:44:21 [ 1735.098354][T89195]  ? __do_softirq+0xaf/0x1d7
Sep 27 17:44:21 [ 1735.098963][T89195]  ? __irq_exit_rcu+0x9a/0xd0
Sep 27 17:44:21 [ 1735.099586][T89195]  ? =
sysvec_call_function_single+0x32/0x80
Sep 27 17:44:21 [ 1735.100362][T89195]  ? =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:44:21 [ 1735.101194][T89195]  </TASK>
Sep 27 17:44:57 [ 1771.191089][    C8] rcu: INFO: rcu_sched =
self-detected stall on CPU
Sep 27 17:44:57 [ 1771.191955][    C8] rcu: 	8-....: (1 GPs behind) =
idle=3D915/1/0x4000000000000000 softirq=3D176180/176181 fqs=3D2489
Sep 27 17:44:57 [ 1771.193321][    C8] 	(t=3D6001 jiffies g=3D178373 =
q=3D403611 ncpus=3D28)
Sep 27 17:44:57 [ 1771.194141][    C8] NMI backtrace for cpu 8
Sep 27 17:44:57 [ 1771.194709][    C8] CPU: 8 PID: 1464 Comm: kresd =
Tainted: G           O      5.19.11 #1
Sep 27 17:44:57 [ 1771.195799][    C8] Hardware name: Supermicro Super =
Server/X10SRD-F, BIOS 3.3 10/28/2020
Sep 27 17:44:57 [ 1771.196901][    C8] Call Trace:
Sep 27 17:44:57 [ 1771.197330][    C8]  <IRQ>
Sep 27 17:44:57 [ 1771.197697][    C8]  dump_stack_lvl+0x33/0x42
Sep 27 17:44:57 [ 1771.198297][    C8]  nmi_cpu_backtrace.cold+0x32/0x75
Sep 27 17:44:57 [ 1771.198988][    C8]  ? lapic_can_unplug_cpu+0x60/0x60
Sep 27 17:44:57 [ 1771.199679][    C8]  =
nmi_trigger_cpumask_backtrace+0xf3/0x100
Sep 27 17:44:57 [ 1771.200465][    C8]  =
trigger_single_cpu_backtrace+0x2a/0x2d
Sep 27 17:44:57 [ 1771.201226][    C8]  rcu_dump_cpu_stacks+0x9a/0xd3
Sep 27 17:44:57 [ 1771.201879][    C8]  print_cpu_stall.cold+0xd0/0x1f8
Sep 27 17:44:57 [ 1771.202556][    C8]  check_cpu_stall+0xc7/0x1e0
Sep 27 17:44:57 [ 1771.203174][    C8]  rcu_sched_clock_irq+0x16c/0x2c0
Sep 27 17:44:57 [ 1771.203851][    C8]  update_process_times+0x56/0x90
Sep 27 17:44:57 [ 1771.204520][    C8]  tick_sched_timer+0x69/0xa0
Sep 27 17:44:57 [ 1771.205139][    C8]  ? tick_sched_do_timer+0xa0/0xa0
Sep 27 17:44:57 [ 1771.205815][    C8]  __hrtimer_run_queues+0xff/0x1a0
Sep 27 17:44:57 [ 1771.206492][    C8]  hrtimer_interrupt+0xee/0x200
Sep 27 17:44:57 [ 1771.207132][    C8]  =
__sysvec_apic_timer_interrupt+0x47/0x60
Sep 27 17:44:57 [ 1771.232875][    C8]  =
sysvec_apic_timer_interrupt+0x61/0x80
Sep 27 17:44:57 [ 1771.258765][    C8]  </IRQ>
Sep 27 17:44:57 [ 1771.284425][    C8]  <TASK>
Sep 27 17:44:57 [ 1771.308866][    C8]  =
asm_sysvec_apic_timer_interrupt+0x16/0x20
Sep 27 17:44:57 [ 1771.332920][    C8] RIP: =
0010:queued_spin_lock_slowpath+0x41/0x1a0
Sep 27 17:44:57 [ 1771.356563][    C8] Code: 08 0f 92 c1 8b 02 0f b6 c9 =
c1 e1 08 30 e4 09 c8 3d ff 00 00 00 0f 87 f5 00 00 00 85 c0 74 0f 8b 02 =
84 c0 74 09 0f ae e8 8b 02 <84> c0 75 f7 b8 01 00 00 00 66 89 02 c3 8b =
37 b8 00 02 00 00 81 fe
Sep 27 17:44:57 [ 1771.405388][    C8] RSP: 0000:ffffa03dc3e3faf8 =
EFLAGS: 00000202
Sep 27 17:44:57 [ 1771.429444][    C8] RAX: 0000000000000101 RBX: =
ffff9d530e975a48 RCX: 0000000000000000
Sep 27 17:44:57 [ 1771.454289][    C8] RDX: ffff9d5380235d04 RSI: =
0000000000000001 RDI: ffff9d5380235d04
Sep 27 17:44:57 [ 1771.479285][    C8] RBP: ffff9d5380235d04 R08: =
0000000000000056 R09: 0000000000000030
Sep 27 17:44:57 [ 1771.504541][    C8] R10: c3acfae79ca90a0d R11: =
ffffa03dc3e30a0d R12: 0000000064a1ac01
Sep 27 17:44:57 [ 1771.529954][    C8] R13: 0000000000000002 R14: =
0000000000000000 R15: 0000000000000001
Sep 27 17:44:57 [ 1771.555591][    C8]  nf_ct_seqadj_set+0x55/0xd0 =
[nf_conntrack]
Sep 27 17:44:57 [ 1771.581511][    C8]  =
__nf_nat_mangle_tcp_packet+0x102/0x160 [nf_nat]
Sep 27 17:44:57 [ 1771.607825][    C8]  nf_nat_ftp+0x175/0x267 =
[nf_nat_ftp]
Sep 27 17:44:57 [ 1771.634121][    C8]  ? fib_validate_source+0x37/0xd0
Sep 27 17:44:57 [ 1771.660376][    C8]  ? help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:44:57 [ 1771.686819][    C8]  help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:44:58 [ 1771.713440][    C8]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:44:58 [ 1771.740264][    C8]  nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:44:58 [ 1771.767269][    C8]  nf_hook_slow+0x36/0xa0
Sep 27 17:44:58 [ 1771.794059][    C8]  ip_output+0xa3/0xc0
Sep 27 17:44:58 [ 1771.820540][    C8]  ? lookup+0x64/0xf0
Sep 27 17:44:58 [ 1771.846733][    C8]  ? ip_output+0xc0/0xc0
Sep 27 17:44:58 [ 1771.872583][    C8]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:44:58 [ 1771.898175][    C8]  process_backlog+0x7c/0x110
Sep 27 17:44:58 [ 1771.923064][    C8]  __napi_poll+0x20/0x100
Sep 27 17:44:58 [ 1771.947723][    C8]  net_rx_action+0x26d/0x330
Sep 27 17:44:58 [ 1771.972155][    C8]  __do_softirq+0xaf/0x1d7
Sep 27 17:44:58 [ 1771.996127][    C8]  __irq_exit_rcu+0x9a/0xd0
Sep 27 17:44:58 [ 1772.019663][    C8]  =
sysvec_call_function_single+0x32/0x80
Sep 27 17:44:58 [ 1772.043684][    C8]  =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:44:58 [ 1772.067955][    C8] RIP: 0033:0x7fbd49d8d14a
Sep 27 17:44:58 [ 1772.092161][    C8] Code: 7f 44 24 24 89 44 24 20 48 =
89 5c 24 28 c5 fa 7f 44 24 34 c5 fa 7f 44 24 40 48 8b 52 20 48 89 54 24 =
30 48 85 d2 74 2b 48 8b 12 <48> 85 d2 74 23 48 8d 7c 24 20 ff d2 83 f8 =
1f 89 83 80 00 00 00 c5
Sep 27 17:44:58 [ 1772.143922][    C8] RSP: 002b:00007ffdb7a5cdf0 =
EFLAGS: 00000206
Sep 27 17:44:58 [ 1772.170005][    C8] RAX: 0000000000000002 RBX: =
00000000013c4800 RCX: 0000000000439f68
Sep 27 17:44:58 [ 1772.196517][    C8] RDX: 0000000000416130 RSI: =
0000000000000010 RDI: 00007ffdb7a5ce10
Sep 27 17:44:58 [ 1772.223054][    C8] RBP: 000000000000000e R08: =
0000000040ad2a60 R09: 0000000000000000
Sep 27 17:44:58 [ 1772.249734][    C8] R10: 0000000000000013 R11: =
0000000000000000 R12: 00000000013c5360
Sep 27 17:44:58 [ 1772.276290][    C8] R13: 0000000000ff5c40 R14: =
000000000000001c R15: 0000000000000001
Sep 27 17:44:58 [ 1772.302794][    C8]  </TASK>
Sep 27 17:45:26 [ 1800.361125][T89195] rcu: INFO: rcu_sched detected =
expedited stalls on CPUs/tasks: { 8-... } 8687 jiffies s: 16725 root: =
0x1/.
Sep 27 17:45:26 [ 1800.392199][T89195] rcu: blocking rcu_node structures =
(internal RCU debug): l=3D1:0-13:0x100/.
Sep 27 17:45:26 [ 1800.420803][T89195] Task dump for CPU 8:
Sep 27 17:45:26 [ 1800.449235][T89195] task:kresd           state:R  =
running task     stack:    0 pid: 1464 ppid:  1456 flags:0x00000008
Sep 27 17:45:26 [ 1800.478999][T89195] Call Trace:
Sep 27 17:45:26 [ 1800.508083][T89195]  <TASK>
Sep 27 17:45:26 [ 1800.536826][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:45:26 [ 1800.566367][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:45:26 [ 1800.595401][T89195]  ? nf_hook_slow+0x36/0xa0
Sep 27 17:45:26 [ 1800.624112][T89195]  ? ip_output+0xa3/0xc0
Sep 27 17:45:26 [ 1800.652046][T89195]  ? lookup+0x64/0xf0
Sep 27 17:45:26 [ 1800.679181][T89195]  ? ip_output+0xc0/0xc0
Sep 27 17:45:26 [ 1800.705678][T89195]  ? =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:45:27 [ 1800.732226][T89195]  ? process_backlog+0x7c/0x110
Sep 27 17:45:27 [ 1800.758487][T89195]  ? __napi_poll+0x20/0x100
Sep 27 17:45:27 [ 1800.784746][T89195]  ? net_rx_action+0x26d/0x330
Sep 27 17:45:27 [ 1800.810794][T89195]  ? __do_softirq+0xaf/0x1d7
Sep 27 17:45:27 [ 1800.836683][T89195]  ? __irq_exit_rcu+0x9a/0xd0
Sep 27 17:45:27 [ 1800.862119][T89195]  ? =
sysvec_call_function_single+0x32/0x80
Sep 27 17:45:27 [ 1800.887609][T89195]  ? =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:45:27 [ 1800.913054][T89195]  </TASK>
Sep 27 17:46:33 [ 1866.911097][T89195] rcu: INFO: rcu_sched detected =
expedited stalls on CPUs/tasks: { 8-... } 15342 jiffies s: 16725 root: =
0x1/.
Sep 27 17:46:33 [ 1866.965641][T89195] rcu: blocking rcu_node structures =
(internal RCU debug): l=3D1:0-13:0x100/.
Sep 27 17:46:33 [ 1866.994270][T89195] Task dump for CPU 8:
Sep 27 17:46:33 [ 1867.022843][T89195] task:kresd           state:R  =
running task     stack:    0 pid: 1464 ppid:  1456 flags:0x00000008
Sep 27 17:46:33 [ 1867.052481][T89195] Call Trace:
Sep 27 17:46:33 [ 1867.081754][T89195]  <TASK>
Sep 27 17:46:33 [ 1867.111147][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:33 [ 1867.140201][T89195]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:33 [ 1867.168819][T89195]  ? nf_hook_slow+0x36/0xa0
Sep 27 17:46:33 [ 1867.197208][T89195]  ? ip_output+0xa3/0xc0
Sep 27 17:46:33 [ 1867.225489][T89195]  ? lookup+0x64/0xf0
Sep 27 17:46:33 [ 1867.253674][T89195]  ? ip_output+0xc0/0xc0
Sep 27 17:46:33 [ 1867.281801][T89195]  ? =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:46:33 [ 1867.310354][T89195]  ? process_backlog+0x7c/0x110
Sep 27 17:46:33 [ 1867.338751][T89195]  ? __napi_poll+0x20/0x100
Sep 27 17:46:33 [ 1867.366923][T89195]  ? net_rx_action+0x26d/0x330
Sep 27 17:46:33 [ 1867.394906][T89195]  ? __do_softirq+0xaf/0x1d7
Sep 27 17:46:33 [ 1867.422255][T89195]  ? __irq_exit_rcu+0x9a/0xd0
Sep 27 17:46:33 [ 1867.448856][T89195]  ? =
sysvec_call_function_single+0x32/0x80
Sep 27 17:46:33 [ 1867.475125][T89195]  ? =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:46:33 [ 1867.501298][T89195]  </TASK>
Sep 27 17:46:40 [ 1873.721122][    C8] watchdog: BUG: soft lockup - =
CPU#8 stuck for 164s! [kresd:1464]
Sep 27 17:46:40 [ 1873.748081][    C8] Modules linked in: =
nf_conntrack_netlink pppoe pppox ppp_generic slhc nft_nat nft_chain_nat =
nf_tables netconsole coretemp bonding ixgbe mdio_devres libphy mdio i40e =
nf_nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si ipmi_devintf =
ipmi_msghandler rtc_cmos
Sep 27 17:46:40 [ 1873.865737][    C8] CPU: 8 PID: 1464 Comm: kresd =
Tainted: G           O      5.19.11 #1
Sep 27 17:46:40 [ 1873.895359][    C8] Hardware name: Supermicro Super =
Server/X10SRD-F, BIOS 3.3 10/28/2020
Sep 27 17:46:40 [ 1873.924970][    C8] RIP: =
0010:queued_spin_lock_slowpath+0x41/0x1a0
Sep 27 17:46:40 [ 1873.954233][    C8] Code: 08 0f 92 c1 8b 02 0f b6 c9 =
c1 e1 08 30 e4 09 c8 3d ff 00 00 00 0f 87 f5 00 00 00 85 c0 74 0f 8b 02 =
84 c0 74 09 0f ae e8 8b 02 <84> c0 75 f7 b8 01 00 00 00 66 89 02 c3 8b =
37 b8 00 02 00 00 81 fe
Sep 27 17:46:40 [ 1874.014909][    C8] RSP: 0000:ffffa03dc3e3faf8 =
EFLAGS: 00000202
Sep 27 17:46:40 [ 1874.045586][    C8] RAX: 0000000000000101 RBX: =
ffff9d530e975a48 RCX: 0000000000000000
Sep 27 17:46:40 [ 1874.077184][    C8] RDX: ffff9d5380235d04 RSI: =
0000000000000001 RDI: ffff9d5380235d04
Sep 27 17:46:40 [ 1874.108938][    C8] RBP: ffff9d5380235d04 R08: =
0000000000000056 R09: 0000000000000030
Sep 27 17:46:40 [ 1874.140729][    C8] R10: c3acfae79ca90a0d R11: =
ffffa03dc3e30a0d R12: 0000000064a1ac01
Sep 27 17:46:40 [ 1874.172825][    C8] R13: 0000000000000002 R14: =
0000000000000000 R15: 0000000000000001
Sep 27 17:46:40 [ 1874.205141][    C8] FS:  00007fbd49128480(0000) =
GS:ffff9d599f800000(0000) knlGS:0000000000000000
Sep 27 17:46:40 [ 1874.237881][    C8] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Sep 27 17:46:40 [ 1874.270556][    C8] CR2: 00007f4ebef14340 CR3: =
000000010c1d3002 CR4: 00000000003706e0
Sep 27 17:46:40 [ 1874.303788][    C8] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 27 17:46:40 [ 1874.337086][    C8] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 27 17:46:40 [ 1874.370185][    C8] Call Trace:
Sep 27 17:46:40 [ 1874.403088][    C8]  <TASK>
Sep 27 17:46:40 [ 1874.435656][    C8]  nf_ct_seqadj_set+0x55/0xd0 =
[nf_conntrack]
Sep 27 17:46:40 [ 1874.468668][    C8]  =
__nf_nat_mangle_tcp_packet+0x102/0x160 [nf_nat]
Sep 27 17:46:40 [ 1874.501744][    C8]  nf_nat_ftp+0x175/0x267 =
[nf_nat_ftp]
Sep 27 17:46:40 [ 1874.534162][    C8]  ? fib_validate_source+0x37/0xd0
Sep 27 17:46:40 [ 1874.565710][    C8]  ? help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:46:40 [ 1874.596768][    C8]  help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:46:40 [ 1874.627460][    C8]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:40 [ 1874.657731][    C8]  nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:40 [ 1874.687632][    C8]  nf_hook_slow+0x36/0xa0
Sep 27 17:46:41 [ 1874.717588][    C8]  ip_output+0xa3/0xc0
Sep 27 17:46:41 [ 1874.747307][    C8]  ? lookup+0x64/0xf0
Sep 27 17:46:41 [ 1874.777213][    C8]  ? ip_output+0xc0/0xc0
Sep 27 17:46:41 [ 1874.806970][    C8]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:46:41 [ 1874.837154][    C8]  process_backlog+0x7c/0x110
Sep 27 17:46:41 [ 1874.867402][    C8]  __napi_poll+0x20/0x100
Sep 27 17:46:41 [ 1874.897688][    C8]  net_rx_action+0x26d/0x330
Sep 27 17:46:41 [ 1874.927823][    C8]  __do_softirq+0xaf/0x1d7
Sep 27 17:46:41 [ 1874.957806][    C8]  __irq_exit_rcu+0x9a/0xd0
Sep 27 17:46:41 [ 1874.987741][    C8]  =
sysvec_call_function_single+0x32/0x80
Sep 27 17:46:41 [ 1875.017970][    C8]  =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:46:41 [ 1875.048447][    C8] RIP: 0033:0x7fbd49d8d14a
Sep 27 17:46:41 [ 1875.078930][    C8] Code: 7f 44 24 24 89 44 24 20 48 =
89 5c 24 28 c5 fa 7f 44 24 34 c5 fa 7f 44 24 40 48 8b 52 20 48 89 54 24 =
30 48 85 d2 74 2b 48 8b 12 <48> 85 d2 74 23 48 8d 7c 24 20 ff d2 83 f8 =
1f 89 83 80 00 00 00 c5
Sep 27 17:46:41 [ 1875.142896][    C8] RSP: 002b:00007ffdb7a5cdf0 =
EFLAGS: 00000206
Sep 27 17:46:41 [ 1875.175027][    C8] RAX: 0000000000000002 RBX: =
00000000013c4800 RCX: 0000000000439f68
Sep 27 17:46:41 [ 1875.207293][    C8] RDX: 0000000000416130 RSI: =
0000000000000010 RDI: 00007ffdb7a5ce10
Sep 27 17:46:41 [ 1875.238751][    C8] RBP: 000000000000000e R08: =
0000000040ad2a60 R09: 0000000000000000
Sep 27 17:46:41 [ 1875.269189][    C8] R10: 0000000000000013 R11: =
0000000000000000 R12: 00000000013c5360
Sep 27 17:46:41 [ 1875.298480][    C8] R13: 0000000000ff5c40 R14: =
000000000000001c R15: 0000000000000001
Sep 27 17:46:41 [ 1875.326620][    C8]  </TASK>
Sep 27 17:46:41 [ 1875.354008][    C8] Kernel panic - not syncing: =
softlockup: hung tasks
Sep 27 17:46:41 [ 1875.381653][    C8] CPU: 8 PID: 1464 Comm: kresd =
Tainted: G           O L    5.19.11 #1
Sep 27 17:46:41 [ 1875.409432][    C8] Hardware name: Supermicro Super =
Server/X10SRD-F, BIOS 3.3 10/28/2020
Sep 27 17:46:41 [ 1875.437033][    C8] Call Trace:
Sep 27 17:46:41 [ 1875.463682][    C8]  <IRQ>
Sep 27 17:46:41 [ 1875.489514][    C8]  dump_stack_lvl+0x33/0x42
Sep 27 17:46:41 [ 1875.515233][    C8]  panic+0xea/0x24b
Sep 27 17:46:41 [ 1875.540597][    C8]  watchdog_timer_fn.cold+0xc/0x16
Sep 27 17:46:41 [ 1875.566205][    C8]  ? =
lockup_detector_update_enable+0x50/0x50
Sep 27 17:46:41 [ 1875.591890][    C8]  __hrtimer_run_queues+0xff/0x1a0
Sep 27 17:46:41 [ 1875.617527][    C8]  hrtimer_interrupt+0xee/0x200
Sep 27 17:46:41 [ 1875.642734][    C8]  =
__sysvec_apic_timer_interrupt+0x47/0x60
Sep 27 17:46:41 [ 1875.667848][    C8]  =
sysvec_apic_timer_interrupt+0x61/0x80
Sep 27 17:46:41 [ 1875.692727][    C8]  </IRQ>
Sep 27 17:46:42 [ 1875.717341][    C8]  <TASK>
Sep 27 17:46:42 [ 1875.741909][    C8]  =
asm_sysvec_apic_timer_interrupt+0x16/0x20
Sep 27 17:46:42 [ 1875.766680][    C8] RIP: =
0010:queued_spin_lock_slowpath+0x41/0x1a0
Sep 27 17:46:42 [ 1875.791892][    C8] Code: 08 0f 92 c1 8b 02 0f b6 c9 =
c1 e1 08 30 e4 09 c8 3d ff 00 00 00 0f 87 f5 00 00 00 85 c0 74 0f 8b 02 =
84 c0 74 09 0f ae e8 8b 02 <84> c0 75 f7 b8 01 00 00 00 66 89 02 c3 8b =
37 b8 00 02 00 00 81 fe
Sep 27 17:46:42 [ 1875.844741][    C8] RSP: 0000:ffffa03dc3e3faf8 =
EFLAGS: 00000202
Sep 27 17:46:42 [ 1875.871204][    C8] RAX: 0000000000000101 RBX: =
ffff9d530e975a48 RCX: 0000000000000000
Sep 27 17:46:42 [ 1875.898137][    C8] RDX: ffff9d5380235d04 RSI: =
0000000000000001 RDI: ffff9d5380235d04
Sep 27 17:46:42 [ 1875.925237][    C8] RBP: ffff9d5380235d04 R08: =
0000000000000056 R09: 0000000000000030
Sep 27 17:46:42 [ 1875.952188][    C8] R10: c3acfae79ca90a0d R11: =
ffffa03dc3e30a0d R12: 0000000064a1ac01
Sep 27 17:46:42 [ 1875.979203][    C8] R13: 0000000000000002 R14: =
0000000000000000 R15: 0000000000000001
Sep 27 17:46:42 [ 1876.006215][    C8]  nf_ct_seqadj_set+0x55/0xd0 =
[nf_conntrack]
Sep 27 17:46:42 [ 1876.033350][    C8]  =
__nf_nat_mangle_tcp_packet+0x102/0x160 [nf_nat]
Sep 27 17:46:42 [ 1876.060859][    C8]  nf_nat_ftp+0x175/0x267 =
[nf_nat_ftp]
Sep 27 17:46:42 [ 1876.088553][    C8]  ? fib_validate_source+0x37/0xd0
Sep 27 17:46:42 [ 1876.116413][    C8]  ? help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:46:42 [ 1876.144288][    C8]  help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
Sep 27 17:46:42 [ 1876.172144][    C8]  ? nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:42 [ 1876.200192][    C8]  nf_confirm+0x4f/0x110 =
[nf_conntrack]
Sep 27 17:46:42 [ 1876.228400][    C8]  nf_hook_slow+0x36/0xa0
Sep 27 17:46:42 [ 1876.256523][    C8]  ip_output+0xa3/0xc0
Sep 27 17:46:42 [ 1876.284609][    C8]  ? lookup+0x64/0xf0
Sep 27 17:46:42 [ 1876.312480][    C8]  ? ip_output+0xc0/0xc0
Sep 27 17:46:42 [ 1876.340113][    C8]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 27 17:46:42 [ 1876.367905][    C8]  process_backlog+0x7c/0x110
Sep 27 17:46:42 [ 1876.395100][    C8]  __napi_poll+0x20/0x100
Sep 27 17:46:42 [ 1876.421492][    C8]  net_rx_action+0x26d/0x330
Sep 27 17:46:42 [ 1876.447303][    C8]  __do_softirq+0xaf/0x1d7
Sep 27 17:46:42 [ 1876.472769][    C8]  __irq_exit_rcu+0x9a/0xd0
Sep 27 17:46:42 [ 1876.498153][    C8]  =
sysvec_call_function_single+0x32/0x80
Sep 27 17:46:42 [ 1876.523775][    C8]  =
asm_sysvec_call_function_single+0x16/0x20
Sep 27 17:46:42 [ 1876.549695][    C8] RIP: 0033:0x7fbd49d8d14a
Sep 27 17:46:42 [ 1876.575681][    C8] Code: 7f 44 24 24 89 44 24 20 48 =
89 5c 24 28 c5 fa 7f 44 24 34 c5 fa 7f 44 24 40 48 8b 52 20 48 89 54 24 =
30 48 85 d2 74 2b 48 8b 12 <48> 85 d2 74 23 48 8d 7c 24 20 ff d2 83 f8 =
1f 89 83 80 00 00 00 c5
Sep 27 17:46:42 [ 1876.629976][    C8] RSP: 002b:00007ffdb7a5cdf0 =
EFLAGS: 00000206
Sep 27 17:46:42 [ 1876.657077][    C8] RAX: 0000000000000002 RBX: =
00000000013c4800 RCX: 0000000000439f68
Sep 27 17:46:42 [ 1876.684247][    C8] RDX: 0000000000416130 RSI: =
0000000000000010 RDI: 00007ffdb7a5ce10
Sep 27 17:46:43 [ 1876.711049][    C8] RBP: 000000000000000e R08: =
0000000040ad2a60 R09: 0000000000000000
Sep 27 17:46:43 [ 1876.738070][    C8] R10: 0000000000000013 R11: =
0000000000000000 R12: 00000000013c5360
Sep 27 17:46:43 [ 1876.765026][    C8] R13: 0000000000ff5c40 R14: =
000000000000001c R15: 0000000000000001
Sep 27 17:46:43 [ 1876.791891][    C8]  </TASK>
Sep 27 17:46:43 [ 1876.899635][    C8] Kernel Offset: 0x2d000000 from =
0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Sep 27 17:46:43 [ 1876.955793][    C8] Rebooting in 10 seconds..



m.

> On 27 Sep 2022, at 7:44, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Add intel=20
> And one more from last min:
>=20
>=20
> Sep 27 06:28:58 [ 1715.463514][   C28] ------------[ cut here =
]------------
> Sep 27 06:28:58 [ 1715.464245][   C28] NETDEV WATCHDOG: eth0 (i40e): =
transmit queue 0 timed out
> Sep 27 06:28:58 [ 1715.465216][   C28] WARNING: CPU: 28 PID: 0 at =
net/sched/sch_generic.c:529 dev_watchdog+0x167/0x170
> Sep 27 06:28:58 [ 1715.466459][   C28] Modules linked in: nft_limit =
nf_conntrack_netlink pppoe pppox ppp_generic slhc nft_ct nft_nat =
nft_chain_nat team_mode_loadbalance team nf_tables netconsole coretemp =
i40e nf_nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp =
nf_nat_tftp nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si =
ipmi_devintf ipmi_msghandler rtc_cmos [last unloaded: nf_flow_table]
> Sep 27 06:28:58 [ 1715.472099][   C28] CPU: 28 PID: 0 Comm: swapper/28 =
Tainted: G           O      5.19.11 #1
> Sep 27 06:28:58 [ 1715.473225][   C28] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
> Sep 27 06:28:58 [ 1715.474377][   C28] RIP: =
0010:dev_watchdog+0x167/0x170
> Sep 27 06:28:58 [ 1715.475081][   C28] Code: 28 e9 77 ff ff ff 48 89 =
df c6 05 63 57 c4 00 01 e8 de 59 fb ff 48 89 c2 44 89 e1 48 89 de 48 c7 =
c7 08 c7 ec 98 e8 52 c6 13 00 <0f> 0b eb 85 0f 1f 44 00 00 41 55 41 54 =
55 53 48 8b 47 50 4c 8b 28
> Sep 27 06:28:58 [ 1715.477736][   C28] RSP: 0018:ffffa93c806b8ee8 =
EFLAGS: 00010292
> Sep 27 06:28:58 [ 1715.478542][   C28] RAX: 0000000000000038 RBX: =
ffffa01591bb0000 RCX: 0000000000000001
> Sep 27 06:28:58 [ 1715.479608][   C28] RDX: 00000000ffffffea RSI: =
00000000fff7ffff RDI: 00000000fff7ffff
> Sep 27 06:28:58 [ 1715.480674][   C28] RBP: ffffa01591bb03c0 R08: =
0000000000000001 R09: 00000000fff7ffff
> Sep 27 06:28:58 [ 1715.481741][   C28] R10: ffffa01cdae00000 R11: =
0000000000000003 R12: 0000000000000000
> Sep 27 06:28:58 [ 1715.482807][   C28] R13: 0000000000000001 R14: =
ffffa01cdfd207a8 R15: 0000000000000082
> Sep 27 06:28:58 [ 1715.483876][   C28] FS:  0000000000000000(0000) =
GS:ffffa01cdfd00000(0000) knlGS:0000000000000000
> Sep 27 06:28:58 [ 1715.485072][   C28] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
> Sep 27 06:28:58 [ 1715.485949][   C28] CR2: 000000c000c19010 CR3: =
00000001974a4005 CR4: 00000000003706e0
> Sep 27 06:28:58 [ 1715.487018][   C28] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
> Sep 27 06:28:58 [ 1715.488084][   C28] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
> Sep 27 06:28:58 [ 1715.489151][   C28] Call Trace:
> Sep 27 06:28:58 [ 1715.489582][   C28]  <IRQ>
> Sep 27 06:28:58 [ 1715.489949][   C28]  ? pfifo_fast_destroy+0x30/0x30
> Sep 27 06:28:58 [ 1715.490615][   C28]  =
call_timer_fn.constprop.0+0x14/0x70
> Sep 27 06:28:58 [ 1715.491342][   C28]  =
__run_timers.part.0+0x164/0x190
> Sep 27 06:28:58 [ 1715.492019][   C28]  ? ktime_get+0x30/0x90
> Sep 27 06:28:58 [ 1715.492576][   C28]  run_timer_softirq+0x21/0x50
> Sep 27 06:28:58 [ 1715.493204][   C28]  __do_softirq+0xaf/0x1d7
> Sep 27 06:28:58 [ 1715.493788][   C28]  __irq_exit_rcu+0x9a/0xd0
> Sep 27 06:28:58 [ 1715.494383][   C28]  =
sysvec_apic_timer_interrupt+0x66/0x80
> Sep 27 06:28:58 [ 1715.495131][   C28]  </IRQ>
> Sep 27 06:28:58 [ 1715.495509][   C28]  <TASK>
> Sep 27 06:28:58 [ 1715.495887][   C28]  =
asm_sysvec_apic_timer_interrupt+0x16/0x20
> Sep 27 06:28:58 [ 1715.496683][   C28] RIP: =
0010:cpuidle_enter_state+0xb3/0x290
> Sep 27 06:28:58 [ 1715.497455][   C28] Code: e8 12 25 b0 ff 31 ff 49 =
89 c5 e8 c8 80 af ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 cf 01 00 00 31 =
ff e8 c1 cb b3 ff fb 45 85 f6 <0f> 88 d0 00 00 00 49 63 ce 48 6b f1 68 =
48 8b 04 24 4c 89 ea 48 29
> Sep 27 06:28:58 [ 1715.500111][   C28] RSP: 0018:ffffa93c801cfe98 =
EFLAGS: 00000202
> Sep 27 06:28:58 [ 1715.500916][   C28] RAX: ffffa01cdfd26800 RBX: =
ffffa01580bff000 RCX: 000000000000001f
> Sep 27 06:28:58 [ 1715.501983][   C28] RDX: 0000018f6997dcb8 RSI: =
00000000313b13b1 RDI: 0000000000000000
> Sep 27 06:28:58 [ 1715.503050][   C28] RBP: 0000000000000001 R08: =
0000000000000002 R09: ffffa01cdfd25724
> Sep 27 06:28:58 [ 1715.504118][   C28] R10: 0000000000000018 R11: =
000000000000007b R12: ffffffff99222da0
> Sep 27 06:28:58 [ 1715.536292][   C28] R13: 0000018f6997dcb8 R14: =
0000000000000001 R15: 0000000000000000
> Sep 27 06:28:58 [ 1715.568539][   C28]  ? =
cpuidle_enter_state+0x98/0x290
> Sep 27 06:28:58 [ 1715.600850][   C28]  cpuidle_enter+0x24/0x40
> Sep 27 06:28:58 [ 1715.632878][   C28]  cpuidle_idle_call+0xbb/0x100
> Sep 27 06:28:58 [ 1715.664572][   C28]  do_idle+0x76/0xc0
> Sep 27 06:28:58 [ 1715.695803][   C28]  cpu_startup_entry+0x14/0x20
> Sep 27 06:28:58 [ 1715.726582][   C28]  start_secondary+0xd6/0xe0
> Sep 27 06:28:58 [ 1715.756507][   C28]  =
secondary_startup_64_no_verify+0xd3/0xdb
> Sep 27 06:28:58 [ 1715.785770][   C28]  </TASK>
> Sep 27 06:28:58 [ 1715.813710][   C28] ---[ end trace 0000000000000000 =
]---
> Sep 27 06:28:58 [ 1715.840988][   C28] i40e 0000:03:00.0 eth0: =
tx_timeout: VSI_seid: 390, Q 0, NTC: 0x697, HWB: 0x78c, NTU: 0x78c, =
TAIL: 0x78c, INT: 0x0
> Sep 27 06:28:58 [ 1715.896233][   C28] i40e 0000:03:00.0 eth0: =
tx_timeout recovery level 1, txqueue 0
>=20
>=20
>=20
>> On 26 Sep 2022, at 18:19, Florian Westphal <fw@strlen.de> wrote:
>>=20
>> Michal Hocko <mhocko@suse.com> wrote:
>>> On Mon 26-09-22 10:31:39, Florian Westphal wrote:
>>>> Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
>>>> kernel BUG at mm/vmalloc.c:2437!
>>>> invalid opcode: 0000 [#1] SMP
>>>> CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 =
#1
>>>> [..]
>>>> RIP: 0010:__get_vm_area_node+0x120/0x130
>>>> __vmalloc_node_range+0x96/0x1e0
>>>> kvmalloc_node+0x92/0xb0
>>>> bucket_table_alloc.isra.0+0x47/0x140
>>>> rhashtable_try_insert+0x3a4/0x440
>>>> rhashtable_insert_slow+0x1b/0x30
>>>> [..]
>>>>=20
>>>> bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, =
this now
>>>> falls through to vmalloc and hits code paths that assume =
GFP_KERNEL.
>>>>=20
>>>> I sent a patch to restore GFP_ATOMIC support in kvmalloc but mm
>>>> maintainers rejected it.
>>>>=20
>>>> This patch is partial revert of
>>>> commit 93f976b5190d ("lib/rhashtable: simplify =
bucket_table_alloc()"),
>>>> to avoid kvmalloc for ATOMIC case.
>>>>=20
>>>> As kvmalloc doesn't warn when used with ATOMIC, kernel will only =
crash
>>>> once vmalloc fallback occurs, so we may see more crashes in other =
areas
>>>> in the future.
>>>>=20
>>>> Most other callers seem ok but kvm_mmu_topup_memory_cache looks =
like it
>>>> might be affected by the same breakage, so Cc kvm@.
>>>>=20
>>>> Reported-by: Martin Zaharinov <micron10@gmail.com>
>>>> Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for =
kvmalloc")
>>>> Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: kvm@vger.kernel.org
>>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>>=20
>>> Please continue in the original email thread until we sort out the =
most
>>> reasonable solution for this.
>>=20
>> I've submitted a v2 using Michals proposed fix for kvmalloc api, if
>> thats merged no fixes are required in the callers, so this rhashtable
>> patch can be discarded.
>=20

