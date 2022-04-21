Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7950A500
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390480AbiDUQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390477AbiDUQJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:09:08 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D21947541
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:06:18 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id x9so2475589ybe.11
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ao6JOiGIKhmxQmFS+ZxxkcT+hGHLZDm7zhluUVW/Z6M=;
        b=Dd857z3OI6w2cEAe8C8V/nguYgDUfEPP8fcN4RVDjtv0JlbqIVek/rswzW4ANfgXtv
         0gG8TZ6cCPCz3C5/QLiXvIcJ6G6oJTfzX50xaGJDrEcFkrma29C29FX/EFozYAhK3ov7
         7e5+TsxXBYvPGAjaUA/yZGvlYZ3AwvEiVjIwTDeFWfTBzSha3z1DQJg227DXeBpJhLGq
         ezavNTz4G7pcKsFRZdisaU2xN/ffE5tuOJ92mdLvd8n8cpVepi+qyayZPbPG4WgQsJV6
         /fBQ40Yte+8Mcm/Zzl7bwvW7H8vXpwZj2P0noXg34m7afARKuVWHRmXGcvy/1wDfC9Dm
         mHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ao6JOiGIKhmxQmFS+ZxxkcT+hGHLZDm7zhluUVW/Z6M=;
        b=isZuIe/1S+OCS5rW00R7XG3vLajsjnUiqB/PDb7r7ljMbp0syFQ1O0+3BIYN4Pn6bE
         qHZdpzpbBPYLAil4BgxDykGhA/H832fpL7EBaDwl5WUx60nFlhDOGbIOyEPSqs93hb0/
         1hB2rz2QNXx8u0S0I6j/CpixI3Ki6Z54a/OAEdnRDV+yR4uX/YhZiKg7uueAop4FdCSC
         NISOavnAdWRyvZHDQmQfEV+tiVWCwDqqCPH77krP84L5yfRw5h/ctGpwGrhEHB4j65Za
         2vfGWJgZSLr4ebKrgfyZnVn0NhNVLnC4NfOZia/F3/ryXMcNu1b/C4eDPZHrsHToVulW
         inxQ==
X-Gm-Message-State: AOAM530TboQeC/4c65tiFhY64yURmRD4hIKm+Eh2IAkjkvphX7oip8ZO
        GlKRgj3/9mtGPxP6AFxP5sxiP7Eb/LtzPR4pydshdA==
X-Google-Smtp-Source: ABdhPJz/v/SaLTJH6sJ0oDo4t/7tVNKumYOANhbVm8wuCj6UJIN4fpBkKrs8HINUpizT1KD8o45mabmJAByAG9kzeNw=
X-Received: by 2002:a25:ea48:0:b0:644:e2e5:309 with SMTP id
 o8-20020a25ea48000000b00644e2e50309mr357251ybe.407.1650557176979; Thu, 21 Apr
 2022 09:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
In-Reply-To: <YmFjdOp+R5gVGZ7p@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Apr 2022 09:06:05 -0700
Message-ID: <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
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

On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>

>                 for_each_possible_cpu(i) {
>                         core_stats = per_cpu_ptr(p, i);
> -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> +                       storage->rx_dropped += core_stats->rx_dropped;
> +                       storage->tx_dropped += core_stats->tx_dropped;
> +                       storage->rx_nohandler += core_stats->rx_nohandler;

I think that one of the reasons for me to use  local_read() was that
it provided what was needed to avoid future syzbot reports.

Perhaps use READ_ONCE() here ?

Yes, we have many similar folding loops that are  simply assuming
compiler won't do stupid things.
