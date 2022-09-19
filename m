Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429745BCD6C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiISNlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiISNlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:41:50 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0915FF4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:41:49 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-324ec5a9e97so339761587b3.7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=aQgi6Pu6LKQ4LFLczUoYz5yG9aB8B6oMSsmY4zlXGcQ=;
        b=lZ64I0JTTbdboJhfDIbfviGM5K0rtx4L079kU9kHBAVDmiJLODVcIMGq8fCc/OpiwV
         ySPE5X9cY7JVDS58SoIgYc3Lo+pkdJj5SLyP6ly9zC9MnBiQCG0cge2p7tHWfyPexK5a
         t2v7PfBtq2VhtVpHIUqd86QTE9rrlyhcGg6D6oyIf8scsakyRiLma1G+fWPoT69vTG0B
         Ucc+t56J6I+xIkqsEupPs/0p45/hPHiF538lqOHaXI8NHShV7B5ZXNMuEf9v3KdrzMsb
         iB8rCOZGgXkPy36REbpkrswWQhX5BdwBL1aMdYpgBEcI/uRSOpb8klhboaGRkSadetLa
         A5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aQgi6Pu6LKQ4LFLczUoYz5yG9aB8B6oMSsmY4zlXGcQ=;
        b=XQRvgfoP2adsyIE0/oDYG+fKh9C3WjsMAvRV5pbrXshuMHvWNuV0XWsNxsnTWbXTQx
         eweuREZsk0nOji+0Y3g52cplAFVKxdKY7L1PmMHN7Bt1qyd+VOtwgtCbytQzjglxB3zm
         X3igqJyEv1+Om53+BkTMhyIRaSangG3imWhbmTkVEh98KPYDgcDAjiRIuLdK0NAnxTFk
         IeZ5hEiCee2CtVtZpFiwdO1R+UzG9FXGPZUq+9maQUa1CezpesgdtU+4TXykocUOTF/T
         YI66pUCWFI/MqJehe3yH6+tglt/N+YJeTpxDIKaJZ6d5EmJNtINwa8JhO34vHzOTz+nZ
         mNIA==
X-Gm-Message-State: ACrzQf2N4rdxyBQhZgfIrgIpE7q1zc4t2GI7q0hznHpFbLck7L0AkvO5
        julRQICQs+iip68EoGStuvB9Fs4/mcx6lEJAv0CaNQ==
X-Google-Smtp-Source: AMsMyM4xrGbMfRdNPW+/V5EyahlE5SlrAAk8oqjkr9xNKtdgxhlTGCfbVn2KSCFFsP+tugn3qlRzusp5yHDI0H/7NVw=
X-Received: by 2002:a81:1409:0:b0:349:e8bb:1fdb with SMTP id
 9-20020a811409000000b00349e8bb1fdbmr14923270ywu.299.1663594908316; Mon, 19
 Sep 2022 06:41:48 -0700 (PDT)
MIME-Version: 1.0
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 19 Sep 2022 15:41:12 +0200
Message-ID: <CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com>
Subject: Use of uninit value in inet_bind2_bucket_find
To:     joannelkoong@gmail.com, Jakub Kicinski <kuba@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne, Jakub et al.,

When building next-20220919 with KMSAN I am seeing the following error
at boot time:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
BUG: KMSAN: uninit-value in inet_bind2_bucket_find+0x71f/0x790
net/ipv4/inet_hashtables.c:827
 inet_bind2_bucket_find+0x71f/0x790 net/ipv4/inet_hashtables.c:827
 inet_csk_get_port+0x2415/0x32e0 net/ipv4/inet_connection_sock.c:529
 __inet6_bind+0x1474/0x1a20 net/ipv6/af_inet6.c:406
 inet6_bind+0x176/0x360 net/ipv6/af_inet6.c:465
 __sys_bind+0x5b3/0x750 net/socket.c:1776
 __do_sys_bind net/socket.c:1787
 __se_sys_bind net/socket.c:1785
 __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?

Uninit was created at:
 slab_post_alloc_hook+0x156/0xb40 mm/slab.h:759
 slab_alloc_node mm/slub.c:3331
 slab_alloc mm/slub.c:3339
 __kmem_cache_alloc_lru mm/slub.c:3346
 kmem_cache_alloc+0x47e/0x9f0 mm/slub.c:3355
 inet_bind2_bucket_create+0x4b/0x3b0 net/ipv4/inet_hashtables.c:128
 inet_csk_get_port+0x2513/0x32e0 net/ipv4/inet_connection_sock.c:533
 __inet_bind+0xbd2/0x1040 net/ipv4/af_inet.c:525
 inet_bind+0x184/0x360 net/ipv4/af_inet.c:456
 __sys_bind+0x5b3/0x750 net/socket.c:1776
 __do_sys_bind net/socket.c:1787
 __se_sys_bind net/socket.c:1785
 __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?

CPU: 3 PID: 5983 Comm: sshd Not tainted 6.0.0-rc6-next-20220919 #211
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.0-debian-1.16.0-4 04/01/2014
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

I think this is related to "net: Add a bhash2 table hashed by port and
address", could you please take a look?
This error is not reported on v6.0-rc5 (note that KMSAN only exists in
-next and as a v6.0-rc5 fork at https://github.com/google/kmsan).

Alex

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
