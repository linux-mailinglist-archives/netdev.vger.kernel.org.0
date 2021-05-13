Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2BF37F3EA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhEMIMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbhEMIMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:12:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54ADC061574;
        Thu, 13 May 2021 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U156ZDGv52XDyRmomu81y1AofnnDZp5kY1yCQ1vGoGg=; b=X0R3x/iAxVmHofiyxhzRf8I2a
        c9jmKXRccdwMjk0Gpk3siFmqoo4ed4tI/eNVAfO+3l7JvCr3xrxV6S3QruWlF8pIz1IZdB/6y1kr5
        p6+gWk5NYP/DH6bFDi2AkQ5vWgFFxhAN2mO3SjuRHD+rEp4AzRWE+usMviVb6AOdI0RDRZ7Z4xn7t
        6qmEW1CTwFq+xLp6ChlIIj7gfE79BOGSiTUimuwVDnd2cY4ylUF3XXldbPbNFWKmT9EAXPmOC2NUL
        fYGpzJHztFpWi+OImr3SJe747G7/tKeG1YNeSsrV3nsS/Q2bofrHBr+UfayN99GeOusfLgBDF5Xx0
        CukVCZqDA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43918)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lh6RY-0005on-8X; Thu, 13 May 2021 09:11:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lh6RX-0002qk-Ic; Thu, 13 May 2021 09:11:39 +0100
Date:   Thu, 13 May 2021 09:11:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] net: mdio: thunder: Fix a double free issue in the
 .remove function
Message-ID: <20210513081139.GT1336@shell.armlinux.org.uk>
References: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:44:49AM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the remove function.

This still leaves the unregister of an allocated-but-unregistered bus,
which you disagreed with - but I hope as I've pointed out the exact
code path in your v1 patch, you'll now realise is a real possibility.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
