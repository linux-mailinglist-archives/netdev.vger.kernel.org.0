Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139F7BA2BD
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 14:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfIVM4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 08:56:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36860 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfIVM4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 08:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kXNd4Otf1WXHwIbrWf/Ed5THU+eNYMXWXGBOvSSFAIA=; b=bKBEgWaVVL6JvTnHYJtfS65X2
        70ZjyqL3sLH8PRn9lslR086dYLyfOI2J6Hz1nuNesaQxJoAr4ZQxyEWsc65DdrpqrpvzfnUvx6k3n
        G1yI+QRGxHJXUxwFkmsgJrS3+MTtX0usIwyCxaMC6moaqBx4M5bcwYxQcC/R/fzezjH/BD+pP2irH
        hb6WVywh3S7hV5RZrz4eYE5bvsNGoqbJ+Hj7t3ztdsROvCBaJbQGFF27RLhpooSoxYXLSx5P9Jh7B
        6J21cnlTf1YdHBIs24a3u/ZywgWjG0mWZQZ2cBQhWnf8Qv9LH3qjRB2XaWC+l1V9NRqEdbrWpyW3e
        5olFokSdQ==;
Received: from shell.armlinux.org.uk ([192.168.0.251]:55382)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iC1Pj-00073T-6s
        for netdev@vger.kernel.org; Sun, 22 Sep 2019 13:56:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iC1Pc-0007kK-M5; Sun, 22 Sep 2019 13:56:24 +0100
Date:   Sun, 22 Sep 2019 13:56:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed downgrade
Message-ID: <20190922125624.GQ25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 11:59:32AM +0100, Russell King - ARM Linux admin wrote:
> Commentary: what is not yet known is whether the AR8035 restores the
>             advertisement register when the link goes down to the
> 	    previous state.

I've just found my 2-pair cable, and it appears that the AR8035 does
indeed restore the advertisement register.

Using the 2-pair cable (which takes a while for the link to come up
at 100mbit) results in register 9 becoming zero:

   1140 796d 004d d072 15e1 c1e1 000d 2001
   0000 0000 0800 0000 0000 4007 b29a a000
   0862 7c30 0000 dc20 082c 0000 04e8 0000
   3200 3000 0000 060d 0000 0005 2d47 8100.

Disconnecting the 2-pair, and connecting a 4-pair cable results in a
gigabit link with the advertisement restored:

   1140 796d 004d d072 15e1 c1e1 000d 2001
   0000 0200 2800 0000 0000 4007 b29a a000
   0862 bc50 0000 dc00 082c 0000 04e8 0000
   3200 3000 0000 060e 0000 0005 2d47 8100.

Note that register 0x11 bit 5 reports when downshift is active.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
