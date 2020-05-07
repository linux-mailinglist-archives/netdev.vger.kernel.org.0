Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817F11C8BA9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEGNC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:02:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgEGNC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z6KuXtJXawSDTaJcg/aiiJZVD/MQw/2EooMYHaz1n38=; b=NZBesiYZmcT+GQ5aRvDvCuwRji
        QfXQu2V3SjosPKNkKlqCn8dK0a8Ur+VYM1W3x7AvNkKXbEVves+KKczOEdnKRPJ4JEMtyvJSZLR0B
        RyGvIrnev+ogcbU0gC+8OUuMJVc0Xzv19/0BrS9/gA9oywKOD3dMQfoAlgDZBYAcyo+w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jWgAt-001Dto-76; Thu, 07 May 2020 15:02:51 +0200
Date:   Thu, 7 May 2020 15:02:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        olteanv@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net] net: dsa: Add missing reference counting
Message-ID: <20200507130251.GL208718@lunn.ch>
References: <20200505210253.20311-1-f.fainelli@gmail.com>
 <20200505172302.GB1170406@t480s.localdomain>
 <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:24:14PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/5/2020 2:23 PM, Vivien Didelot wrote:
> > On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> If we are probed through platform_data we would be intentionally
> >> dropping the reference count on master after dev_to_net_device()
> >> incremented it. If we are probed through Device Tree,
> >> of_find_net_device() does not do a dev_hold() at all.
> >>
> >> Ensure that the DSA master device is properly reference counted by
> >> holding it as soon as the CPU port is successfully initialized and later
> >> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
> >> a short de-reference, so we hold and release the master at that time,
> >> too.
> >>
> >> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> > 
> Andrew, Vladimir, any thoughts on that?

Hi Florian

Have you looked at how other stacked drivers do this? bond/team, vlan,
bridge, BATMAN?

Do we maybe need to subscribe to the master devices notifier chain,
and do a tear down when the device is removed?

    Andrew
