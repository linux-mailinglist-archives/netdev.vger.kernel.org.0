Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E038AF1D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbhETMvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242269AbhETMvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 08:51:07 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B0DC06916D;
        Thu, 20 May 2021 05:13:57 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id b25so16244439oic.0;
        Thu, 20 May 2021 05:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=acaajPzuKCDrOFX5gmmTjekv1R6GhRxiFcjrlWBQ62A=;
        b=LqFXQaa0+PrzE8lY/mSLntTGLHm6S54Dq1PdCCJQ9YEA6YSs6Sm8UAKNdQYIRX7GFU
         l0BtZrvCVvQOszSdgDT3oU60EcqmuaUcVSMbtnBYzMEEBmdFuH43r+D4EXPz/Yxzq/Fk
         TcKaTm5d1E0j/5COr1RmAfmr4SnT6R7jX4SBkEiw48tWdY7ij2bLVp57XnGJWPvnuU58
         GQe2IEb6ueJWHrU0yF6Z9GkRc+0MT5GCZLMcCwyc6dhM+6yYJtbyZbNyLx4fIt44uHeY
         3N0YD7VNR0dhqSSkLr0XmA90za38UswtvQR9NFxXqRdIwfl4Pw+0860HeAT8GY6OPfgK
         Sw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=acaajPzuKCDrOFX5gmmTjekv1R6GhRxiFcjrlWBQ62A=;
        b=jcpwCFTLHXXmg0rRywxCQbqSyVbcP6whu3GMtwBHNhVfp0m2keSbLuoZEJoWPY14om
         ouBIBCPijX2nU3RT9E709mfCzfr961B7ieKu3TuxSYqBfN1zbqXvgRPwHCXWDn60u9p0
         iR4Du100/G3PiZTstsmTpSlrqBRPXRRlDoi0Smm2gGbvxpw4g4vZJJ6rn0UqNZbwvcVQ
         ztrzPwiAP1XyGDSL+4BuEQeZZ64e5ReIgvOlv9JeNW6EzYhUN9ldG7RVuDQHZO0J/DCF
         GYBMwitelfAbLXv28eSWXwSnVqwD9NO6yRRH0/iB0PWMLO9cnPmBHXUJ+U1GQ+KZ12Ri
         wLXg==
X-Gm-Message-State: AOAM530s+Kw2C8GHR3C7bzSBDIHtb1+gw4RXnOBVUbIBGt7zcVlmIqCT
        6oxBBm9olOhn7KftCBn9EpMnZKRkc1iEGf8HAg==
X-Google-Smtp-Source: ABdhPJyjLQC8w35cvcxLwyvOQqhRZnBH4AQwZ3j123NQN1fwLUTBeNtwM9PHIPM2mMIQwwddbRiHsEDQ6h8X8yBhDOo=
X-Received: by 2002:a05:6808:143:: with SMTP id h3mr802936oie.96.1621512836598;
 Thu, 20 May 2021 05:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <1621406954-1130-1-git-send-email-zheyuma97@gmail.com> <20210519.122605.1971627339402718160.davem@davemloft.net>
In-Reply-To: <20210519.122605.1971627339402718160.davem@davemloft.net>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Thu, 20 May 2021 20:13:45 +0800
Message-ID: <CAMhUBjkCdP-jfnKwAwdCR78tMqgHTPW6qVssE6T66=NrWznkJQ@mail.gmail.com>
Subject: Re: [PATCH] net/qla3xxx: fix schedule while atomic in ql_sem_spinlock
To:     David Miller <davem@davemloft.net>
Cc:     GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 3:26 AM David Miller <davem@davemloft.net> wrote:
>
> From: Zheyu Ma <zheyuma97@gmail.com>
> Date: Wed, 19 May 2021 06:49:14 +0000
>
> > When calling the 'ql_sem_spinlock', the driver has already acquired the
> > spin lock, so the driver should not call 'ssleep' in atomic context.
> >
> > This bug can be fixed by unlocking before calling 'ssleep'.
>  ...
> > diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> > index 214e347097a7..af7c142a066f 100644
> > --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> > +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> > @@ -114,7 +114,9 @@ static int ql_sem_spinlock(struct ql3_adapter *qdev,
> >               value = readl(&port_regs->CommonRegs.semaphoreReg);
> >               if ((value & (sem_mask >> 16)) == sem_bits)
> >                       return 0;
> > +             spin_unlock_irq(&qdev->hw_lock);
> >               ssleep(1);
> > +             spin_lock_irq(&qdev->hw_lock);
> >       } while (--seconds);
> >       return -1;
> >  }
>
> Are you sure dropping the lock like this dos not introduce a race condition?
>
> Thank you.

Thanks for your comment, it is indeed inappropriate to release the
lock here, I will resend the second version of the patch.

Zheyu Ma
