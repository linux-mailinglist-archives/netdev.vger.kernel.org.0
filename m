Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECDC5FA1D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGDOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:32:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfGDOcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WqfUMJML9WSOHiE+CrfUgXW6vEXB3qi3LNfexS8xML0=; b=3v1Lt8NFOhvJOPPSJPTOPzt1RV
        3f3ZhkET4aT3VtARntPcv8Hwo5Sub5yXo3h8bAQNmIy9vrEvC/lKF4yfV0MUSz+VyTcV4Tcu3Vpag
        0432dP8eFpEt9Q9BdBKhutojaDf0VW/bi4DfmQAAAsx9gfaPbUVJTKxVrb6igSVph8zc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj2mB-0004Ep-66; Thu, 04 Jul 2019 16:31:55 +0200
Date:   Thu, 4 Jul 2019 16:31:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190704143155.GE13859@lunn.ch>
References: <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <20190703181851.GP20101@unicorn.suse.cz>
 <20190704080435.GF2250@nanopsycho>
 <20190704115236.GR20101@unicorn.suse.cz>
 <6c070d62ffe342f5bc70556ef0f85740d04ae4a3.camel@sipsolutions.net>
 <20190704121718.GS20101@unicorn.suse.cz>
 <2f1a8edb0b000b4eb7adcaca0d1fb05fdd73a587.camel@sipsolutions.net>
 <20190704125315.GT20101@unicorn.suse.cz>
 <a6fbee05df0efd2528a06922bcb514d321b1a8bc.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6fbee05df0efd2528a06922bcb514d321b1a8bc.camel@sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> OK, here I guess I see what you mean. You're saying if ethtool were to
> send a value/mask of "0..0100/0..0111" you wouldn't know what to do with
> BIT(4) as long as the kernel knows about that bit?
> 
> I guess the difference now is depending on the operation. NLA_BITFIELD32
> is sort of built on the assumption of having a "toggle" operation. If
> you want to have a "set to" operation, then you don't really need the
> selector/mask at all, just the value.

I don't think it is as simple as this. User space has a few different
things it wants to pass to the kernel:

I want to set this bit to 0
I want to set this bit to 1
I don't want to change this bit
In my world view, this bit is unused

The kernel has had a long history of trouble with flag bits in system
calls. It has not validated that unused bits are clear. Meaning when
you actually want to make use of the unused bits you cannot because
userspace has been passing random values in them since day 1.

We need a design which is clear to everybody which bits are unused and
should be validated as being unused and an error returned if an unused
bit is actually used. A value and a mask is not sufficient for
this. We need the length in bits.

      Andrew
