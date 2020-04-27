Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4111BAFF9
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD0VJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:09:09 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57889 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgD0VJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 17:09:09 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id eda53648
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Y7CA7CJdHczKK53LQ+8K9ck5AfY=; b=0u/skW
        88OllipZXEUEZNHuxXQS4m8Et75m7Y1wjQGlYRlHC/feIAgrHfwzakqECR1+9/yC
        OtlW31kKf1yXlkoDGQRs2EHBDt2WRzLRVCWOwTk07Ei1QkJH/ZvNk+ii2wQ+Rww8
        rpZJ8u8l1OhPE017LInloDVfMJmh3WHykfozJjUmbCuffHXxR9jxH47JCEyTmKYI
        ABsGxnqci51sCIdO9DCkTJuRPYh2ZJYc7xW6nOjihcKf3UwqqS67/VWaPtAyTybm
        ikMVCKaJRNzkLvZVYMGIrjiqInV54UhFy0Z+B0kcBxN4K1eNPPRZpcwh5qtTOJr+
        B5RXry/fq9cbxqNA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f4c1770e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 20:57:33 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id q10so18196358ile.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:09:06 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ6jS+66FxGFO5Co1mSWvhX47aG8t6Zvu2gi+M+ttMSRi2+L57R
        ZeotwqgrTOxugpWBwy0JOC/KtgYYjV1igEQYF1M=
X-Google-Smtp-Source: APiQypJ56Fak/DXfyi+m4x4RZkS5n8G82z1oSDtVkmsbRerl+XCQZqJu8e8yeg8apUvKbsW+udvxDCqbne4GGLqncQE=
X-Received: by 2002:a92:bf0b:: with SMTP id z11mr23027059ilh.207.1588021746146;
 Mon, 27 Apr 2020 14:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 15:08:55 -0600
X-Gmail-Original-Message-ID: <CAHmME9q_T9kPn329sWkRXpAxyaeVUnySTt7fNkeYW19f3FCPfA@mail.gmail.com>
Message-ID: <CAHmME9q_T9kPn329sWkRXpAxyaeVUnySTt7fNkeYW19f3FCPfA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:
> > On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
> > > A user reported that packets from wireguard were possibly ignored by XDP
> > > [1]. Apparently, the generic skb xdp handler path seems to assume that
> > > packets will always have an ethernet header, which really isn't always
> > > the case for layer 3 packets, which are produced by multiple drivers.
> > > This patch fixes the oversight. If the mac_len is 0, then we assume
> > > that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
> > > the packet whose h_proto is copied from skb->protocol, which will have
> > > the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
> > > assumption correct about packets always having that ethernet header, so
> > > that existing code doesn't break, while still allowing layer 3 devices
> > > to use the generic XDP handler.
> >
> > Is this going to work correctly with XDP_TX? presumably wireguard
> > doesn't want the ethernet L2 on egress, either? And what about
> > redirects?
> >
> > I'm not sure we can paper over the L2 differences between interfaces.
> > Isn't user supposed to know what interface the program is attached to?
> > I believe that's the case for cls_bpf ingress, right?
>
> In general we should also ask ourselves if supporting XDPgeneric on
> software interfaces isn't just pointless code bloat, and it wouldn't
> be better to let XDP remain clearly tied to the in-driver native use
> case.

Seems nice to be able to use XDP everywhere as a means of packet
processing without context switch, right?
