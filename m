Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0705356E75
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFZQNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:13:44 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:43215 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZQNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 12:13:44 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 45Yp2p5mdrzJb;
        Wed, 26 Jun 2019 18:12:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1561565556; bh=n5zWYxICS2xoE95InVjEnZLwmYctSBGSJ8mrMXN7MT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FfPhjsaevimtQ2UpqFsl9LwLXUYXcpAP17KKTqiAP1CWBql6MTg3vBZ/R4qLNQOBZ
         sjBwmnjwNpdLDnEKyo94rfZBzQMDkX1weA/tsNPUBu3p8XWSd0ayBrx92HoRRzeHg2
         rYwcexbv2wZitx++RU0UxqnooI1f0nv4QwNFfTw8/sR1HaTXUR8/aZaD1IRyH8SMD0
         K1YLX0OW2WBSyH5qMKOBsrzpQpsig75bVJkSNgvuRa1/QQoxIGFFtK7tBYy85vCovq
         SPrhqlCBpyM8ZKH2EVybAWFrXq0EaVXngTvNbDIgKAuR2V9p1CmKBM0FOPnrJGZiYM
         0TDCBNmjPk3tw==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.100.3 at mail
Date:   Wed, 26 Jun 2019 18:13:38 +0200
From:   mirq-linux@rere.qmqm.pl
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, sdf@google.com, jianbol@mellanox.com,
        jiri@mellanox.com, willemb@google.com, sdf@fomichev.me,
        jiri@resnulli.us, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always enable vlan tx offload
Message-ID: <20190626161337.GA18953@qmqm.qmqm.pl>
References: <20190624135007.GA17673@nanopsycho>
 <20190626080844.20796-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190626080844.20796-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 04:08:44PM +0800, YueHaibing wrote:
> We build vlan on top of bonding interface, which vlan offload
> is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
> BOND_XMIT_POLICY_ENCAP34.
> 
> Because vlan tx offload is off, vlan tci is cleared and skb push
> the vlan header in validate_xmit_vlan() while sending from vlan
> devices. Then in bond_xmit_hash, __skb_flow_dissect() fails to
> get information from protocol headers encapsulated within vlan,
> because 'nhoff' is points to IP header, so bond hashing is based
> on layer 2 info, which fails to distribute packets across slaves.
> 
> This patch always enable bonding's vlan tx offload, pass the vlan
> packets to the slave devices with vlan tci, let them to handle
> vlan implementation.
[...]
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 407f4095a37a..799fc38c5c34 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4320,12 +4320,12 @@ void bond_setup(struct net_device *bond_dev)
>  	bond_dev->features |= NETIF_F_NETNS_LOCAL;
>  
>  	bond_dev->hw_features = BOND_VLAN_FEATURES |
> -				NETIF_F_HW_VLAN_CTAG_TX |
>  				NETIF_F_HW_VLAN_CTAG_RX |
>  				NETIF_F_HW_VLAN_CTAG_FILTER;
>  
>  	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
>  	bond_dev->features |= bond_dev->hw_features;
> +	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
>  }
>  
>  /* Destroy a bonding device.
> 

I can see that bonding driver uses dev_queue_xmit() to pass packets to
slave links, but I can't see where in the path it does software fallback
for devices without HW VLAN tagging. Generally drivers that don't ever
do VLAN offload also ignore vlan_tci presence. Am I missing something
here?

Best Regards,
Micha³ Miros³aw
