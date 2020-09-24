Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9398E2778D3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgIXS6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgIXS6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:58:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38DBC0613CE;
        Thu, 24 Sep 2020 11:58:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id s13so106849wmh.4;
        Thu, 24 Sep 2020 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=whVWU1G0Rf6aOrTmjuAQq7Qed/+App25DvdLdv5TIOw=;
        b=J5VvsV6T+xNuTTn6TFx5ulvFBfEGLwV/KpEmgJ8YRi1ld3sMbflUlCvxVE6+TiTGVL
         N4iM3HIQcRLhPz/4teEybKkwcbZaxVUdWz5UwwxO5Jv1UZ5tEmcdXXa6KXOEE39qzeYZ
         ikvxYdetFLNAapEc1HBknUF4lduRE9PFILnHqr6IrwwgXalcjkGkcs/wA/uO9UdO1ltg
         3VPmanQtPT3yPN5i4pRcIYnUsVeq4Hsd3YP9vanuL8yfcQAlcCkF2NpN4PnNl+NRBPl0
         3OxUzi4K7uWJktsNCk4hDokD4AvnZY8bU3frkCUsPqTono8PsXwh5En8tbDzXoOTNhDl
         NQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=whVWU1G0Rf6aOrTmjuAQq7Qed/+App25DvdLdv5TIOw=;
        b=mNQf1zyubDW5V0wcX8dBL/hsaDO/fr58GFimoiUYwUT1aXD/tc1Hf3OPjVDZV37b3b
         53sRUMDCHp777TBwbCYhf7EPfjXBUCjhkcYf9NbJz7AwohW73rZUYw5fTKrM+FShdT++
         fbCpJ9alZbTwwA6ddWA11DVDQgDDqs3KQXhiyI4SkLaJj9sum728vrm5bph42hdjhOOq
         CBRg2UZ0gMvgo5S+u8dd+DaT5gyEVwlKi40ijM5I15oe34L37RD6I0tfw0LZCM3ekrIA
         bZs5gYAhrbggNcrX7Uig/K4RHyxogPxm0UrCPS/tUSTzuCnslgxeUactoIHNv15qpI/d
         y17Q==
X-Gm-Message-State: AOAM530N5e2iUnTjxbiDclL+pgHLjKMbXh3OX7seq16eyQufPDXVbKiq
        qQliuQmvulnOPaIbjJN6K/dYoa6gUk4=
X-Google-Smtp-Source: ABdhPJy5pDn2aAO5m6cClMO/dZT0eGyg4CWDTAlV7V3sEahSsNSFr2c24eAdg5CQ1/zNYuDpeyIYKA==
X-Received: by 2002:a7b:c095:: with SMTP id r21mr82558wmh.133.1600973932150;
        Thu, 24 Sep 2020 11:58:52 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.124.168])
        by smtp.gmail.com with ESMTPSA id n4sm61340wrp.61.2020.09.24.11.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 11:58:51 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu
 one
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
Date:   Thu, 24 Sep 2020 20:58:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/20 8:21 PM, Daniel Borkmann wrote:
> With its use in BPF the cookie generator can be called very frequently
> in particular when used out of cgroup v2 hooks (e.g. connect / sendmsg)
> and attached to the root cgroup, for example, when used in v1/v2 mixed
> environments. In particular when there's a high churn on sockets in the
> system there can be many parallel requests to the bpf_get_socket_cookie()
> and bpf_get_netns_cookie() helpers which then cause contention on the
> shared atomic counter. As similarly done in f991bd2e1421 ("fs: introduce
> a per-cpu last_ino allocator"), add a small helper library that both can
> then use for the 64 bit counters.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/cookie.h   | 41 ++++++++++++++++++++++++++++++++++++++++
>  net/core/net_namespace.c |  5 +++--
>  net/core/sock_diag.c     |  7 ++++---
>  3 files changed, 48 insertions(+), 5 deletions(-)
>  create mode 100644 include/linux/cookie.h
> 
> diff --git a/include/linux/cookie.h b/include/linux/cookie.h
> new file mode 100644
> index 000000000000..2488203dc004
> --- /dev/null
> +++ b/include/linux/cookie.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __LINUX_COOKIE_H
> +#define __LINUX_COOKIE_H
> +
> +#include <linux/atomic.h>
> +#include <linux/percpu.h>
> +
> +struct gen_cookie {
> +	u64 __percpu	*local_last;
> +	atomic64_t	 shared_last ____cacheline_aligned_in_smp;
> +};
> +
> +#define COOKIE_LOCAL_BATCH	4096
> +
> +#define DEFINE_COOKIE(name)					\
> +	static DEFINE_PER_CPU(u64, __##name);			\
> +	static struct gen_cookie name = {			\
> +		.local_last	= &__##name,			\
> +		.shared_last	= ATOMIC64_INIT(0),		\
> +	}
> +
> +static inline u64 gen_cookie_next(struct gen_cookie *gc)
> +{
> +	u64 *local_last = &get_cpu_var(*gc->local_last);
> +	u64 val = *local_last;
> +
> +	if (__is_defined(CONFIG_SMP) &&
> +	    unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
> +		s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
> +					       &gc->shared_last);
> +		val = next - COOKIE_LOCAL_BATCH;
> +	}
> +	val++;
> +	if (unlikely(!val))
> +		val++;
> +	*local_last = val;
> +	put_cpu_var(local_last);
> +	return val;


This is not interrupt safe.

I think sock_gen_cookie() can be called from interrupt context.

get_next_ino() is only called from process context, that is what I used get_cpu_var()
and put_cpu_var()

