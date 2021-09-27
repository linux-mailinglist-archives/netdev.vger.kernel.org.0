Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93B41A3D6
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 01:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhI0XhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 19:37:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34284 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238012AbhI0XhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 19:37:09 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2021 19:37:09 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EB4C3229E1E
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 23:30:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.132])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AFEBB2007E
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 23:30:04 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8F096940070
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 23:30:04 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DD42913C2B0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:30:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DD42913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1632785403;
        bh=QIRfqdq9cR2haoxMIDkJfBpDdaTrXIB1HgM9EH06t8o=;
        h=To:From:Subject:Date:From;
        b=pOxWnPgJxUEYQ0Bu9EAChINNKGNd1FQGuZBmrI8hqMsMCEzG4Fk9CS/1TR445tCoU
         tIUeMk7MMHNHnzVInHAZpzx9qJMmZOu9nakg6IrFOmsNVO5wuvGrfLtYQJS7dkf2p/
         C7G3WqCXYcqVIoo4kqV298r/hrTv1saYqLfaVAWU=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: 5.15-rc3+ crash in fq-codel?
Organization: Candela Technologies
Message-ID: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
Date:   Mon, 27 Sep 2021 16:30:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1632785405-mL_Y01xA1NQO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
pktgen so I cannot easily run this test on stock kernels, and there is some chance
some of my hackings have caused this issue.

But, in case others have seen similar, please let me know.  I shall go digging
in the meantime...

Looks to me like 'skb' is NULL in line 120 below.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./net/sched/sch_fq_codel.ko...done.
"/home/greearb/kernel/2.6/linux-5.15.x64/vmlinux" is not a core dump: file format not recognized
(gdb) l *(fq_codel_enqueue+0x24b)
0x76b is in fq_codel_enqueue (/home/greearb/git/linux-5.15.dev.y/net/sched/sch_fq_codel.c:120).
115	/* remove one skb from head of slot queue */
116	static inline struct sk_buff *dequeue_head(struct fq_codel_flow *flow)
117	{
118		struct sk_buff *skb = flow->head;
119	
120		flow->head = skb->next;
121		skb_mark_not_on_list(skb);
122		return skb;
123	}
124	
(gdb)


BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 3 PID: 2077 Comm: kpktgend_3 Not tainted 5.15.0-rc3+ #2
Hardware name: Default string Default string/SKYBAY, BIOS 5.12 02/19/2019
RIP: 0010:fq_codel_enqueue+0x24b/0x380 [sch_fq_codel]
Code: e0 02 48 89 44 24 08 49 c1 e0 06 4c 03 83 50 01 00 00 45 31 f6 45 31 c9 31 c9 89 74 24 10 eb 04 39 fa 73 33 49 8b 00 83 c13
RSP: 0018:ffffc9000030fd10 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88810a78f600 RCX: 0000000000000032
RDX: 00000000000121ca RSI: ffff88812d716900 RDI: 00000000003b26f5
RBP: ffffc9000030fd78 R08: ffff8881311dd340 R09: 00000000000121ca
R10: 000000000000034d R11: 0000000001680900 R12: ffffc9000030fde0
R13: 000000000001b900 R14: 000000000001b900 R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffff888265cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000260f003 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  dev_qdisc_enqueue+0x35/0x90
  __dev_queue_xmit+0x647/0xb70
  macvlan_start_xmit+0x4a/0x110 [macvlan]
  pktgen_thread_worker+0x19fe/0x20ed [pktgen]
  ? wait_woken+0x60/0x60
  ? pktgen_rem_all_ifs+0x70/0x70 [pktgen]
  kthread+0x11e/0x150
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x1f/0x30


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

