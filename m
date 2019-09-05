Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547FCAA719
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfIEPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:14:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51958 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732265AbfIEPOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:14:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id k1so3274687wmi.1;
        Thu, 05 Sep 2019 08:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfUO9a7E9R+fOWFokuwHNXPizB7LWxoWz7TwHKPJeKA=;
        b=f4csicVeVdbTjTLkGvuU0mio8k0xnxfoLTmb8gdYb5QJnAEFROnPSH7xc73HYN+ixy
         e7gsFYRoSkO7Br2jflzTOhyh3rBXVyvrUz6DglZJyLAz55fNeDFqYRKseYc5o5YYmG9X
         9EH6/ZINv9WZapt2Lac5IXHUER+zSZ8KE5NYwoWAMtg+lG2QKlwMyc5entzeSaE+ljVK
         SaVxAbTmwbe+Lz2ctOldV92jLUOuBjwE6ipjqOdeWVnYpT2TFYkopT5bgHkmRtBU3hPo
         PrrkIH3ne82+4DNJs2FLPJ3tAQarRkLp+JhsT7jjovcykTPt5+3w0RpXc3x76k90mUlq
         CFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfUO9a7E9R+fOWFokuwHNXPizB7LWxoWz7TwHKPJeKA=;
        b=sz2JrCrAlOdU1Hdd7FVZEqKC0I2bUkQZzV1fPLHHPAc3ojuS7VCbu6YFo5whsbQT+r
         9VuI3LRK7zp6msfgku4bQl/6KCujxmZatB7U6KaxygHqgyVVaD40MkiNQF7xJfwOGnhU
         YxP89niruZ7j87GTCOIKCIEC2iEHTYWpG6jKcVAEvv50QGc+/IF3xk2jr/QLbyPPMiPa
         U3T5e0kETZ6627X+E1ddLf1kF9/bqXyaYk//CcJ+I/izXJA0hfs9UChvySTLCHe2wgkk
         mH6krs65WhtyRZY0fByfTtSqcUHDu3jQtb/M9SvDPqn9sKo4yYPmtuuND+Ygl/cIykeJ
         mKPw==
X-Gm-Message-State: APjAAAVENdsbhUoxdc1Y/pI8z0vG6G7XnYff5RL5X1cwAkOIOnWy/elt
        0js7ZSu0jJQhnauUKo8sk14=
X-Google-Smtp-Source: APXvYqzYIkx/gnO7fVC7G+fRVIplybcIMoud+HvMrsXB+dAIK4P1jN6ol9+wQvapxKMmcT0X7chTUA==
X-Received: by 2002:a1c:9950:: with SMTP id b77mr3552791wme.46.1567696457429;
        Thu, 05 Sep 2019 08:14:17 -0700 (PDT)
Received: from [192.168.8.147] (163.175.185.81.rev.sfr.net. [81.185.175.163])
        by smtp.gmail.com with ESMTPSA id y14sm3817913wrd.84.2019.09.05.08.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 08:14:16 -0700 (PDT)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw> <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw> <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw> <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <165827b5-6783-f4f8-69d6-b088dd97eb45@gmail.com>
 <1567692555.5576.91.camel@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5405caf6-805b-d459-c447-15a23d0d71dd@gmail.com>
Date:   Thu, 5 Sep 2019 17:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567692555.5576.91.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/19 4:09 PM, Qian Cai wrote:

> Instead of repeatedly make generalize statements, could you enlighten me with
> some concrete examples that have the similar properties which would trigger a
> livelock,
> 
> - guaranteed GFP_ATOMIC allocations when processing softirq batches.
> - the allocation has a fallback mechanism that is unnecessary to warn a failure.
> 
> I thought "skb" is a special-case here as every packet sent or received is
> handled using this data structure.
>

Just  'git grep GFP_ATOMIC -- net' and carefully study all the places.

You will discover many allocations done for incoming packets.

All of them can fail and trigger a trace.

Please fix the problem for good, do not pretend addressing the skb allocations
will solve it.

The skb allocation can succeed, then the following allocation might fail.

skb are one of the many objects that networking need to allocate dynamically.

