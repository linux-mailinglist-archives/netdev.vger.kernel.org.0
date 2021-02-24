Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FC33241FC
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhBXQVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbhBXQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 11:19:20 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547A1C061793
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:18:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o63so1764734pgo.6
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=lteuOHvfo4K4/+NJPA032TcNQF+JRBgKzkoDcHJYOeU=;
        b=uCCBhDCiEOSzFvDq8hugaWh/4pBpmUkUgVRmolQ8lW0uFuHMzJvGIgmPL4r8kj3n2l
         01nDGBc4uXPWXEBYFUYjKC5zR2diGc96pCYSa0TJ7bJo3Ll38Y0hEMSXhUYacQW9v9Xx
         am3Z3d5h+oL9sffF9MC+Op2fdaEek0PJThOjiCXJf1hng3UAcrancae4fy52JJP46G5L
         J4eofy0ONPNKGBqSVa4T8n11S/TvXgpMsVDaxDBMnt/6ykECd71r5+E+Ku4bkyvdDKyY
         3MifsS3qqXObyJaomc97p6GiRN+AdOg1lMBqiURpgnS0szSIBhq4vkR6lu00kdBWQitB
         Yliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=lteuOHvfo4K4/+NJPA032TcNQF+JRBgKzkoDcHJYOeU=;
        b=dN6wu8NtPQ0ze+dIi/9XnMf1qEuHHig5SRVOGicjR2gsMYcLUzHNooQY83BwV3gc7t
         zXFKXMhiyTJvDlcJ24chdBgGoceEvNtswegsCThEesv6M4c+5hOvPxhKFZnMUWV6NKX8
         eP/QkXGxDis8G8vj7mHwSw5jsKiXbdojG+CJ8mzSP0MyVYVOlQoe0+Xui0Oy7GHPDU5J
         MqPXFB5qnem7/xd7Lku8WdFFsyjycSql0b6qN5RBoL5x2X8fEUoyGJKjHzU7KlOOo8fi
         YU9fSJDAIBiApyP5NY+arRYLAwcLAUpQUUC3LKvRcn/sxf+g8cYm111kxQemLdGpW7p3
         Hv1A==
X-Gm-Message-State: AOAM531KxG7DuBGup1Mkm8qCs/NCAPfiQwORZEegjWH419dcRrFPABzr
        uNyxyjbCFmwxs1IEvBBR6KE3tQ==
X-Google-Smtp-Source: ABdhPJyDwLpbyvL71TWNq5m3Blk+xEoWJgoXaTBodv14KeO97PF/M4n3D1ftcLakL1bJecWKk1RjlA==
X-Received: by 2002:a63:db08:: with SMTP id e8mr29626323pgg.261.1614183518749;
        Wed, 24 Feb 2021 08:18:38 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:f023:34a9:302a:60b6? ([2601:646:c200:1ef2:f023:34a9:302a:60b6])
        by smtp.gmail.com with ESMTPSA id v4sm3283538pjo.32.2021.02.24.08.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 08:18:37 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3] seccomp: Improve performace by optimizing rmb()
Date:   Wed, 24 Feb 2021 08:18:36 -0800
Message-Id: <638D44BA-0ACA-4041-8213-217233656A70@amacapital.net>
References: <1614156585-18842-1-git-send-email-wanghongzhe@huawei.com>
Cc:     keescook@chromium.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, wad@chromium.org, yhs@fb.com,
        tongxiaomeng@huawei.com
In-Reply-To: <1614156585-18842-1-git-send-email-wanghongzhe@huawei.com>
To:     wanghongzhe <wanghongzhe@huawei.com>
X-Mailer: iPhone Mail (18D52)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 24, 2021, at 12:03 AM, wanghongzhe <wanghongzhe@huawei.com> wrote:
>=20
> =EF=BB=BFAs Kees haved accepted the v2 patch at a381b70a1 which just
> replaced rmb() with smp_rmb(), this patch will base on that and just adjus=
t
> the smp_rmb() to the correct position.
>=20
> As the original comment shown (and indeed it should be):
>   /*
>    * Make sure that any changes to mode from another thread have
>    * been seen after SYSCALL_WORK_SECCOMP was seen.
>    */
> the smp_rmb() should be put between reading SYSCALL_WORK_SECCOMP and readi=
ng
> seccomp.mode to make sure that any changes to mode from another thread hav=
e
> been seen after SYSCALL_WORK_SECCOMP was seen, for TSYNC situation. Howeve=
r,
> it is misplaced between reading seccomp.mode and seccomp->filter. This iss=
ue
> seems to be misintroduced at 13aa72f0fd0a9f98a41cefb662487269e2f1ad65 whic=
h
> aims to refactor the filter callback and the API. So let's just adjust the=

> smp_rmb() to the correct position.
>=20
> A next optimization patch will be provided if this ajustment is appropriat=
e.

Would it be better to make the syscall work read be smp_load_acquire()?

>=20
> v2 -> v3:
> - move the smp_rmb() to the correct position
>=20
> v1 -> v2:
> - only replace rmb() with smp_rmb()
> - provide the performance test number
>=20
> RFC -> v1:
> - replace rmb() with smp_rmb()
> - move the smp_rmb() logic to the middle between TIF_SECCOMP and mode
>=20
> Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
> ---
> kernel/seccomp.c | 15 +++++++--------
> 1 file changed, 7 insertions(+), 8 deletions(-)
>=20
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 1d60fc2c9987..64b236cb8a7f 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1160,12 +1160,6 @@ static int __seccomp_filter(int this_syscall, const=
 struct seccomp_data *sd,
>    int data;
>    struct seccomp_data sd_local;
>=20
> -    /*
> -     * Make sure that any changes to mode from another thread have
> -     * been seen after SYSCALL_WORK_SECCOMP was seen.
> -     */
> -    smp_rmb();
> -
>    if (!sd) {
>        populate_seccomp_data(&sd_local);
>        sd =3D &sd_local;
> @@ -1291,7 +1285,6 @@ static int __seccomp_filter(int this_syscall, const s=
truct seccomp_data *sd,
>=20
> int __secure_computing(const struct seccomp_data *sd)
> {
> -    int mode =3D current->seccomp.mode;
>    int this_syscall;
>=20
>    if (IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) &&
> @@ -1301,7 +1294,13 @@ int __secure_computing(const struct seccomp_data *s=
d)
>    this_syscall =3D sd ? sd->nr :
>        syscall_get_nr(current, current_pt_regs());
>=20
> -    switch (mode) {
> +    /*=20
> +     * Make sure that any changes to mode from another thread have
> +     * been seen after SYSCALL_WORK_SECCOMP was seen.
> +     */
> +    smp_rmb();
> +
> +    switch (current->seccomp.mode) {
>    case SECCOMP_MODE_STRICT:
>        __secure_computing_strict(this_syscall);  /* may call do_exit */
>        return 0;
> --=20
> 2.19.1
>=20
