Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0020F798
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgF3Owv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:52:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:35354 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgF3Owu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:52:50 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqHcu-0005YP-Cf; Tue, 30 Jun 2020 16:52:48 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqHcu-000FIn-6D; Tue, 30 Jun 2020 16:52:48 +0200
Subject: Re: [PATCH v2 bpf] bpf: enforce BPF ringbuf size to be the power of 2
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200630061500.1804799-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <285e32b1-daa5-1be4-5939-c86249680311@iogearbox.net>
Date:   Tue, 30 Jun 2020 16:52:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630061500.1804799-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25859/Tue Jun 30 15:38:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 8:15 AM, Andrii Nakryiko wrote:
> BPF ringbuf assumes the size to be a multiple of page size and the power of
> 2 value. The latter is important to avoid division while calculating position
> inside the ring buffer and using (N-1) mask instead. This patch fixes omission
> to enforce power-of-2 size rule.
> 
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Lgtm, applied, thanks!

[...]
> @@ -166,9 +157,16 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
>   		return ERR_PTR(-EINVAL);
>   
>   	if (attr->key_size || attr->value_size ||
> -	    attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> +	    !is_power_of_2(attr->max_entries) ||
> +	    !PAGE_ALIGNED(attr->max_entries))

Technically !IS_ALIGNED(attr->max_entries, PAGE_SIZE) might have been a bit cleaner
since PAGE_ALIGNED() is only intended for pointers, though, not wrong here given
max_entries is u32.

Thanks,
Daniel
