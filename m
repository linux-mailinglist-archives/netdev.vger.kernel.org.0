Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B712E4CB206
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiCBWNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiCBWNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:13:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA1B6D27
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 14:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9ctLhnTTg7LPNflQrOIe1tZRQtjg9/38RUCtD+MPuC4=; b=AYKXeJEtbc+t/nmzxhp5UttMo8
        gopIHV+J5dyFHCQPoGsB5p063txkofE6ksNE8HZq7Z/v4/IfMhJNLZKX4ms1KdZO3EJetNIzfpg/L
        VkYlqXU8IFjxynbQ0rSO1ps9Kawph+WF7OpenU/Jv6LBFAdsSw4tP57V/PHaHQ2fO9FU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPXDK-008z4K-6m; Wed, 02 Mar 2022 23:12:54 +0100
Date:   Wed, 2 Mar 2022 23:12:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Subject: Re: smsc95xx warning after a 'reboot' command
Message-ID: <Yh/r5hkui6MrV4W6@lunn.ch>
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 06:57:06PM -0300, Fabio Estevam wrote:
> Hi,
> 
> On a imx8mm iotgateway board from Compulab running 5.10 or 5.17-rc the
> following warning is observed after a 'reboot' command:

Just to make sure i'm interpreting this correctly, you are doing a
reboot with the first 20 seconds of the machine starting?

> [   23.077179] ci_hdrc ci_hdrc.1: remove, state 1
> [   23.081674] usb usb2: USB disconnect, device number 1
> [   23.086740] usb 2-1: USB disconnect, device number 2
> [   23.088393] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   23.091718] usb 2-1.1: USB disconnect, device number 3
> [   23.094090] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
> usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
> [   23.098869] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> [   23.098877] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy

So it looks like the PHY state machine has not been told to stop using
the PHY. That suggests smsc95xx_disconnect_phy() has not been
called. Could you confirm this by putting a printk() in there.

	Andrew
