Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB2A4EACC4
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiC2MBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 08:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiC2MBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 08:01:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C7860D2;
        Tue, 29 Mar 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648555206; x=1680091206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W97RVxU6FU90i0ZBblRp2YTYj4F8zwDfNEJUFaHimOo=;
  b=Ety0D08o2tcaUYk42I5sF+JjazLsmlty2GVvu+VqZ65OSfGpllfr/TCH
   h1cRiWEL83YjYGbpdQlaR09p3FPQqgxjUKj/q1pZBUSCQpORvs9CrRPQt
   WXhmt/kswSTvP52dQPIdFGS8o5nHxJ/2bSR09nUMs8N+YAjEwi+40mhNA
   B8AhuswPCckgyd+/qF3VSg5as0GYHVt+7v16JYF2MUN+KFDpklOth8228
   S7cHZYrcO61l7S8rW1gLCmaEDB7xKcQyvtVQmggu5/b0ey3UyP5dPKcjW
   aqFlkc0OYXjVCgfYSY0qth2tJ7JPK9wqGJtF7feXZ1oYgGTZffkivK6kr
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="284130650"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="284130650"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 05:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="604737288"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 29 Mar 2022 05:00:01 -0700
Date:   Tue, 29 Mar 2022 14:00:01 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix logic of getting XSK pool associated with
 Tx queue
Message-ID: <YkL0wfgyCq5s8vdu@boxer>
References: <20220329102752.1481125-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329102752.1481125-1-ivecera@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 12:27:51PM +0200, Ivan Vecera wrote:
> Function ice_tx_xsk_pool() used to get XSK buffer pool associated
> with XDP Tx queue returns NULL when number of ordinary Tx queues
> is not equal to num_possible_cpus().
> 
> The function computes XDP Tx queue ID as an expression
> `ring->q_index - vsi->num_xdp_txq` but this is wrong because
> XDP Tx queues are placed after ordinary ones so the correct
> formula is `ring->q_index - vsi->alloc_txq`.
> 
> Prior commit 792b2086584f ("ice: fix vsi->txq_map sizing") number
> of XDP Tx queues was equal to number of ordinary Tx queues so
> the bug in mentioned function was hidden.
> 
> Reproducer:
> host# ethtool -L ens7f0 combined 1
> host# ./xdpsock -i ens7f0 -q 0 -t -N
> samples/bpf/xdpsock_user.c:kick_tx:794: errno: 6/"No such device or address"
> 
>  sock0@ens7f0:0 txonly xdp-drv
>                 pps         pkts        0.00
> rx              0           0
> tx              0           0
> 
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Fixes: 792b2086584f ("ice: fix vsi->txq_map sizing")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Thanks for this fix! I did exactly the same patch yesterday and it's
already applied to bpf tree:

https://lore.kernel.org/bpf/20220328142123.170157-5-maciej.fijalkowski@intel.com/T/#u

Maciej

> ---
>  drivers/net/ethernet/intel/ice/ice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index b0b27bfcd7a2..d4f1874df7d0 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -710,7 +710,7 @@ static inline struct xsk_buff_pool *ice_tx_xsk_pool(struct ice_tx_ring *ring)
>  	struct ice_vsi *vsi = ring->vsi;
>  	u16 qid;
>  
> -	qid = ring->q_index - vsi->num_xdp_txq;
> +	qid = ring->q_index - vsi->alloc_txq;
>  
>  	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
>  		return NULL;
> -- 
> 2.34.1
> 
