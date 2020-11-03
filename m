Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77F2A4E1F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgKCSQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgKCSQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:16:33 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB8BC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 10:16:32 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id h22so238541wmb.0
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 10:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I09KzPQvkis8PkKizwbhy7q3S2vVghUZJ/0kEo4CnXs=;
        b=hw7bkZxoYtW6BHqk8Z1gNBJuiyGXWRCZ3wqJb8T9EKVc1O5tayu3IsvWCSCA22q2wq
         SOzt4opGJaRZMIfHAx9Zhiht5WxUHnYoyaCQbbLlN99fu/tuWU8qgRoQtxBWMB/u0d1v
         vu//CxyLKWHVYWXzGXmdfbz3msfIagbAtjhIS0zZbrjo/qUojbN+RK/VNx+6mW7Kyrfo
         zejMB7MlR8ev1Bzx9m9YYwf8QjlaJ23DYuU/5SOQdt9TXL8jczRLjABp4me7w26M8A4c
         ydRNc22xOe28v3ihOjpc277iQ+TVX1YXMZJnx3qzm7l3GGL7GljpDZWNeUV57WwUysKi
         y1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I09KzPQvkis8PkKizwbhy7q3S2vVghUZJ/0kEo4CnXs=;
        b=maq8af9b6HJE2dbhMaMKKS+c2uosj1GjNFiNYPWCCx+AtVceVhsrv9ugd0DqXm1PTo
         o7fybuZMgjH+zDxSaqSag+feWlCnEK17CQSRlLe/J0VIkfTZZDaXx4DxQ3EFwLbYnmYB
         WCdFP1uGrDQiF9Q7OWX9dJSPwtCyHspVdwZEQsfRg7C5XR7eiFwQGmQD9qDbUZJ4L33o
         axjiaK+MmPrr0w9s+x4HTLJeH0DcReUaFA4siIrgEqcVZURYZ9IMw7WcgfyAOUIq5FWS
         f1vS7Rq5p/VbOC1MgAhwz/JubBueMTSul2EqCyXqlWFnBGASaeqZ2qyj+a+VkaBkpihG
         B3Dg==
X-Gm-Message-State: AOAM531kYAketoPMDKeoqeKACBmB8d9M5J+6suqxrfOYf2++V4oDAp/O
        Srg0W7Ysw4VwWyDQw9Zfd9U=
X-Google-Smtp-Source: ABdhPJznqhUT4a9ghpV/OZZHN+l+gXJXF70JgJXh4rTRJpYZVoBvwhkYXSnKbABLo2aBNNnFXjSfjA==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr466768wmc.8.1604427391626;
        Tue, 03 Nov 2020 10:16:31 -0800 (PST)
Received: from [192.168.8.114] ([37.171.35.74])
        by smtp.gmail.com with ESMTPSA id n22sm3162911wmk.40.2020.11.03.10.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 10:16:30 -0800 (PST)
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
To:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
 <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103174906.ttncbiqvlvfjibyl@skbuf>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <19c3385d-7974-b5bd-3d5a-51d3d87919b0@gmail.com>
Date:   Tue, 3 Nov 2020 19:16:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201103174906.ttncbiqvlvfjibyl@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/20 6:49 PM, Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 05:41:36PM +0000, Claudiu Manoil wrote:
>> This is the patch:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d145c9031325fed963a887851d9fa42516efd52b
>>
>> are you sure you have it applied?
> 
> Actually? No, I didn't have it applied... I had thought that net had
> been already merged into net-next, for some reason :-/
> Let me run the test for a few more tens of minutes with the patch
> applied.
> 

I find strange that the local TCP traffic can end up calling skb_realloc_headromm() in the old kernels.

Normally TCP reserves a lot of bytes for headers.

#define MAX_TCP_HEADER     L1_CACHE_ALIGN(128 + MAX_HEADER)

It should accommodate the gianfar needs for additional 24 bytes,
even if LL_MAX_HEADER is 32 in your kernel build perhaps.


