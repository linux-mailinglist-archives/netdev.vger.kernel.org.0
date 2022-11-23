Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5706365FF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbiKWQmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbiKWQmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:42:17 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A39BF5B0;
        Wed, 23 Nov 2022 08:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669221735; x=1700757735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eR+hV87Imw9gI40kRAx0evPGGNFSlbCYKi23jBS+FNs=;
  b=GTKMAbAyiCol/OXtkoBess1QW0CJUQJT8SfXTXQKLkOruJdrKj5jAVm6
   P8kJ/aR1SI7QL8u9E5G5LWLF5VOw3ugNT5GXsHTdT+gDwQTwVGcBk1xTs
   6WcQWHJXkYpX/TtPWJlkaYEYVROBpk9CDNvMqnp7CT+CdciJKiW2I16wY
   /kiVN/jCHy9oAOyvn3TjKWBE+nuzaAv0qW0BLfdO9HuTdj0PMJLona3+w
   9ZBDmApledx+K31gskGdTf8jEwSEKdckcQr6VqyeQkWUPlfDshBd0Baxr
   3u9XdUN7nwBOPYYDDDU6yK8Zh6w4aBquP2ChobqKPeBoxa5XMPCPuc73Y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="312807034"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312807034"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:42:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747860442"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747860442"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 08:42:13 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANGgCAi013285;
        Wed, 23 Nov 2022 16:42:12 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] bnxt: Use generic HBH removal helper in tx path
Date:   Wed, 23 Nov 2022 17:41:59 +0100
Message-Id: <20221123164159.485728-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122232740.3180560-2-lixiaoyan@google.com>
References: <20221122232740.3180560-1-lixiaoyan@google.com> <20221122232740.3180560-2-lixiaoyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>
Date: Tue, 22 Nov 2022 15:27:40 -0800

> Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> for IPv6 traffic. See patch series:
> 'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
> 
> This reduces the number of packets traversing the networking stack and
> should usually improves performance. However, it also inserts a
> temporary Hop-by-hop IPv6 extension header.
> 
> Using the HBH header removal method in the previous path, the extra header
> be removed in bnxt drivers to allow it to send big TCP packets (bigger
> TSO packets) as well.
> 
> If bnxt folks could help with testing this patch on the driver (as I
> don't have access to one) that would be wonderful. Thank you!
> 
> Tested:
> Compiled locally

Please mark "potential" patches with 'RFC'. Then, if/when you get a
'Tested-by:', you can spin a "true" v1.

> 
> To further test functional correctness, update the GSO/GRO limit on the
> physical NIC:
> 
> ip link set eth0 gso_max_size 181000
> ip link set eth0 gro_max_size 181000
> 
> Note that if there are bonding or ipvan devices on top of the physical
> NIC, their GSO sizes need to be updated as well.
> 
> Then, IPv6/TCP packets with sizes larger than 64k can be observed.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 0fe164b42c5d..2bfa5e9fb179 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  			return NETDEV_TX_BUSY;
>  	}
>  
> +	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> +		goto tx_free;
> +
>  	length = skb->len;
>  	len = skb_headlen(skb);
>  	last_frag = skb_shinfo(skb)->nr_frags;
> @@ -13657,6 +13660,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev->features &= ~NETIF_F_LRO;
>  	dev->priv_flags |= IFF_UNICAST_FLT;
>  
> +	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
>  #ifdef CONFIG_BNXT_SRIOV
>  	init_waitqueue_head(&bp->sriov_cfg_wait);
>  #endif
> -- 
> 2.38.1.584.g0f3c55d4c2-goog

Thanks,
Olek
