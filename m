Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51D83B328E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhFXP3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhFXP3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:29:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3149C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:27:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l12so6409029wrt.3
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:subject:reply-to:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PzDOsz4dUMAwrPa1KQCzHsHNKY8qfIzsqCNnyWzyvto=;
        b=MXs/+nh1lufJBCLf7SBkx4EJV3gAu1htyzetvuazfB3DpFr3ZrndwgSH+BUHLDG2A+
         JeUpRicq46h/OeO/KtM5pg0TKjQbm0vEE4R58nfiCUwj6RiX5cHBNZ63w1ig7wa9lzuh
         anAoHV8WyVZvKwrN4MLhRJouluLrE3xE7X5+jqhUDAeKwSjLzBH8USQHyVnoLrGhylgK
         bICG4RcToUCxrVxc7P5pFqez41dRbAQ6EbXW0akao9nquwj6IW5nquLWafIZBRwWKk3p
         OiGy2b7KVumNigjc8gulbki7N41fd6iF6cCzsVjc/8tqZVi68GyTjdi9MfWPhrFMUHB0
         2nyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:reply-to:to:cc:references
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PzDOsz4dUMAwrPa1KQCzHsHNKY8qfIzsqCNnyWzyvto=;
        b=oSZfkKv3Yu43DGl6yEsuVfIaA9xZjO2dVWeEp0oaIHVMkfb8HgThLWfTdCkPgfpMtx
         a3SSchDjDKRZH3Empc12KQ2ZXpABwBzf545Z2EZxAT0ZNjCY3IgIq62FxmYP+GBUKqUE
         HhI9GXRI3b6dNjwcaTi2J/5GxAZ9TOiKT6D99U/pW3udXOuQDs78txq1kDJOeza/nt4r
         SwcMX5w9HNFtnHKiUauYNhv59FtV+aiJsaZOuM7+ZphD/GrG7GEwgtZp24M2iLNnU1gY
         n1fYjlL+1lFsHQgR+QRwB+4WnARVLpIfVP4v9cmL7/WCyrs/p40DPwEl4Aq+S1zvCGgR
         LDiQ==
X-Gm-Message-State: AOAM5301G9YKHrLR7OIqL0VwO8lpn6fH7gQp8t9s7r3JO4EPIWYw2nd9
        PUkuJo2NW6NvnASqQ9v3LazMzQ==
X-Google-Smtp-Source: ABdhPJxS0r/LbpPRdOtsqAkBHAvWZWQn60lbouVOLpyLnJjDMl34+lvzucJSOYadr4/c4R7UWa25Aw==
X-Received: by 2002:adf:cd88:: with SMTP id q8mr5249855wrj.181.1624548420345;
        Thu, 24 Jun 2021 08:27:00 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:48d1:d5b6:5b87:8a6e? ([2a01:e0a:410:bb00:48d1:d5b6:5b87:8a6e])
        by smtp.gmail.com with ESMTPSA id l22sm4081907wrz.54.2021.06.24.08.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 08:26:59 -0700 (PDT)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net] dev_forward_skb: do not scrub skb mark within the
 same name space
Reply-To: nicolas.dichtel@6wind.com
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        liran.alon@oracle.com, shmulik.ladkani@gmail.com,
        daniel@iogearbox.net
References: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
 <ad019c34-6b18-9bd8-047f-6688cc4a3b8b@gmail.com>
Organization: 6WIND
Message-ID: <773bae50-3bd6-00bc-7cc6-f5eec510f0b8@6wind.com>
Date:   Thu, 24 Jun 2021 17:26:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ad019c34-6b18-9bd8-047f-6688cc4a3b8b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

Le 24/06/2021 à 14:16, Eyal Birger a écrit :
> Hi Nicholas,
> 
> On 24/06/2021 11:05, Nicolas Dichtel wrote:
>> The goal is to keep the mark during a bpf_redirect(), like it is done for
>> legacy encapsulation / decapsulation, when there is no x-netns.
>> This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
>> mark within the same name space").
>>
>> When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
>> 8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
>> second argument (xnet) was set to true to force a call to skb_orphan(). At
>> this time, the mark was always cleanned up by skb_scrub_packet(), whatever
>> xnet value was.
>> This call to skb_orphan() was removed later in commit
>> 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
>> But this 'true' stayed here without any real reason.
>>
>> Let's correctly set xnet in ____dev_forward_skb(), this function has access
>> to the previous interface and to the new interface.
> 
> This change was suggested in the past [1] and I think one of the main concerns
> was breaking existing callers which assume the mark would be cleared [2].
Thank you for the pointers!

> 
> Personally, I think the suggestion made in [3] adding a flag to bpf_redirect()
> makes a lot of sense for this use case.
I began with this approach, but actually, as I tried to explain in the commit
log, this looks more like a bug. This function is called almost everywhere in
the kernel (except for openvswitch and wireguard) with the xnet argument
reflecting a netns change. In other words, the behavior is different between
legacy encapsulation and the one made with ebpf :/


Regards,
Nicolas

> 
> Eyal.
> 
> [1]
> https://lore.kernel.org/netdev/1520953642-8145-1-git-send-email-liran.alon@oracle.com/
> 
> 
> [2] https://lore.kernel.org/netdev/20180315112150.58586758@halley/
> 
> [3]
> https://lore.kernel.org/netdev/cd0b73e3-2cde-1442-4312-566c69571e8a@iogearbox.net/
