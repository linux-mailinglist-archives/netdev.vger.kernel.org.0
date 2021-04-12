Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83A35CA79
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbhDLPxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240489AbhDLPxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49006124C;
        Mon, 12 Apr 2021 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618242763;
        bh=APl4ltoCaeAX320Wz7C3DT47Uhr03SEhnnO+/Oi4vsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hVbeTbsK+UPbYADeqoXS+4cks4edwWgjyPeTb08ATlCqepQSYtGWQRK81CnMkH3u4
         01wTagc5WXzgVCmp+tUkYJjxJNSi6ZNDfuqQiFnCHHWq9XVwSOTA0On5DWYECxylrL
         f9WWEJr9TZ299jN8Wy0h5IIlio/FmSVFhGYT1HKJLzyEsYal7Q9xzPf88w+toDj7RE
         xrQrFZhkc+V0fcb66XSJkDm9IOgAkN3rR681o+zAr8oUW8I4/oJWT1AtHmFUyB34YH
         9dLqx7LNqGkFbkiI8eiRcob8Ky0LPuNaYUXU37/VYxPg73c0Vai2rRKtR3Dor/CdJ2
         /ok/JMy/HTgMg==
Received: by pali.im (Postfix)
        id 28B38687; Mon, 12 Apr 2021 17:52:40 +0200 (CEST)
Date:   Mon, 12 Apr 2021 17:52:39 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <20210412155239.chgrne7uzvlrac2e@pali>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRcu+dNKE7xC8EG@lunn.ch>
 <20210412150152.pbz5zt7mu3aefbrx@pali>
 <YHRoEfGi3/l3K6iF@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHRoEfGi3/l3K6iF@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 April 2021 17:32:33 Andrew Lunn wrote:
> > Anyway, now I'm looking at phy/marvell.c driver again and it supports
> > only 88E6341 and 88E6390 families from whole 88E63xxx range.
> > 
> > So do we need to define for now table for more than
> > MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries?
> 
> Probably not. I've no idea if the 6393 has an ID, so to be safe you
> should add that. Assuming it has a family of its own.

So what about just?

	if (reg == MII_PHYSID2 && !(val & 0x3f0)) {
		if (chip->info->family == MV88E6XXX_FAMILY_6341)
			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6341 >> 4;
		else if (chip->info->family == MV88E6XXX_FAMILY_6390)
			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
	}
