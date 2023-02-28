Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7757F6A5D64
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjB1QqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB1QqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:46:02 -0500
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2316034C03;
        Tue, 28 Feb 2023 08:45:57 -0800 (PST)
Received: by mail-qv1-f52.google.com with SMTP id nv15so7265796qvb.7;
        Tue, 28 Feb 2023 08:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYVO48FXas9roeOJnyiiq+0n+H4awkY5GZrrWNRYNF0=;
        b=2I4bxxqFbFu7q/PsAyTElTZR/eQQlYTjSeyXufZn0ub/sYCjQn0iRIXh8WX+KaaF3A
         vm1DyVb+Fn1gLU5XA2+Bm1ol/ee80xne4il2oAsutIN0NKO8q9uM3e61Yb5iQhTTtg0p
         DDto++3ue+bTJNPEKKGU8ndC1zAIlBzfcsj6icTaJlblmxaM1l4GSSU9+6cdeFRaBE6K
         m3Neg32+Vak6SXAkxydEhk/CGmlotU1DxBxldbXW0g/A4DQ2+Te61klHu65+UyuvDw8J
         74CPRjCgWg9+VGp8x4NODhOztZJBvCTnXREbDeBsFFD7n+g/1kjSS7TNTtSXCjc7cMd4
         HLUg==
X-Gm-Message-State: AO0yUKXsQ7NExMRUtGB7SjKT8XM4y4QjeooDjeVrHalcfowtLI3McKgl
        s/0GYLHRV6vVku+D5qS6XkA=
X-Google-Smtp-Source: AK7set+Hs0hpd1ZNKXTBvr7aHFo+ekwRQK23UYef40SCMeUIPBk/GIbSWc3wULRdW0oyhCoeTUVYTg==
X-Received: by 2002:a05:6214:cad:b0:56b:f47b:1cd2 with SMTP id s13-20020a0562140cad00b0056bf47b1cd2mr7496153qvs.41.1677602756014;
        Tue, 28 Feb 2023 08:45:56 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id bl32-20020a05620a1aa000b007423e52f9d2sm7122602qkb.71.2023.02.28.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 08:45:55 -0800 (PST)
Date:   Tue, 28 Feb 2023 10:45:53 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Mark cgroups and dfl_cgrp fields as
 trusted.
Message-ID: <Y/4vwaGKhZdLPTL3@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-3-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:18PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf programs sometimes do:
> bpf_cgrp_storage_get(&map, task->cgroups->dfl_cgrp, ...);
> It is safe to do, because cgroups->dfl_cgrp pointer is set diring init and
> never changes. The task->cgroups is also never NULL. It is also set during init
> and will change when task switches cgroups. For any trusted task pointer
> dereference of cgroups and dfl_cgrp should yield trusted pointers. The verifier
> wasn't aware of this. Hence in gcc compiled kernels task->cgroups dereference
> was producing PTR_TO_BTF_ID without modifiers while in clang compiled kernels
> the verifier recognizes __rcu tag in cgroups field and produces
> PTR_TO_BTF_ID | MEM_RCU | MAYBE_NULL.
> Tag cgroups and dfl_cgrp as trusted to equalize clang and gcc behavior.
> When GCC supports btf_type_tag such tagging will done directly in the type.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
