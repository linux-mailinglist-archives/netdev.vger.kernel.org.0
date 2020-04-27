Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011621BAD74
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgD0TBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:01:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:49884 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgD0TBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 15:01:22 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT90G-0003P7-EC; Mon, 27 Apr 2020 21:01:16 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT90F-0003c7-SB; Mon, 27 Apr 2020 21:01:15 +0200
Subject: Re: [PATCH net-next 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
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
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757178840.1370371.13037637865133257416.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <940b8c06-b71f-f6b1-4832-4abc58027589@iogearbox.net>
Date:   Mon, 27 Apr 2020 21:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158757178840.1370371.13037637865133257416.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 6:09 PM, Jesper Dangaard Brouer wrote:
> Finally, after all drivers have a frame size, allow BPF-helper
> bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.
> 
> Remember that helper/macro xdp_data_hard_end have reserved some
> tailroom.  Thus, this helper makes sure that the BPF-prog don't have
> access to this tailroom area.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/uapi/linux/bpf.h |    4 ++--
>   net/core/filter.c        |   15 +++++++++++++--
>   2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2e29a671d67e..0e5abe991ca3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1969,8 +1969,8 @@ union bpf_attr {
>    * int bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
>    * 	Description
>    * 		Adjust (move) *xdp_md*\ **->data_end** by *delta* bytes. It is
> - * 		only possible to shrink the packet as of this writing,
> - * 		therefore *delta* must be a negative integer.
> + * 		possible to both shrink and grow the packet tail.
> + * 		Shrink done via *delta* being a negative integer.
>    *
>    * 		A call to this helper is susceptible to change the underlying
>    * 		packet buffer. Therefore, at load time, all checks on pointers
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7d6ceaa54d21..5e9c387f74eb 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3422,12 +3422,23 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>   
>   BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>   {
> +	void *data_hard_end = xdp_data_hard_end(xdp);
>   	void *data_end = xdp->data_end + offset;
>   
> -	/* only shrinking is allowed for now. */
> -	if (unlikely(offset >= 0))
> +	/* Notice that xdp_data_hard_end have reserved some tailroom */
> +	if (unlikely(data_end > data_hard_end))
>   		return -EINVAL;
>   
> +	/* ALL drivers MUST init xdp->frame_sz, some chicken checks below */
> +	if (unlikely(xdp->frame_sz < (xdp->data_end - xdp->data_hard_start))) {
> +		WARN(1, "Too small xdp->frame_sz = %d\n", xdp->frame_sz);
> +		return -EINVAL;
> +	}
> +	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
> +		WARN(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
> +		return -EINVAL;
> +	}

I don't think we can add the WARN()s here. If there is a bug in the driver in this
area and someone deploys an XDP-based application (otherwise known to work well
elsewhere) on top of this, then an attacker can basically remote DoS the machine
with malicious packets that end up triggering these WARN()s over and over.

If you are worried that not all your driver changes are correct, maybe only add
those that you were able to actually test yourself or that have been acked, and
otherwise pre-init the frame_sz to a known invalid value so this helper would only
allow shrinking for them in here (as today)?

Thanks,
Daniel

>   	if (unlikely(data_end < xdp->data + ETH_HLEN))
>   		return -EINVAL;
>   
> 
> 

