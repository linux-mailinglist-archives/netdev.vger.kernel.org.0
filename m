Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68177434FFD
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJTQUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhJTQUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:20:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C84AC06161C;
        Wed, 20 Oct 2021 09:18:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d9so3390367pfl.6;
        Wed, 20 Oct 2021 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gy854QluB1gtuvRG+A8zZ+CiHHzyMfhwhgDp8iUZREA=;
        b=qkSmSs4tV80qZGOw7QkuJxzsgqby53LmkOeTwLKdRMhVeGYJ1KZrXG4tF3Yv6aRYyx
         NFDFtupeGBgfzD384KU4hahGGqc0ZeV0ojmElJfsyPaLJZS2s5RKmu35jQMzX7fWM4ev
         ReTj9G7nGIhsNCZBj2MzwciIAKPF+C9fh/7FPVs6ZUxVmaMt8zr4wJagJp8YoVT4JBuA
         6f4DPx0IJMwMEsB0BSk4Q2j86CKDrG+kMmvhz9ewQoPA03TP6a1pFjjmUqqSJU+b/Srh
         HXC4kgUngtJsXEetWGLj2b0kYDea8sV9un+Ta9IWJ0VOhrxFLpcWEoB6xah3wi3M1cCG
         jmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gy854QluB1gtuvRG+A8zZ+CiHHzyMfhwhgDp8iUZREA=;
        b=4QGNoF+Ie/XuB4sIuYVDTi3/XwM6VZJ4uqp0NQ7xEGZJOix05+6Nra5ZZ0Lvkk/BSD
         akwJY4l9yChUDZ4aI6rzMwk8G5h54wMZmO4amMcikC9koFiq9jRsg4nShi3xj82HhBLA
         bpsls+HCKvEJS4etIeKhKju5fPJLRzQAuiwlsc0sszEQIxWHf/f4GLxSONPT5Cf20fS+
         RnM2wfXHIVxdcdcTyYpN2XycYOgAuG0fLbq3okkda7tqWhDZ0aW9JACicBpwgTCVecPL
         CL4GRCq2hwyw5Fgu45El9DgvQmWljxH1PobGPX1AqBZzxZiMcZReYVhlIKc02rY63ESJ
         Hp3w==
X-Gm-Message-State: AOAM532f6TfytwXaaqUtNbFx3m0nYeHEFiaVLSjpoK7jDaE3SdG3paWP
        gvvDcSrXTNuY36GU+TO1YWWXHAzGEsg=
X-Google-Smtp-Source: ABdhPJzxJVHWSCpg04h+Z33QUNIhotY7fKemvsOTlQ9AU+N7031YIqaDZjmfxmga4Ue8rkuQZboGyQ==
X-Received: by 2002:a62:e90d:0:b0:44d:35a1:e5a0 with SMTP id j13-20020a62e90d000000b0044d35a1e5a0mr244414pfh.54.1634746695130;
        Wed, 20 Oct 2021 09:18:15 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o10sm3051164pjo.31.2021.10.20.09.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 09:18:14 -0700 (PDT)
Subject: Re: [PATCH net v9] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@openvz.org
References: <45b3cb13-8c6e-25a3-f568-921ab6f1ca8f@virtuozzo.com>
 <2bd9c638-3038-5aba-1dae-ad939e13c0c4@virtuozzo.com>
 <a1b83e46-27d6-d8f0-2327-bb3466e2de13@gmail.com>
 <a7318420-0182-7e66-33e3-3368d4cc181f@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2721362c-462b-878f-9e09-9f6c4353c73d@gmail.com>
Date:   Wed, 20 Oct 2021 09:18:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a7318420-0182-7e66-33e3-3368d4cc181f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/21 10:57 PM, Vasily Averin wrote:
> On 10/4/21 10:26 PM, Eric Dumazet wrote:

>>
>>     Why not re-using is_skb_wmem() here ?
>>     Testing != sock_edemux looks strange.
> 
> All non-wmem skbs was cloned and then was freed already.
> After pskb_expand_head() call we can have:
> (1) either original wmem skbs 
> (2) or cloned skbs: 
>  (2a) either without sk at all,
>  (2b) or with sock_edemux destructor (that was set inside skb_set_owner_w() for !sk_fullsock(sk))
>  (2c) or with sock_wfree destructor (that was set inside skb_set_owner_w() for sk_fullsock(sk))
> 
> (2a) and (2b) do not require truesize/sk_wmem_alloc update, it was handled inside pskb_expand_head()
> (1) and (2c) cases are processed here.
> 
> If required I can add this explanation either into patch description or as comment.
> 

sock_edemux is one of the current destructors.

New ones will be added later. We can not expect that in two or three years,
at least one reviewer will remember this special case.

I would prefer you list the known destructors (allow-list, instead of disallow-list)



> Btw I just noticed that we can avoid cloning for original skbs without sk.
> How do you think should I do it?

Lets wait a bit before new features...

