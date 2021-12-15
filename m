Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63160475DAD
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244893AbhLOQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhLOQks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:40:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ABAC061574;
        Wed, 15 Dec 2021 08:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C6B7B8201E;
        Wed, 15 Dec 2021 16:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E064AC36AE3;
        Wed, 15 Dec 2021 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639586446;
        bh=SX0OrCxVumA1tCRQnY9OBElu2TNIeelB2MX6iLzch1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EJqZAbpsBWw5B8ZRKYd5Y5EZA4vn6LZCwRchReyc3VzOpjMtMt7FzaODVwCJ8hBWP
         Xr8HYP2J7qLD7mei2bZxiXAs+xmC6CSLB7jSCwN90cwauFNLnA7NydTcoMpdkiE88M
         nSF+z9cjTQAge+yV54jgZO1XtqImgpqS4QiUVo4mZMA7BhWmKNj5Jtae75CdO9EOvL
         UobCss4x8ODAfmfk/CC+lJSh56MiRdcm1efWWZsTf1y9nCRdB9VBJw71XazXwz+enk
         CjFv5/AMMe+EM9d31ApiqLF/4TT3YrQmwFrsnFJQo5N0PsV5igNIGRim7KOR1saUor
         XG+YQNKzKqtjA==
Date:   Wed, 15 Dec 2021 08:40:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Message-ID: <20211215084044.064e6861@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 14:49:18 +0000 Pavel Begunkov wrote:
> +static inline bool
> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
> +				 enum cgroup_bpf_attach_type type)
> +{
> +	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
> +
> +	return array == &bpf_empty_prog_array.hdr;
> +}
> +
> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> +({									       \
> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
> +									       \
> +	!__cgroup_bpf_prog_array_is_empty(&__cgrp->bpf, (atype));	       \
> +})
> +

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index e7a163a3146b..0d2195c6fb2a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1161,6 +1161,19 @@ struct bpf_prog_array {
>  	struct bpf_prog_array_item items[];
>  };
>  
> +struct bpf_empty_prog_array {
> +	struct bpf_prog_array hdr;
> +	struct bpf_prog *null_prog;
> +};
> +
> +/* to avoid allocating empty bpf_prog_array for cgroups that
> + * don't have bpf program attached use one global 'bpf_empty_prog_array'
> + * It will not be modified the caller of bpf_prog_array_alloc()
> + * (since caller requested prog_cnt == 0)
> + * that pointer should be 'freed' by bpf_prog_array_free()
> + */
> +extern struct bpf_empty_prog_array bpf_empty_prog_array;

mumble mumble, this adds more "fun" dependencies [1] Maybe I'm going
about this all wrong, maybe I should be pulling out struct cgroup_bpf
so that cgroup.h does not need bpf-cgroup, not breaking bpf <-> bpf-cgroup.
Alexei, WDYT?

[1] https://lore.kernel.org/all/20211215061916.715513-2-kuba@kernel.org/
