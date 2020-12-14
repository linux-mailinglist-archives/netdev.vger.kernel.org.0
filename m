Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A22D9FA3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439971AbgLNSyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbgLNSxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:53:44 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560BC0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 10:53:04 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id a11so9744633wrr.13
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 10:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDdObFQGHP44wB5uzTs8CFNojQR78cri+zip8zY60tY=;
        b=qtseBLRRIiwub6DQNE6y6+zZnF+JWErsu8k99AdAIvuuayLrf/JVtUx+i2syw5V4Et
         fBAiG55BonHRp6eybFbp70rUSOhqyI92D3DFf1K5IXp7+P6csHI0BJm8mJD3aYXXoVQD
         R7qAw4vhwvylhCM8wMrds9Fw3Ypx+YuJGaSYI3gtl5+mz9xfjFnZeFng6nS+BmSb5xwf
         BMKIDVQZPmtjzgv+/DF06K6LLIyEeIygqx3mzwI9XHByDW1kusU4bDMY7AO8S4XTLepY
         Uk7zUN7/LcB3AGtk3Nk8KhUiyqIV51EvFBJpuFm9AgVheEAgFZQuBoezANi/FsA0Dnqi
         KiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDdObFQGHP44wB5uzTs8CFNojQR78cri+zip8zY60tY=;
        b=Iad6pZTZ4NJ44pFkZOZjc7zii53N74xGeNSO5QKgnQgYEE/9fADZDoTdy+NZkecx4O
         r6muXN3uXzA1I0utWxtOhQtp/pZ3efXF5JD36gbTI8g8TYwIpre+48ZPSVZ6zliIWBji
         n12ZW4yi5hg04oOyV2D50sr8FUrjEbffWqR9+ysmoZzqt1WXi5eJ2r0DmqnAGQot45U5
         D8fDfWf0IMARgI37O+/2mtT3Z5+NpYgEryKEtGzVWA4LGA9pz9yqb0jgdOH6Vz918l3L
         f7iOg/BhL4hz056VhqYDTpPH/Tqg+onDhujcolsLi+AKCfxVKWSkvhmgXVosphnzqs8+
         g61g==
X-Gm-Message-State: AOAM53220iPoKyYM5fcvGBU7SUckY6HwdfDBupEHXeimxGA3lF27tbff
        d4Bmkc+3xD/eeTrm//e6pMnuI2zAj7DVvpIg5iiaaQ==
X-Google-Smtp-Source: ABdhPJwEMTtYeETuXF3/XCpMDfqlJZwPT9M5sPnMxHan/mH+fTUl/SwsWhAn4rnqs7N+v2n/cTjVFqXQvHBIvXNHCAY=
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr30383506wrt.49.1607971982996;
 Mon, 14 Dec 2020 10:53:02 -0800 (PST)
MIME-Version: 1.0
References: <160780498125.3272.15437756269539236825.stgit@localhost.localdomain>
 <CANn89i+uQ0p81O3-aWO-WPifc35KtpDFRsO9WJKrXxEhpArDWw@mail.gmail.com>
In-Reply-To: <CANn89i+uQ0p81O3-aWO-WPifc35KtpDFRsO9WJKrXxEhpArDWw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 14 Dec 2020 10:52:26 -0800
Message-ID: <CAK6E8=ftSyOhBnB8ZXb_NaBW0wKLSQRjGCm5xE=RMCg=BMnb1g@mail.gmail.com>
Subject: Re: [net-next PATCH v3] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 9:42 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Dec 12, 2020 at 9:31 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> > message in the case of IPv6 or a fragmentation request in the case of
> > IPv4. This results in the socket stalling for a second or more as it does
> > not respond to the message by retransmitting the SYN frame.
> >
> > Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> > ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> > makes use of the entire MSS. In the case of fastopen it does, and an
> > additional complication is that the retransmit queue doesn't contain the
> > original frames. As a result when tcp_simple_retransmit is called and
> > walks the list of frames in the queue it may not mark the frames as lost
> > because both the SYN and the data packet each individually are smaller than
> > the MSS size after the adjustment. This results in the socket being stalled
> > until the retransmit timer kicks in and forces the SYN frame out again
> > without the data attached.
> >
> > In order to resolve this we can reduce the MSS the packets are compared
> > to in tcp_simple_retransmit to -1 for cases where we are still in the
> > TCP_SYN_SENT state for a fastopen socket. Doing this we will mark all of
> > the packets related to the fastopen SYN as lost.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >
>
> SGTM, thanks !
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
Nice work. I tested and verified it works with our packetdrill

Signed-off-by: Yuchung Cheng <ycheng@google.com>

>
> > v2: Changed logic to invalidate all retransmit queue frames if fastopen SYN
> > v3: Updated commit message to reflect actual solution in 3rd paragraph
> >
