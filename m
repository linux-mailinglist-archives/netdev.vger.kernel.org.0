Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB44273E5F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIVJRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgIVJRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:17:33 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CBCC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:17:32 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w16so20281157oia.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RXae/aOLNMnxlMYIGKwG05c4UMKJkn0dioq6hp9j5w=;
        b=y2EgvZklRCT4oZaqKxrpjfur/PnS8PmSZ4Qq8XB6E80yo3uPbfWhA/u1I7Nkj8cryx
         zT15fxmn+uS2tkZClaZL/SjDOx7wV9fqywYMylqosUP2XJXjAQTzCNTki4q0e4GChufj
         8UEEAKsOEXhCBhE9AlTzwC6Sj0wRqi5NL7e+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RXae/aOLNMnxlMYIGKwG05c4UMKJkn0dioq6hp9j5w=;
        b=dXoIA3oSkrNNtWHydUwLVLrRP9B9pbBiWuuk1sFIyojAQlsz+D2+nh6piIuoIJl3cj
         NHf2YLzWgurYPTvOANvqhohfjrrnuq18eX71wUrWC8UyisMQSesr5/liedSQ3Plm7kap
         H9bDwBsvbeU4MoR5w3merCGxOqbxl5cglGTZHUnkiyHUJUgYlm7reH7OV1RIKT8POdPV
         Syq+cXv7AT4qW2/9YtvaV83MMktFmhkBdBCxLnhNvQnu3f21+Z9FAQfypvhnWmZPGo5Q
         29yRaBBcn78nPDxnMzwoUcelmNzTcgpcFt0hiBRD2ZGzPGLGB61HkDjPfRc4t3zhFlaJ
         DKNw==
X-Gm-Message-State: AOAM532uvElVeGJ4tHo93EOjJmWeWhPupbVSg9jawqA4kL7GfqibPuVL
        hGYNoJa4dJePtw+fedawbTiHyjDC3iki0NgsfabUItffDfA=
X-Google-Smtp-Source: ABdhPJwxoiCqTJn47bYmsH5M5lqR1JRbxS6BeR3ZxxGjJGLL+fiuuueNz/1UphFA6M3RH0H9W25fqb16NzMqKm5NkO0=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr2116399oip.13.1600766252401;
 Tue, 22 Sep 2020 02:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070434.1919082-1-kafai@fb.com>
In-Reply-To: <20200922070434.1919082-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 22 Sep 2020 10:17:20 +0100
Message-ID: <CACAyw98FbjdmaVQJcuVPSmb40fLG_QnrkMJ2pUaJPdSSTwLp5g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 04/11] bpf: Change bpf_sk_storage_*() to
 accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch changes the bpf_sk_storage_*() to take
> ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
> returned by the bpf_skc_to_*() helpers also.
>
> A micro benchmark has been done on a "cgroup_skb/egress" bpf program
> which does a bpf_sk_storage_get().  It was driven by netperf doing
> a 4096 connected UDP_STREAM test with 64bytes packet.
> The stats from "kernel.bpf_stats_enabled" shows no meaningful difference.
>
> The sk_storage_get_btf_proto, sk_storage_delete_btf_proto,
> btf_sk_storage_get_proto, and btf_sk_storage_delete_proto are
> no longer needed, so they are removed.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

I like that we can get rid of the init code.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
