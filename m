Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5465F350CF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFDUWv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 16:22:51 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39204 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDUWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:22:50 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so2277086edv.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lUz5zokjAF15rh9aFBgEOYfgttrQtIynuAsC+GxZfnA=;
        b=IG5girFsIS718t6ciUEVS6XXhaUZjUD60w8QVYF7jVIhHRfFKN/rtaSJZvPv3FKsAi
         pS3so3GRFyY7ZC3V4vgNSt9j+2RS4IVcLWwbdkpKCRziOwrRE4AaKqtYFhFdG6fD8h56
         rY0srS1iuCWuSuBY9/qsMUWwqiIl/YS8FOxhRRkTy3WIdyDBBT3thLzOz2pEoQwUe/dL
         c7o4N14pjOLNoaRGBdJxwU/dAQANtRA0JNIkki9gCqq3vplcAWdKouJCCN0Qo36plETY
         DBDOuu52B+5VLXW4ARLq2e+QC+LwBA55URd/iBUlhLaonQUUH9tzFuwDtn1iZqf1qz3M
         kYIg==
X-Gm-Message-State: APjAAAV7O8uv3SjsofBfv6AscVnCsx5lnMoAVx6PfvpPH8ZX8EQ0rlun
        IevhLsgS8VxV1kRho7n0D30zUw==
X-Google-Smtp-Source: APXvYqwYhXA4G1Zvd0neaENDdUMHEipNVKisqSKz602BCIT6FsbacmsYtOzKYc3p+TWs2f6m2O4Vkw==
X-Received: by 2002:a17:906:7c10:: with SMTP id t16mr31747803ejo.161.1559679768869;
        Tue, 04 Jun 2019 13:22:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i5sm5125690edc.20.2019.06.04.13.22.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 13:22:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 92848181CC1; Tue,  4 Jun 2019 22:22:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
In-Reply-To: <155966185078.9084.7775851923786129736.stgit@alrua-x1>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1> <155966185078.9084.7775851923786129736.stgit@alrua-x1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Jun 2019 22:22:47 +0200
Message-ID: <871s09f6co.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> writes:

> We don't currently allow lookups into a devmap from eBPF, because the map
> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
> modifiable from eBPF.
>
> However, being able to do lookups in devmaps is useful to know (e.g.)
> whether forwarding to a specific interface is enabled. Currently, programs
> work around this by keeping a shadow map of another type which indicates
> whether a map index is valid.
>
> To allow lookups, simply copy the ifindex into a scratch variable and
> return a pointer to this. If an eBPF program does modify it, this doesn't
> matter since it will be overridden on the next lookup anyway. While this
> does add a write to every lookup, the overhead of this is negligible
> because the cache line is hot when both the write and the subsequent read
> happens.
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c   |    8 +++++++-
>  kernel/bpf/verifier.c |    7 ++-----
>  2 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 5ae7cce5ef16..830650300ea4 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -65,6 +65,7 @@ struct xdp_bulk_queue {
>  struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct bpf_dtab *dtab;
> +	int ifindex_scratch;

Just realised I forgot to make this per-cpu; I'll send an updated
version once we settle on a solution that works for xskmap as well...

-Toke
