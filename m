Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBA32D9F9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbhCDTFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:05:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237033AbhCDTFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 14:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614884628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OXdDzBc80btNZRQxO9G9vwAqzKclWBAcF6GgkGrm6Mc=;
        b=aiKZsZx+ggPhLlmo+94K4OTpl7IodsKPyXUF5XRwLc8eorsIKZeDKFVZTu0VDEHo8Wonhx
        Tzy8R5IBs6qXfHDReVQWqfW+rMOBY3VnaidDZMY9XRnwFDyp3kzyAtaMSMOuhM4VhjAW1H
        Ct4xjCBq04czdTNmfnJv524L3HENK78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-AGPTzdMTPP2cM2XvlODfdA-1; Thu, 04 Mar 2021 14:03:42 -0500
X-MC-Unique: AGPTzdMTPP2cM2XvlODfdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE815108BD06;
        Thu,  4 Mar 2021 19:03:40 +0000 (UTC)
Received: from krava (unknown [10.40.196.20])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4A4A55B4A9;
        Thu,  4 Mar 2021 19:03:34 +0000 (UTC)
Date:   Thu, 4 Mar 2021 20:03:33 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roman Gushchin <guro@fb.com>, YiFei Zhu <zhuyifei@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>
Subject: [BUG] hitting bug when running spinlock test
Message-ID: <YEEvBUiJl2pJkxTd@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
I'm getting attached BUG/crash when running in parralel selftests, like:

  while :; do ./test_progs -t spinlock; done
  while :; do ./test_progs ; done

it's the latest bpf-next/master, I can send the .config if needed,
but I don't think there's anything special about it, because I saw
the bug on other servers with different generic configs

it looks like it's related to cgroup local storage, for some reason
the storage deref returns NULL

I'm bit lost in this code, so any help would be great ;-)

thanks,
jirka


---
...
[  382.324440] bpf_testmod: loading out-of-tree module taints kernel.
[  382.330670] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
[  480.391667] perf: interrupt took too long (2540 > 2500), lowering kernel.perf_event_max_sample_rate to 78000
[  480.401730] perf: interrupt took too long (6860 > 6751), lowering kernel.perf_event_max_sample_rate to 29000
[  480.416172] perf: interrupt took too long (8602 > 8575), lowering kernel.perf_event_max_sample_rate to 23000
[  480.433053] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  480.440014] #PF: supervisor read access in kernel mode
[  480.445153] #PF: error_code(0x0000) - not-present page
[  480.450294] PGD 8000000133a18067 P4D 8000000133a18067 PUD 10c019067 PMD 0 
[  480.457164] Oops: 0000 [#1] PREEMPT SMP PTI
[  480.461350] CPU: 6 PID: 16689 Comm: test_progs Tainted: G          IOE     5.11.0+ #11
[  480.469263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 12/14/2018
[  480.476742] RIP: 0010:bpf_get_local_storage+0x13/0x50
[  480.481797] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
[  480.500540] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
[  480.505766] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
[  480.512901] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
[  480.520034] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
[  480.527164] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
[  480.534299] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
[  480.541430] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
[  480.549515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  480.555262] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
[  480.562395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  480.569527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  480.576660] PKRU: 55555554
[  480.579372] Call Trace:
[  480.581829]  ? bpf_prog_c48154a736e5c014_bpf_sping_lock_test+0x2ba/0x860
[  480.588526]  bpf_test_run+0x127/0x2b0
[  480.592192]  ? __build_skb_around+0xb0/0xc0
[  480.596378]  bpf_prog_test_run_skb+0x32f/0x6b0
[  480.600824]  __do_sys_bpf+0xa94/0x2240
[  480.604577]  ? debug_smp_processor_id+0x17/0x20
[  480.609107]  ? __perf_event_task_sched_in+0x32/0x340
[  480.614077]  __x64_sys_bpf+0x1a/0x20
[  480.617653]  do_syscall_64+0x38/0x50
[  480.621233]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  480.626286] RIP: 0033:0x7f8f2467f55d
[  480.629865] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d eb 78 0c 00 f7 d8 64 89 018
[  480.648611] RSP: 002b:00007f8f2357ad58 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
[  480.656175] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f2467f55d
[  480.663308] RDX: 0000000000000078 RSI: 00007f8f2357ad60 RDI: 000000000000000a
[  480.670442] RBP: 00007f8f2357ae28 R08: 0000000000000000 R09: 0000000000000008
[  480.677574] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f8f2357ae2c
[  480.684707] R13: 00000000022df420 R14: 0000000000000000 R15: 00007f8f2357b640
[  480.691842] Modules linked in: bpf_testmod(OE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif irqbypass rapl intel_cstate dell_smbios intel_uncore mei_]
[  480.739134] CR2: 0000000000000000
[  480.742452] ---[ end trace 807177cbb5e3b3da ]---
[  480.752174] RIP: 0010:bpf_get_local_storage+0x13/0x50
[  480.757230] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
[  480.775976] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
[  480.781202] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
[  480.788335] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
[  480.795466] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
[  480.802598] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
[  480.809730] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
[  480.816865] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
[  480.824951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  480.830695] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
[  480.837829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  480.844961] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  480.852093] PKRU: 55555554

