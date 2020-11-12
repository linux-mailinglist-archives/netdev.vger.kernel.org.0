Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5392B0F1D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgKLUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgKLUkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:40:37 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51258216C4;
        Thu, 12 Nov 2020 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605213636;
        bh=/eXhgchzcoJxeDp1IAW4yf8roLRQLzQOciGB9j9SjPg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FqLP6D3DdUz4eobJJXxEUvYQiuRNMTyLpeX0eiBk8AIUsZgX1zaP8ppmojZC90S7z
         Cl4rnZszzsMT8c5JEFknz3R5KLBjk47uzFD6K5LpjAYbPlJm2Pu/ZAPzFpJTUdkhFs
         3kczpIWbib4/xS9LgUqAfZAoEv1Z9/ggpU2zYj6A=
Message-ID: <e05a7a100208033cb428eb44ad59f7bf77729727.camel@kernel.org>
Subject: Re: [PATCH net-next 2/7] dpaa_eth: add basic XDP support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>, kuba@kernel.org,
        brouer@redhat.com, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:40:31 -0800
In-Reply-To: <7389fa62d9e311236f2e39c5d5d153cabc59949d.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
         <7389fa62d9e311236f2e39c5d5d153cabc59949d.1605181416.git.camelia.groza@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 20:10 +0200, Camelia Groza wrote:
> Implement the XDP_DROP and XDP_PASS actions.
> 
> Avoid draining and reconfiguring the buffer pool at each XDP
> setup/teardown by increasing the frame headroom and reserving
> XDP_PACKET_HEADROOM bytes from the start. Since we always reserve an
> entire page per buffer, this change only impacts Jumbo frame
> scenarios
> where the maximum linear frame size is reduced by 256 bytes. Multi
> buffer Scatter/Gather frames are now used instead in these scenarios.
> 
> Allow XDP programs to access the entire buffer.
> 
> The data in the received frame's headroom can be overwritten by the
> XDP
> program. Extract the relevant fields from the headroom while they are
> still available, before running the XDP program.
> 
> Since the headroom might be resized before the frame is passed up to
> the
> stack, remove the check for a fixed headroom value when building an
> skb.
> 
> Allow the meta data to be updated and pass the information up the
> stack.
> 
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 148
> ++++++++++++++++++++++---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
>  2 files changed, 134 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 88533a2..d1d8a46 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -53,6 +53,8 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/sort.h>
>  #include <linux/phy_fixed.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
>  #include <soc/fsl/bman.h>
>  #include <soc/fsl/qman.h>
>  #include "fman.h"
> @@ -177,7 +179,7 @@
>  #define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE +
> DPAA_TIME_STAMP_SIZE \
>  		       + DPAA_HASH_RESULTS_SIZE)
>  #define DPAA_RX_PRIV_DATA_DEFAULT_SIZE (DPAA_TX_PRIV_DATA_SIZE + \
> -					dpaa_rx_extra_headroom)
> +					XDP_PACKET_HEADROOM -
> DPAA_HWA_SIZE)
>  #ifdef CONFIG_DPAA_ERRATUM_A050385
>  #define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN -
> DPAA_HWA_SIZE)
>  #define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> @@ -1733,7 +1735,6 @@ static struct sk_buff *contig_fd_to_skb(const
> struct dpaa_priv *priv,
>  			SKB_DATA_ALIGN(sizeof(struct
> skb_shared_info)));
>  	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
>  		goto free_buffer;
> -	WARN_ON(fd_off != priv->rx_headroom);
>  	skb_reserve(skb, fd_off);
>  	skb_put(skb, qm_fd_get_length(fd));
>  
> @@ -2349,12 +2350,62 @@ static enum qman_cb_dqrr_result
> rx_error_dqrr(struct qman_portal *portal,
>  	return qman_cb_dqrr_consume;
>  }
>  
> +static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd,
> void *vaddr,
> +			unsigned int *xdp_meta_len)
> +{
> +	ssize_t fd_off = qm_fd_get_offset(fd);
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 xdp_act;
> +
> +	rcu_read_lock();
> +
> +	xdp_prog = READ_ONCE(priv->xdp_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		return XDP_PASS;
> +	}
> +
> +	xdp.data = vaddr + fd_off;
> +	xdp.data_meta = xdp.data;
> +	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
> +	xdp.data_end = xdp.data + qm_fd_get_length(fd);
> +	xdp.frame_sz = DPAA_BP_RAW_SIZE;
> +
> +	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +
> +	/* Update the length and the offset of the FD */
> +	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end -
> xdp.data);
> +
> +	switch (xdp_act) {
> +	case XDP_PASS:
> +		*xdp_meta_len = xdp.data - xdp.data_meta;
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(xdp_act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
> +		fallthrough;
> +	case XDP_DROP:
> +		/* Free the buffer */
> +		free_pages((unsigned long)vaddr, 0);
> +		break;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return xdp_act;
> +}
> +
>  static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal
> *portal,
>  						struct qman_fq *fq,
>  						const struct
> qm_dqrr_entry *dq,
>  						bool sched_napi)
>  {
> +	bool ts_valid = false, hash_valid = false;
>  	struct skb_shared_hwtstamps *shhwtstamps;
> +	unsigned int skb_len, xdp_meta_len = 0;
>  	struct rtnl_link_stats64 *percpu_stats;
>  	struct dpaa_percpu_priv *percpu_priv;
>  	const struct qm_fd *fd = &dq->fd;
> @@ -2364,10 +2415,11 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
>  	u32 fd_status, hash_offset;
>  	struct dpaa_bp *dpaa_bp;
>  	struct dpaa_priv *priv;
> -	unsigned int skb_len;
>  	struct sk_buff *skb;
>  	int *count_ptr;
> +	u32 xdp_act;
>  	void *vaddr;
> +	u32 hash;
>  	u64 ns;
>  
>  	fd_status = be32_to_cpu(fd->status);
> @@ -2423,35 +2475,58 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
>  	count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
>  	(*count_ptr)--;
>  
> -	if (likely(fd_format == qm_fd_contig))
> +	/* Extract the timestamp stored in the headroom before running
> XDP */
> +	if (priv->rx_tstamp) {
> +		if (!fman_port_get_tstamp(priv->mac_dev->port[RX],
> vaddr, &ns))
> +			ts_valid = true;
> +		else
> +			dev_warn(net_dev->dev.parent,
> "fman_port_get_tstamp failed!\n");

dev_warn per packet is a bad idea.. you might want to change this to
WARN_ONCE() or a counter.

> +	}
> +
> +	/* Extract the hash stored in the headroom before running XDP
> */
> +	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> &&
> +	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> +					      &hash_offset)) {
> +		hash = be32_to_cpu(*(u32 *)(vaddr + hash_offset));
> +		hash_valid = true;
> +	}
> +


I hope you keep this data avaialbe in the headroom buffer on
extraction..
Soon enough XDP programs will have the means to see the headroom meta
data from the NIC.

https://zabiplane.groups.io/g/dev/message/56

Latest discussion on making NIC timestamp available to XDP programs.

https://www.spinics.net/lists/netdev/msg699281.html


> +	if (likely(fd_format == qm_fd_contig)) {
> +		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> +				       &xdp_meta_len);
> +		if (xdp_act != XDP_PASS) {
> +			percpu_stats->rx_packets++;
> +			percpu_stats->rx_bytes += qm_fd_get_length(fd);
> +			return qman_cb_dqrr_consume;
> +		}
>  		skb = contig_fd_to_skb(priv, fd);
> -	else
> +	} else {
> +		WARN_ONCE(priv->xdp_prog, "S/G frames not supported
> under XDP\n");
>  		skb = sg_fd_to_skb(priv, fd);
> +	}
>  	if (!skb)
>  		return qman_cb_dqrr_consume;
>  
> -	if (priv->rx_tstamp) {
> +	if (xdp_meta_len)
> +		skb_metadata_set(skb, xdp_meta_len);
> +
> +	/* Set the previously extracted timestamp */
> +	if (ts_valid) {
>  		shhwtstamps = skb_hwtstamps(skb);
>  		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> -
> -		if (!fman_port_get_tstamp(priv->mac_dev->port[RX],
> vaddr, &ns))
> -			shhwtstamps->hwtstamp = ns_to_ktime(ns);
> -		else
> -			dev_warn(net_dev->dev.parent,
> "fman_port_get_tstamp failed!\n");
> +		shhwtstamps->hwtstamp = ns_to_ktime(ns);
>  	}
>  
>  	skb->protocol = eth_type_trans(skb, net_dev);
>  
> -	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> &&
> -	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> -					      &hash_offset)) {
> +	/* Set the previously extracted hash */
> +	if (hash_valid) {
>  		enum pkt_hash_types type;
>  
>  		/* if L4 exists, it was used in the hash generation */
>  		type = be32_to_cpu(fd->status) & FM_FD_STAT_L4CV ?
>  			PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
> -		skb_set_hash(skb, be32_to_cpu(*(u32 *)(vaddr +
> hash_offset)),
> -			     type);
> +		skb_set_hash(skb, hash, type);
>  	}
>  


