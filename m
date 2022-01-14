Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD66B48ED11
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiANPUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiANPUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:20:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EA3C061574;
        Fri, 14 Jan 2022 07:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427F8B8243B;
        Fri, 14 Jan 2022 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A38DC36AEF;
        Fri, 14 Jan 2022 15:20:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GzdGWz16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642173645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFgML1uQ/Qzn1vSR4mCIz6pcZeXqvGjS03+Xmhw6EOs=;
        b=GzdGWz16StVcPMrECW8MBygQFgy1yssgeUTpyKjGAG3jJcWLL+8CH8zut/dZjjjRHethuB
        CdCH1hOeuFHtxMNp3+KiF3nGQVG3+BvccvTiBidU6LxtxIsb6ADZC5K5I0S2BUngT6sENM
        7wRS4fqM0svIA1vBKgq9ArSWcIPAEAA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d0b260f1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 15:20:45 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id h14so24711622ybe.12;
        Fri, 14 Jan 2022 07:20:44 -0800 (PST)
X-Gm-Message-State: AOAM533lKuhPZ+34OG5LbfM6rACd+ZHkZcdzWhF8zNsGCAu+bFwjayp8
        6IrMfZ6AePzq9gq/IaoDkw+J0VbFGSV9bwgW6QY=
X-Google-Smtp-Source: ABdhPJzZy7umxKxjUw/ZcSNFZNoyraKJDGR7iFCzVJTzk3ebqFXxxLSPMOq8y0XkfmCqyD/t21YJlm0N2vmX7W/Lro8=
X-Received: by 2002:a25:aae2:: with SMTP id t89mr13574829ybi.638.1642173643690;
 Fri, 14 Jan 2022 07:20:43 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
 <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com> <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
In-Reply-To: <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 16:20:33 +0100
X-Gmail-Original-Message-ID: <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
Message-ID: <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 4:08 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> Yeah, so the issue is that, at *some* point, SHA-1 is going to have to
> go. So it would be helpful if Alexei could clarify *why* he doesn't
> see this as a problem. The fact that it is broken means that it is no
> longer intractable to forge collisions, which likley means that SHA-1
> no longer fulfills the task that you wanted it to do in the first
> place.

I think the reason that Alexei doesn't think that the SHA-1 choice
really matters is because the result is being truncated to 64-bits, so
collisions are easy anyway, regardless of which hash function is
chosen (birthday bound and all). But from Geert's perspective, that
SHA-1 is still taking up precious bytes in m68k builds. And from my
perspective, it's poor form and clutters vmlinux, and plus, now I'm
curious about why this isn't using a more appropriately sized tag in
the first place.

On Fri, Jan 14, 2022 at 3:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> "checksum" -- the thing is only 64-bits, and as you told Andy Polyakov

Whoops, meant Lutomirski here. x86 Andy, not crypto Andy :)
