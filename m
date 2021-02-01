Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9695630ABB3
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBAPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbhBAPky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:40:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE10C061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 07:39:19 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9so2593670pjl.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 07:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=PXC9eT33XzY/s4/vcYqNkyG5cAOxeL/xc7nss0BbEbE=;
        b=VfHp/waiZVqG2VDLYSCVYni+7TYwgejrhlmjxrZQPg/myt0JuK1hvsksaPeX56eouz
         YvaYjD76uTNSZTgRc9lSDkf3hskX7knWLkL3VgZvzyUEj1HLUwrZN136fb01ZQsB6cJy
         /2KgJLegnL/j+w8LwgrSldhKBFFTxAYqyWKmAJdixHeEtH7IoT47lkeIfmAUUbbuU1RD
         K/mhF1z6uYSFrY29pcvya2Z8d5G84IuRs5jdkPRJkmGZGKtq0yE0LnsNua3aDp31ktje
         dye2sTlibbtSQ5yspjGveBvKwIQyPlQRz56GvoIA0YtnvtRWhwygEv5yt9otMSiFou6w
         LnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=PXC9eT33XzY/s4/vcYqNkyG5cAOxeL/xc7nss0BbEbE=;
        b=IigA5CrbxlRELVu1tswifV2/742L3MScrVq0XSHNX0SzzmXRxP+1+YJ/aU+qy0YAbT
         zau9+/0Yl/wyYbHuksP0WG+bPB8NEusGrrfBU0vSg3GtPlvVvIol+8506INusju95Ydc
         8X6kPokuRi/ZngHMadKYxrFGEhsPOTFnAHXXGZn5MJKBRhgDm/LMfmhUwKwRGfVIEKUL
         6/cfhtIfTHQ+k06bwDtDzOcr6Rg5DcH5USxZdc044+/4AZi16Q1qEwAPQPEoCNvAfQWr
         cN3ySaYklfkXGnMmYiLl+jgGG81qAK30KvhuOY6KPWn0crEn7QRr7Wq8RPnkSx7DN/12
         Ayqg==
X-Gm-Message-State: AOAM532TV2hnxI/pdvvX8Ivdwa583wsBIG1D0aTZxWjxH0vqZll22nTb
        kC0EnXfjTsG/R3QLUg03368JPw==
X-Google-Smtp-Source: ABdhPJwue7vFFQ464PTMfBB6M+kFjxBcFe9G0nU2E0WWVBkUYxVCp/LHVgQR2W3uryeS6UoegxhGVg==
X-Received: by 2002:a17:902:b116:b029:e1:58b2:2280 with SMTP id q22-20020a170902b116b02900e158b22280mr5849921plr.29.1612193958610;
        Mon, 01 Feb 2021 07:39:18 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:7d9a:44be:c6b1:962b? ([2601:646:c200:1ef2:7d9a:44be:c6b1:962b])
        by smtp.gmail.com with ESMTPSA id w66sm18563296pfd.48.2021.02.01.07.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 07:39:17 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] seccomp: Improve performance by optimizing memory barrier
Date:   Mon, 1 Feb 2021 07:39:16 -0800
Message-Id: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
References: <1612183830-15506-1-git-send-email-wanghongzhe@huawei.com>
Cc:     keescook@chromium.org, wad@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <1612183830-15506-1-git-send-email-wanghongzhe@huawei.com>
To:     wanghongzhe <wanghongzhe@huawei.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 1, 2021, at 4:06 AM, wanghongzhe <wanghongzhe@huawei.com> wrote:
>=20
> =EF=BB=BFIf a thread(A)'s TSYNC flag is set from seccomp(), then it will
> synchronize its seccomp filter to other threads(B) in same thread
> group. To avoid race condition, seccomp puts rmb() between
> reading the mode and filter in seccomp check patch(in B thread).
> As a result, every syscall's seccomp check is slowed down by the
> memory barrier.
>=20
> However, we can optimize it by calling rmb() only when filter is
> NULL and reading it again after the barrier, which means the rmb()
> is called only once in thread lifetime.
>=20
> The 'filter is NULL' conditon means that it is the first time
> attaching filter and is by other thread(A) using TSYNC flag.
> In this case, thread B may read the filter first and mode later
> in CPU out-of-order exection. After this time, the thread B's
> mode is always be set, and there will no race condition with the
> filter/bitmap.
>=20
> In addtion, we should puts a write memory barrier between writing
> the filter and mode in smp_mb__before_atomic(), to avoid
> the race condition in TSYNC case.

I haven=E2=80=99t fully worked this out, but rmb() is bogus. This should be s=
mp_rmb().

>=20
> Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
> ---
> kernel/seccomp.c | 31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)
>=20
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 952dc1c90229..b944cb2b6b94 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -397,8 +397,20 @@ static u32 seccomp_run_filters(const struct seccomp_d=
ata *sd,
>            READ_ONCE(current->seccomp.filter);
>=20
>    /* Ensure unexpected behavior doesn't result in failing open. */
> -    if (WARN_ON(f =3D=3D NULL))
> -        return SECCOMP_RET_KILL_PROCESS;
> +    if (WARN_ON(f =3D=3D NULL)) {
> +        /*
> +         * Make sure the first filter addtion (from another
> +         * thread using TSYNC flag) are seen.
> +         */
> +        rmb();
> +       =20
> +        /* Read again */
> +        f =3D READ_ONCE(current->seccomp.filter);
> +
> +        /* Ensure unexpected behavior doesn't result in failing open. */
> +        if (WARN_ON(f =3D=3D NULL))
> +            return SECCOMP_RET_KILL_PROCESS;
> +    }
>=20
>    if (seccomp_cache_check_allow(f, sd))
>        return SECCOMP_RET_ALLOW;
> @@ -614,9 +626,16 @@ static inline void seccomp_sync_threads(unsigned long=
 flags)
>         * equivalent (see ptrace_may_access), it is safe to
>         * allow one thread to transition the other.
>         */
> -        if (thread->seccomp.mode =3D=3D SECCOMP_MODE_DISABLED)
> +        if (thread->seccomp.mode =3D=3D SECCOMP_MODE_DISABLED) {
> +            /*
> +             * Make sure mode cannot be set before the filter
> +             * are set.
> +             */
> +            smp_mb__before_atomic();
> +
>            seccomp_assign_mode(thread, SECCOMP_MODE_FILTER,
>                        flags);
> +        }
>    }
> }
>=20
> @@ -1160,12 +1179,6 @@ static int __seccomp_filter(int this_syscall, const=
 struct seccomp_data *sd,
>    int data;
>    struct seccomp_data sd_local;
>=20
> -    /*
> -     * Make sure that any changes to mode from another thread have
> -     * been seen after SYSCALL_WORK_SECCOMP was seen.
> -     */
> -    rmb();
> -
>    if (!sd) {
>        populate_seccomp_data(&sd_local);
>        sd =3D &sd_local;
> --=20
> 2.19.1
>=20
