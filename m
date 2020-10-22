Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9153296350
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898353AbgJVREW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505307AbgJVREW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:04:22 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1F6C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:04:21 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id n18so1299199vsl.2
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CA9DaLGcfiGHJuWUm9GTfgcNbHzlugvVFcCxDBKaYY=;
        b=ncPf31HbfcjQd6NIMQLmAF2/5N+eTlUKStvLivEX00tV1s0lulIuHg6E3j8ijdRLR3
         a9wJ/CMs9p27BAYsZD4C5XPP+CnwVY+iMirYNGYdrB9sl4S6Z1Af8ixkhfXGSz4FVsBg
         Cp4p5gz59taoNkOeItfGhvkSvCohn//JuFp4QTuzLDVRRokNESxZ/PTxQRrJ7NfQQrk1
         5uNxTXhOyWdfrp5OlpdJUn1kLU3DYbF9hEf1EUL3rBdFGBsQDnpGkRjdBUziZkbTXqEG
         aC4IUnJHdTJWm8yQz7pBgbt6VeQ3Tx4n13uqiIXy7V8fqPvGZu67g/YV4YJDaS9G7SrM
         aRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CA9DaLGcfiGHJuWUm9GTfgcNbHzlugvVFcCxDBKaYY=;
        b=VtP7kHWYEuleenmUvcB41JFu1E8Y1ubwBNlYYvGJQfRADK33eEhYGsRAghcLow3P5e
         QQkGGTCU2pBPIWjT4JK+qpUvvtwjUUGU4Y+H+nTrEZGg+5YtEWM3WUgT2CofgCgBjHZU
         tG5cqDhJQSxzMhYIdY5yIuH9jseX/dKTdDU25iAXrEhXMELHOmQraPk+QmExJ/F4FrWy
         dz0ygZVlAzOsi1yEvaRj2QAKM64OSF7loOj61dyoQp0jdR0qQTE9f6VjGTSJJY9NJf69
         ocg0F891nUQUzRxHG3IlFIscUrb3dZjmthF3MOgN4dxnx93u9KUVngX0GsEHijSobqRL
         pC+Q==
X-Gm-Message-State: AOAM533CKE6JBg/OkGhtAzXJOzUoKwXqlW6uZks9zhvtYcAtZE/gzB/K
        mcNzYBHrFgbaKeNP6y/6zXbYrQ5Ivbv2y3T8TOlCd3VS69w=
X-Google-Smtp-Source: ABdhPJxMuX3Tnmwq3uNPeBJsQhGYMIolPPYOOgdFABTJRMjqM46I+wyfuemgBbRsvxLOhwo0idPpVFVxrCVTdY4ZECY=
X-Received: by 2002:a67:c41:: with SMTP id 62mr2725660vsm.54.1603386260921;
 Thu, 22 Oct 2020 10:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201022143331.1887495-1-ncardwell.kernel@gmail.com> <20201022090757.4ac6ba0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022090757.4ac6ba0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 22 Oct 2020 13:04:04 -0400
Message-ID: <CADVnQy=KhEZ6OA+Kr2M8iP7zuPO7uc2jLJ1rxi1Qq8pau2KZ2w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Oct 2020 10:33:31 -0400 Neal Cardwell wrote:
> > From: Neal Cardwell <ncardwell@google.com>
> >
> > In the header prediction fast path for a bulk data receiver, if no
> > data is newly acknowledged then we do not call tcp_ack() and do not
> > call tcp_ack_update_window(). This means that a bulk receiver that
> > receives large amounts of data can have the incoming sequence numbers
> > wrap, so that the check in tcp_may_update_window fails:
> >    after(ack_seq, tp->snd_wl1)
> >
> > If the incoming receive windows are zero in this state, and then the
> > connection that was a bulk data receiver later wants to send data,
> > that connection can find itself persistently rejecting the window
> > updates in incoming ACKs. This means the connection can persistently
> > fail to discover that the receive window has opened, which in turn
> > means that the connection is unable to send anything, and the
> > connection's sending process can get permanently "stuck".
> >
> > The fix is to update snd_wl1 in the header prediction fast path for a
> > bulk data receiver, so that it keeps up and does not see wrapping
> > problems.
> >
> > This fix is based on a very nice and thorough analysis and diagnosis
> > by Apollon Oikonomopoulos (see link below).
> >
> > This is a stable candidate but there is no Fixes tag here since the
> > bug predates current git history. Just for fun: looks like the bug
> > dates back to when header prediction was added in Linux v2.1.8 in Nov
> > 1996. In that version tcp_rcv_established() was added, and the code
> > only updates snd_wl1 in tcp_ack(), and in the new "Bulk data transfer:
> > receiver" code path it does not call tcp_ack(). This fix seems to
> > apply cleanly at least as far back as v3.2.
>
> In that case - can I slap:
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> on it?

Yes, slapping that Fixes footer on it sounds fine to me. I see
that it does apply cleanly to 1da177e4c3f4.

Or let me know if you would prefer for me to resubmit a v2 with that footer.

thanks,
neal
