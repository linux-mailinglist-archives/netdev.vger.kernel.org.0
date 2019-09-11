Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CFAAFF22
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfIKOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:50:19 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:38824 "EHLO pilot.trilug.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfIKOuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 10:50:19 -0400
Received: by pilot.trilug.org (Postfix, from userid 8)
        id D6DAF169753; Wed, 11 Sep 2019 10:50:18 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on pilot.trilug.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable version=3.3.2
Received: from michaelmarley.com (cpe-2606-A000-BFC0-90-509-B1D3-C76D-19C7.dyn6.twc.com [IPv6:2606:a000:bfc0:90:509:b1d3:c76d:19c7])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id 5FE9A169748;
        Wed, 11 Sep 2019 10:50:17 -0400 (EDT)
Received: from michaelmarley.com (localhost [127.0.0.1])
        by michaelmarley.com (Postfix) with ESMTP id 63BF218160F;
        Wed, 11 Sep 2019 10:50:16 -0400 (EDT)
Received: from michaelmarley.com ([::1])
        by michaelmarley.com with ESMTPA
        id wR4xGKgJeV3IggEAnAHMIA
        (envelope-from <michael@michaelmarley.com>); Wed, 11 Sep 2019 10:50:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 11 Sep 2019 10:50:16 -0400
From:   Michael Marley <michael@michaelmarley.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
In-Reply-To: <20190911061547.GR2879@gauss3.secunet.de>
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
 <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
 <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
 <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
 <20190911061547.GR2879@gauss3.secunet.de>
User-Agent: Roundcube Webmail/1.4-rc1
Message-ID: <12d6d2313eeb61a51731a2ba9b1fa9bf@michaelmarley.com>
X-Sender: michael@michaelmarley.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-11 02:15, Steffen Klassert wrote:
> On Tue, Sep 10, 2019 at 06:53:30PM -0400, Michael Marley wrote:
>> 
>> StrongSwan has hardware offload disabled by default, and I didn't 
>> enable
>> it explicitly.  I also already tried turning off all those switches 
>> with
>> ethtool and it has no effect.  This doesn't surprise me though, 
>> because
>> as I said, I don't actually have the IPSec connection running over the
>> ixgbe device.  The IPSec connection runs over another network adapter
>> that doesn't support IPSec offload at all.  The problem comes when
>> traffic received over the IPSec interface is then routed back out
>> (unencrypted) through the ixgbe device into the local network.
> 
> 
> Seems like the ixgbe driver tries to use the sec_path
> from RX to setup an offload at the TX side.
> 
> Can you please try this (completely untested) patch?
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
With the patch, the problem is gone.  Thanks!

Michael
