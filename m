Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C28C48AE18
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbiAKNDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:03:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiAKNDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:03:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD5161247;
        Tue, 11 Jan 2022 13:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C4AC36AED;
        Tue, 11 Jan 2022 13:03:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MFUmMebD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641906191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dD8XQSwfxo9Qxlwz/G+XVhaNKfdndavkp2bxgcRBbBo=;
        b=MFUmMebDpLyDxjsoyIJbJpe79N9khL827AQ4XB75K8ZWyHtg+Ti8ikJHsZlBmfFmhuRyGt
        LuwBsm4bRzhYzg1MIKHgAG8zR798wojqy0m8kiQlHGzbSbWQjQ26dggaYIO67mmoruTYCE
        ClEPPD2IuBuEQlmg9OJkXz6i+p+JFGI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 502088a2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 11 Jan 2022 13:03:10 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id n68so1445650ybg.6;
        Tue, 11 Jan 2022 05:03:10 -0800 (PST)
X-Gm-Message-State: AOAM5318ZN/Tx3YlCRwxUK4DWwLku6kK85cMUZ9pHT8vXFXl0HBY6AEE
        Rr7nzB211U2vsmKtcK498ZQY0i9IP0qoyH2z+68=
X-Google-Smtp-Source: ABdhPJyuxNRlBlXLYZ87sxZJN7FApgyqec7syhcIQclS06IdXwytu39KatIkarIKO39uGGvNME+hOhV9JsThjOhfr+c=
X-Received: by 2002:a25:a0c4:: with SMTP id i4mr5913073ybm.457.1641906189532;
 Tue, 11 Jan 2022 05:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20211223141113.1240679-1-Jason@zx2c4.com> <20211223141113.1240679-2-Jason@zx2c4.com>
 <CAMuHMdU0spv9X_wErkBBWQ9kV9f1zE_YNcu5nPbTG_64Lh_h0w@mail.gmail.com>
 <CAHmME9pZu-UvCK=uP-sxXL127BmbjmrD2=M7cNd9vHdJEsverw@mail.gmail.com> <CAMuHMdW+Od70XTNbnNxL3qXgetZ9QDLeett6u5vg9Wr6atxD=w@mail.gmail.com>
In-Reply-To: <CAMuHMdW+Od70XTNbnNxL3qXgetZ9QDLeett6u5vg9Wr6atxD=w@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 11 Jan 2022 14:02:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
Message-ID: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] random: use BLAKE2s instead of SHA1 in extraction
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 1:51 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Jan 11, 2022 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On Tue, Jan 11, 2022 at 12:38 PM Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> > > Unfortunately we cannot get rid of the sha1 code yet (lib/sha1.o is
> > > built-in unconditionally), as there are other users...
>
> kernel/bpf/core.c and net/ipv6/addrconf.c
> Could they be switched to blake2s, too?

I've brought this up before and the conclusion is that they probably
can't for compatibility reasons. No need to rehash that discussion
again. Alternatively, send a patch to netdev and see how it goes.

Anyway, we can follow up with the code size reduction patches we
discussed elsewhere in this thread.
