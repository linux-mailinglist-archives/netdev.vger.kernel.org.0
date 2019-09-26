Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BD2BF9EB
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfIZTQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:16:17 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36372 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfIZTQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:16:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so49719plr.3
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 12:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1iAiQX+JCpioikSZCLlXhF0q1kO+MQOLvWTNDhhvXOw=;
        b=G0tyGJLxvoNU0uff/AE/pc2f2y7lD/pgF98dr7B5xQdiSensW6c02qNlAuniSTkA/i
         7x41v/Cy9OGNHu36w5USU40pLEOtiquHcrAWJeZ1RKcnektyfAKbqlDE6Iv7TAgubVnw
         aQXo3EbJe6kJRLWaKKFiOUiV1UBpstr4RGBY3fmmOhXUO5bLW1Y95kNOghfJvpIRF+ri
         cX7Xw8E1sFmQsaAJO9wGHy56e2EjRVkXuUORNm7v3Gxbn+y9hVTHoy+lds6yubgjc0vF
         /cpZPAL/Pu8VYmHWsCAtPjE+A2a00HSXOJO2TxRHLslVxH7/VArZpjvkJG8gXY+Qf25r
         fhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1iAiQX+JCpioikSZCLlXhF0q1kO+MQOLvWTNDhhvXOw=;
        b=CfWXyV2itKUSkzZTU6oZvf133KDI7yT6DVM8oOBVWr/U8aeWq/TPm1otXcsASL4I19
         22ogp/mqJT+i9E05os1p1PeF+a+h4NkvLS3Z8ytyaRXjkH4Sk/N3AZs+FplYZnzRwIw+
         XOP3N5qwOMfnESan2hDHJA9r14DEOGk/tiWIumnWvnmCaReYY07lLl66DPOtHwt5SlTz
         mqzS3yAKhbliK7959aWCN5WEGvDaQZC5RqXXidwHABhnGBetwCmlPY1Riydifps7IIzl
         I75RaKv43ahbnzScGDQvK6Vx8adEelKz7cN5mStjZyn9FHA9fIjk/5+TOiDLI4si+DDw
         gcSQ==
X-Gm-Message-State: APjAAAUK0zw8QrZwHdy+CP3t1Nwer7/5VWPK9GEd6fge7WoCTU6sKtZ9
        WcSb8X1pHy7AT/XyL3klx+M=
X-Google-Smtp-Source: APXvYqyvDP6VKI4l369V2i9/SYhPSgPJf+NeO2YU8iVVxR/QwVYTZhRveSkBsXyDtr29KXq9mHajig==
X-Received: by 2002:a17:902:8bca:: with SMTP id r10mr133395plo.233.1569525376487;
        Thu, 26 Sep 2019 12:16:16 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b9sm43395pfo.105.2019.09.26.12.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 12:16:15 -0700 (PDT)
Subject: Re: [PATCH v2 net] sk_buff: drop all skb extensions on free and skb
 scrubbing
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        paulb@mellanox.com, vladbu@mellanox.com
References: <20190926183705.16951-1-fw@strlen.de>
 <1ad4b9f0-c9d4-954b-eafe-8652ea6ce409@gmail.com>
 <20190926190920.GC9938@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fce20607-baa3-eecf-6330-08a66d9097dc@gmail.com>
Date:   Thu, 26 Sep 2019 12:16:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926190920.GC9938@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 12:09 PM, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> -	secpath_reset(skb);
>>> +	skb_ext_reset(skb);
>>>  	nf_reset(skb);
>>>  	nf_reset_trace(skb);
>>
>>
>> It is unfortunate nf_reset(skb) will call skb_ext_del(skb, SKB_EXT_BRIDGE_NF),
>> which is useless after skb_ext_reset(skb) 
>>
>> Maybe time for a nf_ct_reset() helper only dealing with nfct.
> 
> Agree, but that seems more like -next material?

Sure.


