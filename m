Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8563B637EA8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiKXRzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiKXRyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:54:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A5C12D39;
        Thu, 24 Nov 2022 09:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669312458; x=1700848458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sXnKN/YXOdlrt4gQi4aLdKbmQKzlc0Sj2MoBA1aMjMg=;
  b=YwyNlSxmNLWmFxuwYCI9dVUAwwQwoe+yLi8a6K4Aqr6kuLg7ur+LjaCv
   YphQQFd3YbRcTjGlW9zN9Iv6+2UTBIXUHQZTS0/xCNX9L3mJf9uR8p2j2
   BauOe3r6wFgBCmGppi8amxLyPOkRux0dcUTsLnKtorqrrowfpOyAt7wI1
   yYp+8Ukf000l2VWu9ZAcEj/2mauXwNZdYze7FR3i7/rMFlgfhhT8VWEeA
   l9C592lYpPjxvBKIYX65C3YbDmfEuoGloqUP9FhD0uKOL3wmxYg1+pjOs
   OgDhNTcU+51HRWhPQUMVzb0Xl+CqDrH2v7rBXqtJrDaLmD5oFFlCEJmbx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="316166681"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="316166681"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 09:54:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="767146960"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="767146960"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 24 Nov 2022 09:54:15 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AOHsDbM003592;
        Thu, 24 Nov 2022 17:54:13 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] net: ethernet: mtk_eth_soc: work around issue with sending small fragments
Date:   Thu, 24 Nov 2022 18:54:10 +0100
Message-Id: <20221124175410.5684-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123095754.36821-3-nbd@nbd.name>
References: <20221123095754.36821-1-nbd@nbd.name> <20221123095754.36821-3-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>
Date: Wed, 23 Nov 2022 10:57:52 +0100

> When frames are sent with very small fragments, the DMA engine appears to
> lock up and transmit attempts time out. Fix this by detecting the presence
> of small fragments and use skb_gso_segment + skb_linearize to deal with
> them

Nit: all of your commit messages don't have a trailing dot (.), not
sure if it's important, but my eye is missing it definitely :D

skb_gso_segment() and skb_linearize() are slow as hell. I think you
can do it differently. I guess only the first (head) and the last
frag can be so small, right?

So, if a frag from shinfo->frags is less than 16, get a new frag of
the minimum acceptable size via netdev_alloc_frag(), copy the data
to it and pad the rest with zeroes. Then increase skb->len and
skb->data_len, skb_frag_unref() the current, "invalid" frag and
replace the pointer to the new frag. I didn't miss anything I
believe... Zero padding the tail is usual thing for NICs. skb frag
substitution is less common, but should be legit.

If skb_headlen() is less than 16, try doing pskb_may_pull() +
__skb_pull() at first. The argument would be `16 - headlen`. If
pskb_may_pull() returns false, then yeah, you have no choice other
than segmenting and linearizing ._.

> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)

[...]

>  	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
>  		netif_tx_stop_all_queues(dev);
> -- 
> 2.38.1

Thanks,
Olek
