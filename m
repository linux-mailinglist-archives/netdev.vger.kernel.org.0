Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5A228706F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgJHIGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:06:51 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35656 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgJHIGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602144409; x=1633680409;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=bg3O7qEGH1fNCK+zQ+U6E2nWrjAtawJmaEIw/54CrhU=;
  b=fYQ5l0P700TOncHISyku0k7RlBKOfqFnqfhJ9Fz3nfKAdxFjyBg2fI45
   fHuhN6+SMLdNDjtGxVlrir1VpbeIQ0PTZ3Ff9/MyDieg6jjLaG44URgac
   BYMrWVMmq/vEdaSxcO/81Zz4dB/tl6DN14nCYFoiFcIiByhyPPmpI1dAS
   4=;
X-IronPort-AV: E=Sophos;i="5.77,350,1596499200"; 
   d="scan'208";a="82535724"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 08 Oct 2020 08:06:43 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 3A62DA1F3D;
        Thu,  8 Oct 2020 08:06:39 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.231) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Oct 2020 08:06:33 +0000
References: <cover.1601648734.git.lorenzo@kernel.org>
 <d6ed575afaf89fc35e233af5ccd063da944b4a3a.1601648734.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <sameehj@amazon.com>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <lorenzo.bianconi@redhat.com>,
        <echaudro@redhat.com>
Subject: Re: [PATCH v4 bpf-next 09/13] bpf: introduce multibuff support to
 bpf_prog_test_run_xdp()
In-Reply-To: <d6ed575afaf89fc35e233af5ccd063da944b4a3a.1601648734.git.lorenzo@kernel.org>
Date:   Thu, 8 Oct 2020 11:06:14 +0300
Message-ID: <pj41zl362puop5.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.231]
X-ClientProxiedBy: EX13D01UWB002.ant.amazon.com (10.43.161.136) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce the capability to allocate a xdp multi-buff in
> bpf_prog_test_run_xdp routine. This is a preliminary patch to 
> introduce
> the selftests for new xdp multi-buff ebpf helpers
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/bpf/test_run.c | 51 
>  ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index bd291f5f539c..ec7286cd051b 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -617,44 +617,79 @@ int bpf_prog_test_run_xdp(struct bpf_prog 
> *prog, const union bpf_attr *kattr,
>  {
>  	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct 
>  skb_shared_info));
>  	u32 headroom = XDP_PACKET_HEADROOM;
> -	u32 size = kattr->test.data_size_in;
>  	u32 repeat = kattr->test.repeat;
>  	struct netdev_rx_queue *rxqueue;
> +	struct skb_shared_info *sinfo;
>  	struct xdp_buff xdp = {};
> +	u32 max_data_sz, size;
>  	u32 retval, duration;
> -	u32 max_data_sz;
> +	int i, ret, data_len;
>  	void *data;
> -	int ret;
>  
>  	if (kattr->test.ctx_in || kattr->test.ctx_out)
>  		return -EINVAL;
>  
> -	/* XDP have extra tailroom as (most) drivers use full page 
> */
>  	max_data_sz = 4096 - headroom - tailroom;

For the sake of consistency, can this 4096 be changed to PAGE_SIZE 
?
Same as in
     data_len = min_t(int, kattr->test.data_size_in - size, 
     PAGE_SIZE);

expression below

> +	size = min_t(u32, kattr->test.data_size_in, max_data_sz);
> +	data_len = size;
>  
> -	data = bpf_test_init(kattr, kattr->test.data_size_in,
> -			     max_data_sz, headroom, tailroom);
> +	data = bpf_test_init(kattr, size, max_data_sz, headroom, 
> tailroom);
>  	if (IS_ERR(data))
>  		return PTR_ERR(data);
>  
>  	xdp.data_hard_start = data;
>  	xdp.data = data + headroom;
>  	xdp.data_meta = xdp.data;
> -	xdp.data_end = xdp.data + size;
> +	xdp.data_end = xdp.data + data_len;
>  	xdp.frame_sz = headroom + max_data_sz + tailroom;
>  
> +	sinfo = xdp_get_shared_info_from_buff(&xdp);
> +	if (unlikely(kattr->test.data_size_in > size)) {
> +		void __user *data_in = 
> u64_to_user_ptr(kattr->test.data_in);
> +
> +		while (size < kattr->test.data_size_in) {
> +			skb_frag_t *frag = 
> &sinfo->frags[sinfo->nr_frags];
> +			struct page *page;
> +			int data_len;
> +
> +			page = alloc_page(GFP_KERNEL);
> +			if (!page) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +
> +			__skb_frag_set_page(frag, page);
> +			data_len = min_t(int, 
> kattr->test.data_size_in - size,
> +					 PAGE_SIZE);
> +			skb_frag_size_set(frag, data_len);
> +			if (copy_from_user(page_address(page), 
> data_in + size,
> +					   data_len)) {
> +				ret = -EFAULT;
> +				goto out;
> +			}
> +			sinfo->nr_frags++;
> +			size += data_len;
> +		}
> +		xdp.mb = 1;
> +	}
> +
>  	rxqueue = 
>  __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 
>  0);
>  	xdp.rxq = &rxqueue->xdp_rxq;
>  	bpf_prog_change_xdp(NULL, prog);
>  	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, 
>  true);
>  	if (ret)
>  		goto out;
> +
>  	if (xdp.data != data + headroom || xdp.data_end != 
>  xdp.data + size)
> -		size = xdp.data_end - xdp.data;
> +		size += xdp.data_end - xdp.data - data_len;

Can we please drop the variable shadowing of data_len ? This is 
confusing since the initial value of data_len is correct in the 
`size` calculation, while its value inside the while loop it not.

This seem to be syntactically correct, but I think it's better 
practice to avoid shadowing here.

> +
>  	ret = bpf_test_finish(kattr, uattr, xdp.data, size, 
>  retval, duration);
>  out:
>  	bpf_prog_change_xdp(prog, NULL);
> +	for (i = 0; i < sinfo->nr_frags; i++)
> +		__free_page(skb_frag_page(&sinfo->frags[i]));
>  	kfree(data);
> +
>  	return ret;
>  }

