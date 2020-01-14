Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2194313A72D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgANKTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:19:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:36634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbgANKTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:19:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46E0CACB8;
        Tue, 14 Jan 2020 10:19:50 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EA694E0488; Tue, 14 Jan 2020 11:19:49 +0100 (CET)
Date:   Tue, 14 Jan 2020 11:19:49 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     sunil.kovvuri@gmail.com, davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: Re: [PATCH v2 15/17] octeontx2-pf: ethtool RSS config support
Message-ID: <20200114101949.GB22304@unicorn.suse.cz>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578985340-28775-16-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578985340-28775-16-git-send-email-sunil.kovvuri@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 12:32:18PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Added support to show or configure RSS hash key, indirection table,
> 2,4 tuple via ethtool. Also added debug msg_level support
> to dump messages when HW reports errors in packet received
> or transmitted.
> 
> Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
[...]
> +static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
> +				  struct ethtool_rxnfc *nfc)
> +{
> +	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> +	u32 rxh_l4 = RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +	u32 rss_cfg = rss->flowkey_cfg;
> +
> +	if (!rss->enable)
> +		netdev_err(pfvf->netdev, "RSS is disabled, cmd ignored\n");
> +
> +	/* Mimimum is IPv4 and IPv6, SIP/DIP */
> +	if (!(nfc->data & RXH_IP_SRC) || !(nfc->data & RXH_IP_DST))
> +		return -EINVAL;
> +
> +	switch (nfc->flow_type) {
> +	case TCP_V4_FLOW:
> +	case TCP_V6_FLOW:
> +		/* Different config for v4 and v6 is not supported.
> +		 * Both of them have to be either 4-tuple or 2-tuple.
> +		 */
> +		if ((nfc->data & rxh_l4) == rxh_l4)
> +			rss_cfg |= NIX_FLOW_KEY_TYPE_TCP;
> +		else
> +			rss_cfg &= ~NIX_FLOW_KEY_TYPE_TCP;
> +		break;

IMHO it would be cleaner to reject requests with only one bit set than
to silently clear the bit (same for UDP and SCTP). You also shouldn't
silently ignore unsupported bits.

Michal Kubecek

> +	case UDP_V4_FLOW:
> +	case UDP_V6_FLOW:
> +		if ((nfc->data & rxh_l4) == rxh_l4)
> +			rss_cfg |= NIX_FLOW_KEY_TYPE_UDP;
> +		else
> +			rss_cfg &= ~NIX_FLOW_KEY_TYPE_UDP;
> +		break;
> +	case SCTP_V4_FLOW:
> +	case SCTP_V6_FLOW:
> +		if ((nfc->data & rxh_l4) == rxh_l4)
> +			rss_cfg |= NIX_FLOW_KEY_TYPE_SCTP;
> +		else
> +			rss_cfg &= ~NIX_FLOW_KEY_TYPE_SCTP;
> +		break;
> +	case AH_ESP_V4_FLOW:
> +	case AH_V4_FLOW:
> +	case ESP_V4_FLOW:
> +	case IPV4_FLOW:
> +	case AH_ESP_V6_FLOW:
> +	case AH_V6_FLOW:
> +	case ESP_V6_FLOW:
> +	case IPV6_FLOW:
> +		rss_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	rss->flowkey_cfg = rss_cfg;
> +	otx2_set_flowkey_cfg(pfvf);
> +	return 0;
> +}
