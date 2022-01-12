Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A441648CE2C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiALWBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:01:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiALWA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:00:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C3ECB82141;
        Wed, 12 Jan 2022 22:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C780DC36AE9;
        Wed, 12 Jan 2022 22:00:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lr/xlBLC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642024850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x7iEe7IoxzS5LF9sUIO2C6nbsTbfn+EF6LhXMAOlaaE=;
        b=lr/xlBLCZhYJYGE3l7rjBQs6lpPhxatKOJKXsHsFfWW3BhDx3vbC+FWBWLhVD95Lbk1THF
        oSse5uLcPApKGTWPwssJ2FwtmJjFGDvACZbzrZlCO4liAvC4eQxuEuVrLVB2jAb8cYgDlJ
        DrO8bK6NuGXBT8OcmyHrGhlAr4ooSIo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 92028de6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 22:00:50 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id d7so9581607ybo.5;
        Wed, 12 Jan 2022 14:00:49 -0800 (PST)
X-Gm-Message-State: AOAM530Fc3zhdBtk60l6Yed4ldWjjRgJhjAHlXwXT98ANN7NZdM/LE4i
        I0+qYylS8zYedz6Fb+/u2tn3747HpRTJzff8/H4=
X-Google-Smtp-Source: ABdhPJxpRMesfcwVP3cDFwxhtrXE3cWVaFTB1pgeIm7wgCjUmTGJYn0+LmHJIWiD1lpG6RAGzWa6tkk4ceurJUL7qr0=
X-Received: by 2002:a25:8c4:: with SMTP id 187mr2224483ybi.245.1642024848755;
 Wed, 12 Jan 2022 14:00:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Wed, 12 Jan 2022
 14:00:48 -0800 (PST)
In-Reply-To: <d7e206a5a03d46a69c0be3b8ed651518@AcuMS.aculab.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com> <20220111134934.324663-2-Jason@zx2c4.com>
 <Yd8enQTocuCSQVkT@gmail.com> <CAHmME9qGs8yfYy0GVcV8XaUt9cjCqQF2D79RvrsQE+CNLCeojA@mail.gmail.com>
 <d7e206a5a03d46a69c0be3b8ed651518@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 23:00:48 +0100
X-Gmail-Original-Message-ID: <CAHmME9p-JZS480-e3MvPsa1Q07rqX79h8oNEZsF970GjT-_nqA@mail.gmail.com>
Message-ID: <CAHmME9p-JZS480-e3MvPsa1Q07rqX79h8oNEZsF970GjT-_nqA@mail.gmail.com>
Subject: Re: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 1/12/22, David Laight <David.Laight@aculab.com> wrote:
> I think you mentioned in another thread that the buffers (eg for IPv6
> addresses) are actually often quite short.
>
> For short buffers the 'rolled-up' loop may be of similar performance
> to the unrolled one because of the time taken to read all the instructions
> into the I-cache and decode them.
> If the loop ends up small enough it will fit into the 'decoded loop
> buffer' of modern Intel x86 cpu and won't even need decoding on
> each iteration.
>
> I really suspect that the heavily unrolled loop is only really fast
> for big buffers and/or when it is already in the I-cache.
> In real life I wonder how often that actually happens?
> Especially for the uses the kernel is making of the code.
>
> You need to benchmark single executions of the function
> (doable on x86 with the performance monitor cycle counter)
> to get typical/best clocks/byte figures rather than a
> big average for repeated operation on a long buffer.
>
> 	David

This patch has been dropped entirely from future revisions. The latest
as of writing is at:

https://lore.kernel.org/linux-crypto/20220111220506.742067-1-Jason@zx2c4.com/

If you'd like to do something with blake2s, by all means submit a
patch and include various rationale and metrics and benchmarks. I do
not intend to do that myself and do not think my particular patch here
should be merged. But if you'd like to do something, feel free to CC
me for a review. However, as mentioned, I don't think much needs to be
done here.

Again, v3 is here:
https://lore.kernel.org/linux-crypto/20220111220506.742067-1-Jason@zx2c4.com/

Thanks,
Jason
