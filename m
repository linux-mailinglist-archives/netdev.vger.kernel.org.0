Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7662C2EC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbiKPPqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiKPPqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:46:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAD827917;
        Wed, 16 Nov 2022 07:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668613558; x=1700149558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/gkxejWIA7ingIPW/2Fo+kxpItp23dI6rVvmXK6vEs=;
  b=XC08bUuMhTnfnU2IKwr/m0M+YcRuBG0cxPZCEZiXJ7A6KOi0mhySistE
   KVB03LAn6+CZb0Y7998scwIABgw70GZxrzKWdl+7F2waOxr0TdT5uywXi
   tDN7us5xeaM84hQX0IuJrVAuxxvhMqsVUO51jFI2PMiNQyLDmARgwfohO
   yteXm5ZGKbEteO8CLFp2Jjv4pB8CslyyQ9qBjuMOhqEaeZwNSHRJw9L5d
   9rmIHK6+TLBTn+049SfpdSCo+TVc+4mbgLe504M+mKW8IJS2oAeXM34IC
   KARUeIamPL2pyrHr6cWj4AXXvYItX1Ci0iIVd90DE/kGR4+bQToWu9QFp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="311282694"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="311282694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 07:45:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="814125429"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="814125429"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 16 Nov 2022 07:45:55 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGFjstk031345;
        Wed, 16 Nov 2022 15:45:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Date:   Wed, 16 Nov 2022 16:45:28 +0100
Message-Id: <20221116154528.3390307-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115214456.1456856-2-horatiu.vultur@microchip.com>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com> <20221115214456.1456856-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Tue, 15 Nov 2022 22:44:52 +0100

> Update the page_pool params to allocate XDP_PACKET_HEADROOM space as
> headroom for all received frames.
> This is needed for when the XDP_TX and XDP_REDIRECT are implemented.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

[...]

> @@ -466,6 +470,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
>  
>  	skb_mark_for_recycle(skb);
>  
> +	skb_reserve(skb, XDP_PACKET_HEADROOM);

Oh, forgot to ask previously. Just curious, which platforms do
usually have this NIC? Do those platforms have
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS set?
If no, then adding %NET_SKB_PAD to the headroom can significantly
improve performance, as currently you have 28 bytes of IFH + 14
bytes of Eth header, so IP header is not aligned to 4 bytes
boundary. Kernel and other drivers often expect IP header to be
aligned. Adding %NET_SKB_PAD to the headroom addresses that.
...but be careful, I've just realized that you have IFH in front
of Eth header, that means that it will also become unaligned after
that change, so make sure you don't access it with words bigger
than 2 bytes. Just test all the variants and pick the best :D

>  	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
>  
>  	lan966x_ifh_get_timestamp(skb->data, &timestamp);
> @@ -786,7 +791,8 @@ static int lan966x_fdma_get_max_frame(struct lan966x *lan966x)
>  	return lan966x_fdma_get_max_mtu(lan966x) +
>  	       IFH_LEN_BYTES +
>  	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
> -	       VLAN_HLEN * 2;
> +	       VLAN_HLEN * 2 +
> +	       XDP_PACKET_HEADROOM;
>  }

[...]

> -- 
> 2.38.0

Thanks,
Olek
