Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5765A3DB8EC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhG3M4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 08:56:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhG3M4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 08:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627649797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UtfsScUhD+pEZHHcmHhhH+yLEg7yLqf8T5OocO85sds=;
        b=bIl/mAF1xxox7pbLxadsVOxvN1e1EB6fScCA15/ekrDiKgjCj6luK4HogGOhB9709QX9gm
        oHXLOxnEPz2E8jI3qwJMxWatmqcKcFk5th4s2moP0xQGSdZKqU2V3Hi0NoIy80LjDFh6hA
        0+WXh54DkgxTn7OpzcsW4vt2lv2PE9U=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-b2SygdOmNuKq_7nb2ohxlA-1; Fri, 30 Jul 2021 08:56:36 -0400
X-MC-Unique: b2SygdOmNuKq_7nb2ohxlA-1
Received: by mail-oi1-f200.google.com with SMTP id o185-20020acaf0c20000b029025cacdf2ac0so4529570oih.9
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 05:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UtfsScUhD+pEZHHcmHhhH+yLEg7yLqf8T5OocO85sds=;
        b=Hpj0MXiPxwWERgWH84VKyooBWesC7V6WKBe4Q8Pe80PLVDoZPE+r48TCT+1P7bW6fZ
         7VrGp5nkRYE1jcBm9Jcd4wkFAcvd1jTtgY3bXoEtvji5oHMWOa69t76WvBoeKnJ/3wPT
         +hhWc+U9BVLh5cHfp9JIItraFtWSAXw+FO/sufOMqUEczV8vn9WoKZLAjN7GjIj1IECP
         kaA8IfmyquWFs7+fcoqkTrpMaPO/gGxkZ1dJeHWj07rPdovqVJ4/RZ6HogK0FYSOqo+L
         Yg42dc3YIJJKqVj/T+CL9PG1PPeIZnXg5whzJC8JqH04rouMiybwwe3jzu44l5e8nWLV
         BBZQ==
X-Gm-Message-State: AOAM530kK4mXJMae7rjcEUqxOCOeNsHOiXZwyzRkp5W2YL0FDLye60Vz
        ElVs2YqibWWDHY50LqMTv+lvpewfCWSCHtPXxZ+zm6k4N4sykLje+qT3T9YTFCtyH/O8jKrnsK1
        zHbbePAgzzkYbLQPHNVeIrogbO9Nm6dLF
X-Received: by 2002:a05:6808:1887:: with SMTP id bi7mr1666426oib.115.1627649795301;
        Fri, 30 Jul 2021 05:56:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxf7koHApQZ7driEjjiDkMYWNez7AyvQMuuoFtY5dVuJfLDJ6WPhPy3xdN+rQeihfaew83/39QzgNXpZV7Ii5A=
X-Received: by 2002:a05:6808:1887:: with SMTP id bi7mr1666415oib.115.1627649795080;
 Fri, 30 Jul 2021 05:56:35 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Fri, 30 Jul 2021 14:56:24 +0200
Message-ID: <CA+QYu4qNuOEJqWJST26CoDh6D2XPocjqaOZncpFRwR-qnEym=A@mail.gmail.com>
Subject: BUG: MAX_LOCKDEP_ENTRIES too low! during network test
To:     netdev@vger.kernel.org
Cc:     CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We've hit the call trace below twice during our tests of kernel
5.14.0-rc2. We hit it during CKI test [1], in both cases it was
testing on ppc64le, more logs on [2].

[14100.944491] BUG: MAX_LOCKDEP_ENTRIES too low!
[14100.944651] turning off the locking correctness validator.
[14100.944739] CPU: 121 PID: 430464 Comm: socket Tainted: G
OE     5.14.0-rc2 #1
[14100.944764] Call Trace:
[14100.944775] [c00000003a92f4f0] [c00000000097d4f4]
dump_stack_lvl+0x98/0xe0 (unreliable)
[14100.944979] [c00000003a92f530] [c0000000002076d8]
add_lock_to_list.constprop.0+0x218/0x230
[14100.945007] [c00000003a92f5a0] [c00000000020e1bc]
__lock_acquire+0x1d6c/0x2850
[14100.945033] [c00000003a92f6d0] [c00000000020f80c] lock_acquire+0x11c/0x450
[14100.945057] [c00000003a92f7d0] [c0000000011f0cdc]
_raw_spin_lock_irqsave+0x6c/0xc0
[14100.945084] [c00000003a92f810] [c00000000095f42c]
percpu_counter_add_batch+0x5c/0x120
[14100.945109] [c00000003a92f850] [c000000000fb9534]
tcp_v4_destroy_sock+0x1d4/0x3b0
[14100.945136] [c00000003a92f8a0] [c000000000f89c5c]
inet_csk_destroy_sock+0x8c/0x1f0
[14100.945162] [c00000003a92f8d0] [c000000000f9762c] __tcp_close+0x50c/0x680
[14100.945185] [c00000003a92f930] [c000000000f977e4] tcp_close+0x44/0x100
[14100.945329] [c00000003a92f960] [c000000000fed488] inet_release+0x78/0xf0
[14100.945387] [c00000003a92f990] [c000000000e24f40] __sock_release+0x70/0x150
[14100.945412] [c00000003a92fa10] [c000000000e25048] sock_close+0x28/0x40
[14100.945434] [c00000003a92fa30] [c0000000005877f8] __fput+0xd8/0x360
[14100.945457] [c00000003a92fa80] [c0000000001944f4] task_work_run+0xb4/0x120
[14100.945478] [c00000003a92fad0] [c000000000163408] do_exit+0x4e8/0xdd0
[14100.945500] [c00000003a92fb90] [c000000000163dc0] do_group_exit+0x60/0xd0
[14100.945523] [c00000003a92fbd0] [c000000000179d38] get_signal+0x238/0xc00
[14100.945546] [c00000003a92fcb0] [c0000000000229f4]
do_notify_resume+0x114/0x4b0
[14100.945572] [c00000003a92fd70] [c00000000002dc64]
interrupt_exit_user_prepare_main+0x2e4/0x370
[14100.945600] [c00000003a92fde0] [c00000000002e0a4]
syscall_exit_prepare+0xc4/0x1c0
[14100.945625] [c00000003a92fe10] [c00000000000c770]
system_call_common+0x100/0x258
[14100.945651] --- interrupt: c00 at 0x7fffa8a59904
[14100.945670] NIP:  00007fffa8a59904 LR: 0000000010001e44 CTR: 0000000000000000
[14100.945692] REGS: c00000003a92fe80 TRAP: 0c00   Tainted: G
 OE      (5.14.0-rc2)
[14100.945715] MSR:  900000000000f033 <SF,HV,EE,PR,FP,ME,IR,DR,RI,LE>
CR: 38002842  XER: 00000000
[14100.945908] IRQMASK: 0
               GPR00: 0000000000000146 00007fffd5d1a870
00007fffa8b56f00 0000000000000061
               GPR04: 0000000000000007 0000000000000000
00007fffa8b50018 000000019f9f6bb0
               GPR08: 0000000000000007 0000000000000000
0000000000000000 0000000000000000
               GPR12: 0000000000000000 00007fffa8c0a360
0000000000000000 0000000000000000
               GPR16: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
               GPR20: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
               GPR24: 0000000010001978 00007fffd5d1ad68
000000001001fd08 00007fffa8bfeb68
               GPR28: 00007fffd5d1b038 00007fffd5d1ad48
0000000000000003 00007fffd5d1a870
[14100.946264] NIP [00007fffa8a59904] 0x7fffa8a59904
[14100.946289] LR [0000000010001e44] 0x10001e44
[14100.946306] --- interrupt: c00


[1] https://gitlab.com/cki-project/kernel-tests/-/tree/main/networking/route/pmtu
[2] https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/25/342571554/build_ppc64le_redhat%3A1450600800/tests/Networking_route_pmtu/

Thank you,
Bruno

