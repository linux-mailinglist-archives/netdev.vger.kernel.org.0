Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2BF39752C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhFAOOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:14:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhFAOOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 10:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K0UlamJ2SjuXsA7nv33aecOE1GjMP3YKRT/OKBxt8dI=; b=tq1KyMjSJJZ4r5v9ly0wtAILkK
        OGDy+zNt5E6ocRTF8JuaohL4tiCdyM/iAApM9q/sPe0vfBJW7CqR4P6Z80DIi4gmlzASkU7xpGRQJ
        ltAZ48RmX9Dti92JoENfuCtuZ7JhTruk0CLyuiiBI1CHCXxNo5sYuACzFUujqG0JPmGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo589-007IXg-3Q; Tue, 01 Jun 2021 16:12:29 +0200
Date:   Tue, 1 Jun 2021 16:12:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YLZATclYESd9ROcd@lunn.ch>
References: <20210528193719.6132-1-davthompson@nvidia.com>
 <YLGJLv7y0NLPFR28@lunn.ch>
 <CH2PR12MB3895FA4354E69D830F39CDC8D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YLYz94yo0ge6CDh+@lunn.ch>
 <CH2PR12MB38955E99161C89C165D70B76D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB38955E99161C89C165D70B76D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess I misunderstood. I thought 1G speed always requires
> autonegotiation. And phy_support_sym_pause would display that the
> only pause supported by this MAC is symmetric. But what you are
> saying is that we don't really "negotiate" the pause since our MAC
> HW supports only symmetric pause?

The point of negotiation is that the link peer can say it does not
support pause, because it is missing the needed hardware, or because
of a policy decision. Pause can be bad, particularly if used away from
the leaf nodes of the network. If the negotiation says pause should
not be used, you really should not use it.

Now, you hardware seems to be very limited. You cannot turn pause
off. It is hard coded on. So you cannot negotiate this feature. You
need to report that in ethtool. And you are also going to have to
manually configure pause in the link peer. Since it cannot be
negotiated, the peer is not going to use pause. Meaning by default,
pause in your MAC is pointless. You need to manually configure pause
in the link peer, by telling it to also not to negotiate, and perform
fixed symmetric pause.

Hopefully for the next generation of the hardware, you can fix this
bad design decision.

	Andrew
