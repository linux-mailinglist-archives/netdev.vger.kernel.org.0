Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24F9124FF7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfLRSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:00:48 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54120 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfLRSAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:00:47 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so1220735pjc.3;
        Wed, 18 Dec 2019 10:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kiwngbDlyS6BqmtksKNN+BZ598T1YrYs4t1Vv+9Myr0=;
        b=PXX5IC8pNhCalJLIgvMQ9SIjzlR018PlQ1JbEVIne4Yth6MZxg9wnUOhvZk4+kIzG+
         iXvs7+qFFDkXdA88vyTomJlu07314xkKI68kpS9xASj1/QuCJJESo2v3zkATraJtaTBJ
         hyo7F1jMQHI0GYkEfVneHAoODvL6efGLeW4554PHsL6z50eoHu+1ty0n6GbwJtWECJCd
         bzzoQc0WeHfTI4o7lwacGN9hlKhLm3Qof8/IhlxVP8EOAfc5T5qRbJCfdiu58Gt14+oc
         /nAFmeSzn2kgd72ZwSqgzFsfMOSTPNw1ojRI7LgTW8odtgukTAW4x+5iIdVGTf9QNMlh
         lw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kiwngbDlyS6BqmtksKNN+BZ598T1YrYs4t1Vv+9Myr0=;
        b=jZ6MIKgQ8hjjivOKhean9xc6o8kpggiosiAVDkYjESFDtOjYg+/KAf6MmhmlJs3ENR
         iNmLR4jX/dXc0rBsw7EYLWQIRcrfuPpVRDBqEZiEijJrCJ9QgBjB1rYUK/7CTVZpxHWd
         QGR5EysC/uqa04In471k0SI2MYNG6FoSGaU4T+5iLZu4Q6BZ7uqHvNxWL2lphZoRE0Xz
         qvgBniptCY/TOfkGVdU89aJVKn0HTVcg0SAoisKTLOxp629rH78miMJDVvsyZbYKDDPF
         m74Bw9W6Cl+ssYY7p7i8J6EgS462hUnrvrNplGQ7gB1owCezCBEmNLCdLRv5y9GQm0mK
         V5Dg==
X-Gm-Message-State: APjAAAVhtO8YOAZSxqDUiJR9efahDDtpqCyZn14+qz8Qlam3m3Vq7HPB
        iC0hE0VdqInV6tWoEMcdFqk=
X-Google-Smtp-Source: APXvYqxhv1TnRe03QCYFcaO69PhSNvKECZBoJM0ccNleoBHyw3Sou26hi99GDh30RtV5t1lbdHKElg==
X-Received: by 2002:a17:90a:ba98:: with SMTP id t24mr4373790pjr.12.1576692046910;
        Wed, 18 Dec 2019 10:00:46 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::4108])
        by smtp.gmail.com with ESMTPSA id c184sm4276544pfa.39.2019.12.18.10.00.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 10:00:45 -0800 (PST)
Date:   Wed, 18 Dec 2019 10:00:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     bpf@vger.kernel.org, paul.chaignon@gmail.com,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
Message-ID: <20191218180042.2ktkmok5ugeahczn@ast-mbp.dhcp.thefacebook.com>
References: <cover.1576673841.git.paul.chaignon@orange.com>
 <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 03:23:04PM +0100, Paul Chaignon wrote:
> Currently, userspace programs have to update the values of all CPUs at
> once when updating per-cpu maps.  This limitation prevents the update of
> a single CPU's value without the risk of missing concurrent updates on
> other CPU's values.
> 
> This patch allows userspace to update the value of a specific CPU in
> per-cpu maps.  The CPU whose value should be updated is encoded in the
> 32 upper-bits of the flags argument, as follows.  The new BPF_CPU flag
> can be combined with existing flags.

In general makes sense. Could you elaborate more on concrete issue?

>   bpf_map_update_elem(..., cpuid << 32 | BPF_CPU)
> 
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> ---
>  include/uapi/linux/bpf.h       |  4 +++
>  kernel/bpf/arraymap.c          | 19 ++++++++-----
>  kernel/bpf/hashtab.c           | 49 ++++++++++++++++++++--------------
>  kernel/bpf/local_storage.c     | 16 +++++++----
>  kernel/bpf/syscall.c           | 17 +++++++++---
>  tools/include/uapi/linux/bpf.h |  4 +++
>  6 files changed, 74 insertions(+), 35 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index dbbcf0b02970..2efb17d2c77a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -316,6 +316,10 @@ enum bpf_attach_type {
>  #define BPF_NOEXIST	1 /* create new element if it didn't exist */
>  #define BPF_EXIST	2 /* update existing element */
>  #define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
> +#define BPF_CPU		8 /* single-cpu update for per-cpu maps */

BPF_F_CPU would be more consistent with the rest of flags.

Can BPF_F_CURRENT_CPU be supported as well?

And for consistency support this flag in map_lookup_elem too?

> +
> +/* CPU mask for single-cpu updates */
> +#define BPF_CPU_MASK	0xFFFFFFFF00000000ULL

what is the reason to expose this in uapi?

>  /* flags for BPF_MAP_CREATE command */
>  #define BPF_F_NO_PREALLOC	(1U << 0)
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index f0d19bbb9211..a96e94696819 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -302,7 +302,8 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
>  	u32 index = *(u32 *)key;
>  	char *val;
>  
> -	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
> +	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_F_LOCK &
> +				  ~BPF_CPU) > BPF_EXIST))

that reads odd.
More traditional would be ~ (A | B | C)

