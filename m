Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5157146CA17
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 02:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhLHBjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 20:39:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhLHBjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 20:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oGqvZL2bCZkbyBRTHXbtR3qrLS4yqTi1pyKcjkCRtPw=; b=KylLcYPqSxpG0OHphp2+AODqfl
        ISTVV+pr5DuEniJr4NE39ZJbTxZCD9VfxBQRoOOi22qr2OKiOHc4ZwnNDBQ/ViffoELnQsk/QJLLM
        fOILvzz1fcdaZC+J0vzdE3RfcAmu1X250IRGRU3hMjFsiaC6K8KWrmJHBsXOaFDG1jVM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mulrq-00FpaB-Vl; Wed, 08 Dec 2021 02:35:34 +0100
Date:   Wed, 8 Dec 2021 02:35:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <YbAL5pP6IrN1ey5e@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <Ya/mD/KUYDLb7qed@lunn.ch>
 <20211207231449.bk5mxg3z2o7mmtzg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207231449.bk5mxg3z2o7mmtzg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 01:14:49AM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 11:54:07PM +0100, Andrew Lunn wrote:
> > > I considered a simplified form like this, but I think the tagger private
> > > data will still stay in dp->priv, only its ownership will change.
> > 
> > Isn't dp a port structure. So there is one per port?
> 
> Yes, but dp->priv is a pointer. The thing it points to may not
> necessarily be per port.
> 
> > This is where i think we need to separate shared state from tagger
> > private data. Probably tagger private data is not per port. Shared
> > state between the switch driver and the tagger maybe is per port?
> 
> I don't know whether there's such a big difference between
> "shared state" vs "private data"?

The difference is to do with stopping the kernel exploding when the
switch driver is not using the tagger it expects.

Anything which is private to the tagger is not a problem. Only the
tagger uses it, so it cannot be wrong.

Anything which is shared between the tagger and the switch driver we
have to be careful about. We are just passing void * pointers
about. There is no type checking. If i'm correct about the 1:N
relationship, we can store shared state in the tagger. The tagger
should be O.K, because it only ever needs to deal with one format of
shared state. The switch driver needs to handle N different formats of
shared state, depending on which of the N different taggers are in
operation. Ideally, when it asks for the void * pointer for shared
information, some sort of checking is performed to ensure the void *
is what the switch driver actually expects. Maybe it needs to pass the
tag driver it thinks it is talking to, or as well as getting the void
* back, it also gets the tag enum and it verifies it actually knows
about that tag driver.

     Andrew
