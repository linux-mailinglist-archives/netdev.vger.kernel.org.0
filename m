Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C144362B95
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDPWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhDPWqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 18:46:13 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D07C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 15:45:48 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w23so28483791ejb.9
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 15:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EAc+sFWHuHmrU5lTSO9F5779cW2Dcf8sjmB9+TjApkI=;
        b=ijndgSH6LCAaK+E6nFzlV7hVCrKvErhpEXwTSyZoqKwxUJOVrOmXFyisIgcC5pLUAs
         YGyQwoK+OW2BJeNTkQMAZ35X2laLc0fQt97WCjwgRAQM6C4LOaWulag+Vf3Pc4tUzrde
         +bxlFNIYIF5i2ctTelaglTz1wdCyMkhs9x4vqWLT0KQ96AY1OnKb5Gf8t3Fmo4nTAOPg
         m2gUtJViLQ8lUtpDdQzGjLdJl4gX1fbOEUHIVA/XpKZ4WhaBhSp4EpdASjQaYKmsnTgw
         FzRhKjjE0Ad7eNoqpufTgqJmIMa41KqS2xA08NfxGFnhU/NBBva5zZ2zBH1lCoLrY3R2
         c+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EAc+sFWHuHmrU5lTSO9F5779cW2Dcf8sjmB9+TjApkI=;
        b=hf242TQVCpq3P5kwZOHJnSYfVBDS+AZkeLcR72HAFiQiyj0FJvHdfwt8AkVqIUTAfR
         pTG3hAZzxUPwFemUFqD2oehH5oWSs9LwXnqu10eFlsuA69njjXlKXqY6ZBxHjmJPlYWm
         rDj8IWEKK/uwzGuh/73Chun5FIyZdGyaRSGAsANFl4A0tb/OefmxYWx1Kc6zF9dG5Vzg
         4CpFwXfKeS+kQlhGQEZRq08kYKcD/kLywzJD863JoKCEKD3RbYB3CAzo6bRP6LLnfiOr
         256k0fgQ/gqJrxUO9Oaei4RXd5i6p+elBVZu9G4hrTi+jMQI5RDEEONvunsRJv/nCBS9
         gfYQ==
X-Gm-Message-State: AOAM533qFGvcYv3jqWXLXIENM8EpGSttTCj31wjol0GqbTPDmtaeFGI+
        uVxIwXnh4xguTtk6S+10ZzEJNSwa16MSua4frzGFNQ==
X-Google-Smtp-Source: ABdhPJzdYjMOIM983g0JP8aujANOQUHsV/lsi50TJtjab69daqBjPSj6zF8t/b8Ey/gY1ykcr3cMY5s0vjsFbyJspmo=
X-Received: by 2002:a17:907:2485:: with SMTP id zg5mr10487112ejb.43.1618613147071;
 Fri, 16 Apr 2021 15:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210416105142.38149-1-zhaoya.gaius@bytedance.com> <CANn89iJ5-4u98sGXt6oH5ZbWGFcYCy3T-B+qktvm3-cMkFQXKA@mail.gmail.com>
In-Reply-To: <CANn89iJ5-4u98sGXt6oH5ZbWGFcYCy3T-B+qktvm3-cMkFQXKA@mail.gmail.com>
From:   =?UTF-8?B?6LW15Lqa?= <zhaoya.gaius@bytedance.com>
Date:   Sat, 17 Apr 2021 06:45:35 +0800
Message-ID: <CAPXF5UVG+c0STZORvdaz6Mk8fwxE7DTBtTp=uF51xMrFL0R02w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] tcp: fix silent loss when syncookie is trigered
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 7:52 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Apr 16, 2021 at 12:52 PM zhaoya <zhaoya.gaius@bytedance.com> wrote:
> >
> > When syncookie is triggered, since $MSSID is spliced into cookie and
> > the legal index of msstab  is 0,1,2,3, this gives client 3 bytes
> > of freedom, resulting in at most 3 bytes of silent loss.
> >
> > C ------------seq=12345-------------> S
> > C <------seq=cookie/ack=12346-------- S S generated the cookie
> >                                         [RFC4987 Appendix A]
> > C ---seq=123456/ack=cookie+1-->X      S The first byte was loss.
> > C -----seq=123457/ack=cookie+1------> S The second byte was received and
> >                                         cookie-check was still okay and
> >                                         handshake was finished.
> > C <--------seq=.../ack=12348--------- S acknowledge the second byte.
>
>
> I think this has been discussed in the past :
> https://kognitio.com/blog/syn-cookies-ate-my-dog-breaking-tcp-on-linux/
>
> If I remember well, this can not be fixed "easily"
>
> I suspect you are trading one minor issue with another (which is
> considered more practical these days)
> Have you tried what happens if the server receives an out-of-order
> packet after the SYN & SYN-ACK ?
> The answer is : RST packet is sent, killing the session.
>
> That is the reason why sseq is not part of the hash key.

Yes, I've tested this scenario. More sessions do get reset.

If a client got an RST, it knew the session failed, which was clear. However,
if the client send a character and it was acknowledged, but the server did not
receive it, this could cause confusion.
>
> In practice, secure connexions are using a setup phase where more than
> 3 bytes are sent in the first packet.
> We recommend using secure protocols over TCP. (prefer HTTPS over HTTP,
> SSL over plaintext)

Yes, i agree with you. But the basis of practice is principle.
Syncookie breaks the
semantics of TCP.
>
> Your change would severely impair servers under DDOS ability to really
> establish flows.

Would you tell me more details.
>
> Now, if your patch is protected by a sysctl so that admins can choose
> the preferred behavior, then why not...

The sysctl in the POC is just for triggering problems easily.

So the question is, when syncookie is triggered, which is more important,
the practice or the principle?
