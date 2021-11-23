Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E716845A392
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhKWNWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:22:54 -0500
Received: from mail-oo1-f46.google.com ([209.85.161.46]:43647 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbhKWNWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:22:52 -0500
Received: by mail-oo1-f46.google.com with SMTP id w5-20020a4a2745000000b002c2649b8d5fso6966387oow.10;
        Tue, 23 Nov 2021 05:19:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sxbm5nZuxDktECFOUcgXGTkmQEJlkXm+UQAvKfd0Kcw=;
        b=mvIZSRRstoDDJUR3+mmLSzn8fqBURUL2JlI4/Frf4C5a1N1wjF+v56uIhWx1YQ6hIU
         2dRlJni8qcx7RNXE/GL3pu+VAv4UTqUgv0o0BPxl1qPIMETntN/kFAcnpoZUrd76KegU
         EKQW2pSud38zRmUCW7u3aRvEpqa57hx5kLNxJpFfSThGzmmlFeGfKmPN1gM2ntWdyv6r
         2K2zy/YtYJXicIGjMq8lQO4aP9dlCmJCRrZ18lWH4dxrRs0a7kbT707/Ermt9GwlRTOZ
         iHZj2FfFaNhu+t2/hEMpJXlTJejai2RmZvQ9M4xDAe0JogPrmv2xKN1LX2XKwKVhUUIN
         EpOg==
X-Gm-Message-State: AOAM531CX/cyV9bldIBySkzO0zA6rfPkTAyy3w7GuJYD/LNAvoOh+1Pk
        WbbJ3XOnhaH2aQ5OION/ViKK3GF1OW9tVoWM0vM=
X-Google-Smtp-Source: ABdhPJx4LJPjPNqz/sXcVDWL5tamzih4SOz6Sq7UGTbN97hIVt3zgoG90+osvpCrjRpDoZ3z/WaeE3Jdprr6Jm1J/tY=
X-Received: by 2002:a4a:1d82:: with SMTP id 124mr2868847oog.91.1637673583839;
 Tue, 23 Nov 2021 05:19:43 -0800 (PST)
MIME-Version: 1.0
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-13-keescook@chromium.org>
In-Reply-To: <20210818060533.3569517-13-keescook@chromium.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 23 Nov 2021 14:19:25 +0100
Message-ID: <CAJZ5v0iS3qMgdab1S-NzGfeLLXV=S6p5Qx8AaqJ50rsUngS=LA@mail.gmail.com>
Subject: Re: [PATCH v2 12/63] thermal: intel: int340x_thermal: Use
 struct_group() for memcpy() region
To:     Kees Cook <keescook@chromium.org>, Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 8:08 AM Kees Cook <keescook@chromium.org> wrote:
>
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), avoid intentionally writing across
> neighboring fields.
>
> Use struct_group() in struct art around members weight, and ac[0-9]_max,
> so they can be referenced together. This will allow memcpy() and sizeof()
> to more easily reason about sizes, improve readability, and avoid future
> warnings about writing beyond the end of weight.
>
> "pahole" shows no size nor member offset changes to struct art.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences).
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Rui, Srinivas, any comments here?

> ---
>  .../intel/int340x_thermal/acpi_thermal_rel.c  |  5 +-
>  .../intel/int340x_thermal/acpi_thermal_rel.h  | 48 ++++++++++---------
>  2 files changed, 29 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> index a478cff8162a..e90690a234c4 100644
> --- a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> +++ b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> @@ -250,8 +250,9 @@ static int fill_art(char __user *ubuf)
>                 get_single_name(arts[i].source, art_user[i].source_device);
>                 get_single_name(arts[i].target, art_user[i].target_device);
>                 /* copy the rest int data in addition to source and target */
> -               memcpy(&art_user[i].weight, &arts[i].weight,
> -                       sizeof(u64) * (ACPI_NR_ART_ELEMENTS - 2));
> +               BUILD_BUG_ON(sizeof(art_user[i].data) !=
> +                            sizeof(u64) * (ACPI_NR_ART_ELEMENTS - 2));
> +               memcpy(&art_user[i].data, &arts[i].data, sizeof(art_user[i].data));
>         }
>
>         if (copy_to_user(ubuf, art_user, art_len))
> diff --git a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> index 58822575fd54..78d942477035 100644
> --- a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> +++ b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> @@ -17,17 +17,19 @@
>  struct art {
>         acpi_handle source;
>         acpi_handle target;
> -       u64 weight;
> -       u64 ac0_max;
> -       u64 ac1_max;
> -       u64 ac2_max;
> -       u64 ac3_max;
> -       u64 ac4_max;
> -       u64 ac5_max;
> -       u64 ac6_max;
> -       u64 ac7_max;
> -       u64 ac8_max;
> -       u64 ac9_max;
> +       struct_group(data,
> +               u64 weight;
> +               u64 ac0_max;
> +               u64 ac1_max;
> +               u64 ac2_max;
> +               u64 ac3_max;
> +               u64 ac4_max;
> +               u64 ac5_max;
> +               u64 ac6_max;
> +               u64 ac7_max;
> +               u64 ac8_max;
> +               u64 ac9_max;
> +       );
>  } __packed;
>
>  struct trt {
> @@ -47,17 +49,19 @@ union art_object {
>         struct {
>                 char source_device[8]; /* ACPI single name */
>                 char target_device[8]; /* ACPI single name */
> -               u64 weight;
> -               u64 ac0_max_level;
> -               u64 ac1_max_level;
> -               u64 ac2_max_level;
> -               u64 ac3_max_level;
> -               u64 ac4_max_level;
> -               u64 ac5_max_level;
> -               u64 ac6_max_level;
> -               u64 ac7_max_level;
> -               u64 ac8_max_level;
> -               u64 ac9_max_level;
> +               struct_group(data,
> +                       u64 weight;
> +                       u64 ac0_max_level;
> +                       u64 ac1_max_level;
> +                       u64 ac2_max_level;
> +                       u64 ac3_max_level;
> +                       u64 ac4_max_level;
> +                       u64 ac5_max_level;
> +                       u64 ac6_max_level;
> +                       u64 ac7_max_level;
> +                       u64 ac8_max_level;
> +                       u64 ac9_max_level;
> +               );
>         };
>         u64 __data[ACPI_NR_ART_ELEMENTS];
>  };
> --
> 2.30.2
>
