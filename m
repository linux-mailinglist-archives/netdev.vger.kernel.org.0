Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0471D860F4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfHHLhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:37:34 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35333 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHHLhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:37:33 -0400
Received: by mail-yw1-f68.google.com with SMTP id g19so33250644ywe.2
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3GlhYP383I2+CYpqR8l32cY067xh8g7dsEH0Pwsq0o=;
        b=RssdtkeJZ8ZszIPiYtfO3f5xjJLIUGTTQOPO6xjq/ELyt4+mrQuJSSEAx2JyCRe9Dr
         IVPwy1coLSHjkAe1lpfvs0YWBn4SO4ej8V7MYSWINWkxAr3+M42FQ71qQg82la5Iy9if
         MinQlsg5/QpZ4V7ZIJCLgdVlmeqv8HpRPRCWORbUHCF/VAfvodODYYKO+H2phT4AhaAt
         MGBFzhGwJe3OSC9+OpnVKNYt2EmyNk+V3CQUDayyjgDXglLtHmDV94MBC/tS+4F9X5me
         BMQIkIKhKN1aSGzsAMd7ZhhMWNNwygBm9LRWcVF2nMMthEhA90jSXKxY9Y8nLCcB0eYg
         QDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3GlhYP383I2+CYpqR8l32cY067xh8g7dsEH0Pwsq0o=;
        b=U1rcG/knlfdcj+CmBccW9B+euZqicl/WVoJrsvofGeNfr0llYnlo27XSA489Sv/ZdM
         uKn+X3Pt8i3/Mj7giDHsJ6JeIH8d6NWkJcaUminS02tofIVh7B+6WIgM4bQN6upGafpX
         oBcfrubfpj1jc1ouB/kEyEZWevN6elEPKb3ttvmGAsdESTRv+xDv+5DEvXQzDxpoRp3x
         aTtwP3JO/1WFMpROZ7ur9Ya9z9tjkI7Wu5VXkN/5nekU3xPFaFCzAVzhuXGoQCwXONDr
         wP+a8xhHuKGdI+AN86SQflfVwtiwOzE7wYpxXI28evKxjOVD/EmFyKIvp/nOZ4D8qOJS
         atIA==
X-Gm-Message-State: APjAAAWED0c7YFSABL2ULlFcjI/vmS01yt0UStj3LleFgzorHwtq2s6X
        VHrcFppe4CJDsk0QJMFep3wrCO6UFTp+y3eb3tgkDddOMUwVOw==
X-Google-Smtp-Source: APXvYqyBiFeVogs4OHQGZws9+Ejtp5zMK40hKYHM0+EqSS3LnX9t95S5LeZ8Mfpxpl12fHs8G6I7ddPmdPxgMcQPPtU=
X-Received: by 2002:a81:1090:: with SMTP id 138mr2472662ywq.179.1565264252623;
 Thu, 08 Aug 2019 04:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190808094937.26918-1-daniel@iogearbox.net> <20190808094937.26918-2-daniel@iogearbox.net>
 <CANn89iKzaxxyC=6s45PEnTsKfz7GN4HHOw3wtpb6-ozrJSRP=g@mail.gmail.com> <d87d35a1-0ebc-4e48-1950-e94fde62a6c4@iogearbox.net>
In-Reply-To: <d87d35a1-0ebc-4e48-1950-e94fde62a6c4@iogearbox.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Aug 2019 13:37:21 +0200
Message-ID: <CANn89iLqhYF=JYtNtB25O=0a_tn50dRko3fqvvC-sWTZXuK+0g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] sock: make cookie generation global instead of
 per netns
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        m@lambda.lt, Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 1:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/8/19 12:45 PM, Eric Dumazet wrote:
> > On Thu, Aug 8, 2019 at 11:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> >> Socket cookie consumers must assume the value as opqaue in any case.
> >> The cookie does not guarantee an always unique identifier since it
> >> could wrap in fabricated corner cases where two sockets could end up
> >> holding the same cookie,
> >
> > What do you mean by this ?
> >
> > Cookie is guaranteed to be unique, it is from a 64bit counter...
> >
> > There should be no collision.
>
> I meant the [theoretical] corner case where socket_1 has cookie X and
> we'd create, trigger sock_gen_cookie() to increment, close socket in a
> loop until we wrap and get another cookie X for socket_2; agree it's
> impractical and for little gain anyway. So in practice there should be
> no collision which is what I tried to say.


If a 64bit counter, updated by one unit at a time could overflow
during the lifetime of a host,
I would agree with you, but this can not happen, even if we succeed to
make 1 billion
locked increments per second (this would still need 584 years)

I would prefer not mentioning something that can not possibly happen
in your changelog ;)
