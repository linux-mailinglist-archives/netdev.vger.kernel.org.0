Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11606362DD0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 06:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhDQE7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 00:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhDQE7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 00:59:31 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F35DC061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 21:59:05 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g38so32427733ybi.12
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 21:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C6bbmprffd+fOzugJa7DHVeiVO8dMs/4piGp2pCGG3I=;
        b=IqaZA97LfflsvYGxD6F809CgBq3nGPHXQBnUcjEMrv5r1X+TRrhwG15Gipt9hmmasq
         ibHiMqzZNrKWkxYh4CrFs7/zNCNTNFQkGy2BW4KRwJ456VXM/T9Wh7KU2U0kqxmYE+Ur
         agzXdjNr9arEK54P3weMhFnChKCnmZ/jTaHDNLymnv4yzCruhMCcYE/yJwTCqetHlDgP
         PwmeeDA8t8SuV91p0rbe50MJA74kAz9zp40jlgKWNBGoXGbbgkwRbpnf/nE/fuC6rCWw
         bvsng2YQDTCnDBRTfb9bU+BtLoSkrhRjAfcsvxXHNn2UX6TpP6PPxAQ/ScGUW+bBPNeI
         RbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C6bbmprffd+fOzugJa7DHVeiVO8dMs/4piGp2pCGG3I=;
        b=bd2eME8aaoSmF2vqJ16pRYL3Ci47VCasVwijlk9rctjwUHl3rj0uXP8dZ13sKNPyxg
         ZmWs1zdUSyf120N4XfHfxJJN4YbirQYx5aEYXIlQR+OMiToUzgKV9qdieWJ7UB2nR9+e
         JInf5rMuKL/p9deHzi0Kj5/6Cd0FHmKfuC89Aos1r0kWV6rX1xtKNbVmWarkzp9jP8cf
         yWRkpqyxsKvPHOrtsOWWZGX+gaV0LLMDzdQNibr1vzwQzStDxu32xs/GXUCYRdT3fUY6
         bmQUHCW5SqNrxLI8zz0SZoJ1OKLDxxYPHUVeLDudxMYP6X3igzvK26sAkigOPBwGw9Cj
         sJjg==
X-Gm-Message-State: AOAM533iz7jrDvVgt0MV2oVC+BWinjJnrAq3Wdes5gIkFAdkbBH9mjGs
        6MiHw8lpEsjYL24E1RPmeUAWOJpdgoGhJ5WToD1yOA==
X-Google-Smtp-Source: ABdhPJykMguzo/vuiaUHmI12y4yI/iO1SaJXOQH1FQ15EXpkdE1qqCHjfHEglksBwOtGJL89slj9qL1sP+rA+nKc5QE=
X-Received: by 2002:a25:4244:: with SMTP id p65mr3485713yba.452.1618635544425;
 Fri, 16 Apr 2021 21:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210416105142.38149-1-zhaoya.gaius@bytedance.com>
 <CANn89iJ5-4u98sGXt6oH5ZbWGFcYCy3T-B+qktvm3-cMkFQXKA@mail.gmail.com> <CAPXF5UVG+c0STZORvdaz6Mk8fwxE7DTBtTp=uF51xMrFL0R02w@mail.gmail.com>
In-Reply-To: <CAPXF5UVG+c0STZORvdaz6Mk8fwxE7DTBtTp=uF51xMrFL0R02w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 17 Apr 2021 06:58:53 +0200
Message-ID: <CANn89i+rPwy=_T1aaCGTkUoEHaAXeHe6Ep3wLKhW1VRpTL4EfA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] tcp: fix silent loss when syncookie is trigered
To:     =?UTF-8?B?6LW15Lqa?= <zhaoya.gaius@bytedance.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 12:45 AM =E8=B5=B5=E4=BA=9A <zhaoya.gaius@bytedance=
.com> wrote:
>
> On Fri, Apr 16, 2021 at 7:52 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Apr 16, 2021 at 12:52 PM zhaoya <zhaoya.gaius@bytedance.com> wr=
ote:
> > >
> > > When syncookie is triggered, since $MSSID is spliced into cookie and
> > > the legal index of msstab  is 0,1,2,3, this gives client 3 bytes
> > > of freedom, resulting in at most 3 bytes of silent loss.
> > >
> > > C ------------seq=3D12345-------------> S
> > > C <------seq=3Dcookie/ack=3D12346-------- S S generated the cookie
> > >                                         [RFC4987 Appendix A]
> > > C ---seq=3D123456/ack=3Dcookie+1-->X      S The first byte was loss.
> > > C -----seq=3D123457/ack=3Dcookie+1------> S The second byte was recei=
ved and
> > >                                         cookie-check was still okay a=
nd
> > >                                         handshake was finished.
> > > C <--------seq=3D.../ack=3D12348--------- S acknowledge the second by=
te.
> >
> >
> > I think this has been discussed in the past :
> > https://kognitio.com/blog/syn-cookies-ate-my-dog-breaking-tcp-on-linux/
> >
> > If I remember well, this can not be fixed "easily"
> >
> > I suspect you are trading one minor issue with another (which is
> > considered more practical these days)
> > Have you tried what happens if the server receives an out-of-order
> > packet after the SYN & SYN-ACK ?
> > The answer is : RST packet is sent, killing the session.
> >
> > That is the reason why sseq is not part of the hash key.
>
> Yes, I've tested this scenario. More sessions do get reset.
>
> If a client got an RST, it knew the session failed, which was clear. Howe=
ver,
> if the client send a character and it was acknowledged, but the server di=
d not
> receive it, this could cause confusion.
> >
> > In practice, secure connexions are using a setup phase where more than
> > 3 bytes are sent in the first packet.
> > We recommend using secure protocols over TCP. (prefer HTTPS over HTTP,
> > SSL over plaintext)
>
> Yes, i agree with you. But the basis of practice is principle.
> Syncookie breaks the
> semantics of TCP.
> >
> > Your change would severely impair servers under DDOS ability to really
> > establish flows.
>
> Would you tell me more details.
> >
> > Now, if your patch is protected by a sysctl so that admins can choose
> > the preferred behavior, then why not...
>
> The sysctl in the POC is just for triggering problems easily.
>
> So the question is, when syncookie is triggered, which is more important,
> the practice or the principle?

SYNCOOKIES have lots of known limitations.

You can disable them if you need.

Or you can add a sysctl or socket options so that each listener can
decide what they want.

I gave feedback of why your initial patch was _not_ good.

I think it can render a server under DDOS absolutely unusable.
Exactly the same situation than _without_ syncookies being used.
We do not want to go back to the situation wed had before SYNCOOKIES
were invented.

I think you should have put a big warning in the changelog to explain
that you fully understood
the risks.

We prefer having servers that can still be useful, especially ones
serving 100% HTTPS traffic.

Thank you.
