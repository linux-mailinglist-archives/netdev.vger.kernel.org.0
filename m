Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C8C2C5E00
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 23:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgKZW6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 17:58:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387854AbgKZW6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 17:58:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiQD3-0092rW-5o; Thu, 26 Nov 2020 23:57:53 +0100
Date:   Thu, 26 Nov 2020 23:57:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201126225753.GP2075216@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
 <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
 <20201120133050.GF1804098@lunn.ch>
 <87v9dr925a.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9dr925a.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you go with the static array, you theoretically can not get the
> equivalent of an ENOMEM. Practically though you have to iterate through
> the array and look for a free entry, but you still have to put a return
> statement at the bottom of that function, right? Or panic I suppose. My
> guess is you end up with:
> 
>     struct dsa_lag *dsa_lag_get(dst)
>     {
>         for (lag in dst->lag_array) {
>             if (lag->dev == NULL)
>                 return lag;
>         }
> 
>         return NULL;
>     }

I would put a WARN() in here, and return the NULL pointer. That will
then likely opps soon afterwards and kill of the user space tool
configuring the LAG, maybe leaving rtnl locked, and so all network
configuration dies. But that is all fine, since you cannot have more
LAGs than ports. This can never happen. If it does happen, something
is badly wrong and we want to know about it. And so a very obvious
explosion is good.

> So now we have just traded dealing with an ENOMEM for a NULL pointer;
> pretty much the same thing.

ENOMEM you have to handle correctly, unwind everything and leaving the
stack in the same state as before. Being out of memory is not a reason
to explode. Have you tested this? It is the sort of thing which does
not happen very often, so i expect is broken.

   Andrew
