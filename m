Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6FE2DB217
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgLORBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgLORBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:01:20 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA11C0617B0;
        Tue, 15 Dec 2020 09:00:38 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C3062593;
        Tue, 15 Dec 2020 18:00:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1608051634;
        bh=TnWF5kCi0eF700zzTEiikZPbUPvjXEDFeGtQD8p6IkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OMSTgwM/XbekXmteZnkB9KD/8B7dnlyMuXKwrNL+xLTQLLaAk3HrAV1NQuvr8W3yB
         Jo5tVEVP/SuyeAJLcvhMPpbfsuEtWtAatOk+o73d9ZFEyE5iEzqL9tYtLONci9Jzrr
         eW2cmnQHN0tJ3SG1XbEQXProGOmNulSWzvxyQnFM=
Date:   Tue, 15 Dec 2020 19:00:28 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, linux.cj@gmail.com,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [net-next PATCH v2 10/14] device property: Introduce
 fwnode_get_id()
Message-ID: <X9jrrMJIj2EQBykI@pendragon.ideasonboard.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Calvin,

Thank you for the patch.

On Tue, Dec 15, 2020 at 10:13:11PM +0530, Calvin Johnson wrote:
> Using fwnode_get_id(), get the reg property value for DT node
> and get the _ADR object value for ACPI node.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v2: None
> 
>  drivers/base/property.c  | 26 ++++++++++++++++++++++++++
>  include/linux/property.h |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 4c43d30145c6..1c50e17ae879 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -580,6 +580,32 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
>  	return fwnode_call_ptr_op(fwnode, get_name_prefix);
>  }
>  
> +/**
> + * fwnode_get_id - Get the id of a fwnode.
> + * @fwnode: firmware node
> + * @id: id of the fwnode
> + *

Is the concept of fwnode ID documented clearly somewhere ? I think this
function should otherwise have more documentation, at least to explain
what the ID is.

> + * Returns 0 on success or a negative errno.
> + */
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> +{
> +	unsigned long long adr;
> +	acpi_status status;
> +
> +	if (is_of_node(fwnode)) {
> +		return of_property_read_u32(to_of_node(fwnode), "reg", id);
> +	} else if (is_acpi_node(fwnode)) {
> +		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +					       METHOD_NAME__ADR, NULL, &adr);
> +		if (ACPI_FAILURE(status))
> +			return -ENODATA;

Would it make sense to standardize error codes ? of_property_read_u32()
can return -EINVAL, -ENODATA or -EOVERFLOW. I don't think the caller of
this function would be very interested to tell those three cases apart.
Maybe we should return -EINVAL in all error cases ? Or maybe different
error codes to mean "the backend doesn't support the concept of IDs",
and "the device doesn't have an ID" ?

> +		*id = (u32)adr;
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(fwnode_get_id);
> +
>  /**
>   * fwnode_get_parent - Return parent firwmare node
>   * @fwnode: Firmware whose parent is retrieved
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 2d4542629d80..92d405cf2b07 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -82,6 +82,7 @@ struct fwnode_handle *fwnode_find_reference(const struct fwnode_handle *fwnode,
>  
>  const char *fwnode_get_name(const struct fwnode_handle *fwnode);
>  const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode);
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id);
>  struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);
>  struct fwnode_handle *fwnode_get_next_parent(
>  	struct fwnode_handle *fwnode);

-- 
Regards,

Laurent Pinchart
