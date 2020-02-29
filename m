Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D87317484B
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 18:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgB2RGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 12:06:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbgB2RGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 12:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kvDszULOHU2THHkE1gFvbsX46BUGU952QWYH97S/Pzg=; b=Il+UOTDqA5c1PQLZvj5CipCZ0q
        N2WADRXXFNz3ChvyHB1FfsTEGpQNebtYp4P7JE/7ZOHs8cGLsdkTdddtpk0UIIed747rI8xSzY7Mq
        kAt0hBZ42MGrfdJxceCOKomRxAaSvzRSuNDqSnS4ueBD4y9unuVK6949+zL/Z8wGolpw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j85ZZ-000263-Su; Sat, 29 Feb 2020 18:06:41 +0100
Date:   Sat, 29 Feb 2020 18:06:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix phylink_start()/phylink_stop() calls
Message-ID: <20200229170641.GE6305@lunn.ch>
References: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
 <20200229154215.GD6305@lunn.ch>
 <20200229164538.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229164538.GB25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell

> > The current code in dsa_slave_open() first enables the port, then
> > calls phylink_start(). So maybe we should keep the ordering the same?
> 
> However, dsa_port_setup() does it in the reverse order, so it was a
> bit of guess work which is right.  So, if the port needs to be enabled
> first, then the dsa_port_setup() path for DSA and CPU ports is wrong.
> 
> It's not clear what dsa_port_enable() actually does, and should a port
> be enabled before its interface mode and link parameters have been
> set?

Agreed, it is not clearly defined. port_enable()/port_disable() are
mostly used for power saving. If a port is not used, it can be turned
off.

Having phylink for DSA and CPU ports is a new thing. Slaves have
always had phylib/phylink. So i think it would be safest to follow the
order used for slave interfaces, enable the port first, then start
phylink.

We should probably also change the order for DSA and CPU ports so it
is consistent.

   Andrew
