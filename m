Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0E34EF0C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhC3RKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhC3RKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 13:10:02 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6166FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 10:10:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo8797956wmq.4
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 10:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LFxWtZcu/BgbfeBPnuuoQCwwRuafGzbkIrzG5v8qPI4=;
        b=JCtq4dobn0P3pQ40W5xQLA/l88z+cLsz2EO1ZM0kYPz0gZTHKS+KJ7cGnXEAUbVwX8
         P9zARbC7vkzKX3N+Xu9fPjEcq+9DMdBtZCPW0kTLarLp71IQTOjF7kj0xel05J/5IZtA
         EtG81JMgUhPAev99B3FfsKg7IdBXWCO+JxPWvdC5k2UWNRWwM9ZurwuZVq89wdWYfzc+
         Lddi7mLE94JFxauQKCT4Dh4RlG90EhDOTs6B57DZez8jL7EUeUZFthcU8F+Nld49b2X0
         wQVV7fWquouOV9ih/WgSb8ioBL4PQhAV4DpOHDvJgvRncMyr6adWB1hlQ7euMhqefRlC
         SlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFxWtZcu/BgbfeBPnuuoQCwwRuafGzbkIrzG5v8qPI4=;
        b=rkEyhfbIxD6YF4zfuzMb+M+nXVbCNWUvJ72RY/jiASUJBhK6o0yP/wXEwDSB9LYU3d
         yBBo+OKwJjX5lFa11PsNh1DwkcA7ZXac88asroc/NjdYmYOH6A3TUdG4CSxGa/0iVmMO
         6qAOW+cAsCJ8kYaZWjdPOZ/Js5ODx8H9RB2WVxyBI6fqySNQAqLIxNi40nyYYhCVeKrz
         kq02AanYTjzjN8aR8r8SnBEVF/tsUzIW7DyIPXoe4vu3uJd+HipmSCcFoL61+MGu/MoY
         Ya6Lltz0yhmfTm5NKLHaNG5UadvVF89ZA8LEcX15+qJQ42U8xmQsLe21Qa8b4aGNQkHq
         RrgA==
X-Gm-Message-State: AOAM532HSLEgfhOabgrH3qtPq9yoyC03ybsYLNff+3BZRwfPVlz8JaZf
        YTrqSNy7aeg6UAKASJYUTLc=
X-Google-Smtp-Source: ABdhPJyEq26TLsYgU809LVFok7J6/czwOFbZ4Ttzx6d4/K3+W+m6B+Ux0adJ1Z41Y9vLpqEwVVlPQg==
X-Received: by 2002:a05:600c:3506:: with SMTP id h6mr5149486wmq.168.1617124201130;
        Tue, 30 Mar 2021 10:10:01 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.251.74])
        by smtp.gmail.com with ESMTPSA id 64sm4594208wmz.7.2021.03.30.10.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 10:10:00 -0700 (PDT)
Subject: Re: [PATCH net v2] net: let skb_orphan_partial wake-up waiters.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <532014d8a99966da5fbcee528abe56356899f04a.1617121851.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4db3b5d8-e809-498c-a516-0e10c246619a@gmail.com>
Date:   Tue, 30 Mar 2021 19:09:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <532014d8a99966da5fbcee528abe56356899f04a.1617121851.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/21 6:43 PM, Paolo Abeni wrote:
> Currently the mentioned helper can end-up freeing the socket wmem
> without waking-up any processes waiting for more write memory.
> 
> If the partially orphaned skb is attached to an UDP (or raw) socket,
> the lack of wake-up can hang the user-space.
> 
> Even for TCP sockets not calling the sk destructor could have bad
> effects on TSQ.
> 
> Address the issue using skb_orphan to release the sk wmem before
> setting the new sock_efree destructor. Additionally bundle the
> whole ownership update in a new helper, so that later other
> potential users could avoid duplicate code.
> 
> v1 -> v2:
>  - use skb_orphan() instead of sort of open coding it (Eric)
>  - provide an helper for the ownership change (Eric)
> 
> Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

