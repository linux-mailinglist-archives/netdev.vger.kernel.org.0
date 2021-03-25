Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAD43494AF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhCYOyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhCYOyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:54:03 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B62C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:54:03 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id y18so1979786qky.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WcUAfakiaRflXJsbFLsUfCZemSovJNHWXiRp28Iky/s=;
        b=Dmt9ROX72lZBYf7Mz+uAwKzOzzentjY7qaEzLmonFU4p6Azby+5hx1JfR54diifhZN
         7jWv9nyFfUSIav577e0aj/TpyaFG+OsmkUAc5BCy4jUtva24pRv0awSv16FF+ToV0IHu
         gTP8UtqOO9kwpn9uTLT/iCe8z2cv+S8cP/C1yNfhFpi98RCX3ivUsqsvl4PmX/7S7nK5
         6KlKeM46LvuLy6R04B6+lfqDIHpOtS49Xl8vqa+IiR79CMZl9hKUrTjG19iXjwIQWmch
         PJyHMjeq5AnipQmDbxuV4Ivedfz3eaBNsAFHO9rOVbWExPQODOtQUe4ct9MfVmZGQ03w
         TlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WcUAfakiaRflXJsbFLsUfCZemSovJNHWXiRp28Iky/s=;
        b=o6s+XOH+gs2eQHM0wV0Qf5QDc+pG3T5KrgufGoFUlqhONWYfzr8vcuCSF52PjgL7ji
         QrvXNU8KhZRqlYCkCUCvJrYSqHxbk6gfIcXVU6d9BJYngyRnxvFgIfipyqzSHCh9fXNz
         WEr9IP4KC68O5e9H/KrQzdoPc23LOeTuPXhaqQeecmkttvQSMs5CR/nXYMkEmf48dNF0
         QeINIf2P8S/0EpjXzSCPH4UJH4Xskd/Dl8m7HokTQWPBWdgfAXZfdzRq25ocwDjKj75W
         7wU9HODC8aulwSs8bRGpL5zEhCC92k/msa1EwDDcjTDXpvF+XL70YMAKROADx7ZGjPCk
         vdnQ==
X-Gm-Message-State: AOAM532oPtpKmap7aEXL9atlfrfT6gNXjkxqOEMxN3M5QglDF33hO3x8
        HBqtSy1kZPZXQmuitg9UxhjYOPX0+ent0mNBVDK24w==
X-Google-Smtp-Source: ABdhPJySEzdLTk7YsG7O3I3ubTJVxsPdVO8ILzkXXeBfiykqa8dLEyAFFCePMfOYEQeo2m2g6DxfFSw4Uk9/L02NOfg=
X-Received: by 2002:a05:620a:2095:: with SMTP id e21mr8353814qka.265.1616684042120;
 Thu, 25 Mar 2021 07:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210325103105.3090303-1-dvyukov@google.com> <651b7d2d-21b2-8bf4-3dc8-e351c35b5218@gmail.com>
 <CACT4Y+ad6bwMbQ6OwrdypCsNRvYTMtMf0KR2EpVOhPOZvnxeNA@mail.gmail.com> <c6e79b82-50dd-633c-8d63-77c059538338@gmail.com>
In-Reply-To: <c6e79b82-50dd-633c-8d63-77c059538338@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 25 Mar 2021 15:53:50 +0100
Message-ID: <CACT4Y+ZVPrZMs3Uq0O1iSCtmwnNHKzbYV2W2Mu43cerrWZt6rA@mail.gmail.com>
Subject: Re: [PATCH] net: change netdev_unregister_timeout_secs min value to 1
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 3:43 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 3/25/21 3:38 PM, Dmitry Vyukov wrote:
> > On Thu, Mar 25, 2021 at 3:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> On 3/25/21 11:31 AM, Dmitry Vyukov wrote:
> >>> netdev_unregister_timeout_secs=0 can lead to printing the
> >>> "waiting for dev to become free" message every jiffy.
> >>> This is too frequent and unnecessary.
> >>> Set the min value to 1 second.
> >>>
> >>> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> >>> Suggested-by: Eric Dumazet <edumazet@google.com>
> >>> Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
> >>> Cc: netdev@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> ---
> >>
> >> Please respin your patch, and fix the merge issue [1]
> >
> > Is net-next rebuilt and rebased? Do I send v4 of the whole change?
> > I cannot base it on net-next now, because net-next already includes
> > most of it... so what should I use as base then?
> >
> >> For networking patches it is customary to tell if its for net or net-next tree.
> >>
> >> [1]
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 4bb6dcdbed8b856c03dc4af8b7fafe08984e803f..7bb00b8b86c6494c033cf57460f96ff3adebe081 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -10431,7 +10431,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
> >>
> >>                 refcnt = netdev_refcnt_read(dev);
> >>
> >> -               if (refcnt &&
> >> +               if (refcnt != 1 &&
> >>                     time_after(jiffies, warning_time +
> >>                                netdev_unregister_timeout_secs * HZ)) {
> >>                         pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
>
> Please include my fix into your patch.
>
> Send a V2, based on current net-next.
>
> net-next is never rebased, we have to fix the bug by adding a fix on top of it.

Ah, got it. Mailed:
[PATCH net-next v2] net: change netdev_unregister_timeout_secs min value to 1
