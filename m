Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B635A36FE
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiH0K0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 06:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiH0K0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 06:26:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1985B042;
        Sat, 27 Aug 2022 03:26:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 145so3478285pfw.4;
        Sat, 27 Aug 2022 03:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oOOvNlBst84Vb+zKt/goG7vCoGnafio/yIXc1jtgiMs=;
        b=IyLEqu4EZ97wyRhH1+PCzJA12gQjPIsb27v8IThpAsYJYru+SfjOezkzGAP61NJkaG
         RouREYqNDibByW08suDtzDfouhJZ8zQ6Y+UAqjb1+9ZauS3TseMDJBs+AZjHrJS4lkuF
         0pZlcnhSMVeS6pEtLdpfXRc9rF+boHJbTd0OIfQP4SoyJrsSL+dRbTMMK2PLcJu69D6Z
         m7e4+0j383UtN6NyBcpgAG2KlA/fAQeAIxJU+MKAcO9c7a205c7nSZjWcuhghjHDo2Rb
         xAwPlDGJ+MMJxezWZkDBdMWEBDGoGrQPqR32eia2HdCSMf0Wdp80++WHaFVJIxEXJiCq
         8/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oOOvNlBst84Vb+zKt/goG7vCoGnafio/yIXc1jtgiMs=;
        b=3xF1G89bHDdnoXIKjnSLsx3/pP4QsE0MQK34nzCUbH6a8VaPwdDbxmJdjmeEkS4/rX
         nyK2F4ZUriJuNC5EH3jOSW8DRNxuvKcZfjlrmXfRmmnzXityh6nnXEfsqel4iHvS9c2s
         syvm+TovQvT4v6Awl9E2qpOBcB7Wr+FhBa7on8KP8rXdZGWfBMLUzlJXpOFA5d5WvGWl
         6nEenKeOfu33HMXUlHXWU1cgGh2F5y0U5Z3waKLGfVhea7AJEEPEeGzmSEDcbNbOsH8I
         3QK43mEK0nZpz7oI21Iz7xvTfGPxc1CbSWzruGc989F1RZCSwYNjkRoYmYDQHBYeL9t8
         waxg==
X-Gm-Message-State: ACgBeo2bkUlt5E4A+ak4YUO+WPjQMbmIPVnXm0oBreiYmtWaKtTCGkVD
        VwbKBfMYc/SPimQhvPud0Ik=
X-Google-Smtp-Source: AA6agR7IEJZdrMwq+UyiPfqBV37n4Oe2H5cwGKFaYIVjxqhIVacaQoHayczyNicb86vlyU9DhlbrrA==
X-Received: by 2002:a63:d94a:0:b0:412:6e04:dc26 with SMTP id e10-20020a63d94a000000b004126e04dc26mr6574259pgj.539.1661596003356;
        Sat, 27 Aug 2022 03:26:43 -0700 (PDT)
Received: from localhost ([223.104.39.136])
        by smtp.gmail.com with ESMTPSA id y63-20020a623242000000b00537f13d217bsm1111053pfy.76.2022.08.27.03.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 03:26:42 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     578001344xu@gmail.com
Cc:     borisp@nvidia.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yin31149@gmail.com
Subject: Re: refcount bug in bpf_exec_tx_verdict
Date:   Sat, 27 Aug 2022 18:26:33 +0800
Message-Id: <20220827102632.4956-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAO4S-mfk+Rb5Rjr-ZLBu0UHrQuH2+d5tC9XO_tSL-=ukMjQnPA@mail.gmail.com>
References: <CAO4S-mfk+Rb5Rjr-ZLBu0UHrQuH2+d5tC9XO_tSL-=ukMjQnPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Aug 2022 at 16:09, Jiacheng Xu <578001344xu@gmail.com> wrote:
>
> Hello,
>
> When using modified Syzkaller to fuzz the Linux kernel-5.19, the
> following crash was triggered.  
> HEAD commit: 3d7cb6b04c3f Linux-5.19
> git tree: upstream
>
> console output:
> https://drive.google.com/file/d/1Sdr1eSqR2fQ187gdAIn568-JBiUTgoOL/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
> syz repro: https://drive.google.com/file/d/1bP0dDQfHG4yy59rHjxQxfjnDiIjXfbBU/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1yB50TqEIAAZibpU9G_c3ryvCCnGsBRir/view?usp=sharing
>
> Environment:
> Ubuntu 20.04 on Linux 5.4.0
> QEMU 4.2.1:
> qemu-system-x86_64 \
>   -m 2G \
>   -smp 2 \
>   -kernel /home/workdir/bzImage \
>   -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
>   -drive file=/home/workdir/stretch.img,format=raw \
>   -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
>   -net nic,model=e1000 \
>   -enable-kvm \
>   -nographic \
>   -pidfile vm.pid \
>   2>&1 | tee vm.log
>
> It seems there is a similar
> problem(https://lore.kernel.org/bpf/20220804082913.5dac303c@kernel.org/)
> and patch.
> Is the patch applied on Linux-5.19.4? I can still trigger the bug on
> both 5.19 and 5.19.4.
Hi,
This patch is not applied on Linux-5.19.4 or Linux-5.19.
Yet it has been applied at least on Linux-6.0-rc1.
You can find the commit
2a0133723f9e("net: fix refcount bug in sk_psock_get (2)")

I test it locally, it seems that the reproducer did not trigger
this bug on Linux-6.0-rc1.
>
> If you fix this issue, please add the following tag to the commit:
> Reported-by Jiacheng Xu<578001344xu@gmail.com>,
>
> -----------------------------------
> refcount_t: saturated; leaking memory.
> WARNING: CPU: 2 PID: 7393 at lib/refcount.c:19
> refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Modules linked in:
> CPU: 2 PID: 7393 Comm: syz-executor Not tainted 5.19.0 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Code: 1d e2 87 9d 09 31 ff 89 de e8 58 32 72 fd 84 db 75 ab e8 2f 31
> 72 fd 48 c7 c7 e0 34 28 8a c6 05 c2 87 9d 09 01 e8 63 7d 2d 05 <0f> 0b
> eb 8f e8 13 31 72 fd 0f b6 1d ac 87 9d 09 31 ff 89 de e8 23
> RSP: 0018:ffffc9000856f5c0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffffc90002949000 RSI: ffff888023841d80 RDI: fffff520010adeaa
> RBP: 0000000000000000 R08: ffffffff81619cd8 R09: 0000000000000000
> R10: 0000000000000005 R11: ffffed100c7a4f25 R12: ffff8880259e82b8
> R13: 0000000000000000 R14: 00000000912d1630 R15: ffff888014780000
> FS:  00007f5a2d44f700(0000) GS:ffff888063d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5a2c30e010 CR3: 000000002555f000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __refcount_add_not_zero include/linux/refcount.h:163 [inline]
>  __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
>  refcount_inc_not_zero include/linux/refcount.h:245 [inline]
>  sk_psock_get include/linux/skmsg.h:439 [inline]
>  bpf_exec_tx_verdict+0x1066/0x14d0 net/tls/tls_sw.c:809
>  tls_sw_sendmsg+0xe53/0x1740 net/tls/tls_sw.c:1023
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  sock_sendmsg+0xc3/0x120 net/socket.c:729
>  sock_write_iter+0x284/0x3c0 net/socket.c:1108
>  call_write_iter include/linux/fs.h:2058 [inline]
>  new_sync_write+0x393/0x570 fs/read_write.c:504
>  vfs_write+0x7c4/0xab0 fs/read_write.c:591
>  ksys_write+0x1e8/0x250 fs/read_write.c:644
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f5a2c295dfd
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5a2d44ec58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f5a2c3bc0a0 RCX: 00007f5a2c295dfd
> RDX: 000000000000fdef RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00007f5a2c2ff4c1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5a2c3bc0a0
> R13: 00007ffce006e15f R14: 00007ffce006e300 R15: 00007f5a2d44edc0
>  </TASK>
