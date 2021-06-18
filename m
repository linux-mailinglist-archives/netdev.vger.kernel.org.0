Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EABF3AD41A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhFRVGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 17:06:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38849 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbhFRVGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 17:06:20 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <seth.forshee@canonical.com>)
        id 1luLer-0001ie-WF
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 21:04:10 +0000
Received: by mail-oi1-f197.google.com with SMTP id j1-20020aca65410000b02901f1d632e208so5494104oiw.16
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 14:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5zbYadu2t3o6x+9++LseJ8wQLR5kf1IyrynQJ5OhAxw=;
        b=tcOrwRp9CCgmZvG4G/ZPN2bMTTWodSh3FR5q3+ndxW/sAmB4ddf3ZHfzge2QzGIqk+
         BRu+xODZywoLLo4DDi0CzwA5BRHyCi83531MRjJoBihMR0HMapqAVUfkWnSMWsxxGpBW
         ed0BPulktP6xiUxkMaIPVxeNess/PEsoXsOiCq2APBi7Dm0bBg0FCmAc5N8viI+iAajw
         Jn7vkDkMvsEetItpdxjFsLg+RKSAuT9gubWr38fHKuj23vFAeCS8GkrSMcsb/jWrR+uF
         QMPK1UN4EDoY/V/vsCoPBlyo8QuV1YqoVz4Q1V5dIs3KYTvKMb/e3/BkYAN2e9nORqme
         yVTw==
X-Gm-Message-State: AOAM533uviL4VDftzs2tGe6wEozJdUg52A140vXE4H74ZZIbiQ8CNq2p
        zqWsqH4U+ns5X07/i0pWer3ML6F9MSpQadWqrshSCRUC54xQQ4qE+L/we/sWMhPvZu6zUYFfR02
        F51ds1tq+E8rTutRSnweJ8ijwwSpykdn0TQ==
X-Received: by 2002:a9d:7d99:: with SMTP id j25mr10998164otn.96.1624050248969;
        Fri, 18 Jun 2021 14:04:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqMOxfozpdxtOxnHtmpGvoAp17XOGw5LC4TpDNUy7r009zmOT038vgLAVGvqZX44z1jwi1Ng==
X-Received: by 2002:a9d:7d99:: with SMTP id j25mr10998151otn.96.1624050248757;
        Fri, 18 Jun 2021 14:04:08 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:ada:6eea:499c:8227])
        by smtp.gmail.com with ESMTPSA id p25sm1976336ood.4.2021.06.18.14.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 14:04:08 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:04:07 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, davejwatson@fb.com,
        ilyal@mellanox.com, aviadye@mellanox.com,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: Re: [PATCH net] tls: prevent oversized sendfile() hangs by ignoring
 MSG_MORE
Message-ID: <YM0KR8IPGoSBgCl8@ubuntu-x1>
References: <20210618203406.1437414-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618203406.1437414-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 01:34:06PM -0700, Jakub Kicinski wrote:
> We got multiple reports that multi_chunk_sendfile test
> case from tls selftest fails. This was sort of expected,
> as the original fix was never applied (see it in the first
> Link:). The test in question uses sendfile() with count
> larger than the size of the underlying file. This will
> make splice set MSG_MORE on all sendpage calls, meaning
> TLS will never close and flush the last partial record.
> 
> Eric seem to have addressed a similar problem in
> commit 35f9c09fe9c7 ("tcp: tcp_sendpages() should call tcp_push() once")
> by introducing MSG_SENDPAGE_NOTLAST. Unlike MSG_MORE
> MSG_SENDPAGE_NOTLAST is not set on the last call
> of a "pipefull" of data (PIPE_DEF_BUFFERS == 16,
> so every 16 pages or whenever we run out of data).
> 
> Having a break every 16 pages should be fine, TLS
> can pack exactly 4 pages into a record, so for
> aligned reads there should be no difference,
> unaligned may see one extra record per sendpage().
> 
> Sticking to TCP semantics seems preferable to modifying
> splice, but we can revisit it if real life scenarios
> show a regression.
> 
> Reported-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Reported-by: Seth Forshee <seth.forshee@canonical.com>
> Link: https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/
> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

With this patch the muilt_chunk_sendfile selftest passes. Thanks!

Tested-by: Seth Forshee <seth.forshee@canonical.com>
