Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD812DB8DA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgLPCP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPCP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 21:15:58 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C03C0613D6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 18:15:18 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id y128so1252435ybf.10
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 18:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zjBqUmfq8NIqZrwSzfkb+sBpusW9sLj6nPD5Dfw+0EI=;
        b=F4oT7uTJ8pJnHDgyp9W4M+7KKinWzyadvk7IOn75qhRHprwSgSyGLveIUYdEgPWyW2
         NVmbZ6ryszZqhe9jPBLwoIEH4xcPpemWLOMlcOVPFM95YNZv/JAe4M4Em6eO76yB4Y09
         TxEA7PpITcJG6rZkbddsmQby8vU5RurQiZok5IjK6kHQhl6emSp8KtAFS+95eE095YZH
         SQWgqYgOTuf3zUHfVQOUSZ2sr8pFB76CXDZNNMJFUf96wgNbQDaW6DxWASY/Q2kM+taN
         Y6GITQlfPcLz8MZylYu1TDOzIbLVKlikj3wDJFg4aXyIya8VmLeerV0pEKBZQePtlvYs
         i2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zjBqUmfq8NIqZrwSzfkb+sBpusW9sLj6nPD5Dfw+0EI=;
        b=QDKCsaCrYBqWGdVVzLORgtRzB3Oc63yiW99TSUWEhXSsd1gKqXI8rQa1WDXn/E70Zi
         UqBWWiAti+v+gxQd2mC9S4TgFMmeo/bEWUqzh2gnv4qKkpzupYFRk86gl6NgJTJGywL5
         Xx/10Bm5qjy84iYX8lyVBsTr3bFXJ4ZyMelzMOH4NZOy/A8v1v2m3xQSHg19c1JnRdV/
         TMTxKtJ3eUdnoxcWLXO2LoK/Mb7SYiwIiC/OFIe8F16nryGhRswhGwPvzGWAEqNhO3KA
         JpnXaBFt9k3fv96c8mCWlEf6grzxksHFwXMtjzZ9x+nwWDuYVh5Vd0Txb6W0GTr8FUpZ
         4VUQ==
X-Gm-Message-State: AOAM530HUSEsxWwsgX0vgAZvWXpZiSaTEfwESzcRfrunkBIhGnn220NE
        86wvjZGQSTONd9YsxzVQxQHO9B5De5yblcw593iUfcJu2HZRDA==
X-Google-Smtp-Source: ABdhPJxePeisz2r5WvlDl+Rqg4+elJS41Og3oyYzSmonZyiSxu7T17kTGObtL600qfH2wWOeFNmTHER0Fm6UO4U3yHE=
X-Received: by 2002:a25:ce47:: with SMTP id x68mr46636245ybe.139.1608084917036;
 Tue, 15 Dec 2020 18:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20201216012515.560026-1-weiwan@google.com> <20201216012515.560026-3-weiwan@google.com>
 <20201215175333.16735bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215175333.16735bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 15 Dec 2020 18:15:06 -0800
Message-ID: <CAEA6p_DdarvYYSdnof+mEWJ=R7gBLB0By9EME2ZEfvGBhhN+Yg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/3] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Dec 2020 17:25:14 -0800 Wei Wang wrote:
> > +void napi_enable(struct napi_struct *n)
> > +{
> > +     bool locked = rtnl_is_locked();
>
> Maybe you'll prove me wrong but I think this is never a correct
> construct.

Sorry, I don't get what you mean here.

>
> > +     BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> > +     smp_mb__before_atomic();
> > +     clear_bit(NAPI_STATE_SCHED, &n->state);
> > +     clear_bit(NAPI_STATE_NPSVC, &n->state);
> > +     if (!locked)
> > +             rtnl_lock();
>
> Why do we need the lock? Can't we assume the caller of napi_enable()
> has the sole ownership of the napi instance? Surely clearing the other
> flags would be pretty broken as well, so the napi must had been
> disabled when this is called by the driver.
>

Hmm... OK. The reason I added this lock operation is that we have
ASSERT_RTNL() check in napi_set_threaded(), because it is necessary
from the net-sysfs path to grab rtnl lock when modifying the threaded
mode. Maybe it is not needed here.
And the reason I added a rtnl_is_locked() check is I found mlx driver
already holds rtnl lock before calling napi_enable(). Not sure about
other drivers though.

> > +     WARN_ON(napi_set_threaded(n, n->dev->threaded));
> > +     if (!locked)
> > +             rtnl_unlock();
> > +}
> > +EXPORT_SYMBOL(napi_enable);
>
> Let's switch to RFC postings and get it in for 5.12 :(

OK.
