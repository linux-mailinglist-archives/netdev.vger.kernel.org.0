Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A68D1FA9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfJJEa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:30:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34298 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfJJEaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:30:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so2833261pgl.1;
        Wed, 09 Oct 2019 21:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AT1qXEvZ+lQA7q1Z71j11lVp8JI+71RILIKUCFl5DKI=;
        b=bf70iZzyYJHlRpq3VlAxj/4S5gY1uZNsyF6fU1xHSUCByV+eMZBMvgaCY7OC0WGGI5
         xy/2Lg09kPSUy2iEaUpTWfJk38pJTVfUp7n8OkH5axKB0NoWP/khROfd61VTuvF9XBn4
         NXwgnGb8EVFJyku92dH2NlmnQgiIA1Ov7pHUVMWO64r258kPf3lAO9EwRRH4k1BIf5V6
         Tq4OlS79M6v7lgBpYqNnBfgysdvyTxqFP9yrpwRtOFOSrHTW0bqGyiTSDN2SFKynU660
         nhgtimefy+yoxqPiJfNaMFQFV+c73rJAeBnS9DM663vNuus7QCAdW7uQvFq7cxu3SbLa
         h2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AT1qXEvZ+lQA7q1Z71j11lVp8JI+71RILIKUCFl5DKI=;
        b=WyY9cL7gcPJiD1F9KsJAJP6WpLEp4VHQfdUwgD45DOnH06sVbwoSHQBAXnkXqe6xFW
         NaoS+/XVcI8Tlo6nQX2K03iBXg7xFEkQ58jwjmizkGj8+uQAMGpjgdTSiGuLEc1Df+qh
         fpq432SOpsZLdx6KRELQu+SX2qR9R9srVw8qPNa3I0BnpHbaoidjEALSMiXgZaapqv7M
         +aKUB8LuAIFUZUyz9sbc88wVK9RKgP/X3Bg3kSZdgW5TSe+S5ClHE3X+hYpAUKhf1g0J
         h+VjmyWk0+rr/BZGp2aHU/77DqYr9vmHcQWZpOEU5l+Kd2VGDwKSJw2PO4QUXIQVHR3d
         iqYw==
X-Gm-Message-State: APjAAAWEGW2zvzAvq8Vka0VvWhQRtPD9Am7RaaRzL0SiRrTvJ+Tc6Wzy
        thah3a9TC+V+T8BXgw25/wA=
X-Google-Smtp-Source: APXvYqxAGi9RKiZZfYMaYp3blstGL8vkWv2x/vmRLdHFU7Vu+wMMTuEUBcdFzSMOO4Ll9Tn6GCVuMA==
X-Received: by 2002:a17:90a:f495:: with SMTP id bx21mr8347624pjb.84.1570681824990;
        Wed, 09 Oct 2019 21:30:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i132sm3404043pgd.47.2019.10.09.21.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 21:30:24 -0700 (PDT)
Subject: Re: [PATCH net] netfilter: conntrack: avoid possible false sharing
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20191009161913.18600-1-edumazet@google.com>
 <20191009212451.0522979f@cakuba.netronome.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b7193d5-c93f-b81a-f4a0-ad63ed8196c3@gmail.com>
Date:   Wed, 9 Oct 2019 21:30:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009212451.0522979f@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/19 9:24 PM, Jakub Kicinski wrote:
> On Wed,  9 Oct 2019 09:19:13 -0700, Eric Dumazet wrote:
>> As hinted by KCSAN, we need at least one READ_ONCE()
>> to prevent a compiler optimization.
>>
>> More details on :
>> https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
>>
>> [...]
>>
>> Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
>> Cc: Florian Westphal <fw@strlen.de>
> 
> Applied, thank you. 
> 
> Not queuing for stable, please let me know if I should.
> 

This is fine really, thanks.
