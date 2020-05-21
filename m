Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2271DC5A0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 05:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgEUD3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 23:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgEUD3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 23:29:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938F9C061A0E;
        Wed, 20 May 2020 20:29:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id c75so2464212pga.3;
        Wed, 20 May 2020 20:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=chdEgCT7GKJB4jIbkmr6XV4Z/mYxxC3p/RRFsfkC23s=;
        b=sVWvgrjIOVISN145PuY85XGHqfiF9Lho2Q+C0xxZxfEO0jwMcI8h4g8kxDEgJYWSG6
         8DeuGsiXLo4dAbPnQpwZ6QTO68C5INDHZe22O2UOVUQpbPxbxjJx+heKgdlfti7qDhJr
         /KQG7BmTJX5Wla19ZHZ8aAxGwGF/hp9F/go5XxcJ1Y0SdCSGcXoherEiT9UIxIY4qC9Q
         JczOaXgqU0UEtFOXuoA+SWeI8m8t9CZ9Efrr3zk7RmeLlVRCfDN6hUrwwY8U9aCgJCwg
         7uvxPLB02EKZMX4RtWAv2Szn3FdWk+IJRrW6P8nafQk91TMbT2ro+R7GMZdx1i2m6uPx
         i6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=chdEgCT7GKJB4jIbkmr6XV4Z/mYxxC3p/RRFsfkC23s=;
        b=Ui+AeObM8w0JXa/nAsX0om6ZDdOCRddom0m+avQlf6lq3VbMWRexUx3O1d6g2bz+59
         DqrSIL77ZEs6B/gImHgQpEcrt6+lzOtnvtx3lLDO/0jgJNAU0ZGfmPlxSPnEKZMzFm+e
         ZDw8NJXUNUuwDmaFFfYL/tjFQAtdwtB5Plbc8QdE3jFOGgk4Q6TSiaHmC/8biUUyTiOS
         EjSjHmakabtZOiie/ij1oJ6EYbmOtOhYq6BNX/ft7DWDhBQHUWv53gG/3ct1IYSbUc3l
         SnWVz5ckPKpZKyyW78yvj8rFuIkGtu+ltBr5r4BN7yCMsvw/zplMlaoilMeu/HSjuYLT
         QL3g==
X-Gm-Message-State: AOAM530gPoNuG1NyXttld5LSHwq3SfNk1lNYRMnKXqfIZ1adQwr7NFMA
        0eQ1VUN3GH1D0891iE0+oI0=
X-Google-Smtp-Source: ABdhPJzxUBhJWlG+guZfwttPTGrh5JxX7MA2wb/nJVCu6HCqzt9OnwDlwEO7fglht1BNQdlQcgnM0g==
X-Received: by 2002:a62:1702:: with SMTP id 2mr7508833pfx.243.1590031774065;
        Wed, 20 May 2020 20:29:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id d2sm3159472pfa.164.2020.05.20.20.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 20:29:33 -0700 (PDT)
Date:   Wed, 20 May 2020 20:29:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jann Horn <jannh@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: prevent mmap()'ing read-only maps as writable
Message-ID: <20200521032931.rs5vbob2gei6ccic@ast-mbp.dhcp.thefacebook.com>
References: <20200519053824.1089415-1-andriin@fb.com>
 <CAG48ez2HZfjCKG+coVq2k9eE_Hm0rsdQE=O=5nVyKL80QncVZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2HZfjCKG+coVq2k9eE_Hm0rsdQE=O=5nVyKL80QncVZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:50:32AM +0200, Jann Horn wrote:
> On Tue, May 19, 2020 at 7:38 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > As discussed in [0], it's dangerous to allow mapping BPF map, that's meant to
> > be frozen and is read-only on BPF program side, because that allows user-space
> > to actually store a writable view to the page even after it is frozen. This is
> > exacerbated by BPF verifier making a strong assumption that contents of such
> > frozen map will remain unchanged. To prevent this, disallow mapping
> > BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.
> >
> >   [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=9OQPJxQpgug080MMjdSB72i9R+5c6g@mail.gmail.com/
> >
> > Suggested-by: Jann Horn <jannh@google.com>
> > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> 
> Reviewed-by: Jann Horn <jannh@google.com>

I fixed trailing white space after 'writable page'
and applied to bpf tree.
Thanks
