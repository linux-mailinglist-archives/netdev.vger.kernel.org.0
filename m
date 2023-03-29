Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F316CF27D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjC2Swv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjC2Swv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C024C3A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC11E61DF0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F149C433D2;
        Wed, 29 Mar 2023 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680115959;
        bh=tJQh8hxzb6cjcoek/HQB41uPjrQD4yyLbq9tcQ3pF/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIh9Np5aTc+r0EfkzEQ4duxBzRQm8Dzx1YAiCn6RNu64/Yuc3OqsAEWuaFIoym6xk
         HFXBWb5rmQqWYIrrqQv95U2gJwFu39XrVcwMvYtdTzMdgq/I50srkNm8x7hezqS3Id
         VMoHQmm6wKtO5KUF/Yxm3+gPC/Hp2DvKMrI6q9UTpi1DSvFIVun56InIF/kllgzIWw
         AgnFqFyg8bGb3ikrczhI9gV0CIZ+Y7xjSPbbx/uzCU5Hm4nuIzoOVlFq/oBV23uq3r
         BQftPxXiVQlLJNNUfcCdRcbObLdkaGOK0E7xd522YKu7jTmThfbYtXC0YInYH1TL0D
         r0/aq3JyLMQFg==
Date:   Wed, 29 Mar 2023 21:52:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230329185235.GD831478@unreal>
References: <20230329144548.66708-1-louis.peens@corigine.com>
 <20230329144548.66708-3-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329144548.66708-3-louis.peens@corigine.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:45:48PM +0200, Louis Peens wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> For nic application firmware, enable the ports' phy state at the
> beginning. And by default its state doesn't change in pace with
> the upper state, unless the ethtool private flag "link_state_detach"
> is turned off by:
> 
>  ethtool --set-private-flags <netdev> link_state_detach off
> 
> With this separation, we're able to keep the VF state up while
> bringing down the PF.

What does it mean "bringing down the PF"?

Thanks

> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 103 ++++++++++++++++++
>  drivers/net/ethernet/netronome/nfp/nic/main.c |  20 ++++
>  2 files changed, 123 insertions(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index dfedb52b7e70..fd4cf865da4a 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -841,6 +841,102 @@ static void nfp_net_self_test(struct net_device *netdev, struct ethtool_test *et
>  	netdev_info(netdev, "Test end\n");
>  }
>  
> +static bool nfp_pflag_get_link_state_detach(struct net_device *netdev)
> +{
> +	struct nfp_port *port = nfp_port_from_netdev(netdev);
> +
> +	if (!__nfp_port_get_eth_port(port))
> +		return false;
> +
> +	return port->eth_forced;
> +}
> +
> +static int nfp_pflag_set_link_state_detach(struct net_device *netdev, bool en)
> +{
> +	struct nfp_port *port = nfp_port_from_netdev(netdev);
> +	struct nfp_eth_table_port *eth_port;
> +
> +	eth_port = __nfp_port_get_eth_port(port);
> +	if (!eth_port)
> +		return -EOPNOTSUPP;
> +
> +	if (!en) {
> +		/* When turning link_state_detach off, we need change the lower
> +		 * phy state if it's different with admin state.
> +		 * Contrarily, we can leave the lower phy state as it is when
> +		 * turning the flag on, since it's detached.
> +		 */
> +		int err = nfp_eth_set_configured(port->app->cpp, eth_port->index,
> +						 netif_running(netdev));
> +		if (err && err != -EOPNOTSUPP)
> +			return err;
> +	}
> +
> +	port->eth_forced = en;
> +	return 0;
> +}
> +
> +#define DECLARE_NFP_PFLAG(flag)	{	\
> +	.name	= #flag,		\
> +	.get	= nfp_pflag_get_##flag,	\
> +	.set	= nfp_pflag_set_##flag,	\
> +	}
> +
> +static const struct {
> +	const char name[ETH_GSTRING_LEN];
> +	bool (*get)(struct net_device *netdev);
> +	int (*set)(struct net_device *netdev, bool en);
> +} nfp_pflags[] = {
> +	DECLARE_NFP_PFLAG(link_state_detach),
> +};
> +
> +#define NFP_PFLAG_MAX ARRAY_SIZE(nfp_pflags)
> +
> +static void nfp_get_pflag_strings(struct net_device *netdev, u8 *data)
> +{
> +	for (u32 i = 0; i < NFP_PFLAG_MAX; i++)
> +		ethtool_sprintf(&data, nfp_pflags[i].name);
> +}
> +
> +static int nfp_get_pflag_count(struct net_device *netdev)
> +{
> +	return NFP_PFLAG_MAX;
> +}
> +
> +static u32 nfp_net_get_pflags(struct net_device *netdev)
> +{
> +	u32 pflags = 0;
> +
> +	for (u32 i = 0; i < NFP_PFLAG_MAX; i++) {
> +		if (nfp_pflags[i].get(netdev))
> +			pflags |= BIT(i);
> +	}
> +
> +	return pflags;
> +}
> +
> +static int nfp_net_set_pflags(struct net_device *netdev, u32 pflags)
> +{
> +	u32 changed = nfp_net_get_pflags(netdev) ^ pflags;
> +	int err;
> +
> +	for (u32 i = 0; i < NFP_PFLAG_MAX; i++) {
> +		bool en;
> +
> +		if (!(changed & BIT(i)))
> +			continue;
> +
> +		en = !!(pflags & BIT(i));
> +		err = nfp_pflags[i].set(netdev, en);
> +		if (err)
> +			return err;
> +
> +		netdev_info(netdev, "%s is %sabled.", nfp_pflags[i].name, en ? "en" : "dis");
> +	}
> +
> +	return 0;
> +}
> +
>  static unsigned int nfp_vnic_get_sw_stats_count(struct net_device *netdev)
>  {
>  	struct nfp_net *nn = netdev_priv(netdev);
> @@ -1107,6 +1203,9 @@ static void nfp_net_get_strings(struct net_device *netdev,
>  	case ETH_SS_TEST:
>  		nfp_get_self_test_strings(netdev, data);
>  		break;
> +	case ETH_SS_PRIV_FLAGS:
> +		nfp_get_pflag_strings(netdev, data);
> +		break;
>  	}
>  }
>  
> @@ -1143,6 +1242,8 @@ static int nfp_net_get_sset_count(struct net_device *netdev, int sset)
>  		return cnt;
>  	case ETH_SS_TEST:
>  		return nfp_get_self_test_count(netdev);
> +	case ETH_SS_PRIV_FLAGS:
> +		return nfp_get_pflag_count(netdev);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -2116,6 +2217,8 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
>  	.set_fecparam		= nfp_port_set_fecparam,
>  	.get_pauseparam		= nfp_port_get_pauseparam,
>  	.set_phys_id		= nfp_net_set_phys_id,
> +	.get_priv_flags		= nfp_net_get_pflags,
> +	.set_priv_flags		= nfp_net_set_pflags,
>  };
>  
>  const struct ethtool_ops nfp_port_ethtool_ops = {
> diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
> index 9dd5afe37f6e..7d8505c033ee 100644
> --- a/drivers/net/ethernet/netronome/nfp/nic/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
> @@ -6,6 +6,7 @@
>  #include "../nfp_app.h"
>  #include "../nfp_main.h"
>  #include "../nfp_net.h"
> +#include "../nfp_port.h"
>  #include "main.h"
>  
>  static int nfp_nic_init(struct nfp_app *app)
> @@ -32,11 +33,30 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
>  
>  static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
>  {
> +	struct nfp_port *port = nn->port;
> +
> +	if (port->type == NFP_PORT_PHYS_PORT) {
> +		/* Enable PHY state here, and its state doesn't change in
> +		 * pace with the port upper state by default. The behavior
> +		 * can be modified by ethtool private flag "link_state_detach".
> +		 */
> +		int err = nfp_eth_set_configured(app->cpp,
> +						 port->eth_port->index,
> +						 true);
> +		if (err >= 0)
> +			port->eth_forced = true;
> +	}
> +
>  	return nfp_nic_dcb_init(nn);
>  }
>  
>  static void nfp_nic_vnic_clean(struct nfp_app *app, struct nfp_net *nn)
>  {
> +	struct nfp_port *port = nn->port;
> +
> +	if (port->type == NFP_PORT_PHYS_PORT)
> +		nfp_eth_set_configured(app->cpp, port->eth_port->index, false);
> +
>  	nfp_nic_dcb_clean(nn);
>  }
>  
> -- 
> 2.34.1
> 
