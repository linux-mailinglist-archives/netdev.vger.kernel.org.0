Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827623B69D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390639AbfFJN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:59:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390636AbfFJN7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 09:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PHdatKCG4Xr2cHIDtZVIWTIYI9ACQ+8MeVzL71lMfc0=; b=XGkYL7NTvT5y7jv3j2bBJZvRcE
        Lr2K01yvQNQHQjJdfzjBNyYQxM6NGE0mkUffLuxbHGIv2x0nSaUtWnsQDdpK+krzNTkKgSb62Tvw4
        bzad2FBGOODJIj9PpNscrhy9n5rCgI6CSVVj8Gk/uqukPXZWanzMa2j2dynP1akLB8W8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haKpO-00079J-Hq; Mon, 10 Jun 2019 15:59:14 +0200
Date:   Mon, 10 Jun 2019 15:59:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190610135914.GH8247@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610084045.6029-2-idosch@idosch.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +speeds_get()
> +{
> +	local dev=$1; shift
> +	local with_mode=$1; shift
> +
> +	local speeds_str=$(ethtool "$dev" | \
> +		# Snip everything before the link modes section.
> +		sed -n '/Supported link modes:/,$p' | \
> +		# Quit processing the rest at the start of the next section.
> +		# When checking, skip the header of this section (hence the 2,).
> +		sed -n '2,${/^[\t][^ \t]/q};p' | \
> +		# Drop the section header of the current section.
> +		cut -d':' -f2)

ethtool gives you two lists of link modes:

$ sudo ethtool eth17
Settings for eth17:
         Supported ports: [ TP ]
         Supported link modes:   10baseT/Half 10baseT/Full 
                                 100baseT/Half 100baseT/Full 
                                 1000baseT/Full 
         Supported pause frame use: No
         Supports auto-negotiation: Yes
         Supported FEC modes: Not reported
         Advertised link modes:  10baseT/Half 10baseT/Full 
                                 100baseT/Half 100baseT/Full 
                                 1000baseT/Full

and if auto-neg has completed, there is potentially a third list, what
the peer is advertising.

Since this test is all about auto-neg, you should be using Advertised
link modes, not Supported link modes. There can be supported link
modes which you cannot advertise.

   Andrew
