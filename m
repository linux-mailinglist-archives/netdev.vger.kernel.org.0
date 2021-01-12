Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BDE2F3F8A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbhALWxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731700AbhALWxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:53:36 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF5DC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:52:55 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p187so218111iod.4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fLxEHdmjmlZykfFx5ew3fFtTUyVnStFftN9I76p99UQ=;
        b=qikE3aBL2oQopixdpOcKbZPz1BM+i5uJ4ibkCQyu6n74dUKNhiMBhC8nHxo/W4mabh
         efbn32R3WjTdznhrnZqt1E574wCHvn/YJuIdsMDnpHedhWT/w3+IqrxW82+pSrW0Ij/G
         OEzbYW3tr9QgKhpXavWlWjDqgFWaP38yLTdJk1F0iBtEAoSD0FFSk9J7feP6DhjRAegK
         eHHtYnLMHvfJEkZBthN6S4Jsu7ZbrVqeg+dDe4jqjMvVoLnaBcYKyww9RqOGp0Z4JbRC
         t0ZYZDUTDyRutBF4WQ/T+iTnj2fiH6mTqfROrKTa/WQ0e8GYK6c9+J0E+gQ9HWzgHGIp
         CGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fLxEHdmjmlZykfFx5ew3fFtTUyVnStFftN9I76p99UQ=;
        b=NRayDZ5MTvHnp5PiH59Q1NWL/RlCkHDUVfiK1AsWXOR4dl0YDjiZa15cYBWN2dfalA
         +74ElR+M5OpvgvTkiNuEKFKMbjgRwpR89iOwKepLsAcM2Jj4eYbfyMQufoKrc+GMP1hY
         Gg0vvt5IcLLenhMIv47inEvlm/ZpLzFbmy72Eh2ULDr0vImxhJJHFLZbcBKgOHo1NDXA
         4guv49EHC8jVwkDu0CD7+3upariFmmC6M6TwwMxi5KUVoFmjA0cVMeZxPShO/8pwn4R/
         V44kQSqNim41B/EBx61UkxZcAcIEm+fTifQcV/9s5QWGw/1L4JZjT2PZ2w47V77STxun
         lq5g==
X-Gm-Message-State: AOAM530H3vJGIiEG/CikVgdmFKudmGNqybwXsCbTrI0fIA15C5iJEoG+
        jhQnyuxlv0u+YyE/PfTlydzZB6hA2CQf5Syv8BouoA==
X-Google-Smtp-Source: ABdhPJwxrcb5DLSRScZkWKsPyNKcqO0DvW1lFlX0FBDDNbkmeCtALzzWhkyD52/yBRbAKw/sAxXUCcye+3KoCkY/bWk=
X-Received: by 2002:a92:ce09:: with SMTP id b9mr1375100ilo.69.1610491974876;
 Tue, 12 Jan 2021 14:52:54 -0800 (PST)
MIME-Version: 1.0
References: <20210112192544.GA12209@localhost.localdomain> <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
In-Reply-To: <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 23:52:43 +0100
Message-ID: <CANn89i+w-_caN+D=W9Jv1VK4u8ZOLi-WzKJXi1pdEkr_5c+abQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: keepalive fixes
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Enke Chen <enkechen2020@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:48 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Tue, Jan 12, 2021 at 2:31 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > From: Enke Chen <enchen@paloaltonetworks.com>
> >
> > In this patch two issues with TCP keepalives are fixed:
> >
> > 1) TCP keepalive does not timeout when there are data waiting to be
> >    delivered and then the connection got broken. The TCP keepalive
> >    timeout is not evaluated in that condition.
> hi enke
> Do you have an example to demonstrate this issue -- in theory when
> there is data inflight, an RTO timer should be pending (which
> considers user-timeout setting). based on the user-timeout description
> (man tcp), the user timeout should abort the socket per the specified
> time after data commences. some data would help to understand the
> issue.
>

+1

A packetdrill test would be ideal.

Also, given that there is this ongoing issue with TCP_USER_TIMEOUT,
lets not mix things
or risk added work for backports to stable versions.
