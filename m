Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C761BB29C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD1ARe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:17:34 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:52765 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgD1ARe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:17:34 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a1ba24e1
        for <netdev@vger.kernel.org>;
        Tue, 28 Apr 2020 00:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8GWXpjM0XtS5Xk30KdqI6W0wfTQ=; b=tg4gT9
        3ajKZKpuSdPZ2WzBPdb7j5I3sgJhyLQ+BSYneRA793C9CCUap9YBrB575DuWBJ9D
        dORMfqUto1oFl49NlUv0oEn7FtC4zR9mOtt2LmVnyq5P57memarRW+odocGrI7eP
        0sZw9cLO6oyjgvc8Sf1w+kCYsdKR+6Yqc9ceH0F69uadRo1s2XUwBZ5O6A0ZPYTs
        eBy8iyy4AxrATQlOm/Oo223ts22hjOHTYFWnOjmHO/p6geIkBLCwu0leKfZjtW2J
        xP9mTAzpw+RX284MKoEkX7/sRgacu8li30aDskRGfXPhOB9d8qIQkIWBCJRlpYOe
        RLUAQ9qgJbDHDo1w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57ed77d1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 28 Apr 2020 00:05:54 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id b12so20930291ion.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:17:28 -0700 (PDT)
X-Gm-Message-State: AGi0PubUXhNewCB6BB+URJrtT+m9MKWjyl6Vobk6vHkUpCFMcZv/VyUM
        +uN8eGySzRVxJRRx72xrgLBWYK06xWbY1LEaH6c=
X-Google-Smtp-Source: APiQypKym4ClSUUee/GdcPSVABuokF02hFRJ8nKleqbqnwjNWkRi09lXHg+fFS5ZBhnBJrsAFhBf+skNRvg1xsOjr4o=
X-Received: by 2002:a5e:9401:: with SMTP id q1mr22767026ioj.80.1588033047735;
 Mon, 27 Apr 2020 17:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <877dy0y6le.fsf@toke.dk> <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
 <CAHmME9r6Vb7yBxBsLY75zsqROUnHeoRAjmSSfAyTwZtzcs_=kg@mail.gmail.com> <20200427171536.31a89664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427171536.31a89664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 18:17:16 -0600
X-Gmail-Original-Message-ID: <CAHmME9rr2vnCgULXEF4pPyUNU2N6g3yomPBA6mzArnPMc8kDSw@mail.gmail.com>
Message-ID: <CAHmME9rr2vnCgULXEF4pPyUNU2N6g3yomPBA6mzArnPMc8kDSw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 6:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Apr 2020 17:45:12 -0600 Jason A. Donenfeld wrote:
> > > Okay, well, I'll continue developing the v3 approach a little further
> > > -- making sure I have tx path handled too and whatnot. Then at least
> > > something viable will be available, and you can take or leave it
> > > depending on what you all decide.
> >
> > Actually, it looks like egress XDP still hasn't been merged. So I
> > think this patch should be good to go in terms of what it is.
>
> TX and redirect don't require the XDP egress hook to function.

Oh, you meant the TX and redirect actions returned from the ingress
hook. Gotcha. The paths that those take don't appear to rely on having
the fake header though, whereas the actual xdp_progs that run do rely
on that, which is why it's added there.
