Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25A5F9F55
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJJNYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJJNYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:24:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB23261D89;
        Mon, 10 Oct 2022 06:24:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id nb11so24894959ejc.5;
        Mon, 10 Oct 2022 06:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S4TuO/R3PUr2Z3As+PBmnhfUrFKXN0bX/gKStbzoYWY=;
        b=lEqkby1o2P9oiUTHmDuhjFJ6WX4EvOcDTsRrkhNm9cfmmNx7LU7OTxjbhCshQd4C8V
         JWiaxVIQaER2wIOSmq1yo/hxidyY2sp0kk7UOD8iI16ynloBS/qa0eJxpJh7naspnBmF
         Eomb6M7bQHkWiLqwIeyExy4duhlHArJUy3ExyanWt/X5NNVXt9wl2o6quVRll7D6zJwa
         rTSDmp3dMrkqk22HVDsEOUC0kAdacsQlvYzqCgDCJTuU86Ceg4IMY5FMmxmWVtDPaScK
         jUpqS3al4/H7VCuFfDUZMQ1BBpGVmly4z+rGVoFTDt0J0qmQvsVjQBR/zgr61PjzpDO2
         k8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4TuO/R3PUr2Z3As+PBmnhfUrFKXN0bX/gKStbzoYWY=;
        b=v+eUlSBBlHV4LTTybsZA4osfnq2gAF4/BV4YRHbPT2nNcOtBNKJOytH71mwlGRo7wK
         Z42tdNElvoxLzkSkS7kYppZJ8za6gaCVQ3obDSwWf5I/2g6yVTvIwvhA+zWkPFBA89Or
         nzgVm91ozq1skgp3SVP1DWWE7GvARsjmtQJhhtyYdP4cz7RJy6z5N3dwhA4C2LoO67TQ
         irjbXNvwzpqtG6DQmPFlZNh6yTQFDZELEYIPZ++kBMjlrXU+Zial3L6VNpUSLyZtMJ9G
         H+3lsFjbh3q+50GACe2ycqYYx3gpMvJCkH91IGfgxiBGC4VyQDtYZ/TITaCh9yMR1BrD
         Dvkg==
X-Gm-Message-State: ACrzQf2w7nHiEPw4R5Jy5BePoQiDyMUYesSqZFmL1FllxpKQv2kqzYZf
        AO/Ox36D7OtRY9/IF4Zn5tAzNnm7RMQAzbJ3vko=
X-Google-Smtp-Source: AMsMyM7nNJ9G292inQymfGArq4O2cI71AqV4IIm31Y9VqNdyXyEO2cc8vT1w7LdYU88WIdncAAYGZTlouIQ8eFLSmZE=
X-Received: by 2002:a17:907:2d06:b0:78d:50db:130e with SMTP id
 gs6-20020a1709072d0600b0078d50db130emr13651649ejc.371.1665408259027; Mon, 10
 Oct 2022 06:24:19 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 10 Oct 2022 21:23:44 +0800
Message-ID: <CAO4mrff8gu5pe5A-Tm7mDrduHz4yNHRyWh5B5S2=2qe3ejfgUg@mail.gmail.com>
Subject: kernel BUG in ip6gre_header
To:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com, willemb@google.com,
        kafai@fb.com, imagedong@tencent.com, talalahmad@google.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: fc74e0a40e4f Linux 5.16-rc7
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1w1j1H1ptN2F4RTwi06iAgwXM6cscQHg7/view?usp=sharing
kernel config: https://drive.google.com/file/d/1L16y3aFu5mPQbKNsc7eQc6RH55YRd1zd/view?usp=sharing

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

kernel BUG at net/core/skbuff.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3152 Comm: syz-executor Not tainted 5.16.0-rc7 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_panic+0x14a/0x150
Code: ca 99 8b 48 8b 74 24 08 48 8b 54 24 10 8b 0c 24 44 8b 44 24 04
49 89 e9 31 c0 53 41 55 41 54 41 57 e8 71 e3 f0 01 48 83 c4 20 <0f> 0b
0f 1f 40 00 55 41 57 41 56 41 55 41 54 53 48 83 ec 70 4c 89
RSP: 0018:ffffc90009d9f820 EFLAGS: 00010282
RAX: 000000000000008a RBX: ffff88803e85a000 RCX: 114ab6c57586dc00
RDX: ffffc90002144000 RSI: 0000000000002f87 RDI: 0000000000002f88
RBP: ffff88801cb30c00 R08: ffffffff8167a5e2 R09: ffffed100c7867b1
R10: ffffed100c7867b1 R11: 0000000000000000 R12: 000000000000003c
R13: 00000000000000c0 R14: dffffc0000000000 R15: ffff88801cb30bd8
FS:  00007f8d37e40700(0000) GS:ffff888063c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 00000000131c1000 CR4: 0000000000752ef0
DR0: 0000000020000100 DR1: 0000000020000100 DR2: c62d86afc1fea99c
DR3: 0000000000000d27 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 skb_under_panic+0x25/0x30
 skb_push+0xb2/0xd0
 ip6gre_header+0xcb/0x7b0
 vlan_dev_hard_header+0x35b/0x480
 llc_mac_hdr_init+0x116/0x190
 llc_sap_action_send_test_c+0x188/0x310
 llc_sap_state_process+0x247/0x840
 llc_ui_sendmsg+0x7da/0x1420
 __sys_sendto+0x43d/0x5a0
 __x64_sys_sendto+0xda/0xf0
 do_syscall_64+0x3d/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8d3a8d7c4d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8d37e3fc58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f8d3a9fe0a0 RCX: 00007f8d3a8d7c4d
RDX: 0000000000000035 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00007f8d3a950d80 R08: 0000000020000080 R09: 0000000000000010
R10: 0000000004000000 R11: 0000000000000246 R12: 00007f8d3a9fe0a0
R13: 00007ffc1bf6b7bf R14: 00007ffc1bf6b960 R15: 00007f8d37e3fdc0
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace a43bcba70fed35f6 ]---
RIP: 0010:skb_panic+0x14a/0x150
Code: ca 99 8b 48 8b 74 24 08 48 8b 54 24 10 8b 0c 24 44 8b 44 24 04
49 89 e9 31 c0 53 41 55 41 54 41 57 e8 71 e3 f0 01 48 83 c4 20 <0f> 0b
0f 1f 40 00 55 41 57 41 56 41 55 41 54 53 48 83 ec 70 4c 89
RSP: 0018:ffffc90009d9f820 EFLAGS: 00010282
RAX: 000000000000008a RBX: ffff88803e85a000 RCX: 114ab6c57586dc00
RDX: ffffc90002144000 RSI: 0000000000002f87 RDI: 0000000000002f88
RBP: ffff88801cb30c00 R08: ffffffff8167a5e2 R09: ffffed100c7867b1
R10: ffffed100c7867b1 R11: 0000000000000000 R12: 000000000000003c
R13: 00000000000000c0 R14: dffffc0000000000 R15: ffff88801cb30bd8
FS:  00007f8d37e40700(0000) GS:ffff888063c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f300ed27000 CR3: 00000000131c1000 CR4: 0000000000752ef0
DR0: 0000000020000100 DR1: 0000000020000100 DR2: c62d86afc1fea99c
DR3: 0000000000000d27 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554

Best,
Wei
