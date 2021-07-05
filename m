Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36433BB971
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhGEImF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:42:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhGEImE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 04:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625474366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bweUN2pJ/Ie83brxZk2wROyzcyW2xnYFdHaPpHgUT4A=;
        b=h+KtyqqJruAAXSTiaU1uulTYmyLge+inZMMLKy30YdocvmUr5wM6FJC4rHA+Bor+a+mk2o
        +4H7grut0bTkgL6PNdadzH80GotpkULyYmWj9SVMGR/aAjCG4iQy9uCroctrv54slHgarA
        s3CNoCkCwZqTJ0Ly+IOeVP2hx/Yu3k4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-qQErTLZuPBCqvUXeFHvJMg-1; Mon, 05 Jul 2021 04:39:25 -0400
X-MC-Unique: qQErTLZuPBCqvUXeFHvJMg-1
Received: by mail-wm1-f70.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so5589241wmh.9
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 01:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bweUN2pJ/Ie83brxZk2wROyzcyW2xnYFdHaPpHgUT4A=;
        b=D9izwh4lb0JK6oeVl8P4vawc8QVsMFYqXF6wGJremO/CwjWglWfCinnaPPF87oJpQW
         iequEHQGitJUdrucHDSQScFbY9CUBHNBPBgCfXTIzdXA6RXaFPrJc2atqgx4E6g1klTJ
         8BkKKCfO904pa+G+UpmQ5Eqr9iCRGEKkn7pG1eQHktvY/RenI+8ukamitDrRf1P8bCcu
         sWH1keaLIPBFHeC1JZpE/6mWjjoJcYVDiN3ghp9oYhAu9LMGONJeMD6zYXmufWkdPv/b
         pQbDca/CaIV3NSh43qkYYsRoBex2j3dxcOB6+YZrMxUgHmmjAa7RwxEneuVAjokuUNCn
         d12Q==
X-Gm-Message-State: AOAM530yVU1UetBQzs7+ycnLa+7Zvst0dIjCCsy4vp4ZdRkUP97UAy5h
        ZA5hOX2K95sXi6/I4lG+yypLhtQIaBU/XQzPXbphMUgx5cnb2kuiP0ea4cwKIZ2iP5f/dpHxq9I
        b5vh7CuIr6m2b72mR
X-Received: by 2002:a5d:6d8d:: with SMTP id l13mr14162148wrs.358.1625474364376;
        Mon, 05 Jul 2021 01:39:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYUXWm3f8RD3/5fIHDZa9XyLJ72aJsRoj07K9wfaJyBJlzU8vw2ib9iyh8bpiQrGEk63JWJA==
X-Received: by 2002:a5d:6d8d:: with SMTP id l13mr14162124wrs.358.1625474364131;
        Mon, 05 Jul 2021 01:39:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id h9sm11401823wmb.35.2021.07.05.01.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 01:39:23 -0700 (PDT)
Message-ID: <cba3fd4b530e05c8262713e32bad54d87c5a151a.camel@redhat.com>
Subject: Re: [PATCH net v2] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Date:   Mon, 05 Jul 2021 10:39:22 +0200
In-Reply-To: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
References: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-05 at 10:49 +0300, Paul Blakey wrote:
> When multiple SKBs are merged to a new skb under napi GRO,
> or SKB is re-used by napi, if nfct was set for them in the
> driver, it will not be released while freeing their stolen
> head state or on re-use.
> 
> Release nfct on napi's stolen or re-used SKBs, and
> in gro_list_prepare, check conntrack metadata diff.
> 
> Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
> Changelog:
> 	v1->v2:
> 	 Check for different flows based on CT and chain metadata in gro_list_prepare
> 
>  net/core/dev.c    | 13 +++++++++++++
>  net/core/skbuff.c |  1 +
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 439faadab0c2..bf62cb2ec6da 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head *head,
>  			diffs = memcmp(skb_mac_header(p),
>  				       skb_mac_header(skb),
>  				       maclen);
> +
> +		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> +
> +		if (!diffs) {
> +			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +			diffs |= (!!p_ext) ^ (!!skb_ext);
> +			if (!diffs && unlikely(skb_ext))
> +				diffs |= p_ext->chain ^ skb_ext->chain;
> +		}

I'm wondering... if 2 skbs are merged, and have the same L2/L3/L4
headers - except len and csum - can they have different dst/TC_EXT?

@Eric: I'm sorry for the very dumb and late question. You reported v1
of this patch would make "GRO slow as hell", could you please elaborate
a bit more? I thought most skbs (with no ct attached) would see little
difference???

Cheers,

Paolo


