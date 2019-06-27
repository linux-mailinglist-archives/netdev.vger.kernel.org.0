Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3613C58D6A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF0V4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:56:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:41498 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0V4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:56:01 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcN3-0002N0-8A; Thu, 27 Jun 2019 23:55:57 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcN3-000CxQ-2W; Thu, 27 Jun 2019 23:55:57 +0200
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
Message-ID: <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net>
Date:   Thu, 27 Jun 2019 23:55:56 +0200
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

Overall series looks good to me. Just very small things inline here & in the
other two patches:

[...]
> @@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  
> -	if (unlikely(flags))
> +	/* Lower bits of the flags are used as return code on lookup failure */
> +	if (unlikely(flags > XDP_TX))
>  		return XDP_ABORTED;
>  
> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
> +	if (unlikely(!ri->item)) {
> +		WRITE_ONCE(ri->map, NULL);

This WRITE_ONCE() is not needed. We never set it before at this point.

> +		return flags;
> +	}
> +
>  	ri->ifindex = ifindex;
>  	ri->flags = flags;
>  	WRITE_ONCE(ri->map, map);
> 

