Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CACE56BF1A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbiGHQa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbiGHQaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:30:16 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88871E0A5
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:30:15 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-31c86fe1dddso155782187b3.1
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 09:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8x0u4Qyq+SD5RRHwBiqYoK9+zYIhhiga3tdyksTWuEM=;
        b=Ke8CpjfFKzsr6196M+mLfguOz2uSemxkmFfVKdbxSBvwHeT6WHPM31zJG8xNUcl9Im
         cvyMIfhEXDeCgDodBqdbsTTlQX9ygA6iaEiJ1nBzdXTa1bwQbm2DmuPp5qz6jzti/+fm
         +LeIBS0T6QdWXTcsnD7NQuDoiFmiYSIe5sLqnePqmHl6jtPUjWKVXW/s81A1OMqR4hOj
         4W/EgdjArLJwI8Ru1ujCCRwF10oFlTq31drbP5CpbOufn91EZ8wW4ia+qRtNMKmWrbS4
         VuD2vceCIIw6F2y3nBZf8vvfcL8B2UW+jF1k+hKHShrzkZc12VS5BckT4C+tYR8mU4im
         Zj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8x0u4Qyq+SD5RRHwBiqYoK9+zYIhhiga3tdyksTWuEM=;
        b=xgyDPb1Sl6AKHSamhCaqXAqXaMATkyk6KNWMXJm38fZkpEAxiQgHCAW90Jw+Ci6hVO
         mHXqlWuGlwSmkH7hiPKinn6J8DbzRvdEE1ZUc9EK0sFhY1RgbjertkwXS1YyeIrzDpF4
         Q5mPteyW5NfzED9jfF/Wxzyt1ce1/uomtpXiXEZ3hYF4I0L2wdQJM3SYI/L0CKtyDqTJ
         vGEtu5Bnlie8dzCfr5SKZLyQaq3YQ9jqL8HODhqhSfZLX9tYNtCnle3VYG3hcarAbWS/
         ODx1S00G4W9UKwZSiAZKszKZ6rmA1jHC77RP5qVyhBKeRj0Ua1BzcQGM78yO9p8eK2JU
         WtnQ==
X-Gm-Message-State: AJIora/IYCBwv2JwCNecg8pWea540gare328rnk/nw3I+jK7SSSJG3Aw
        YAiZmky4c8V9nugaWcN+OLTfIIRhNKD0LSthsLNNNw==
X-Google-Smtp-Source: AGRyM1ufy95RP7yNTqurFAf3ydE4wds25/vdJRwedyAkdmhhRLuF0a+q94glTRle8ekM9H9fEX+IwJx4tIpDBqXx7xU=
X-Received: by 2002:a81:160d:0:b0:31c:8997:b760 with SMTP id
 13-20020a81160d000000b0031c8997b760mr4826185yww.489.1657297814520; Fri, 08
 Jul 2022 09:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220708162858.1955086-1-edumazet@google.com>
In-Reply-To: <20220708162858.1955086-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jul 2022 18:30:03 +0200
Message-ID: <CANn89iLEEOKC7Xi3G_BTZbZqNx8hORoZMHMXxYu0D9U4dh-Jzg@mail.gmail.com>
Subject: Re: [PATCH net] af_unix: fix unix_sysctl_register() error path
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 6:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> We want to kfree(table) if @table has been kmalloced,
> ie for non initial network namespace.
>
> Fixes: 849d5aa3a1d8 ("af_unix: Do not call kmemdup() for init_net's sysctl table.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---

Wrong tag in [PATCH net], this patch is for net-next tree.
