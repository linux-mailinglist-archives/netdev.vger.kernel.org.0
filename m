Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BD91E11DC
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404122AbgEYPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:36:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403996AbgEYPgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nznL7t5RcKnQc14myjY4CZ1m22+A09eYxFEmxrWGKu4=; b=EozbGen20Gp0WM7zypoI1JpvwM
        pW04+KCo9xvQR7avNNffqoUNlbLfdkwXtTALgIK+ZzEb2TBrF/SiKdmKTAXwWl6QkDSAviRO1rBD6
        D2MdPO+oefgmBk3Tmopz3Iroxi0DjHslZhoQ2v1GiFr8T06m581T/TEczycQOS4/RPIY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdF9S-003CRy-AC; Mon, 25 May 2020 17:36:30 +0200
Date:   Mon, 25 May 2020 17:36:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] dpaa_eth: fix usage as DSA master, try 3
Message-ID: <20200525153630.GC762220@lunn.ch>
References: <20200524212251.3311546-1-olteanv@gmail.com>
 <AM6PR04MB39762C1D25DF9A1788C39DC5ECB30@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB39762C1D25DF9A1788C39DC5ECB30@AM6PR04MB3976.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 03:20:09PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Monday, May 25, 2020 12:23 AM
> > To: davem@davemloft.net
> > Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> > Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; netdev@vger.kernel.org
> > Subject: [PATCH] dpaa_eth: fix usage as DSA master, try 3
> > 
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > The dpaa-eth driver probes on compatible string for the MAC node, and
> > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > triggers the probing of the dpaa-eth net device driver.
> > 
> > All of this is fine, but the problem is that the struct device of the
> > dpaa_eth net_device is 2 parents away from the MAC which can be
> > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > DSA switches won't be able to probe on top of FMan ports.
> > 
> > It would be a bit silly to modify a core function
> > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > just for one driver. We're just 1 step away from implementing full
> > recursion.
> 
> Changing a netdevice parent to satisfy this DSA assumption can be regarded as
> being just as silly. How about changing the DSA assumption, not the generic
> of_find_net_device_by_node API?
> 
> ACPI support is in the making for these platforms, is DSA going to work
> with that?

Hi Madalin

If you listen to what the ACPI people say, ACPI is never going to work
with DSA. ACPI is too primitive, you need to use an advanced
configuration system like DT.

      Andrew
