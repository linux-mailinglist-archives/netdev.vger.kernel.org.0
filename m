Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2023313A2
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCHQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhCHQmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:42:52 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FDFC06174A;
        Mon,  8 Mar 2021 08:42:52 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i8so10607175iog.7;
        Mon, 08 Mar 2021 08:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BNlx4YPfM1nidlUove0a2nwdF4iPwX2FX54lO9BqECo=;
        b=PrcHqWM7PnbSdR1uQ2JziJWlKjjLrk2YVlkPA6r/nL9C/TPD9MIerRj2HQKQ71IvB5
         JZU4S05UPtRRGfcpGqJtEnZv4A7oASYA2vliIUFOdfFaoWy2tITkB2UETbyZ9QQ6EjCJ
         KUjWfSANCUvDkJYwX9160gXx8laQ8HA5OFt9Jcjv63VLYFq7e7Q7812gxrMeSAx9Rc2y
         HCRy9naWrSGM4I0ISYuLtmW5rYiX/RKy0a7rg7uJfNC5W8IkWhZ/hbIcpLkATg8bTaaJ
         uwcj/UHKS1bqp8Qf7+5Jddb55e5G5zDtBp/9y3nZBfCZAl3WYaW4VhQ234YZY1hBZPuw
         G+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BNlx4YPfM1nidlUove0a2nwdF4iPwX2FX54lO9BqECo=;
        b=kNLzruWJJepRVn7Ab6CavNZY2IxmyDii6tACNCzPSnjg+c6p0ZLuA62YSyy79+e8KO
         zJuOVPzRMXfrzMm5v9PO+iDIen9ieCr84F9PCN/0Kto1Htvya9R2B3aX67/Q8DOzQUGt
         6bwOaWy33x8wOP9dwPvwHFbjd2kQCOISCwwMxU8temcnblSuXtZSB/kizFEpCI9YWJuE
         ty/gcN69hBvom0jNPs3gKHChcJBhwJZz+Zqyvymd3Fpb9GXoHkd5J1+KAe/O7trHwV0U
         djiIz/tk5NQ6oSYaqNc3dU9N9gSvgH3t4bSe7ttewb/YroclLFzwOoLz4X3ujccg8YoV
         0Yxw==
X-Gm-Message-State: AOAM5322MNDtyg3rcVBUvMykMQiNZ+YsVqgqFpOvhSIA7gYClLO0feyd
        BQ5ua3/SiY8oybJW7VDk+p0=
X-Google-Smtp-Source: ABdhPJzIqKfSoF0sdk0JhHyfLAp1Hk3pGQs1ueevQq3Q58YZsgerxVcRu7ZhXkyZOXOPDB84Yy0r/g==
X-Received: by 2002:a6b:7302:: with SMTP id e2mr19112165ioh.106.1615221771648;
        Mon, 08 Mar 2021 08:42:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id k10sm6291465iop.42.2021.03.08.08.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:42:51 -0800 (PST)
Subject: Re: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment when
 mpls_hlen == 0
To:     Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
References: <cover.1615199056.git.bnemeth@redhat.com>
 <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
 <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
 <718e4f13-31a8-037c-9725-08ae3cd93ccd@gmail.com>
 <543ebc518aa31f04bb6a85b66f37d984ede4b031.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1fc417e-946b-6e92-3650-865834c289f3@gmail.com>
Date:   Mon, 8 Mar 2021 09:42:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <543ebc518aa31f04bb6a85b66f37d984ede4b031.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 9:26 AM, Balazs Nemeth wrote:
> On Mon, 2021-03-08 at 09:17 -0700, David Ahern wrote:
>> On 3/8/21 9:07 AM, Willem de Bruijn wrote:
>>>> diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
>>>> index b1690149b6fa..cc1b6457fc93 100644
>>>> --- a/net/mpls/mpls_gso.c
>>>> +++ b/net/mpls/mpls_gso.c
>>>> @@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct
>>>> sk_buff *skb,
>>>>
>>>>         skb_reset_network_header(skb);
>>>>         mpls_hlen = skb_inner_network_header(skb) -
>>>> skb_network_header(skb);
>>>> -       if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
>>>> +       if (unlikely(!mpls_hlen || !pskb_may_pull(skb,
>>>> mpls_hlen)))
>>>>                 goto out;
>>>
>>> Good cathc. Besides length zero, this can be more strict: a label
>>> is
>>> 4B, so mpls_hlen needs to be >= 4B.
>>>
>>> Perhaps even aligned to 4B, too, but not if there may be other
>>> encap on top.
>>>
>>> Unfortunately there is no struct or type definition that we can use
>>> a
>>> sizeof instead of open coding the raw constant.
>>>
>>
>> MPLS_HLEN can be used here.
>>
> 
> What about sizeof(struct mpls_label), like in net/ipv4/tunnel4.c?
> 

I was thinking MPLS_HLEN because of its consistent use with skb
manipulations. net/mpls code uses mpls_shim_hdr over mpls_label.

Looks like the MPLS code could use some cleanups to make this consistent.
