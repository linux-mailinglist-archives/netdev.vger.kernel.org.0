Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4743A619A46
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiKDOkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiKDOkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:40:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52972197;
        Fri,  4 Nov 2022 07:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572703; x=1699108703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Qz6/3spwrqUoYTSX0DPgHA9Qlrgln4MaaCK1iydmAI=;
  b=PoivtNennRl7Fiy8cScE7Fa7ICr82I76maqEH9TbQWH/zguXIVdxZrOI
   Py94i4mllP6IwpTGA5EQv+QwMhxWn9WV2xOLWz/3widJa8N6xAbP9ebfr
   utgRgrRTlLUg7MeFslbdDnxAUoHsJdzy0lGOdVnl5Q/QHNo80iluEEV0s
   vhA582cLmfOBrXmIB1As1P+zxfLdYD9+dFgTBonX1SHuSnwTZWRZk7l7J
   +GzdYHJ0jUHd1NKzwYD6br3nyfUaY5lVuICV1++1l5mkM4VIS691FASsQ
   xJXKzDT7s1MDxLyOH8/Fg9bmBldTP3HFTCIR5gEHnTFEdN7zMVgqYv1kF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372087137"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="372087137"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="704101828"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="704101828"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 04 Nov 2022 07:38:19 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A4EcHMF021328;
        Fri, 4 Nov 2022 14:38:17 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next v2 10/14] ice: Support rx timestamp metadata for xdp
Date:   Fri,  4 Nov 2022 15:35:47 +0100
Message-Id: <20221104143547.3575615-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104032532.1615099-11-sdf@google.com>
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-11-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>
Date: Thu,3 Nov 2022 20:25:28 -0700

> COMPILE-TESTED ONLY!
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  5 ++
>  drivers/net/ethernet/intel/ice/ice_main.c |  1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 75 +++++++++++++++++++++++
>  3 files changed, 81 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index f88ee051e71c..c51a392d64a4 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -925,6 +925,11 @@ int ice_open_internal(struct net_device *netdev);
>  int ice_stop(struct net_device *netdev);
>  void ice_service_task_schedule(struct ice_pf *pf);
>  
> +struct bpf_insn;
> +struct bpf_patch;
> +void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> +		      struct bpf_patch *patch);
> +
>  /**
>   * ice_set_rdma_cap - enable RDMA support
>   * @pf: PF struct
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 1f27dc20b4f1..8ddc6851ef86 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -9109,4 +9109,5 @@ static const struct net_device_ops ice_netdev_ops = {
>  	.ndo_xdp_xmit = ice_xdp_xmit,
>  	.ndo_xsk_wakeup = ice_xsk_wakeup,
>  	.ndo_get_devlink_port = ice_get_devlink_port,
> +	.ndo_unroll_kfunc = ice_unroll_kfunc,
>  };
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 1b6afa168501..e9b5e883753e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -7,6 +7,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/prefetch.h>
>  #include <linux/bpf_trace.h>
> +#include <linux/bpf_patch.h>
>  #include <net/dsfield.h>
>  #include <net/mpls.h>
>  #include <net/xdp.h>
> @@ -1098,8 +1099,80 @@ ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
>  
>  struct ice_xdp_buff {
>  	struct xdp_buff xdp;
> +	struct ice_rx_ring *rx_ring;
> +	union ice_32b_rx_flex_desc *rx_desc;
>  };
>  
> +void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> +		      struct bpf_patch *patch)
> +{
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
> +		return xdp_metadata_export_to_skb(prog, patch);

Hey,

FYI, our team wants to write a follow-up patch with ice support
added, not like a draft, more of a mature code. I'm thinking of
calling ice C function which would process Rx descriptors from
that BPF code from the unrolling callback -- otherwise,
implementing a couple hundred C code lines from ice_txrx_lib.c
would be a bit too much :D

> +	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> +		/* return true; */
> +		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> +	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {

[...]

> -- 
> 2.38.1.431.g37b22c650d-goog

Thanks,
Olek
