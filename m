Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01122C184D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgKWWPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:15:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:6413 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbgKWWPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:15:44 -0500
IronPort-SDR: b03sUXyTH7PnwQjYCaWssnCdw87VQ5iT4pWojNKooFGOMwlwwWkuymHX4/BLwSvgogoAOhyLC9
 FcPuZ3LZzaPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="171951075"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="171951075"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:15:43 -0800
IronPort-SDR: Y6Y8U3vV8pHfQKCbzY1jgcWy6WAV/afsY3Di2LoEOgzQqHy23/469u8srgYQfflBZ/vixKYn4i
 vQuOuGwCgnGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="361620722"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2020 14:15:40 -0800
Date:   Mon, 23 Nov 2020 23:07:52 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
Message-ID: <20201123220752.GB11618@ranger.igk.intel.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <257fc3a02512bb4d2fc5eccec1796011ec9f0fbb.1605802951.git.camelia.groza@nxp.com>
 <20201120001844.GB24983@ranger.igk.intel.com>
 <VI1PR04MB58076B6D16C76E71247BA12FF2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB58076B6D16C76E71247BA12FF2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:50:28PM +0000, Camelia Alexandra Groza wrote:
> > -----Original Message-----
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Friday, November 20, 2020 02:19
> > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > davem@davemloft.net; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
> > 
> > On Thu, Nov 19, 2020 at 06:29:31PM +0200, Camelia Groza wrote:
> > > Implement the XDP_DROP and XDP_PASS actions.
> > >
> > > Avoid draining and reconfiguring the buffer pool at each XDP
> > > setup/teardown by increasing the frame headroom and reserving
> > > XDP_PACKET_HEADROOM bytes from the start. Since we always reserve
> > an
> > > entire page per buffer, this change only impacts Jumbo frame scenarios
> > > where the maximum linear frame size is reduced by 256 bytes. Multi
> > > buffer Scatter/Gather frames are now used instead in these scenarios.
> > >
> > > Allow XDP programs to access the entire buffer.
> > >
> > > The data in the received frame's headroom can be overwritten by the XDP
> > > program. Extract the relevant fields from the headroom while they are
> > > still available, before running the XDP program.
> > >
> > > Since the headroom might be resized before the frame is passed up to the
> > > stack, remove the check for a fixed headroom value when building an skb.
> > >
> > > Allow the meta data to be updated and pass the information up the stack.
> > >
> > > Scatter/Gather frames are dropped when XDP is enabled.
> > >
> > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > > ---
> > > Changes in v2:
> > > - warn only once if extracting the timestamp from a received frame fails
> > >
> > > Changes in v3:
> > > - drop received S/G frames when XDP is enabled
> > >
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 158
> > ++++++++++++++++++++++---
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> > >  2 files changed, 144 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > index 88533a2..102023c 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > @@ -53,6 +53,8 @@
> > >  #include <linux/dma-mapping.h>
> > >  #include <linux/sort.h>
> > >  #include <linux/phy_fixed.h>
> > > +#include <linux/bpf.h>
> > > +#include <linux/bpf_trace.h>
> > >  #include <soc/fsl/bman.h>
> > >  #include <soc/fsl/qman.h>
> > >  #include "fman.h"
> > > @@ -177,7 +179,7 @@
> > >  #define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE +
> > DPAA_TIME_STAMP_SIZE \
> > >  		       + DPAA_HASH_RESULTS_SIZE)
> > >  #define DPAA_RX_PRIV_DATA_DEFAULT_SIZE
> > (DPAA_TX_PRIV_DATA_SIZE + \
> > > -					dpaa_rx_extra_headroom)
> > > +					XDP_PACKET_HEADROOM -
> > DPAA_HWA_SIZE)
> > >  #ifdef CONFIG_DPAA_ERRATUM_A050385
> > >  #define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN -
> > DPAA_HWA_SIZE)
> > >  #define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> > > @@ -1733,7 +1735,6 @@ static struct sk_buff *contig_fd_to_skb(const
> > struct dpaa_priv *priv,
> > >  			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> > >  	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
> > >  		goto free_buffer;
> > > -	WARN_ON(fd_off != priv->rx_headroom);
> > >  	skb_reserve(skb, fd_off);
> > >  	skb_put(skb, qm_fd_get_length(fd));
> > >
> > > @@ -2349,12 +2350,62 @@ static enum qman_cb_dqrr_result
> > rx_error_dqrr(struct qman_portal *portal,
> > >  	return qman_cb_dqrr_consume;
> > >  }
> > >
> > > +static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void
> > *vaddr,
> > > +			unsigned int *xdp_meta_len)
> > > +{
> > > +	ssize_t fd_off = qm_fd_get_offset(fd);
> > > +	struct bpf_prog *xdp_prog;
> > > +	struct xdp_buff xdp;
> > > +	u32 xdp_act;
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	xdp_prog = READ_ONCE(priv->xdp_prog);
> > > +	if (!xdp_prog) {
> > > +		rcu_read_unlock();
> > > +		return XDP_PASS;
> > > +	}
> > > +
> > > +	xdp.data = vaddr + fd_off;
> > 
> > I feel like a little drawing of xdp_buff layout would help me with
> > understanding what is going on over here :)
> 
> A region at the start of the buffer is reserved for storing hardware annotations and room for the XDP_PACKET_HEADROOM, before the actual data starts. So vaddr points to the start of the buffer, while fd offset provides the offset of the data inside the buffer. I don't feel that we are filling the xdp_buff in a majorly different way from other drivers, so please mention what is unclear here and I can provide more details.

Okay, so fd_off tells me where the frame starts, from vaddr to vaddr +
fd_off there might be some HW provided data, so you extract it and then
you are free to go with setting the data_hard_start?

> 
> > > +	xdp.data_meta = xdp.data;
> > > +	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
> > > +	xdp.data_end = xdp.data + qm_fd_get_length(fd);
> > > +	xdp.frame_sz = DPAA_BP_RAW_SIZE;
> > 
> > Maybe you could fill xdp_buff outside of this function so that later on
> > you could set xdp.rxq once per napi?
> 
> I admit I haven't looked into exactly how much performance we would gain from this, but I don't think it would be enough to justify the code churn. We don't have a clean loop for processing the received frames like I see the Intel and ENA drivers have.
> 
> > > +
> > > +	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > +
> > > +	/* Update the length and the offset of the FD */
> > > +	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end - xdp.data);
> > > +
> > > +	switch (xdp_act) {
> > > +	case XDP_PASS:
> > > +		*xdp_meta_len = xdp.data - xdp.data_meta;
> > > +		break;
> > > +	default:
> > > +		bpf_warn_invalid_xdp_action(xdp_act);
> > > +		fallthrough;
> > > +	case XDP_ABORTED:
> > > +		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
> > > +		fallthrough;
> > > +	case XDP_DROP:
> > > +		/* Free the buffer */
> > > +		free_pages((unsigned long)vaddr, 0);
> > > +		break;
> > > +	}
> > > +
> > > +	rcu_read_unlock();
> > > +
> > > +	return xdp_act;
> > > +}
> > > +
> > >  static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal
> > *portal,
> > >  						struct qman_fq *fq,
> > >  						const struct qm_dqrr_entry
> > *dq,
> > >  						bool sched_napi)
> > >  {
> > > +	bool ts_valid = false, hash_valid = false;
> > >  	struct skb_shared_hwtstamps *shhwtstamps;
> > > +	unsigned int skb_len, xdp_meta_len = 0;
> > >  	struct rtnl_link_stats64 *percpu_stats;
> > >  	struct dpaa_percpu_priv *percpu_priv;
> > >  	const struct qm_fd *fd = &dq->fd;
> > > @@ -2362,12 +2413,14 @@ static enum qman_cb_dqrr_result
> > rx_default_dqrr(struct qman_portal *portal,
> > >  	enum qm_fd_format fd_format;
> > >  	struct net_device *net_dev;
> > >  	u32 fd_status, hash_offset;
> > > +	struct qm_sg_entry *sgt;
> > >  	struct dpaa_bp *dpaa_bp;
> > >  	struct dpaa_priv *priv;
> > > -	unsigned int skb_len;
> > >  	struct sk_buff *skb;
> > >  	int *count_ptr;
> > > +	u32 xdp_act;
> > >  	void *vaddr;
> > > +	u32 hash;
> > >  	u64 ns;
> > >
> > >  	fd_status = be32_to_cpu(fd->status);
> > > @@ -2423,35 +2476,67 @@ static enum qman_cb_dqrr_result
> > rx_default_dqrr(struct qman_portal *portal,
> > >  	count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
> > >  	(*count_ptr)--;
> > >
> > > -	if (likely(fd_format == qm_fd_contig))
> > > +	/* Extract the timestamp stored in the headroom before running
> > XDP */
> > > +	if (priv->rx_tstamp) {
> > > +		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> > &ns))
> > > +			ts_valid = true;
> > > +		else
> > > +			WARN_ONCE(1, "fman_port_get_tstamp failed!\n");
> > > +	}
> > > +
> > > +	/* Extract the hash stored in the headroom before running XDP */
> > > +	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> > &&
> > > +	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > > +					      &hash_offset)) {
> > > +		hash = be32_to_cpu(*(u32 *)(vaddr + hash_offset));
> > > +		hash_valid = true;
> > > +	}
> > > +
> > > +	if (likely(fd_format == qm_fd_contig)) {
> > > +		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > > +				       &xdp_meta_len);
> > > +		if (xdp_act != XDP_PASS) {
> > > +			percpu_stats->rx_packets++;
> > > +			percpu_stats->rx_bytes += qm_fd_get_length(fd);
> > > +			return qman_cb_dqrr_consume;
> > > +		}
> > >  		skb = contig_fd_to_skb(priv, fd);
> > > -	else
> > > +	} else {
> > > +		/* XDP doesn't support S/G frames. Return the fragments to
> > the
> > > +		 * buffer pool and release the SGT.
> > > +		 */
> > > +		if (READ_ONCE(priv->xdp_prog)) {
> > > +			WARN_ONCE(1, "S/G frames not supported under
> > XDP\n");
> > > +			sgt = vaddr + qm_fd_get_offset(fd);
> > > +			dpaa_release_sgt_members(sgt);
> > > +			free_pages((unsigned long)vaddr, 0);
> > > +			return qman_cb_dqrr_consume;
> > > +		}
> > >  		skb = sg_fd_to_skb(priv, fd);
> > > +	}
> > >  	if (!skb)
> > >  		return qman_cb_dqrr_consume;
> > >
> > > -	if (priv->rx_tstamp) {
> > > +	if (xdp_meta_len)
> > > +		skb_metadata_set(skb, xdp_meta_len);
> > 
> > This is working on a single buffer, right? So there's no need to clear
> > xdp_meta_len?
> 
> I don't think I understand what you mean. Are you saying I shouldn't be initializing xdp_meta_len to 0? This receive path is used when XDP is disabled as well, in which case we don't propagate the metadata.

What I meant was that if this function would operate on many buffers then
we would have to clear the xdp_meta_len, so that next buffers wouldn't get
the value from previous bufs, but I suppose that this rx_default_dqrr
callback is called once per each buffer.

> 
> > > +
> > > +	/* Set the previously extracted timestamp */
> > > +	if (ts_valid) {
> > >  		shhwtstamps = skb_hwtstamps(skb);
> > >  		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> > > -
> > > -		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> > &ns))
> > > -			shhwtstamps->hwtstamp = ns_to_ktime(ns);
> > > -		else
> > > -			dev_warn(net_dev->dev.parent,
> > "fman_port_get_tstamp failed!\n");
> > > +		shhwtstamps->hwtstamp = ns_to_ktime(ns);
> > >  	}
> > >
> > >  	skb->protocol = eth_type_trans(skb, net_dev);
> > >
> > > -	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> > &&
> > > -	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > > -					      &hash_offset)) {
> > > +	/* Set the previously extracted hash */
> > > +	if (hash_valid) {
> > >  		enum pkt_hash_types type;
> > >
> > >  		/* if L4 exists, it was used in the hash generation */
> > >  		type = be32_to_cpu(fd->status) & FM_FD_STAT_L4CV ?
> > >  			PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
> > > -		skb_set_hash(skb, be32_to_cpu(*(u32 *)(vaddr +
> > hash_offset)),
> > > -			     type);
> > > +		skb_set_hash(skb, hash, type);
> > >  	}
> > >
> > >  	skb_len = skb->len;
> > > @@ -2671,6 +2756,46 @@ static int dpaa_eth_stop(struct net_device
> > *net_dev)
> > >  	return err;
> > >  }
