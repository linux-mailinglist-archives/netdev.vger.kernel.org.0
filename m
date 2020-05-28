Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8781E6A4D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406315AbgE1TVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:21:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:41388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406306AbgE1TU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:20:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 179D8AF6D;
        Thu, 28 May 2020 19:20:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 14A6560347; Thu, 28 May 2020 21:20:51 +0200 (CEST)
Date:   Thu, 28 May 2020 21:20:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/4] vmxnet3: add support to get/set rx flow
 hash
Message-ID: <20200528192051.hnqeifcjmfu5vffz@lion.mk-sys.cz>
References: <20200528183615.27212-1-doshir@vmware.com>
 <20200528183615.27212-3-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528183615.27212-3-doshir@vmware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:36:13AM -0700, Ronak Doshi wrote:
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
> index 1163eca7aba5..83cec9946466 100644
> --- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
> +++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> @@ -665,18 +665,237 @@ vmxnet3_set_ringparam(struct net_device *netdev,
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
> +	case AH_ESP_V4_FLOW:
> +	case AH_V4_FLOW:
> +	case ESP_V4_FLOW:
> +		if (rss_fields & VMXNET3_RSS_FIELDS_ESPIP4)
> +			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +			/* fallthrough */
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

This still suffers from the inconsistency between get and set handler
I already pointed out in v1:

- there is no way to change VMXNET3_RSS_FIELDS_TCPIP{4,6} bits
- get_rxnfc() may return value that set_rxnfc() won't accept
- get_rxnfc() may return different value than set_rxnfc() set

Above, vmxnet3_get_rss_hash_opts() returns 0 or
RXH_L4_B_0_1 | RXH_L4_B_2_3 | RXH_IP_SRC | RXH_IP_DST for any of
{TCP,UDP}_V{4,6}_FLOW, depending on corresponding bit in rss_fields. But
here you accept only all four bits for TCP (both v4 and v6) and either
the two RXH_IP_* bits or all four for UDP.

Michal

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
[...]
