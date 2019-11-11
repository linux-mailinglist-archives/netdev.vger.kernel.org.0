Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D181CF7816
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKKPxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:53:47 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37557 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfKKPxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:53:46 -0500
Received: by mail-io1-f67.google.com with SMTP id 1so15105236iou.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FJ/7Xjql9joXVcK8sa+4UElmLiYfJPeDkhbXJfFPJbs=;
        b=eF1/kIYClCt2WFCqVGU4Zf/EgpLNsBd4f0oCpvdu2kVpMe4QmyxOy8iVD1OMsb/IaV
         a1p/jqJUjjbaTBd3SEDdcwXbVZ1JrwmReG6LFhz6aqg3hck4fsdF6K68YNj8Ux9HiTCK
         ZyZLTAw94KbsynfhNm6ZKR8dyTdf8FUVJKTzGQBCI1w9C13bduSaBzoZolaKOMB3GAce
         BKrRYxnzB8iV43WYbpoVH/bysiSvqfIYkRigVDbuDzPRThvcvnQw+hZxGaNhvuPQ/UcP
         KIQdGLyeFB+rvfFY/EqC1WGP1Q97pNbmk9C933sSy05bq1ho942IpxYOflskHJv0lJWe
         UZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FJ/7Xjql9joXVcK8sa+4UElmLiYfJPeDkhbXJfFPJbs=;
        b=XqssOMf+MH0UDQKNacgkUJcqWJ72JdAEd3zWXs0VKRVZGePFYZE8PskNmcQ+9csWjT
         ooa2vPy+acm1JLRX0whk0HBBkKtmnt8fcxDz6Fr5+iRh1w4n6sqF8SkK/a447ymW7aHI
         Uub8L9fmZlBjl26FULvuDr8DZxFmgD5PiXo/mJb9nM6i4Gjp6hnrUF1ZTy/K0dO2WltU
         ++bH7/v16ZseXX8d1jTxbbP3QqZSanpDPu/25OvX6z6FqyMrNgoB9jzq+LSXaYfRNuB2
         tnkivHjQXlM8AOA82g1wr5pvITnVX9yuiRVxzoS4Ls+aDLul/bmIDeaiMGxHXKecs7pK
         aGGQ==
X-Gm-Message-State: APjAAAVjIIn852ygXxPVBivYpKpBPW4G3/VVYQc74fl+KpDrPy93U6pz
        BPqqjmYsHox0uFAaKdqQA/nSkhPlf++HbpF/xHmtSg==
X-Google-Smtp-Source: APXvYqxi2nekNDZv9/xs0cPIuurtM6auyN95/capgrWHgFu+xVx6vxCclCpc3oHr9lZpfqqaZJNfxecWvLBtSOHYKy0=
X-Received: by 2002:a5e:8e02:: with SMTP id a2mr397196ion.269.1573487625670;
 Mon, 11 Nov 2019 07:53:45 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
 <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
 <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com> <CAC=O2+R3gHT6RtqL6RPiWsyuptpa+vrSQsxdN=DW1LaD1B-vGw@mail.gmail.com>
In-Reply-To: <CAC=O2+R3gHT6RtqL6RPiWsyuptpa+vrSQsxdN=DW1LaD1B-vGw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 11 Nov 2019 07:53:33 -0800
Message-ID: <CANn89iLPfy6Nbk0pouySQq=xVsEOGJMkVEXM=nKWW3=e4OGjoQ@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     Thiemo Nagel <tnagel@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 12:53 AM Thiemo Nagel <tnagel@google.com> wrote:
>
> Hey Eric,
>
> I've been thinking about this some more. The prandom_u32() description
> says: "This algorithm is NOT considered safe for cryptographic use."
> -- Afaiu this implies that an attacker could deduce internal state by
> looking at a sequence of random numbers.

Keep in mind that we need some entropy, and some device can not provide any=
.

prandom_u32() gets some reasonable amount of entropy. And it seems
better than ' jiffies' .

If you want strong (hardware) generators, I guess next Android/Chrome
devices will cost a bit more.


 Consequently, I believe that
> we shouldn't use prandom_* for data that gets sent over the wire.
> Instead get_random_* should be used which is described as
> cryptographically secure.
>

If IP ID had to be cryptographically secure, you can be sure we would
have addressed the problem 20 years ago.

Please discuss this matter with random maintainers, not networking ones ;)

> Kind regards,
> Thiemo
>
> From /drivers/char/random.c:
>
> [About get_random_*:]
>  * Besides the obvious cryptographic uses, these numbers are also good
>  * for seeding TCP sequence numbers, and other places where it is
>  * desirable to have numbers which are not only random, but hard to
>  * predict by an attacker.
> [...]
>  * It *is* safe to expose get_random_int() output to attackers (e.g. as
>  * network cookies); given outputs 1..n, it's not feasible to predict
>  * outputs 0 or n+1.
> [...]
>
>  * prandom_u32()
>  * -------------
>  *
>  * For even weaker applications, see the pseudorandom generator
>  * prandom_u32(), prandom_max(), and prandom_bytes().  If the random
>  * numbers aren't security-critical at all, these are *far* cheaper.
>  * Useful for self-tests, random error simulation, randomized backoffs,
>  * and any other application where you trust that nobody is trying to
>  * maliciously mess with you by guessing the "random" numbers.
>
>
> On Mon, Nov 4, 2019 at 4:50 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Nov 4, 2019 at 7:24 AM Thiemo Nagel <tnagel@google.com> wrote:
> > >
> > > Thanks a lot, Eric!
> > >
> > > Grepping through the source, it seems to me there are two more
> > > occurrences of jiffies in inet_id:
> > >
> > > https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L120
> > > https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L419
> > >
> >
> > Indeed.
> >
> > The one in dccp_v4_connect() has been handled in my patch.
> > I missed it in dccp_v4_request_recv_sock()
> >
> > Thanks.
> >
> > > Kind regards,
> > > Thiemo
>
>
>
> --
>
> Thiemo Nagel
>
> Software Engineer
>
>
> Google Germany GmbH, Erika-Mann-Stra=C3=9Fe 33, 80686 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
>
> Registergericht und -nummer: Hamburg, HRB 86891
>
> Sitz der Gesellschaft: Hamburg
