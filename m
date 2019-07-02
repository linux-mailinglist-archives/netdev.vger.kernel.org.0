Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D85D1CE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGBOfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:35:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39559 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfGBOfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:35:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so27502485edv.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/tvS4Z+7KmwQg+/M+VIUoTm/hizrenk2naesJR2Rwmk=;
        b=CVJ5wZgl9tnDojyhgtG6zhCjr62a6ZjZvV4/I6/3cK259Co5jbalrUGoG8Y8hT3W9O
         xDqRUhphNa59VClJwpHqnDT0Z68JmTb2Qv2cfJTP6GQ/DX79/+W1+a1d8f6jFwyWhHbU
         opp9OR0hPtwxYMzzlnYsDPf75eCLXRSFu01tomg23zYI2XUACr6AUgEf05KJthdPpPN2
         H9mTD+z5JkhmD/HNF+O2rhJLN9xBhGiTvNJ484NGanrtkysQx2uFHkMoitcgTcFgvQZf
         fsK0jgcKLpReHC1VlOKtai0nKk2ZQMqu1je1xic8irjH+iAhUgK0OmFhstLcL1Q8NCaW
         /a4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/tvS4Z+7KmwQg+/M+VIUoTm/hizrenk2naesJR2Rwmk=;
        b=hAR4Zvq/zguvkhcjUUdhUXWOLHtOv68RF/Ptii0QwYBjyjvkgnnB725TRKl5AzmhIb
         3sY/NAq9bo57RtTfLViMbJXo/g/TIM7AP1umvlmfmaA+di3N7WvVYGZ2ilbG8iUnF61V
         iPcy+omd/Z+o8ea/ZoDfghRHCoUwd0h0fagCkie5NclCLwXcED3gqIE99WhMHsytzvWC
         2JLsuZzEbyMX5mi7BVnoljbpRoHun0m95PfVtaI+2tan9/esLqVUv2El8BQpbFXCrAHt
         qmF0PhKDW2Y25wKJG8ze1650Sm8U9oxq8LgS+TSLelwIJrtRSxNdqe9cE5+ad6K3rJr7
         Yk+Q==
X-Gm-Message-State: APjAAAV4BL5PCEAXwGOV1wNVTN3qWl5ewNBjbmlQJ0QsSzEAWn/FWgAl
        kgDEJug72LdoL7RyiJOLz6umzTKNG28YePBgHqk=
X-Google-Smtp-Source: APXvYqwtkuZPwqzosmYwhPw1haoERZtGko8dE2uL4isFF2OGC+B3OrHPoGxl3MAAneKx/RJxxPXDFJmaMOKOrDxvVQg=
X-Received: by 2002:a17:906:cd1f:: with SMTP id oz31mr28726134ejb.226.1562078149356;
 Tue, 02 Jul 2019 07:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
 <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com> <94382bd8cfbf924779ce86cd6405331f70f65c27.camel@domdv.de>
In-Reply-To: <94382bd8cfbf924779ce86cd6405331f70f65c27.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 10:35:13 -0400
Message-ID: <CAF=yD-LBRZjns1x9_UrhBYZGX8JNeM+r-cYJV=eyYKDTSG8rBQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] macsec: fix checksumming after decryption
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 12:25 AM Andreas Steinmetz <ast@domdv.de> wrote:
>
> On Sun, 2019-06-30 at 21:47 -0400, Willem de Bruijn wrote:
> > On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de>
> > wrote:
> > > Fix checksumming after decryption.
> > >
> > > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> > >
> > > --- a/drivers/net/macsec.c      2019-06-30 22:14:10.250285314 +0200
> > > +++ b/drivers/net/macsec.c      2019-06-30 22:15:11.931230417 +0200
> > > @@ -869,6 +869,7 @@
> > >
> > >  static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len,
> > > u8 hdr_len)
> > >  {
> > > +       skb->ip_summed = CHECKSUM_NONE;
> > >         memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
> > >         skb_pull(skb, hdr_len);
> > >         pskb_trim_unique(skb, skb->len - icv_len);
> >
> > Does this belong in macset_reset_skb?
>
> Putting this in macsec_reset_skb would then miss out the "nosci:" part
> of the RX path in macsec_handle_frame().

It is called on each nskb before calling netif_rx.

It indeed is not called when returning RX_HANDLER_PASS, but that is correct?
