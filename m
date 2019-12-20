Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8212792D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfLTKSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:18:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfLTKSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 05:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SvddWfTI/HFSZzIg7oe7QhsGZ7pz+7bLMCfyWciZGh0=; b=5JskYvrntnDb6k/KkUWUPnhN7p
        TtCyNDVAkv9enzcEJNeWFoscjTQUYgDMBstZgMd+W7kIqYHuIVAl9nrznZRw8kY6dmiWT1RH3+TvK
        iNdGfbPrPY8CU5eFy9Q7ao0nglr3fQIZMf+mTwCx9R/fk5Z5e6sLFEh7ry73AIaj6ov8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiFMd-0007U7-Ha; Fri, 20 Dec 2019 11:18:31 +0100
Date:   Fri, 20 Dec 2019 11:18:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cris Forno <cforno12@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
Message-ID: <20191220101831.GF24174@lunn.ch>
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com>
 <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 02:54:09PM -0600, Cris Forno wrote:
> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>  	return 0;
>  }
>  
> +/* Check if the user is trying to change anything besides speed/duplex */
> +static bool
> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> +{
> +	struct ethtool_link_ksettings diff1 = *cmd;
> +	struct ethtool_link_ksettings diff2 = {};

Hi Cris

These are not the best of names. How about request and valid?

> +
> +	/* cmd is always set so we need to clear it, validate the port type
> +	 * and also without autonegotiation we can ignore advertising
> +	 */
> +	diff1.base.speed = 0;
> +	diff2.base.port = PORT_OTHER;
> +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> +	diff1.base.duplex = 0;
> +	diff1.base.cmd = 0;
> +	diff1.base.link_mode_masks_nwords = 0;
> +
> +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&

linkmode_equal()

> +		bitmap_empty(diff1.link_modes.supported,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&

linkmode_empty()

	Andrew
