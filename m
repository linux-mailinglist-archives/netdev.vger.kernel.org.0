Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A9E6DE32E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDKRy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKRyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:54:25 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB1D4EF1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:54:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id sh8so22426398ejc.10
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1681235663;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=yrryeHhnkLhdBjI+IiusBoHSwY8FqBR49EYLQoRG9uU=;
        b=n+kducnI/HClkrEboojcGSrYYB8Mnuq6RXm196HIJ0/TbxqSV+dm4z8FHEqqZ54aWh
         9LZI91xy7CUgc+9vzHaSJoWiDHTry9sM4wrK1vf9Kcu9QcbFpfpRAz+2bbMELEihU+s+
         Lnft+S+8ZWudzOgs+G01c/biuTccGvxpJ3KKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235663;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrryeHhnkLhdBjI+IiusBoHSwY8FqBR49EYLQoRG9uU=;
        b=RqVpaVgfkPog6SNzdM93XxUg3LI4JdfmxbqCyY31mXaWFyEZkc5FOhkeVreg7Rwwtw
         1onUf0YZkElPviphiEcTG7LFsVi76ImcQZ9reF8z1j+uF0IR7mYzqRYLufRkK/t/3Km3
         GEhZiYrWRZ/CvH1ceSkmyboJgOmgMxZyk13hTeEvTrmNRaWzqiK5gX3/vjRnXHZ+dAbF
         gNXuXMfGJM7gxL5dxtYufq8Dx4tVH4e+XOJel/0Kd0+G8NQnJsSrTIQpDbiD1BwBsOAt
         1rteO8eRr8ND7I8pCZfxKqtPMzl80b/3Q0oN7g5PnKw8a1Ec64Qf1yxPBprHFQJEUv4W
         EZ2g==
X-Gm-Message-State: AAQBX9fYGxE4q9Xf5vTJIKhy1iuAh/STc15BfICUNsDkNfG4K3EbBz+F
        JRhxq89ldv5zYbtVBvLbFbEuTg==
X-Google-Smtp-Source: AKy350ZkrQtWh3QgEm99IhZQZPqghsII8d36Ewx7T3FrSf6cSnQ3JD6OuM+d8IUz+12tfWA/5LIfUw==
X-Received: by 2002:a17:907:7b06:b0:94c:548f:f81d with SMTP id mn6-20020a1709077b0600b0094c548ff81dmr5369385ejc.71.1681235663251;
        Tue, 11 Apr 2023 10:54:23 -0700 (PDT)
Received: from cloudflare.com (79.191.181.173.ipv4.supernova.orange.pl. [79.191.181.173])
        by smtp.gmail.com with ESMTPSA id jg7-20020a170907970700b0094bb4c75695sm1690515ejc.194.2023.04.11.10.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:54:22 -0700 (PDT)
References: <20230407171654.107311-1-john.fastabend@gmail.com>
 <20230407171654.107311-4-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v6 03/12] bpf: sockmap, improved check for empty queue
Date:   Tue, 11 Apr 2023 19:53:51 +0200
In-reply-to: <20230407171654.107311-4-john.fastabend@gmail.com>
Message-ID: <87pm8agv8y.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:16 AM -07, John Fastabend wrote:
> We noticed some rare sk_buffs were stepping past the queue when system was
> under memory pressure. The general theory is to skip enqueueing
> sk_buffs when its not necessary which is the normal case with a system
> that is properly provisioned for the task, no memory pressure and enough
> cpu assigned.
>
> But, if we can't allocate memory due to an ENOMEM error when enqueueing
> the sk_buff into the sockmap receive queue we push it onto a delayed
> workqueue to retry later. When a new sk_buff is received we then check
> if that queue is empty. However, there is a problem with simply checking
> the queue length. When a sk_buff is being processed from the ingress queue
> but not yet on the sockmap msg receive queue its possible to also recv
> a sk_buff through normal path. It will check the ingress queue which is
> zero and then skip ahead of the pkt being processed.
>
> Previously we used sock lock from both contexts which made the problem
> harder to hit, but not impossible.
>
> To fix also check the 'state' variable where we would cache partially
> processed sk_buff. This catches the majority of cases. But, we also
> need to use the mutex lock around this check because we can't have both
> codes running and check sensibly. We could perhaps do this with atomic
> bit checks, but we are already here due to memory pressure so slowing
> things down a bit seems OK and simpler to just grab a lock.
>
> To reproduce issue we run NGINX compliance test with sockmap running and
> observe some flakes in our testing that we attributed to this issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
