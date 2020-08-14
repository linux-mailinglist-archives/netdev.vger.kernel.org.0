Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CF244520
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 08:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgHNG5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 02:57:02 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33007 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgHNG5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 02:57:02 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 67478349
        for <netdev@vger.kernel.org>;
        Fri, 14 Aug 2020 06:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=QAi5ZfWxfb4Xzi8SgOxteUmhlNQ=; b=YCQmGi
        4UYlALkG/fl0ofcAUOw/KbvtA9qrGEp5kxMvDyXhg5roMCOAQSYtH8vG2I0WLwU5
        6nAz4pLqQUvs1H7YARBb9MN6aVh0mt2r5wsfvTkNL2ieV5HVaNKEo0TTgOF6jLKR
        UyI/TmyPFBaAM4+InIjTM8L6n9mjkbtavktU/ChlDSewcXL/m8O6Iqikv0JBWtP+
        RY0wlTlzs1Eth2n10Mb1W/sy0anMlQLg9Q8Ut/R0BdvlzgRSz60bfvb4tLVoBRhw
        yE+m91QgioObFyxQarpzviMoKgo4XzXyGA2IiEhWJnnw+deS1aDKWCwHDgHZUh/p
        p2kndwbxIOtvCCJg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2909e36d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Aug 2020 06:31:23 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id z6so9834484iow.6
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 23:57:00 -0700 (PDT)
X-Gm-Message-State: AOAM531FHuQCB7r73syGdLM9oFX76yTmv1O5j5MBn4HwyPjLK2VF5IoM
        3Pcrq1NLzbimGW0+Lm6tgyVpXza3OaBTnWjyR4k=
X-Google-Smtp-Source: ABdhPJwghdP1cc93FiGzF7DYV3YVBQ0OiOTLAXH2S4PepxFfqW7ynGBXvhpsIKs6LGxjAyaWlcHQtS1g8jZD8fBXoXY=
X-Received: by 2002:a05:6638:1027:: with SMTP id n7mr1543520jan.86.1597388219934;
 Thu, 13 Aug 2020 23:56:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200813195816.67222-1-Jason@zx2c4.com> <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Aug 2020 08:56:48 +0200
X-Gmail-Original-Message-ID: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
Message-ID: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > I had originally dropped this patch, but the issue kept coming up in
> > user reports, so here's a v4 of it. Testing of it is still rather slim,
> > but hopefully that will change in the coming days.
>
> Here an alternative patch, untested:

Funny. But come on now... Why would we want to deprive our users of
system consistency?

Doesn't it make sense to allow users to use the same code across
interfaces? You actually want them to rewrite their code to use a
totally different trigger point just because of some weird kernel
internals between interfaces?

Why not make XDP more useful and more generic across interfaces? It's
very common for systems to be receiving packets with a heavy ethernet
card from the current data center, in addition to receiving packets
from a tunnel interface connected to a remote data center, with a need
to run the same XDP program on both interfaces. Why not support that
kind of simplicity?

This is _actually_ something that's come up _repeatedly_. This is a
real world need from real users who are doing real things. Why not
help them?

It's not at the expense of any formal consistency, or performance, or
even semantic perfection. It costs very little to support these
popular use cases.

[FYI, there's one tweak I'd like to make, so I'll probably send v5 ~soon.]

Jason
