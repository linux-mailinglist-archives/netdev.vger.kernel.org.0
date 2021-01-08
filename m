Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582102EEA42
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbhAHATg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:19:36 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:50014 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbhAHATg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:19:36 -0500
Received: from [192.168.254.6] (unknown [50.46.152.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1AD8F13C2B3
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:17:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1AD8F13C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1610065047;
        bh=o3joCyfnDrTllgvYDMVRMjj/62to+RMWTMPZbkUZ9rY=;
        h=To:From:Subject:Date:From;
        b=bDiEDBouFmxgEhBlrT6P8PFrys2JQUEWoPKQK9KBoxeLA31nILUnO6jHRq4pzGchL
         Eex/q4m3QWvl8i1q1ld8em50LpHXzc5hN5oMRfawIs6eqYbB7AGm9A4Z4TDt+ie9FT
         aw9EImrc09dF6XoBc1uTFex6ZojiIa9XqDWz4kY8=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: 5.10.4+ hang with 'rmmod nf_conntrack'
Organization: Candela Technologies
Message-ID: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
Date:   Thu, 7 Jan 2021 16:17:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed my system has a hung process trying to 'rmmod nf_conntrack'.

I've generally been doing the script that calls rmmod forever,
but only extensively tested on 5.4 kernel and earlier.

If anyone has any ideas, please let me know.  This is from 'sysrq t'.  I don't see
any hung-task splats in dmesg.  I'll see if it is reproducible and if so will try
with lockdep enabled...

21497 Jan 07 16:12:05 TR-398 kernel: task:rmmod           state:R  running task     stack:    0 pid: 4107 ppid:  4054 flags:0x00004084
21498 Jan 07 16:12:05 TR-398 kernel: Call Trace:
21499 Jan 07 16:12:05 TR-398 kernel:  ? do_softirq_own_stack+0x32/0x40
21500 Jan 07 16:12:05 TR-398 kernel:  ? irq_exit_rcu+0x39/0x90
21501 Jan 07 16:12:05 TR-398 kernel:  ? sysvec_apic_timer_interrupt+0x34/0x80
21502 Jan 07 16:12:05 TR-398 kernel:  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
21503 Jan 07 16:12:05 TR-398 kernel:  ? nf_conntrack_attach+0x30/0x30 [nf_conntrack]
21504 Jan 07 16:12:05 TR-398 kernel:  ? _raw_spin_lock+0x12/0x20
21505 Jan 07 16:12:05 TR-398 kernel:  ? do_softirq_own_stack+0x32/0x40
21506 Jan 07 16:12:05 TR-398 kernel:  ? nf_conntrack_lock+0x9/0x40 [nf_conntrack]
21507 Jan 07 16:12:05 TR-398 kernel:  ? nf_ct_iterate_cleanup+0x88/0x140 [nf_conntrack]
21508 Jan 07 16:12:05 TR-398 kernel:  ? nf_conntrack_cleanup_net_list+0x36/0xc0 [nf_conntrack]
21509 Jan 07 16:12:05 TR-398 kernel:  ? unregister_pernet_operations+0xcc/0x130
21510 Jan 07 16:12:05 TR-398 kernel:  ? unregister_pernet_subsys+0x18/0x30
21511 Jan 07 16:12:05 TR-398 kernel:  ? nf_conntrack_standalone_fini+0x11/0x425 [nf_conntrack]
21512 Jan 07 16:12:05 TR-398 kernel:  ? __x64_sys_delete_module+0x131/0x270
21513 Jan 07 16:12:05 TR-398 kernel:  ? syscall_trace_enter.isra.21+0xf9/0x190
21514 Jan 07 16:12:05 TR-398 kernel:  ? do_syscall_64+0x2d/0x70
21515 Jan 07 16:12:05 TR-398 kernel:  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
