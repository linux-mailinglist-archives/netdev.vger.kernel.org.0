Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CFE1E64BA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403822AbgE1Ox3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391259AbgE1OxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:53:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84582C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:53:25 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d128so2372692wmc.1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jYwlFXyoA5W7eOjmY64mk9fyq3/rODJ0HXkx98UI8ms=;
        b=SbC0EQCRmMAuKlDmTMhJKM9/33wrjm/5m2A2+LrYTwDPw/46j9VlKEgIUfKQCdLuAn
         fXX93FqGNDFTYN3zPxj+k59IOEd36bKDQRBOBhfWH9O7pBo+QJaZACUtjmi0qvG6k1WX
         tdRemBAXpwxvD6CCdTEFVESiud6PlgU1nXiLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jYwlFXyoA5W7eOjmY64mk9fyq3/rODJ0HXkx98UI8ms=;
        b=AD5dgx87TEQ4FqRuGf4wNGgImExIhfZi8Tww1fVLum3hKw/c+JLfyEL1GlR0I88iU4
         0AtAX8JXNfZ+589+yceEwYwS+BRzg0sydYetxRQ+nSZBjkfJ5yqXHSBsTo1r9cy2WCSk
         9AqIK3GeyGKKUl18/DqrSad6qjW+gzxpgmK7R4Ns6lkyQ/oZgkmk+eipUoxKEbgD+4tn
         lqjyhITJ/cGA2B1jyCNNeZIE89643/zlCrttuqZqXTuo7qF7EmvZVVRIyxsoXh1Vkab/
         NnT2/MsXrVb7Rk0lb/iQBqIAiCDZQP95sstK6nLly+8SIsO/kfpi4TyaBVySGc60yH2I
         Q0Zw==
X-Gm-Message-State: AOAM530Z04TRKmkWVGX16umxXncgWGmbFmp0784/VXLUY2cgsGYshE6a
        kDGbM6mMEMoT/0cYQglMSu9myQ==
X-Google-Smtp-Source: ABdhPJw6x83C5m+liS6sK3O+5Mi+sGqGNugMnzt/+6U4WeTLNCfN42hQ7sh+8CL5hqzz96DVlegeBA==
X-Received: by 2002:a1c:a74d:: with SMTP id q74mr3779042wme.177.1590677604252;
        Thu, 28 May 2020 07:53:24 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h20sm6747524wma.6.2020.05.28.07.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 07:53:22 -0700 (PDT)
Subject: Re: [PATCH][net-next] nexthop: fix incorrect allocation failure on
 nhg->spare
To:     Colin King <colin.king@canonical.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528145114.420100-1-colin.king@canonical.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <8b73e872-c05e-e93f-1d2d-3466da4ddbcc@cumulusnetworks.com>
Date:   Thu, 28 May 2020 17:53:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200528145114.420100-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 17:51, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The allocation failure check for nhg->spare is currently checking
> the pointer nhg rather than nhg->spare which is never false. Fix
> this by checking nhg->spare instead.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index ebafa5ed91ac..97423d6f2de9 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1185,7 +1185,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
>  
>  	/* spare group used for removals */
>  	nhg->spare = nexthop_grp_alloc(num_nh);
> -	if (!nhg) {
> +	if (!nhg->spare) {
>  		kfree(nhg);
>  		kfree(nh);
>  		return NULL;
> 

Good catch, embarrassing copy paste error :-/
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

