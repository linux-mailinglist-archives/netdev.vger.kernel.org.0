Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF41646C5F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiLHKDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLHKDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:03:40 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BAA4E686;
        Thu,  8 Dec 2022 02:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670493818; x=1702029818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T+eOy8kpGeFvv0C5bjdvd+Hz/oC/JRU1NsuROG9ParA=;
  b=d3KvmhexqMDyXUVhr/Aw30Tx6iBcUpQ7YSLB2icz8T+HHvEntaGFmTQ9
   otE74QWzaked8vGlbdWkg1M1c9RRjAFnUN7e444shopphyEtxWvrmT62A
   KoA3zmgSDB5Sfy9y07ZkGncJnwna2306xkUmjJmHEuwqsebORh36PAZXN
   B3OoyqIsZgNwyeqGQGU7fETwAi/MYlokIDCJk51YcZeyATKfuP8w1E6fg
   faU1/nsyAMpkOn7+FFy/8C3CWAY9IkkQmBI9qTCNPTmGZthR699iop+XP
   mImqV4L77XwkjbfOXzVDYLmajw9VcNq85h/CW0b6Ph8/tchIWuaCl9lbT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="318271232"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="318271232"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 02:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="821282851"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="821282851"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2022 02:03:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 5FC1411D; Thu,  8 Dec 2022 12:04:02 +0200 (EET)
Date:   Thu, 8 Dec 2022 12:04:02 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH RFC 1/2] i2c: add fwnode APIs
Message-ID: <Y5G2kkGC69FVWaiK@black.fi.intel.com>
References: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
 <E1p2sVM-009tqA-Vq@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1p2sVM-009tqA-Vq@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Dec 07, 2022 at 11:22:24AM +0000, Russell King (Oracle) wrote:
> Add fwnode APIs for finding and getting I2C adapters, which will be
> used by the SFP code. These are passed the fwnode corresponding to
> the adapter, and return the I2C adapter. It is the responsibility of
> the caller to find the appropriate fwnode.
> 
> We keep the DT and ACPI interfaces, but where appropriate, recode them
> to use the fwnode interfaces internally.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Looks good, just few minor comments below. :)

> ---
>  drivers/i2c/i2c-core-acpi.c | 13 +------
>  drivers/i2c/i2c-core-base.c | 72 +++++++++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core-of.c   | 51 ++------------------------
>  include/linux/i2c.h         |  9 +++++
>  4 files changed, 85 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
> index 4dd777cc0c89..d6037a328669 100644
> --- a/drivers/i2c/i2c-core-acpi.c
> +++ b/drivers/i2c/i2c-core-acpi.c
> @@ -442,18 +442,7 @@ EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
>  
>  static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
>  {
> -	struct device *dev;
> -	struct i2c_client *client;
> -
> -	dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
> -	if (!dev)
> -		return NULL;
> -
> -	client = i2c_verify_client(dev);
> -	if (!client)
> -		put_device(dev);
> -
> -	return client;
> +	return i2c_find_device_by_fwnode(acpi_fwnode_handle(adev));
>  }
>  
>  static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index 9aa7b9d9a485..254ec043ce90 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -1011,6 +1011,27 @@ void i2c_unregister_device(struct i2c_client *client)
>  }
>  EXPORT_SYMBOL_GPL(i2c_unregister_device);
>  
> +/* must call put_device() when done with returned i2c_client device */

I think proper kernel-doc would be better here and all the exported
functions.

> +struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode)
> +{
> +	struct i2c_client *client;
> +	struct device *dev;
> +
> +	if (!fwnode)
> +		return NULL;
> +
> +	dev = bus_find_device_by_fwnode(&i2c_bus_type, fwnode);
> +	if (!dev)
> +		return NULL;
> +
> +	client = i2c_verify_client(dev);
> +	if (!client)
> +		put_device(dev);
> +
> +	return client;
> +}
> +EXPORT_SYMBOL(i2c_find_device_by_fwnode);
> +

Drop this empty line.

>  
>  static const struct i2c_device_id dummy_id[] = {
>  	{ "dummy", 0 },
> @@ -1761,6 +1782,57 @@ int devm_i2c_add_adapter(struct device *dev, struct i2c_adapter *adapter)
>  }
>  EXPORT_SYMBOL_GPL(devm_i2c_add_adapter);
>  
> +static int i2c_dev_or_parent_fwnode_match(struct device *dev, const void *data)
> +{
> +	if (dev_fwnode(dev) == data)
> +		return 1;
> +
> +	if (dev->parent && dev_fwnode(dev->parent) == data)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/* must call put_device() when done with returned i2c_adapter device */
> +struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode)
> +{
> +	struct i2c_adapter *adapter;
> +	struct device *dev;
> +
> +	if (!fwnode)
> +		return NULL;
> +
> +	dev = bus_find_device(&i2c_bus_type, NULL, fwnode,
> +			      i2c_dev_or_parent_fwnode_match);
> +	if (!dev)
> +		return NULL;
> +
> +	adapter = i2c_verify_adapter(dev);
> +	if (!adapter)
> +		put_device(dev);
> +
> +	return adapter;
> +}
> +EXPORT_SYMBOL(i2c_find_adapter_by_fwnode);
> +
> +/* must call i2c_put_adapter() when done with returned i2c_adapter device */
> +struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode)
> +{
> +	struct i2c_adapter *adapter;
> +
> +	adapter = i2c_find_adapter_by_fwnode(fwnode);
> +	if (!adapter)
> +		return NULL;
> +
> +	if (!try_module_get(adapter->owner)) {
> +		put_device(&adapter->dev);
> +		adapter = NULL;
> +	}
> +
> +	return adapter;
> +}
> +EXPORT_SYMBOL(i2c_get_adapter_by_fwnode);
> +
>  static void i2c_parse_timing(struct device *dev, char *prop_name, u32 *cur_val_p,
>  			    u32 def_val, bool use_def)
>  {
> diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
> index 3ed74aa4b44b..c3e565e4bddf 100644
> --- a/drivers/i2c/i2c-core-of.c
> +++ b/drivers/i2c/i2c-core-of.c
> @@ -113,69 +113,24 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  	of_node_put(bus);
>  }
>  
> -static int of_dev_or_parent_node_match(struct device *dev, const void *data)
> -{
> -	if (dev->of_node == data)
> -		return 1;
> -
> -	if (dev->parent)
> -		return dev->parent->of_node == data;
> -
> -	return 0;
> -}
> -
>  /* must call put_device() when done with returned i2c_client device */
>  struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
>  {
> -	struct device *dev;
> -	struct i2c_client *client;
> -
> -	dev = bus_find_device_by_of_node(&i2c_bus_type, node);
> -	if (!dev)
> -		return NULL;
> -
> -	client = i2c_verify_client(dev);
> -	if (!client)
> -		put_device(dev);
> -
> -	return client;
> +	return i2c_find_device_by_fwnode(of_fwnode_handle(node));
>  }
>  EXPORT_SYMBOL(of_find_i2c_device_by_node);
>  
>  /* must call put_device() when done with returned i2c_adapter device */
>  struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
>  {
> -	struct device *dev;
> -	struct i2c_adapter *adapter;
> -
> -	dev = bus_find_device(&i2c_bus_type, NULL, node,
> -			      of_dev_or_parent_node_match);
> -	if (!dev)
> -		return NULL;
> -
> -	adapter = i2c_verify_adapter(dev);
> -	if (!adapter)
> -		put_device(dev);
> -
> -	return adapter;
> +	return i2c_find_adapter_by_fwnode(of_fwnode_handle(node));
>  }
>  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
>  
>  /* must call i2c_put_adapter() when done with returned i2c_adapter device */
>  struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
>  {
> -	struct i2c_adapter *adapter;
> -
> -	adapter = of_find_i2c_adapter_by_node(node);
> -	if (!adapter)
> -		return NULL;
> -
> -	if (!try_module_get(adapter->owner)) {
> -		put_device(&adapter->dev);
> -		adapter = NULL;
> -	}
> -
> -	return adapter;
> +	return i2c_get_adapter_by_fwnode(of_fwnode_handle(node));
>  }
>  EXPORT_SYMBOL(of_get_i2c_adapter_by_node);
>  
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index d84e0e99f084..bcee9faaf2e6 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -965,6 +965,15 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
>  
>  #endif /* I2C */
>  
> +/* must call put_device() when done with returned i2c_client device */
> +struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode);

With the kernel-docs in place you probably can drop these comments.

> +
> +/* must call put_device() when done with returned i2c_adapter device */
> +struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode);
> +
> +/* must call i2c_put_adapter() when done with returned i2c_adapter device */
> +struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode);
> +
>  #if IS_ENABLED(CONFIG_OF)
>  /* must call put_device() when done with returned i2c_client device */
>  struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
> -- 
> 2.30.2
