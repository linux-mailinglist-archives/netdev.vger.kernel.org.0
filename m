Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D83453547
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhKPPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbhKPPJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:09:35 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0F7C06122D
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:06:09 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 133so17311667wme.0
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oo1eBn1uBvuGvc9j5mk8VFqWC+DtuU7lgqMd9EFeEL0=;
        b=K3tF/EqYPz8KMxA6iedaodMO0YZZkJ3i/uJuLXYotb+wOSt2Iul+IK+SBVAjuQPwEe
         EANK77dBBtE9TQrCJwVZqNE6KkkXs1zNUbM7cbPoOIT9y3HiC3N6TAYU1vI1RpY3dTdo
         KW62ZZ8XZtenyoCc2Z5fNKP4rNmWvlAnMT6KDCaGFNX6xFsWFO8FPGgQoX6aulrVWVyz
         uQ4P0LRNpVSZ4bkhdQYtRd35tkvKZ411DWjFuesCw3NYo1ZVLmTd9Fy/m+ElW5a3WTlr
         eSSw3+/VRBt/vM/CHpb9BT+J556RJ7yrtxMEd7StW8hKCRyOaLSIitPaUai7UkGcEsDA
         tdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oo1eBn1uBvuGvc9j5mk8VFqWC+DtuU7lgqMd9EFeEL0=;
        b=j71mJeEqXVb9228Cr5atW/VINJgAcpLkHYA19+71d2DTdqP7y6Hq5RpL5/OacQ+hix
         78aDCiJc7S7MG3NaZv6cwDrhzArbzHvI3bW7YL5XZoAvHj6+yV+o3fR3zXEq1eRs91RR
         CTQY+4U3rmfiCctXqYc+EQSUimDXF2KuXkyz9viR+ka+EgYy97OQu8bhEeKJvNBQ5e/6
         /msYC8ovd3PmVPbe9YkV5c53/EeU00vAAa6pEKUBJL7DquGVLpmp+o6JtXOI4h5BsDrU
         k0nRRAGoEQmxtwe0x5yT5mSPnwgeBRmFOJsoUSTFARgbCt/zgg3JB1TVcfhoSR290cVw
         pgKQ==
X-Gm-Message-State: AOAM5332AVu/7hzr4KWelBPRfxi6EiSi/U4TB3K29MPkfqd7uhqLe95S
        k/j6d9yE5WudVO/E5DSrsvrmDYMx59hByWZZEW6LuA==
X-Google-Smtp-Source: ABdhPJwj2sIRZbKisni0tE2gTerMjTgaZvBFgFgWhzjyw4PPy1XoZlp4h8FnVe8deSuVWhDRw+okl2pfJukbZRDLXkw=
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr8648449wml.49.1637075167252;
 Tue, 16 Nov 2021 07:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-18-eric.dumazet@gmail.com> <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 07:05:54 -0800
Message-ID: <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 6:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 15 Nov 2021 11:02:46 -0800 Eric Dumazet wrote:
> > One cpu can now be fully utilized for the kernel->user copy,
> > and another cpu is handling BH processing and skb/page
> > allocs/frees (assuming RFS is not forcing use of a single CPU)
>
> Are you saying the kernel->user copy is not under the socket lock
> today? I'm working on getting the crypto & copy from under the socket
> lock for ktls, and it looked like tcp does the copy under the lock.

Copy is done currently with socket lock owned.

But each skb is freed one at a time, after its payload has been consumed.

Note that I am also working on performing the copy while still allowing BH
to process incoming packets.

This is a bit more complex, but I think it is doable.
