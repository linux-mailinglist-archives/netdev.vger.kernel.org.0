Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D3542D0CC
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJNDM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNDM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:12:56 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA64C061570;
        Wed, 13 Oct 2021 20:10:51 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so6379147otl.11;
        Wed, 13 Oct 2021 20:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MDcIaKQ5v9Uwb9iAdAtQgCdcI6fVMvMf7iMJVcoRZNY=;
        b=B429JZV/z6LMkDJeR+RpZcUWKQPrYn8GDkQB43bsVK1tDGeo4J5mNuitjQJyPQ0n8z
         jLw7zBn+h220gYYX7WP+Ydz6dEF9LqrVxt+rz4RMLnEouovd+3vImzRctMe1dmYlhVpq
         WtBTuwFjuP5p58EuVcphgqGc+bFVizQbTRiuXSYkXJtOes4uH6/j/UQcSltKqsPqPEB2
         T1DTlR1gCLZfbKPESNy8KXJCdC4Ex4CXvNySjDGRlslIhDAoAATyK8H412m7mfSp8pNx
         oK80IgQ4XDkvEr4i7PwaJ9N1gfgLvqopXOvP4TN277XLp3mk2SncQqkoSBK3L0aU8J7Y
         gdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MDcIaKQ5v9Uwb9iAdAtQgCdcI6fVMvMf7iMJVcoRZNY=;
        b=wuv2WnLuhOVIVORDEi2iD+9Vgk6QGH7wBoQOndjMxY3N4PM41H5Or3EdXaHVetH0Dn
         MBk+qG6UOPYrenFGb1d6lVjTKRT/3rnsTpn7v5a8qXD7M9ELQmfUI0UhX2RCyO5/HjIM
         jODBeAJgdfOBApAU37EikWwaO7WgQY6JiQJ4WLhTa9aCoL3J7pffX8iHJj5SDt7ESftj
         WlCMDBF80SiaP6wsJL6dRUaysVcD1aAJgXN+t3dDmSHUQIjC2Dn3cEQ+P4EUCM+xIWqQ
         VuIu6tLcLzHa6IzkHEgddZsugkyDCacK2XdLR5MejsTgZ5qTW57o82qTaC4rzJZe7Kq/
         ydAQ==
X-Gm-Message-State: AOAM531j4ludh7dZEczBGtP1j9hKTxc9HbH8EDhrMEn02cOIhOTkaUnj
        Vx0bq2vvDt95Uk5n+EmqkQxQp5ao8hVs9A==
X-Google-Smtp-Source: ABdhPJzuRjsbUZY+gCV5v11n1amFzerZaVhz32/94M9+JjEqkPFuJWMAoVB+wNEvPHASX9/TgaB94A==
X-Received: by 2002:a05:6830:35a:: with SMTP id h26mr307225ote.369.1634181051071;
        Wed, 13 Oct 2021 20:10:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id t5sm340740oic.4.2021.10.13.20.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 20:10:50 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net, neigh: Add build-time assertion to
 avoid neigh->flags overflow
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211013132140.11143-1-daniel@iogearbox.net>
 <20211013132140.11143-2-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e5eed61b-94d3-aa1a-1966-84242785f5dc@gmail.com>
Date:   Wed, 13 Oct 2021 21:10:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013132140.11143-2-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 7:21 AM, Daniel Borkmann wrote:
> Currently, NDA_FLAGS_EXT flags allow a maximum of 24 bits to be used for
> extended neighbor flags. These are eventually fed into neigh->flags by
> shifting with NTF_EXT_SHIFT as per commit 2c611ad97a82 ("net, neigh:
> Extend neigh->flags to 32 bit to allow for extensions").
> 
> If really ever needed in future, the full 32 bits from NDA_FLAGS_EXT can
> be used, it would only require to move neigh->flags from u32 to u64 inside
> the kernel.
> 
> Add a build-time assertion such that when extending the NTF_EXT_MASK with
> new bits, we'll trigger an error once we surpass the 24th bit. This assumes
> that no bit holes in new NTF_EXT_* flags will slip in from UAPI, but I
> think this is reasonable to assume.
> 
> Suggested-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  net/core/neighbour.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index eae73efa9245..4fc601f9cd06 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1940,6 +1940,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			NL_SET_ERR_MSG(extack, "Invalid extended flags");
>  			goto out;
>  		}
> +		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
> +			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
> +			      hweight32(NTF_EXT_MASK)));
>  		ndm_flags |= (ext << NTF_EXT_SHIFT);
>  	}
>  	if (ndm->ndm_ifindex) {
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

