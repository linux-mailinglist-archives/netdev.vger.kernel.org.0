Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314883AE1DA
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 05:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFUDWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 23:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhFUDWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 23:22:19 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B3DC061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 20:20:04 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id f3-20020a0568301c23b029044ce5da4794so9703357ote.11
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 20:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZJJLjcRf47PkBn+hTEvAsOyUR1nX+g7azGbAsPG0uaQ=;
        b=WLVHclR8Cm3qQ+Xr3oW7QVncxGYTQGxn5SEP3d8mceP3TWnSE7f/txO30zTg/K9FWy
         7ut23OSVcbBIcTEyinfzSd/8y68a5Ip5EGz0Out3hRwLkZnum5754iR2fDUqSj99ixVt
         ZdCyWQ37nj72kf8tnjisk0I+A2wysuZjlDFmOnVHGKc5GInMS5PjBRoRDd5IrByjuwpR
         L95+P7udm59wvzpjFVejnCw4NBAs8n/phOL0wDygxkJPltitp68KpTwQ6DeMTb+w3yrG
         gqrhu/QjeCvkSrCLwJw3pgYaE1YB7ZKELvNvdNbJfEDNVie70//NFfAaCmUD78FbP7Lu
         Uqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJJLjcRf47PkBn+hTEvAsOyUR1nX+g7azGbAsPG0uaQ=;
        b=AmOMtfijE1ij1wGhA7CauD0TUkiNAEaEQ9od5vR18YrD1P2bovBnyNihI9vWKRNeZc
         6KB/vkL1AIsYyucFVkAQyDp326uXcOFZDn2l7QN29qRfnkwtCysH0FA36ky01GkNsPX3
         soSf7YCyI3nQq+G4RO5tjJR0Zxm7KgxU+jfcveeawmSUZSIkuQyvs9YRaTuShjFSnmHY
         JgWRnsM5Em+lOL0N9YiMtE/uRuZKhq44SRzVDcuC7+UL7293Nx/64m2KzDvp6Zb8H1wf
         0QeMWiMy8ZrzCp25u1zbs/g6UhdDX507MXvHHXR9aD0Ib3AkTENJvH9wF5IMc6KO5eI/
         q2Dg==
X-Gm-Message-State: AOAM530w6jWKxnQLgB8O6Llay2S5q/Mz+PToKzDNzXkZMlHW6a+ILAaE
        Sciq3GqJvqOia2gMNysONRg=
X-Google-Smtp-Source: ABdhPJxMo+erjiCDahTK7E21HDTj9pAywc3EZX7ZHkAjA/UW/7M8DMLwdLEzJLG8GdHO/KJx+Q5FXQ==
X-Received: by 2002:a9d:674b:: with SMTP id w11mr11587795otm.260.1624245603817;
        Sun, 20 Jun 2021 20:20:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id l2sm3850519otl.27.2021.06.20.20.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 20:20:03 -0700 (PDT)
Subject: Re: [PATCH net] vrf: do not push non-ND strict packets with a source
 LLA through packet taps again
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20210618151553.59456-1-atenart@kernel.org>
 <16920ba3-57b7-3431-4667-9aaf0d7380af@gmail.com>
 <162419114873.131954.7165131880961444756@kwain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <231434ea-9eb0-28c8-baab-cf979cdf7e47@gmail.com>
Date:   Sun, 20 Jun 2021 21:20:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162419114873.131954.7165131880961444756@kwain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/21 6:12 AM, Antoine Tenart wrote:
> Quoting David Ahern (2021-06-19 03:18:50)
>> On 6/18/21 9:15 AM, Antoine Tenart wrote:
>>> --- a/drivers/net/vrf.c
>>> +++ b/drivers/net/vrf.c
>>> @@ -1366,22 +1366,22 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
>>>       int orig_iif = skb->skb_iif;
>>>       bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
>>>       bool is_ndisc = ipv6_ndisc_frame(skb);
>>> -     bool is_ll_src;
>>>  
>>>       /* loopback, multicast & non-ND link-local traffic; do not push through
>>>        * packet taps again. Reset pkt_type for upper layers to process skb.
>>> -      * for packets with lladdr src, however, skip so that the dst can be
>>> -      * determine at input using original ifindex in the case that daddr
>>> -      * needs strict
>>> +      * For strict packets with a source LLA, determine the dst using the
>>> +      * original ifindex.
>>>        */
>>> -     is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
>>> -     if (skb->pkt_type == PACKET_LOOPBACK ||
>>> -         (need_strict && !is_ndisc && !is_ll_src)) {
>>> +     if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
>>>               skb->dev = vrf_dev;
>>>               skb->skb_iif = vrf_dev->ifindex;
>>>               IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
>>> +
>>>               if (skb->pkt_type == PACKET_LOOPBACK)
>>>                       skb->pkt_type = PACKET_HOST;
>>> +             else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
>>> +                     vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
>>> +
>>>               goto out;
>>>       }
>>
>> you are basically moving Stephen's is_ll_src within the need_strict and
>> not ND.
> 
> That's right.
> 
>> Did you run the fcnal-test script and verify no change in test results?
> 
> Yes, I saw no regression, and the tests Stephen added were still OK.
> 
> Antoine
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

