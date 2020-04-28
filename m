Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3DB1BB2FD
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgD1Akl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgD1Akl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:40:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30DBC206B8;
        Tue, 28 Apr 2020 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588034440;
        bh=lpsxGKz5/sU4u/BxoYwhurjfGL3Ah4t7W8gWsJ1KshY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZxNd6O4QxihXEnW6dxQ6t7o0eh0wOwIKY8vMnGDjR3MX49HWJsWkVNqRr5BPLLq5x
         r4+qC5sIjAp9yIOb7rN8x2n8imjlf4avX9jLebqJv/8ksH+YZauGFFvnjJtezra17Z
         KuSLOjfrlxy6g5+iHsNAZKNa0OPKJtm3qiQzyYx8=
Date:   Mon, 27 Apr 2020 17:40:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200427174038.7d2f2ed8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHmME9rr2vnCgULXEF4pPyUNU2N6g3yomPBA6mzArnPMc8kDSw@mail.gmail.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
        <20200427204208.2501-1-Jason@zx2c4.com>
        <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877dy0y6le.fsf@toke.dk>
        <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
        <CAHmME9r6Vb7yBxBsLY75zsqROUnHeoRAjmSSfAyTwZtzcs_=kg@mail.gmail.com>
        <20200427171536.31a89664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9rr2vnCgULXEF4pPyUNU2N6g3yomPBA6mzArnPMc8kDSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 18:17:16 -0600 Jason A. Donenfeld wrote:
> On Mon, Apr 27, 2020 at 6:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 27 Apr 2020 17:45:12 -0600 Jason A. Donenfeld wrote:  
> > > > Okay, well, I'll continue developing the v3 approach a little further
> > > > -- making sure I have tx path handled too and whatnot. Then at least
> > > > something viable will be available, and you can take or leave it
> > > > depending on what you all decide.  
> > >
> > > Actually, it looks like egress XDP still hasn't been merged. So I
> > > think this patch should be good to go in terms of what it is.  
> >
> > TX and redirect don't require the XDP egress hook to function.  
> 
> Oh, you meant the TX and redirect actions returned from the ingress
> hook. Gotcha. The paths that those take don't appear to rely on having
> the fake header though, whereas the actual xdp_progs that run do rely
> on that, which is why it's added there.

Ack, but if the redirection target is a real Ethernet device it will
see a frame without a L2 header, right? Redirect from a real Ethernet
device to a L3 one and vice versa remains broken.
