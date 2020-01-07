Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A50131FCB
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgAGG31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:29:27 -0500
Received: from conssluserg-04.nifty.com ([210.131.2.83]:51037 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgAGG31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 01:29:27 -0500
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 0076TA8c014378;
        Tue, 7 Jan 2020 15:29:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 0076TA8c014378
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1578378551;
        bh=V4OXT4Fpyi9+NOlQeIWNoTFry/VXFE9skkoLr0JmobU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PUtkQKRh/fLDhr7OyI2jsy3dRzrVKjGRsJD26kFb8Yi5DYb3ZzVIj9aI89P3bCxO2
         kcx+0mSsXbAq4C2G/aOvNTObJyA3sA7ZRSemwGljOlIhcw4yni6N1g0mkghKwLkTff
         PCvpPysq86Ay4TJqu/B05j3eWpmSKVpUV3flWj7fJbDYzYBRe9GDCcNj/9ZPgS6WVy
         mBpxYB8cwCaNXyhhFYC562rrdIJWQJ4ftIQllFGlOQDej1RK7yQoEXLAEkU4cuevXA
         FSB3dvO2xXez30a7IBaDz3GjYj6T2nLHidaWCSDoGt0mX8w317v0yQ6iasfpegGulk
         qbQdyYxrLIKew==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id y23so18070021ual.2;
        Mon, 06 Jan 2020 22:29:10 -0800 (PST)
X-Gm-Message-State: APjAAAX4OV0JdmY3G5sTMv5AWHnVrwQNu0DHhBg8VT2p58i/tMByElVg
        ROQnZfbu9nt9w1UAX2VzjdAUszkWFQxJNHz/+bk=
X-Google-Smtp-Source: APXvYqypZNoHbzfj+w5gFDA3N15SQKWwFjdrHnOhN5aGCU+FKq8xDDltKeTcAoYEWk93oUB5yZ92m3AGy2jJt8IgSdk=
X-Received: by 2002:ab0:2ea6:: with SMTP id y6mr41352359uay.25.1578378549666;
 Mon, 06 Jan 2020 22:29:09 -0800 (PST)
MIME-Version: 1.0
References: <20200106045833.1725-1-masahiroy@kernel.org> <20200107051521.GF705@sol.localdomain>
In-Reply-To: <20200107051521.GF705@sol.localdomain>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 7 Jan 2020 15:28:33 +0900
X-Gmail-Original-Message-ID: <CAK7LNATbLESJ6CdPSN8bdpt7+4iOKW2L3c4OZaz2sLzqJH6BTw@mail.gmail.com>
Message-ID: <CAK7LNATbLESJ6CdPSN8bdpt7+4iOKW2L3c4OZaz2sLzqJH6BTw@mail.gmail.com>
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code check
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        DTML <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 2:15 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jan 06, 2020 at 01:58:33PM +0900, Masahiro Yamada wrote:
> > 'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
> > Hence, IS_ERR(p) is unneeded.
> >
> > The semantic patch that generates this commit is as follows:
> >
> > // <smpl>
> > @@
> > expression ptr;
> > constant error_code;
> > @@
> > -IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
> > +PTR_ERR(ptr) == - error_code
> > // </smpl>
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Any reason for not doing instead:
>
>         ptr == ERR_PTR(-error_code)
>
> ?

Because there is no reason to change

        PTR_ERR(ptr) == -error_code
to
        ptr == ERR_PTR(-error_code)



     if (PTR_ERR(ptr) == -error_code)
style seems to be used more often.

But, I think it is just a matter of preference after all.
Both work equally fine.



>  To me it seems weird to use PTR_ERR() on non-error pointers.  I even had to
> double check that it returns a 'long' and not an 'int'.  (If it returned an
> 'int', it wouldn't work...)
>
> - Eric



-- 
Best Regards
Masahiro Yamada
