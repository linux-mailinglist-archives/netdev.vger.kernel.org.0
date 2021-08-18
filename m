Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F3D3F0E1E
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhHRWZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:25:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:57914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhHRWZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 18:25:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mGTzG-000657-Ck; Thu, 19 Aug 2021 00:24:42 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mGTzG-0000BQ-75; Thu, 19 Aug 2021 00:24:42 +0200
Subject: Re: [PATCH bpf-next v2 2/2] bpf: use kvmalloc for map keys in
 syscalls
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org
References: <20210817154556.92901-1-sdf@google.com>
 <20210817154556.92901-2-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <afd42427-f424-5f0d-360c-5fcdfc078704@iogearbox.net>
Date:   Thu, 19 Aug 2021 00:24:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210817154556.92901-2-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26267/Wed Aug 18 10:21:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 5:45 PM, Stanislav Fomichev wrote:
> Same as previous patch but for the keys. memdup_bpfptr is renamed
> to vmemdup_bpfptr (and converted to kvmalloc).
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   include/linux/bpfptr.h | 12 ++++++++++--
>   kernel/bpf/syscall.c   | 34 +++++++++++++++++-----------------
>   2 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> index 5cdeab497cb3..84eeffb4316a 100644
> --- a/include/linux/bpfptr.h
> +++ b/include/linux/bpfptr.h
> @@ -62,9 +62,17 @@ static inline int copy_to_bpfptr_offset(bpfptr_t dst, size_t offset,
>   	return copy_to_sockptr_offset((sockptr_t) dst, offset, src, size);
>   }
>   
> -static inline void *memdup_bpfptr(bpfptr_t src, size_t len)
> +static inline void *vmemdup_bpfptr(bpfptr_t src, size_t len)

nit: should we just name it kvmemdup_bpfptr() in that case?

>   {
> -	return memdup_sockptr((sockptr_t) src, len);
> +	void *p = kvmalloc(len, GFP_USER | __GFP_NOWARN);
> +
> +	if (!p)
> +		return ERR_PTR(-ENOMEM);
> +	if (copy_from_sockptr(p, (sockptr_t) src, len)) {

Also, I think this one should rather use copy_from_bpfptr() here.

> +		kvfree(p);
> +		return ERR_PTR(-EFAULT);
> +	}
> +	return p;
>   }
>   

Rest lgtm, thanks!
