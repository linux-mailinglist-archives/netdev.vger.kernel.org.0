Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDDF293D93
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407599AbgJTNp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407578AbgJTNp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 09:45:58 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7232C061755;
        Tue, 20 Oct 2020 06:45:57 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z5so3392515iob.1;
        Tue, 20 Oct 2020 06:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UG73CwBBAsAs1bvJnIn/MkjvzhJCIst3qjKbFhh7+34=;
        b=hZ7kr3Xlcc64mXZSjudnBkYa9XSUqZFkhMK2p2KEDbNjE+cVvWELcfTrN/PmapGhAt
         bYKKV5PtEc/6NkTxlfjwcfnEWoM8dyAS8SIwAf9V0ID/GgGsd3TTP2O1FrYVn9R3fiKe
         JgiaVe4X6Fz+f2+74s+tWSj/zJIl1Feym+Aty5+iWURYuOn2VQQUlI4+7tbNuyHUXPth
         BQzaZ9zchOTByVhYX81HK9ew1qOrqizswi0uEwiCuyYKK0VgUoDROM7MVKIBvwAzKWGB
         kPB2qNXwakbrmfgnlQ6hCeSkbPx/L1Enc1wi1aDFhNzfvPNJmM8ZBZmgKvpB3Tys6SDl
         mdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UG73CwBBAsAs1bvJnIn/MkjvzhJCIst3qjKbFhh7+34=;
        b=cHAA06IpSimhL55+cOFPNNV64doVNpsc9BOP0oGeC6yLM3Ss/7MR+J6BZHVj85WOgn
         mLcim694yRroLmNETaPhdDdUhENDRL2zi0buJnkmngXZYqVLAyWgCJreRSUtbp8XUVZl
         jgKJ7QVj0WVJF7Ah2J5p7ls75mlaoXMCMuf2cU+FHf5lNQ3dZ/UkO22e9Dn3ibRwySCn
         5XDX6/A/5xBTxZMfSyI5hKp7VP7ZdA+bOAJTGFab/vAW1cg3yd8TWigerdYwce4iz5qo
         urSal7X/+bOLqz/XD8Q8hLrF7/WHLOj1/jEtP6JFGYfKG8K/l4yQPMndUaXf7wKkOLoA
         ZO7Q==
X-Gm-Message-State: AOAM532a/z/iYymTWoo1hWmB79DOKctdaNQsJaJ4knPP3Ly+uWnMPYEg
        yS+Be884B1UB33m5gz1Pj/EQxQbMibQ=
X-Google-Smtp-Source: ABdhPJxqrMkL9PlFYyuRjXiQc05LYWeMcZDLsOfvpxkqkkVeVlvd6fgZOiiWgTN7R4NBCQt/iBanDA==
X-Received: by 2002:a02:7083:: with SMTP id f125mr1520296jac.27.1603201556999;
        Tue, 20 Oct 2020 06:45:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id d7sm1868618ilr.31.2020.10.20.06.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 06:45:56 -0700 (PDT)
Subject: Re: [PATCH bpf 1/2] bpf_redirect_neigh: Support supplying the nexthop
 as a helper parameter
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160312349392.7917.6673239142315191801.stgit@toke.dk>
 <160312349501.7917.13131363910387009253.stgit@toke.dk>
 <3785e450-313f-c6f0-2742-716c10b6f8a4@iogearbox.net>
 <e4188697-4467-61fe-72c4-cc387ea9a727@gmail.com>
 <dd953598-c897-e4f5-39e5-43f62bd15431@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a6f2081-c9a9-727c-c654-347cbdf7b29f@gmail.com>
Date:   Tue, 20 Oct 2020 07:45:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <dd953598-c897-e4f5-39e5-43f62bd15431@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 2:59 AM, Daniel Borkmann wrote:
> On 10/20/20 5:12 AM, David Ahern wrote:
>> On 10/19/20 12:23 PM, Daniel Borkmann wrote:
>>> Looks good to me, thanks! I'll wait till David gets a chance as well to
>>> review.
>>> One thing that would have made sense to me (probably worth a v2) is to
>>> keep the
>>> fib lookup flag you had back then, meaning sth like BPF_FIB_SKIP_NEIGH
>>> which
>>> would then return a BPF_FIB_LKUP_RET_NO_NEIGH before doing the neigh
>>> lookup inside
>>> the bpf_ipv{4,6}_fib_lookup() so that programs can just unconditionally
>>> use the
>>> combination of bpf_fib_lookup(skb, [...], BPF_FIB_SKIP_NEIGH) with the
>>> bpf_redirect_neigh([...]) extension in that case and not do this
>>> bpf_redirect()
>>> vs bpf_redirect_neigh() dance as you have in the selftest in patch 2/2.
>>
>> That puts the overhead on bpf_ipv{4,6}_fib_lookup. The existiong helpers
>> return BPF_FIB_LKUP_RET_NO_NEIGH which is the key to the bpf program to
>> call the bpf_redirect_neigh - making the program deal with the overhead
>> as needed on failures.
> 
> But if I know there's high chance anyway that __ipv*_neigh_lookup_noref*()
> is failing for bpf_ipv{4,6}_fib_lookup() why even paying the price of the
> hash table lookup in there? Simple test to skip and return early would be
> much cheaper, and branch predictor should work it out just fine given that
> setting is pretty much static anyway; I'm not sure I'm seeing why this
> would
> be much of a concern..

The death by a 1000 paper cuts mantra.

The new bpf_redirect_neigh helper only works for skb's; the older
bpf_fib_lookup helpers work for XDP and skb's.

The primary reason for a program to need both helpers back to back is
when the neighbor entry is invalid. A condition where the nexthop
address is valid yet the neighbor entry is not resolving or in an
invalid state should be a rare event - like startup.

The existing helper has enough 'if' checks in it, forced by the
multitude of features the stack supports. Rare runtime events should be
handled by the bpf programs.
