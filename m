Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5C13EDF73
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhHPVn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:43:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:58442 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhHPVnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:43:55 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mFkO9-000Gll-NU; Mon, 16 Aug 2021 23:43:21 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mFkO9-0009Js-Ie; Mon, 16 Aug 2021 23:43:21 +0200
Subject: Re: [PATCH bpf-next] bpf: use kvmalloc in map_lookup_elem
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org
References: <20210816164832.1743675-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1b3cb059-9ecb-a0c9-3c99-805788088d09@iogearbox.net>
Date:   Mon, 16 Aug 2021 23:43:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210816164832.1743675-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26265/Mon Aug 16 10:19:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 6:48 PM, Stanislav Fomichev wrote:
> Use kvmalloc/kvfree for temporary value when looking up a map.
> kmalloc might not be sufficient for percpu maps where the value is big.
> 
> Can be reproduced with netcnt test on qemu with "-smp 255".
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   kernel/bpf/syscall.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 9a2068e39d23..ae0b1c1c8ece 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1076,7 +1076,7 @@ static int map_lookup_elem(union bpf_attr *attr)
>   	value_size = bpf_map_value_size(map);
>   
>   	err = -ENOMEM;
> -	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> +	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
>   	if (!value)
>   		goto free_key;

What about other cases like map_update_elem(), shouldn't they be adapted
similarly?

Thanks,
Daniel
