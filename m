Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04469305DE2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhA0OJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhA0OGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:06:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D634C061756;
        Wed, 27 Jan 2021 06:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=a9lz6Nh/YaZwz1AK+igIvtM70y/LqIIzyscnDNFu86E=; b=P2aBcxa2/pKEPzHDOsczZAM9B
        Tp3MVR1nTTnkphwO3txhWD8pNBVjV3Z9UBIx6kL91QXHyqlmxOauRsANFx8uO8IXQ0+2qMSsjgHtq
        H417Muvp729PnjIutuyEGQ/KoVKjnj4tv18y3b7TpL1pwg8C2oattjKzuis/9k59toCdBMpk5iDGL
        VHIYN0fC3LXaWnAxJqBEA4tM2xtJpnhQ9pyi2RzW4ku4nRH3I893YK/QKku9JAWSgLGaYokIJzg0J
        QwnQKVzE1l7IOjZr83wl8kdiyCk7Hy9Bqy13mVmO7r9zd11/LSvBeoDqEWWXM0lkGOc7NY79JME6z
        A/lzCDA7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53402)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l4lSF-0005Yb-NU; Wed, 27 Jan 2021 14:05:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l4lSD-0004s8-2d; Wed, 27 Jan 2021 14:05:53 +0000
Date:   Wed, 27 Jan 2021 14:05:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC firmware check
Message-ID: <20210127140552.GM1551@shell.armlinux.org.uk>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611747815-1934-20-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 01:43:35PM +0200, stefanc@marvell.com wrote:
>  	if (priv->global_tx_fc && priv->hw_version != MVPP21) {
> -		val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
> -		val |= FLOW_CONTROL_ENABLE_BIT;
> -		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
> +		err = mvpp2_enable_global_fc(priv);
> +		if (err) {
> +			dev_warn(&pdev->dev, "CM3 firmware not running, version should be higher than 18.09\n");
> +			dev_warn(&pdev->dev, "Flow control not supported\n");
> +		}

I've just booted this on my mcbin-ss, and I get:

mvpp2 f2000000.ethernet: CM3 firmware not running, version should be higher than 18.09
mvpp2 f4000000.ethernet: CM3 firmware not running, version should be higher than 18.09

which is rather odd, because I believe I'm running the 18.12 firmware
from git://github.com/MarvellEmbeddedProcessors/binaries-marvell
branch binaries-marvell-armada-18.12.

Any ideas?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
