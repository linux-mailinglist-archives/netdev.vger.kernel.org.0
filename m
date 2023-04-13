Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041756E099A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjDMJDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMJCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2B58A77
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681376450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPZassmmND4as8Ee3QZUaKONdfHqHZIWeRG0bZD04Hc=;
        b=GOUAY7AncofadWKZ0tNGGE5qfXCUS54igdN9v46JspuczivXtjsZkrP3O4sIos4IVrNpVU
        9l0RyInMvazANiqwKvWZJlHfzK/ixolKJdMKdeVLWqBQdGiY5jZfepwAoNlfXRrMcpJ2ga
        6e755LFv/5Wi8TXcCTbca3/CQv3wUC4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-UFdCJ6mbOe-q-jWKhKn5kw-1; Thu, 13 Apr 2023 05:00:48 -0400
X-MC-Unique: UFdCJ6mbOe-q-jWKhKn5kw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3e699011c0eso1297831cf.0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681376448; x=1683968448;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rPZassmmND4as8Ee3QZUaKONdfHqHZIWeRG0bZD04Hc=;
        b=Wqu8h6gk4jDK78JGvTCAjohdbOEQfR8p+S478dDPksI9xK9hmHgcoHGIxBGm7bQaph
         pR3go0usTkkkFa3yi5Cz8x2wj9gqVFCQNc3i+9+U079wIB+vGO+wFUw1ebZkofYoL5O/
         /nVESk2VT45YU2bQ5wjEWgoWLvOvScRi2GFweb2664V/UIvdnQCdb1LzUSdGA1KBwCIE
         ZCw/wjrAUmzdZSgV/6mw1bEyZFW0qBCgWbfHekimXLjCe0Nc4vqGu/5Vx1orwJxbKQ2u
         LfPyMNkEV2Ut53GwbXB1gz8VAPRhWrk8x2SzFtKbfH8NXUWGDgOxI8kZuwNp1zyuoKl9
         8Mlw==
X-Gm-Message-State: AAQBX9c10CXum7AUO7AJ0TImQd4axTOyQ2zW95/1Xm47wN+yLxKllx5L
        RwunhJkYTMXleJ/ajr87qO31QXueDSNmQp9R02ebPsynbgOBMW5Pl4yE7yAJ/O0OzoU1inpsrB3
        AE8cRu0CsZzxnG8CUwVy+122s
X-Received: by 2002:ac8:5f0c:0:b0:3e6:707e:d3b2 with SMTP id x12-20020ac85f0c000000b003e6707ed3b2mr2166269qta.0.1681376448014;
        Thu, 13 Apr 2023 02:00:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350YH9wOQsLjfDgQLRLVNmWwvfFAMFDDBk0dzNmunfXitmQjbu21LsoYIlsvUU6EK+560cJ5hAQ==
X-Received: by 2002:ac8:5f0c:0:b0:3e6:707e:d3b2 with SMTP id x12-20020ac85f0c000000b003e6707ed3b2mr2166239qta.0.1681376447727;
        Thu, 13 Apr 2023 02:00:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-183.dyn.eolo.it. [146.241.232.183])
        by smtp.gmail.com with ESMTPSA id g3-20020ac81243000000b003ea1b97acfasm141766qtj.49.2023.04.13.02.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 02:00:47 -0700 (PDT)
Message-ID: <2c65147554c04d6e6a8c91fa4e0d953ff60217fe.camel@redhat.com>
Subject: Re: [PATCH net v2] net: sched: sch_qfq: prevent slab-out-of-bounds
 in qfq_activate_agg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gwangun Jung <exsociety@gmail.com>, jhs@mojatatu.com
Cc:     netdev@vger.kernel.org
Date:   Thu, 13 Apr 2023 11:00:45 +0200
In-Reply-To: <ZDU8cmEVHMYZtaSg@pr0lnx>
References: <ZDU8cmEVHMYZtaSg@pr0lnx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2023-04-11 at 19:54 +0900, Gwangun Jung wrote:
> If the TCA_QFQ_LMAX value is not offered through nlattr, lmax is determin=
ed by the MTU value of the network device.
> The MTU of the loopback device can be set up to 2^31-1.
> As a result, it is possible to have an lmax value that exceeds QFQ_MIN_LM=
AX.
>=20
> Due to the invalid lmax value, an index is generated that exceeds the QFQ=
_MAX_INDEX(=3D24) value, causing out-of-bounds read/write errors.
>=20
> The following reports a oob access:
>=20
> [   84.582666] BUG: KASAN: slab-out-of-bounds in qfq_activate_agg.constpr=
op.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c=
:1313)
> [   84.583267] Read of size 4 at addr ffff88810f676948 by task ping/301
> [   84.583686]
> [   84.583797] CPU: 3 PID: 301 Comm: ping Not tainted 6.3.0-rc5 #1
> [   84.584164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.15.0-1 04/01/2014
> [   84.584644] Call Trace:
> [   84.584787]  <TASK>
> [   84.584906] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
> [   84.585108] print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
> [   84.585570] kasan_report (mm/kasan/report.c:538)
> [   84.585988] qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net=
/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
> [   84.586599] qfq_enqueue (net/sched/sch_qfq.c:1255)
> [   84.587607] dev_qdisc_enqueue (net/core/dev.c:3776)
> [   84.587749] __dev_queue_xmit (./include/net/sch_generic.h:186 net/core=
/dev.c:3865 net/core/dev.c:4212)
> [   84.588763] ip_finish_output2 (./include/net/neighbour.h:546 net/ipv4/=
ip_output.c:228)
> [   84.589460] ip_output (net/ipv4/ip_output.c:430)
> [   84.590132] ip_push_pending_frames (./include/net/dst.h:444 net/ipv4/i=
p_output.c:126 net/ipv4/ip_output.c:1586 net/ipv4/ip_output.c:1606)
> [   84.590285] raw_sendmsg (net/ipv4/raw.c:649)
> [   84.591960] sock_sendmsg (net/socket.c:724 net/socket.c:747)
> [   84.592084] __sys_sendto (net/socket.c:2142)
> [   84.593306] __x64_sys_sendto (net/socket.c:2150)
> [   84.593779] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/c=
ommon.c:80)
> [   84.593902] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:=
120)
> [   84.594070] RIP: 0033:0x7fe568032066
> [   84.594192] Code: 0e 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0=
f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c09[ 84.594796] RSP: 002b:00007=
ffce388b4e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   84.595047] RAX: ffffffffffffffda RBX: 00007ffce388cc70 RCX: 00007fe56=
8032066
> [   84.595281] RDX: 0000000000000040 RSI: 00005605fdad6d10 RDI: 000000000=
0000003
> [   84.595515] RBP: 00005605fdad6d10 R08: 00007ffce388eeec R09: 000000000=
0000010
> [   84.595749] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
0000040
> [   84.595984] R13: 00007ffce388cc30 R14: 00007ffce388b4f0 R15: 0000001d0=
0000001
> [   84.596218]  </TASK>
> [   84.596295]
> [   84.596351] Allocated by task 291:
> [   84.596467] kasan_save_stack (mm/kasan/common.c:46)
> [   84.596597] kasan_set_track (mm/kasan/common.c:52)
> [   84.596725] __kasan_kmalloc (mm/kasan/common.c:384)
> [   84.596852] __kmalloc_node (./include/linux/kasan.h:196 mm/slab_common=
.c:967 mm/slab_common.c:974)
> [   84.596979] qdisc_alloc (./include/linux/slab.h:610 ./include/linux/sl=
ab.h:731 net/sched/sch_generic.c:938)
> [   84.597100] qdisc_create (net/sched/sch_api.c:1244)
> [   84.597222] tc_modify_qdisc (net/sched/sch_api.c:1680)
> [   84.597357] rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
> [   84.597495] netlink_rcv_skb (net/netlink/af_netlink.c:2574)
> [   84.597627] netlink_unicast (net/netlink/af_netlink.c:1340 net/netlink=
/af_netlink.c:1365)
> [   84.597759] netlink_sendmsg (net/netlink/af_netlink.c:1942)
> [   84.597891] sock_sendmsg (net/socket.c:724 net/socket.c:747)
> [   84.598016] ____sys_sendmsg (net/socket.c:2501)
> [   84.598147] ___sys_sendmsg (net/socket.c:2557)
> [   84.598275] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:2586=
)
> [   84.598399] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/c=
ommon.c:80)
> [   84.598520] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:=
120)
> [   84.598688]
> [   84.598744] The buggy address belongs to the object at ffff88810f67400=
0
> [   84.598744]  which belongs to the cache kmalloc-8k of size 8192
> [   84.599135] The buggy address is located 2664 bytes to the right of
> [   84.599135]  allocated 7904-byte region [ffff88810f674000, ffff88810f6=
75ee0)
> [   84.599544]
> [   84.599598] The buggy address belongs to the physical page:
> [   84.599777] page:00000000e638567f refcount:1 mapcount:0 mapping:000000=
0000000000 index:0x0 pfn:0x10f670
> [   84.600074] head:00000000e638567f order:3 entire_mapcount:0 nr_pages_m=
apped:0 pincount:0
> [   84.600330] flags: 0x200000000010200(slab|head|node=3D0|zone=3D2)
> [   84.600517] raw: 0200000000010200 ffff888100043180 dead000000000122 00=
00000000000000
> [   84.600764] raw: 0000000000000000 0000000080020002 00000001ffffffff 00=
00000000000000
> [   84.601009] page dumped because: kasan: bad access detected
> [   84.601187]
> [   84.601241] Memory state around the buggy address:
> [   84.601396]  ffff88810f676800: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.601620]  ffff88810f676880: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.601845] >ffff88810f676900: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602069]                                               ^
> [   84.602243]  ffff88810f676980: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602468]  ffff88810f676a00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602693] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   84.602924] Disabling lock debugging due to kernel taint
>=20
> Signed-off-by: Gwangun Jung <exsociety@gmail.com>

The code still LGTM, but the commit message still lacks the fixes tag.
Please investigate which commit introduced the issue addressed here and
repost including the appropriate fixes tag.

Please read carefully the process documentation for the details.

Thanks

Paolo

