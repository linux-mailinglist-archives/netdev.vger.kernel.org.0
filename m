Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8B5EDE83
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiI1OMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiI1OMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:12:17 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0496C9E0FC
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:12:13 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3529c491327so36455027b3.13
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ZC+JTcGztSKl+RjKLwGKj/o8HbqE0xt0q2yyLJn8QCg=;
        b=rQNXEyB/J42WFQx1vYAH9CBRpkSqjcgTgMqF/3AraY0P/UgUgdT5KWxjQBP/xro4tB
         9w2Ec9U+bW8r72c+d6wca0RSUvB6a17vtOP0fPcbHVRDd89dRa79d5tuf0bCAblvwOYP
         j5mz0T/RSYf73mA2Ie8kYuM75QMiQwbu3hECQ1W9rSZG3BbnKZRmN0WZQUI+0v4qAV4z
         7Ba/WGv1U5hcTRDfOQxv5UE3SskgwbttjvRUw+fqtzxamXU5u8tG7dNd2DFSb5qoOkhM
         hPzShNHZVCF7yryDi9CkW8xPfXwufCSmlgt3Kk82Bakfifv9oCBW4o+ytIzE6ISt/C6G
         yfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZC+JTcGztSKl+RjKLwGKj/o8HbqE0xt0q2yyLJn8QCg=;
        b=IQgNf4hexRcw/eePck2oE3mOw6E6gmvNymAiX7/eJVp8tuEXo3BBS5d4G0PUfeQZ7b
         MR9giIjHrlQJKUhkvEebxGkBJCiEevdUMbdiCjzZckhip5Q8RCjIF53lh4i5Q7pY4nFa
         S0ZI37tp/adXrxXCvy8h6eaYrsuh51L8yXRtl27gEyk19vbO8HWKY3bURSHDrnB08m9F
         g/5W0zqoSwSW0QyznhAfbtsvjIT/tGE5cGuvqOODGERRaYTirlV8fvO4NJnkrLuqAwrn
         NIQ912aDT+rhij0/BrXlmi6Rvmg8dO9SjKyxHW99Zp9UMacosCYZU7gE2WIgaBhBWUPa
         oQxA==
X-Gm-Message-State: ACrzQf2i6nkpcweCyFnbUn3JRTLniQ+MNLmwn/Ys9JiPXpyyOcVmJoYK
        FcT3FYmszpaOmtBaRIvouTAvZw8Vw9J//JMVa6FtbA==
X-Google-Smtp-Source: AMsMyM6Xj55/2opV90t0yd1EijPH3xcxgUXpi/m4kiNubkL6itrp47qTLSZaWKxZAfWtPO39vHKLm3WgHdiAkiK4KRc=
X-Received: by 2002:a0d:e244:0:b0:351:ce09:1b13 with SMTP id
 l65-20020a0de244000000b00351ce091b13mr8303180ywe.332.1664374331914; Wed, 28
 Sep 2022 07:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
In-Reply-To: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Sep 2022 07:11:59 -0700
Message-ID: <CANn89iJ3B1kcYFurAw=84cswXNSS26ER5cutYG9k9YN+zJNJ+w@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 1:43 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> for tiny skbs") we are observing 10-20% regressions in performance
> tests with small packets. The perf trace points to high pressure on
> the slab allocator.
>
> This change tries to improve the allocation schema for small packets
> using an idea originally suggested by Eric: a new per CPU page frag is
> introduced and used in __napi_alloc_skb to cope with small allocation
> requests.
>
> To ensure that the above does not lead to excessive truesize
> underestimation, the frag size for small allocation is inflated to 1K
> and all the above is restricted to build with 4K page size.
>
> Note that we need to update accordingly the run-time check introduced
> with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
>
> Alex suggested a smart page refcount schema to reduce the number
> of atomic operations and deal properly with pfmemalloc pages.
>
> Under small packet UDP flood, I measure a 15% peak tput increases.
>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Alexander H Duyck <alexanderduyck@fb.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
