Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD854EBB47
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 08:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbiC3HAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243545AbiC3G77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 02:59:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364D3DEBA8;
        Tue, 29 Mar 2022 23:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648623486; x=1680159486;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SIp0h30VMDvBIVSGXrWFtTthjxzLWvye/g+v5SbbOFY=;
  b=H6NuMmduSjL5ovNPAVlnUgNpw/MRoYZqG6ws9IyE4YBDUPjZo1mwfxQP
   qh6JYRND4CdevJqN7YEeqne+d9FnuWUPci3dDJMTwebS0233VlCvPlTEk
   xeUbDFPwrw+BwMG3PYAufwYmUCtUqq142iuRkc5GpKKGvm5bfXnIyVTcZ
   Bue3YYctIqhIS1uFa2jyrxaO3FyOxyZlcm2C9CF9b0QBZpVOR8n+E3Vyh
   6SZMznUA3w3qF2efiv7PoUSDgStf80w5GO1RDo4eTT12EtcCrU7jNa/MI
   geC39aTEdN7mdgeRcJFd5FaH61Wgt7BnextYFnu5OnsANjV//KtDoZXPM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="322644251"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="322644251"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 23:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="546730778"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.135])
  by orsmga007.jf.intel.com with ESMTP; 29 Mar 2022 23:58:00 -0700
Date:   Wed, 30 Mar 2022 14:50:47 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Message-ID: <20220330065047.GA212503@yilunxu-OptiPlex-7050>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329160730.3265481-2-michael@walle.cc>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 06:07:26PM +0200, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
>  drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
>  include/linux/hwmon.h                    |  3 ++
>  3 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> index c41eb6108103..12f4a9bcef04 100644
> --- a/Documentation/hwmon/hwmon-kernel-api.rst
> +++ b/Documentation/hwmon/hwmon-kernel-api.rst
> @@ -50,6 +50,10 @@ register/unregister functions::
>  
>    void devm_hwmon_device_unregister(struct device *dev);
>  
> +  char *hwmon_sanitize_name(const char *name);
> +
> +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> +
>  hwmon_device_register_with_groups registers a hardware monitoring device.
>  The first parameter of this function is a pointer to the parent device.
>  The name parameter is a pointer to the hwmon device name. The registration
> @@ -93,7 +97,10 @@ removal would be too late.
>  
>  All supported hwmon device registration functions only accept valid device
>  names. Device names including invalid characters (whitespace, '*', or '-')
> -will be rejected. The 'name' parameter is mandatory.
> +will be rejected. The 'name' parameter is mandatory. Before calling a
> +register function you should either use hwmon_sanitize_name or
> +devm_hwmon_sanitize_name to replace any invalid characters with an

I suggest                   to duplicate the name and replace ...

Thanks,
Yilun

> +underscore.
>  
>  Using devm_hwmon_device_register_with_info()
>  --------------------------------------------
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index 989e2c8496dd..619ef9f9a16e 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -1057,6 +1057,55 @@ void devm_hwmon_device_unregister(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
>  
> +static char *__hwmon_sanitize_name(struct device *dev, const char *old_name)
> +{
> +	char *name, *p;
> +
> +	if (dev)
> +		name = devm_kstrdup(dev, old_name, GFP_KERNEL);
> +	else
> +		name = kstrdup(old_name, GFP_KERNEL);
> +	if (!name)
> +		return NULL;
> +
> +	for (p = name; *p; p++)
> +		if (hwmon_is_bad_char(*p))
> +			*p = '_';
> +
> +	return name;
> +}
> +
> +/**
> + * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
> + * @name: NUL-terminated name
> + *
> + * Allocates a new string where any invalid characters will be replaced
> + * by an underscore.
> + *
> + * Returns newly allocated name or %NULL in case of error.
> + */
> +char *hwmon_sanitize_name(const char *name)
> +{
> +	return __hwmon_sanitize_name(NULL, name);
> +}
> +EXPORT_SYMBOL_GPL(hwmon_sanitize_name);
> +
> +/**
> + * devm_hwmon_sanitize_name - resource managed hwmon_sanitize_name()
> + * @dev: device to allocate memory for
> + * @name: NUL-terminated name
> + *
> + * Allocates a new string where any invalid characters will be replaced
> + * by an underscore.
> + *
> + * Returns newly allocated name or %NULL in case of error.
> + */
> +char *devm_hwmon_sanitize_name(struct device *dev, const char *name)
> +{
> +	return __hwmon_sanitize_name(dev, name);
> +}
> +EXPORT_SYMBOL_GPL(devm_hwmon_sanitize_name);
> +
>  static void __init hwmon_pci_quirks(void)
>  {
>  #if defined CONFIG_X86 && defined CONFIG_PCI
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index eba380b76d15..4efaf06fd2b8 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -461,6 +461,9 @@ void devm_hwmon_device_unregister(struct device *dev);
>  int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
>  		       u32 attr, int channel);
>  
> +char *hwmon_sanitize_name(const char *name);
> +char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> +
>  /**
>   * hwmon_is_bad_char - Is the char invalid in a hwmon name
>   * @ch: the char to be considered
> -- 
> 2.30.2
