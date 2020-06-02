Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F103A1EBCF9
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgFBNU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFBNU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:20:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE369C061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 06:20:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p30so5056465pgl.11
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N2eicIBnsRhNHTfHua2/6Ykx9jcEXaC9iLm87ntVd2w=;
        b=WUJTzCgJt9bTExDQSjI1K1fSuJxd0W3AeWCqjpftmUisnT2Xi94XkjFXvLS/QiwxcR
         J+70uzVL0x7e1ZRNLxU6aoressTR7sn+bUJ240Mkdv4GoCYu25UK8hXJQ3jwt0HEyyNg
         xRw8jDrbNNluI9eD7FbxG1MmzbEE94ylRUI3hE8E6s6zM2ZomX3GrXsMQ5Hp3KfFQKjh
         IjeGsqZ+ClXg68ICFFR+VUeThBOGuSbEbiJKRaJYSaveFbfozEiFEkng/OgJyG955dgp
         iLsLgTy7W0pMYMEinthNs9HsHxtS/zF3dKZgHnEGfcgvoQZD/Icm0b+nhY3sKhZXAU05
         qOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N2eicIBnsRhNHTfHua2/6Ykx9jcEXaC9iLm87ntVd2w=;
        b=OvaErks8OuPtfOivxfky0Sj9fUsPwj4RY07Ad/1gCoF+crnL/u+Ds+ud1CZeIadL+y
         iYxa3FMCZdvu2Il9chT3SOC8HuZv6mYt8H73Gb1UcTscNbadAffTu0r4ZandfZYy1b4K
         8uCDgQ1vZP0cRhxr5LxOEyQbG0UKG6bqULAD4yCs4sKHEMwjuh4sOhTL5VhQLPLPxt5I
         z9ae+EafZYb7n9mpkeu4e648G4+geJYqcmyBXISiVHTtuXPPZ9Ov2EfiJib47EMYl9gH
         djI+INlad6iXyxQyjBwj7LZMA2ZWt825g4Pnlmdm7UDcsy6zSDcLhZwQBDINvxxGoMb3
         jR0g==
X-Gm-Message-State: AOAM531gOmLrg9nkdU0FBqbDQmYnpFC9drv/GklpprSuXTjjSMorotxp
        rI0XRtxfSS47xUi7sfEDpUw=
X-Google-Smtp-Source: ABdhPJyPuUQcJ1wxTT9nDKVR5c/kFbXTH0269SVEZ22RDg41cd0oBRZMvwD8TCyV1Olsh5TniO4jQQ==
X-Received: by 2002:a63:f40f:: with SMTP id g15mr23585094pgi.285.1591104056238;
        Tue, 02 Jun 2020 06:20:56 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x190sm2322116pgb.79.2020.06.02.06.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 06:20:55 -0700 (PDT)
Subject: Re: [PATCH] seg6: Fix slab-out-of-bounds in fl6_update_dst()
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        alex.aring@gmail.com, ahabdels@gmail.com
Cc:     netdev@vger.kernel.org, Ahmed Abdelsalam <ahabdels@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>
References: <20200602065155.18272-1-yuehaibing@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e8e9f99e-9123-9a9a-f5b7-123e11800c06@gmail.com>
Date:   Tue, 2 Jun 2020 06:20:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200602065155.18272-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/1/20 11:51 PM, YueHaibing wrote:
> When update flowi6 daddr in fl6_update_dst() for srcrt, the used index
> of segments should be segments_left minus one per RFC8754
> (section 4.3.1.1) S15 S16. Otherwise it may results in an out-of-bounds
> read.
> 
> Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
> Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/ipv6/exthdrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index 5a8bbcdcaf2b..f5304bf33ab1 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -1353,7 +1353,7 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
>  	{
>  		struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)opt->srcrt;
>  
> -		fl6->daddr = srh->segments[srh->segments_left];
> +		fl6->daddr = srh->segments[srh->segments_left - 1];
>  		break;
>  	}
>  	default:
> 

1) Any reason you do not cc the author of the buggy patch ?
   I also cced David Lebrun <david.lebrun@uclouvain.be> to get more eyes.

2) What happens if segments_left == 0 ?

