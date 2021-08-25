Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18BE3F7A68
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbhHYQWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbhHYQVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:21:52 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5DFC0611DD
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:20:51 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id t190so28191864qke.7
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HEJVL6vS0URIXz+R1rpadDnrKkkkmIihS3Y5sG4WlI=;
        b=ngOwM2o0ybZwCcD6lZ+0y5TYEwPRYDq6uZwJqDulv0Zy/ZeECFCo+28MuhV+77gHot
         IXnJL3y1Bsj/pU5OE+KuLltaH4lyZoq8buXPDgggoVPPhq88tQLWwklWMUyBJXb4I7pP
         yPzX8OurKEATEwA7rLTuxe6sM+tJ65Q/X9boM31iYtDiXdoGVKFeNv4JEO2W1dlSVAu4
         LnyfEDWqIhMweKdUseaXF4YZTFVOr6TIivN9lnRcO2RcEWyKtSqAgWa1oeVqytiN9LK8
         LeQKT8asU94d/YeSp8M5VyWXRSS86/u66YQQpQZ+x8uMi6HZCzXtrXR9iT8s4WtnS0W9
         /AXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HEJVL6vS0URIXz+R1rpadDnrKkkkmIihS3Y5sG4WlI=;
        b=ObH8fqP77S/OlSX6JYxYYHMQbIF4HiV+8LCX332aTIaZZX9NkMAK6w2xiHBoZC61SE
         9dRn45Ss75O2ATaiUlTzoq99abazcVExZSEMjrddKgVPii9DYpjcnFD35WxpMjdEs8+d
         3xOgXAOBZZh36y2u7kSRQ/DzyvVQxNu9+EOUdvvHph2n7mPChoX6gj54AIBlacGTUcS6
         Ucfbx3p5s5JsEDTDPy+9KLzwKrAWiCHFC+BfRMLjaocK0KhIDlgNFIXn60rdX4wiJXmD
         hXUgT4ogX/JCc4rZpFdp3ZIRBKL9/AGu3ZseKuxNFQ14UIckcmbCN+s/L5WhUzmc3Zy4
         6/Vg==
X-Gm-Message-State: AOAM531X2aPniTEKKQi+vl0k6rdeyvGFrzOS/YJcFsYbYzFlCj7UIZx/
        47BZoa5R1byeRE0zqg+gXEuOBk6oZZACEzjGN/B5RA==
X-Google-Smtp-Source: ABdhPJw9e/9xv+EJVkpFFB3A16VUA8QTZQwQz17yaBy3MDsjXiqap7ZkCevB4HVgau08nc4qsazA14VSZYNrmifEmvg=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr61019188ybm.234.1629908448906;
 Wed, 25 Aug 2021 09:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210825154043.247764-1-yan2228598786@gmail.com>
 <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com> <20210825090418.57fd7d2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210825090418.57fd7d2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 09:20:37 -0700
Message-ID: <CANn89iKkjtj68yksMg6fhpv2tZ9j2k0xgNK7S-wWi3e=XUrXmw@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>, Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 9:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 25 Aug 2021 08:47:46 -0700 Eric Dumazet wrote:
> > On Wed, Aug 25, 2021 at 8:41 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
> > > @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
> > >                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
> > >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
> > >                 tcp_send_challenge_ack(sk, skb);
> > > -               goto discard;
> > > +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
> >
> > I'd rather use a string. So that we can more easily identify _why_ the
> > packet was drop, without looking at the source code
> > of the exact kernel version to locate line number 1057
>
> Yeah, the line number seems like a particularly bad idea. Hopefully
> strings won't be problematic, given we can expect most serious users
> to feed the tracepoints via BPF. enum would be more convenient there,
> I'd think.
>
> > You can be sure that we will get reports in the future from users of
> > heavily modified kernels.
> > Having to download a git tree, or apply semi-private patches is a no go.
>
> I'm slightly surprised by this angle. Are there downstream kernels with
> heavily modified TCP other than Google's?

Not sure why Google is mentioned here ?
Have you ever received a public report about TCP behavior in a Google kernel ?

Over the years, we received hundreds of TCP bug reports on
netdev@vger, where users claim to use  kernel version 4.19 (or other),
when in fact they use 4.19.xxx
It takes in general multiple emails exchange before we get a more
realistic version number.
Not to mention distro kernels, or even worse private kernels, which
are not exactly easy to track for us upstream developers.
