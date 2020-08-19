Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE06B2493AF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHSDyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgHSDyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:54:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5421A2078B;
        Wed, 19 Aug 2020 03:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809293;
        bh=IySTLt7rjNFqkj9Oj+bN9bGl5aMTBA+aB2CVpLkxd9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GmJM8UmrYObZSsIrSYW/V7XH1Ya+WL8e1/wwH7Vk2zoXU6nkIFHvNMuV3oq1XVSej
         X4vTiPrCFppyoGhPpVgZSkzqH1UiJ4IBsmgqQk01T9tsijzpGWJOmeSy19ajtx0ULe
         IIyVUNV9mOMIt0Tt7bmKeHq6Kue8QxoxaaG93RC4=
Date:   Tue, 18 Aug 2020 20:54:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v3 3/4] devlink: introduce flash update overwrite
 mask
Message-ID: <20200818205451.35191c0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819002821.2657515-4-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 17:28:17 -0700 Jacob Keller wrote:
> +The ``devlink-flash`` command allows optionally specifying a mask indicating
> +the how the device should handle subsections of flash components when

remove one 'the'?

> +updating. This mask indicates the set of sections which are allowed to be
> +overwritten.

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index ebfc4a698809..74a869fbaa67 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -201,6 +201,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>  		return PTR_ERR(nsim_dev->ports_ddir);
>  	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
>  			    &nsim_dev->fw_update_status);
> +	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
> +			    &nsim_dev->fw_update_overwrite_mask);

Nice to see the test, but netdevsim changes could be separated out :S

>  	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
>  			   &nsim_dev->max_macs);
>  	debugfs_create_bool("test1", 0600, nsim_dev->ddir,

> -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
> +#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
> +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)

Since core will check supported flags, I'd be tempted to have a flag
for each override type. Saves an 'if' in every driver.

>  struct devlink_region;
>  struct devlink_info_req;
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index cfef4245ea5a..1d8bbe9c1ae1 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -228,6 +228,28 @@ enum {
>  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
>  };
>  
> +/* Specify what sections of a flash component can be overwritten when
> + * performing an update. Overwriting of firmware binary sections is always
> + * implicitly assumed to be allowed.
> + *
> + * Each section must be documented in
> + * Documentation/networking/devlink/devlink-flash.rst
> + *
> + */
> +enum {
> +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
> +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,

IMHO generally a good practice to have 0 be undefined.

> +	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
> +	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
> +};
