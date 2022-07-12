Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C9A57127E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiGLGvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiGLGvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:51:12 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE698BA90;
        Mon, 11 Jul 2022 23:51:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ez10so12588737ejc.13;
        Mon, 11 Jul 2022 23:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TQzVugZhGld5vaXp+oM1h1EMID2gkhbawjghtSP3Iek=;
        b=WsbGNhBGltSFugquCLvGkr6AZ4+pst40njs2a3jp7+zOTX3UBA9S/7gV0wl5B0o2ef
         fD2x83zEo/J88aCMer4tyzChLG8A36hC1zfdX5OAk3sD3Wrf4UbgQQVCAS2oE2mIENDM
         gfJHt1S6Q3SKEPjjkz6FsRZCzbQ7py7OZKLq3wR+UXHswl7WtMGGAdaHCsC6hlg50mFl
         YhrmPedVHsYa18C4wJgD1hgvGUSi+VJ+cY7Kj91LYy6xkNcl46SW1kiooB5Ec9UnhKGL
         GupUWG065DtaN07tbsqv7cJJ3QcbRLE9X4XdPEd48JduLWpqRD54pk3g/gNaHDQnDxfs
         K4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TQzVugZhGld5vaXp+oM1h1EMID2gkhbawjghtSP3Iek=;
        b=fk5+kPOb0bNSj4wR1K2FwBzp9lwq3bJE7GRpNzmBq95jBl8kcI8Q0hvJ1pGMQzgy1q
         pB3aCfBB2tzRodFrCrGqMsY4jRwL7vcwp6LirWJzEanxSbzcY94gQCKo1bf9MJzFreJa
         0mYeOkKl7cN1VBENObYJZw9nTV4RuZ1SyDsK197O2xDD5vONiwCJ+pCJnrK/ePhlSRKJ
         yl+HG7CvsL/43SPOfb/6gZb0ENfvsdqTyCPsIZQlQGHHNjRp+fYkf9yjSJz8W6nY3cba
         SGATwM2j1blq8IaZEBR/+hZS/Un74cfX4gAvpwW2zkVA3DT+zfGvppyVjyF9vGagDUiy
         f3qQ==
X-Gm-Message-State: AJIora8Nb2xGBoyhFGFqqQooN+nSCo7KQGIPJudroCyV4lXm6esCH/H+
        a4nH9FsgTKFgdWxhbJpBKRdiRbHN0K3KJv5p51I=
X-Google-Smtp-Source: AGRyM1v51omMmVZcw1SNCS3Ct04JLiqxQJBgp8QerZE2ITACMQHmD5C5OvQ2uxBCE9IhCn5htQ6bKESr7nhq4LO9swU=
X-Received: by 2002:a17:907:9620:b0:72b:5822:93d0 with SMTP id
 gb32-20020a170907962000b0072b582293d0mr8330577ejc.235.1657608668710; Mon, 11
 Jul 2022 23:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4mrfcUYjEi69mcSt_vXyb3VGFTAAq3dyNeWueucgw0DGABfg@mail.gmail.com>
In-Reply-To: <CAO4mrfcUYjEi69mcSt_vXyb3VGFTAAq3dyNeWueucgw0DGABfg@mail.gmail.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Tue, 12 Jul 2022 14:50:33 +0800
Message-ID: <CAO4mrfcB0d+qbwtfndzqcrL+QEQgfOmJYQMAdzwxRePmP8TY1A@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in sctp_sched_dequeue_common
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit:  c5eb0a61238d Linux 5.18-rc6
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1zbd9t-NNorzTXESdQ3bxE-q9uLu-Bm9d/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/18wnwTf53Ln4K8e4G9d8hS4-e0URQKHet/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1ttiMq0WYi46zFP1II8O9eee_dvDweIb6/view?usp=sharing
kernel config: https://drive.google.com/file/d/1fITkvcuglspvuhI0mhXUndx112fJmcOZ/view?usp=sharing

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 12f83067 P4D 12f83067 PUD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.18.0-rc6 #12
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__list_del_entry_valid+0x26/0x80
Code: 00 00 00 00 55 48 89 e5 48 89 fe 48 ba 00 01 00 00 00 00 ad de
48 8b 0f 48 39 d1 74 22 48 8b 46 08 48 83 c2 22 48 39 d0 74 25 <48> 8b
10 48 39 f2 75 2d 48 8b 51 08 48 39 f2 75 37 b0 01 5d c3 48
RSP: 0018:ffff888007313720 EFLAGS: 00010217
RAX: 0000000000000000 RBX: ffff88800c6283e8 RCX: 0000000000000000
RDX: dead000000000122 RSI: ffff88800c6283e8 RDI: ffff88800c6283e8
RBP: ffff888007313720 R08: ffffffff84399732 R09: ffffffff84392a74
R10: 0000000000000042 R11: ffff8880072a2f80 R12: ffff8880138be238
R13: ffff888016cdb000 R14: ffff888016cdb5a0 R15: ffff888016cdb000
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000012f82000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 sctp_sched_dequeue_common+0x1c/0x90
 sctp_sched_prio_dequeue+0x67/0x80
 __sctp_outq_teardown+0x299/0x380
 sctp_outq_free+0x15/0x20
 sctp_association_free+0xc3/0x440
 sctp_do_sm+0x1ca7/0x2210
 sctp_assoc_bh_rcv+0x1f6/0x340
 sctp_inq_push+0x98/0xb0
 sctp_rcv+0x134e/0x16b0
 sctp6_rcv+0x1b/0x30
 ip6_protocol_deliver_rcu+0x5b7/0x930
 ip6_input+0x80/0x140
 ip6_rcv_finish+0x16e/0x1d0
 ipv6_rcv+0x72/0x110
 __netif_receive_skb+0x66/0x140
 process_backlog+0x13d/0x230
 __napi_poll+0x4b/0x310
 net_rx_action+0x1ae/0x410
 __do_softirq+0x16e/0x30f
 run_ksoftirqd+0x23/0x30
 smpboot_thread_fn+0x210/0x370
 kthread+0x124/0x160
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid+0x26/0x80
Code: 00 00 00 00 55 48 89 e5 48 89 fe 48 ba 00 01 00 00 00 00 ad de
48 8b 0f 48 39 d1 74 22 48 8b 46 08 48 83 c2 22 48 39 d0 74 25 <48> 8b
10 48 39 f2 75 2d 48 8b 51 08 48 39 f2 75 37 b0 01 5d c3 48
RSP: 0018:ffff888007313720 EFLAGS: 00010217
RAX: 0000000000000000 RBX: ffff88800c6283e8 RCX: 0000000000000000
RDX: dead000000000122 RSI: ffff88800c6283e8 RDI: ffff88800c6283e8
RBP: ffff888007313720 R08: ffffffff84399732 R09: ffffffff84392a74
R10: 0000000000000042 R11: ffff8880072a2f80 R12: ffff8880138be238
R13: ffff888016cdb000 R14: ffff888016cdb5a0 R15: ffff888016cdb000
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000012f82000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
----------------
Code disassembly (best guess):
   0: 00 00                          add    %al,(%rax)
   2: 00 00                          add    %al,(%rax)
   4: 55                               push   %rbp
   5: 48 89 e5                     mov    %rsp,%rbp
   8: 48 89 fe                      mov    %rdi,%rsi
   b: 48 ba 00 01 00 00 00 movabs $0xdead000000000100,%rdx
  12: 00 ad de
  15: 48 8b 0f                     mov    (%rdi),%rcx
  18: 48 39 d1                    cmp    %rdx,%rcx
  1b: 74 22                         je     0x3f
  1d: 48 8b 46 08               mov    0x8(%rsi),%rax
  21: 48 83 c2 22               add    $0x22,%rdx
  25: 48 39 d0                    cmp    %rdx,%rax
  28: 74 25                         je     0x4f
* 2a: 48 8b 10                   mov    (%rax),%rdx <-- trapping instruction
  2d: 48 39 f2                    cmp    %rsi,%rdx
  30: 75 2d                        jne    0x5f
  32: 48 8b 51 08              mov    0x8(%rcx),%rdx
  36: 48 39 f2                    cmp    %rsi,%rdx
  39: 75 37                        jne    0x72
  3b: b0 01                        mov    $0x1,%al
  3d: 5d                             pop    %rbp
  3e: c3                             retq
  3f: 48                              rex.W
