Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026CA165388
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgBTAZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:25:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBTAZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:25:48 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC21207FD;
        Thu, 20 Feb 2020 00:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582158348;
        bh=7vGB6j+bTOTlHzxGy4TsamfoNpdh8Rf6lVXkxcm4FZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bdNGfXfge2+cL2+kjXpa0rtSV/IwTh1jgcQR7IGY5oLnlw1Gsk9E4RE1RRcGYw4Ps
         zJuagMArBYNapp5QcJNDq0LjLkpZH9KnorDByjV1irXk9YZqC3K5iYEe8YaYyftlwI
         HUtRLpiTQayI0lPi9/wP6DBG5sxRaLIgXlUh6NLE=
Date:   Wed, 19 Feb 2020 16:25:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: CHECKSUM_COMPLETE question
Message-ID: <20200219162546.312218a2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CA+FuTSeSouL4pFFo8kAcU4yZ7m6C2v_6OcGHXHWeEXXNFofzXA@mail.gmail.com>
References: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com>
        <9cfc1bcb-6d67-e966-28d9-a6f290648cb0@ti.com>
        <CA+FuTSeSouL4pFFo8kAcU4yZ7m6C2v_6OcGHXHWeEXXNFofzXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 14:59:16 -0800 Willem de Bruijn wrote:
> On Wed, Feb 19, 2020 at 9:04 AM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> >
> > Hi All,
> >
> > On 12/02/2020 11:52, Grygorii Strashko wrote:  
> > > Hi All,
> > >
> > > I'd like to ask expert opinion and clarify few points about HW RX checksum offload.
> > >
> > > 1) CHECKSUM_COMPLETE - from description in <linux/skbuff.h>
> > >   * CHECKSUM_COMPLETE:
> > >   *
> > >   *   This is the most generic way. The device supplied checksum of the _whole_
> > >   *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
> > >   *   hardware doesn't need to parse L3/L4 headers to implement this.
> > >
> > > My understanding from above is that HW, to be fully compatible with Linux, should produce CSUM
> > > starting from first byte after EtherType field:
> > >   (6 DST_MAC) (6 SRC_MAC) (2 EtherType) (...                   ...)
> > >                                          ^                       ^
> > >                                          | start csum            | end csum
> > > and ending at the last byte of Ethernet frame data.
> > > - if packet is VLAN tagged then VLAN TCI and real EtherType included in CSUM,
> > >    but first VLAN TPID doesn't
> > > - pad bytes may/may not be included in csum  
> 
> Based on commit 88078d98d1bb ("net: pskb_trim_rcsum() and
> CHECKSUM_COMPLETE are friends") these bytes are expected to be covered
> by skb->csum.
> 
> Not sure about that ipv4 header pull without csum adjust.

Isn't it just because IPv4 has a header checksum and therefore what's
pulled off adds up to 0 anyway? IPv6 does not have a header csum, hence
the adjustment?
