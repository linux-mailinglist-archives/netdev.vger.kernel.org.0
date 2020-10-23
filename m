Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F35A297745
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755095AbgJWStS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755068AbgJWStR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:49:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D767C0613D5
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 11:49:17 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k18so2995745wmj.5
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q51TK8/PvlrJALSNBr7oRhEZ17+8vqbYI8em8LLff6M=;
        b=D2JZ4jqmBFMI0jviR/yb+H4dpQs6CpplHKxqaSRiDzMlbLXyCT3KYKkETv4mQ7DzcA
         I4SOWLzxKNfo15N/hj6Ffvq2Qa6ZOtAL3ygd1sErlhhfJ+TNOTAhcqIAxNESTgPv9v4c
         /oxtIV7KPYyVv+wsYM+R2yIAhjiceMk/d5RFfS9u4Ns/3Dvlb/+wdY4iBZvPqR0OzB+d
         9494sBoD11FYcKXJ0xS5dzxp6T8wL8vGisRTNHnjMLSfdK9veFQqRJyqA+rdx/uzcHHM
         4Vszz4Tw4h6bxCmFS/Z7vonEDbyy2zXZB/N2Hstket/J9PpveJQ0Xa3/X0hGH3gjYrRP
         tohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q51TK8/PvlrJALSNBr7oRhEZ17+8vqbYI8em8LLff6M=;
        b=WZn2sDDT6HKoK6ql328aY822JSZcMakma1zuQ/sespFHeclE3StM8rrFe+sMd8fhlv
         UlaY9/H5U8mC90p71giICcI78G2ITsub0H9MWpsamaSB6PsYXjyN7sUOvhdl1lucUcyP
         /WJ45MxrDkcOaOxs4DpKwbXaN7I7yHVqrruuE4HioP2Brb2vrLy7BLG0BoKu13nEI8OX
         UjNChyzz+wCwu74sSMl6rn8+5nAMLuis1mmmjS8gC3sn/QKX6wfObbzHilXXGMxcySf6
         r0k/qa0T/JYvb7xPXaB0YpvCjgJBb9l1Abeb3Y6MzmbIA1GSpvMIFj8QUzVLoBXLX0ww
         RdbA==
X-Gm-Message-State: AOAM533t7ovBMH7yfNiIHun6BF8/rIh6u77nFL52twYMXxhHubXl0diw
        kb7kJlamsMIHrYA8TYniepOonlTnC7Gs6ppZniYqMA==
X-Google-Smtp-Source: ABdhPJxmf+2e5U6A163eq/nzohuUamTcf95MmirAW1BJwrPBD9Eqz3ke8pzfFCmyVqQaUoHw5h6anKXvVguc7xqpUSQ=
X-Received: by 2002:a1c:740f:: with SMTP id p15mr3510441wmc.106.1603478955761;
 Fri, 23 Oct 2020 11:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201023174856.200394-1-arjunroy.kdev@gmail.com> <20201023113131.780be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023113131.780be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 23 Oct 2020 11:49:04 -0700
Message-ID: <CAOFY-A2TtTvm58DtsoBkhS-co8Qc=NYCG=jSfrNuTqt=D5Vg0A@mail.gmail.com>
Subject: Re: [net] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acknowledged, I have rebased onto net master just now and I think that
should fix the sha1 information. v2 patch has been mailed. Sorry for
the error first time round :)

-Arjun

On Fri, Oct 23, 2020 at 11:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 23 Oct 2020 10:48:57 -0700 Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> >
> > With SO_RCVLOWAT, under memory pressure,
> > it is possible to enter a state where:
> >
> > 1. We have not received enough bytes to satisfy SO_RCVLOWAT.
> > 2. We have not entered buffer pressure (see tcp_rmem_pressure()).
> > 3. But, we do not have enough buffer space to accept more packets.
>
> Doesn't apply cleanly to net:
>
> Applying: tcp: Prevent low rmem stalls with SO_RCVLOWAT.
> error: sha1 information is lacking or useless (net/ipv4/tcp.c).
> error: could not build fake ancestor
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> Patch failed at 0001 tcp: Prevent low rmem stalls with SO_RCVLOWAT.
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
