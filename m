Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598131BAFDB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgD0VAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgD0VAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 17:00:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1E8206E2;
        Mon, 27 Apr 2020 21:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588021241;
        bh=dPHCtfjhX2EyqRgUMeS8QHKk61Rp73BqmNGDALa8iNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y7ThY+EFUW2+bKRD5NMC6m1Eu6gLnB7nVUAcZBmaybFkonRimr+V/KA/zkEXY67Ov
         PETnTIOd+APGlE/VgetDL2rkfe1reBYbzpHM4Bvj5qGmZmO8Sco+djUXt9X10Q4mqB
         kED8nvThZsEPY/yFQ8j/hYww2t3c7eSC+4EFcs00=
Date:   Mon, 27 Apr 2020 14:00:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
        <20200427204208.2501-1-Jason@zx2c4.com>
        <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:
> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
> > A user reported that packets from wireguard were possibly ignored by XDP
> > [1]. Apparently, the generic skb xdp handler path seems to assume that
> > packets will always have an ethernet header, which really isn't always
> > the case for layer 3 packets, which are produced by multiple drivers.
> > This patch fixes the oversight. If the mac_len is 0, then we assume
> > that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
> > the packet whose h_proto is copied from skb->protocol, which will have
> > the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
> > assumption correct about packets always having that ethernet header, so
> > that existing code doesn't break, while still allowing layer 3 devices
> > to use the generic XDP handler.
> 
> Is this going to work correctly with XDP_TX? presumably wireguard
> doesn't want the ethernet L2 on egress, either? And what about
> redirects?
> 
> I'm not sure we can paper over the L2 differences between interfaces.
> Isn't user supposed to know what interface the program is attached to?
> I believe that's the case for cls_bpf ingress, right?

In general we should also ask ourselves if supporting XDPgeneric on
software interfaces isn't just pointless code bloat, and it wouldn't
be better to let XDP remain clearly tied to the in-driver native use
case.
