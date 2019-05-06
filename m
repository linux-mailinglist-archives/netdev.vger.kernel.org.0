Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3639414627
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfEFI0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:26:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:53696 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfEFI0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:26:04 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNYwj-0002PO-FG; Mon, 06 May 2019 10:26:01 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNYwj-000Tq4-93; Mon, 06 May 2019 10:26:01 +0200
Subject: Re: [PATCH bpf 1/2] libbpf: fix invalid munmap call
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, u9012063@gmail.com
References: <20190430124536.7734-1-bjorn.topel@gmail.com>
 <20190430124536.7734-2-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <20aaa3f5-fd93-9773-ca8a-40809e9dc981@iogearbox.net>
Date:   Mon, 6 May 2019 10:26:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190430124536.7734-2-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25440/Sun May  5 10:04:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/30/2019 02:45 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> When unmapping the AF_XDP memory regions used for the rings, an
> invalid address was passed to the munmap() calls. Instead of passing
> the beginning of the memory region, the descriptor region was passed
> to munmap.
> 
> When the userspace application tried to tear down an AF_XDP socket,
> the operation failed and the application would still have a reference
> to socket it wished to get rid of.
> 
> Reported-by: William Tu <u9012063@gmail.com>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
[...]
>  out_mmap_tx:
>  	if (tx)
> -		munmap(xsk->tx,
> -		       off.tx.desc +
> +		munmap(tx_map, off.tx.desc +
>  		       xsk->config.tx_size * sizeof(struct xdp_desc));
>  out_mmap_rx:
>  	if (rx)
> -		munmap(xsk->rx,
> -		       off.rx.desc +
> +		munmap(rx_map, off.rx.desc +
>  		       xsk->config.rx_size * sizeof(struct xdp_desc));
>  out_socket:
>  	if (--umem->refcount)
> @@ -684,10 +681,12 @@ int xsk_umem__delete(struct xsk_umem *umem)
>  	optlen = sizeof(off);
>  	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
>  	if (!err) {
> -		munmap(umem->fill->ring,
> -		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
> -		munmap(umem->comp->ring,
> -		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
> +		(void)munmap(umem->fill->ring - off.fr.desc,
> +			     off.fr.desc +
> +			     umem->config.fill_size * sizeof(__u64));
> +		(void)munmap(umem->comp->ring - off.cr.desc,
> +			     off.cr.desc +
> +			     umem->config.comp_size * sizeof(__u64));

What's the rationale to cast to void here and other places (e.g. below)?
If there's no proper reason, then lets remove it. Given the patch has already
been applied, please send a follow up. Thanks.

>  	}
>  
>  	close(umem->fd);
> @@ -698,6 +697,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
>  
>  void xsk_socket__delete(struct xsk_socket *xsk)
>  {
> +	size_t desc_sz = sizeof(struct xdp_desc);
>  	struct xdp_mmap_offsets off;
>  	socklen_t optlen;
>  	int err;
> @@ -710,14 +710,17 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>  	optlen = sizeof(off);
>  	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
>  	if (!err) {
> -		if (xsk->rx)
> -			munmap(xsk->rx->ring,
> -			       off.rx.desc +
> -			       xsk->config.rx_size * sizeof(struct xdp_desc));
> -		if (xsk->tx)
> -			munmap(xsk->tx->ring,
> -			       off.tx.desc +
> -			       xsk->config.tx_size * sizeof(struct xdp_desc));
> +		if (xsk->rx) {
> +			(void)munmap(xsk->rx->ring - off.rx.desc,
> +				     off.rx.desc +
> +				     xsk->config.rx_size * desc_sz);
> +		}
> +		if (xsk->tx) {
> +			(void)munmap(xsk->tx->ring - off.tx.desc,
> +				     off.tx.desc +
> +				     xsk->config.tx_size * desc_sz);
> +		}
> +
>  	}
>  
>  	xsk->umem->refcount--;
> 

