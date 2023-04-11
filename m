Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8D6DD7FC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDKKee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKKed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D780E54
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681209225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4cei96wO/T2C4Lpc30M3t/bBIzgP+CrtXfnGlNvvb60=;
        b=MKDR4Lyupjp74AtuMGjh7bASLqEUDfIcIxtdvLUFQ9H9ufpFYX42jOGjZ32daX+D7RXK5n
        5RahrI+8YJpUdBrb4Bd0p6HU1026Xn+y95s5pnVaGz4vMbBGZ7VaZ+Ttna9dhn+K5hW2Jg
        oShDievdwoaW2H1sN+UlYzPGwPfowKY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-_eh-8-uzN1qDQ2-P7eu8Aw-1; Tue, 11 Apr 2023 06:33:44 -0400
X-MC-Unique: _eh-8-uzN1qDQ2-P7eu8Aw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-5e8ebec3e31so3547016d6.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681209223;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cei96wO/T2C4Lpc30M3t/bBIzgP+CrtXfnGlNvvb60=;
        b=YXFzzvpti0QHyyAFp+kYx1NufUoVVyCfwnZo96OmP4OFDxWXL2DZ5QL9lAeEMFru9b
         xJGUfLXMImYAu7bmZSNneUNaA7AnjRfJr4a+GBphruhQF9iQR5JHqqS4oZM33Bd8qnXx
         oyOLUbEkfaxOI3dg7VuhsQUmviOF3JUSRKwB8X+svf6jm1SI0ZPvapiHVxuSjW4s8u8g
         FZjEAh+fYJMy/FpQ87k5KnieeL4eat2vM0gBAqDT/YX1b6ixTaXsEr06pFPBaxb0tkKp
         0iC1h+B3KWSXkwFkgHGxKA4KntO18o1y7Vrr6hlQhaIt+09RI5QQslCwfyxAJVvqwkD0
         KgtA==
X-Gm-Message-State: AAQBX9fkkU3tyBmEN1FxRI8Ll0D+UPc7qdUvFD2oSDXBwZzRYp386Jw9
        +OsmfCp9n9qUINjXDNI4014aH3Fi6jUfeNNakw1WHaj6oCdRafQQTfUQ4lPHbg6mrgP4HMq6MlL
        TeOczC8zy8BvbxhEFjHB24vkc
X-Received: by 2002:a05:6214:4104:b0:5e8:e227:982e with SMTP id kc4-20020a056214410400b005e8e227982emr17520994qvb.3.1681209223478;
        Tue, 11 Apr 2023 03:33:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350aw7m27qAAlpX1G8dRUN/JPBxGgDJWYnVsBfo/L3vQ8sjJVaq1HS8XCDhMBN/ZzlyCot2FOGg==
X-Received: by 2002:a05:6214:4104:b0:5e8:e227:982e with SMTP id kc4-20020a056214410400b005e8e227982emr17520976qvb.3.1681209223205;
        Tue, 11 Apr 2023 03:33:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id qd13-20020ad4480d000000b005eac9c00bd5sm1773956qvb.34.2023.04.11.03.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 03:33:42 -0700 (PDT)
Message-ID: <d327e582ff04cc01a39498d3eac8d16f23c5f6bf.camel@redhat.com>
Subject: Re: [PATCH] net/sched: sch_qfq: prevent slab-out-of-bounds in
 qfq_activate_agg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gwangun Jung <exsociety@gmail.com>, jhs@mojatatu.com
Cc:     netdev@vger.kernel.org
Date:   Tue, 11 Apr 2023 12:33:40 +0200
In-Reply-To: <ZC+Kgc7feqYy/Gdw@pr0lnx>
References: <ZC+Kgc7feqYy/Gdw@pr0lnx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2023-04-07 at 12:14 +0900, Gwangun Jung wrote:
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

The patch LGTM, but you need to include a suitable Fixes tag. Please
send a v2 with such info and specifying in the subject the target tree
(net, in this case).

Thanks!

Paolo

