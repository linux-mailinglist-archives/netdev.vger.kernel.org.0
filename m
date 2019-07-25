Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E986D754F8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfGYRAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:00:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:30649 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbfGYRAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 13:00:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 10:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="345497546"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by orsmga005.jf.intel.com with ESMTP; 25 Jul 2019 10:00:43 -0700
Subject: Re: [PATCH bpf-next v3 06/11] mlx5e: modify driver for handling
 offsets
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "Loftus, Ciara" <ciara.loftus@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-7-kevin.laatz@intel.com>
 <c5704b74-8efe-af2a-68e6-716fa89a5665@mellanox.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <4a8bea9e-6b0c-152c-fcbc-6be414a4a324@intel.com>
Date:   Thu, 25 Jul 2019 18:00:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c5704b74-8efe-af2a-68e6-716fa89a5665@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2019 11:15, Maxim Mikityanskiy wrote:
> On 2019-07-24 08:10, Kevin Laatz wrote:
>> With the addition of the unaligned chunks option, we need to make sure we
>> handle the offsets accordingly based on the mode we are currently running
>> in. This patch modifies the driver to appropriately mask the address for
>> each case.
>>
>> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
>>
>> ---
>> v3:
>>     - Use new helper function to handle offset
>> ---
>>    drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 8 ++++++--
>>    drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 9 +++++++--
>>    2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> index b0b982cf69bb..d5245893d2c8 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> @@ -122,6 +122,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>>    		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
>>    {
>>    	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
>> +	struct xdp_umem *umem = rq->umem;
>>    	struct xdp_buff xdp;
>>    	u32 act;
>>    	int err;
>> @@ -138,8 +139,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>>    	xdp.rxq = &rq->xdp_rxq;
>>    
>>    	act = bpf_prog_run_xdp(prog, &xdp);
>> -	if (xsk)
>> -		xdp.handle += xdp.data - xdp.data_hard_start;
>> +	if (xsk) {
>> +		u64 off = xdp.data - xdp.data_hard_start;
>> +
>> +		xdp.handle = xsk_umem_handle_offset(umem, xdp.handle, off);
>> +	}
> What's missed is that umem_headroom is added to handle directly in
> mlx5e_xsk_page_alloc_umem. In my understanding umem_headroom should go
> to the offset part (high 16 bits) of the handle, to
> xsk_umem_handle_offset has to support increasing the offset.

Will look into it and make the changes for the v4

>>    	switch (act) {
>>    	case XDP_PASS:
>>    		*rx_headroom = xdp.data - xdp.data_hard_start;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>> index 35e188cf4ea4..f596e63cba00 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>> @@ -61,6 +61,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
>>    	struct mlx5e_xdp_xmit_data xdptxd;
>>    	bool work_done = true;
>>    	bool flush = false;
>> +	u64 addr, offset;
>>    
>>    	xdpi.mode = MLX5E_XDP_XMIT_MODE_XSK;
>>    
>> @@ -82,8 +83,12 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
>>    			break;
>>    		}
>>    
>> -		xdptxd.dma_addr = xdp_umem_get_dma(umem, desc.addr);
>> -		xdptxd.data = xdp_umem_get_data(umem, desc.addr);
>> +		/* for unaligned chunks need to take offset from upper bits */
>> +		offset = (desc.addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT);
>> +		addr = (desc.addr & XSK_UNALIGNED_BUF_ADDR_MASK);
>> +
>> +		xdptxd.dma_addr = xdp_umem_get_dma(umem, addr + offset);
>> +		xdptxd.data = xdp_umem_get_data(umem, addr + offset);
> Why can't these calculations be encapsulated into
> xdp_umem_get_{dma,data}? I think they are common for all drivers, aren't
> they?
>
> Even if there is some reason not to put this bitshifting stuff into
> xdp_umem_get_* functions, I suggest to encapsulate it into a function
> anyway, because it's a good idea to keep those calculations in a single
> place.
Nice suggestion! I will move it to the xdp_umem_get_* functions in the 
v4. Thanks

