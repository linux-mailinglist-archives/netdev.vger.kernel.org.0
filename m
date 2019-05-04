Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2CC13B81
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfEDSGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:06:34 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:38230 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfEDSGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:06:33 -0400
Received: by mail-pl1-f178.google.com with SMTP id a59so4275868pla.5
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 11:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJVOWpxu/rvaGY9TORo9IDn9g8HEwReO2fw94yG1UNc=;
        b=Cu2noWE4GVZstVK1eCnHeTAUaAZli5tas2mhv3D7byyefu1bT1cs9qUGO9ladXxhIk
         E23NyF81o9120aoB72JVjK0I2aI1gN164093kBUDbA7fmAxrm2jj1p+YshW+TEn1MnKO
         z/QFnlF7SLRzsyxtdJojhJ5j/fwXhvNe4/L1GNvl/6MEE45iUOPgnRuClhqT9abUaS10
         s15T+CvPy5mYiTwfB91FEOcgV3FJQHPE3YHJkhf+G9UrFXcTcJZfdzluhkAbziCDNX+Q
         LX0u8NQBBTA8elPrvCG+52yLUsP2QjZrthZEqiL0n6wkCi+jV/PEla+gqouv1CSUqeaf
         fM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJVOWpxu/rvaGY9TORo9IDn9g8HEwReO2fw94yG1UNc=;
        b=FI8eqqskmVEC4gn+fxachN+LsxD4ep+Db3ZFwW2PIW1lbhHfzLnbdVdTSobP+xPEn8
         e0oqF+gu1qyOGc2311KQvWLlytqx4/LCgPv5Ffb0ghRZibGCuaSW3xLLBoVtJsHu2+Ts
         bii+kpMM6urz49CQsPm9qA6zjE3rf0y5y05mLswOU2Y+BHqBVhdj7DvxEpLxTC0FYHWk
         pI38U6w7Aarxrz6SlAm/HgAA7WeqeM791vYce8DAHfl3oYBTGCMkUUJuL/5C74Nlih9C
         AiFbxDkbKlO9h+A0y0lMyosxROIqkQlT8hmTFK0plrDTG0LtKmrL/JXbVyW0DSYjseQD
         ytRQ==
X-Gm-Message-State: APjAAAXKJ2nEVYTqUEtNnJ+TLC20zrxwHeV73OKhl9/0TFvExR8+yADW
        fsYH083bGsqHRGf6z7/EJ8c=
X-Google-Smtp-Source: APXvYqzXN37nIv09QdHAu1VHsMfzUvGGeG0jpoewDNtU2jXsoJO6aFPfB5oGrXWUntMUQn2AizouuA==
X-Received: by 2002:a17:902:7b97:: with SMTP id w23mr20739428pll.335.1556993192851;
        Sat, 04 May 2019 11:06:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id 144sm7564474pfy.49.2019.05.04.11.06.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:06:31 -0700 (PDT)
Subject: Re: [RFC] ifa_list needs proper rcu protection
To:     Florian Westphal <fw@strlen.de>
Cc:     Networking <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
References: <7bdc26e6-ce41-02ba-baef-3e4e908f6dd7@gmail.com>
 <20190504180139.ftpnwgefjvukda7w@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <be05d2bd-0745-1639-df26-401e175b0332@gmail.com>
Date:   Sat, 4 May 2019 14:06:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504180139.ftpnwgefjvukda7w@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 2:01 PM, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> Sorry for late reply.
> 
>> It looks that unless RTNL is held, accessing ifa_list needs proper RCU protection ?
>>
>> indev->ifa_list can be changed under us by another cpu (which owns RTNL)
>>
>> Lets took an example.
>>
>> (A proper rcu_dereference() with an happy sparse support would require adding __rcu attribute,
>>  I put a READ_ONCE() which should be just fine in this particular context)
> 
> I don't see e.g. __inet_insert_ifa() use rcu_assign_pointer() or similar
> primitive, so I don't think its enough to change readers.
> 
> Same for __inet_del_ifa(), i see freeing gets dealyed via call_rcu, but
> it uses normal assignemts instead of a rcu helper.
> 
> So, I am afraid we will have to sprinkle some rcu_assign_/derefence in
> several places.

Yes, I came to the same conclusion.

