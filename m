Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7961ED783
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 22:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgFCUjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 16:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgFCUjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 16:39:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8630C08C5C1
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 13:39:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k11so3613711ejr.9
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 13:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=s9a3sBWiPbLX3OUXd89qCWIIhpbfPNP9FedjZfBx1Ic=;
        b=bQ+uXBtAdJnAm4Fb+TJk4i3yWvKleFFAhEoXwFL/ZCSiwr7DXDGK2HHdcsEvRABWOr
         WCcwpowg3ffTOoN0ohUiWPbY7wHQitd8d21cCYAoKgTU10Pw/bOwEBgWRQ9sgE65k9sR
         gQDttImW2iwzRgLGGJ3GoFy0Vj3XN1t6ZJvkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=s9a3sBWiPbLX3OUXd89qCWIIhpbfPNP9FedjZfBx1Ic=;
        b=DUbKbniJ4lW7iCAX48Zhfw7P/J8OECVWEm07kfglEXBb+jGSzUboDu0kE1CZRE4TUh
         QmNBieGbkpsTGLvgjo8JPmn/HubdRcShNBFywn7+AsUnGY8FyBk+7xMvpsbxJAtcSeK+
         utqw2tw7hKdqB5U7vOuQk0R47WPubFUCBrP7s6TIwN4HKBTPBYQ3xkg1/4HLQvqYgkh9
         8au8MslIRjWlKCgopGV0z4DajCIfRxVizuBiJX5EvevkhfXOD56MQZphQA0g6q+6wAy3
         THAw+Wqn3rdQ4CGSOr0gJr8Fr70iYNvlzR+poq8UhV/ilUF0UKXZEO1MG3kIrb8+3h3G
         tqHQ==
X-Gm-Message-State: AOAM533fq+jNRGSgfCiF6caTiJZz4vXbbE+QL23nlviCxLjmh04caK/J
        6lpzgttktmJgx4RcDrPgy+gZNg==
X-Google-Smtp-Source: ABdhPJwd6i9/n11XR+AmSb4TS78eKAHg9q+4Xaz3Eys3xNWzjyPQzjeoljht/UJhu2PY2f0YOpvj1Q==
X-Received: by 2002:a17:907:2052:: with SMTP id pg18mr944564ejb.513.1591216754427;
        Wed, 03 Jun 2020 13:39:14 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n25sm353242edo.56.2020.06.03.13.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 13:39:13 -0700 (PDT)
References: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower> <6f8bb6d8-bb70-4533-f15b-310db595d334@gmail.com> <87a71k2yje.fsf@cloudflare.com> <5ed7ed7d315bd_36aa2ab64b3c85bcd9@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [bpf PATCH] bpf: sockmap, remove bucket->lock from sock_{hash|map}_free
In-reply-to: <5ed7ed7d315bd_36aa2ab64b3c85bcd9@john-XPS-13-9370.notmuch>
Date:   Wed, 03 Jun 2020 22:39:12 +0200
Message-ID: <878sh33mvj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 08:35 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:

[...]

>> I'm not sure that the check for map->refcnt when sock is unlinking
>> itself from the map will do it. I worry we will then have issues when
>> sockhash is unlinking itself from socks (so the other way around) in
>> sock_hash_free(). We could no longer assume that the sock & psock
>> exists.
>>
>> What comes to mind is to reintroduce the spin-lock protected critical
>> section in sock_hash_free(), but delay the processing of sockets to be
>> unlinked from sockhash. We could grab a ref to sk_psock while holding a
>> spin-lock and unlink it while no longer in atomic critical section.
>
> It seems so. In sock_hash_free we logically need,
>
>  for (i = 0; i < htab->buckets_num; i++) {
>   hlist_for_each_entryy_safe(...) {
>   	hlist_del_rcu() <- detached from bucket and no longer reachable

Just to confirm - synchronize_rcu() doesn't prevent
sock_hash_delete_from_link() from getting as far as hlist_del_rcu(),
that is here [0], while on another cpu sock_hash_free() is also
performing hlist_del_rcu().

That is, reintroducing the spin-lock is needed, right? Otherwise we have
two concurrent updaters that are not synchronized.

>         synchronize_rcu()
>         // now element can not be reached from unhash()
> 	... sock_map_unref(elem->sk, elem) ...
>   }
>  }
>
> We don't actually want to stick a synchronize_rcu() in that loop
> so I agree we need to collect the elements do a sync then remove them.

[...]

>>
>> John, WDYT?
>
> Want to give it a try? Or I can draft something.

I can give it a try, as I clearly need to wrap my head better around
this code path. But I can only see how to do it with a spin-lock back in
place in sock_hash_free(). If you have an idea in mind how to do it
locklessly, please go ahead.

[...]

[0] https://elixir.bootlin.com/linux/latest/source/net/core/sock_map.c#L738
