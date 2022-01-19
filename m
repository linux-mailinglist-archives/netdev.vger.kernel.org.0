Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3414936A2
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 09:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352645AbiASIzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 03:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352641AbiASIzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 03:55:04 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06760C061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 00:55:04 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id h14so5209555ybe.12
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 00:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZAagVbA/i07oNhTFvM2cyHUWajTLtxzUpHCcDLcCUs=;
        b=aZjW63ddqlbcZvzsKduutBmJDVdui920oQWbOyZmoUPl6NMA4fiHVc3958W4JZxDHB
         bDX0CKMRnQvbJSCTm+VWcaVpg3XUIXx/5W0jgA+RA00csIMmD9kpAqJrunLJdr1qvhND
         zUuO7jHMPjibzTo9hUPXI1DmUAWxMQioi2CaBgldiB82Y7iQ4+zWGgnQATjrsN5vcRLu
         tMx4ofB+F19t9upffxbsp43eQxcB48tqYLbP933C1H1AfCwS2hZdXjGG6jG1jMu0sdHD
         +3Czil5200TV2gKNF4kFcCh23Hhvx3cACXP/4xUYk6Htsp9JNMLN0dYdcHlwbMsu5eMf
         LvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZAagVbA/i07oNhTFvM2cyHUWajTLtxzUpHCcDLcCUs=;
        b=ptM0jr6VPbmj3vzqpuXtSDEwx24KUhAarIEyAh7EBzGLqVJFLLxixtG70U4zdO2uV6
         XfDCEUIQRw39G430xx5PEgar2IlOmy2EvnAnQp9+glp91QUZ/I/NfwnIPpXKAPCs3H4l
         0cyO+rscfdv5gjQGfoTQfSC6CLThQjxdFNFsJZL+Atc5Sld+4AtW0AgxA6AyHXYvks9w
         L0ljgfGfPXgONR0CK5ixYi9wxVfpzV1u0PVBxebbTyTLfEFY99ZFMjMZhPG8/qopkv3S
         WyR2JfxI2vPVRyb+2nOE9fi0s6p685bBG3+HVtJdyRAr0TpJ9jacQqbFQdQkwYA1IC7n
         OcuA==
X-Gm-Message-State: AOAM533/tdtmt09DR6ODmmEs5WgoYLFK5FOZkzaQULLwR5dy0JyQyaL8
        OUatciFmQdLmBS6/Vy8wlaaTz4DJnBPhgkOQ5MOUyA==
X-Google-Smtp-Source: ABdhPJzXofjjkJFwOwGWNo4DeaBaYcoumhhuuPvdoOd/LQN2Sh9bRvNzPI06xFtITByuyNH1pRthwA7vCmOkjIDV8NA=
X-Received: by 2002:a25:8442:: with SMTP id r2mr12764543ybm.711.1642582502828;
 Wed, 19 Jan 2022 00:55:02 -0800 (PST)
MIME-Version: 1.0
References: <20220118204646.3977185-1-eric.dumazet@gmail.com>
 <20220118204646.3977185-3-eric.dumazet@gmail.com> <1d570c92-8acc-fd82-ce8b-f23b2ce47a9f@gmail.com>
In-Reply-To: <1d570c92-8acc-fd82-ce8b-f23b2ce47a9f@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Jan 2022 00:54:51 -0800
Message-ID: <CANn89i+=Sy5THwOxBRrDLEcgM32yC3OEs+9_KebO=tkxfzkRAA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] ipv4: add net_hash_mix() dispersion to
 fib_info_laddrhash keys
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 6:42 PM David Ahern <dsahern@gmail.com> wrote:
>
>
> for consistency, make this hashfn and bucket lookup similar to
> fib_devindex_hashfn and fib_info_devhash_bucket.
>
>

Ack, thanks for the suggestion.
