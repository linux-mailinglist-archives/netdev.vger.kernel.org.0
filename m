Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EE61E5706
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgE1Fuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:50:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:60170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgE1Fub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 01:50:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A63DAF92;
        Thu, 28 May 2020 05:50:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9E91D60489; Thu, 28 May 2020 07:50:28 +0200 (CEST)
Date:   Thu, 28 May 2020 07:50:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] vmxnet3: add support to get/set rx flow hash
Message-ID: <20200528055028.yagr6r3rrjb3qrlc@lion.mk-sys.cz>
References: <20200528020707.10036-1-doshir@vmware.com>
 <20200528020707.10036-3-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528020707.10036-3-doshir@vmware.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 07:07:04PM -0700, Ronak Doshi wrote:
> With vmxnet3 version 4, the emulation supports multiqueue(RSS) for
> UDP and ESP traffic. A guest can enable/disable RSS for UDP/ESP over
> IPv4/IPv6 by issuing commands introduced in this patch. ESP ipv6 is
> not yet supported in this patch.
> 
> This patch implements get_rss_hash_opts and set_rss_hash_opts
> methods to allow querying and configuring different Rx flow hash
> configurations.
> 
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> ---
[...]
> diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> index 1163eca7aba5..ceedf63020cb 100644
> --- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
> +++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> @@ -665,18 +665,236 @@ vmxnet3_set_ringparam(struct net_device *netdev,
>  	return err;
>  }
>  
> +static int
> +vmxnet3_get_rss_hash_opts(struct vmxnet3_adapter *adapter,
> +			  struct ethtool_rxnfc *info)
> +{
> +	enum Vmxnet3_RSSField rss_fields;
> +
> +	if (netif_running(adapter->netdev)) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&adapter->cmd_lock, flags);
> +
> +		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
> +				       VMXNET3_CMD_GET_RSS_FIELDS);
> +		rss_fields = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
> +		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
> +	} else {
> +		rss_fields = adapter->rss_fields;
> +	}
> +
> +	info->data = 0;
> +
> +	/* Report default options for RSS on vmxnet3 */
> +	switch (info->flow_type) {
> +	case TCP_V4_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_TCPIP4)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +				      RXH_IP_SRC | RXH_IP_DST;
> +		break;
> +	case UDP_V4_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_UDPIP4)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +				      RXH_IP_SRC | RXH_IP_DST;
> +		break;

In both cases above (and also in the two for IPv6 below) you set
info->data to either 0 or all four bits, depending on the value of
corresponding flag in rss_fields. But in vmxnet3_set_rss_hash_opt()
you have different mapping:

  - for TCP, you only accept all four bits (no other value) and don't
    touch rss_fields at all
  - for UDP, you allow either all four bits (and set the flag) or the
    two IP related bits (and clear the flag)

The UDPv4/UDPv6 behaviour of vmxnet3_set_rss_hash_opt() seems to be the
correct one but you should be consistent between get and set handlers.

> +	case AH_ESP_V4_FLOW:
> +	case AH_V4_FLOW:
> +	case ESP_V4_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_ESPIP4)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;

If this fallthrough is intentional (it seems to be), it should be
marked.

Michal

> +	case SCTP_V4_FLOW:
> +	case IPV4_FLOW:
> +		info->data |= RXH_IP_SRC | RXH_IP_DST;
> +		break;
> +	case TCP_V6_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_TCPIP6)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +				      RXH_IP_SRC | RXH_IP_DST;
> +		break;
> +	case UDP_V6_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_UDPIP6)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +				      RXH_IP_SRC | RXH_IP_DST;
> +		break;
> +	case AH_ESP_V6_FLOW:
> +	case AH_V6_FLOW:
> +	case ESP_V6_FLOW:
> +	case SCTP_V6_FLOW:
> +	case IPV6_FLOW:
> +		info->data |= RXH_IP_SRC | RXH_IP_DST;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +vmxnet3_set_rss_hash_opt(struct net_device *netdev,
> +			 struct vmxnet3_adapter *adapter,
> +			 struct ethtool_rxnfc *nfc)
> +{
> +	enum Vmxnet3_RSSField rss_fields = adapter->rss_fields;
> +
> +	/* RSS does not support anything other than hashing
> +	 * to queues on src and dst IPs and ports
> +	 */
> +	if (nfc->data & ~(RXH_IP_SRC | RXH_IP_DST |
> +			  RXH_L4_B_0_1 | RXH_L4_B_2_3))
> +		return -EINVAL;
> +
> +	switch (nfc->flow_type) {
> +	case TCP_V4_FLOW:
> +	case TCP_V6_FLOW:
> +		if (!(nfc->data & RXH_IP_SRC) ||
> +		    !(nfc->data & RXH_IP_DST) ||
> +		    !(nfc->data & RXH_L4_B_0_1) ||
> +		    !(nfc->data & RXH_L4_B_2_3))
> +			return -EINVAL;
> +		break;
> +	case UDP_V4_FLOW:
> +		if (!(nfc->data & RXH_IP_SRC) ||
> +		    !(nfc->data & RXH_IP_DST))
> +			return -EINVAL;
> +		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
> +		case 0:
> +			rss_fields &= ~VMXNET3_RSS_FIELDS_UDPIP4;
> +			break;
> +		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
> +			rss_fields |= VMXNET3_RSS_FIELDS_UDPIP4;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +		break;
> +	case UDP_V6_FLOW:
> +		if (!(nfc->data & RXH_IP_SRC) ||
> +		    !(nfc->data & RXH_IP_DST))
> +			return -EINVAL;
> +		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
> +		case 0:
> +			rss_fields &= ~VMXNET3_RSS_FIELDS_UDPIP6;
> +			break;
> +		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
> +			rss_fields |= VMXNET3_RSS_FIELDS_UDPIP6;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +		break;
> +	case ESP_V4_FLOW:
> +	case AH_V4_FLOW:
> +	case AH_ESP_V4_FLOW:
> +		if (!(nfc->data & RXH_IP_SRC) ||
> +		    !(nfc->data & RXH_IP_DST))
> +			return -EINVAL;
> +		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
> +		case 0:
> +			rss_fields &= ~VMXNET3_RSS_FIELDS_ESPIP4;
> +			break;
> +		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
> +			rss_fields |= VMXNET3_RSS_FIELDS_ESPIP4;
> +		break;
> +		default:
> +			return -EINVAL;
> +		}
> +		break;
> +	case ESP_V6_FLOW:
> +	case AH_V6_FLOW:
> +	case AH_ESP_V6_FLOW:
> +	case SCTP_V4_FLOW:
> +	case SCTP_V6_FLOW:
> +		if (!(nfc->data & RXH_IP_SRC) ||
> +		    !(nfc->data & RXH_IP_DST) ||
> +		    (nfc->data & RXH_L4_B_0_1) ||
> +		    (nfc->data & RXH_L4_B_2_3))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* if we changed something we need to update flags */
> +	if (rss_fields != adapter->rss_fields) {
> +		adapter->default_rss_fields = false;
> +		if (netif_running(netdev)) {
> +			struct Vmxnet3_DriverShared *shared = adapter->shared;
> +			union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&adapter->cmd_lock, flags);
> +			cmdInfo->setRssFields = rss_fields;
> +			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
> +					       VMXNET3_CMD_SET_RSS_FIELDS);
> +
> +			/* Not all requested RSS may get applied, so get and
> +			 * cache what was actually applied.
> +			 */
> +			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
> +					       VMXNET3_CMD_GET_RSS_FIELDS);
> +			adapter->rss_fields =
> +				VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
> +			spin_unlock_irqrestore(&adapter->cmd_lock, flags);
> +		} else {
> +			/* When the device is activated, we will try to apply
> +			 * these rules and cache the applied value later.
> +			 */
> +			adapter->rss_fields = rss_fields;
> +		}
> +	}
> +	return 0;
> +}
>  
>  static int
>  vmxnet3_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info,
>  		  u32 *rules)
>  {
>  	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	int err = 0;
> +
>  	switch (info->cmd) {
>  	case ETHTOOL_GRXRINGS:
>  		info->data = adapter->num_rx_queues;
> -		return 0;
> +		break;
> +	case ETHTOOL_GRXFH:
> +		if (!VMXNET3_VERSION_GE_4(adapter)) {
> +			err = -EOPNOTSUPP;
> +			break;
> +		}
> +		err = vmxnet3_get_rss_hash_opts(adapter, info);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +		break;
>  	}
> -	return -EOPNOTSUPP;
> +
> +	return err;
> +}
> +
> +static int
> +vmxnet3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	int err = 0;
> +
> +	if (!VMXNET3_VERSION_GE_4(adapter)) {
> +		err = -EOPNOTSUPP;
> +		goto done;
> +	}
> +
> +	switch (info->cmd) {
> +	case ETHTOOL_SRXFH:
> +		err = vmxnet3_set_rss_hash_opt(netdev, adapter, info);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +		break;
> +	}
> +
> +done:
> +	return err;
>  }
>  
>  #ifdef VMXNET3_RSS
> @@ -887,6 +1105,7 @@ static const struct ethtool_ops vmxnet3_ethtool_ops = {
>  	.get_ringparam     = vmxnet3_get_ringparam,
>  	.set_ringparam     = vmxnet3_set_ringparam,
>  	.get_rxnfc         = vmxnet3_get_rxnfc,
> +	.set_rxnfc         = vmxnet3_set_rxnfc,
>  #ifdef VMXNET3_RSS
>  	.get_rxfh_indir_size = vmxnet3_get_rss_indir_size,
>  	.get_rxfh          = vmxnet3_get_rss,
> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> index e803ffad75d6..d52ccc3eeba2 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -377,6 +377,8 @@ struct vmxnet3_adapter {
>  	u16 rxdata_desc_size;
>  
>  	bool rxdataring_enabled;
> +	bool default_rss_fields;
> +	enum Vmxnet3_RSSField rss_fields;
>  
>  	struct work_struct work;
>  
> @@ -438,6 +440,8 @@ struct vmxnet3_adapter {
>  
>  #define VMXNET3_COAL_RBC_RATE(usecs) (1000000 / usecs)
>  #define VMXNET3_COAL_RBC_USECS(rbc_rate) (1000000 / rbc_rate)
> +#define VMXNET3_RSS_FIELDS_DEFAULT (VMXNET3_RSS_FIELDS_TCPIP4 | \
> +				    VMXNET3_RSS_FIELDS_TCPIP6)
>  
>  int
>  vmxnet3_quiesce_dev(struct vmxnet3_adapter *adapter);
> -- 
> 2.11.0
> 
