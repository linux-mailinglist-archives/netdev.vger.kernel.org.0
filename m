Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD30130DB
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfECPFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:05:19 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40600 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfECPFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:05:19 -0400
Received: by mail-yw1-f65.google.com with SMTP id t79so4517282ywc.7
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kGH4TNvulqIm9INQy5CjbV1y049U/PnIlWcW9FXC2TQ=;
        b=A01FCc9NnuD/6lIFp62Rp/A/o22y9Z7hg8sP9S53rdHRiqey8yT7pb19vI0sEkazDU
         JVED2c1ZBWpi5RiFUbRO6lbcwmgYgQmO5GFhWT5ntpC9tUz4veGs2cbX5Bs1T8ZZ9J4h
         F7GUQ2CVyi8k6seMdQ/WW5bzC9JULwKXCnvfylI9dyqVRM0/tKUd2zPZ/hPLAf1QlpA+
         yhfZGhSHjpWCsV30MiiAcRLnoLF0w8HM3Gnm9/rW5rQiVoCCQHhrcnUKA1RdNgATY6Kb
         EX35QhJYB7d6RpfyuGhQRmtxLF8hbHtLO7WHyI1YQwqHglwqSjm/F4bZoIIVVe3IDo3c
         tq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kGH4TNvulqIm9INQy5CjbV1y049U/PnIlWcW9FXC2TQ=;
        b=EVpjyiB40eojFJQa6zE2TO1Ig5I52v/DgyaNBYXQRR5OAm0bQte/9tdR87qzn11Jpo
         uT5HG9x7KkkFYk196xEJDPp82T7AIPgaTWBcXckhqs0BUq+pbfZ87sxbgg4X2LVyPHfH
         mnykiJm6PXGJVvdvVnYcq9QrdE44kqq/zjn5yj0bsrExZNtzm8nNquac4ojw2usNN8Rc
         8ucQgl7rdjxik6XhiJ8MPYAqeQbiD1wWuYLzJ4+JwKKP7CKNJun5ufe0MavtrHz9AXEN
         xwI/2U8dtow9xkyWhz8sTVPDtn6yS6Trw4bbzivSIWrLVasD0rhCc9ZV2PfKJyy4xNbl
         tpvg==
X-Gm-Message-State: APjAAAVTTqUGBwTLC9xlQXpFe+pXIpiax1iMVJHLDSi2d5pdcVZ8M38C
        sIa3QnFeNAj5nqgunHKZPu4tlw5Ss4c1wtGtF6VT/g==
X-Google-Smtp-Source: APXvYqzJ8s3zcywT+K8+6cag/yErdGeQ2xTg2b2rrf5E1tmu7XhvdP6EAE2sBd3vL2u9/e+XBrwEOwirKnWzeSAsdNo=
X-Received: by 2002:a0d:e1c1:: with SMTP id k184mr8121772ywe.430.1556895411005;
 Fri, 03 May 2019 07:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190503114721.10502-1-edumazet@google.com> <6852d902-8896-a057-5755-807d432fbc09@6wind.com>
In-Reply-To: <6852d902-8896-a057-5755-807d432fbc09@6wind.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 May 2019 10:56:39 -0400
Message-ID: <CANn89iLKaiO0GaQUSoBd8wjRzL3rJ_CNdu=c=E_a1wdjjbZOZw@mail.gmail.com>
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 10:55 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 03/05/2019 =C3=A0 13:47, Eric Dumazet a =C3=A9crit :
> > Since ip6frag_expire_frag_queue() now pulls the head skb
> > from frag queue, we should no longer use skb_get(), since
> > this leads to an skb leak.
> >
> > Stefan Bader initially reported a problem in 4.4.stable [1] caused
> > by the skb_get(), so this patch should also fix this issue.
> >
> > 296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/s=
kbuff.c:1207!
> > [296583.091734] Call Trace:
> > [296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
> > [296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
> > [296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
> > [296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
> > [296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
> > [296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
> > [296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32=
/0xa0
> > [296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 =
[ixgbe]
> > [296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_de=
frag_ipv6]
> > [296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
> > [296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
> > [296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_=
defrag_ipv6]
> > [296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
> > [296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_de=
frag_ipv6]
> > [296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
> > [296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
> >
> > Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Stfan Bader <stefan.bader@canonical.com>
> nit: the 'e' is missing in Stefan ;-)

Indeed, copy/paste error, thanks.
