Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0A2E0AE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfE2PL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:11:56 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36693 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfE2PL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:11:56 -0400
Received: by mail-vs1-f68.google.com with SMTP id l20so2103663vsp.3;
        Wed, 29 May 2019 08:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UIVDIT77fklabMXqDAOJeTqVDgwvqkeiaJrtX84VDSg=;
        b=SCQOExSDY4j6nVitwzKonoEiLkjv+AyqGbzWrSdcW35kQZOpct9Bl6m3yZYRqlA710
         AIABGbyP7sqKZEJrI11hdVw4wQee6PyT6NV0BKeCM5QO9d2iHqsH2KjR+L+GcaT8eqzC
         UIG5j5D17DiT3itUYV4M17aQeZ7bttrh9TPhT8d0TExkePwT6D/Y9d68sV4sNYdWTPL2
         GGE3S9kvtzDBCRXNm6paAlcQ5ypSB0ItaPxlfVVYTHW6N7akoi/ExAClCGclLQ3ZGuUb
         RDYYDIIT33PyHsRCyT3nI4g+a7/MFxLR29+EgR5EJElJxxmlKS72UxjOPPruey5ZmQ/x
         ILBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UIVDIT77fklabMXqDAOJeTqVDgwvqkeiaJrtX84VDSg=;
        b=Idf3trS3owjSmL1RKIFRUN0o1tfCuplOM+ExDldngLeCEsjR8ZZswinWqKGz8nO005
         MT+sYemAnPNOOSHaKZaAOa60ue0WRMhYxlyOLjhVWaAkYevir7d5R0UWRrd6uSDdVf4k
         2gfnHlnCWs8b5KWADm9sQV8cxERrmeOQ2XqQ0VWtXHWB9bsjMUT6VxCmwKkDupcTPMkK
         Xmq2pexnMYwoiYT7Hx0Atyl8Ouh1kwSU85/eC5yIta9ExoZGPsBebPnNxm27c2qHQC7W
         xNlxM+vcY0Ya2AfpJTKlJ6RbI+BMcMPpWu1Su1Iw3Z/JgAHqgcJiHcDTDrtBANwsvML4
         xqXQ==
X-Gm-Message-State: APjAAAVxqS5DXNOM26oB1WH26XvcOyPQMrh39kDsm/QbOFTdE2SQdw8h
        wW8YbE4GhtIb1MrtQltIlmWlZlYYJHJB88i05So=
X-Google-Smtp-Source: APXvYqyVbpePc0qw8XIy67sCbwpzdYgls/MnhlRZ0Dyy1OOs6HY2INwn/MYYV2OhRgbS31JA1j5o3HdTJ+sd5SNzK2M=
X-Received: by 2002:a67:8747:: with SMTP id j68mr38428396vsd.212.1559142715413;
 Wed, 29 May 2019 08:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <1559117459-27353-1-git-send-email-92siuyang@gmail.com> <CANn89iLxxiX+4E7EURNKb=xRkk97rPaKTkpSc6Yu7fZbiwPT6w@mail.gmail.com>
In-Reply-To: <CANn89iLxxiX+4E7EURNKb=xRkk97rPaKTkpSc6Yu7fZbiwPT6w@mail.gmail.com>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Wed, 29 May 2019 23:11:17 +0800
Message-ID: <CAKgHYH2uW=iSUM1j5pLhaQXpm35XK2rWq45M2Yih1-Dn=es0SA@mail.gmail.com>
Subject: Re: [PATCH] ipv4: tcp_input: fix stack out of bounds when parsing TCP options.
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed, condition opsize < 2 and opsize > length can deduce that length >= 2.
However, before the condition (if opsize < 2), there may be one-byte
out-of-bound access in line 12.
I'm not sure whether I have put it very clearly.

On Wed, May 29, 2019 at 10:20 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, May 29, 2019 at 1:10 AM Young Xiao <92siuyang@gmail.com> wrote:
> >
> > The TCP option parsing routines in tcp_parse_options function could
> > read one byte out of the buffer of the TCP options.
> >
> > 1         while (length > 0) {
> > 2                 int opcode = *ptr++;
> > 3                 int opsize;
> > 4
> > 5                 switch (opcode) {
> > 6                 case TCPOPT_EOL:
> > 7                         return;
> > 8                 case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
> > 9                         length--;
> > 10                        continue;
> > 11                default:
> > 12                        opsize = *ptr++; //out of bound access
> >
> > If length = 1, then there is an access in line2.
> > And another access is occurred in line 12.
> > This would lead to out-of-bound access.
> >
> > Therefore, in the patch we check that the available data length is
> > larger enough to pase both TCP option code and size.
> >
> > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > ---
> >  net/ipv4/tcp_input.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 20f6fac..9775825 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3791,6 +3791,8 @@ void tcp_parse_options(const struct net *net,
> >                         length--;
> >                         continue;
> >                 default:
> > +                       if (length < 2)
> > +                               return;
> >                         opsize = *ptr++;
> >                         if (opsize < 2) /* "silly options" */
> >                                 return;
>
> In practice we are good, since we have at least 320 bytes of room there,
> and the test done later catches silly options.
>
> if (opsize < 2) /* "silly options" */
>     return;
> if (opsize > length)   /* remember, opsize >= 2 here */
>      return; /* don't parse partial options */
>
> I guess adding yet another conditional will make this code obviously
> correct for all eyes
> and various tools.
>
> Thanks.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>



-- 
Best regards!

Young
-----------------------------------------------------------
