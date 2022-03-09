Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1424D2E3A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiCILjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiCILjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:39:06 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394BA46B20
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:38:07 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id w7so3227709lfd.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 03:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=hWuA/BCKrwbECxgkKPDuKn7go+NuLdz9HJVfM+vYFCo=;
        b=KasEXfzo1GKGxWI7PW0vNHq4yReZGdrxtmYHRtqlZtKwgH8O4KOIiUzjeacfHJ6v/k
         glrjN/eLRtSt/fudYqdYopr0/kFt6ZNFmfxTqx/dsP0H1YdkBvx6wqYE12QWl3XZWzFm
         o0L8vgsp0WKrspSu9BrTL6BH88Huk758naQOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hWuA/BCKrwbECxgkKPDuKn7go+NuLdz9HJVfM+vYFCo=;
        b=rzVSAL7yNXng+IxMCtB9gpvWrM/erGRXPLe+hi1GcuhSB4y/bVxWb2PM9eDZy193Dn
         rFKkEzmizjZDLuCbwxq+20cTBaPvTa33hFhG5tPx6+YtfCEtajgE2fWfX8N9RCSZ3OB2
         qxqJ0NQqFgsQdXWEymxJlNu1lddXltyL7XlQyxyEmFZIwXuWFh3QbbfIbzLq8qaQ1iuW
         LezRaw2pHA25pmOxf4G017rAAHbTkVddkCDwL2qvIcrx6HbRx53SJ4Qdm5d8km5TA6uW
         Zn43MS3BCu2q5s+9PmKeJ7htdkKplskectxCfOA7atSG6dZyJmMTT9W+vDSy7XrFLzlb
         s7xg==
X-Gm-Message-State: AOAM533gj70pgzxIIy3NPNTavsH2HuVHWw1sPbez6RQ5is911+leoPur
        NmELkioXMiJfkbFrKlYczTh1L1v1U4f8JOtjkJQJfxyTl5zldg==
X-Google-Smtp-Source: ABdhPJzJs9TAxHpmTdcGQoMKR8Syy7TLGgfWwwynGcHTj8xiZkyxdUczMGLeW7K/MnJwiun1zGdX+ok71ATYHT16D7c=
X-Received: by 2002:a05:6512:33d2:b0:448:3488:3668 with SMTP id
 d18-20020a05651233d200b0044834883668mr7817969lfg.124.1646825885083; Wed, 09
 Mar 2022 03:38:05 -0800 (PST)
MIME-Version: 1.0
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Wed, 9 Mar 2022 11:37:54 +0000
Message-ID: <CABEBQikk7=cL_Y1CYrSig4okjcjzVUU_f051+FHD96qnvSyCYg@mail.gmail.com>
Subject: #GP in fnhe_dump_bucket()
To:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we've had crashes on two of our systems with identical backtraces,

general protection fault, probably for non-canonical address
0x200000001820f0b6: 0000 [#1] SMP NOPTI
CPU: 74 PID: 243831 Comm: conduit-edge Tainted: G           O
5.15.26-cloudflare-2022.3.4 #1
Hardware name: HYVE EDGE-METAL-GEN11/HS1811D_Lite, BIOS V0.07-sig 05/20/2021
RIP: 0010:fib_dump_info_fnhe+0x11c/0x250
Code: 24 28 48 8b 7c 24 28 e8 02 9e ff ff 48 83 c4 20 85 c0 75 79 8b
45 00 83 c0 01 89 45 00 48 8b 1b 48 85 db 74 40 41 39 c4 7f ed <44> 3b
73 08 75 e7 48 8b 53 20 48 85 d2 74 0c 48 8b 0d 2e 0d 1a 01
RSP: 0018:ffffba03f44db9e8 EFLAGS: 00010297
RAX: 0000000000000057 RBX: 200000001820f0ae RCX: 00000001030a5ecf
RDX: 0000000100a2576e RSI: ffffba03f44db908 RDI: 00000000000003e6
RBP: ffffba03f44dba94 R08: 0000000000000000 R09: ffff980fae5630c4
R10: 00000000000003e6 R11: ffff980d106f6368 R12: 0000000000000000
R13: 00000000000003e6 R14: 0000000000000000 R15: ffff980d106f6368
FS:  00007fe58effd700(0000) GS:ffff98179fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdc68503000 CR3: 0000003219c22003 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 <TASK>
 fib_table_dump+0x210/0x300
 inet_dump_fib+0x136/0x270
 rtnl_dump_all+0xaf/0xe0
 netlink_dump+0x168/0x3d0
 ? validate_linkmsg+0x100/0x100
 __netlink_dump_start+0x1c4/0x2a0
 rtnetlink_rcv_msg+0x290/0x380
 ? 0xffffffffc0e460c8
 ? validate_linkmsg+0x100/0x100
 ? rtnl_calcit.isra.0+0x130/0x130
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x1fc/0x2c0
 netlink_sendmsg+0x255/0x4d0
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? call_rcu+0x91/0x250
 ? auditd_test_task+0x33/0x40
 ? __audit_syscall_entry+0xe6/0x110
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x48060a
Code: e8 9b ca fe ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c
8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d
01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c00935efb8 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000c00004b800 RCX: 000000000048060a
RDX: 0000000000000020 RSI: 000000c002f73ac0 RDI: 0000000000000024
RBP: 000000c00935f020 R08: 000000c00487d780 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000000
R13: 0000000000000001 R14: 000000c000438680 R15: ffffffffffffffff
</TASK>

This is actually inlined the fnhe_dump_bucket(),

 static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
                            struct netlink_callback *cb, u32 table_id,
                            struct fnhe_hash_bucket *bucket, int genid,
                            int *fa_index, int fa_start, unsigned int flags)
{
        int i;
        for (i = 0; i < FNHE_HASH_SIZE; i++) {
                struct fib_nh_exception *fnhe;
                for (fnhe = rcu_dereference(bucket[i].chain); fnhe;
                     fnhe = rcu_dereference(fnhe->fnhe_next)) {
                        struct rtable *rt;
                        int err;
                        if (*fa_index < fa_start)
                                goto next;
                        if (fnhe->fnhe_genid != genid)
                            ^^^^^^^^^^^^^^^^
                                goto next;
...

I don't know / can't say from the trace above whether the non-canon
addr is in the bucket or the chain (outer/inner loop).

The code there appears pretty much unchanged since the introduction in
ee28906fd7a1437ca77a60a99b6b9c6d676220f8 and the RCU addition (around
the call to above) in fib_dump_info_fnhe() via
93ed54b15b2aae060c75ac00eb251ed02745eed1 (per 2019 syzkaller report
https://syzkaller.appspot.com/bug?id=2987ec035b602681b9c84de888615ea144f3c8ea).

We haven't found a reproducer yet; could it be that
fnhe_dump_bucket(), as it iterates all of hash+buckets, needs
spin_lock_bh(&fnhe_lock)/spin_unlock_bh(&fnhe_lock) as well ?

This seen on 5.15.26.

Thanks in advance for casting an eye over this !

Frank Hofmann
