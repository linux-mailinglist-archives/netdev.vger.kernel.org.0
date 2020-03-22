Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672A418EC6E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 22:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCVVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 17:10:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgCVVKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 17:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ptdzuTNWiWg0jVMZ4VrC6zBgD5Vp7gRPxVGGykUOgno=; b=p2avgSfSRLAx0Qc22GEhPx4ZLs
        WP+71pOHSFxOrynsrtUdNZC2yEHrp+au/RLxGvP1U1n28C+s3Qj4DuARauhQ2T91xUCMHLp7JjvFu
        6w9TKjT0rQsWeOc27TY0O3xH2CKGOVhdHJccxZID+w3fSVyaw9AtaibmMdda6BIoXzZU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG7r4-0002iX-Ls; Sun, 22 Mar 2020 22:09:58 +0100
Date:   Sun, 22 Mar 2020 22:09:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?B=F6hler?= <news@aboehler.at>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] MDIO firmware upload for offloading CPU
Message-ID: <20200322210958.GF3819@lunn.ch>
References: <27780925-4a60-f922-e1ed-e8e43a9cc8a2@aboehler.at>
 <20200322144306.GI11481@lunn.ch>
 <96bfdd47-80ce-b7fd-75f7-d2ad0705f8bb@aboehler.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96bfdd47-80ce-b7fd-75f7-d2ad0705f8bb@aboehler.at>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Andreas
> > 
> > You say there is no PHY. So is the MDIO bus used for anything other
> > than firmware upload?
> 
> Yes - there are four other PHYs on the bus, everything is attached to
> the Lantiq Gigabit switch. I wasn't clear enough in this regard.

O.K. That makes it more difficult. Does probing just these four PHYs
upset the firmware upload? You need to probe them in order to use
them.

> > This two stage firmware upload is messy. If it had been just MDIO i
> > would of said do it from the kernel, as part of the Atheros SoC WiFi
> > driver. MDIO is a nice simple interface. Sending Ethernet frames is a
> > bit harder. Still, if you can do it all in the wifi driver, i
> > would. You can use phandle's to get references to the MDIO bus and the
> > Ehernet interface. There are examples of this in net/dsa/dsa2.c.
> 
> A bit more info on the two-stage firmware upload: The Atheros SoC is a
> complete AR9342 or QCA9558 SoC with 64MB or 128MB RAM. The stage 1
> firmware only initializes the Ethernet connection and waits for the
> stage 2 firmware. The latter consists in the vendor implementation of a
> Linux kernel and minimal user space, the wireless cards are then somehow
> "exported" over Ethernet to the Lantiq SoC. On the Lantiq, they look
> like local Atheros interfaces  - it looks a lot like ath9k-htc with a
> different transport

So the traditional model would be, the driver on the Lantiq for the
interfaces would be responsible for downloading the firmware to the
Atheros. Is there a driver for the ath9k-htc transport? That transport
is probably specific to the Atheros chip. So you can do the firmware
download from there.

Do you only use one address on the MDIO bus for firmware download?
Another option would be to have an mdio 'device' with a driver. When
the MDIO bus is enumerated by of_mdiobus_register(), it would find
this 'device' in DT, and load the driver for it. That driver could
then download the firmware over MDIO, and then later Ethernet. All the
infrastructure is in place for this. It is used by Ethernet switches
on MDIO busses.

	 Andrew
