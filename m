Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A113D2E8B2E
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 07:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhACGcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 01:32:21 -0500
Received: from conssluserg-03.nifty.com ([210.131.2.82]:34119 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbhACGcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 01:32:21 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 1036V9GQ027664;
        Sun, 3 Jan 2021 15:31:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 1036V9GQ027664
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1609655469;
        bh=f5iEqiep2UuWsTl/6wtQ4qnhwNXKGbskFSoikG9gKU8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1Woh/nj/aACSW/QexxoC56oqet3p1u70XpbRAJCB4uyUsnSaqFClgj4ZCIPBxm46F
         oNluJb93CKGM8a/uw1WknI1qqDjev0+BdSg9H/VbUIaEUnL4adqPoeaebKcdbBj7Kq
         x/LVLT9hcjyxoxuDmPzWTVgWcqtotTChlBpljgaVbXbqpa++hvNy34eFqt9crP9Hrf
         n/KFOThELqefgZ8QpKzB75nibswzw3VW6kL4ByEjF8SJ5yuP/iekYrERJx3Ld2urHR
         k77U+m5/4ZPnpMqG8IUnzUTLobKUmNk9p961oX+UVpFvThF8qsHereXSjK9R4PtBb7
         NeQQtsV04fZCg==
X-Nifty-SrcIP: [209.85.215.174]
Received: by mail-pg1-f174.google.com with SMTP id n10so16703099pgl.10;
        Sat, 02 Jan 2021 22:31:09 -0800 (PST)
X-Gm-Message-State: AOAM533nqUpAZQg9PaswAZj1BEawfJAgAVH6oJGWn1iHlOEvE/PxriT0
        zwhv/u0E8G1NLS1Q8KdOu7BT+8d/GL3yLFo3AOs=
X-Google-Smtp-Source: ABdhPJz/Rzhb8CoOVcfVjcQ1tOCOkkVEDVjbzVXkHGdYs2JmaD+p7VY4c2umwEM+71O3b93K4bKy9U5FoL5DFkPFswk=
X-Received: by 2002:a63:1f1d:: with SMTP id f29mr7612800pgf.47.1609655468397;
 Sat, 02 Jan 2021 22:31:08 -0800 (PST)
MIME-Version: 1.0
References: <16871.1609618487@turing-police>
In-Reply-To: <16871.1609618487@turing-police>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sun, 3 Jan 2021 15:30:30 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQU61eccDfh_jX_cnZHnyxfbfgBGu1845QM8XbBTJPnsw@mail.gmail.com>
Message-ID: <CAK7LNAQU61eccDfh_jX_cnZHnyxfbfgBGu1845QM8XbBTJPnsw@mail.gmail.com>
Subject: Re: Kconfig, DEFAULT_NETSCH, and shooting yourself in the foot..
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 3, 2021 at 5:14 AM Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.e=
du> wrote:
>
> Consider the following own goal I just discovered I scored:
>
> [~] zgrep -i fq_codel /proc/config.gz
> CONFIG_NET_SCH_FQ_CODEL=3Dm
> CONFIG_DEFAULT_FQ_CODEL=3Dy
> CONFIG_DEFAULT_NET_SCH=3D"fq_codel"
>
> Obviously, fq_codel didn't get set as the default, because that happens
> before the module gets loaded (which may never happen if the sysadmin
> thinks the DEFAULT_NET_SCH already made it happen)
>
> Whoops. My bad, probably - but....
>
> The deeper question, part 1:
>
> There's this chunk in net/sched/Kconfig:
>
> config DEFAULT_NET_SCH
>         string
>         default "pfifo_fast" if DEFAULT_PFIFO_FAST
>         default "fq" if DEFAULT_FQ
>         default "fq_codel" if DEFAULT_FQ_CODEL
>         default "fq_pie" if DEFAULT_FQ_PIE
>         default "sfq" if DEFAULT_SFQ
>         default "pfifo_fast"
> endif
>
> (And a similar chunk right above it with a similar issue)
>
> Should those be "if (foo=3Dy)" so =3Dm can't be chosen? (I'll be
> happy to write the patch if that's what we want)
>
> Deeper question, part 2:
>
> Should there be a way in the Kconfig language to ensure that
> these two chunks can't accidentally get out of sync?  There's other
> places in the kernel where similar issues arise - a few days ago I was
> chasing a CPU governor issue where it looked like it was possible
> to set a default that was a module and thus possibly not actually loaded.
>


If there is a restriction where a modular discipline cannot be the default,
I think you can add 'depends on FOO =3D y'.



For example,


choice
           prompt "Default"

           config DEFAULT_FOO
                  bool "Use foo for default"
                  depends on FOO =3D y

           config DEFAULT_BAR
                  bool "Use bar for default"
                  depends on BAR =3D y

           config DEFAULT_FALLBACK
                  bool "fallback when nothing else is builtin"

endchoice





--=20
Best Regards
Masahiro Yamada
