Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C30815854F
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgBJWAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 17:00:10 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:44919 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgBJWAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 17:00:10 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 83ab46aa
        for <netdev@vger.kernel.org>;
        Mon, 10 Feb 2020 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=L8Cki6SFMhXFqqVKWex/xGjwvFE=; b=piv2Jn
        FoSYdOMX2rNbBjIXQYy/ve74edG1D0aWa6OencuVEYhAA0ZQEtnW6WBxq8Q7o9Ml
        aAOU2MdAGTf0LXoWOGsEOv1qq3meCQRpibXuny2aKVk+hJqJRG5P/kDV6IECeEMY
        W0n8qpS1lDnEcjoaoCjnw8DMZfiCV9x7dDkEElNYIx6UB3OAs/QuY0uCfG6/WDlo
        AhXL9ZZ1VrUGJ27q7jt/CKMex7DpuT5tUvlkJETaTomhsFAL2DD93C8u4V54m7eX
        5w6OD9rtBCEgk7ri9Xjy92Ftug31PACeG7+QQEyf5dUkNn4oslLYRqTocxPdoigb
        8yBuUc3mF2pVQXlw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 48c2f47a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 10 Feb 2020 21:58:31 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id p125so10760373oif.10
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 14:00:09 -0800 (PST)
X-Gm-Message-State: APjAAAXtmHavNgZN5z/FmyBQ2vNOuOgcHoPXv49gTJz3yqCv2CzEyFU4
        A385t0ov2H1iaK9zar353bJbRAltP2FvbEnZ1xI=
X-Google-Smtp-Source: APXvYqyJ9e8RkR7W+a1X+CSy+57e5kpRS/T/SN9Kopcit8mJXLu78NxH9azGGJFmew/DSZWxyOR018ZCspKenHWuXSU=
X-Received: by 2002:a05:6808:4cc:: with SMTP id a12mr832950oie.115.1581372008322;
 Mon, 10 Feb 2020 14:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-1-Jason@zx2c4.com> <20200210141423.173790-2-Jason@zx2c4.com>
 <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com> <20200210213259.GI2991@breakpoint.cc>
In-Reply-To: <20200210213259.GI2991@breakpoint.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 10 Feb 2020 22:59:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9qQ=E1L0XVe=i714AMdpMJQs3zPz=XVKW9Ck6TvGu_Hew@mail.gmail.com>
Message-ID: <CAHmME9qQ=E1L0XVe=i714AMdpMJQs3zPz=XVKW9Ck6TvGu_Hew@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/5] icmp: introduce helper for NAT'd source
 address in network device context
To:     Florian Westphal <fw@strlen.de>
Cc:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Feb 10, 2020 at 10:33 PM Florian Westphal <fw@strlen.de> wrote:
>
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On Mon, Feb 10, 2020 at 3:15 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > +               ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> > > +       }
> > > +       icmp_send(skb_in, type, code, info);
> >
> > According to the comments in icmp_send, access to
> > ip_hdr(skb_in)->saddr requires first checking for `if
> > (skb_network_header(skb_in) < skb_in->head ||
> > (skb_network_header(skb_in) + sizeof(struct iphdr)) >
> > skb_tail_pointer(skb_in))` first to be safe.
>
> You will probably also need skb_ensure_writable() to handle cloned skbs.
>
> I also suggest to check "ct->status & IPS_NAT_MASK", nat is only done if
> those bits are set.

Thanks for the suggestions. I've made these changes and they're queued
up for a v3, currently staged in wireguard-linux.git's stable branch:
https://git.zx2c4.com/wireguard-linux/log/?h=stable

Jason
