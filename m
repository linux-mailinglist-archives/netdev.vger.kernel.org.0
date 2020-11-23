Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034812C1861
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgKWW0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:26:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:7229 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgKWW0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:26:21 -0500
IronPort-SDR: EXAqgrpY8tV9uBNEZAl8aEW/iR9bAoq3W6LIzqJ+wTPO1q0bZOnQaF+/Y7EuYTaxf7EsUacBGf
 qUjeaOe+0Rdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="171952300"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="171952300"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:26:21 -0800
IronPort-SDR: T7H7VH0fn/Tv/cyYv/fj8+Wdu9oXHncX/bnNsx1wtW8MAUHpDf9ZNtc3g/3dWdxhZF65h9O0QN
 A18E6sLQq4bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="361622958"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2020 14:26:18 -0800
Date:   Mon, 23 Nov 2020 23:18:29 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
Message-ID: <20201123221829.GC11618@ranger.igk.intel.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <aa8bbb5c404f57fdb7915eb236305a177800becb.1605802951.git.camelia.groza@nxp.com>
 <20201119235034.GA24983@ranger.igk.intel.com>
 <VI1PR04MB5807F56500D25ECD20657618F2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5807F56500D25ECD20657618F2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:54:42PM +0000, Camelia Alexandra Groza wrote:
> > -----Original Message-----
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Friday, November 20, 2020 01:51
> > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > davem@davemloft.net; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
> > 
> > On Thu, Nov 19, 2020 at 06:29:33PM +0200, Camelia Groza wrote:
> > > Use an xdp_frame structure for managing the frame. Store a backpointer
> > to
> > > the structure at the start of the buffer before enqueueing. Use the XDP
> > > API for freeing the buffer when it returns to the driver on the TX
> > > confirmation path.
> > 

[...]

> > >  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void
> > *vaddr,
> > > -			unsigned int *xdp_meta_len)
> > > +			struct dpaa_fq *dpaa_fq, unsigned int
> > *xdp_meta_len)
> > >  {
> > >  	ssize_t fd_off = qm_fd_get_offset(fd);
> > >  	struct bpf_prog *xdp_prog;
> > > +	struct xdp_frame *xdpf;
> > >  	struct xdp_buff xdp;
> > >  	u32 xdp_act;
> > >
> > > @@ -2370,7 +2470,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> > struct qm_fd *fd, void *vaddr,
> > >  	xdp.data_meta = xdp.data;
> > >  	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
> > >  	xdp.data_end = xdp.data + qm_fd_get_length(fd);
> > > -	xdp.frame_sz = DPAA_BP_RAW_SIZE;
> > > +	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > +	xdp.rxq = &dpaa_fq->xdp_rxq;
> > >
> > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > >
> > > @@ -2381,6 +2482,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> > struct qm_fd *fd, void *vaddr,
> > >  	case XDP_PASS:
> > >  		*xdp_meta_len = xdp.data - xdp.data_meta;
> > >  		break;
> > > +	case XDP_TX:
> > > +		/* We can access the full headroom when sending the frame
> > > +		 * back out
> > 
> > And normally why a piece of headroom is taken away? I probably should
> > have
> > started from the basic XDP support patch, but if you don't mind, please
> > explain it a bit.
> 
> I mentioned we require DPAA_TX_PRIV_DATA_SIZE bytes at the start of the buffer in order to make sure we have enough space for our private info.

What is your private info?

> 
> When setting up the xdp_buff, this area is reserved from the frame size exposed to the XDP program.
>  -	xdp.frame_sz = DPAA_BP_RAW_SIZE;
>  +	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> 
> After the XDP_TX verdict, we're sure that DPAA_TX_PRIV_DATA_SIZE bytes at the start of the buffer are free and we can use the full headroom how it suits us, hence the increase of the frame size back to DPAA_BP_RAW_SIZE.

Not at the *end* of the buffer?

> 
> Thanks for all your feedback.
> 
> > > +		 */
> > > +		xdp.data_hard_start = vaddr;
> > > +		xdp.frame_sz = DPAA_BP_RAW_SIZE;
> > > +		xdpf = xdp_convert_buff_to_frame(&xdp);
> > > +		if (unlikely(!xdpf)) {
> > > +			free_pages((unsigned long)vaddr, 0);
> > > +			break;
> > > +		}
> > > +
> > > +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> > > +			xdp_return_frame_rx_napi(xdpf);
> > > +
> > > +		break;
> > >  	default:
> > >  		bpf_warn_invalid_xdp_action(xdp_act);
> > >  		fallthrough;
> > > @@ -2415,6 +2532,7 @@ static enum qman_cb_dqrr_result
