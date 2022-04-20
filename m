Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2950862C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377757AbiDTKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352448AbiDTKnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:43:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0875F101F0;
        Wed, 20 Apr 2022 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650451259; x=1681987259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=potqXVYX3OmiIRlmNKrPcjYJve3h2E3TfCZOfajoLII=;
  b=jRQLXEFE7O+xbTplljjZhrYH6m+bRiOATr4uKMlPQKjbLHdw+F38WDcC
   fuv7VNv1BFe3uedHKJ/+mOtkC/5htYOwRbUmUuluGlIpgUkdpztZOtIp9
   wMM+k+Wn1vPYL/CLRq/++62LGlcuaEp4JCV7T6pVTXdhlG/GNVuw26oO6
   Z8Me8DOlZuea+oW8XrGhR0m+DbPZ4G4ciE38aMvwS6eKsPQ3wtJqiNvTU
   Hv//Qh87AvlyE5c3+CvYaOI05K1HRAkfJwCqEBYFkSrC3aAKmQOW+tHtn
   TXiUvgJO1qxCDSehwR3SZ1rt8/PosqQpBCKilHvRtWdi/hI9vZn1CuvZ5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="350445387"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="350445387"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 03:40:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="555142556"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2022 03:40:55 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23KAer2s026937;
        Wed, 20 Apr 2022 11:40:53 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jeff Evanson <jeff.evanson@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH 1/2] Fix race in igc_xdp_xmit_zc
Date:   Wed, 20 Apr 2022 12:37:08 +0200
Message-Id: <20220420103708.1841070-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415210421.11217-1-jeff.evanson@qsc.com>
References: <20220415210421.11217-1-jeff.evanson@qsc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Evanson <jeff.evanson@gmail.com>
Date: Fri, 15 Apr 2022 15:04:21 -0600

> in igc_xdp_xmit_zc, initialize next_to_use while holding the netif_tx_lock
> to prevent racing with other users of the tx ring
> 
> Signed-off-by: Jeff Evanson <jeff.evanson@qsc.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 1c00ee310c19..a36a18c84aeb 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -2598,7 +2598,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
>  	struct netdev_queue *nq = txring_txq(ring);
>  	union igc_adv_tx_desc *tx_desc = NULL;
>  	int cpu = smp_processor_id();
> -	u16 ntu = ring->next_to_use;
> +	u16 ntu;

Please don't break the RCT (reverse christmas tree) style here. You
should move it to the bottom of the declaration block, ideally
combine it with the declaration of @budget as they're both u16s.

>  	struct xdp_desc xdp_desc;
>  	u16 budget;
>  
> @@ -2607,6 +2607,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
>  
>  	__netif_tx_lock(nq, cpu);
>  
> +	ntu = ring->next_to_use;
> +

There's no need for this empty newline I believe.

>  	budget = igc_desc_unused(ring);
>  
>  	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
> -- 
> 2.17.1

Thanks,
Al
