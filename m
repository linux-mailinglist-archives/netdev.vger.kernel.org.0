Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E25B44F06B
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 02:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhKMBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 20:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhKMBQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 20:16:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE828C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 17:13:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z10so18031543edc.11
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 17:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uLeJTssYC3H4f1dqUZkTgm2WEawAH18iY1t1rjoBB/M=;
        b=UqGlPyMu56qsPp0F25J5Rx9+ZR7C5BfsnOo/cuIZqD9TFuY6zcLio9vE2kN1HKzs/A
         V2sMrTyhZlelX5kUj0FGy/9YySeoEjBor85wxpW3YZRQ0ItFSj1pbDanWCFCo5igK9gA
         OZkZZHFCeYsNw4BiCg15MkVjP1WFAdDMASbH87CYy5z6JnF9M9MRCphjuyT3cXEPIlbw
         uhh76B92ThwqK6o6b/ll1+SW+ZIWX9CgXWpwqAcxCsFVYWroYq6VXU9om8Ws3gkLtcLn
         0b5zIhIDF4qi5k+7bYFuQ+4uEwtj2wKCbiJmO2qoqy4fx5fAE8HrwNHQ1i/VDyalO3jj
         T6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uLeJTssYC3H4f1dqUZkTgm2WEawAH18iY1t1rjoBB/M=;
        b=he7eAup/CwejV3e2DvLYVVuyLl+plTVtHUfuvaiXOMc5MPH+HmLIS4k2Gljgmj8ygE
         33GoqBLFBDhikZsnr8AVOXauvu3j9P4MzzNpmv3CTQ+grRxku5lC7pYJZfGhw03E1yKU
         rW0uOabUGlzKaJvSpkzzTWqawsc+h4+JIs6zLEiLqwpg/cs3Jadf/LEVAS3WOqLUdsOt
         l1w8OT500bKfMVPaTEwmCU0zdDw5uwkQgySPo2WHZaMKr3wbuWjHScZTW9MqId1aq7JK
         va88N8RO1/jRyjLmBL1G9gRuAZg/nBQzGbhm5vhKkONea8RS4RVlwut5SmKAUbcKHcP6
         X1UA==
X-Gm-Message-State: AOAM533TYVbEc3lzVV59Kbn/OPRJ4yG0QR4MTftBdIz0QPuBkXuCiMi4
        3Sg7C2L9TFczGJ6wCRvh+LFUQUJ2a7enSHpxt7Y=
X-Google-Smtp-Source: ABdhPJyiI/5Z+GASmjUbQCG8/pIDg1buPfKdg4fskmI+/yQOStMjK6GUa3pQFQGwF9HVAqNCd2f4Ic+epdnNdhwRyWE=
X-Received: by 2002:a50:e089:: with SMTP id f9mr27756879edl.290.1636766017287;
 Fri, 12 Nov 2021 17:13:37 -0800 (PST)
MIME-Version: 1.0
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
In-Reply-To: <20211112161950.528886-1-eric.dumazet@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Nov 2021 17:13:26 -0800
Message-ID: <CAKgT0UdmtdkjW2ManK72WgBP6MToJwv5sZQbGZV_RBdPS_X7eQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/csum: rewrite csum_partial()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 8:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> csum_partial() is heavily used with small amount of bytes,
> and is consuming many cycles.
>
> IPv6 header size for instance is 40 bytes.
>
> Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> meaning that network headers are not word-aligned, unless
> the driver forces this.
>
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform three u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
>
> With this new version, we perform a loop only for the 64 bytes blocks,
> then the remaining is bisected.
>
> Tested on various cpus, all of them show a big reduction in
> csum_partial() cost (by 50 to 80 %)
>
> v3: - use "+r" (temp64) asm constraints (Andrew).
>     - fold do_csum() in csum_partial(), as gcc does not inline it.
>     - fix bug added in v2 for the "odd" case.
>     - back using addcq, as Andrew pointed the clang bug that was adding
>           a stall on my hosts.
>       (separate patch to add32_with_carry() will follow)
>     - use load_unaligned_zeropad() for final 1-7 bytes (Peter & Alexander).
>
> v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
>     - removed the final add32_with_carry() that we were doing
>       in csum_partial(), we can simply pass @sum to do_csum().
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Cooper <andrew.cooper3@citrix.com>
> ---
>  arch/x86/lib/csum-partial_64.c | 162 ++++++++++++++-------------------
>  1 file changed, 67 insertions(+), 95 deletions(-)

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
