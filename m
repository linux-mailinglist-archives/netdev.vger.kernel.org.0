Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A170758DAD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF0WJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:09:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:44190 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfF0WJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:09:05 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcZd-0003sO-M5; Fri, 28 Jun 2019 00:08:57 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcZd-000QBc-Fa; Fri, 28 Jun 2019 00:08:57 +0200
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup
 in eBPF helper
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626136.5209.14349225282974871197.stgit@alrua-x1>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d0d5dbe3-d2bf-2284-b2a3-667c77487125@iogearbox.net>
Date:   Fri, 28 Jun 2019 00:08:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <156125626136.5209.14349225282974871197.stgit@alrua-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The bpf_redirect_map() helper used by XDP programs doesn't return any
> indication of whether it can successfully redirect to the map index it was
> given. Instead, BPF programs have to track this themselves, leading to
> programs using duplicate maps to track which entries are populated in the
> devmap.
> 
> This patch fixes this by moving the map lookup into the bpf_redirect_map()
> helper, which makes it possible to return failure to the eBPF program. The
> lower bits of the flags argument is used as the return code, which means
> that existing users who pass a '0' flag argument will get XDP_ABORTED.
> 
> With this, a BPF program can check the return code from the helper call and
> react by, for instance, substituting a different redirect. This works for
> any type of map used for redirect.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
[...]
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 183bf4d8e301..a6779e1cc1b8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3605,17 +3605,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>  			       struct bpf_redirect_info *ri)
>  {
>  	u32 index = ri->ifindex;
> -	void *fwd = NULL;
> +	void *fwd = ri->item;
>  	int err;
>  
>  	ri->ifindex = 0;
> +	ri->item = NULL;
>  	WRITE_ONCE(ri->map, NULL);
>  
> -	fwd = __xdp_map_lookup_elem(map, index);
> -	if (unlikely(!fwd)) {
> -		err = -EINVAL;
> -		goto err;
> -	}

If you look at the _trace_xdp_redirect{,_err}(), we should also get rid of the
extra NULL test in devmap_ifindex() which is not under tracepoint static key.
