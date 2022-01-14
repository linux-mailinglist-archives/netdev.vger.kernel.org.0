Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA12E48EE2B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiANQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:33:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36406 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiANQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:33:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2EAB82963;
        Fri, 14 Jan 2022 16:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E157C36AEF;
        Fri, 14 Jan 2022 16:33:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f8BE3bp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642177997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fjhRN0D79I8OqjnhotxNxDTJr6R4g/K22rp1JS1C5Eo=;
        b=f8BE3bp888e2UKyRZigZlucXrl3EdxDbtL2HX5Uh6swbq0rLANuLtzjzONNVXsYEFDHnUn
        wv5dGEQ278DvKOHOOv0FuHhDaAj0Avb7lqA83+1xY++L96XuPTypYbcYQgFdf14t0lTllp
        Qmub2ddKHXu8E2fLwGtJgLDGOam56y0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3ee846df (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 16:33:17 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id h14so25261919ybe.12;
        Fri, 14 Jan 2022 08:33:17 -0800 (PST)
X-Gm-Message-State: AOAM530kUVVuAQAdn4s+NCPDlRQNeZEEhFl57dlLIFzmxX9ei3a/7kH6
        3qnpE1RNkhWfZnr36/fWNU3qd8Ba178JeYRF6mQ=
X-Google-Smtp-Source: ABdhPJw+G76wCMtSJSIuOYt31tQHyRYk7zoC2KbYtKA7+I1KIxZdl0Ni/9vsDj9W+Rg1a6w300a7FLWP7S/v0KjtE5Y=
X-Received: by 2002:a25:4109:: with SMTP id o9mr11071225yba.115.1642177996382;
 Fri, 14 Jan 2022 08:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20220114142015.87974-1-Jason@zx2c4.com> <20220114142015.87974-2-Jason@zx2c4.com>
 <CAADnVQJ1qsGacgrsKNiMme--+nwPVG+bd1D8rF8t8bDCvTgbLw@mail.gmail.com>
In-Reply-To: <CAADnVQJ1qsGacgrsKNiMme--+nwPVG+bd1D8rF8t8bDCvTgbLw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 17:33:05 +0100
X-Gmail-Original-Message-ID: <CAHmME9oV-KEU=3ZVHzN1APgUWP0vABt3T5FL4GX47KAUfp6ekw@mail.gmail.com>
Message-ID: <CAHmME9oV-KEU=3ZVHzN1APgUWP0vABt3T5FL4GX47KAUfp6ekw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Fri, Jan 14, 2022 at 5:20 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 14, 2022 at 6:20 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
> > now. This also removes quite a bit of code, and lets us potentially
> > remove sha1 from lib, which would further reduce vmlinux size.
>
> Same NACK as before.
> Stop this spam. Pls.

You can read the 0/3 for an explanation of why I sent this v2. I
reject your characterization of this as "spam".

Thanks,
Jason
