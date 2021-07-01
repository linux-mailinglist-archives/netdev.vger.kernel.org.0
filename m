Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605A33B9463
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhGAP6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbhGAP6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:58:48 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF3EC061764
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 08:56:17 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id k8so9147416lja.4
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=EWMfplk1+E9qv/BJMYr9wuJzgYw35Tkq30B5gBP8ayU=;
        b=KMImn+fMpu/UCH/8Y163vpsWNShJ0j+vmdUzijdVm/6HZjgAgLOj4KpdkctvAgRwSK
         8tLnOFPygqQ1kWbhW38qn7xpTKF2P5pt8NksTvBLmblfl15hJNSTwti2vy/8AfB0Kxj2
         jI4uI5aOc7o66koPJlPE60i43SUw8MSvg4ODs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=EWMfplk1+E9qv/BJMYr9wuJzgYw35Tkq30B5gBP8ayU=;
        b=Rf1s8iqQHBAPVSfT1eY3v7Sjraw59hksEIyagtOEmRZzdiF3rGv3Mp/x7FUELFi6h9
         Y2Ajc3e64TdqkPRA8I6p7kWR6NM61Na+Aa0vlfhik3K5ve9XA7ZIFQDUTeVlHpL9Sh82
         dYR5L6wtmhSJeUn1Wcnkk+pDRPQ++loEl+AB9JPmvKbaM8N3KxnxBPImiNoGhbJwsCzT
         Cjl7GiujwMAhTPI8FOF9ZxlmETO+kVImRxYXuvCdvMffQ7A3uDxwLTl5BXx+l/t3jqBB
         kvR0PdGILEAtz0B3Lxm8ROi0G1YcgWGhxyNuxg2LC4b6/Sei7s2FVooMGwChBw6m6yl+
         mxZw==
X-Gm-Message-State: AOAM532SU/LHE3GnICuRhslcftdKMaKypmYhvO/DILbRyYchU+aEBFAy
        YSzFApB+QNfMK7O/jvuvEezkKw==
X-Google-Smtp-Source: ABdhPJxu5QBTaoNnXWim8i4I+vDDqdP6jrz4BF3wUCa4CxyVKGKO5mF+Wh4XPuYJsCJH1+EbfivxDA==
X-Received: by 2002:a05:651c:1115:: with SMTP id d21mr181091ljo.476.1625154976091;
        Thu, 01 Jul 2021 08:56:16 -0700 (PDT)
Received: from cloudflare.com (79.191.58.233.ipv4.supernova.orange.pl. [79.191.58.233])
        by smtp.gmail.com with ESMTPSA id t24sm49412ljj.97.2021.07.01.08.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 08:56:14 -0700 (PDT)
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
In-reply-to: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
Date:   Thu, 01 Jul 2021 17:56:12 +0200
Message-ID: <877diarpsz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 08:16 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Jiang observed OOM frequently when testing our AF_UNIX/UDP
> proxy. This is due to the fact that we do not actually limit
> the socket memory before queueing skb to ingress_skb. We
> charge the skb memory later when handling the psock backlog,
> but it is not limited either.
>
> This patch adds checks for sk->sk_rcvbuf right before queuing
> to ingress_skb and drops packets if this limit exceeds. This
> is very similar to UDP receive path. Ideally we should set the
> skb owner before this check too, but it is hard to make TCP
> happy about sk_forward_alloc.
>
> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

By saying that it is hard to make TCP happy about sk_forward_alloc, I'm
guessing you're referring to problems described in 144748eb0c44 ("bpf,
sockmap: Fix incorrect fwd_alloc accounting") [1]?

Thanks for the fix.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=144748eb0c445091466c9b741ebd0bfcc5914f3d

[...]
