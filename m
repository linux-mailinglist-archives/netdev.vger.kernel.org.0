Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FD048187B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhL3CXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhL3CXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:23:32 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBB2C061574;
        Wed, 29 Dec 2021 18:23:31 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z3so17213741plg.8;
        Wed, 29 Dec 2021 18:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lEWqHLR4IbqmlBub+ds0nLFhZFaT8QHa3CHLgWRdNYQ=;
        b=IRZEbk/DyfJWRqe1VSMQp73XOpSGUbcWUbGFdem/qkvNp1kRZ/Xh1q33wCDL7zYNxP
         OqoJJo7C1hZMOW4VrYjljZ89OBfVit06BNK96VhQZhz7OaQaJS/iN0dZBgV0ZrdKsUJr
         VRF3ll/LgPu8Qna/wABxvr0xgowFOFa6syuGNDoUZp4uV7Bit2l7j3WvWQXRWty06HGf
         m13xflQtmT7B79KS/3KM6q+BLJEuzSD1XncZMA5VuSxLuCHcddRnpe2DO96c3K8enGHC
         Fp6O15fcMdGw1bmGJ5WSjHAjluJLrjT+9e+ynwD3vEC0ND/cw0DN3qRqT8MIwnQUclZF
         sINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lEWqHLR4IbqmlBub+ds0nLFhZFaT8QHa3CHLgWRdNYQ=;
        b=oXwp8At3DVgweN4/DnO+8MmJ7qjVklb3GZFZo0P5QB2NwPsQ9169/2Nv67bIBtQ5et
         RAIebGxnik1rRpKDV0FOPrmPKTf7JpHe6KO4EHD76vfIGEqOtDeq49snX4UOypTbUUcx
         OKkS6iKAMfr0a6X408ZQEVcHCEZ6aMCG0Gn7MMgFPpmpwoRk2JjKR/ScpP354DuEG1S7
         Yx8/dJWeFCvqNBYfu0/SQT04MCHjMEnSwrhl9i3FJG+8cB5VmYq/gNgf3qb5a3p0EUu6
         B1wvq1HRy6Jo041jH/8RNXsVIDduxDQjAk8r80VSetmdS3hvr/kS0w073t0bwnAtapsT
         xcXg==
X-Gm-Message-State: AOAM5320yB/R4g5f7zYGgM7ZVTxS+ZgceGhZo2Yxjs3AY+nvTP+uiEPm
        PG6hF52oF5Hz7fSvu6m78IdrFtih40rMrNgp7wo3BBy3
X-Google-Smtp-Source: ABdhPJyHOpWlkk7qZxz67djBEUddHIaDK483V/PDfCyokLdVZ6UjTrykwApssiW+KlWfsis6k9iFsbivlvIqF86sh4s=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr35496747pjz.122.1640831011288;
 Wed, 29 Dec 2021 18:23:31 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
In-Reply-To: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 18:23:20 -0800
Message-ID: <CAADnVQJK5mPOB7B4KBa6q1NRYVQx1Eya5mtNb6=L0p-BaCxX=w@mail.gmail.com>
Subject: Re: A slab-out-of-bounds Read bug in __htab_map_lookup_and_delete_batch
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 2:10 AM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> Hi, there is a slab-out-bounds Read bug in
> __htab_map_lookup_and_delete_batch in kernel/bpf/hashtab.c
> and I reproduce it in linux-5.16.rc7(upstream) and latest linux-5.15.11.
>
> #carsh log
> [  166.945208][ T6897]
> ==================================================================
> [  166.947075][ T6897] BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x87/0xb0
> [  166.948612][ T6897] Read of size 49 at addr ffff88801913f800 by
> task __htab_map_look/6897
> [  166.950406][ T6897]
> [  166.950890][ T6897] CPU: 1 PID: 6897 Comm: __htab_map_look Not
> tainted 5.16.0-rc7+ #30
> [  166.952521][ T6897] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> [  166.954562][ T6897] Call Trace:
> [  166.955268][ T6897]  <TASK>
> [  166.955918][ T6897]  dump_stack_lvl+0x57/0x7d
> [  166.956875][ T6897]  print_address_description.constprop.0.cold+0x93/0x347
> [  166.958411][ T6897]  ? _copy_to_user+0x87/0xb0
> [  166.959356][ T6897]  ? _copy_to_user+0x87/0xb0
> [  166.960272][ T6897]  kasan_report.cold+0x83/0xdf
> [  166.961196][ T6897]  ? _copy_to_user+0x87/0xb0
> [  166.962053][ T6897]  kasan_check_range+0x13b/0x190
> [  166.962978][ T6897]  _copy_to_user+0x87/0xb0
> [  166.964340][ T6897]  __htab_map_lookup_and_delete_batch+0xdc2/0x1590
> [  166.965619][ T6897]  ? htab_lru_map_update_elem+0xe70/0xe70
> [  166.966732][ T6897]  bpf_map_do_batch+0x1fa/0x460
> [  166.967619][ T6897]  __sys_bpf+0x99a/0x3860
> [  166.968443][ T6897]  ? bpf_link_get_from_fd+0xd0/0xd0
> [  166.969393][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [  166.970425][ T6897]  ? lock_acquire+0x1ab/0x520
> [  166.971284][ T6897]  ? find_held_lock+0x2d/0x110
> [  166.972208][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [  166.973139][ T6897]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  166.974096][ T6897]  __x64_sys_bpf+0x70/0xb0
> [  166.974903][ T6897]  ? syscall_enter_from_user_mode+0x21/0x70
> [  166.976077][ T6897]  do_syscall_64+0x35/0xb0
> [  166.976889][ T6897]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  166.978027][ T6897] RIP: 0033:0x450f0d
>
>
> In hashtable, if the elements' keys have the same jhash() value, the
> elements will be put into the same bucket.
> By putting a lot of elements into a single bucket, the value of
> bucket_size can be increased to overflow.
>  but also we can increase bucket_cnt to out of bound Read.

Can you be more specific?
If you can send a patch with a fix it would be even better.

> the out of bound Read in  __htab_map_lookup_and_delete_batch code:
> ```
> ...
> if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
> key_size * bucket_cnt) ||
>     copy_to_user(uvalues + total * value_size, values,
>     value_size * bucket_cnt))) {
> ret = -EFAULT;
> goto after_loop;
> }
> ...
> ```
>
> Regards,
>  butt3rflyh4ck.
>
>
> --
> Active Defense Lab of Venustech
