Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711B6D534A
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 01:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfJLXYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 19:24:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39982 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJLXYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 19:24:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id d26so7887229pgl.7;
        Sat, 12 Oct 2019 16:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yUu4uX/YGXLWPr9O636FpYe8iD69UkUp54Dx79SWpig=;
        b=SaWqjjZL/bXZB8w6cTvUNnTMefN1s/RaCw+lhmkrvUbQtL63Fu7XzMxZKEF6Bm/F0L
         tfHFb0nQzNKsBQsAZMmIPO6DicqmWQXhwQGRNLU5HBfCo3qCDIyn5dkJ9hj/+aB9MQgi
         qkLcS3apTo1lKC99qkJgsTtalWsO4J53+78CzoMVnKUNKe6RdtUKwirUmc8eG+2370yf
         ql6yDT7VeJu1+gYu8c+AP1pdbCIPqaQsmVaqB5PwyLwXWkbx8ta30Tn2ftWd2MHlvYrE
         +QJs/NFWExRZB1cqv4S+867HexZlIua/vo7So8/315UkGugTKF0kBKXgfZ5iJJrkUzgv
         AZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yUu4uX/YGXLWPr9O636FpYe8iD69UkUp54Dx79SWpig=;
        b=XMZ9RV/HxPqzAtB9Bkq0xudJPPvV2vWsi1X7bIf9YNeBVPWkc7qXpwgKDdj+kMNLgd
         iFOPke1FNzXlA5UYwSZBtdWyvid52mWtl6deHzMTl2MxqKAQI1R1ig4eT4lnlAkGRdyQ
         u1XD1XNfenyMpr3eyURxRzux++qiY/LTvkuztjEZsFOHQ7d3lO05tan0yh2zVOq2q3Fr
         iF0/HxNnVgGGiPDIgM3f5h2H59h/UR0VZEnsjBiBS+62edDyCT1Hc2tavTTVgqPGgbbs
         MDZ8l3n3Bn/nKSoUu5LOlECvphbGkE6gtEo6rF7cVfY+HHUBleFk2AfNq1DFt0nylrAz
         P6PQ==
X-Gm-Message-State: APjAAAXG+VU+D53645Ka479JFDjS76pW9KIqfrMmyy8MNvfbqx9HrUfQ
        fwmKTZgcMooF/4qyjv41wYw=
X-Google-Smtp-Source: APXvYqw3b0MPezsl/abUZC4G2lePpAZNsResq/IOE7r+aE9896QxDbgmmTwZn56M+V+dSPsLD9LEWQ==
X-Received: by 2002:a63:f908:: with SMTP id h8mr24050277pgi.244.1570922681812;
        Sat, 12 Oct 2019 16:24:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::8e83])
        by smtp.gmail.com with ESMTPSA id o15sm12005203pjs.14.2019.10.12.16.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 16:24:41 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:24:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: fix passing uninitialized bytes to
 setsockopt
Message-ID: <20191012232437.2xpi5mmmv7mxz3yy@ast-mbp.dhcp.thefacebook.com>
References: <5da24d48.1c69fb81.a3069.c817SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5da24d48.1c69fb81.a3069.c817SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 06:49:29PM +0200, Ilya Maximets wrote:
> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
> valgrind complain about passing uninitialized stack memory to the
> syscall:
> 
>   Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>     at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>     by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>   Uninitialised value was created by a stack allocation
>     at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
> 
> Padding bytes appeared after introducing of a new 'flags' field.
> memset() is required to clear them.
> 
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
> 
> Version 2:
>   * Struct initializer replaced with explicit memset(). [Andrii]
> 
>  tools/lib/bpf/xsk.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index a902838f9fcc..9d5348086203 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -163,6 +163,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>  	umem->umem_area = umem_area;
>  	xsk_set_umem_config(&umem->config, usr_config);
>  
> +	memset(&mr, 0, sizeof(mr));
>  	mr.addr = (uintptr_t)umem_area;
>  	mr.len = size;
>  	mr.chunk_size = umem->config.frame_size;

This was already applied. Why did you resend?

