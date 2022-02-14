Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D844B5B28
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiBNUpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:45:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiBNUpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:45:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73C94242F96
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644870921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e6EPVeD6do3pRt+tnipJnjeqzRh8UgXYDY8NcL5v4TA=;
        b=U2BMp9ivdf4tHxMPF4mp3ASac4g0SM3gxKsHFeRuSw1m7rs17MiM7txNoYNIM/e++0xXO7
        IXX3Qk8xhzzqkQJ/2Og4c7KZT2pIrJwDSsLABJJnh72xEduqC8gZRhRty+644HPfv1kQT9
        rFwBiFARL+RQuC305YF4jLl6VEG40cM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-uXqD1SLXO_iIgtsYWMX37A-1; Mon, 14 Feb 2022 14:53:19 -0500
X-MC-Unique: uXqD1SLXO_iIgtsYWMX37A-1
Received: by mail-qt1-f197.google.com with SMTP id d25-20020ac84e39000000b002d1cf849207so13263306qtw.19
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 11:53:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6EPVeD6do3pRt+tnipJnjeqzRh8UgXYDY8NcL5v4TA=;
        b=FABGdYKPs3v/ZHpDtteJB368mu6rJs4+QYeLI4RMFwXtlQdL+yn8KG79IGh3WE5y5U
         E2rn9OrsvP3vkRzEOeLeOM+lNsPIvR4OTi3Ris8ZR5P5gi2EqM6a6045bdV2gKC5DtId
         CxAXlD6Nw6rCLTEUeIUlsJUWOD39a0Vyti9O2DPo3AXZJZwQ0e1m/AnxfofszWzEHLiK
         WBn2XYY5a2DRn0SpRq6bCdtJHopqF/fu1oQPj4MikEHYKZYKR39Y5QZkzT62cqudKSei
         FG0KejqefUdClSXxKstLMOSMlNfqceRYQOl8HISONQ8e0O7hDTKSqpvRnhKgUCMblSq5
         oGLw==
X-Gm-Message-State: AOAM531p6wIOHLssQ/OKh5kIePXxgqGsNn1Q34aMa57ooO7vyj5peBAb
        MjN85mKE4UT/QAHVOP2y64+QASm0MKOjfax3u0EgURmtzSBArJHpwj2kiF9cSZ3xp9aOwh6ri18
        ajmshJIDp0HQnbxMY
X-Received: by 2002:ac8:5950:: with SMTP id 16mr442159qtz.104.1644868398657;
        Mon, 14 Feb 2022 11:53:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfG6/1k0rBJt+vzNdA66ptivPgVKhtvF3fESYrk5a1gNiCTywfjuzFjb7lbQg3RurGL/bZLg==
X-Received: by 2002:ac8:5950:: with SMTP id 16mr442138qtz.104.1644868398345;
        Mon, 14 Feb 2022 11:53:18 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id e64sm123461qkd.122.2022.02.14.11.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 11:53:17 -0800 (PST)
Date:   Mon, 14 Feb 2022 11:53:14 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     syzbot <syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jgross@suse.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in __text_poke
Message-ID: <20220214195314.gv7gzxqza346ztnf@treble>
References: <00000000000076b4bf05d7fed1f1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00000000000076b4bf05d7fed1f1@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Song, this is likely the same issue as 

https://lkml.kernel.org/r/0000000000007646bd05d7f81943@google.com

On Mon, Feb 14, 2022 at 10:45:19AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=173474ac700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=ecb1e7e51c52f68f7481
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: vmalloc-out-of-bounds in memcmp+0x16f/0x1c0 lib/string.c:770
> Read of size 8 at addr ffffffffa0013400 by task syz-executor.3/26377
> 
> CPU: 1 PID: 26377 Comm: syz-executor.3 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  memcmp+0x16f/0x1c0 lib/string.c:770
>  memcmp include/linux/fortify-string.h:269 [inline]
>  __text_poke+0x5a2/0x8c0 arch/x86/kernel/alternative.c:1056
>  text_poke_copy+0x66/0xa0 arch/x86/kernel/alternative.c:1132
>  bpf_arch_text_copy+0x21/0x40 arch/x86/net/bpf_jit_comp.c:2426
>  bpf_jit_binary_pack_finalize+0x43/0x170 kernel/bpf/core.c:1098
>  bpf_int_jit_compile+0x9d5/0x12f0 arch/x86/net/bpf_jit_comp.c:2383
>  bpf_prog_select_runtime+0x4d4/0x8a0 kernel/bpf/core.c:2163
>  bpf_prog_load+0xfe6/0x2250 kernel/bpf/syscall.c:2349
>  __sys_bpf+0x68a/0x59a0 kernel/bpf/syscall.c:4640
>  __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f8a1c276059
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8a1abca168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f8a1c389030 RCX: 00007f8a1c276059
> RDX: 0000000000000064 RSI: 00000000202a0fb8 RDI: 0000000000000005
> RBP: 00007f8a1c2d008d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffe9ad17dff R14: 00007f8a1abca300 R15: 0000000000022000
>  </TASK>
> 
> 
> Memory state around the buggy address:
>  ffffffffa0013300: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffffffa0013380: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >ffffffffa0013400: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                    ^
>  ffffffffa0013480: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffffffa0013500: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

-- 
Josh

