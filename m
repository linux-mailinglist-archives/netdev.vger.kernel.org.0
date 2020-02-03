Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35473150F35
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgBCSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:18:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46672 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbgBCSSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:18:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so8224128pgb.13
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=19h+SkKmkwjK5sjA80T7a2detw2yj63kLrpBrzlDKOQ=;
        b=XqYmg8cBGK9qml4SikzCz2kEA69VfZeWUXBQN0y4d2EsEhiMcHRS5q/yo35IREPKBd
         DqTZ/B6eMTTz4LeHfDyriPsOb1buSfP+29R4oK2etUeicQT+P7shdvL6B/97RYIYR+4t
         HQs23skj2lACwHeGm62KkpsWCp305FKI2nfZfcfB26YJQ72jeNP6rVhk9xpYVlUDUMlr
         +XnFOk8uNy0RqtUb3xZY9VbJw5+khrT0exGvCdJHcJcP13l2A3dosTz+RJ5JykOXYZ2Y
         ZNjJV+Q75M+TlpkZ1W+Q38pWPq++q6gs2iVXEO3UO9kTJlYA+SQxyStHU9kPxUDYzQS9
         sd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=19h+SkKmkwjK5sjA80T7a2detw2yj63kLrpBrzlDKOQ=;
        b=H01abgAd7sHI9iCloN6Eh2u1plainRLcrXqlts5+LcEFlOasm8OtKanbO3n8evQygu
         HjwCmx00AZlsNBkv3Z8vRBqK9aUoxPsSHFBflVGUtRl91voEMi/orEJbKDqdBF4Vad0b
         yaLx4t2BTQTJ6I/et3fduzOgYLFbWmUIdHjVqTwkH9Ka3WBmPqsvzJUhPcYNGLonXdSY
         rLSVh5P62QNPv92huSTG/QlI6AjB+2eVbSUS0YziyPppYYdtn77lgpYbabTWfgnKcxDA
         mJ0PfZK4FMf3HBaT72yUBTq6ix7GPUk/HOIoZCj2AygV976igJllpHGVz80epdqFWHf1
         cqQg==
X-Gm-Message-State: APjAAAXa8colGTE869EZ096uGVhBRs1Pus7zOxEcv0MejzKrTzbZ27Yr
        Zl5N1DLYocwlk2C1OzrXSYKBDv2I
X-Google-Smtp-Source: APXvYqy3dgm2UinWLMRSE+BN4hd18krlyAntjm8bAfA6AgHLCpoxGpnguzORXe/VGboJfADG6k77Uw==
X-Received: by 2002:a63:cd15:: with SMTP id i21mr20893196pgg.453.1580753880481;
        Mon, 03 Feb 2020 10:18:00 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id l7sm10493447pga.27.2020.02.03.10.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 10:17:59 -0800 (PST)
Subject: Re: [PATCH net] wireguard: fix use-after-free in
 root_remove_peer_lists
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
References: <20200203171951.222257-1-edumazet@google.com>
 <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com>
Date:   Mon, 3 Feb 2020 10:17:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/20 9:29 AM, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Mon, Feb 3, 2020 at 6:19 PM Eric Dumazet <edumazet@google.com> wrote:
>> diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
>> index 121d9ea0f13584f801ab895753e936c0a12f0028..3725e9cd85f4f2797afd59f42af454acc107aa9a 100644
>> --- a/drivers/net/wireguard/allowedips.c
>> +++ b/drivers/net/wireguard/allowedips.c
>> @@ -263,6 +263,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
>>         } else {
>>                 node = kzalloc(sizeof(*node), GFP_KERNEL);
>>                 if (unlikely(!node)) {
>> +                       list_del(&newnode->peer_list);
>>                         kfree(newnode);
>>                         return -ENOMEM;
>>                 }
>> --
>> 2.25.0.341.g760bfbb309-goog
> 
> Thanks, nice catch. I remember switching that code over to using the
> peer_list somewhat recently and embarrassed I missed this. Glad to see
> WireGuard is hooked up to syzkaller.
> 

I will let you work on a lockdep issue that syzbot found :)



