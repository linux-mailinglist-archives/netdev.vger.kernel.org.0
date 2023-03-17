Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66FC6BE924
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCQM0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCQM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:26:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2B65849E;
        Fri, 17 Mar 2023 05:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679055971; x=1710591971;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wwb7QQUYDZ1MGwyahU1bpHx/tV/A7KWGOzAqHD9NCzs=;
  b=LId+y+ItMz0FtogdpnbZyjVxY03kS2FGrv3UEKqm1hYFRtWeN2bhfp7Y
   Te7+31Zk41v0lpCSmHFDwrvj24kjfzDZpMLd6N7ZzT0wCxt6A30oOSqFh
   Pv5ejTB3jLDlC5RKJZXA1YJ5dNR5Jhuod/zlXjmKbXkfzPKKJihxLRQES
   117y2ZKD0S4uJC/Z86FotFzb6o7k1EZRqL/PD5552PeE3uJZRzJeWf1M5
   +xj9bkpR8iUIVvSbC3gudtqjZRv8B+ltXRJXAZblAjO5oSHlYpc6SOVfW
   0qO9d8ubeypWXr8QpHyMLxJrWQdaoVn9D9Mjg9m2/J0wu5VKxual70Rvh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="336948022"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="336948022"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:26:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749242431"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="749242431"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:26:07 -0700
Date:   Fri, 17 Mar 2023 13:26:00 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Message-ID: <ZBRcWLngOPY51qPc@localhost.localdomain>
References: <20230317120815.321871-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317120815.321871-1-noltari@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:08:15PM +0100, Álvaro Fernández Rojas wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
> tag before passing it to the 4-byte tag decoding.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  net/dsa/tag_brcm.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index 10239daa5745..cacdafb41200 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -7,6 +7,7 @@
>  
>  #include <linux/dsa/brcm.h>
>  #include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
>  
> @@ -252,6 +253,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
>  static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
>  					struct net_device *dev)
>  {
> +	int len = BRCM_LEG_TAG_LEN;
>  	int source_port;
>  	u8 *brcm_tag;
>  
> @@ -266,12 +268,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
>  	if (!skb->dev)
>  		return NULL;
>  
> +	/* VLAN tag is added by BCM63xx internal switch */
> +	if (netdev_uses_dsa(skb->dev))
> +		len += VLAN_HLEN;
> +
>  	/* Remove Broadcom tag and update checksum */
> -	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
> +	skb_pull_rcsum(skb, len);
>  
>  	dsa_default_offload_fwd_mark(skb);
>  
> -	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
> +	dsa_strip_etype_header(skb, len);
>  
>  	return skb;
>  }
LGTM, but You can add fixes tag.
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> -- 
> 2.30.2
> 
