Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02A12FF1C6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388770AbhAURZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:25:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:57783 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388758AbhAURYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:24:44 -0500
IronPort-SDR: rtiQ39BNacDDXYG89UWI7VdiF2QCUFdED8Bu9BQv6Ewd6TxWrs9ExSKqroGKEmO59uf0NuHQ+E
 W/k4N0V4h0ag==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="178527918"
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="178527918"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 09:23:59 -0800
IronPort-SDR: /OujRDvzmBuHXUOqqf+jMYfr6/R1+gaos5+YvGZEXGrFqFw/f5WG8o4e+tdUU3hg0pRvXlmE/l
 WKRkVu7m5R3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="366989002"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 21 Jan 2021 09:23:55 -0800
Date:   Thu, 21 Jan 2021 18:14:23 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Ivan Babrou <ivan@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
Message-ID: <20210121171423.GB44125@ranger.igk.intel.com>
References: <20210120212759.81548-1-ivan@cloudflare.com>
 <20210121181130.77c06723@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121181130.77c06723@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 06:11:30PM +0100, Jesper Dangaard Brouer wrote:
> On Wed, 20 Jan 2021 13:27:59 -0800
> Ivan Babrou <ivan@cloudflare.com> wrote:
> 
> > Without this change the driver tries to allocate too many queues,
> > breaching the number of available msi-x interrupts on machines
> > with many logical cpus and default adapter settings:
> > 
> > Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> > 
> > Which in turn triggers EINVAL on XDP processing:
> > 
> > sfc 0000:86:00.0 ext0: XDP TX failed (-22)

Please mention in commit message *how* you are addressing/fixing this
issue.

> > 
> > Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> > ---
> 
> I guess the patch is good in itself due to available msi-x interrupts.
> 
> Per earlier discussion: What will happen if a CPU with an ID higher
> than available XDP TX-queues redirect a packet out this driver?

+1 on that question

> 
> 
> >  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> > index a4a626e9cd9a..1bfeee283ea9 100644
> > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > @@ -17,6 +17,7 @@
> >  #include "rx_common.h"
> >  #include "nic.h"
> >  #include "sriov.h"
> > +#include "workarounds.h"
> >  
> >  /* This is the first interrupt mode to try out of:
> >   * 0 => MSI-X
> > @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> >  {
> >  	unsigned int n_channels = parallelism;
> >  	int vec_count;
> > +	int tx_per_ev;
> >  	int n_xdp_tx;
> >  	int n_xdp_ev;
> >  
> > @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> >  	 * multiple tx queues, assuming tx and ev queues are both
> >  	 * maximum size.
> >  	 */
> > -
> > +	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
> >  	n_xdp_tx = num_possible_cpus();
> > -	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> > +	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
> >  
> >  	vec_count = pci_msix_vec_count(efx->pci_dev);
> >  	if (vec_count < 0)
> 
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
