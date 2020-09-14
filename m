Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41926824C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 03:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgINBhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 21:37:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgINBhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 21:37:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHdR1-00EXEE-HF; Mon, 14 Sep 2020 03:37:35 +0200
Date:   Mon, 14 Sep 2020 03:37:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using
 coresight
Message-ID: <20200914013735.GC3463198@lunn.ch>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
 <20200912144106.11799-13-oded.gabbay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912144106.11799-13-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gaudi_nic_get_module_eeprom(struct net_device *netdev,
> +					struct ethtool_eeprom *ee, u8 *data)
> +{
> +	struct gaudi_nic_device **ptr = netdev_priv(netdev);
> +	struct gaudi_nic_device *gaudi_nic = *ptr;
> +	struct hl_device *hdev = gaudi_nic->hdev;
> +
> +	if (!ee->len)
> +		return -EINVAL;
> +
> +	memset(data, 0, ee->len);
> +	memcpy(data, hdev->asic_prop.cpucp_nic_info.qsfp_eeprom, ee->len);
> +

You memset and then memcpy the same number of bytes?

You also need to validate ee->offset, and ee->len. Otherwise this is a
vector for user space to read kernel memory after
hdev->asic_prop.cpucp_nic_info.qsfp_eeprom. See drivers/net/phy/sfp.c:
sfp_module_eeprom() as a good example of this validation.

    Andrew
