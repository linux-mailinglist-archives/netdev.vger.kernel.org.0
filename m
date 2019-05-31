Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD431184
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEaPpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:45:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35724 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfEaPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:45:42 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so8302500lfg.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/DZt8luZx8AZd+g3OwucXhV/souOkAqU6IAlufN+JIw=;
        b=fRr515esaIOr8mkEww0IKDtMKmNftE282RImc1BVF4NJkoyzWycXVzqJGvuIhA4tRg
         yGD98Ugj6GLQCyZr2JaDPuomsu1bWjRPzuDOz5QxW4SEF/qpmGwOeTDYHxJmmhOgcpvh
         YTD8txi1NP7Tf93arKTMnQTYJzJOeBgEcuaR9Nk9UIfApiKPLOM9OKvKzoFI65b+en8G
         mqoQU8m/U/4AUlvwyEhuXXJiWSMQGVpS8baWkvBUint97bO4se4HJHQ4vXPI0pA6nHPM
         QiOQRZe0fXT8C240IXihy/Ku1XNTcuFvmFzZNCsaPzcfS7NIiVdploSAO975KD9bFmyl
         O+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/DZt8luZx8AZd+g3OwucXhV/souOkAqU6IAlufN+JIw=;
        b=SywPulr9NFDVaMkUAE+JF5LKLPm5xVP8SwFNsECthJIJRsh00eY7YSd+pcbqy04hwe
         4074ZHCWjMtI9n5Mi7o1hKrY/to8T8/P7erQFVX2W7xQPcIQCabJMB5gw0hxoTGdC8Lx
         TA9ecnSWofjqVJ30Xdo7FWkxj6Fyemv/Bkbs9CxqTEc2IBZGbrnJexBChwUZSWAaBhuW
         d/ZjnDVRjRczUScO3weUDr163mWJ2V5ufzghqYJZOQOsSuNS+WfCkW3cSUfVd7w67GfE
         xxxU87i0B9upPMevM92Yn0+F6MM92mk4c3mGN1QZk3C69xuBw9sijy0w7nHYw3szHuGk
         7Dpw==
X-Gm-Message-State: APjAAAULd+eTwYQ1Y562vsIHlAZiJP9mr86MRZri/8KtA1HC3Q0OGyYt
        A7R9WeHpE86+iWVAzCgV3CNZm4ZQf1x4sFgB/fVg
X-Google-Smtp-Source: APXvYqzFztIsHezNj4wOvdAK/eHaIBSHz130vzxCSTL8AZkALwTZeT3dQxZbC5UR86jbnMY3vWbN4D58tPPMshgs18U=
X-Received: by 2002:a19:c301:: with SMTP id t1mr6164138lff.137.1559317540060;
 Fri, 31 May 2019 08:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190531013350.GA4642@zhanggen-UX430UQ>
In-Reply-To: <20190531013350.GA4642@zhanggen-UX430UQ>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 31 May 2019 11:45:28 -0400
Message-ID: <CAHC9VhTmj8b9jYMaXd=ORhBgTAWUgF=srgqAXkECe7MFkDXOmg@mail.gmail.com>
Subject: Re: [PATCH v2] hooks: fix a missing-check bug in selinux_sb_eat_lsm_opts()
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, omosnace@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 9:34 PM Gen Zhang <blackgod016574@gmail.com> wrote:
>
> In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> returns NULL when fails. So 'arg' should be checked.
>
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> Fixes: 99dbbb593fe6 ("selinux: rewrite selinux_sb_eat_lsm_opts()")

One quick note about the subject line, instead of using "hooks:" you
should use "selinux:" since this is specific to SELinux.  If the patch
did apply to the LSM framework as a whole, I would suggest using
"lsm:" instead of "hooks:" as "hooks" is too ambiguous of a prefix.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702c..5a9e959 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2635,6 +2635,8 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
>                                                 *q++ = c;
>                                 }
>                                 arg = kmemdup_nul(arg, q - arg, GFP_KERNEL);
> +                               if (!arg)
> +                                       return -ENOMEM;

It seems like we should also check for, and potentially free *mnt_opts
as the selinux_add_opt() error handling does just below this change,
yes?  If that is the case we might want to move that error handling
code to the bottom of the function and jump there on error.

>                         }
>                         rc = selinux_add_opt(token, arg, mnt_opts);
>                         if (unlikely(rc)) {

-- 
paul moore
www.paul-moore.com
