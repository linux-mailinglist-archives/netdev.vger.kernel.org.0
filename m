Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF31A27FB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 19:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgDHRcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 13:32:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:17604 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbgDHRcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 13:32:05 -0400
IronPort-SDR: Ar5yCnsXzK7BFPqgHi24XNxjqm40ZNsFMaY0qnCXFZtxPZ6nK99vwla5MwI2WNjbeYW322Q7c7
 tGQLCgFghPgg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 10:32:04 -0700
IronPort-SDR: 2I538bWVfJfLlF/ZOfIMcxUOCMMdomDh4bmOAqpFBpzjUODcD4SrUFpnnaTu8bU9Q6QyDz7GRj
 K6q4iMC2tuaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,359,1580803200"; 
   d="scan'208";a="286617958"
Received: from hrotuna-mobl.ti.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.246])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2020 10:31:59 -0700
Subject: Re: [PATCH RFC v2 28/33] xdp: for Intel AF_XDP drivers add XDP
 frame_sz
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     intel-wired-lan@lists.osuosl.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634677661.707275.17823370564281193008.stgit@firesoul>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <55b6684d-9097-e2c1-c939-bf3273bd70f6@intel.com>
Date:   Wed, 8 Apr 2020 19:31:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <158634677661.707275.17823370564281193008.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-08 13:52, Jesper Dangaard Brouer wrote:
> Intel drivers implement native AF_XDP zerocopy in separate C-files,
> that have its own invocation of bpf_prog_run_xdp(). The setup of
> xdp_buff is also handled in separately from normal code path.
> 
> This patch update XDP frame_sz for AF_XDP zerocopy drivers i40e, ice
> and ixgbe, as the code changes needed are very similar.  Introduce a
> helper function xsk_umem_xdp_frame_sz() for calculating frame size.
> 
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: Björn Töpel <bjorn.topel@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for the patch, Jesper! Note that mlx5 has AF_XDP support as well,
and might need similar changes. Adding Max for input!

For the Intel drivers, and core AF_XDP:
Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c   |    2 ++
>   drivers/net/ethernet/intel/ice/ice_xsk.c     |    2 ++
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c |    2 ++
>   include/net/xdp_sock.h                       |   11 +++++++++++
>   4 files changed, 17 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 0b7d29192b2c..2b9184aead5f 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -531,12 +531,14 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>   {
>   	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>   	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
> +	struct xdp_umem *umem = rx_ring->xsk_umem;
>   	unsigned int xdp_res, xdp_xmit = 0;
>   	bool failure = false;
>   	struct sk_buff *skb;
>   	struct xdp_buff xdp;
>   
>   	xdp.rxq = &rx_ring->xdp_rxq;
> +	xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>   
>   	while (likely(total_rx_packets < (unsigned int)budget)) {
>   		struct i40e_rx_buffer *bi;
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 8279db15e870..23e5515d4527 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -840,11 +840,13 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
>   {
>   	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>   	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
> +	struct xdp_umem *umem = rx_ring->xsk_umem;
>   	unsigned int xdp_xmit = 0;
>   	bool failure = false;
>   	struct xdp_buff xdp;
>   
>   	xdp.rxq = &rx_ring->xdp_rxq;
> +	xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>   
>   	while (likely(total_rx_packets < (unsigned int)budget)) {
>   		union ice_32b_rx_flex_desc *rx_desc;
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index 74b540ebb3dc..a656ee9a1fae 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -431,12 +431,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>   	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>   	struct ixgbe_adapter *adapter = q_vector->adapter;
>   	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
> +	struct xdp_umem *umem = rx_ring->xsk_umem;
>   	unsigned int xdp_res, xdp_xmit = 0;
>   	bool failure = false;
>   	struct sk_buff *skb;
>   	struct xdp_buff xdp;
>   
>   	xdp.rxq = &rx_ring->xdp_rxq;
> +	xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>   
>   	while (likely(total_rx_packets < budget)) {
>   		union ixgbe_adv_rx_desc *rx_desc;
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index e86ec48ef627..1cd1ec3cea97 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -237,6 +237,12 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
>   	else
>   		return address + offset;
>   }
> +
> +static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
> +{
> +	return umem->chunk_size_nohr + umem->headroom;
> +}
> +
>   #else
>   static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   {
> @@ -367,6 +373,11 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
>   	return 0;
>   }
>   
> +static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
> +{
> +	return 0;
> +}
> +
>   static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
>   {
>   	return -EOPNOTSUPP;
> 
> 
