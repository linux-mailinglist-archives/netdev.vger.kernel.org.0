Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A82E7201
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgL2PyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 10:54:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:41034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgL2PyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 10:54:08 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kuHJN-0005zA-3p; Tue, 29 Dec 2020 16:53:25 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kuHJM-0008IW-Rb; Tue, 29 Dec 2020 16:53:24 +0100
Subject: Re: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        alexander.duyck@gmail.com, maciej.fijalkowski@intel.com,
        saeed@kernel.org
References: <cover.1608670965.git.lorenzo@kernel.org>
 <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <63bcde67-4124-121d-e96a-066493542ca9@iogearbox.net>
Date:   Tue, 29 Dec 2020 16:53:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26032/Tue Dec 29 13:42:39 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/20 10:09 PM, Lorenzo Bianconi wrote:
> Introduce xdp_prepare_buff utility routine to initialize per-descriptor
> xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff() in
> all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Overall looks good to me, just one small nit in the Intel drivers below (cc Maciej):

[...]
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index a87fb8264d0c..2574e78f7597 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2406,12 +2406,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>   
>   		/* retrieve a buffer from the ring */
>   		if (!skb) {
> -			xdp.data = page_address(rx_buffer->page) +
> -				   rx_buffer->page_offset;
> -			xdp.data_meta = xdp.data;
> -			xdp.data_hard_start = xdp.data -
> -					      i40e_rx_offset(rx_ring);
> -			xdp.data_end = xdp.data + size;
> +			unsigned int offset = i40e_rx_offset(rx_ring);
> +			unsigned char *hard_start;
> +
> +			hard_start = page_address(rx_buffer->page) +
> +				     rx_buffer->page_offset - offset;
> +			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>   #if (PAGE_SIZE > 4096)
>   			/* At larger PAGE_SIZE, frame_sz depend on len size */
>   			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 500e93bf6238..422f53997c02 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -1104,8 +1104,10 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
>   
>   	/* start the loop to process Rx packets bounded by 'budget' */
>   	while (likely(total_rx_pkts < (unsigned int)budget)) {
> +		unsigned int offset = ice_rx_offset(rx_ring);
>   		union ice_32b_rx_flex_desc *rx_desc;
>   		struct ice_rx_buf *rx_buf;
> +		unsigned char *hard_start;
>   		struct sk_buff *skb;
>   		unsigned int size;
>   		u16 stat_err_bits;
> @@ -1151,10 +1153,9 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
>   			goto construct_skb;
>   		}
>   
> -		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
> -		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
> -		xdp.data_meta = xdp.data;
> -		xdp.data_end = xdp.data + size;
> +		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
> +			     offset;
> +		xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>   #if (PAGE_SIZE > 4096)
>   		/* At larger PAGE_SIZE, frame_sz depend on len size */
>   		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index cf9e8b7d2c70..6b5adbd9660b 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8715,12 +8715,12 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
>   
>   		/* retrieve a buffer from the ring */
>   		if (!skb) {
> -			xdp.data = page_address(rx_buffer->page) +
> -				   rx_buffer->page_offset;
> -			xdp.data_meta = xdp.data;
> -			xdp.data_hard_start = xdp.data -
> -					      igb_rx_offset(rx_ring);
> -			xdp.data_end = xdp.data + size;
> +			unsigned int offset = igb_rx_offset(rx_ring);
> +			unsigned char *hard_start;
> +
> +			hard_start = page_address(rx_buffer->page) +
> +				     rx_buffer->page_offset - offset;
> +			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>   #if (PAGE_SIZE > 4096)
>   			/* At larger PAGE_SIZE, frame_sz depend on len size */
>   			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 7ec196589a07..e714db51701a 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2335,12 +2335,12 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>   
>   		/* retrieve a buffer from the ring */
>   		if (!skb) {
> -			xdp.data = page_address(rx_buffer->page) +
> -				   rx_buffer->page_offset;
> -			xdp.data_meta = xdp.data;
> -			xdp.data_hard_start = xdp.data -
> -					      ixgbe_rx_offset(rx_ring);
> -			xdp.data_end = xdp.data + size;
> +			unsigned int offset = ixgbe_rx_offset(rx_ring);
> +			unsigned char *hard_start;
> +
> +			hard_start = page_address(rx_buffer->page) +
> +				     rx_buffer->page_offset - offset;
> +			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>   #if (PAGE_SIZE > 4096)
>   			/* At larger PAGE_SIZE, frame_sz depend on len size */
>   			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 624efcd71569..a534a3fb392e 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -1160,12 +1160,12 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
>   
>   		/* retrieve a buffer from the ring */
>   		if (!skb) {
> -			xdp.data = page_address(rx_buffer->page) +
> -				   rx_buffer->page_offset;
> -			xdp.data_meta = xdp.data;
> -			xdp.data_hard_start = xdp.data -
> -					      ixgbevf_rx_offset(rx_ring);
> -			xdp.data_end = xdp.data + size;
> +			unsigned int offset = ixgbevf_rx_offset(rx_ring);
> +			unsigned char *hard_start;
> +
> +			hard_start = page_address(rx_buffer->page) +
> +				     rx_buffer->page_offset - offset;
> +			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>   #if (PAGE_SIZE > 4096)
>   			/* At larger PAGE_SIZE, frame_sz depend on len size */
>   			xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);
[...]
The design is very similar for most of the Intel drivers. Why the inconsistency on
ice driver compared to the rest, what's the rationale there to do it in one but not
the others? Generated code better there?

Couldn't you even move the 'unsigned int offset = xyz_rx_offset(rx_ring)' out of the
while loop altogether for all of them? (You already use the xyz_rx_offset() implicitly
for most of them when setting xdp.frame_sz.)

Thanks,
Daniel
