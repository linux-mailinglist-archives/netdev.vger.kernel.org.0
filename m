Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B557A331335
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCHQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhCHQRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:17:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30C2C06174A;
        Mon,  8 Mar 2021 08:17:14 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id k2so9326350ili.4;
        Mon, 08 Mar 2021 08:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NEZnGRLyGUv6j7TBBXQHVAxZPQHAwJbm1fTojXbpoFk=;
        b=Cho/P6nHpddiaz/cI1Z1BsYnIITIQzQDsk046xSUrqx8QMsc8lymC8Zvpqvnk93caH
         oym9P1XKRpUdJideJc/wyuG4gidGl313q71cT9fYHCJp6jTMGw6Abk2CHRTgCudmJjld
         eqGo7w1zwJU5IBG4XY/2pP0S1Ygw6Iazs8a+na2aU9T0tGFTnSpCqK3e+s/tJUiifeiP
         gb2UgxGvD8a8ZhX7azlyeC1jQGywcjJnDmz3OB4+oVvhwjHkokmEMSutsPeDR5MXiKSl
         Y+D+cV+bLkzs8Kt1xvIuNkjoXrpgArxisoKOInGmLnpSxaLYhq69OCb/ine50c4/Cz2V
         5bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NEZnGRLyGUv6j7TBBXQHVAxZPQHAwJbm1fTojXbpoFk=;
        b=mezlrFwa7pwweVImXlGDvGXu60kb/dRuCdYorQlgzqVS9ilZ9DBdqot5Dg+Ydgs/D5
         Ry9QGcPHpp8WC+lycQO4+iX6cY0/Mk4xnQ1RJY5M4nK9cLeec2ITAR6WUdUmV1ZrFwp/
         ejWT8I4L7JsyYUr92mLMtIoUgaX+b6z2gRWrEQsOQcGHj962Qnj9Ashh321/wmNyf7ie
         pjQ9R2KEd/eUUNCz2Y04N6FG++cH+OgN92qCcG6no5dBIZLHZuATRKVi+aJdxzAVi5BP
         TAwIgO07N0eRFpqeaiEQDK17XX9TWIjNaF0xHbFJsp9vLbbwWcfEVl9S8I9b3uawJRHu
         v+Sg==
X-Gm-Message-State: AOAM5307/muIrpOhpkQRANrRT18SblSvXtbbtx7DN49ZWe8IsQUYddLw
        p79AFfbU5frOlblDC8dfzhhXH/cA/o8=
X-Google-Smtp-Source: ABdhPJxtkcRFaiLSBFPuVKHol/kRwMdooHx08HbsN3kfIwciuc+ZcnOsk7VC7YWo9CENtqqQ57cLcA==
X-Received: by 2002:a05:6e02:12e3:: with SMTP id l3mr20948602iln.24.1615220234437;
        Mon, 08 Mar 2021 08:17:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id 128sm6201496iov.1.2021.03.08.08.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:17:13 -0800 (PST)
Subject: Re: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment when
 mpls_hlen == 0
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
References: <cover.1615199056.git.bnemeth@redhat.com>
 <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
 <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <718e4f13-31a8-037c-9725-08ae3cd93ccd@gmail.com>
Date:   Mon, 8 Mar 2021 09:17:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 9:07 AM, Willem de Bruijn wrote:
>> diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
>> index b1690149b6fa..cc1b6457fc93 100644
>> --- a/net/mpls/mpls_gso.c
>> +++ b/net/mpls/mpls_gso.c
>> @@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
>>
>>         skb_reset_network_header(skb);
>>         mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
>> -       if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
>> +       if (unlikely(!mpls_hlen || !pskb_may_pull(skb, mpls_hlen)))
>>                 goto out;
> 
> Good cathc. Besides length zero, this can be more strict: a label is
> 4B, so mpls_hlen needs to be >= 4B.
> 
> Perhaps even aligned to 4B, too, but not if there may be other encap on top.
> 
> Unfortunately there is no struct or type definition that we can use a
> sizeof instead of open coding the raw constant.
> 

MPLS_HLEN can be used here.
