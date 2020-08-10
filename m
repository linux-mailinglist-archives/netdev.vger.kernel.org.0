Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBB2240825
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgHJPGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHJPGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:06:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A95C061756;
        Mon, 10 Aug 2020 08:06:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x6so5017589pgx.12;
        Mon, 10 Aug 2020 08:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n4zzcA0S7W6+MhfPmPe3RkV9t2uiG0tre547UgCr2Yw=;
        b=e4CED/lOpJOr7C5jNbzDgAza5R3Mg9DDJmNYBlkci158HZSpAeyZwiyogXJe0HNOCw
         xmEog1xuYF6Dz2fE4oLif2q7zzpix1m13YKOCaTF8zX7K2h6BgjFrnMSON5qpwuvXRJE
         RywwfQ5qz91TIAeuddzcmv2Y46s130neNjYqwvU/K4Qn2V2xoClaUTu5KNOos66RL3xV
         aAla7wyQxUHsi8xaMTZ6ZcFkYME2ohFvbK+lp1Ph+FeL8QbDoVL96g76pYXFzZpKNUzr
         6j108ZWIqMp4CfY8NZvJLgwj8ydOBQVgS48fAZ6nZC00S/56NV4FhivPit+OYnuWweYD
         DHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n4zzcA0S7W6+MhfPmPe3RkV9t2uiG0tre547UgCr2Yw=;
        b=kq4+mYvJuZvOFUwv7bCB8G0g1s8ExW05gV3NHZcICROERXhpyrQiS+Wen4D2+/QU+q
         66LpMy8VE0T3BuzRygzGjBgnn/EerkAolhWN7aUgNCqdAO9aQD8lt0+nW09tQGoR2Suq
         djsPOa652ge9ulkVJzjIKuWYDKb+V1SH58DLL4UWNBXeot6lGGi4wtkeSSWX0hB4IKgf
         s20N+urAgaXzJjqne9dVecQqCNmTkU62X9tW0bdb8DhQzftSz6jWnl/GI5aKLge6Q5Ob
         NVmyuEsxshUkMr1H7L8ZiExccxylXQJnk3rmKf6GNr9OQ/Pqhb1IcGBaDep10bSkWQue
         EDYA==
X-Gm-Message-State: AOAM5300NYbwEBbnAuqrNdDFLTNlCLlOWCvIHQqsetsKZI/Mt8ikswG1
        0y7lI84HQheizZksdrRIhTsm5eyO
X-Google-Smtp-Source: ABdhPJx4c4+BYLQf4r4GU3U/41YOwsfRHq6/82P9SZmrmDFh0rIdScrqpKs+IBzAO+0BatEzBH8MAQ==
X-Received: by 2002:a62:7c09:: with SMTP id x9mr1369261pfc.229.1597071973271;
        Mon, 10 Aug 2020 08:06:13 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v10sm6321590pff.192.2020.08.10.08.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 08:06:12 -0700 (PDT)
Subject: Re: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
To:     Miaohe Lin <linmiaohe@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, pshelar@ovn.org, martin.varghese@nokia.com,
        fw@strlen.de, dcaratti@redhat.com, edumazet@google.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200810122856.5423-1-linmiaohe@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fd23f2e0-5cf9-ef66-0c15-b46eac1da609@gmail.com>
Date:   Mon, 10 Aug 2020 08:06:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810122856.5423-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/20 5:28 AM, Miaohe Lin wrote:
> The skb_shared_info part of the data is assigned in the following loop. It
> is meaningless to do a memcpy here.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/core/skbuff.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7e2e502ef519..5b983c9472f5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5952,9 +5952,6 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>  
>  	size = SKB_WITH_OVERHEAD(ksize(data));
>  
> -	memcpy((struct skb_shared_info *)(data + size),
> -	       skb_shinfo(skb), offsetof(struct skb_shared_info,
> -					 frags[skb_shinfo(skb)->nr_frags]));
>  	if (skb_orphan_frags(skb, gfp_mask)) {
>  		kfree(data);
>  		return -ENOMEM;
> 

Reminder : net-next is CLOSED.

This is not correct. We still have to copy _something_

Something like :

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2828f6d5ba898a5e50ccce45589bf1370e474b0f..1c0519426c7ba4b04377fc8054c4223c135879ab 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5953,8 +5953,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
        size = SKB_WITH_OVERHEAD(ksize(data));
 
        memcpy((struct skb_shared_info *)(data + size),
-              skb_shinfo(skb), offsetof(struct skb_shared_info,
-                                        frags[skb_shinfo(skb)->nr_frags]));
+              skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
+
        if (skb_orphan_frags(skb, gfp_mask)) {
                kfree(data);
                return -ENOMEM;
