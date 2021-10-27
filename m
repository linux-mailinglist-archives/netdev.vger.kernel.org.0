Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4443D197
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbhJ0T2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhJ0T2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:28:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1D4C061570;
        Wed, 27 Oct 2021 12:25:35 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id r5so2754354pls.1;
        Wed, 27 Oct 2021 12:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NO5YnZQD6k9UxVk9cmsEPZ1u0i3nbwKrAR3MTinzS5M=;
        b=emrJUxsqqCVpXyUki4xia4HfR/f6xROGOip3q6Muj/iXZ4dHxWsJZIbps/VqOOOv7/
         oPe7dQrqv0QcypFEqvmiHjYhWoIsOGQfnOTEQWoIPnMqbzEMwDQtqCkLU+ZcV5om104+
         nSCeLCsm3mUf9e0/kJgkcdKaNizD4rmPgC++rYlZxL8zUvmBId+Y/0mJWlYQ1Itblva9
         kGrncl3q2+VDPcCjJHwMkxPrG8ndVFQtXqsJnMpJu4OBJY7lH+ixavc4ygp005Fhtqda
         3f+TLNaj/oo0iMi3+yab3BbdsRpJ0B2RM0lm1yiARMt2orFRPRFx2EfBx6Lri1JQarx+
         g74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NO5YnZQD6k9UxVk9cmsEPZ1u0i3nbwKrAR3MTinzS5M=;
        b=M3UlHLq+Mnagj5XU+YS/2yBO1fyJyP2Ytsi29c+11NoCuFu+VjauVRe4voh+i1WWJP
         lRzX1uYceBIYq7xaGD16MHsV3GvzPc+kS831PNRjatIir6kSkCMLNlM2qozyHBi24Y6z
         /EaYWfuRYLNnTn520k2Mi3L8hsQW+g26Pd/8rg3jTdSsMiFHJdZT8yaXgrPdSXfx8zjY
         cndVdYRZ1jSPrlnBiXDOzW4BGEo23Bdtz1V3DzBRVwcGoaVar7iD7Ocu4XmisM32Rh82
         j+PaIjURerK4NqdLmxzzCEpoCtshQgWW+rVDQPw9CseWgtikv9i4xrSzT7wFjnzl0B+9
         FXBA==
X-Gm-Message-State: AOAM5302vTTA4Ls43paSRp05APBbkZbboa5UMzk4yT4LW3Lqq3u8+Fag
        lR05Grr8u5jePiMc2ccYqaA=
X-Google-Smtp-Source: ABdhPJzPlAJPo57f2XE1Yi3c54OZQl/DRLAVmSd2rnX7WkLHZB43RsyoG8DWWncI1ZtnGKyiK0WVJg==
X-Received: by 2002:a17:90a:5992:: with SMTP id l18mr7716716pji.127.1635362735041;
        Wed, 27 Oct 2021 12:25:35 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f8sm480967pjq.29.2021.10.27.12.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 12:25:34 -0700 (PDT)
Subject: Re: [PATCH net] net: gro: set the last skb->next to NULL when it get
 merged
To:     Jason Xing <kerneljasonxing@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        alobakin@pm.me, jonathan.lemon@gmail.com,
        Willem de Bruijn <willemb@google.com>, pabeni@redhat.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
 <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
 <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1b40f49d-1dd0-5bec-2a08-f55ac3529da3@gmail.com>
Date:   Wed, 27 Oct 2021 12:25:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/21 1:07 AM, Jason Xing wrote:
> On Wed, Oct 27, 2021 at 3:23 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>>
>> On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
>>>
>>> From: Jason Xing <xingwanli@kuaishou.com>
>>>
>>> Setting the @next of the last skb to NULL to prevent the panic in future
>>> when someone does something to the last of the gro list but its @next is
>>> invalid.
>>>
>>> For example, without the fix (commit: ece23711dd95), a panic could happen
>>> with the clsact loaded when skb is redirected and then validated in
>>> validate_xmit_skb_list() which could access the error addr of the @next
>>> of the last skb. Thus, "general protection fault" would appear after that.
>>>
>>> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
>>> ---
>>>  net/core/skbuff.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index 2170bea..7b248f1 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>>>                 skb_shinfo(p)->frag_list = skb;
>>>         else
>>>                 NAPI_GRO_CB(p)->last->next = skb;
>>> +       skb->next = NULL;
>>>         NAPI_GRO_CB(p)->last = skb;
>>
>> Besides, I'm a little bit confused that this operation inserts the
>> newest skb into the tail of the flow, so the tail of flow is the
>> newest, head oldest. The patch (commit: 600adc18) introduces the flush
>> of the oldest when the flow is full to lower the latency, but actually
>> it fetches the tail of the flow. Do I get something wrong here? I feel
> 
> I have to update this part. The commit 600adc18 evicts and flushes the
> oldest flow. But for the current kernel, when
> "napi->gro_hash[hash].count >= MAX_GRO_SKBS" happens, the
> gro_flush_oldest() flushes the oldest skb of one certain flow,
> actually it is the newest skb because it is at the end of the list.

GRO only keeps one skb per flow in the main hash/lru.

I think you are not understanding GRO correctly.

