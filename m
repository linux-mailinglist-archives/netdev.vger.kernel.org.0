Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A0518EC5A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCVU52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgCVU52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:57:28 -0400
Received: from kicinski-fedora-PC1C0HJN (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F732072D;
        Sun, 22 Mar 2020 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584910647;
        bh=xBvP7Mp+pIHzZ93/dMcpBy8F5PSodaSobgfh0uLPEk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WtEr6VHXTRjFlG33SYqFSRXXBVc/m3Xif14qnxtNFV0BegVte9pDAUwNwIcksbAl+
         DjsKQY4TIBmOZZCI8Jzy2C8ym4MEoJNI2wga1RdSR68e5k2FPQ8aC2QvAPiwcrOvck
         19EQhi2T54Cynr3Qz9GMPN1bAYrng9n45klv0Y/Q=
Date:   Sun, 22 Mar 2020 13:57:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@mellanox.com,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] cxgb4/chcr: nic-tls stats in ethtool
Message-ID: <20200322135725.6cdc37a8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200321112336.8771-1-rohitm@chelsio.com>
References: <20200321112336.8771-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 16:53:36 +0530 Rohit Maheshwari wrote:
> Included nic tls statistics in ethtool stats.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 57 +++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> index 398ade42476c..4998f1d1e218 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> @@ -134,6 +134,28 @@ static char loopback_stats_strings[][ETH_GSTRING_LEN] = {
>  	"bg3_frames_trunc       ",
>  };
>  
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +struct chcr_tls_stats {
> +	u64 tx_tls_encrypted_packets;
> +	u64 tx_tls_encrypted_bytes;
> +	u64 tx_tls_ctx;
> +	u64 tx_tls_ooo;
> +	u64 tx_tls_skip_no_sync_data;
> +	u64 tx_tls_drop_no_sync_data;
> +	u64 tx_tls_drop_bypass_req;

I don't understand why you need to have a structure for this, and then
you memset it to 0, unnecessarily, but I guess that's just a matter of
taste.

> +};
> +
> +static char chcr_tls_stats_strings[][ETH_GSTRING_LEN] = {
> +	"tx_tls_encrypted_pkts  ",
> +	"tx_tls_encrypted_bytes ",
> +	"tx_tls_ctx             ",
> +	"tx_tls_ooo             ",
> +	"tx_tls_skip_nosync_data",
> +	"tx_tls_drop_nosync_data",
> +	"tx_tls_drop_bypass_req ",

These, however, are not correct - please remove the spaces at the end,
otherwise your names are different than for other vendors. And there is
an underscore in the middle of "no_sync".

When you're told to adhere to API recommendation, please adhere to it
exactly.

> +};
> +#endif
> +
>  static const char cxgb4_priv_flags_strings[][ETH_GSTRING_LEN] = {
>  	[PRIV_FLAG_PORT_TX_VM_BIT] = "port_tx_vm_wr",
>  };
> @@ -144,6 +166,9 @@ static int get_sset_count(struct net_device *dev, int sset)
>  	case ETH_SS_STATS:
>  		return ARRAY_SIZE(stats_strings) +
>  		       ARRAY_SIZE(adapter_stats_strings) +
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +		       ARRAY_SIZE(chcr_tls_stats_strings) +
> +#endif
>  		       ARRAY_SIZE(loopback_stats_strings);
>  	case ETH_SS_PRIV_FLAGS:
>  		return ARRAY_SIZE(cxgb4_priv_flags_strings);
> @@ -204,6 +229,11 @@ static void get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  		memcpy(data, adapter_stats_strings,
>  		       sizeof(adapter_stats_strings));
>  		data += sizeof(adapter_stats_strings);
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +		memcpy(data, chcr_tls_stats_strings,
> +		       sizeof(chcr_tls_stats_strings));
> +		data += sizeof(chcr_tls_stats_strings);
> +#endif
>  		memcpy(data, loopback_stats_strings,
>  		       sizeof(loopback_stats_strings));
>  	} else if (stringset == ETH_SS_PRIV_FLAGS) {
> @@ -289,6 +319,29 @@ static void collect_adapter_stats(struct adapter *adap, struct adapter_stats *s)
>  	}
>  }
>  
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +static void collect_chcr_tls_stats(struct adapter *adap,
> +				   struct chcr_tls_stats *s)
> +{
> +	struct chcr_stats_debug *stats = &adap->chcr_stats;
> +
> +	memset(s, 0, sizeof(*s));
> +
> +	s->tx_tls_encrypted_packets =
> +		atomic64_read(&stats->ktls_tx_encrypted_packets);
> +	s->tx_tls_encrypted_bytes =
> +		atomic64_read(&stats->ktls_tx_encrypted_bytes);
> +	s->tx_tls_ctx = atomic64_read(&stats->ktls_tx_ctx);
> +	s->tx_tls_ooo = atomic64_read(&stats->ktls_tx_ooo);
> +	s->tx_tls_skip_no_sync_data =
> +		atomic64_read(&stats->ktls_tx_skip_no_sync_data);
> +	s->tx_tls_drop_no_sync_data =
> +		atomic64_read(&stats->ktls_tx_drop_no_sync_data);
> +	s->tx_tls_drop_bypass_req =
> +		atomic64_read(&stats->ktls_tx_drop_bypass_req);
> +}
> +#endif
> +
>  static void get_stats(struct net_device *dev, struct ethtool_stats *stats,
>  		      u64 *data)
>  {
> @@ -307,6 +360,10 @@ static void get_stats(struct net_device *dev, struct ethtool_stats *stats,
>  	data += sizeof(struct queue_port_stats) / sizeof(u64);
>  	collect_adapter_stats(adapter, (struct adapter_stats *)data);
>  	data += sizeof(struct adapter_stats) / sizeof(u64);
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +	collect_chcr_tls_stats(adapter, (struct chcr_tls_stats *)data);
> +	data += sizeof(struct chcr_tls_stats) / sizeof(u64);
> +#endif
>  
>  	*data++ = (u64)pi->port_id;
>  	memset(&s, 0, sizeof(s));

