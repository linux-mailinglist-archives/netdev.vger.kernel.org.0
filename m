Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF846A8CB0
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 00:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCBXDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 18:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCBXDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 18:03:13 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC400BDCC;
        Thu,  2 Mar 2023 15:03:12 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id l18so1113284qtp.1;
        Thu, 02 Mar 2023 15:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677798192;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+pVHKA/oTFVdBwiAlXC7uOD6TN6kupcVJhF4A4T5lM=;
        b=mYom0QD4nMBb/2NvP7+KRZ2ZFoupXyYNpDIXtPmNcgTrdVKld2Em4B3sT5w9qtdoLZ
         VV7MZ2KWIxEJu7Htl17EudNU5rBYozE7Sx91MLvYpAR6hUmRnOvbUBlK7G8+BFka1ggl
         z1whSRGJTSfk5VWRULRQ8aIjaokugRipK8UpeBzLKDDorxdoEbMccnlLqqcSobRt8cyI
         1H1b5ZoM0wcAD6BOyCpIKukvh7s/7hUJtBqpbBvEylODL8+Ir8GCyLwccJ86pYcEdsqz
         7IUFjom/eUcVXIJVgmNy1DlofWcFZCiFZvjI1RRE0LMfXo/geZwq0QHzEZhXvgSiY+ke
         tEAg==
X-Gm-Message-State: AO0yUKUcb7Me9hgDCpjTdPbWyAREm+59eiVM0IRq/MlucSMxOf83oSZt
        yES105UJ0XSmbeYcon5cy9o=
X-Google-Smtp-Source: AK7set9v00NNuQX5RgIn2+RP5BALUK4ddYs7ehAcF83tuLN+QTwayet8xOy1n2xvcYlfxpG2ANzT6g==
X-Received: by 2002:ac8:7f16:0:b0:3bf:bac6:9961 with SMTP id f22-20020ac87f16000000b003bfbac69961mr23470323qtk.55.1677798191600;
        Thu, 02 Mar 2023 15:03:11 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:5ba])
        by smtp.gmail.com with ESMTPSA id p23-20020a05620a057700b0071f0d0aaef7sm529875qkp.80.2023.03.02.15.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 15:03:11 -0800 (PST)
Date:   Thu, 2 Mar 2023 17:03:08 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 6/6] bpf: Refactor RCU enforcement in the
 verifier.
Message-ID: <ZAErLAKYKZKqmhSi@maniforge>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
 <20230301223555.84824-7-alexei.starovoitov@gmail.com>
 <ZAAgfwgo5GU8V28f@maniforge>
 <20230302212344.snafoop5hytngskk@MacBook-Pro-6.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302212344.snafoop5hytngskk@MacBook-Pro-6.local>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 01:23:44PM -0800, Alexei Starovoitov wrote:

[...]

> > > +		if (type_is_trusted(env, reg, off)) {
> > > +			flag |= PTR_TRUSTED;
> > > +		} else if (in_rcu_cs(env) && !type_may_be_null(reg->type)) {
> > > +			if (type_is_rcu(env, reg, off)) {
> > > +				/* ignore __rcu tag and mark it MEM_RCU */
> > > +				flag |= MEM_RCU;
> > > +			} else if (flag & MEM_RCU) {
> > > +				/* __rcu tagged pointers can be NULL */
> > > +				flag |= PTR_MAYBE_NULL;
> > 
> > I'm not quite understanding the distinction between manually-specified
> > RCU-safe types being non-nullable, vs. __rcu pointers being nullable.
> > Aren't they functionally the exact same thing, with the exception being
> > that gcc doesn't support __rcu, so we've decided to instead manually
> > specify them for some types that we know we need until __rcu is the
> > default mechanism?  If the plan is to remove these macros once gcc
> > supports __rcu, this could break some programs that are expecting the
> > fields to be non-NULL, no?
> 
> BTF_TYPE_SAFE_RCU is a workaround for now.
> We can make it exactly like __rcu, but it would split
> the natural dereference of task->cgroups->dfl_cgrp into
> two derefs with extra !=NULL check in-between which is ugly and unnecessary.
> 
> > I see why we're doing this in the interim -- task->cgroups,
> > css->dfl_cgrp, task->cpus_ptr, etc can never be NULL. The problem is
> > that I think those are implementation details that are separate from the
> > pointers being RCU safe. This seems rather like we need a separate
> > non-nullable tag, or something to that effect.
> 
> Right. It is certainly an implementation detail.
> We'd need a new __not_null_mostly tag or __not_null_after_init.
> (similar to __read_mostly and __ro_after_init).
> Where non-null property is true when bpf get to see these structures.
> 
> The current allowlist is incomplete and far from perfect.
> I suspect we'd need to add a bunch more during this release cycle.
> This patch is aggressive in deprecation of old ptr_to_btf_id.
> Some breakage is expected. Hence the timing to do it right now
> at the beginning of the cycle.

Thanks for explaining. This all sounds good -- I'm certainly in favor of
being aggressive in deprecating the old ptr_to_btf_id approach. I was
really just worried that we'd break progs when we got rid of
BTF_TYPE_SAFE_RCU and started to use __rcu once gcc supported it, but as
you said we can just add another type tag at that time. And if we need
to add another RCU-safe pointer that is NULL-able before we have the gcc
support we need, we can always just add something like a
BTF_TYPE_SAFE_NULLABLE_RCU in the interim. Clearly a temporary solution,
but really not a bad one at all.

> 
> > >  		flag &= ~PTR_TRUSTED;
> > 
> > Do you know what else is left for us to fix to be able to just set
> > PTR_UNTRUSTED here?
> 
> All "ctx->" derefs. check_ctx_access() returns old school PTR_TO_BTF_ID.
> We can probably mark all of them as trusted, but need to audit a lot of code.
> I've also played with forcing helpers with ARG_PTR_TO_BTF_ID to be trusted,
> but still too much selftest breakage to even look at.
> 
> The patch also has:
> +                       if (BTF_INFO_KIND(mtype->info) == BTF_KIND_UNION &&
> +                           btf_type_vlen(mtype) != 1)
> +                               /*
> +                                * walking unions yields untrusted pointers
> +                                * with exception of __bpf_md_ptr and other
> +                                * unions with a single member
> +                                */
> +                               *flag |= PTR_UNTRUSTED;
> this is in particular to make skb->dev deref to return untrusted.
> In this past we allowed skb->dev->ifindex to go via PTR_TO_BTF_ID and PROBE_MEM.
> It's safe, but not clean. And we have no safe way to get trusted 'dev' to pass into helpers.
> It's time to clean this all up as well, but it will require rearranging fields in sk_buff.
> Lots of work ahead.

SGTM, thanks
