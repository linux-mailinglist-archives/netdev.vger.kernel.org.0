Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11540287E5D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgJHV64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHV64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:58:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6C2C0613D2;
        Thu,  8 Oct 2020 14:58:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u24so5487420pgi.1;
        Thu, 08 Oct 2020 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gl2SbsWOgmABu56kgPo4pH/0zc3IDICZmxrIpNqXfsc=;
        b=gEYivHnj94cFkJrK5Z52TFc1WGvwe36OtoYUoHIm2guq5S6oILnz/Ub+61t3z8LTsW
         fceFU61yAqVDzdBrplnSXF4mqorxWMCfhnzUDwcndPExyjCWi1aLrGDiWNKbCcH0Mu2a
         SPqy5f/UETZjg60IBwKHlzm1XTvk2ccWTSHWH98EDwxZaWZ52ret+YIOFxMOgdw9ONyD
         v4kfhmsY99yBUTC1OwqUAkQfyQobA2tTmcqnKI1ghrn1RFHcbRaAuAtW7WItp5qoUKjb
         6LJ5mdyacUmy6WiewIyeKGZ5WYFLErjFqi/rvtfKq6GDTPq7leAR/dnEkRd3sMf7uDbz
         gB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gl2SbsWOgmABu56kgPo4pH/0zc3IDICZmxrIpNqXfsc=;
        b=ruElh4WnNyMmuIEFZKHn+zUoaPZuSKTs2WPTaSu1ty3ZzF5TufQTrOYnrJIQMGh+qm
         b0KG45M4MbHhkv+7Ju0BQYG+YGQriCaF8x2y+CK419Xl1Ztvp+We5pSsQObl3SGW1L5e
         rs4csyKJ8F/DSjVG0i8ayg2tzCs/vOIh+MDPgJNqUpZ5hGeVt0Vdi5BYJEjVwLd+6EgI
         TxPBTJvIvRvGpKpbQXj/w67xqWrRk9O4LmY1hIzeAv4+UKWeCWS8NE3dfqf4O6WNWI2s
         i+kyQKHKUwXCqp2UNH783MC8ee8yQI6Ub2/0RDdS0v1DpaukqJZR0KeblhoNwgxXm3yX
         gFcw==
X-Gm-Message-State: AOAM533VZ4sB2fOhETnJiXUXPVQi8FeCbKO6agqViXvSz79gbb+tOW3X
        W5CTMbylpY8akaJRiQiaM2qT5X+opBg=
X-Google-Smtp-Source: ABdhPJxbSNx2UX8Fcn3heSR64r2zW9rMHAnynICuRjkpPGBT4sKzxbKyhS21TC07xpx4pP7wHnZiEA==
X-Received: by 2002:a62:30c2:0:b029:152:83fd:5615 with SMTP id w185-20020a6230c20000b029015283fd5615mr9469942pfw.22.1602194335553;
        Thu, 08 Oct 2020 14:58:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id n19sm8171408pfu.24.2020.10.08.14.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:58:54 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf_fib_lookup: return target ifindex even if
 neighbour lookup fails
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20201008145314.116800-1-toke@redhat.com>
 <da1b5e5f-edb3-4384-c748-8170f51f6f6d@gmail.com> <87d01se8qc.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1acb76c8-469b-9e45-90c7-e8c29c8ea6ff@gmail.com>
Date:   Thu, 8 Oct 2020 14:58:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87d01se8qc.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 1:57 PM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 10/8/20 7:53 AM, Toke Høiland-Jørgensen wrote:
>>> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
>>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>>> that the BPF program will pass the packet up the stack in this case.
>>> However, with the addition of bpf_redirect_neigh() that can be used instead
>>> to perform the neighbour lookup.
>>>
>>> However, for that we still need the target ifindex, and since
>>> bpf_fib_lookup() already has that at the time it performs the neighbour
>>> lookup, there is really no reason why it can't just return it in any case.
>>> With this fix, a BPF program can do the following to perform a redirect
>>> based on the routing table that will succeed even if there is no neighbour
>>> entry:
>>>
>>> 	ret = bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
>>> 	if (ret == BPF_FIB_LKUP_RET_SUCCESS) {
>>> 		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
>>> 		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
>>>
>>> 		return bpf_redirect(fib_params.ifindex, 0);
>>> 	} else if (ret == BPF_FIB_LKUP_RET_NO_NEIGH) {
>>> 		return bpf_redirect_neigh(fib_params.ifindex, 0);
>>> 	}
>>>
>>
>> There are a lot of assumptions in this program flow and redundant work.
>> fib_lookup is generic and allows the caller to control the input
>> parameters. direct_neigh does a fib lookup based on network header data
>> from the skb.
>>
>> I am fine with the patch, but users need to be aware of the subtle details.
> 
> Yeah, I'm aware they are not equivalent; the code above was just meant
> as a minimal example motivating the patch. If you think it's likely to
> confuse people to have this example in the commit message, I can remove
> it?
> 

I would remove it. Any samples or tests in the kernel repo doing those
back-to-back should have a caveat.
