Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4542E35
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfFLR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:59:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35560 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfFLR7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:59:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so17932993wrv.2;
        Wed, 12 Jun 2019 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ePUN5rzo27PFr1LJi5Rm6WSN/mwBD0fkpgyCUhJe7o=;
        b=p03TSkDQxPk7OPna/PaF4pJc2LEzwNW+ETfG7j86VjPJhxkPpPjQJLnF7xnbondmE9
         K8y26OEFXHIX7eOtl1+NcG0Nn/sR86v8ZTlbhdwu+2HA4bu1nklQMxOULzOg+AWLrDzT
         heVLEMCIOgzc0XUezR4CQ169kewPzs75hdmSPXzTMfLoVWU92W658MZdykFHzStIkBWu
         0bAdG9o4cdBFrDkX0pJHdcDLQkrLT6RWxgA8x9ZWDTceD+Xi1hcasYglbNXgVwTZxAud
         wFk3mzZfkGVKDpa+yBd3wNmOPq5Co1YUl73xYZseikPOCcrNcfu60AnyRNZWQIulS54Y
         AnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ePUN5rzo27PFr1LJi5Rm6WSN/mwBD0fkpgyCUhJe7o=;
        b=P2GWspX8mUFcb5kkqMx+jL/wsrMnWb0h4TgrH860XFTJdeEFTXOlEbwHUoHMTry9TK
         ZIOBWhYiLl3Y2LqjP2KWgO2xFsLo9axVh8h7GyGWgU+ktsz7fVBfUG8e+nRTABXQ68E9
         akEz4lFXXVgfGBfrds5PxdJsxJROJH7FiwxPB5dofDlmNxOyk8lMMtadUAxzuAig2lpu
         IYzi2MBj92n2mkE8EZTXeMZk6BonXqEHcJw9gJcR5GIFB8QsrOK8GkBbv0sRJxKKk+dO
         W58w+/pRQKnaqvOzWCr3PAjyVmO1KsAtuw09ECN83SxomNjs+KowImcqEv6YyFOXrdBp
         g/9g==
X-Gm-Message-State: APjAAAWyi2nmUK6t3JxYL10WjYNlN58LuKvR6nW4BradQv36d5QIbPFa
        fK79J9Tkko4/IQ1SXPil+8WJ4G+CC+dRMv3OtbY=
X-Google-Smtp-Source: APXvYqxZZ99QcxrlWX+qT0sDYcNaM0+GhAyRwKpy54BqCzlIQjymmRJsPm/4q597LbYkPMyBUGOE8uP+f8h27+0dUqA=
X-Received: by 2002:adf:bac5:: with SMTP id w5mr42486928wrg.124.1560362351411;
 Wed, 12 Jun 2019 10:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190610163456.7778-1-nhorman@tuxdriver.com> <20190612003814.7219-1-nhorman@tuxdriver.com>
In-Reply-To: <20190612003814.7219-1-nhorman@tuxdriver.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 13 Jun 2019 01:58:59 +0800
Message-ID: <CADvbK_cpgsMs_Kxp7LHH_Y-MC1Fqfvbjt2XmnHxBvT5wHbOwGA@mail.gmail.com>
Subject: Re: [PATCH v4 net] sctp: Free cookie before we memdup a new one
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 8:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
>
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
>
> ---
> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)
>
> v2->v3
> net->sctp
> also free peer_chunks
>
> v3->v4
> fix subject tags
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org
> ---
>  net/sctp/sm_make_chunk.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index f17908f5c4f3..9b0e5b0d701a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2583,6 +2583,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>         case SCTP_PARAM_STATE_COOKIE:
>                 asoc->peer.cookie_len =
>                         ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> +               if (asoc->peer.cookie)
> +                       kfree(asoc->peer.cookie);
>                 asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>                 if (!asoc->peer.cookie)
>                         retval = 0;
> @@ -2647,6 +2649,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>                         goto fall_through;
>
>                 /* Save peer's random parameter */
> +               if (asoc->peer.peer_random)
> +                       kfree(asoc->peer.peer_random);
>                 asoc->peer.peer_random = kmemdup(param.p,
>                                             ntohs(param.p->length), gfp);
>                 if (!asoc->peer.peer_random) {
> @@ -2660,6 +2664,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>                         goto fall_through;
>
>                 /* Save peer's HMAC list */
> +               if (asoc->peer.peer_hmacs)
> +                       kfree(asoc->peer.peer_hmacs);
>                 asoc->peer.peer_hmacs = kmemdup(param.p,
>                                             ntohs(param.p->length), gfp);
>                 if (!asoc->peer.peer_hmacs) {
> @@ -2675,6 +2681,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>                 if (!ep->auth_enable)
>                         goto fall_through;
>
> +               if (asoc->peer.peer_chunks)
> +                       kfree(asoc->peer.peer_chunks);
>                 asoc->peer.peer_chunks = kmemdup(param.p,
>                                             ntohs(param.p->length), gfp);
>                 if (!asoc->peer.peer_chunks)
> --
> 2.20.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
