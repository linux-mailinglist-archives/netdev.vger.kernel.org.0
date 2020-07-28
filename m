Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632FE231383
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgG1UHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgG1UHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:07:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327EFC061794;
        Tue, 28 Jul 2020 13:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=cF4fi/YTQLkJLvcc0xwvYdQPbbV5NEC0vNHkk0t1bX4=; b=V+N1ixMSS5zT6glLkEhjrDbYVQ
        S3sGf1NB8Ppdoj3aDQqtBpvhFfLXNE5TS0PfiwiFpKkDLjB/QliG8QqUcsU1paGy7E+qOiIqMEOXH
        /uut7ioNXZNgTmheIVdj+7hr0GgGPnQP+JvyMXQfqQKvkhXo3OF0hkHyjIulwAcQEPxOzCJFGEUET
        3F598TjUkkjzuSLjcuVlYH9btb/DmsnJQIft3XqHaZIsxb2NngSMRDLBBYI6rpDoQen6GAzmAkH9y
        Ek8JcA1KzSf13Y55uoubJdy9Sln0vb0NKRy1SrT1nsmLKM7TLcpDFtCrk0dO+wXCMdWYQ2ojNjZWS
        PB5W3zhg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0VsV-0000kw-Ci; Tue, 28 Jul 2020 20:07:11 +0000
Subject: Re: [PATCH bpf-next] bpf: fix build without CONFIG_NET when using BPF
 XDP link
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200728190527.110830-1-andriin@fb.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <416c8ef6-3459-8710-2eb5-870e2c695ceb@infradead.org>
Date:   Tue, 28 Jul 2020 13:07:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728190527.110830-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 12:05 PM, Andrii Nakryiko wrote:
> Entire net/core subsystem is not built without CONFIG_NET. linux/netdevice.h
> just assumes that it's always there, so the easiest way to fix this is to
> conditionally compile out bpf_xdp_link_attach() use in bpf/syscall.c.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  kernel/bpf/syscall.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0e8c88db7e7a..cd3d599e9e90 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3923,9 +3923,11 @@ static int link_create(union bpf_attr *attr)
>  	case BPF_PROG_TYPE_SK_LOOKUP:
>  		ret = netns_bpf_link_create(attr, prog);
>  		break;
> +#ifdef CONFIG_NET
>  	case BPF_PROG_TYPE_XDP:
>  		ret = bpf_xdp_link_attach(attr, prog);
>  		break;
> +#endif
>  	default:
>  		ret = -EINVAL;
>  	}
> 


-- 
~Randy
