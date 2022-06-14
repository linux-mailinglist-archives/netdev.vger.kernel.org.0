Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CA654B6D0
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbiFNQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351017AbiFNQuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:50:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEB946667
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:50:27 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id t32so16082276ybt.12
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DbLstPVjSZAP/sKzQ7nKqOChfTvrhIrabFpV4f08jH4=;
        b=olqJgTwsqyk+K0Jud77oIC5xu2RhJZXY7bG9+kyE0HPOHodJD26905P25NTl626WJX
         3+ACxdyZeihaFi6qZHz3cJna5eWAkPWL83fabsjMRLU3mLRJBRkt8Oj+0/PVK7EXPKsT
         alnAHsRy38+ep8Rf8UnncMtdh/pSvJ66LolhMRg+yQapdZGjzyX6tr6lEz5Xn/BPLjDK
         jn5FphCJHA2/JMIEj3620xgPFMz+CHF5PZbSSaxMI1gbYrJZAfmi/RMavwK82icBW2/W
         hFO78mHtg+Ucjmz35VcCxIWjT5+K2cSbAIK3TgUvH+8rtKlxfBahpDXXfBrnnU+CWDuR
         39+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbLstPVjSZAP/sKzQ7nKqOChfTvrhIrabFpV4f08jH4=;
        b=QNeA/EWXrLliooC0OIRNmzOe8XMiyDx19fz4iftdv74+F6KQP10oG8AqmQJsJkWmQp
         hyNd6ZnuPMqzDKeoyZ4DAGGDqrZSn1ygarZS37lhmABDRtLw4ql2HwhqG8tvnHwpyvh1
         3ecKSRQfFKb676iN02tqrthXl2JYJLmcipchJm6FSbT+OL/7ziZgcB6EZayDbjQ3b7n8
         aoTQ1oveQUbl+ZGoEs0JEEsICS6m0GhwVTxsNO9BiTouXGrrZ4LA7F38wb2IYBmAy7l9
         FZcm41W8DCIfqc+eMzapyV+kr1RUC9dzezWkCW1g9dkWhbHZHRuN+maVQwlilZycnqgT
         Nf/g==
X-Gm-Message-State: AJIora/UryOwPjY8nb4bF8bOrXdNk429tjZQrXttbRqQpyufR7MbiQtY
        S2SmVoE0Zj6O7QEcnkrc8Kgef4F7BmMhUY6KofG31V+1m3w=
X-Google-Smtp-Source: AGRyM1v5zGyJxQ8lXqUi29omUiYhZnUE6tAU4mJVKm4unW3/BcsRBA+v1/3fCdsygHsw02biU6aHdH+/3yo4EgxO4OQ=
X-Received: by 2002:a25:d649:0:b0:65c:9e37:8bb3 with SMTP id
 n70-20020a25d649000000b0065c9e378bb3mr6084525ybg.387.1655225426244; Tue, 14
 Jun 2022 09:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220614163024.1061106-1-eric.dumazet@gmail.com>
In-Reply-To: <20220614163024.1061106-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Jun 2022 09:50:15 -0700
Message-ID: <CANn89iJLo7C4hLmOQ9dQ=_RG5xx3JJSYWoyC9XoBMVFu7QHJ-w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] tcp: final (?) round of mem pressure fixes
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>
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

On Tue, Jun 14, 2022 at 9:30 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> While working on prior patch series (e10b02ee5b6c "Merge branch
> 'net-reduce-tcp_memory_allocated-inflation'"), I found that we
> could still have frozen TCP flows under memory pressure.
>
> I thought we had solved this in 2015, but the fix was not complete.
>

I will send a V2, because we need to deal with tx zero copy paths.

> Eric Dumazet (2):
>   tcp: fix over estimation in sk_forced_mem_schedule()
>   tcp: fix possible freeze in tx path under memory pressure
>
>  net/ipv4/tcp.c        | 18 ++++++++++++++++--
>  net/ipv4/tcp_output.c |  7 ++++---
>  2 files changed, 20 insertions(+), 5 deletions(-)
>
> --
> 2.36.1.476.g0c4daa206d-goog
>
