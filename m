Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F7297B0A
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 08:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759744AbgJXG0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 02:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759740AbgJXG0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 02:26:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB67C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 23:26:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y12so4970228wrp.6
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 23:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FYw6hlF3zVU55hf6NO6+DeWBWQVJ7zIDenp+3zMY3rs=;
        b=sQ9SsVq08i9FirE1oHBw1Ez3bpfkszUhJvDchfiQzdMMr4CUTUAQEeAh2aa7TQ6PpO
         sJanjyxvalUeo7tcLvmyxE4PwDJUNHAi6OJt6AhbH52HV7lJwopMc5HHmdXiQ3o47l6f
         yCTAA6eLOv9g5zgHdHNtIuJfojGO0YKyGXMntCWPoS+ZUi8bLwpTiTluYZpHyigmvnvi
         uLtI17clRybRG1/73u3ThOT+V49ddLhLX6GB2WAcNjrXr2FnKnNDN8sq7/3OZrp//roq
         /d2LHQ+i0Dcs1tflEbt1GSKTrNxaWWsI7jYNjMpRbsPMd4sxEiIvfyrFzw5o+IF3yomy
         uuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FYw6hlF3zVU55hf6NO6+DeWBWQVJ7zIDenp+3zMY3rs=;
        b=q8Y+zL+ZWxWWb/Nv2TWD7e6ta9GhGcAM8hXQ17mFCS8gKlVdf0ZWGKeroVdTnmWKxw
         Vk1Ct/rxOM9Pfi3iXtEfNJ0/ZUIJB3Hmq5BxVU1/MDwdb9ObdaNoRL6OipF1DBBUUims
         WRWl4DdQYJyb+L167WMSZBM8UIQcdfeUMIWKoea89dnsCMbfNGD5NiCJ8Ax6zyY8RpYj
         vNMYHVoceCVRoHddNmkcos0UEmxY3j7wc/ClWqLqVUxRfJGDNjJZQkX7xZmP2bRTgqEw
         T7SxKWPS5QzcAC9XmmsmLWE+EyfQAwHNLDimCtYe3vWm87H1k+4+xDTO2Po3g3ZpccJA
         xqIQ==
X-Gm-Message-State: AOAM530RZh71lh2FysoImeEtS1hFyou0irxHGcCE33/ALIyn9sJWeOxU
        FTZAgWVv68Ld55/hj41m7RSevw+xzSu51pWiTEXxyg==
X-Google-Smtp-Source: ABdhPJwctYaDhweSm5lBc4LQdlJP3qXy30XsD8S9jwlycPm9AnJsfH8nV6N73nyZ5EDFM5f1lbTat70oZmPgrDFFbjs=
X-Received: by 2002:a5d:63cb:: with SMTP id c11mr5780066wrw.243.1603520773607;
 Fri, 23 Oct 2020 23:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201023184709.217614-1-arjunroy.kdev@gmail.com> <20201023191348.7a6003f4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023191348.7a6003f4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 23 Oct 2020 23:26:02 -0700
Message-ID: <CAOFY-A3myOA9WUAu08gbFXM=SrnkoPDK0GnfZjOyHTv5gGxStQ@mail.gmail.com>
Subject: Re: [net v2] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
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

On Fri, Oct 23, 2020 at 7:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 23 Oct 2020 11:47:09 -0700 Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> >
> > With SO_RCVLOWAT, under memory pressure,
> > it is possible to enter a state where:
> >
> > 1. We have not received enough bytes to satisfy SO_RCVLOWAT.
> > 2. We have not entered buffer pressure (see tcp_rmem_pressure()).
> > 3. But, we do not have enough buffer space to accept more packets.
> >
> > In this case, we advertise 0 rwnd (due to #3) but the application does
> > not drain the receive queue (no wakeup because of #1 and #2) so the
> > flow stalls.
> >
> > Modify the heuristic for SO_RCVLOWAT so that, if we are advertising
> > rwnd<=rcv_mss, force a wakeup to prevent a stall.
> >
> > Without this patch, setting tcp_rmem to 6143 and disabling TCP
> > autotune causes a stalled flow. With this patch, no stall occurs. This
> > is with RPC-style traffic with large messages.
> >
> > Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Acked-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Applied, thank you!

Ack, thanks for the quick review!

-Arjun
