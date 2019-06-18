Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF35D4A9A3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfFRSSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbfFRSSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:18:07 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 761D5206BA;
        Tue, 18 Jun 2019 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560881886;
        bh=jZMjzsK5OMZgfCQBd2j4lRcYuYePGrpIOkAj+CkC+5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sqq6doFxMe4JbBYwRcibxB9uJvhPlSwMDzNkNKsvvF/rVlyLmWduC1Gez+z1sG7EU
         qnMvGs9+zoQf5Kyfj8EL+oAPq4LVmcP5tYi7KNFwpselM9aBdmTaSxU/ZNZFGg5ai7
         tj7vup137siyfYdl5cnP/v8i6rFDGdF7cKWbYnxI=
Date:   Tue, 18 Jun 2019 11:18:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH 1/2] net: fastopen: make key handling more robust against
 future changes
Message-ID: <20190618181804.GJ184520@gmail.com>
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-2-ard.biesheuvel@linaro.org>
 <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
 <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com>
 <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 02:53:05AM -0700, Eric Dumazet wrote:
> On Tue, Jun 18, 2019 at 2:41 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Tue, 18 Jun 2019 at 11:39, Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > Some changes to the TCP fastopen code to make it more robust
> > > > against future changes in the choice of key/cookie size, etc.
> > > >
> > > > - Instead of keeping the SipHash key in an untyped u8[] buffer
> > > >   and casting it to the right type upon use, use the correct
> > > >   siphash_key_t type directly. This ensures that the key will
> > > >   appear at the correct alignment if we ever change the way
> > > >   these data structures are allocated. (Currently, they are
> > > >   only allocated via kmalloc so they always appear at the
> > > >   correct alignment)
> > > >
> > > > - Use DIV_ROUND_UP when sizing the u64[] array to hold the
> > > >   cookie, so it is always of sufficient size, even when
> > > >   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> > > >
> > > > - Add a key length check to tcp_fastopen_reset_cipher(). No
> > > >   callers exist currently that fail this check (they all pass
> > > >   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
> > > >   but future changes might create problems, e.g., by leaving part
> > > >   of the key uninitialized, or overflowing the key buffers.
> > > >
> > > > Note that none of these are functional changes wrt the current
> > > > state of the code.
> > > >
> > > ...
> > >
> > > > -       memcpy(ctx->key[0], primary_key, len);
> > > > +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> > > > +               pr_err("TCP: TFO key length %u invalid\n", len);
> > > > +               err = -EINVAL;
> > > > +               goto out;
> > > > +       }
> > >
> > >
> > > Why a pr_err() is there ?
> > >
> > > Can unpriv users flood the syslog ?
> >
> > They can if they could do so before: there was a call to
> > crypto_cipher_setkey() in the original pre-SipHash code which would
> > also result in a pr_err() on an invalid key length. That call got
> > removed along with the AES cipher handling, and this basically
> > reinstates it, as suggested by EricB.
> 
> This tcp_fastopen_reset_cipher() function is internal to TCP stack, all callers
> always pass the correct length.
> 
> We could add checks all over the place, and end up having a TCP stack
> full of defensive
> checks and 10,000 additional lines of code :/
> 
> I would prefer not reinstating this.

The length parameter makes no sense if it's not checked, though.  Either it
should exist and be checked, or it should be removed and the length should be
implicitly TCP_FASTOPEN_KEY_LENGTH.

- Eric
