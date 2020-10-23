Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E872970F4
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750166AbgJWN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750146AbgJWN4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:56:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905E6C0613CE;
        Fri, 23 Oct 2020 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yP+Q48wjyA1OtcAwAs6WtGA6NCAOZIUoYj9ZiEEVx+0=; b=j5UPJ/itw1xdW6ep+I1m7UHQm
        ob4rOr6elyUGAyYU0Me2YV5fMc0ECSL/cVI1BO9W9/nrL5B/9Kvt6/YFGU01JNN4HRxLWmibHYet1
        QtA/C+5//NcXiu/cl3Z1K3TEQEJ3bry6aM3RISxKLhFknrrTuRb1NjqJmTPf+9vNhW8dSOjnZ2JNB
        T9W3IWcpwpbyNqWvjknpu3R485AKnl1THo/i75y5QZmj/sBvFz6boBr7dHNYcBN+iYygiUNc1uMSJ
        3k80MrIkURWZXjosAfVlhY1yJ+5q3i+x7rZGpctuiugcTE06q69gOPR6SqCYe7OgLR00PjkzQTI9Q
        SVsepb4kw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50000)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVxYg-0003Y1-CZ; Fri, 23 Oct 2020 14:56:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVxYc-0008V4-7h; Fri, 23 Oct 2020 14:56:38 +0100
Date:   Fri, 23 Oct 2020 14:56:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [PATCH v3] net: macb: add support for high speed interface
Message-ID: <20201023135638.GE1551@shell.armlinux.org.uk>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
 <20201021185056.GN1551@shell.armlinux.org.uk>
 <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
 <DM5PR07MB3196723723F236F6113DDF9EC11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
 <20201023112549.GB1551@shell.armlinux.org.uk>
 <DM5PR07MB31961A008F4EFA98443E63C6C11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR07MB31961A008F4EFA98443E63C6C11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 01:34:09PM +0000, Parshuram Raju Thombare wrote:
> >Whenever the interface changes, we go through the full reconfiguration
> >procedure that I've already outlined. This involves calling the
> >mac_prepare() method which calls into mvpp2_mac_prepare() and its
> >child mvpp2__mac_prepare().
> 
> Ok, I misunderstood it as interface mode change between successive mac_prepare().
> If major reconfiguration is certain to happen after every interface mode change,
> I will make another small modification in mac_prepare method to set appropriate
> pcs_ops for selected interface mode. 
> pcs_ops for low speed, however, will just be existing non 10GBASE-R functions renamed.
> This will allow us to get rid of old API's for non 10GBASE-R PCS. I hope you are ok with
> these changes done in the same patch.

Yes, that sounds good.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
