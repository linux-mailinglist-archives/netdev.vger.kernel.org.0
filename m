Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5231638170C
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 11:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhEOJDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 05:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhEOJDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 05:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92416135D;
        Sat, 15 May 2021 09:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621069326;
        bh=JbkgiqKo05fRNbDZSt9CFHvFX6bz61XsTpTkCFIs3zs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IOBd8yMa4rv0vsCxa1k4BW/oZzG3MFSbxqmKM2UJ3Ro3tUehP++GOxRHaur97iPPA
         VHumfaThH6c6jZf02shZ3S0ph21UmmDMl5GsNCHPfejtczRHHghMrjJxC4fgWqX2Dj
         fqz2hq0zOCb3XiqlS3OpQwX+Q+BhCcCvKWit+K548+3faVfsPCWvTUkbRVo92QK1NY
         tZW4IcFXI//tPqKeKfJHoXED2++YYgZAkIuRzPoOojRqv+rpoeJOayTAC+o/9Xa32H
         q9P6IO/H3K1IvgpIcEj1EYDA58BMaG27BAj/UjF1awLqWWXMmHCi/8Z+Z+h3u2OwjF
         uygYlZ0AuO9Lg==
Received: by mail-wr1-f49.google.com with SMTP id z17so1420758wrq.7;
        Sat, 15 May 2021 02:02:06 -0700 (PDT)
X-Gm-Message-State: AOAM532d2AL1CNA/qB2+veLPyWxTpr+CCYi9+zPe6j532Vg+lwDJNR1g
        vwNAHRVYFJAFBfN487/UyQJ1sTsFLYLyzpPSq0Y=
X-Google-Smtp-Source: ABdhPJzg2d2S00U4zNlU7vNMN0rVhw0grxjbritw0q/6FeyQwXwNPaFL0Cc+zGzRUDeO1MI0sHNEjvR97BCff3g/boA=
X-Received: by 2002:adf:fe04:: with SMTP id n4mr6617537wrr.361.1621069325292;
 Sat, 15 May 2021 02:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210514100106.3404011-1-arnd@kernel.org> <20210514100106.3404011-11-arnd@kernel.org>
 <87lf8gikhp.fsf@codeaurora.org>
In-Reply-To: <87lf8gikhp.fsf@codeaurora.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 15 May 2021 11:01:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0zc7GGEjPzYsAi=EPxs+3PL0PuhiRF2DfAfR1OHAn+gg@mail.gmail.com>
Message-ID: <CAK8P3a0zc7GGEjPzYsAi=EPxs+3PL0PuhiRF2DfAfR1OHAn+gg@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] mwifiex: re-fix for unaligned accesses
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Devidas Puranik <devidas@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devidas.puranik@nxp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 8:22 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Arnd Bergmann <arnd@kernel.org> writes:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > A patch from 2017 changed some accesses to DMA memory to use
> > get_unaligned_le32() and similar interfaces, to avoid problems
> > with doing unaligned accesson uncached memory.
> >
> > However, the change in the mwifiex_pcie_alloc_sleep_cookie_buf()
> > function ended up changing the size of the access instead,
> > as it operates on a pointer to u8.
> >
> > Change this function back to actually access the entire 32 bits.
> > Note that the pointer is aligned by definition because it came
> > from dma_alloc_coherent().
> >
> > Fixes: 92c70a958b0b ("mwifiex: fix for unaligned reads")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Via which tree should this go? I assume it will go via some other tree
> so:
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

I have queued the series in the asm-generic tree for 5.14, as the patches
that depend on this one are a little too invasive for 5.13 at this point.

If you think this fix should be in 5.13, please take it through your tree.

        Arnd
