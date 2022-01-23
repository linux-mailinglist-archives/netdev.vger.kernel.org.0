Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FD6497261
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 16:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbiAWPTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 10:19:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49562 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbiAWPTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 10:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+Ge3GOK155uvVNrFZBKJI/aKrTuzo/L7tJ7TFAeiQ08=; b=dhwcg7tmmvAWuIfn4YzwbsJoWG
        FirE4jqY8WYCvrlGPcg8F/DHO3//on/RHAty4FtD7AYbRKS/F5BSy1PdgpMoGVloIQjbgtBKl5iKn
        ps7MqYw+I39qrY2azvkZoJd9Ja6yvbH8R6LZTUdag4FgGWzgP9YZPP3pIiS90SjnD+48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBeeY-002OAZ-Vi; Sun, 23 Jan 2022 16:19:38 +0100
Date:   Sun, 23 Jan 2022 16:19:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Tal <moshet@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] ethtool: Fix link extended state for big endian
Message-ID: <Ye1yCtN9g/9+Sv5Q@lunn.ch>
References: <20220120095550.5056-1-moshet@nvidia.com>
 <Yel1AuSIcab+VUsO@lunn.ch>
 <172d43f5-c223-6d6f-c625-dbf1b40c4d15@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172d43f5-c223-6d6f-c625-dbf1b40c4d15@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The Netlink message was defined to only pass u8 and we can't change the 
> message format without causing incompatibility issues.
> So, we are assuming that values will be under 255.
> 
> Still, the compiler is storing enum as int, this isn't matter what the 
> size of the other members of the union.
> If it will be read into u8 - on BE systems the MSB will be read and so 
> it will always pass a zero.

It sounds to me like the type system is being bypassed somewhere. If
the compiler knows we are assigning an emum to a u8, it should perform
a cast and i would expect it to get it correct, independent of big or
little endian. When that u8 is assigned back to an enum, the compiler
should do another cast, and everything works out.

I assume there are no compiler warnings? The enum -> u8 is an
assignment to a smaller type, which is something you sometimes see
compilers warn about. So it might be there is an explicit cast
somewhere?

But you are saying this is not actually happening, the wrong end is
being discarded. Should we not actually be trying to find where the
type system is broken?

Maybe we as a community already do know, and i'm just ignorant. But
maybe there is nothing we can do about it, this being a KAPI? But then
the commit message should actually explain this, to avoid questions
like mine, and to spread knowledge in the community.

	Andrew
