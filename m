Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AEE5F4739
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJDQNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJDQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:13:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AC02C124;
        Tue,  4 Oct 2022 09:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6Nc03kCD580eoe7aqLtPYGYFRbTdfQEDrzlYxPtOCP8=; b=QTab0oCLBQCQu3bfPCz6/3RDvi
        HYnHz6RGyGOTRtwHtBTB6PaGjnCpZRV2QgUzchqqWGwb2q57yXI7jx6H8mH39pMX6E8PgTM6QBRHN
        SlUSj+3oTjYxvTBMhF6tgjevZeCYB4Z91SzhflffKtJZKhLLEX1DIK0ahHb7wW7f7tEJ4KuPW+MRl
        1A2iJ7xYh4lcHsk6BSc8zpSODpwC5UN1nXGHg/3OP7ubGDP4xBaImozA5rjJM2KXsB3oISgtXqfLL
        gpaCucWHwlzAtN6SPsB8MO/D4RwDlcjmL6/A0wqgr7tEASOYVaK2nb6NwcQfCDTqtLh2BkLgMgLjF
        XxsXU2/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34582)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ofkXt-0008Fg-VQ; Tue, 04 Oct 2022 17:13:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ofkXq-0004Vq-IH; Tue, 04 Oct 2022 17:13:22 +0100
Date:   Tue, 4 Oct 2022 17:13:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v6 6/9] net: dpaa: Convert to phylink
Message-ID: <YzxbogPClCjNgN+m@shell.armlinux.org.uk>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <20220930200933.4111249-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930200933.4111249-7-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:09:30PM -0400, Sean Anderson wrote:
> @@ -1064,43 +1061,50 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
>  	return pcs;
>  }
>  
> +static bool memac_supports(struct mac_device *mac_dev, phy_interface_t iface)
> +{
> +	/* If there's no serdes device, assume that it's been configured for
> +	 * whatever the default interface mode is.
> +	 */
> +	if (!mac_dev->fman_mac->serdes)
> +		return mac_dev->phy_if == iface;
> +	/* Otherwise, ask the serdes */
> +	return !phy_validate(mac_dev->fman_mac->serdes, PHY_MODE_ETHERNET,
> +			     iface, NULL);
> +}
> +
>  int memac_initialization(struct mac_device *mac_dev,
>  			 struct device_node *mac_node,
>  			 struct fman_mac_params *params)
>  {
>  	int			 err;
> +	struct device_node      *fixed;
>  	struct phylink_pcs	*pcs;
> -	struct fixed_phy_status *fixed_link;
>  	struct fman_mac		*memac;
> +	unsigned long		 capabilities;
> +	unsigned long		*supported;
>  
> +	mac_dev->phylink_ops		= &memac_mac_ops;
>  	mac_dev->set_promisc		= memac_set_promiscuous;
>  	mac_dev->change_addr		= memac_modify_mac_address;
>  	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
>  	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
> -	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
> -	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
>  	mac_dev->set_exception		= memac_set_exception;
>  	mac_dev->set_allmulti		= memac_set_allmulti;
>  	mac_dev->set_tstamp		= memac_set_tstamp;
>  	mac_dev->set_multi		= fman_set_multi;
> -	mac_dev->adjust_link            = adjust_link_memac;
>  	mac_dev->enable			= memac_enable;
>  	mac_dev->disable		= memac_disable;
>  
> -	if (params->max_speed == SPEED_10000)
> -		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
> -
>  	mac_dev->fman_mac = memac_config(mac_dev, params);
> -	if (!mac_dev->fman_mac) {
> -		err = -EINVAL;
> -		goto _return;
> -	}
> +	if (!mac_dev->fman_mac)
> +		return -EINVAL;
>  
>  	memac = mac_dev->fman_mac;
>  	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
>  	memac->memac_drv_param->reset_on_init = true;
>  
> -	err = of_property_match_string(mac_node, "pcs-names", "xfi");
> +	err = of_property_match_string(mac_node, "pcs-handle-names", "xfi");

While reading through the patch, I stumbled upon this - in the previous
patch, you introduce this code with "pcs-names" and then in this patch
you change the name of the property. I don't think this was mentioned in
the commit message (searching it for "pcs" didn't reveal anything) so
I'm wondering whether this name update should've been merged into the
previous patch instead of this one?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
