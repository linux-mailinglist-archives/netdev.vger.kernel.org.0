Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3695FDDC7
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJMP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiJMP5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:57:13 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3CDAC7B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:57:03 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 126so2562782ybw.3
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U086MnAqmlts9nTr1qcAhivQ37idqW8pg8frbA1SRUU=;
        b=VAZ0KRYdeCr5BhXcqx4apCYK4OVMOcIZw+uwedyOaJLG44hTMWTYcG4nRnu8IiGAN8
         TFa80n+Rl6mgFRb92QkCcJ/3itV1w7+i6VA4S1KomjFsp97s7nn8Woz3evOt+zknUy9k
         Q5txZan3MRRe4CVqSwuWefIUP/MXbaQe31JXAgXLxN0GltEBpy3ElGkQxDfG4ppNnlQS
         N2FhtDbVvY+Z9GcDrZFweKyv5+0H+XYzI0Mv8oQUfQLttXHErVGYMuZCeU4iQb/MdeSr
         uov4bV/8EMolpCFWfMq8J3OaZhFuNnh/JZwjA86G0Kg8ejcrmQTHEweWOjiHwu6GGrGm
         4syw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U086MnAqmlts9nTr1qcAhivQ37idqW8pg8frbA1SRUU=;
        b=AodvzefpD55vqXJ53ARcuaChy5PXKdav1ockBTmK/lzhDSJSkON5FfOCyPmvZoUcKy
         eTdWFZoCJtJYdckq9PfEO4+DNOWm8nMtTkDuNdh4+sQEgMLisSiyfI2cW3DcSrVTHbyd
         hZ2FLcMcoalSlkP92vwhc8672lswp/0uXtTJcvaVfcR+OJzIWUE+zSzZb2v5PO6FfoVr
         sjftFrKCkUpvH7itzA3PimmfjbTwO5UjJkxbLXSP53gg+qZQ0bhTwYJP/09eC+irAPRJ
         t60hdwCCUWbMd0NY2KfYmrfy3wMrC08ULfXxjwOUgppTRM8PpmBiBk9zObkPDCHpY+Db
         rDwQ==
X-Gm-Message-State: ACrzQf2LShxoBr8h8kUn7tk5UX9NUOCX7guoU/LNlpaq2UFR9LvuoOtF
        PUY4jHsRP3n3JoFS9cOmVBru5JWgrXiTUgF2Q4gNVQ==
X-Google-Smtp-Source: AMsMyM4QaoYvfpFma9/NLlZfXpq9kxmftrV0WU9hlJ4D0cWlNF+YrXyF/PvYoFYSWHibvIX4rI40ai0o7KNsn+gd17U=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr570889ybx.427.1665676621803; Thu, 13
 Oct 2022 08:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221012145036.74960-1-kuniyu@amazon.com>
In-Reply-To: <20221012145036.74960-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 08:56:50 -0700
Message-ID: <CANn89iJzkYBGRNaEP8YghGYZfWcAYgSg-OqycLH69m2wkutCjA@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
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

On Wed, Oct 12, 2022 at 7:51 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Eric Dumazet reported a use-after-free related to the per-netns ehash
> series. [0]
>
> When we create a TCP socket from userspace, the socket always holds a
> refcnt of the netns.  This guarantees that a reqsk timer is always fired
> before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> listener is not freed before the reqsk, and the net is not freed before
> the listener as well.
>
...

> Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
