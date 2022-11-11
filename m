Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AFB625DF6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 16:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiKKPLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 10:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiKKPKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 10:10:35 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC56657C4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 07:08:54 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id x6-20020a4ac586000000b0047f8cc6dbe4so691058oop.3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 07:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OTbT3PnKCiUHyfv/DLAnEwQTnkKfhzprbkWm2faBINA=;
        b=0CuK/RQWb+6cesOMC2bHN3caOL8MIHgULsf+RU5GPH++iNgae8xrq9k85A6TMio74A
         yvHJi+W7M6pMwE/ialWcG4lVtrQjHemuNZe/pw9/lt0bd1hQqW4Fcxam3DZS8jNTpwYw
         sdbuD0x2zRLPb2JhDbOYdvBZQfvOLBq1//tP7mOJbPP5oY2ruxYfkCxG+l8uHQZPXhfO
         nJ7nNFpUBZV+maEoLDVy3Uk26oftfoEBN817JMxn8uYDXXdvW71UbVZcTu4XEZ+62ql6
         Fy4x2wVLfjXeGjGnbi5ADKJwCQCfqV0LWaGlIC5tVvVNLEaKistBZTi1saNa6rKM72fP
         UeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OTbT3PnKCiUHyfv/DLAnEwQTnkKfhzprbkWm2faBINA=;
        b=Gwx+uiba+87rAeM2CpkBnF/mkqtEaMXBzlrNswddzGTWv9RW/yWXYo+VPZVr8P2ucd
         VxVz9cV7ghV5dLyUVUdAdbmYQO13h9v67wPndLQFt7zeYmTk80RcAvSTZr59BPHyzVam
         J2wwrj2q73VlphwmJI6q7ig9WBqfUseZKv8sCq6tEHL1V1LgZyFf8ExlLFwoK8M/5KIe
         DTY3WukYwocKrR2HDGt3yD3AoFhirNfsshJ/sKI3hCG1OqIg0LDbCoGl/KNHGjhoFVx+
         sbEEPxcDJqudn755Yyv9cXmJn+wEjcN69ZD2h428gtqwv9ntLTab7A1ofPznj+NXc767
         KQqA==
X-Gm-Message-State: ANoB5pmps1PEww6tKKux6rNgoUfPRd2eXO1CRHnpFeUEUNQkbsgQ0UXd
        xHLU0IoNvPkk1Y8KATwPeiSsGwk0qG/rYCsbn4Ro
X-Google-Smtp-Source: AA0mqf6usvNxkFdKnLz1F3rhVx/l4KFR/MdRYkmqCc+FBzoTMnlbkTF92jaLMMPS9V5d0rnwQIPI1VDo2/G9YkiW+RM=
X-Received: by 2002:a4a:e2c3:0:b0:480:7fd1:1875 with SMTP id
 l3-20020a4ae2c3000000b004807fd11875mr1044707oot.24.1668179333851; Fri, 11 Nov
 2022 07:08:53 -0800 (PST)
MIME-Version: 1.0
References: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 11 Nov 2022 10:08:42 -0500
Message-ID: <CAHC9VhQL0rV608+kJCAcRGHnfo1QLa5g2faws1_Mitipi1wjNQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix memory leak in security_sk_alloc()
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        jmorris@namei.org, serge@hallyn.com, martin.lau@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 4:32 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> kmemleak reports this issue:
>
> unreferenced object 0xffff88810b7835c0 (size 32):
>   comm "test_progs", pid 270, jiffies 4294969007 (age 1621.315s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000376cdeab>] kmalloc_trace+0x27/0x110
>     [<000000003bcdb3b6>] selinux_sk_alloc_security+0x66/0x110
>     [<000000003959008f>] security_sk_alloc+0x47/0x80
>     [<00000000e7bc6668>] sk_prot_alloc+0xbd/0x1a0
>     [<0000000002d6343a>] sk_alloc+0x3b/0x940
>     [<000000009812a46d>] unix_create1+0x8f/0x3d0
>     [<000000005ed0976b>] unix_create+0xa1/0x150
>     [<0000000086a1d27f>] __sock_create+0x233/0x4a0
>     [<00000000cffe3a73>] __sys_socket_create.part.0+0xaa/0x110
>     [<0000000007c63f20>] __sys_socket+0x49/0xf0
>     [<00000000b08753c8>] __x64_sys_socket+0x42/0x50
>     [<00000000b56e26b3>] do_syscall_64+0x3b/0x90
>     [<000000009b4871b8>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The issue occurs in the following scenarios:
>
> unix_create1()
>   sk_alloc()
>     sk_prot_alloc()
>       security_sk_alloc()
>         call_int_hook()
>           hlist_for_each_entry()
>             entry1->hook.sk_alloc_security
>             <-- selinux_sk_alloc_security() succeeded,
>             <-- sk->security alloced here.
>             entry2->hook.sk_alloc_security
>             <-- bpf_lsm_sk_alloc_security() failed
>       goto out_free;
>         ...    <-- the sk->security not freed, memleak
>
> To fix, if security_sk_alloc() failed and sk->security not null,
> goto out_free_sec to reclaim resources.
>
> I'm not sure whether this fix makes sense, but if hook lists don't
> support this usage, might need to modify the
> "tools/testing/selftests/bpf/progs/lsm_cgroup.c" test case.

The core problem is that the LSM is not yet fully stacked (work is
actively going on in this space) which means that some LSM hooks do
not support multiple LSMs at the same time; unfortunately the
networking hooks fall into this category.

While there can only be one LSM which manages the sock::sk_security
field by defining a sk_alloc_security hook, it *should* be possible
for other LSMs to to leverage the socket hooks, e.g.
security_socket_bind(), as long as they don't manipulate any of the
sock::sk_security state.

I would suggest modifying the ".../bpf/progs/lsm_cgroup.c" test until
the LSM supports stacking the networking hooks.

-- 
paul-moore.com
