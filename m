Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE9505D96
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347177AbiDRRmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 13:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347173AbiDRRmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 13:42:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37EE633E;
        Mon, 18 Apr 2022 10:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650303593; x=1681839593;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=oXo/QPoLwcbb7sHSUsxAGl9pqn0ndImlQcoCnhT9XcE=;
  b=Op2bTl9dH4y/nE1CvLYBWjbhJO1slGYbWhERYoz2/uC8hpeOsczUA79F
   h4NdbWRf6Oq+pwRfweL2q8x3+XLVeiRaWWIfCuM3uc0Uwm91mPZ4gmfxm
   UfyaH6UAO/KrkQ9hM8EBcyNk2P1Rnw3Chsz7odWnaGi4opaytMQLJHv6u
   PKbc6l776KOg/n/EWSrSgPryPM54PdQhiZmkYOENxpx3BalVgPMzsl5d9
   pMA43f3PkiOOqV1u4/HQA+fTm7AyFgl5Gfx8uZ/ZbSRM1TmJhUHnX29au
   rDQ+CTzieOYN8nLNFxHaflbBN1Pcc4cwZJUWQ5/8lp9Rj1AhFkAMeq4Qy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263036390"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="263036390"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 10:39:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="804370380"
Received: from alanadu-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.251.2.172])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 10:39:49 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jeff Evanson <jeff.evanson@gmail.com>,
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
Cc:     jeff.evanson@qsc.com, jeff.evanson@gmail.com
Subject: Re: [PATCH 1/2] Fix race in igc_xdp_xmit_zc
In-Reply-To: <20220415210421.11217-1-jeff.evanson@qsc.com>
References: <20220415210421.11217-1-jeff.evanson@qsc.com>
Date:   Mon, 18 Apr 2022 13:39:48 -0400
Message-ID: <871qxu5lzv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,

Jeff Evanson <jeff.evanson@gmail.com> writes:

> in igc_xdp_xmit_zc, initialize next_to_use while holding the netif_tx_lock
> to prevent racing with other users of the tx ring

Some style things to change:
 - Some more details on what is the effect of the race condition, and
 perhaps the conditions to reproduce it (what I could imagine is that
 you would need two applications (one using AF_XDP and another one using
 AF_PACKET, for example) sending packets to the same queue.
 - I think this patch is solving a real problem, so directing this patch
 to the net-queue (using 'PATCH net-queue' as subject prefix) would make
 sense.
 - Please add the 'Fixes:' tag so this commit can be applied to any
 stable tree that makes sense.

Apart from those style changes, the code looks good.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

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
>  	struct xdp_desc xdp_desc;
>  	u16 budget;
>  
> @@ -2607,6 +2607,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
>  
>  	__netif_tx_lock(nq, cpu);
>  
> +	ntu = ring->next_to_use;
> +
>  	budget = igc_desc_unused(ring);
>  
>  	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
> -- 
> 2.17.1
>

-- 
Vinicius
