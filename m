Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844A95285E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfFYJnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:43:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43872 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFYJnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:43:02 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so2609692ios.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhwdQmgTmYTXT3WO+LF8mzQuTFkQGvKf9Tnckc40IY4=;
        b=cQ9oRHzT97lf4doUiOdevWZJb/gfV/3tLsUhYLrx3bb9ge4y0meuIKw4T20/xTOkBB
         nn0wKCDUQY30RsZEGB9s5KbxI82FVJGDknnDzfV2A+fYaFnuIKeEtonfJNOdTNSTvNOs
         cA7AKdc2g0QCgVcq83O5ZRGI08kUUlgB2QDbjAHW6KFKDnR6goUbBLZcaPDC19TYiXzH
         auBiqjxNEwcogZPTVorywirXVQdbBL5O6U0VFPsgqEb2A9Wd9LUhWwSN07R48AFABkXf
         ViG/E8nDVMLFQfml//c8RaLg4LEh4bpWuBc+KC6u6GMqzt3gNYSfdoIwMjnK5aswJdiI
         H0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhwdQmgTmYTXT3WO+LF8mzQuTFkQGvKf9Tnckc40IY4=;
        b=Heh26O0MhfpsNSlr3xAa+IxKb3CYsUJcUMBVzt91OUJcI9y38IOJ1akjLArb/EvdYz
         0wb2WsQ30cC0ngeVzth5zH91i+VmDDwr21yvFvKgGvpL7Kbkh1N9rpv+LYZodlS9JywX
         nGJqzfKmMGdaRyAMqTF9QrDsOwdISbDfqscmbUFX83lZ5EQ5UpIZtB8rK5n7S0r4giTb
         gb/gSgiFbealllqS2x4CYQXBAGqkUWw54iJcP7+orxq4RxpeGnAV8Odom3gUP6cd9AMX
         Qzyp885+yEgHMg4C8SNy07Lu6SyCAI3SENkLKKV/p3C6U4briJhz530DQsUs90nPtJfl
         yJ5A==
X-Gm-Message-State: APjAAAUju1vbTeI52zk8ZXkE//3D709yE8aIgGwuRGRPUV5CrSDJqeO+
        rA8iIXo3XwgNFE/UUwL3y+SZQUFCbyAq3aq2i3bZKA==
X-Google-Smtp-Source: APXvYqwFAcYf4FoBEUWi7suqfe0ssOVcyyOcBaA37kIyzY7n1BDNPVDAGhSiKUoHJuEKgLnL7Vxo6mU2R+bmWT/1exg=
X-Received: by 2002:a5d:9dc7:: with SMTP id 7mr46097398ioo.237.1561455781699;
 Tue, 25 Jun 2019 02:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
 <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
 <20190625113010.7da5dbcb@jimi> <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
 <20190625091507.pwtingx6yk4ltmbo@breakpoint.cc>
In-Reply-To: <20190625091507.pwtingx6yk4ltmbo@breakpoint.cc>
From:   John Hurley <john.hurley@netronome.com>
Date:   Tue, 25 Jun 2019 10:42:51 +0100
Message-ID: <CAK+XE=kdFc8mweAZqQg5=17p8C4NA3-Dm_mdemu2ftTYTr_BsA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
To:     Florian Westphal <fw@strlen.de>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, shmulik@metanetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 10:15 AM Florian Westphal <fw@strlen.de> wrote:
>
> John Hurley <john.hurley@netronome.com> wrote:
> > Hi Eyal,
> > The value of 4 is basically a revert to what it was on older kernels
> > when TC had a TTL value in the skb:
> > https://elixir.bootlin.com/linux/v3.19.8/source/include/uapi/linux/pkt_cls.h#L97
>
> IIRC this TTL value was not used ever.

It was used to carry out this looping check on ingress redirects:
https://elixir.bootlin.com/linux/v3.19.8/source/net/core/dev.c#L3468
It appears this was removed/unused after changes in 4.2


>
> > I also found with my testing that a value greater than 4 was sailing
> > close to the edge.
> > With a larger value (on my system anyway), I could still trigger a
> > stack overflow here.
> > I'm not sure on the history of why a value of 4 was selected here but
> > it seems to fall into line with my findings.
> > Is there a hard requirement for >4 recursive calls here?
>
> One alternative would be to (instead of dropping the skb), to
> decrement the ttl and use netif_rx() instead.

Yes, this seems like something worth investigating.
Thanks
