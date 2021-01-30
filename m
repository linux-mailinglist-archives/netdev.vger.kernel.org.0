Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F59309681
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhA3QGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhA3QGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 11:06:10 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82672C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 08:05:30 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 63so11802570oty.0
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 08:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LEAkpo8Q71pMS5p/jd+4AnTM/010NmIKwzEftzJdxKw=;
        b=QwwYDtXp3R3LmjYu8Qze+8BLq++dmkl8EkHDdegRNQQ3ovlG9sduyuPGi+1Fl58Q6t
         ZNpiISOnm6C1o8/zZPx/Yj4PO8qLM6hDPk8dX15BTNeFwKd8bwifJN8pD/fzmkZMk6E3
         51Tgu+GiSpBMdnYeRVFpYPu+F4M3nK3Q1tbczP+ATAlqUPKynu3DdgzC/nPOwxYK7sJj
         C/3k1otPyhELTDKEnRKPrBkIHoEIsD7OAJzwNQxnzAdRNjo27SXEt0m/nhDq2W/m6LWN
         cmorhq1z7tuqzRQrQyMGoaMb7xGDPVuur4bpoyvfBagVRXNpbimPQmd/WXx5LwTFQpES
         3W8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEAkpo8Q71pMS5p/jd+4AnTM/010NmIKwzEftzJdxKw=;
        b=d9Jc/Pe3+U5/UzYQG74gAumSLGENerjBItvbcvaTKO2ut41SkbvTzXAU6aU2Pw62Yo
         w7YQMoWOTFq4oIdsDkBwhUb6wyVk/vtQi5E9ySmfKU9MBJ5z69evSZrQv0fmEW1lQzXQ
         prXJlOBGeWOehtj+VaYfrYLgh7KELpvf/KQNhZHb2qf4RDcFXGQUOhtyA9PlqtGXxVwF
         x0hZ8YFpLhBCUqQzTokjHmqQ8FGCFJPMNE7IdAPe1F549DnJTYVf1s7+tzfRgZeCKZG1
         3nEtnpj5ZjWJm+IIxr3nBAwBQTKVHPXXTl2FKBBADYFA+4NjlPimgiW4BM5qt+A2QI9i
         n9Iw==
X-Gm-Message-State: AOAM532u9ptd0eNWbeSnlqJ1s1UsGXo66Pbu2MDvu06m/v1GfTGepy0u
        0o85q1rXmEJZhfWWnKPiF94=
X-Google-Smtp-Source: ABdhPJx0/vTnrq9b4gULGDR9WLcu/mjZ4k1BbDi5vvmnKKT0wKL9cBh1bGYdC0LW5BwrP+98RaTEjw==
X-Received: by 2002:a9d:53c5:: with SMTP id i5mr3212892oth.159.1612022729326;
        Sat, 30 Jan 2021 08:05:29 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5e8:905e:fd16:57ad])
        by smtp.googlemail.com with ESMTPSA id q20sm2814570otf.2.2021.01.30.08.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 08:05:28 -0800 (PST)
Subject: Re: [PATCH] neighbour: Prevent a dead entry from updating gc_list
To:     Chinmay Agarwal <chinagar@codeaurora.org>,
        xiyou.wangcong@gmail.com, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sharathv@codeaurora.org
References: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58b836cd-108d-2248-5206-1aade48153dd@gmail.com>
Date:   Sat, 30 Jan 2021 09:05:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 9:54 AM, Chinmay Agarwal wrote:
> Following race condition was detected:
> <CPU A, t0> - neigh_flush_dev() is under execution and calls
> neigh_mark_dead(n) marking the neighbour entry 'n' as dead.
> 
> <CPU B, t1> - Executing: __netif_receive_skb() ->
> __netif_receive_skb_core() -> arp_rcv() -> arp_process().arp_process()
> calls __neigh_lookup() which takes a reference on neighbour entry 'n'.
> 
> <CPU A, t2> - Moves further along neigh_flush_dev() and calls
> neigh_cleanup_and_release(n), but since reference count increased in t2,
> 'n' couldn't be destroyed.
> 
> <CPU B, t3> - Moves further along, arp_process() and calls
> neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
> the neighbour entry back in gc_list(neigh_mark_dead(), removed it
> earlier in t0 from gc_list)
> 
> <CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
> the neighbour entry.
> 
> This leads to 'n' still being part of gc_list, but the actual
> neighbour structure has been freed.
> 
> The situation can be prevented from happening if we disallow a dead
> entry to have any possibility of updating gc_list. This is what the
> patch intends to achieve.
> 
> Fixes: 9c29a2f55ec0 ("neighbor: Fix locking order for gc_list changes")

always Cc the author(s) of commits in Fixes tag.

> Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
> ---
>  net/core/neighbour.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

