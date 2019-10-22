Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6098E08B8
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfJVQYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:24:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45694 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731518AbfJVQYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4cO+8acIhM9K17shnyOAB4m6Sd4pA5D/CMuTsbmCYGE=; b=q/E/cTVFTykh+XhRstDzxRszp
        CLBbHNZBSloJO/xPV9J7Y5PGYTpIqwRoQ37yQq6RUTPfFOadaU4xqcXDNfYLbEnZTjv68WVGtNINn
        BkwS0lwf0Z4u7b+ww8WoWQLQy2TGkMtFAjPAt+LorgiCljE97Er9J1SrI1WUPqtJsate5ISqDYd38
        erVz1IYv+xcLWWez699c9FgFNZAKJK+PekTcc9fkJF0eUoGd6Ws897SUTQ58siSMxkjusur/v9KuG
        KidPI2vfjX+leucyA1Hq1Tyu5aP1Orik9q92upcRqErjHlQ1HLHTZkh6PrL2zFd08vi0zUkfIlLIi
        kBr+eTKbQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57712)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMwxW-0008If-Jx; Tue, 22 Oct 2019 17:24:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMwxQ-0004in-Ht; Tue, 22 Oct 2019 17:24:28 +0100
Date:   Tue, 22 Oct 2019 17:24:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, laurentiu.tudor@nxp.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191022162428.GX25745@shell.armlinux.org.uk>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
 <20191022010649.GI16084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022010649.GI16084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 03:06:49AM +0200, Andrew Lunn wrote:
> Hi Ioana
> 
> > +static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
> > +{
> > +	struct fsl_mc_device *dpni_dev, *dpmac_dev;
> > +	struct dpaa2_mac *mac;
> > +	int err;
> > +
> > +	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
> > +	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
> > +	if (!dpmac_dev || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
> > +		return 0;
> > +
> > +	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
> > +		return 0;
> > +
> > +	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
> > +	if (!mac)
> > +		return -ENOMEM;
> > +
> > +	mac->mc_dev = dpmac_dev;
> > +	mac->mc_io = priv->mc_io;
> > +	mac->net_dev = priv->net_dev;
> > +
> > +	err = dpaa2_mac_connect(mac);
> > +	if (err) {
> > +		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
> > +		kfree(mac);
> > +		return err;
> > +	}
> > +	priv->mac = mac;
> > +
> > +	return 0;
> > +}
> > +
> > +static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
> > +{
> > +	if (!priv->mac)
> > +		return;
> > +
> > +	rtnl_lock();
> > +	dpaa2_mac_disconnect(priv->mac);
> > +	kfree(priv->mac);
> > +	priv->mac = NULL;
> > +	rtnl_unlock();
> > +}
> 
> dpaa2_eth_connect_mac() does not take the rtnl lock.
> dpaa2_eth_disconnect_mac() does. This asymmetry makes me think
> something is wrong. But it could be correct....

The way the driver is written, it's fine.

dpaa2_eth_connect_mac() is called prior to the netdev being registered.
At that point, nothing is published.

dpaa2_eth_disconnect_mac() is called _prior_ to the netdev being
unregistered, so there could be live accesses happening to the phy
and phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
