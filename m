Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AC935BECF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhDLJCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239059AbhDLI7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:59:05 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9DC06138D
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:56:50 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n8so20188276lfh.1
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=v80JJJDW9QtxHkk0a0zU0nnrThIy25/WR2Z0y5oalCQ=;
        b=B0FICsUZf5BlugUzF6HFNlkL5xjsucp0vP8Ze+uCdd+R0swzQwgQoJXK+CzHNwyYps
         Idg6A81UHoPEHV2+aO2VHh1yzZWxUDXt0M2lvIN+6AGXURRcLwc18alykY183arV+jv0
         gtKBn//eU/Vh3G5BzOFRBljiadmr8pZ/Oab80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=v80JJJDW9QtxHkk0a0zU0nnrThIy25/WR2Z0y5oalCQ=;
        b=nc7+ux8U6pcqRAVUUxQkGZ9X0YxsbAIUWv0kBcmp7mR3MYW8M3gJNyhPPIDzlaOFok
         b7yXC/SD/lsQ26+q/4Kxifs6tlbFv0eJfkKk997Cig8J82eg22nctEzSYd0orPG5Ggnc
         6WlE0NE1PnPhIolj/Kgwopsea82mcA4zM9xuEnrkgVp/5Q59kTl5dXSik4xmQUswipFQ
         74niKVCosRsFh2/pdS4MxofKsQ0izMfvkbczmuigbt+1W7oYNrMAK5NFYyM12hdtk5/N
         kCTen6mRMOQcopXFQDTzts8BnYQVhGraPpNFzJ8187e+f5Qy1v6jVbe0W3aTy6mPGfE7
         xw+Q==
X-Gm-Message-State: AOAM530nBPQ9MyJWFvBdtqXWJIr4OPSILbAAhDESoZ9IJn+dHy1w9GOY
        q7rkhZrXLvD448gw87bwx9Ae9g==
X-Google-Smtp-Source: ABdhPJzS8q80Ofl+UQJgn2PmQRSlB7aoaXgbZM87nPxi9zU3guOvIdL4NtCaH8vS1B7vmXTmlb/huA==
X-Received: by 2002:ac2:5617:: with SMTP id v23mr18500507lfd.123.1618217808502;
        Mon, 12 Apr 2021 01:56:48 -0700 (PDT)
Received: from cloudflare.com (79.184.75.85.ipv4.supernova.orange.pl. [79.184.75.85])
        by smtp.gmail.com with ESMTPSA id y25sm2739125ljc.73.2021.04.12.01.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 01:56:47 -0700 (PDT)
References: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next] sock_map: fix a potential use-after-free in
 sock_map_close()
In-reply-to: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
Date:   Mon, 12 Apr 2021 10:56:46 +0200
Message-ID: <87pmyz3mpd.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 05:05 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> The last refcnt of the psock can be gone right after
> sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
> The reason why I placed sk_psock_stop() there is to avoid RCU read
> critical section, and more importantly, some callee of
> sock_map_remove_links() is supposed to be called with RCU read lock,
> we can not simply get rid of RCU read lock here. Therefore, the only
> choice we have is to grab an additional refcnt with sk_psock_get()
> and put it back after sk_psock_stop().
>
> Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
