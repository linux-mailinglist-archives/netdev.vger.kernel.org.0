Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D712C768B
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 00:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgK1XJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 18:09:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:15231 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgK1XJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 18:09:08 -0500
IronPort-SDR: 4rcOzIbt/gET7ykJZWl6bYgdgdyz6nVqxIpjlZ3agNmILXhjvIceyLnt4v600e8rBMDLuPVMZc
 WnBHvJ69in7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="257211976"
X-IronPort-AV: E=Sophos;i="5.78,378,1599548400"; 
   d="scan'208";a="257211976"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2020 15:08:28 -0800
IronPort-SDR: GPK8y4h90HD0JQkZweoWEDCErSOpc98QCUwxuhx8eayXqRd2DyMWdUgrGUghbWbQqNFA5sHmHV
 Ru5UNXrxSJYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,378,1599548400"; 
   d="scan'208";a="363622230"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 28 Nov 2020 15:08:26 -0800
Date:   Sat, 28 Nov 2020 23:59:57 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] dpaa_eth: add XDP support
Message-ID: <20201128225957.GA45349@ranger.igk.intel.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1606322126.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 06:53:29PM +0200, Camelia Groza wrote:
> Enable XDP support for the QorIQ DPAA1 platforms.
> 
> Implement all the current actions (DROP, ABORTED, PASS, TX, REDIRECT). No
> Tx batching is added at this time.
> 
> Additional XDP_PACKET_HEADROOM bytes are reserved in each frame's headroom.
> 
> After transmit, a reference to the xdp_frame is saved in the buffer for
> clean-up on confirmation in a newly created structure for software
> annotations. DPAA_TX_PRIV_DATA_SIZE bytes are reserved in the buffer for
> storing this structure and the XDP program is restricted from accessing
> them.
> 
> The driver shares the egress frame queues used for XDP with the network
> stack. The DPAA driver is a LLTX driver so no explicit locking is required
> on transmission.
> 
> Changes in v2:
> - warn only once if extracting the timestamp from a received frame fails
>   in 2/7
> 
> Changes in v3:
> - drop received S/G frames when XDP is enabled in 2/7
> 
> Changes in v4:
> - report a warning if the MTU is too hight for running XDP in 2/7
> - report an error if opening the device fails in the XDP setup in 2/7
> - call xdp_rxq_info_is_reg() before unregistering in 4/7
> - minor cleanups (remove unneeded variable, print error code) in 4/7
> - add more details in the commit message in 4/7
> - did not call qman_destroy_fq() in case of xdp_rxq_info_reg() failure
> since it would lead to a double free of the fq resources in 4/7
> 
> Changes in v5:
> - report errors on XDP setup with extack in 2/7
> - checkpath fix in 4/7
> - add more details in the commit message in 4/7
> - reduce the impact of the A050385 erratum workaround code on non-erratum
> platforms in 7/7

For the series:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Camelia Groza (7):
>   dpaa_eth: add struct for software backpointers
>   dpaa_eth: add basic XDP support
>   dpaa_eth: limit the possible MTU range when XDP is enabled
>   dpaa_eth: add XDP_TX support
>   dpaa_eth: add XDP_REDIRECT support
>   dpaa_eth: rename current skb A050385 erratum workaround
>   dpaa_eth: implement the A050385 erratum workaround for XDP
> 
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 465 +++++++++++++++++++++++--
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  13 +
>  2 files changed, 448 insertions(+), 30 deletions(-)
> 
> --
> 1.9.1
> 
