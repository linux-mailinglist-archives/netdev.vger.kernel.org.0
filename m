Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A763D5F896
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfGDMxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:53:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:37780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfGDMxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:53:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03806B049;
        Thu,  4 Jul 2019 12:53:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2655DE0159; Thu,  4 Jul 2019 14:53:15 +0200 (CEST)
Date:   Thu, 4 Jul 2019 14:53:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190704125315.GT20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <20190703181851.GP20101@unicorn.suse.cz>
 <20190704080435.GF2250@nanopsycho>
 <20190704115236.GR20101@unicorn.suse.cz>
 <6c070d62ffe342f5bc70556ef0f85740d04ae4a3.camel@sipsolutions.net>
 <20190704121718.GS20101@unicorn.suse.cz>
 <2f1a8edb0b000b4eb7adcaca0d1fb05fdd73a587.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f1a8edb0b000b4eb7adcaca0d1fb05fdd73a587.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 02:21:52PM +0200, Johannes Berg wrote:
> On Thu, 2019-07-04 at 14:17 +0200, Michal Kubecek wrote:
> > On Thu, Jul 04, 2019 at 02:03:02PM +0200, Johannes Berg wrote:
> > > On Thu, 2019-07-04 at 13:52 +0200, Michal Kubecek wrote:
> > > > 
> > > > There is still the question if it it should be implemented as a nested
> > > > attribute which could look like the current compact form without the
> > > > "list" flag (if there is no mask, it's a list). Or an unstructured data
> > > > block consisting of u32 bit length 
> > > 
> > > You wouldn't really need the length, since the attribute has a length
> > > already :-)
> > 
> > It has byte length, not bit length. The bitmaps we are dealing with
> > can have any bit length, not necessarily multiples of 8 (or even 32).
> 
> Not sure why that matters? You have the mask, so you don't really need
> to additionally say that you're only going up to a certain bit?
> 
> I mean, say you want to set some bits <=17, why would you need to say
> that they're <=17 if you have a
>  value: 0b00000000'000000xx'xxxxxxxx'xxxxxxxx
>  mask:  0b00000000'00000011'11111111'11111111

One scenario that I can see from the top of my head would be user
running

  ethtool -s <dev> advertise 0x...

with hex value representing some subset of link modes. Now if ethtool
version is behind kernel and recognizes fewer link modes than kernel
but in a way that the number rounded up to bytes or words would be the
same, kernel has no way to recognize of those zero bits on top of the
mask are zero on purpose or just because userspace doesn't know about
them. In general, I believe the absence of bit length information is
something protocols would have to work around sometimes.

The submitted implementation doesn't have this problem as it can tell
kernel "this is a list" (i.e. I'm not sending a value/mask pair, I want
exactly these bits to be set). Thus it can easily implement requests of
both types (value/mask or just value):

  ethtool -s <dev> advertise 0x2f
  ethtool -s <dev> advertise 0x08/0x0c
  ethtool -s <dev> advertise 100baseT/Full off 1000baseT/Full on

and could be as easily extended to support also

  ethtool -s <dev> advertise 100baseT/Full 1000baseT/Full

Michal
