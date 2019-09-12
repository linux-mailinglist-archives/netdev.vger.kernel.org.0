Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5EB1404
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfILRut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:50:49 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:60522 "EHLO pilot.trilug.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfILRut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 13:50:49 -0400
Received: by pilot.trilug.org (Postfix, from userid 8)
        id 7D32B16983E; Thu, 12 Sep 2019 13:50:46 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on pilot.trilug.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable version=3.3.2
Received: from michaelmarley.com (cpe-2606-A000-BFC0-90-509-B1D3-C76D-19C7.dyn6.twc.com [IPv6:2606:a000:bfc0:90:509:b1d3:c76d:19c7])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id 8CED01697EC;
        Thu, 12 Sep 2019 13:50:44 -0400 (EDT)
Received: from michaelmarley.com (localhost [127.0.0.1])
        by michaelmarley.com (Postfix) with ESMTP id 18E69180170;
        Thu, 12 Sep 2019 13:50:43 -0400 (EDT)
Received: from michaelmarley.com ([::1])
        by michaelmarley.com with ESMTPA
        id ndTdBXOFel1wLAIAnAHMIA
        (envelope-from <michael@michaelmarley.com>); Thu, 12 Sep 2019 13:50:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Sep 2019 13:50:43 -0400
From:   Michael Marley <michael@michaelmarley.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
In-Reply-To: <20190912110144.GS2879@gauss3.secunet.de>
References: <20190912110144.GS2879@gauss3.secunet.de>
User-Agent: Roundcube Webmail/1.4-rc1
Message-ID: <10aeb092a51c85563b37622417de51e3@michaelmarley.com>
X-Sender: michael@michaelmarley.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-12 07:01, Steffen Klassert wrote:
> The ixgbe driver currently does IPsec TX offloading
> based on an existing secpath. However, the secpath
> can also come from the RX side, in this case it is
> misinterpreted for TX offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for TX offload.
> 
> Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
> Reported-by: Michael Marley <michael@michaelmarley.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Tested-by: Michael Marley <michael@michaelmarley.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 9bcae44e9883..ae31bd57127c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -36,6 +36,7 @@
>  #include <net/vxlan.h>
>  #include <net/mpls.h>
>  #include <net/xdp_sock.h>
> +#include <net/xfrm.h>
> 
>  #include "ixgbe.h"
>  #include "ixgbe_common.h"
> @@ -8696,7 +8697,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff 
> *skb,
>  #endif /* IXGBE_FCOE */
> 
>  #ifdef CONFIG_IXGBE_IPSEC
> -	if (secpath_exists(skb) &&
> +	if (xfrm_offload(skb) &&
>  	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
>  		goto out_drop;
>  #endif
