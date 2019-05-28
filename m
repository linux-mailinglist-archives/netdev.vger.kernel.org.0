Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F312C498
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfE1Kjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:39:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:3818 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfE1Kjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:39:41 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 03:39:40 -0700
X-ExtLoop1: 1
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 28 May 2019 03:39:36 -0700
Received: by lahna (sSMTP sendmail emulation); Tue, 28 May 2019 13:39:36 +0300
Date:   Tue, 28 May 2019 13:39:36 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     wsa@the-dreams.de, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [net-next,v3 1/2] i2c: acpi: export
 i2c_acpi_find_adapter_by_handle
Message-ID: <20190528103936.GD2781@lahna.fi.intel.com>
References: <20190528032213.19839-1-ruslan@babayev.com>
 <20190528032213.19839-2-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528032213.19839-2-ruslan@babayev.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:22:12PM -0700, Ruslan Babayev wrote:
> This allows drivers to lookup i2c adapters on ACPI based systems similar to
> of_get_i2c_adapter_by_node() with DT based systems.
> 
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
> Cc: xe-linux-external@cisco.com
> ---
>  drivers/i2c/i2c-core-acpi.c | 3 ++-
>  include/linux/i2c.h         | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
> index 272800692088..964687534754 100644
> --- a/drivers/i2c/i2c-core-acpi.c
> +++ b/drivers/i2c/i2c-core-acpi.c
> @@ -337,7 +337,7 @@ static int i2c_acpi_find_match_device(struct device *dev, void *data)
>  	return ACPI_COMPANION(dev) == data;
>  }
>  
> -static struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
> +struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
>  {
>  	struct device *dev;
>  
> @@ -345,6 +345,7 @@ static struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
>  			      i2c_acpi_find_match_adapter);
>  	return dev ? i2c_verify_adapter(dev) : NULL;
>  }
> +EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
>  
>  static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
>  {
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 1308126fc384..9808993f5fd5 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -21,6 +21,7 @@
>  #include <linux/rtmutex.h>
>  #include <linux/irqdomain.h>		/* for Host Notify IRQ */
>  #include <linux/of.h>		/* for struct device_node */
> +#include <linux/acpi.h>		/* for acpi_handle */
>  #include <linux/swab.h>		/* for swab16 */
>  #include <uapi/linux/i2c.h>
>  
> @@ -981,6 +982,7 @@ bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
>  u32 i2c_acpi_find_bus_speed(struct device *dev);
>  struct i2c_client *i2c_acpi_new_device(struct device *dev, int index,
>  				       struct i2c_board_info *info);
> +struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle);
>  #else
>  static inline bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
>  					     struct acpi_resource_i2c_serialbus **i2c)
> @@ -996,6 +998,10 @@ static inline struct i2c_client *i2c_acpi_new_device(struct device *dev,
>  {
>  	return NULL;
>  }
> +static inline struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle h)

You should use the same argument naming as with the non-stubbed one:

static inline struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)

Anyway looks good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
