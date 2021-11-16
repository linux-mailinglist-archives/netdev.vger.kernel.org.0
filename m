Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6E452CA6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhKPI0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:26:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:13253 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhKPI0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 03:26:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="294464954"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="294464954"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 00:23:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="645389141"
Received: from kuha.fi.intel.com ([10.237.72.166])
  by fmsmga001.fm.intel.com with SMTP; 16 Nov 2021 00:23:17 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 16 Nov 2021 10:23:16 +0200
Date:   Tue, 16 Nov 2021 10:23:16 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 15/23] device property: add helper
 function fwnode_get_child_node_count
Message-ID: <YZNqdLAAYVsMAGm2@kuha.fi.intel.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-16-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116062328.1949151-16-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:23:20PM -0800, Colin Foster wrote:
> Functions existed for determining the node count by device, but not by
> fwnode_handle. In the case where a driver could either be defined as a
> standalone device or a node of a different device, parsing from the root of
> the device might not make sense. As such, it becomes necessary to parse
> from a child node instead of the device root node.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/base/property.c  | 20 ++++++++++++++++----
>  include/linux/property.h |  1 +
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index f1f35b48ab8b..2ee675e1529d 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -845,19 +845,31 @@ bool fwnode_device_is_available(const struct fwnode_handle *fwnode)
>  EXPORT_SYMBOL_GPL(fwnode_device_is_available);
>  
>  /**
> - * device_get_child_node_count - return the number of child nodes for device
> - * @dev: Device to cound the child nodes for
> + * fwnode_get_child_node_count - return the number of child nodes for the fwnode
> + * @fwnode: Node to count the childe nodes for
>   */
> -unsigned int device_get_child_node_count(struct device *dev)
> +unsigned int fwnode_get_child_node_count(struct fwnode_handle *fwnode)
>  {
>  	struct fwnode_handle *child;
>  	unsigned int count = 0;
>  
> -	device_for_each_child_node(dev, child)
> +	fwnode_for_each_child_node(fwnode, child)
>  		count++;
>  
>  	return count;
>  }
> +EXPORT_SYMBOL_GPL(fwnode_get_child_node_count);
> +
> +/**
> + * device_get_child_node_count - return the number of child nodes for device
> + * @dev: Device to count the child nodes for
> + */
> +unsigned int device_get_child_node_count(struct device *dev)
> +{
> +	struct fwnode_handle *fwnode = dev_fwnode(dev);
> +
> +	return fwnode_get_child_node_count(fwnode);
> +}
>  EXPORT_SYMBOL_GPL(device_get_child_node_count);
>  
>  bool device_dma_supported(struct device *dev)
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 88fa726a76df..6dc71029cfc5 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -122,6 +122,7 @@ void fwnode_handle_put(struct fwnode_handle *fwnode);
>  
>  int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
>  
> +unsigned int fwnode_get_child_node_count(struct fwnode_handle *fwnode);
>  unsigned int device_get_child_node_count(struct device *dev);

You can now make device_get_child_node_count() an inline function:

static inline unsigned int device_get_child_node_count(struct device *dev)
{
	return fwnode_get_child_node_count(dev_fwnode(dev));
}

thanks,

-- 
heikki
