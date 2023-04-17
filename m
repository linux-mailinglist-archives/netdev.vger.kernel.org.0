Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B746E4633
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjDQLRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDQLRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:17:31 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F04976F
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:16:37 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id w19so7641395uad.7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681730178; x=1684322178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OP0XOG62qs4RSc2YbVhPnkHep9WoahQsFHFcUdGKKoU=;
        b=ubGAA8HDbhBw1OGW9wwC6pUSXFO6fFB3swXaTjEAB2YFMFrXxF76MsafOYU6boBjHW
         XSk9GFwVU52G/VIzUH93piFPu8TWECqM0JV16odQpk+OxO+solZCS1mKdFolqKto15rv
         MBlCkQroIML/c86/0uGMJtWU28i9ts2JbZdzOv5/ATDClwWyncOFEFzGyIoCJClBDd+k
         zfoH8FZLjUhbz7CtUdwilif7xgB8s1TzwImrCct36tkTTzANAs1YHwt8YVUeWfGPcHOM
         YlOTfR6eYtBtmFOXvRSkRnibzky1iNQdRn8XDBgSyJRp/4c3+TreH8DVXVMA3jaECTA0
         my/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681730178; x=1684322178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OP0XOG62qs4RSc2YbVhPnkHep9WoahQsFHFcUdGKKoU=;
        b=eHX1NnQ3Hz7BL1LcG4jLngfR4Yze4YTDMTB1hayz7aJv5iRJYoWrPP0Bvv8rK3p3CM
         eNJ+OWHkpES5apqVDSPw7LPzASx1gha6X84R+/BBspFPZSinlRdIBpw0R6e4y3YLsgWT
         K1w7t7vKdV5nGpGJzh88St5oFzLXMlGuNIYpBypV6xZI2PABUHSav1+UL1tVt/7uHlkO
         nBLcKCgWiqxHnoTm1B3ushlySruupLHsyr1JQGuD0ni4AYMgTh7E13gkjkYXILorkgjX
         lXbn00gw8Vzj8e2GlIQ7ILrfTctw7Z1J1BQydAjj0Gs3tYVjYXoBtno5BSk5uNE6xShM
         RQmw==
X-Gm-Message-State: AAQBX9f6LU2V805V0f+/enxQQiUlpfpvX4oJZdMyH820vS2nGJduXgMI
        rXCazLJ+hGE7mwn8gtharDFmfTbiYWaQ46Mq4mL6zsgrf3bWklbZ7ldt3g==
X-Google-Smtp-Source: AKy350b9g1+A6K9XLTWGAdJ8ARmb59s5J4GBuoTARIXaZ3p3yxRXkd837jxt/5MLXvF9mHFv4GHefrqy4fKqDY/PNk0=
X-Received: by 2002:a1f:2f81:0:b0:410:4a2c:1e9a with SMTP id
 v123-20020a1f2f81000000b004104a2c1e9amr6772614vkv.1.1681730177834; Mon, 17
 Apr 2023 04:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
In-Reply-To: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Apr 2023 13:16:06 +0200
Message-ID: <CANn89iJy57p6rxguw_FFAb1KoQsaxzSCCGtdcA=ckeLe-bs4Fw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Apr 17, 2023 at 1:02=E2=80=AFPM Davide Caratti <dcaratti@redhat.com=
> wrote:
>
> if sch_fq is configured with "initial quantum" having values greater than
> INT_MAX, the first assignment of "credit" does signed integer overflow to
> a very negative value.
> In this situation, the syzkaller script provided by Cristoph triggers the
> CPU soft-lockup warning even with few sockets. It's not an infinite loop,
> but "credit" wasn't probably meant to be minus 2Gb for each new flow.
> Capping "initial quantum" to INT_MAX proved to fix the issue.
>
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/377
> Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
Thanks.
