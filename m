Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C788FDB8
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfHPIX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:23:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36620 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbfHPIX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 04:23:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so738913wrt.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 01:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TTv7ICEmJhqzfI5qGfgcsvSh9+fw95MkNOOVAZ/4kR8=;
        b=prY9zdy3xD3MpauN4Yf4eipXfCMngHI1u1pRYs2DqAJm0lFrVY089aIUa7s5z5Y8yJ
         2kt3KUikDvDWp5iV75M490/X5HpZshu2Vw/xRPpyFYy1gIYI4nkPspYllvqiXF8+/eML
         9khxs7C19YYBFwGWovY0mVgxvGbOK1InkCVU6XsT/agCg98BKEXZlcz+6Gz4sT3/kcfa
         cM6fsZgnACJHfo2VJCfy7mWTQD3IN+gvqHQkiD7ec2GYQ4d8s03+VV+Es1TLUO2aK3jv
         jXEG5tYm1cZj38TDDcl6/qynVN/bqFBX9XsA2dyJVbEqLm05zuwpCe0U9TbT2k0e2GOi
         7o0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TTv7ICEmJhqzfI5qGfgcsvSh9+fw95MkNOOVAZ/4kR8=;
        b=c2BXAq9eWwub6/H0Mt7l2PZTkw5kRShMfps08XbV+WRJTeaL9VUfhN5nv91esCGXy0
         uTdQv8awvayuOlYyw4pvAFD5u5miF1LZAQCcHDAkkUPsXpV4Ebqi2d1jNRmmoK3qVZRj
         SRogSybc7x/n2uhqmlG60N2chBpY94gxVUjpqsK3OT4sX5aCQFULI1rh0TN3SUxpsUkE
         BGzxbpIU/6h5CZr0F+FZhM1+7ZbPH8p4xzkxXJO3j93mUB1TG7YR/USp3xFvAu9NK6yb
         RDX8zh1g5Dk1aAOcL8KFs+7Mqs+yUCmMyeojcMjVo47M+0/jQfbmNSjw7nurk7tbiltT
         hZtQ==
X-Gm-Message-State: APjAAAXWJBcgrexBTN1lQLykzguj79CLRIwX++tuTtd/QbC1MYKngZeW
        s3QhnzpJRTuBBYPQhV9XHug=
X-Google-Smtp-Source: APXvYqxmlRjxnEpeAmes3XBx29lSNZv1x7GcSVRjCFV75BE9rR3t5d6g251sVfz1b0noxcZ6e0kJpw==
X-Received: by 2002:adf:bace:: with SMTP id w14mr8180449wrg.283.1565943836974;
        Fri, 16 Aug 2019 01:23:56 -0700 (PDT)
Received: from [192.168.8.147] (187.170.185.81.rev.sfr.net. [81.185.170.187])
        by smtp.gmail.com with ESMTPSA id f6sm8786693wrh.30.2019.08.16.01.23.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 01:23:56 -0700 (PDT)
Subject: Re: [PATCH net] tunnel: fix dev null pointer dereference when send
 pkg larger than mtu in collect_md mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
 <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fe103dee-bba8-1e0d-83b2-f91c2c37089d@gmail.com>
Date:   Fri, 16 Aug 2019 10:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/19 5:24 AM, Hangbin Liu wrote:
> Hi Eric,
> 
> Thanks for the review.
> On Thu, Aug 15, 2019 at 11:16:58AM +0200, Eric Dumazet wrote:
>>> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
>>> index 38c02bb62e2c..c6713c7287df 100644
>>> --- a/net/ipv4/ip_tunnel.c
>>> +++ b/net/ipv4/ip_tunnel.c
>>> @@ -597,6 +597,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
>>>  		goto tx_error;
>>>  	}
>>>  
>>> +	if (skb_dst(skb) && !skb_dst(skb)->dev)
>>> +		skb_dst(skb)->dev = rt->dst.dev;
>>> +
>>
>>
>> IMO this looks wrong.
>> This dst seems shared. 
> 
> If the dst is shared, it may cause some problem. Could you point me where the
> dst may be shared possibly?
>

dst are inherently shared.

This is why we have a refcount on them.

Only when the dst has been allocated by the current thread we can make changes on them.

