Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94D278439
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgIYJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYJlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 05:41:06 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF14C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:41:06 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id b12so584843oop.13
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cci3ai4+MozGw7ZhznDXtMZXiz1P5q1VdDnN+O2ZEkY=;
        b=zHmlKhyeDrpXNciiDmehie3M5+icRXMRkxFWHbog2u2jf8ZKrs6KoyPtSU8f2GbMlD
         XBcG9YLITlfqog1UuSImXfj7CFR6YEsaYb5lZRIi5/5CZmmWQauecgQBCC2AKFUeyAWj
         ww7RtLOxcxgzCWUoKTW+YK0OUZEICWzMvclsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cci3ai4+MozGw7ZhznDXtMZXiz1P5q1VdDnN+O2ZEkY=;
        b=fDG3fbT1zjMdanhGzub5ErMveeka6L4io4jT4ydT3/IyGfBBDTJduw1i+WckEdfG2U
         D6Sgc+/97vo7RI62D2oiWODPRnxdZ6KjvtMEQx5iHxm5MwMxQvJZgiC7M/ThfFluq2az
         jCRXVxJa8RdcSjjLfyjq8hZoZuIsq7oVKZJqQ4MJtIxZgB2xWaoHL/mR+U83XhxYLK3B
         0bYiZmscAPAEAdUnxjuAzrUZb2mGatdiPIxALO4X8xp+4QSH+pCQca9sMrqfviAJM35D
         SWgfuaB7J9DUzHIsPspjaF7XfFIvr6RhiZObKjrz/pYafkCIC66/eNxWQxhCKUo4dOtc
         SQHw==
X-Gm-Message-State: AOAM530P95/6AEEuyHVFNbhCf8b6E/hOGjaNQ3OWB+1gbzW1l2q91qzR
        hRZ82EZoiVNyHfoQntaUzMb31Akz30tS2Fu298rzhw==
X-Google-Smtp-Source: ABdhPJx2UKfniuRCaD/83lLqK/GMtdTA6WAe+fN6gq5PGc/JYH3RTn6qdLZwDdZkFQnhlfm3wTQ84u5rckmC+z9ubHw=
X-Received: by 2002:a4a:3516:: with SMTP id l22mr215078ooa.6.1601026865949;
 Fri, 25 Sep 2020 02:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200925000337.3853598-1-kafai@fb.com>
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 25 Sep 2020 10:40:54 +0100
Message-ID: <CACAyw99ZUAzpXNr4ovEZQkhmxckHrb_GMzd2BJNiYO1kmg_YMQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 at 01:03, Martin KaFai Lau <kafai@fb.com> wrote:
>
> This set allows networking prog type to directly read fields from
> the in-kernel socket type, e.g. "struct tcp_sock".
>
> Patch 2 has the details on the use case.
>
> v3:
> - Pass arg_btf_id instead of fn into check_reg_type() in Patch 1 (Lorenz)
> - Move arg_btf_id from func_proto to struct bpf_reg_types in Patch 2 (Lorenz)
> - Remove test_sock_fields from .gitignore in Patch 8 (Andrii)
> - Add tests to have better coverage on the modified helpers (Alexei)
>   Patch 13 is added.
> - Use "void *sk" as the helper argument in UAPI bpf.h
>
> v3:
> - ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted in v2.  The _OR_NULL was
>   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
>   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
>   gives an expectation that the helper can take a scalar NULL which does
>   not make sense in most (except one) helpers.  Passing scalar NULL
>   should be rejected at the verification time.
>
>   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
>   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
>   not scalar NULL.  It requires the func_proto to explicitly specify the
>   arg_btf_id such that there is a very clear expectation that the helper
>   can handle a NULL PTR_TO_BTF_ID.
>
> v2:
> - Add ARG_PTR_TO_SOCK_COMMON_OR_NULL (Lorenz)
>
> Martin KaFai Lau (13):
>   bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
>   bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
>   bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept
>     ARG_PTR_TO_BTF_ID_SOCK_COMMON
>   bpf: Change bpf_sk_storage_*() to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
>   bpf: Change bpf_tcp_*_syncookie to accept
>     ARG_PTR_TO_BTF_ID_SOCK_COMMON
>   bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
>   bpf: selftest: Add ref_tracking verifier test for bpf_skc casting
>   bpf: selftest: Move sock_fields test into test_progs
>   bpf: selftest: Adapt sock_fields test to use skel and global variables
>   bpf: selftest: Use network_helpers in the sock_fields test
>   bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test
>   bpf: selftest: Remove enum tcp_ca_state from bpf_tcp_helpers.h
>   bpf: selftest: Add test_btf_skc_cls_ingress


LGTM, thanks!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
