Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE448CB4D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356543AbiALSva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356574AbiALSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:51:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9122EC061751;
        Wed, 12 Jan 2022 10:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CB54B8203C;
        Wed, 12 Jan 2022 18:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3423BC36AEC;
        Wed, 12 Jan 2022 18:51:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SVlUKGNc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642013471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xreHySqXLyhKUk0VW0GwsU6XUHgnG+4/Jk0kao9Oifc=;
        b=SVlUKGNcrSDoPZWC+klO14Zqk7l7Uf8MtIAFKt+cC6HwyJsLy+SLzVJX2qkW5yifFG74U1
        jkNoAR9iWafix2H1JjlgdtWawKfLApWQRctYnBS5dtnsQG3gAwp6/5nfj5vg0rGFBqRHvP
        Qe+YhFBRbUX0+Y9zskJZr0tLh1hhtZk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f42311d7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 18:51:11 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id v186so8318237ybg.1;
        Wed, 12 Jan 2022 10:51:09 -0800 (PST)
X-Gm-Message-State: AOAM53047xidX8tulzJ90ryBsqKoJ+CfaIZY8T7ByCp0MK/55c6dtvyc
        RcSYh/gspnMn6X7NUUWUGqYn3iVNsvcYaxsJ4Xo=
X-Google-Smtp-Source: ABdhPJyNAIEcTXisld7XC7bhz4PalaSX6tHDm9+bpvRZLfdVf/6oPJbATFqmhRaXycqh4DhrWUXcosqQSbDYw9Ipoz0=
X-Received: by 2002:a25:854f:: with SMTP id f15mr1311046ybn.121.1642013469238;
 Wed, 12 Jan 2022 10:51:09 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com> <20220111134934.324663-2-Jason@zx2c4.com>
 <Yd8enQTocuCSQVkT@gmail.com>
In-Reply-To: <Yd8enQTocuCSQVkT@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 19:50:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9qGs8yfYy0GVcV8XaUt9cjCqQF2D79RvrsQE+CNLCeojA@mail.gmail.com>
Message-ID: <CAHmME9qGs8yfYy0GVcV8XaUt9cjCqQF2D79RvrsQE+CNLCeojA@mail.gmail.com>
Subject: Re: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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

On Wed, Jan 12, 2022 at 7:32 PM Eric Biggers <ebiggers@kernel.org> wrote:
> How about unrolling the inner loop but not the outer one?  Wouldn't that give
> most of the benefit, without hurting performance as much?
>
> If you stay with this approach and don't unroll either loop, can you use 'r' and
> 'i' instead of 'i' and 'j', to match the naming in G()?

All this might work, sure. But as mentioned earlier, I've abandoned
this entirely, as I don't think this patch is necessary. See the v3
patchset instead:

https://lore.kernel.org/linux-crypto/20220111220506.742067-1-Jason@zx2c4.com/
