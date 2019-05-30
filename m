Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4835F2F894
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfE3Iac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:30:32 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43039 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfE3IaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:30:25 -0400
Received: by mail-oi1-f195.google.com with SMTP id t187so4286791oie.10
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 01:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzcNV6SW+Xh9Ya8lDxl+0yI6Dw+WGyclNEKNTVCp8nU=;
        b=R6+KBMb0MHd3+pjsrAVLinun9naTKHYUJ0MxZjxnPRQGZmo6z86wogO/FTLYGG/okH
         KXEDlBj2GBvQ/JlCmT1KGrJTERkrRwmv83Qfjy0VE/qt5vVeyf39/zCF4NRW30B9InWa
         KZD6wBZEaKHJgNhqkEWI+cF2y2H4o2vr6c/m23chdOJhW6xZoDiO5kmfFKKAMEHPsVvA
         9/yK8yQvKUyPjFlc4Xy0M8wk58A4FkKdxixYNeHy1W/zF1D6dsJ1pDqh/e9ABVRg8riD
         dc3grEm2VNWdC8N6FQxuF8Jnqvynn4zvFFI1UiDIklmBYuUagtNYvSpsicR0f1FMNix5
         RE6g==
X-Gm-Message-State: APjAAAXYtXW7wCT2aIokuSGekCNU2Cb5nUn8lhRdAv7qIjQsflkK8O9U
        3LyYDrsmaxjfL1IjSFGiXBOIoGfIIBcDmyEUX72TFg==
X-Google-Smtp-Source: APXvYqzTv07K7SADdE55dDI77M75/XjvtsqUSGRV/r+pWOj/1v586YQ0cf99vI+eQ/N2XWS6ZrVc5NOYVULd8c/HKfw=
X-Received: by 2002:aca:e887:: with SMTP id f129mr1752282oih.156.1559205024714;
 Thu, 30 May 2019 01:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190530080602.GA3600@zhanggen-UX430UQ>
In-Reply-To: <20190530080602.GA3600@zhanggen-UX430UQ>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 30 May 2019 10:30:17 +0200
Message-ID: <CAFqZXNtX1R1VDFxm7Jco3BZ=pVnNiHU3-C=d8MhCVV1XSUQ8bw@mail.gmail.com>
Subject: Re: [PATCH] hooks: fix a missing-check bug in selinux_add_mnt_opt()
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, ccross@android.com,
        selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:06 AM Gen Zhang <blackgod016574@gmail.com> wrote:
> In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
> NULL when fails. So 'val' should be checked.
>
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

Please add a Fixes tag here, too:

Fixes: 757cbe597fe8 ("LSM: new method: ->sb_add_mnt_opt()")

> ---
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702c..4797c63 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1052,8 +1052,11 @@ static int selinux_add_mnt_opt(const char *option, const char *val, int len,
>         if (token == Opt_error)
>                 return -EINVAL;
>
> -       if (token != Opt_seclabel)
> -               val = kmemdup_nul(val, len, GFP_KERNEL);
> +       if (token != Opt_seclabel) {
> +                       val = kmemdup_nul(val, len, GFP_KERNEL);
> +                       if (!val)
> +                               return -ENOMEM;

There is one extra tab character in the above three lines ^^^

> +       }
>         rc = selinux_add_opt(token, val, mnt_opts);
>         if (unlikely(rc)) {
>                 kfree(val);

Thanks,

--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
