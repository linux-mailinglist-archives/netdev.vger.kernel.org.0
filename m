Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560581B85C9
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 12:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgDYKwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 06:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYKwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 06:52:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDB2C09B04A;
        Sat, 25 Apr 2020 03:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X4jKUJfDFix2b4r4fab42K1rsgsQiqYZcWSH/9sV9EE=; b=yq/B9eqqtIQBoSCwg3tjFF0Hk
        7s3TpXppEJvr1TenMjKrQwNo9/g7zXqT/fnVvpgISyDFuPvJFZhpqj5wHyC9nrdv5xJVCyPUZuiiY
        VNOH9NJnj4DR8Nc6fzUJG8kyKyp74KgsV4EoQn4w45RfLHXMOO73y5PQugE8JzMT5028BjBz9DZKn
        /pravyxyAObFNV6BOiVZurlDM3pWQ9FBxmvCAIjCrWTlH/tiUFQTBodkyL4LddbteCMcLn2mkwH0X
        yqvpUarw2puHNIGl6kAZbrfiDJqzBYBafNSg8ITapGhaf7J058lkoqbmV8daAI6soOOFY6EsJNKRt
        UOYqTiN0Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:51040)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSIPs-00029i-3F; Sat, 25 Apr 2020 11:52:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSIPq-0004YH-T1; Sat, 25 Apr 2020 11:52:10 +0100
Date:   Sat, 25 Apr 2020 11:52:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 7/9] net: phy: enable qoriq backplane support
Message-ID: <20200425105210.GZ25745@shell.armlinux.org.uk>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-8-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-8-git-send-email-florinel.iordache@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:46:29PM +0300, Florinel Iordache wrote:
> Enable backplane support for qoriq family of devices

This uses phylib, which is a problem if you have this PCS device
connecting across a backplane to a standard copper PHY (which will
also be a phylib PHY.)  phylib and the networking layer more widely
does not support this setup.

Hence, this can only work when there is no copper PHY on the other
end.

The model presented by phylink since its inception is to drive the
PCS entirely as a separate non-phylib device.  It seems that when
you encounter a setup with a copper PHY on the other end of the
backplane KR link, you're going to have to rewrite all this code
to bolt into phylink.

I thought one of the reasons for the hour long conference call was to
try and sort this out by coming up with an approach for how to deal
with these PCS devices... but it seems the same problems still exist,
and very few of our comments that any kernel maintainer have made have
been addressed so far.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
