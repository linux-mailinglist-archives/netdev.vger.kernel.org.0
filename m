Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0427E48EE31
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243389AbiANQe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:34:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiANQe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:34:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3EC361F81;
        Fri, 14 Jan 2022 16:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D5FC36AEC;
        Fri, 14 Jan 2022 16:34:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Oz1RX5Az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642178096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+St3iTAHIuS0KsoowzgRGUNNSGHH83FkM9ZDKm+9NhI=;
        b=Oz1RX5AzHd8/Mb4vQqSXY9oI9bpi4iLhiD2F558XhoZ9ZdGewhD+IopB5vEjJXiWjEDB6/
        YgICq7jVOHyCE6SX9qyc+ErKVSEsxa1zUazzZg4tAVrB7MTRFYG2oVqubOxUJK58rzxptY
        S85PXES7rGv5QUOSlPV09UcluVLlMcQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0dcadaf2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 16:34:56 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id c10so25389651ybb.2;
        Fri, 14 Jan 2022 08:34:56 -0800 (PST)
X-Gm-Message-State: AOAM5314KgOjH88rCl1k+EnLDfXAKgrd2uFqLd0gCT0ORfxqMiVdjSj0
        1IIgC65Bv8yMNPgVZ8Gly+pxIkr6nFoc4gQYpV0=
X-Google-Smtp-Source: ABdhPJw5y1GoloBGskhkRBQcDqAct29IQbjQkVz+UAlItTl9lTYFdblcTKVyR5fersk213PQnpoEOC40WtOi1tmq2Ig=
X-Received: by 2002:a25:4109:: with SMTP id o9mr11081224yba.115.1642178095003;
 Fri, 14 Jan 2022 08:34:55 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
 <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
 <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com> <CAADnVQKCSJi=U4gNv48vsS8Guu7_JP946yMuNqVAJ-D=rAme7w@mail.gmail.com>
In-Reply-To: <CAADnVQKCSJi=U4gNv48vsS8Guu7_JP946yMuNqVAJ-D=rAme7w@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 17:34:44 +0100
X-Gmail-Original-Message-ID: <CAHmME9pHhy7sXfkF7LWPDik3obkgwYZd1BRSVMYx5=uFAuQtOQ@mail.gmail.com>
Message-ID: <CAHmME9pHhy7sXfkF7LWPDik3obkgwYZd1BRSVMYx5=uFAuQtOQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
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

On Fri, Jan 14, 2022 at 5:19 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 14, 2022 at 7:08 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Yeah, so the issue is that, at *some* point, SHA-1 is going to have to
> > go.
>
> sha1 cannot be removed from the kernel.
> See AF_ALG and iproute2 source for reference.

It can be removed from vmlinux, and be folded into the crypto API's
generic implementation where it belongs, which then can be built as a
module or not built at all, depending on configuration. Please see the
3/3 patch in this series to see what that looks like:
https://lore.kernel.org/lkml/20220114142015.87974-4-Jason@zx2c4.com/

Meanwhile, you have not replied to any of the substantive issues I
brought up. I'd appreciate you doing so.

Thank you,
Jason
