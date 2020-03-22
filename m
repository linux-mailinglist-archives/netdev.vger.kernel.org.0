Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368EE18E96A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCVOnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:43:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVOnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 10:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Sl1RYeEqNC6TsLrG85BUFhksaSp7YOj6MPZpXPMg9A=; b=Xsvy/NgeC0EGW9ySu/lT597och
        F5iA+wcna6f8cHyQubKzMzaHmmyqMIctGeQCW+kVNJG4IfLhVHLBXK8BXQyn+YbMvXCvwHzG+gf/6
        rH9X03QGnOz98CUwjemYdVtfXeF9uiIvvIdk2S7F5Ap/aYVvRTmMWqPoJRvufagORkjc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG1og-0000CA-HG; Sun, 22 Mar 2020 15:43:06 +0100
Date:   Sun, 22 Mar 2020 15:43:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?B=F6hler?= <news@aboehler.at>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] MDIO firmware upload for offloading CPU
Message-ID: <20200322144306.GI11481@lunn.ch>
References: <27780925-4a60-f922-e1ed-e8e43a9cc8a2@aboehler.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27780925-4a60-f922-e1ed-e8e43a9cc8a2@aboehler.at>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 02:56:40PM +0100, Andreas Böhler wrote:
> Hi,
> 
> I'm working on support for AVM FRITZ!Box routers, specifically the 3390
> and 3490. Both contain two SoCs: A Lantiq VDSL SoC that handles VDSL and
> Ethernet connections and an Atheros SoC for WiFi. Only the Lantiq has
> access to flash memory, the Atheros SoC requires firmware to be uploaded.
> 
> AVM has implemented a two-stage firmware upload: The stage 1 firmware is
> transferred via MDIO (there is no PHY), the stage 2 firmware is uploaded
> via Ethernet. I've got basic support up and running, but I'm unsure how
> to proceed:
> 
> I implemented a user space utility that uses ioctls to upload the
> firmware via MDIO. However, this only works when the switch
> driver/ethernet driver is patched to allow MDIO writes to a fixed PHY
> (actually, it now allows MDIO writes to an arbitrary address; I patched
> the out-of-tree xrx200 driver for now). It is important to note that no
> PHY probing must be done, as this confuses the target.
> 
> 1. How should firmware uploads via MDIO be performed? Preferably in
> userspace or in kernel space? Please keep in mind that the protocol is
> entirely reverse-engineered.
> 
> 2. If the firmware upload can/should be done in userspace, how do I best
> get access to the MDIO bus?
> 
> 3. What would be a suitable way to implement it?

Hi Andreas

You say there is no PHY. So is the MDIO bus used for anything other
than firmware upload?

You can control scanning of the MDIO bus using mdio->phy_mask. If you
set it to ~0, no scanning will be performed. It will then only probe
for devices you have in device tree. If there are no devices on the
bus, no probing will happen.

This two stage firmware upload is messy. If it had been just MDIO i
would of said do it from the kernel, as part of the Atheros SoC WiFi
driver. MDIO is a nice simple interface. Sending Ethernet frames is a
bit harder. Still, if you can do it all in the wifi driver, i
would. You can use phandle's to get references to the MDIO bus and the
Ehernet interface. There are examples of this in net/dsa/dsa2.c.

	   Andrew
