Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEBA194DB4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgC0AGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:06:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgC0AGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IzdaltGXCvzTRkjlg3Bs03jNDEhhNg/vbrF5k/j29mw=; b=Ssw5jjA9AINE/IiXZVZyR8kdXR
        QDx9/M6Wfi2yi4NE7qFz3+P6XV/FmLaZ17aNqsM65qHoDhwb+T71YFgA9tMRWVhl5NuqfMcU8InQH
        Ua56lN4AKjwF8iVHPi0rhncEH3lbfAf/PtyI3rLIuwRP1nJhPEqNkH9vVYmdAqVyLn1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHcW1-0004km-Lp; Fri, 27 Mar 2020 01:06:25 +0100
Date:   Fri, 27 Mar 2020 01:06:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/8] net: dsa: configure the MTU for switch
 ports
Message-ID: <20200327000625.GJ3819@lunn.ch>
References: <20200326224040.32014-1-olteanv@gmail.com>
 <20200326224040.32014-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326224040.32014-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static void dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp)
> -{
> -	unsigned int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
> -	int err;
> -
> -	rtnl_lock();
> -	if (mtu <= dev->max_mtu) {
> -		err = dev_set_mtu(dev, mtu);
> -		if (err)
> -			netdev_dbg(dev, "Unable to set MTU to include for DSA overheads\n");
> -	}
> -	rtnl_unlock();
> -}
> -
>  static void dsa_master_reset_mtu(struct net_device *dev)
>  {
>  	int err;
> @@ -344,7 +330,14 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
>  {
>  	int ret;
>  
> -	dsa_master_set_mtu(dev,  cpu_dp);
> +	rtnl_lock();
> +	ret = dev_set_mtu(dev, ETH_DATA_LEN + cpu_dp->tag_ops->overhead);
> +	rtnl_unlock();
> +	if (ret) {
> +		netdev_err(dev, "error %d setting MTU to include DSA overhead\n",
> +			   ret);
> +		return ret;
> +	}

I suspect this will break devices. dsa_master_set_mtu() was not fatal
if it failed. I did this deliberately because i suspect there are some
MAC drivers which are unhappy to have the MTU changed, but will still
send and receive frames which are bigger than the MTU. 

So please keep setting the MTU of ETH_DATA_LEN +
cpu_dp->tag_ops->overhead or less as non-fatal. Jumbo frame sizes you
should however check the return code.

> @@ -1465,7 +1556,10 @@ int dsa_slave_create(struct dsa_port *port)
>  	slave_dev->priv_flags |= IFF_NO_QUEUE;
>  	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
>  	slave_dev->min_mtu = 0;
> -	slave_dev->max_mtu = ETH_MAX_MTU;
> +	if (ds->ops->port_max_mtu)
> +		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
> +	else
> +		slave_dev->max_mtu = ETH_MAX_MTU;

Does this bring you anything. You have a lot more checks you perform
when performing the actual change. Seems better to keep them all
together.

	Andrew
