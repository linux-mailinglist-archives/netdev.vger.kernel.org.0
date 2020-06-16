Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F711FB463
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgFPO2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbgFPO2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:28:49 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FF0C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:28:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so23820277ljn.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bes32zQvMtRaOQrttUPkZlC7gSNPSIik81WBvUM1E+s=;
        b=NEv3OGtOmLBfljH35YNfV5rybK/oyFGKNcTgTOOkgNM9trQy/NaZs0mtPO56fPcvKL
         2bE+Sv84sU0iuFePQwIxlBiL5VJnP1+bNPsYIL+xf2AD069Nrz7Xd16rbRJomQrgQLeS
         2qJXUfV2yvTqKborX9O8ZsRxUVE2rjTuk5QJ8V2eCqofJrLlFdWuKyQ6a8wmHBaMmIDW
         H3A77uQCRLibzQ3VPOB/f6bCvrCcKSe717KLQ8NjKO/6GdltCydEp9fqIB3EGf86L3cb
         M1oP7owNTsbq4sjXMcariKUkX1QH+zl4qmNKkr7D7MIl+mXlZnS7zA7A9cug8Y26Ah3V
         EqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bes32zQvMtRaOQrttUPkZlC7gSNPSIik81WBvUM1E+s=;
        b=KqshxBov4MgDQTnO43Zw+xX+uYqLEh2tNzxzybT8QZISWuNmoHSac3icKqIkv0RucZ
         5wIwKaJCoXfZV9e6ssqDAD3j1j7j77mTggijAYNbvGOQF3rKnde2naTUOYbhlI5/QOC2
         A/wppk44prEeF0Zc/XeqrkEA9LoM0AiIWZEReAXoF2bxXZzTVdfDhvHac1iuwMIRPwtZ
         8Fm5VSHg5DRB/E/V5JQwlWO9IIyKboe4Qe99KPoFiu3eCUrHRVko/Ku6z3MVyAkYUQqv
         YjxZA3fGbJ/UJSpYZnJJNqwDfHGF0G6qtqOP0SrVG76LMpr3Wm371wzYr3Pt/Nw8xd7H
         /e6A==
X-Gm-Message-State: AOAM533tebaB7UfPcpGK42MqTEBoTQ975rUsiv6aDkFUefNue9jw9Cpc
        jajMG+RUBqzjclXU1VsDOxVoCFMJDpjaoEGNMhQ=
X-Google-Smtp-Source: ABdhPJwiG300Ks1+LwwZ1uMgOF9eFju/qwnfrU3QYOkMP9FtY6C3xCMeK2oLApyku3yhB4Jt2GCig4Id+CteBPGtjDw=
X-Received: by 2002:a2e:9113:: with SMTP id m19mr1477182ljg.396.1592317727897;
 Tue, 16 Jun 2020 07:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200615150751.21813-1-ap420073@gmail.com> <20200615.181701.1458193855639723291.davem@davemloft.net>
In-Reply-To: <20200615.181701.1458193855639723291.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 16 Jun 2020 23:28:35 +0900
Message-ID: <CAMArcTWPFhe2O9Jw8_zW=bJwHe5vPXeh=L-8efxJFE=4bJxVaA@mail.gmail.com>
Subject: Re: [PATCH net] ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 10:17, David Miller <davem@davemloft.net> wrote:
>

Hi David,
Thank you for the review :)

> From: Taehee Yoo <ap420073@gmail.com>
> Date: Mon, 15 Jun 2020 15:07:51 +0000
>
> > In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
> > fallback tunnel device pointer, which is fb_tunnel_dev.
> > This pointer is protected by RTNL. It's not enough to be used
> > in the datapath.
> > So, this pointer would be used after an interface is deleted.
> > It eventually results in the use-after-free problem.
> >
> > In order to avoid the problem, the new tunnel pointer variable is added,
> > which indicates a fallback tunnel device's tunnel pointer.
> > This is protected by both RTNL and RCU.
> > So, it's safe to be used in the datapath.
>  ...
>
> I'm marking this changes requested because it seems like the feedback Eric
> Dumazet provided for the ip_tunnel version of this fix applies here too.
>
> Thank you.

I will send a v2 patch soon.

Thanks a lot!
Taehee Yoo
