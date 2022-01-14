Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E4348EDFA
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbiANQUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiANQUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:20:33 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5FC061574;
        Fri, 14 Jan 2022 08:20:33 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso13434091pjd.1;
        Fri, 14 Jan 2022 08:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCk9twFpDl6+WjnnhC7znYwCWhjmneBKzu1nIMx+UPk=;
        b=C+aI5yX1wz/I3tjQZsVrKLlWpgUvrNYWgSbi9B47SEFZnWrCv9iH+y4Ft9oEl9kMuX
         EfIRISlQXs1WJOzYW0CDhKZbh2/iYG7iqSnCkSc88XGXIpo+E1c+Y4lB8GUr61Im4YZB
         3MfJIFDHMn8BdV8OW8ZvrhQrvUokP0o9Gw84Yu2qlSgEsYMyXKrfZTwTi91GQ3s22/VL
         0KTkZGDy7cBlrj5f+LeIcNnbUFjuuRw8MuLI4Nh6hrxNXxl/ClxzN3bbEwZMPdnF15Yu
         +Am9FdfI7iErgMWRcdlGYslQwzgxGC++EvdSMGwR2wvheQhvzYxliJB64z9mSQyUeLij
         d++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCk9twFpDl6+WjnnhC7znYwCWhjmneBKzu1nIMx+UPk=;
        b=d3D5cEK5AWlu6cHJMD3GwwLZMmbNhTuWzgvmYwHj9Y3XoG/AJVUjJOHkpzHTc3CO/B
         drADUbxebU1k1rEZqGLSuBK6FQ0GNQiJu5uBSQDdpwNIckJA3ugKsnrEwNGKb5BEPNTm
         an3FdFf0zFlwNUzb8FwpHoDFckKl7RUQVK6X2wwriE+hzhAA6SaIfc5RUNo7/OCSaZpg
         zCM2705xySCoofzhYQYDceu6Z8pX9KO4Z+2zKLuWFsjagAWyxB/zURZ8WWXr+6S/ilGq
         Vru2M2kYXaAMtMdmnVYcBOasOCytaHc7cY6yJOV0AGwrnOzmFTcezja+yLqD4VmyA8RQ
         j4JQ==
X-Gm-Message-State: AOAM531QR/FeRJ7De+mSMLgBnazQm//7t6HlWJO6U7nDai4eihj4D0rK
        ztrqkdGFf1rDDVnigdB82EoympGFoam06w/l8zY=
X-Google-Smtp-Source: ABdhPJyxtJkZpDAo1n6nW5FDaYgs/bGhPklwfosepqM4KmBTSKklri2jQQWobdLxJtNDUHr64CRPPhM/ZlNsy1oM/vA=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr9819305plk.126.1642177232891; Fri, 14
 Jan 2022 08:20:32 -0800 (PST)
MIME-Version: 1.0
References: <20220114142015.87974-1-Jason@zx2c4.com> <20220114142015.87974-2-Jason@zx2c4.com>
In-Reply-To: <20220114142015.87974-2-Jason@zx2c4.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jan 2022 08:20:21 -0800
Message-ID: <CAADnVQJ1qsGacgrsKNiMme--+nwPVG+bd1D8rF8t8bDCvTgbLw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 6:20 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
> now. This also removes quite a bit of code, and lets us potentially
> remove sha1 from lib, which would further reduce vmlinux size.

Same NACK as before.
Stop this spam. Pls.
