Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE12E159925
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgBKSuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:50:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36512 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgBKSuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:50:50 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so4624000plm.3
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 10:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6lEDHRFOlcXjrp5Q5eSsi/cHTEGkzjD0PlGuHdBxnqo=;
        b=d8oekofX9+Dq/D7Jf+cbWXqtCY/EmXlpQeHZnnQmeWSVwj/lA0YRkotRRegOsSjozv
         7beNtOt+D6ItjI7lOc0oImLIjqp8WQ7gf+TqKqaTNSinpVEx8PtV0PeFHT0U65ZJPJpq
         FuLpREjvaz5J9u0UypDONs0oQWc52jMSBnNGWd5Hc08y5jOizAYajHS1epVhSoqUdNAO
         ooVgT0XWRVTwDQOe4zpr47D5S8XD8iHSL81/GnikQllPuQQNP9wzMqUEsVvJOIcaoerM
         XLDl4fc+iVFn5c+KJ/Y0BiSXniu+iJbjI8EsmRxdBEgXsYhRBYcvup4kt/Mzt1OWV4ny
         jtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6lEDHRFOlcXjrp5Q5eSsi/cHTEGkzjD0PlGuHdBxnqo=;
        b=FR388og3uJBmO8fIu1ppHFoyQfixQ8066GFc+9fetnAFpg6dUck7PuVR2ajYS2RusW
         wXVroznwBJGPCsdhme1m9fNjaGWJUvyPhTkKNRGL90ZwlkoB4DIboW/CZM1RkGJJOVsL
         eppZeJCUf1dj7XdYQClb/l6eOLTbIiAJbsCtJYP2Mu5Cyj52r5mg8556SPvwTzxBkqul
         InI5NMYU5TySK4RNraBMzD1JKWfzflJJDxvvVhc3XcMmUd6kdizMnUKUQWXbQn5dY66s
         cpWIpO1Z/91GW8vzfVIzZefsBJWSXp75jcMusBPOhUpLzhCtTq7Gqls+pY69pMcvjHCV
         ChEA==
X-Gm-Message-State: APjAAAXbeaTByN7Ov1rKGO97hZeDdGQomRK7BlxO+aT98lJp0RFB3opf
        V28yq19kLyLehQQl+MScLxs=
X-Google-Smtp-Source: APXvYqyyNFPQxG4SHoo6yJRwm+BiWhUpIaW8DV6eIIg50EksuXLwo25qoNq70aFMebGl9NA47vMOVQ==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr5200675pjn.117.1581447050159;
        Tue, 11 Feb 2020 10:50:50 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r7sm5178652pfg.34.2020.02.11.10.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 10:50:49 -0800 (PST)
Subject: Re: [PATCH v3 net 7/9] ipvlan: remove skb_share_check from xmit path
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Florian Westphal <fw@strlen.de>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
 <20200211150028.688073-8-Jason@zx2c4.com>
 <db688bb4-bafa-8e9b-34aa-7f1d5a04e10f@gmail.com>
 <CAHmME9o07Ugxet7sKHc9GYU5DkgyDEYsx36+KyAt7PAVtQRiag@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9c36a95d-aed7-0b63-ccda-8cd49ad97d8f@gmail.com>
Date:   Tue, 11 Feb 2020 10:50:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHmME9o07Ugxet7sKHc9GYU5DkgyDEYsx36+KyAt7PAVtQRiag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 9:44 AM, Jason A. Donenfeld wrote:
> On Tue, Feb 11, 2020 at 6:39 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Yes, maybe, but can you elaborate in this changelog ?
>>
>> AFAIK net/core/pktgen.c can definitely provide shared skbs.
>>
>>      refcount_inc(&pkt_dev->skb->users);
>>      ret = dev_queue_xmit(pkt_dev->skb);
>>
>> We might have to change pktgen to make sure we do not make skb shared
>> just because it was convenient.
>>
>> Please do not give a link to some web page that might disappear in the future.
>>
>> Having to follow an old thread to understand the reasoning is not appealing
>> for us having to fix bugs in the following years.
> 
> Well, I don't know really.
> 
> Florian said I should remove skb_share_check() from a function I was
> adding, because according to him, the ndo_start_xmit path cannot
> contain shared skbs. (See the 0/9 cover letter.) If this claim is
> true, then this series is correct. If this claim is not true, then the
> series needs to be adjusted.

The claim might be true for a particular driver, but not others.

ipvlan has a way to forward packets from TX to RX, and RX to TX,
I would rather not touch it unless you really can make good arguments,
and possibly some tests :)

I am worried about a missing skb_share_check() if for some
reason pskb_expand_head() has to be called later

      BUG_ON(skb_shared(skb));

> 
> I tried to trace these and couldn't totally make up my mind, hence the
> ALL CAPS mention in the 0/9.
> 
> Do you know if this is a safe presumption to make? It sounds like your
> opinion is "no" in light of pktgen.c? Should that simply be adjusted
> instead?

The key here is IFF_TX_SKB_SHARING, but really this is the intent.
I am not sure if all paths have been correctly audited/tested.

I am not saying your patch is wrong, I am unsure about it.
