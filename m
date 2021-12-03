Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4F467FA4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383307AbhLCWHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:07:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:38052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383281AbhLCWHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 17:07:53 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mtGfL-000GQn-Uk; Fri, 03 Dec 2021 23:04:27 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mtGfL-000RiK-PZ; Fri, 03 Dec 2021 23:04:27 +0100
Subject: Re: [PATCH v3 net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <cover.1638189075.git.pabeni@redhat.com>
 <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ac2941f-b751-9cf0-f0e3-ea0f245b7503@iogearbox.net>
Date:   Fri, 3 Dec 2021 23:04:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26372/Fri Dec  3 10:24:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

Changes look good to me as well, we can route the series via bpf-next after tree
resync, or alternatively ask David/Jakub to take it directly into net-next with our
Ack given in bpf-next there is no drivers/net/ethernet/microsoft/mana/mana_bpf.c yet.

On 11/30/21 11:08 AM, Paolo Abeni wrote:
[...]> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5631acf3f10c..392838fa7652 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8181,13 +8181,13 @@ static bool xdp_is_valid_access(int off, int size,
>   	return __is_valid_xdp_access(off, size);
>   }
>   
> -void bpf_warn_invalid_xdp_action(u32 act)
> +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
>   {
>   	const u32 act_max = XDP_REDIRECT;
>   
> -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
>   		     act > act_max ? "Illegal" : "Driver unsupported",
> -		     act);
> +		     act, prog->aux->name, prog->aux->id, dev ? dev->name : "");

One tiny nit, but we could fix it up while applying I'd have is that for !dev case
we should probably dump a "<n/a>" or so just to avoid a kernel log message like
"dev , expect packet loss".

>   }
>   EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
>   

Thanks,
Daniel
