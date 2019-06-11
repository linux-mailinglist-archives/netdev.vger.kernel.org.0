Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C61F4169A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407435AbfFKVHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:07:07 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36404 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406793AbfFKVHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:07:07 -0400
Received: by mail-yw1-f65.google.com with SMTP id t126so5863940ywf.3
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZZZVwpsso/EhIBbEdGMFWRVz1yWvhX8O+674DQfvlY=;
        b=fD/S7sBJPQfwW9fdWa6fiz1msYWbP6QjZJqCXP1PcyvqR9DIUsOyo2o5IwEpbTf/0p
         yKnnew/FwPEhSUl0qsJ0gzAn6cyYXKOXkw7/s7r/Og/J6X91wD0h3QURGjgjg0zQ8BTg
         PjiCYay206/jQ9fH07OowhUeg1+fg2Ib7IRlJ4SvYumqtfojH8Ju6fqUVCiW3UYJzblF
         58FOnmMt4wEmocPrVYRhqPWEKEzpA9uCvCetiPq3ur//TZWFKW/u3kgqBv6dKAFPnDD5
         FN5bp2dIXN4syessdjP+j8XyWk2L4jqaeHRj+o/tBD3qrtdabTNQJ+bw9zf3PiQoCF4l
         e1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZZZVwpsso/EhIBbEdGMFWRVz1yWvhX8O+674DQfvlY=;
        b=aPjqUTwJomw7A2J/gw8sss4EfidCPSrlVS688WmFIbl5syKA2pSLgjnNbo+Je4qTnn
         VIptrM3yHHCoKFX+dMjyz72S86Il9z1KomVpG2Ann1tS47GUf7u6SdOxNCVAGcn5M2C9
         nN/G2S9U+2H8D1DifKxpY63SNtm39Nmr/OLYBEoMAEDmvOxrCCU6+2t5HowdMOw3yqVi
         U6M5j0vKkqN+zlG1Q4dgnZKdzkVqF+HtzWVKUGht2oX0Gz7On3gJSYY/9v5tIJA8tO0f
         qmODaVGpyYHpwqz9FavYSNEpcT6ZipK57C0rbsgSIRlPMyXO+nHz5pnsZhtlfBkjFbsK
         VOCA==
X-Gm-Message-State: APjAAAVta113ZjdElaclNnTZ4T37ctd/SIJDwMcxXZFefJ+F4nJBRX1t
        UrZnHpw+6JHc6b6C7bhlR7MkS0d3sdCmG2NQDye9Xg==
X-Google-Smtp-Source: APXvYqwptak8nsNPboA3DBwl8XzfNjWN5xoORBwTFZnNKI0yOywaLEHachDzdeduae+GCKhhKpbcJjY+bkhaUx6Dmgw=
X-Received: by 2002:a81:2e93:: with SMTP id u141mr30138550ywu.21.1560287225866;
 Tue, 11 Jun 2019 14:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190611030334.138942-1-edumazet@google.com> <20190611.121601.1611337978166305865.davem@davemloft.net>
In-Reply-To: <20190611.121601.1611337978166305865.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Jun 2019 14:06:53 -0700
Message-ID: <CANn89iJ3CnQ8X8qBN3MY7hjQq-BsUdMUfPQoES-qEFQjM5Gm+Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: add optional per socket transmit delay
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:16 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 10 Jun 2019 20:03:34 -0700
>
> > This patchs adds TCP_TX_DELAY socket option, to set a delay in
> > usec units.
> >
> >   unsigned int tx_delay = 10000; /* 10 msec */
> >
> >   setsockopt(fd, SOL_TCP, TCP_TX_DELAY, &tx_delay, sizeof(tx_delay));
>
> I'm trying to think about what the implications are for allowing
> arbitrary users to do this.
>
> It allows a user to stuff a TCP cloned SKB in the queues for a certain
> amount of time, and then multiply this by how big a send window the
> user can create (this ramp up takes no time, as the TCP_TX_DELAY
> option can be intentionally set only after the window is maxxed out)
> and how many TCP flows the user can create.
>
> Is this something worth considering?

Absolutely worth.

Note the issue is already there since eBPF hooks can already
manipulate skb->tstamp
to implement pacing (without going through HTB)

We are working on implementing a max horizon in FQ.

The idea is to add a max_horizon parameter, that could be set by
default to 5 or 10 seconds,
but could be tuned if some people want to test TCP to communicate to Mars :)

(Name comes from Carousel paper :
https://www.cc.gatech.edu/~amsmti3/files/carousel-sigcomm17.pdf)
