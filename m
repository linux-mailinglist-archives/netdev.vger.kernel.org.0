Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B8F624328
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiKJN0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKJN0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:26:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68E55B84A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5yFZm5aLOFj321Yzl0QBNzfEIj8FY/Lvlo0q55sGaL4=; b=CcUSPWv9uqyfytTFIKZpG2eee+
        2ApsXtyJd0SNOH0eDJW/hFLTnxo4s6pfCPTCKqLZfR9IfVN8CfWBoQaPeaP/ayTl23bDtlmfXcH0b
        YDv2ZSQl3BoQp4RNPyJvLqd1Fpgw90Jg29YgsxXUNCt4ne29jF++elfnXjU5gJgvkKUA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7ZK-0022C5-OM; Thu, 10 Nov 2022 14:26:10 +0100
Date:   Thu, 10 Nov 2022 14:26:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 4/4] mlxbf_gige: add "set_link_ksettings"
 ethtool callback
Message-ID: <Y2z78lwaeJKnL6DJ@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-5-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109224752.17664-5-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:47:52PM -0500, David Thompson wrote:
> This patch extends the "ethtool_ops" data structure to
> include the "set_link_ksettings" callback. This change
> enables configuration of the various interface speeds
> that the BlueField-3 supports (10Mbps, 100Mbps, and 1Gbps).
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c | 1 +
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> index 41ebef25a930..253d7ad9b809 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> @@ -135,4 +135,5 @@ const struct ethtool_ops mlxbf_gige_ethtool_ops = {
>  	.nway_reset		= phy_ethtool_nway_reset,
>  	.get_pauseparam		= mlxbf_gige_get_pauseparam,
>  	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
> +	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
>  };
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> index 80060a54ba95..a9fa662e0665 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -224,7 +224,7 @@ static int mlxbf_gige_stop(struct net_device *netdev)
>  }
>  
>  static int mlxbf_gige_eth_ioctl(struct net_device *netdev,
> -			       struct ifreq *ifr, int cmd)
> +				struct ifreq *ifr, int cmd)
>  {
>  	if (!(netif_running(netdev)))
>  		return -EINVAL;

White space changes should be in a separate patch.

With this fixed:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
