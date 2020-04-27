Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E01BB05C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD0VTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgD0VTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 17:19:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26AE42072D;
        Mon, 27 Apr 2020 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588022361;
        bh=NZ/1nmmp9+94CdYDXWkJbjWsRq2HQiKbZXX8DdJ3vvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EU64SwoXG/ZiaE5BX4InewVLIqpp1Tq2qEHT2MNMlFF7yG3307clwQEbugERp1j9K
         KLBCXGU5ueU6Bi0kwYIFhJ6N3gAajxKBxCTdLXg7szpfskEC5UHzEUGB0trifEZic0
         etFH0eL/Yko7f+mkz2B0ag9xBoALNGH+V1T6IFyo=
Date:   Mon, 27 Apr 2020 14:19:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200427141918.7b8382d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHmME9q_T9kPn329sWkRXpAxyaeVUnySTt7fNkeYW19f3FCPfA@mail.gmail.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
        <20200427204208.2501-1-Jason@zx2c4.com>
        <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9q_T9kPn329sWkRXpAxyaeVUnySTt7fNkeYW19f3FCPfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 15:08:55 -0600 Jason A. Donenfeld wrote:
> On Mon, Apr 27, 2020 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:  
> > > On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:  
> > > > A user reported that packets from wireguard were possibly ignored by XDP
> > > > [1]. Apparently, the generic skb xdp handler path seems to assume that
> > > > packets will always have an ethernet header, which really isn't always
> > > > the case for layer 3 packets, which are produced by multiple drivers.
> > > > This patch fixes the oversight. If the mac_len is 0, then we assume
> > > > that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
> > > > the packet whose h_proto is copied from skb->protocol, which will have
> > > > the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
> > > > assumption correct about packets always having that ethernet header, so
> > > > that existing code doesn't break, while still allowing layer 3 devices
> > > > to use the generic XDP handler.  
> > >
> > > Is this going to work correctly with XDP_TX? presumably wireguard
> > > doesn't want the ethernet L2 on egress, either? And what about
> > > redirects?
> > >
> > > I'm not sure we can paper over the L2 differences between interfaces.
> > > Isn't user supposed to know what interface the program is attached to?
> > > I believe that's the case for cls_bpf ingress, right?  
> >
> > In general we should also ask ourselves if supporting XDPgeneric on
> > software interfaces isn't just pointless code bloat, and it wouldn't
> > be better to let XDP remain clearly tied to the in-driver native use
> > case.  
> 
> Seems nice to be able to use XDP everywhere as a means of packet
> processing without context switch, right?

cls_bpf has more capabilities as it can integrate with the stack and
poke at various skb bits. Native XDP is faster, because it can short
circuit normal stack processing and skb allocation, if we can figure
out inside the BPF program that we want to redirect or drop the frame.
But software devices cannot take advantage of that speed up, the frame
is already inside the stack.
