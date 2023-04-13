Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A86E0B78
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjDMKgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDMKgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:36:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0467359D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:35:58 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m18so14445231plx.5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681382158; x=1683974158;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KePGVlgo6IBu/hrPfgfTfyOWB7RqndAFAPAfPdN9C5I=;
        b=bcL3rlrPlBu6xSGo2mYtv8WfYqM8pK1/oeozFwbWhvzF3aYHhN9A/zlA9z548a126Y
         yqbS/iVOtvSYkVu6zf4umyJZDil5sgZoH5GFo8CHMenps42EM9a9BPsEKMPcc1T51+pe
         C6rmCx6y1rTN8hbkVmy8nqcFh4D8iaVx9p0pQuaHSnK/7iro33s640smkeOY/MqMOE51
         J6e6JQIdf3++4GfdGi7+y69IhdYwnDuFGyBdd5FjS9+ajGNUIhv1okqLACIkXdu9eVqp
         0/B5nQbHQT6hvzy/p90eX+zQN2AeXzUr87+FRjS7HO6tNktItO7NJoZ06ZzRQZj/rMhj
         c6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681382158; x=1683974158;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KePGVlgo6IBu/hrPfgfTfyOWB7RqndAFAPAfPdN9C5I=;
        b=XKCm3LNcTF2HUTlqe/qx5bjDTIJ7SP8utykTuX9OSCHXSJm2enuzfanrpqg7t1AQ4X
         P+l69DhYuIB+aI1QUEF2lRzVNn3DevWzNi1p+4/d+uAsLVCP3EU+wtrLigHGDNILCyUi
         VIpy9FMp3Q4FnWKvxT9KeN+yrVSPDnygZ9YMX6LSFGBSJptnGSu8LU3Cet2Nj84caD/N
         NNl6Fy2bSzbbSFrua5AGPezyoKIcldJNsfoUvXGd0wJSdqrDlHlrX/SLEZYkG0JIrlH/
         1KRoHh7+uPolB/qGaXMCeLPaMUbkDIVx0Nj0sMvVs5R3GABSLx9HGAdnm5xwdODua+vC
         dm/g==
X-Gm-Message-State: AAQBX9e89GMqaz3VxmFyR78Bl1K7nN0RnGWThEcUz4fl13mQUVbnLmAH
        kwVFiodZyZuT4pWXVczleBw=
X-Google-Smtp-Source: AKy350YC5VY8d5DvvxVA0DMznPWtVoaBezXOu49P9JtyvGe0FGaRLJRvZ6mpeCDYGFc+l1hCvr1vwQ==
X-Received: by 2002:a05:6a20:394c:b0:e9:4683:284a with SMTP id r12-20020a056a20394c00b000e94683284amr7954685pzg.4.1681382157960;
        Thu, 13 Apr 2023 03:35:57 -0700 (PDT)
Received: from pr0lnx ([121.133.63.188])
        by smtp.gmail.com with ESMTPSA id 142-20020a630494000000b00513955cc174sm1129255pge.47.2023.04.13.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 03:35:57 -0700 (PDT)
Date:   Thu, 13 Apr 2023 19:35:54 +0900
From:   Gwangun Jung <exsociety@gmail.com>
To:     pabeni@redhat.com
Cc:     jhs@mojatatu.com, netdev@vger.kernel.org, exsociety@gmail.com
Subject: [PATCH net v3] net: sched: sch_qfq: prevent slab-out-of-bounds in
 qfq_activate_agg
Message-ID: <ZDfbCsDa6oLKzsed@pr0lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the TCA_QFQ_LMAX value is not offered through nlattr, lmax is determined by the MTU value of the network device.
The MTU of the loopback device can be set up to 2^31-1.
As a result, it is possible to have an lmax value that exceeds QFQ_MIN_LMAX.

Due to the invalid lmax value, an index is generated that exceeds the QFQ_MAX_INDEX(=24) value, causing out-of-bounds read/write errors.

The following reports a oob access:

[   84.582666] BUG: KASAN: slab-out-of-bounds in qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
[   84.583267] Read of size 4 at addr ffff88810f676948 by task ping/301
[   84.583686]
[   84.583797] CPU: 3 PID: 301 Comm: ping Not tainted 6.3.0-rc5 #1
[   84.584164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   84.584644] Call Trace:
[   84.584787]  <TASK>
[   84.584906] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
[   84.585108] print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
[   84.585570] kasan_report (mm/kasan/report.c:538)
[   84.585988] qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
[   84.586599] qfq_enqueue (net/sched/sch_qfq.c:1255)
[   84.587607] dev_qdisc_enqueue (net/core/dev.c:3776)
[   84.587749] __dev_queue_xmit (./include/net/sch_generic.h:186 net/core/dev.c:3865 net/core/dev.c:4212)
[   84.588763] ip_finish_output2 (./include/net/neighbour.h:546 net/ipv4/ip_output.c:228)
[   84.589460] ip_output (net/ipv4/ip_output.c:430)
[   84.590132] ip_push_pending_frames (./include/net/dst.h:444 net/ipv4/ip_output.c:126 net/ipv4/ip_output.c:1586 net/ipv4/ip_output.c:1606)
[   84.590285] raw_sendmsg (net/ipv4/raw.c:649)
[   84.591960] sock_sendmsg (net/socket.c:724 net/socket.c:747)
[   84.592084] __sys_sendto (net/socket.c:2142)
[   84.593306] __x64_sys_sendto (net/socket.c:2150)
[   84.593779] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[   84.593902] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[   84.594070] RIP: 0033:0x7fe568032066
[   84.594192] Code: 0e 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c09[ 84.594796] RSP: 002b:00007ffce388b4e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c

Code starting with the faulting instruction
===========================================
[   84.595047] RAX: ffffffffffffffda RBX: 00007ffce388cc70 RCX: 00007fe568032066
[   84.595281] RDX: 0000000000000040 RSI: 00005605fdad6d10 RDI: 0000000000000003
[   84.595515] RBP: 00005605fdad6d10 R08: 00007ffce388eeec R09: 0000000000000010
[   84.595749] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
[   84.595984] R13: 00007ffce388cc30 R14: 00007ffce388b4f0 R15: 0000001d00000001
[   84.596218]  </TASK>
[   84.596295]
[   84.596351] Allocated by task 291:
[   84.596467] kasan_save_stack (mm/kasan/common.c:46)
[   84.596597] kasan_set_track (mm/kasan/common.c:52)
[   84.596725] __kasan_kmalloc (mm/kasan/common.c:384)
[   84.596852] __kmalloc_node (./include/linux/kasan.h:196 mm/slab_common.c:967 mm/slab_common.c:974)
[   84.596979] qdisc_alloc (./include/linux/slab.h:610 ./include/linux/slab.h:731 net/sched/sch_generic.c:938)
[   84.597100] qdisc_create (net/sched/sch_api.c:1244)
[   84.597222] tc_modify_qdisc (net/sched/sch_api.c:1680)
[   84.597357] rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
[   84.597495] netlink_rcv_skb (net/netlink/af_netlink.c:2574)
[   84.597627] netlink_unicast (net/netlink/af_netlink.c:1340 net/netlink/af_netlink.c:1365)
[   84.597759] netlink_sendmsg (net/netlink/af_netlink.c:1942)
[   84.597891] sock_sendmsg (net/socket.c:724 net/socket.c:747)
[   84.598016] ____sys_sendmsg (net/socket.c:2501)
[   84.598147] ___sys_sendmsg (net/socket.c:2557)
[   84.598275] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:2586)
[   84.598399] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[   84.598520] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[   84.598688]
[   84.598744] The buggy address belongs to the object at ffff88810f674000
[   84.598744]  which belongs to the cache kmalloc-8k of size 8192
[   84.599135] The buggy address is located 2664 bytes to the right of
[   84.599135]  allocated 7904-byte region [ffff88810f674000, ffff88810f675ee0)
[   84.599544]
[   84.599598] The buggy address belongs to the physical page:
[   84.599777] page:00000000e638567f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10f670
[   84.600074] head:00000000e638567f order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   84.600330] flags: 0x200000000010200(slab|head|node=0|zone=2)
[   84.600517] raw: 0200000000010200 ffff888100043180 dead000000000122 0000000000000000
[   84.600764] raw: 0000000000000000 0000000080020002 00000001ffffffff 0000000000000000
[   84.601009] page dumped because: kasan: bad access detected
[   84.601187]
[   84.601241] Memory state around the buggy address:
[   84.601396]  ffff88810f676800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.601620]  ffff88810f676880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.601845] >ffff88810f676900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602069]                                               ^
[   84.602243]  ffff88810f676980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602468]  ffff88810f676a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602693] ==================================================================
[   84.602924] Disabling lock debugging due to kernel taint

Fixes: 3015f3d2a3cd ("pkt_sched: enable QFQ to support TSO/GSO")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: Gwangun Jung <exsociety@gmail.com>
---
 net/sched/sch_qfq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index cf5ebe43b3b4..02098a02943e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -421,15 +421,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	} else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
+	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
+		pr_notice("qfq: invalid max length %u\n", lmax);
+		return -EINVAL;
+	}
+
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
-- 
2.34.1

