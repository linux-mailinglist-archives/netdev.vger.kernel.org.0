Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A1241FEDF
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 02:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhJCAOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 20:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhJCAOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 20:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7375F611EE;
        Sun,  3 Oct 2021 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633219976;
        bh=44/4UXSTX7aMakCoo7kCOg/4EAa0B7TFu4vaKWWN1N8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mUcjekr7MFRa8B1hb7yyiu6ZCtmMqk2Cz5RJYLpLb+NWceikIT8Nok5vO0plZF/rE
         K50t5dnUbn3NAshBfLOYktwflEYFA15OMm6ZAyDoHBIhkbP45jbsaE9fQOHTbYQaJV
         KTIcEydZYP1u7Oaxn3zmB5eV/IqIldt/2xS2UH8NmlOOHE0GPZG7T0fpP5keOZbtF6
         YjDW6pFtSVpS79SblR39aveCzJOhzbg82GchlcWSAZeMID1l9AwxttgAJm0FttVHfu
         meIqXjkrhKR1uAPMNER7oycyOAUvNb5UsqdvAYEGmuTspi2RfAn80AjVBc25ljPF6B
         cSJFSalet1r9A==
Date:   Sat, 2 Oct 2021 17:12:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/11] ethernet: use eth_hw_addr_set()
Message-ID: <20211002171255.336bbbe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YViJtfwpSqR9wIOU@shredder>
References: <20211001213228.1735079-1-kuba@kernel.org>
        <20211001213228.1735079-4-kuba@kernel.org>
        <YViJtfwpSqR9wIOU@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 19:32:53 +0300 Ido Schimmel wrote:
> On Fri, Oct 01, 2021 at 02:32:20PM -0700, Jakub Kicinski wrote:
> > Convert all Ethernet drivers from memcpy(... ETH_ADDR)
> > to eth_hw_addr_set():
> > 
> >   @@
> >   expression dev, np;
> >   @@
> >   - memcpy(dev->dev_addr, np, ETH_ALEN)
> >   + eth_hw_addr_set(dev, np)  
> 
> Some use:
> 
> memcpy(dev->dev_addr, np, dev->addr_len)
> 
> Not sure if you missed it or if it's going to be in part 2. I assume the
> latter, but thought I would ask.

Yup, still

 417 files changed, 1239 insertions(+), 960 deletions(-)

to go. I thought I'd start upstreaming from the most obvious /
mechanical changes.

For the memcpy(..., dev->addr_len) I'm thinking of using
eth_hw_addr_set() in appropriate sections of the tree (drivers/ethernet,
driver/wireless) and convert the rest to this helper:

static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
{
	memcpy(dev->dev_addr, addr, dev->addr_len);
}

dev_addr_set() everywhere would be more obviously correct, but using
eth_hw_addr_set() seems cleaner for Ethernet drivers. Second opinion
on this would be good if you have a preference.
