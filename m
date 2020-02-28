Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95866173FEC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1Srj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:47:39 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42730 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Sri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:47:38 -0500
Received: by mail-ed1-f66.google.com with SMTP id n18so4505485edw.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bixkltK37SuvF8+QrZT7cyy3fpESWGz1eL1+F5j0LEc=;
        b=epMwvqt8qOHhN1GLgKCLpg2G+VQyc9awC/hIP+yW78zudAXqvKfKCCaol4y/REooi6
         PHZFGdvu3eEaBiaBvhR9Q553dTmxNveezmdoaL6wzGuU3pRI6JwiglpNscaepSntFXRw
         3ZOhLLlydvStxfx044R1i2AAxiX53Q6zYkcLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bixkltK37SuvF8+QrZT7cyy3fpESWGz1eL1+F5j0LEc=;
        b=M9dQN4gUWtdAbcKl3M4CdltGXsw7Mgm4a6no/K1gLglN8UwlMbyiXXZhHDrXS1FufL
         hQp/aaEr1PL7x3I9dtQJZ0fS/HSKGumNNdulnzhOoEWd104xtTwdnbtiY28ooNVap0S0
         V65WM+7+DqXa3Kgb45dMLV4++j4UFD6FW+c1h7pkUDQOrnhuy+n+d2woTEVF/6ou0awF
         DFfn50RKkut/swI/s84h9UpTCHy5zVI+yNEVazya3xWz+HQV7ru43oPVS7ryH6JHvcoS
         k8ThvN/rFWOzJGTBrSDJMMpIWtk06LmoSTuboL2MrZfbHz/5S3t0BipIMdJ94sx4TFqG
         M2cg==
X-Gm-Message-State: APjAAAVw7M7BQ404ywxTST01PpDVqGgZawzOHRTpA7KPp8TqBVchjtT9
        vsT5JoyxQl/2UhnVv9yVowvbNVPsCdrHr1UfwjCH4Q==
X-Google-Smtp-Source: APXvYqxd0pd2uulOum9GJ4AQBWcLSSQghVJZd2LsTK+vBTTn3CQhL0Tam9NYxIlOg9W+BE3f82oG0A8ivSJ/rz0EoLs=
X-Received: by 2002:a17:906:c828:: with SMTP id dd8mr5429785ejb.382.1582915655273;
 Fri, 28 Feb 2020 10:47:35 -0800 (PST)
MIME-Version: 1.0
References: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
In-Reply-To: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 28 Feb 2020 10:54:44 -0800
Message-ID: <CAJieiUgj5Ho+_OndvVN1a40Fc_4z+BFwwY_hwOJjpb0H7K0oAQ@mail.gmail.com>
Subject: Re: [PATCH] ip route: Do not imply pref and ttl-propagate are per nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 5:12 AM Donald Sharp <sharpd@cumulusnetworks.com> wrote:
>
> Currently `ip -6 route show` gives us this output:
>
> sharpd@eva ~/i/ip (master)> ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1 pref medium
>
> Displaying `pref medium` as the last bit of output implies
> that the RTA_PREF is a per nexthop value, when it is infact
> a per route piece of data.
>
> Change the output to display RTA_PREF and RTA_TTL_PROPAGATE
> before the RTA_MULTIPATH data is shown:
>
> sharpd@eva ~/i/ip (master)> ./ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20 pref medium
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1
>
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>


Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>


> ---
>  ip/iproute.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 93b805c9..07c45169 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -933,9 +933,6 @@ int print_route(struct nlmsghdr *n, void *arg)
>         if (tb[RTA_IIF] && filter.iifmask != -1)
>                 print_rta_if(fp, tb[RTA_IIF], "iif");
>
> -       if (tb[RTA_MULTIPATH])
> -               print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
> -
>         if (tb[RTA_PREF])
>                 print_rt_pref(fp, rta_getattr_u8(tb[RTA_PREF]));
>
> @@ -951,6 +948,14 @@ int print_route(struct nlmsghdr *n, void *arg)
>                                      propagate ? "enabled" : "disabled");
>         }
>
> +       if (tb[RTA_MULTIPATH])
> +               print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
> +
> +       /* If you are adding new route RTA_XXXX then place it above
> +        * the RTA_MULTIPATH else it will appear that the last nexthop
> +        * in the ECMP has new attributes
> +        */
> +
>         print_string(PRINT_FP, NULL, "\n", NULL);
>         close_json_object();
>         fflush(fp);
> --
> 2.25.0
>
