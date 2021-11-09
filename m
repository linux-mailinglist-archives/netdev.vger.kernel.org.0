Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4EA44B7F3
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbhKIWjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:39:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343664AbhKIWfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 17:35:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VXiC1cX0SBb1UiQKKFxqup5UQCdnpSH9v5AlEfUSCXY=; b=pEf9MupQiDH/dXE3L7PLK4IT9U
        3fMQmFiC8L9v1TT8okr3G0h2Izcvz05HLYzl1S54xhnsJEdebuyo38/0t1O+cMl/NZi+OKNk2wwGb
        NBS1Ry6m2FGKXE8+h5BZbKx6vStJqnJL3Ze8hAbXQIx6kpZpn2gFInyI+gKX35qohbEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkZfh-00D1u4-Kb; Tue, 09 Nov 2021 23:32:53 +0100
Date:   Tue, 9 Nov 2021 23:32:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        hkallweit1@gmail.com, alexandr.lobakin@intel.com, saeed@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv4 PATCH net-next] net: extend netdev_features_t
Message-ID: <YYr3FXJC3eu4AN31@lunn.ch>
References: <20211107101519.29264-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107101519.29264-1-shenjian15@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
> +	if ((netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) >
> +	    netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features)) &&

Using > is interesting.

But where did NETIF_F_NTUPLE_BIT come from?

> -	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> -		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
> -		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
> -		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
> -		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
> -		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
> +	netdev_features_zero(&features);
> +	netdev_features_set_array(hns3_default_features_array,
> +				  ARRAY_SIZE(hns3_default_features_array),
> +				  &features);

The original code is netdev->features |= so it is appending these
bits. Yet the first thing the new code does is zero features?

      Andrew
