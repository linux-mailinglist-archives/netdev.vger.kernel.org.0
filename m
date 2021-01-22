Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4625D300894
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbhAVQYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:24:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:40752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbhAVQYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 11:24:13 -0500
IronPort-SDR: OqFOsM55xEFkAnDjVFuulwUhNk8aSw33ialNwX/GtkjcExfdunTE1bmfp5iFI65wu/7XXO8Vz5
 VlWNWIYzFNsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158647360"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="158647360"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 08:23:32 -0800
IronPort-SDR: zH6cmzMCzs2f3MLaQCT+ofDfO04zG8dDAVZwC3WO5cL9ERgr1FmFxFEg2RiK8Guzp2ejipaZNP
 jJv9ZIW3dCKQ==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="400719709"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 08:23:27 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1l2zEa-0097Gd-FZ; Fri, 22 Jan 2021 18:24:28 +0200
Date:   Fri, 22 Jan 2021 18:24:28 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce
 fwnode_get_id()
Message-ID: <YAr8PFRcR8gNZz95@smile.fi.intel.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 09:12:54PM +0530, Calvin Johnson wrote:
> Using fwnode_get_id(), get the reg property value for DT node
> or get the _ADR object value for ACPI node.

...

> +/**
> + * fwnode_get_id - Get the id of a fwnode.
> + * @fwnode: firmware node
> + * @id: id of the fwnode
> + *
> + * This function provides the id of a fwnode which can be either
> + * DT or ACPI node. For ACPI, "reg" property value, if present will
> + * be provided or else _ADR value will be provided.
> + * Returns 0 on success or a negative errno.
> + */
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> +{

> +#ifdef CONFIG_ACPI
> +	unsigned long long adr;
> +	acpi_status status;
> +#endif

Instead you may do...

> +	int ret;
> +
> +	ret = fwnode_property_read_u32(fwnode, "reg", id);
> +	if (ret) {
> +#ifdef CONFIG_ACPI

...it here like

		unsigned long long adr;
		acpi_status status;

> +		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +					       METHOD_NAME__ADR, NULL, &adr);
> +		if (ACPI_FAILURE(status))
> +			return -EINVAL;
> +		*id = (u32)adr;
> +#else
> +		return ret;
> +#endif
> +	}
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


