Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6946C36C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhLGTS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:18:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240849AbhLGTS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 14:18:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=haCxayBggHq3rUzu/zZKh9ckK+z7U1nSBhgcWt3JX7Y=; b=V5aWZzQ6UbVqkuq/hNJ2bDfwK5
        ySiTS4hxpMZmHJ65feJJSseHGxnVK6tvP6ah6ebjqRu+3nGjUkEUM+v4FRsodNhFvLJe/9o2X+KuB
        YUWb9VPwJxcEwlfTEgAAEmBpaUX8V3g6fnKFEI+37nnrkMBQh/TriyoJFbRDj2dfUsQQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mufvw-00Fo4D-DF; Tue, 07 Dec 2021 20:15:24 +0100
Date:   Tue, 7 Dec 2021 20:15:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya+yzNDMorw4X9CT@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The qca tag header provide a TYPE value that refer to a big list of
> Frame type. In all of this at value 2 we have the type that tells us
> that is a READ_WRITE_REG_ACK (aka a mdio rw Ethernet packet)
> 
> The idea of using the tagger is to skip parsing the packet 2 times
> considering the qca tag header is present at the same place in both
> normal packet and mdio rw Ethernet packet.
> 
> Your idea would be hook this before the tagger and parse it?
> I assume that is the only way if this has to be generilized. But I
> wonder if this would create some overhead by the double parsing.

So it seems i remembered this incorrectly. Marvell call this Remote
Management Unit, RMU. And RMU makes use of bits inside the Marvell
Tag. I was thinking it was outside of the tag.

So, yes, the tagger does need to be involved in this.

The initial design of DSA was that the tagger and main driver were
kept separate. This has been causing us problems recently, we have use
cases where we need to share information between the tagger and the
driver. This looks like it is going to be another case of that.

	Andrew
