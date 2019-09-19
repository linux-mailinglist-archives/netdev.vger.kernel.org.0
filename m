Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF8B7BF8
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbfISOSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:18:25 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35757 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388006AbfISOSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:18:25 -0400
Received: by mail-yw1-f65.google.com with SMTP id r134so1291715ywg.2
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADEeWxa6PsQ3m65UwT/gH+lw8Q7oATx6pVIRjpUK+XE=;
        b=p2eb9L6YgMB+cx123A9qZRiLG2Chb/ZhtDywUEeOZkWcs4zfGCb/H21PT6t1aG4yK1
         f1/yZyE59ob0bhCD3JE0IS5A3tHv+kPS9oLow2aj9x4mLbPaRYwqbnoFF40hQ4e1kupc
         8YvPsYSZW+4qC7aOiKhf7wS/MEb9vbizj9cj17QUBYrGH1colHqC0OaTe8PQGVtlpm/R
         2SsCbUJEl08bnkQRfSQr/nY9yDSRAFk4FcdwogCtuIWLFI5KtJL2aQEi0gYokpOyPAgW
         gG6WQQweLQTxSRKjE5vrnSM1o6OPb/h8bVI25RYHLl7bd5aI02QBc5CKek9RqWE2X9mR
         3Mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADEeWxa6PsQ3m65UwT/gH+lw8Q7oATx6pVIRjpUK+XE=;
        b=lOzIwvU92lHSF+vhdD2nQb1gSTp3zD25G7mSUc2ZXNAHDVhsjRiIxa68zF1quX7HiZ
         JylJcUO1JzXQ+1zR/zk4CmoIht1fqaec9aFxqUTaIT648vMRZWm7Y8i+JzlIuFBVniq1
         vTxPu8MR8MTgXs/Vaj7MqJz4849UJMCwYxFkLqtmmLDROVm1FhENN3OeR+FWmVZm7eLV
         c9WwbknJKoy85yh8jlAATG7DcFht7miwcog6iQ+NaYwFsx7nPhN/5rwBZwGe5RO/85Og
         YVdgxAHyziM4mGBBnRSH2IdM+CpG8ZmXpDGBsPFSjcybH3s0CTgghzh9n1K3CLA/euzs
         ojWw==
X-Gm-Message-State: APjAAAWHUH+7ZK/h66gGtbbB1xOpiFWCGmFHep1fZzVhp5nZUeQYUMop
        +qKR8CC86Zjg8Kojanom1ZKazMlAo+UfVjaFwufH/w==
X-Google-Smtp-Source: APXvYqyv7SvKfYxnurDyf2jLleRi4gs0CatfceHrLoe+aBSEnNw1ahY87ruJkLj22DkKEXffofKmV8bx7bHsMbiUe+4=
X-Received: by 2002:a0d:fd03:: with SMTP id n3mr7077541ywf.146.1568902704296;
 Thu, 19 Sep 2019 07:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190910214928.220727-1-edumazet@google.com> <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
 <cd1cce3d-faf5-d35b-7fd4-a831561eea14@gmail.com> <CAJ3xEMgqvFEF1YvL4cV7UEpijki1QXGf+ZqVT5EO8SvYwkHaqA@mail.gmail.com>
In-Reply-To: <CAJ3xEMgqvFEF1YvL4cV7UEpijki1QXGf+ZqVT5EO8SvYwkHaqA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Sep 2019 07:18:12 -0700
Message-ID: <CANn89iKv37151Vu50UAJXGxUvPtHYrvdP=qy6VpU2aE9Se6b9Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 7:01 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Thu, Sep 19, 2019 at 4:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On 9/19/19 5:17 AM, Or Gerlitz wrote:
> > > On Wed, Sep 11, 2019 at 12:54 AM Eric Dumazet <edumazet@google.com> wrote:
> > >> When tcp sends a TSO packet, adding a PSH flag on it
> > >> reduces the sojourn time of GRO packet in GRO receivers.
> > >>
> > >> This is particularly the case under pressure, since RX queues
> > >> receive packets for many concurrent flows.
> > >>
> > >> A sender can give a hint to GRO engines when it is
> > >> appropriate to flush a super-packet, especially when pacing
>
> > > Is this correct that we add here the push flag for the tcp header template
> > > from which all the tcp headers for SW GSO packets will be generated?
> > > Wouldn't that cause a too early flush on GRO engines at the receiver side?
>
> > If a TSO engine is buggy enough to add the PSH on all the segments, it needs
> > to be fixed urgently :)
>
> yeah, but I guess you were not able to test this over all the TSO HWs
> out there..
> so I guess if someone complains we will have to add a quirk to disable
> that, lets see..


The only known pain point for TSO is the ECN part (probably was missed
by first Microsoft specs)

This is why we have NETIF_F_TSO_ECN
