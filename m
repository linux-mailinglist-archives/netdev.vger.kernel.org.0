Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA63354832
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhDEVes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:34:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239935AbhDEVeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 17:34:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTWrm-00EzfB-E2; Mon, 05 Apr 2021 23:34:38 +0200
Date:   Mon, 5 Apr 2021 23:34:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA
 nodes
Message-ID: <YGuCblk9vvmD0NiH@lunn.ch>
References: <20210405164643.21130-1-michael@walle.cc>
 <20210405164643.21130-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405164643.21130-3-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

> -static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
> +static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>  {
>  	struct platform_device *pdev = of_find_device_by_node(np);
> +	struct nvmem_cell *cell;
> +	const void *mac;
> +	size_t len;
>  	int ret;
>  
> -	if (!pdev)
> -		return -ENODEV;
> +	/* Try lookup by device first, there might be a nvmem_cell_lookup
> +	 * associated with a given device.
> +	 */
> +	if (pdev) {
> +		ret = nvmem_get_mac_address(&pdev->dev, addr);
> +		put_device(&pdev->dev);
> +		return ret;
> +	}

Can you think of any odd corner case where nvmem_get_mac_address()
would fail, but of_nvmem_cell_get(np, "mac-address") would work?

      Andrew
