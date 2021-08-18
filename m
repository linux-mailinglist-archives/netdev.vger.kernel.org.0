Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115F53F0096
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhHRJfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbhHRJc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:32:59 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0D6C06179A
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 02:32:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so1347433wml.3
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 02:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8GAddWU2NmYxi2kzO7R2dcfn+9hNnUwg3X5plP43ywE=;
        b=W6Gz1wi/qaK6Vjzxb2QFWj0DtNS9DX6bAWVAUUILZM2DuBGvjiJM0LlJkdZ0Gwaaq7
         FdmCWvxiFkgaySMtRKUwP+/ptcKxhOLZaVYCme6NqrEre/GtrHKn+vY2qdwCU+Ow6D+X
         cbigzNj09kxUruZNw/dqXdViOIVH496gDaIziFdEuJUWVKAa9miZY+pxISl/zIJgDcs0
         aLSivbenYXYSQVBRWLajrY49E++8ytl/Ya5Cnos0p+o9XycCHXEfp7SUTT7tn+/jyj2o
         94eu3rNJl/4jgmBa8ZWR1X+mVImOm7MfYIcEyvaSB7OzGZj/Njx/rOtlPLmlFwtuuUjZ
         /pug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8GAddWU2NmYxi2kzO7R2dcfn+9hNnUwg3X5plP43ywE=;
        b=Ka+MtgFQot1iyUvkFwEpjft2tKNL3O0wT6F8ZIgvabzfZF/+NDCPLq9EpqcJy37eaL
         0UZptp9surHn9T4ZSo4FOUKbcls7RnMiqLefiLPWRixZkORBKm9g0boRwxdtrsFcGu4J
         j+0Gg4aTjMMaeXKkHzka+9FE/vtVPjlmiVjVOnyy5nrzDAR4y6RLJPNBvXlZWp8VdB+B
         f7ORdQS6W2TS8O1KXOQFwfCQYsczR+pQR2Pt12V3hMfNXb5cBt5hD86pQcmceuBFbmls
         63tIr6O8HKcUsLgLykxb3+uy4ANrK1muKFgqcIDb4FE406jrpH1aRqiZX+MNUAYHgc4X
         QmOA==
X-Gm-Message-State: AOAM531ctP/467rCVhrfsixK3yMqj7SCdKyeRZM+Ma+K6L+4DpvvFJEx
        Hsot2C+To1FF72lu1Uyz2BjZJEOLCsU=
X-Google-Smtp-Source: ABdhPJxglRsuXkOT4IkplDd0OtrFErebGyXMRDT/34R8U9GdiqZ8H+ldy08aj46H2s+r6tZRiP7dbA==
X-Received: by 2002:a05:600c:a4b:: with SMTP id c11mr7483612wmq.97.1629279125768;
        Wed, 18 Aug 2021 02:32:05 -0700 (PDT)
Received: from [10.0.0.3] ([37.165.230.154])
        by smtp.gmail.com with ESMTPSA id a11sm1041725wrh.64.2021.08.18.02.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:32:05 -0700 (PDT)
Subject: Re: [PATCH] ovs: clear skb->tstamp in forwarding path
To:     fankaixi.li@bytedance.com, dev@openvswitch.org,
        netdev@vger.kernel.org
Cc:     xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
References: <20210818022215.5979-1-fankaixi.li@bytedance.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <401464ef-2238-ebe0-c661-714403083317@gmail.com>
Date:   Wed, 18 Aug 2021 11:32:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818022215.5979-1-fankaixi.li@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/21 4:22 AM, fankaixi.li@bytedance.com wrote:
> From: kaixi.fan <fankaixi.li@bytedance.com>
> 
> fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
> doesn't clear skb->tstamp. We encountered a problem with linux
> version 5.4.56 and ovs version 2.14.1, and packets failed to
> dequeue from qdisc when fq qdisc was attached to ovs port.
> 

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")

This is more precise than " version 5.4.56 and ovs version ..."

Thanks.

> Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
> Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/openvswitch/vport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 88deb5b41429..cf2ce5812489 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
>  	}
>  
>  	skb->dev = vport->dev;
> +	skb->tstamp = 0;
>  	vport->ops->send(skb);
>  	return;
>  
> 
