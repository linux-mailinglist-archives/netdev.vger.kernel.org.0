Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24F66102C9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiJ0UfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiJ0UfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:35:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F9C71BCF;
        Thu, 27 Oct 2022 13:35:00 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n12so7954502eja.11;
        Thu, 27 Oct 2022 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zGVeDjXeujkiyXIf1q5xCCgm01cdpw69H2d31odE64k=;
        b=fBJXKvJRp1Ca7iTLp64t9ofi+KwlKv9WLYGl6e2hHiWqlW84Jlo/JaPia3RxLRq0If
         z6XqLm03FIhNWdEm4hkVmAOWZLI+a2gXkekjMAakB5MtDSB+jgKtogqxVwzFgV9SiJZ2
         gZgBYc7iA61CMPCyLWk5kFhv/i8NxMtMofzNhnNene/oZApT2jv8KIDCT1OdWaoXsadB
         t17RNUSQivq/7BfztlQ2p2y/5N074q9Dw/BjgYM9o9d/iniwt9PxX+06LdcGYSt4zm6m
         PpINNQ/DolX583IKIV4bQBuUNZb/zbPuL1474BJebVmqwJ13O/DsbF72jjt0UUjI0xWq
         aIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGVeDjXeujkiyXIf1q5xCCgm01cdpw69H2d31odE64k=;
        b=omJ7sHV5IQWDmuZdqerqHMGZ2DYUB6b5UucYBq6hilAyBOlzk7TenaFgAFV0i4AXqM
         anXcDOm8f2Efzajol5GioyfCFOnEWF8KeucLHvWKUI5E56Qs798j1GfVswL5p1PxK9T+
         vVEX1URUlBsv8vMcJAx0ydM6Ffi3NM2q7+pJLqRcj651dSoMPVfQp+dxl6yHuP+i5fuD
         VXmKkektHrIh16W8Sif3aDiCgysuc0RGRm+QL9Z4KrNhAE/a+tiYwjaq9GpBzZKH6dB3
         Tyf3hpPn+LYlJhqkJJoEAWss7cdnY6c59hsg/eGeplcJNayh6lZKdeBZUcM1KCXW432+
         +7zg==
X-Gm-Message-State: ACrzQf2SNB+rwtWJRYYGPxHHXEUmbC6sDkGok3ByRYAAws9OtKFFhzcb
        1QUj757EHAATouYD72zHMV5F5o6wfoEgg9nNxbBoNYl79do=
X-Google-Smtp-Source: AMsMyM4cSjs8StZ1GJtQrsTPgDD/sIubNBaXZhOlmZcMKBk/VXGY6BIQfJfwCEQ9TM2FE0w2GmzBDAfyzjfikdMgAPw=
X-Received: by 2002:a17:907:8a24:b0:795:bb7d:643b with SMTP id
 sc36-20020a1709078a2400b00795bb7d643bmr38412590ejc.115.1666902899199; Thu, 27
 Oct 2022 13:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <1666866213-4394-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1666866213-4394-1-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Oct 2022 13:34:47 -0700
Message-ID: <CAEf4Bza03=MLPJN1fY+93W4=orqt=nHzQuUBw=7cz-qAwFQdvA@mail.gmail.com>
Subject: Re: [PATCH net] bpf: Fix memory leaks in __check_func_call
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, yhs@fb.com, joe@wand.net.nz
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 3:03 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> kmemleak reports this issue:
>
> unreferenced object 0xffff88817139d000 (size 2048):
>   comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
>     [<0000000098b7c90a>] __check_func_call+0x316/0x1230
>     [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
>     [<00000000aa3875b7>] do_check+0x21d8/0x45e0
>     [<000000001147357b>] do_check_common+0x767/0xaf0
>     [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
>     [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
>     [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
>     [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
>     [<00000000946ee250>] do_syscall_64+0x3b/0x90
>     [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The root case here is: In function prepare_func_exit(), the callee is
> not released in the abnormal scenario after "state->curframe--;".
>
> In addition, function __check_func_call() has a similar problem. In
> the abnormal scenario before "state->curframe++;", the callee is alse
> not released.

For prepare_func_exit, wouldn't it be correct and cleaner to just move
state->curframe--; to the very bottom of the function, right when we
free callee and reset frame[] pointer to NULL?

For __check_func_call, please use err_out label name to disambiguate
it from the "err" variable.

>
> Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  kernel/bpf/verifier.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>

[...]
