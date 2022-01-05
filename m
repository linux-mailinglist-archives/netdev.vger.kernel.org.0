Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51325484D1B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 05:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbiAEE2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 23:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbiAEE2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 23:28:43 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48787C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 20:28:43 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id q8so48164352ljp.9
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 20:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJbNqtr2a1TU681oAKLs4260v7Ep6aVnui5lC7vDIxI=;
        b=hYekwA066CqQOakPu339U55jtEJ22dcN6fTMUYhfKZf67kgCxDMx5GAdaJVFClDInw
         9RfRM6HwipKzA+eVrSjg5AVHuEqOOP7mDRINfuQJwT69+zk/SDGU2rsK5rIofTiyekJy
         cRoBBtAtiBngx+rENZtM5/Khpkjwu7WO5Y+5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FJbNqtr2a1TU681oAKLs4260v7Ep6aVnui5lC7vDIxI=;
        b=jFhxk2LLXTg+IF/4n1x7kX6j0CF13Yku1N4ltudTOrWhFOc8jQmOEN0c+QU9K6+Kav
         EOWqO9KS0aqyJSaYCpiVPpch/RgwZYhHmk7nt//dRCNeXM+cibtJhyxQr8FP0ywZJl1g
         fBT1PhDI2jBjOLzMe2R6L4A6Gi+YN4r8ZkgNutTrwLFrwQvaSoBFYAaT25GjAMaRJSx5
         oW8fuO6mHJTTWwiAQillH0sumVy2SZTsFruJObC/DkXBbbtnnGGG9cklfvUMiV+RymWt
         qpPB2LnobJxa53MlK3QBE5ApuxzrNTeWmGrQUNX9+zy739m0iE/lb6sQoDhrjlGN2Kxp
         g4LQ==
X-Gm-Message-State: AOAM530lSy72F+rsLO/YUskrNtemro1HM8pn8h8EGkhfxFzWJ4VhV9qN
        9ZVliJstkUZSbUCrLSjHo3dZJdpfmFXIvJSQH1V0CI3komo=
X-Google-Smtp-Source: ABdhPJyagF6xgwTSdVayvSTmYcLNSFPTWWx1zDpMTKB1S3P8srAkfg/RE1h6KAH19RvDzGmouOBNdzxkzMD914RPiUA=
X-Received: by 2002:a05:651c:544:: with SMTP id q4mr27748150ljp.391.1641356921423;
 Tue, 04 Jan 2022 20:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-3-dmichail@fungible.com> <20220104174732.276286f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104174732.276286f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Tue, 4 Jan 2022 20:28:26 -0800
Message-ID: <CAOkoqZmbuiHYfkzgqFzc1asdk4s1stoLT2zHQ6PCn_8GK_qb5g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 5:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  3 Jan 2022 22:46:51 -0800 Dimitris Michailidis wrote:
> > Fungible cards have a number of different PCI functions and thus
> > different drivers, all of which use a common method to initialize and
> > interact with the device. This commit adds a library module that
> > collects these common mechanisms. They mainly deal with device
> > initialization, setting up and destroying queues, and operating an admin
> > queue. A subset of the FW interface is also included here.
> >
> > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
>
> > +/* Destroy a funq's component queues on the device. */
> > +int fun_destroy_queue(struct fun_queue *funq)
> > +{
> > +     struct fun_dev *fdev = funq->fdev;
> > +     int rc1, rc2 = 0, rc3;
> > +
> > +     rc1 = fun_destroy_sq(fdev, funq->sqid);
> > +     if (funq->rq_depth)
> > +             rc2 = fun_destroy_sq(fdev, funq->rqid);
> > +     rc3 = fun_destroy_cq(fdev, funq->cqid);
> > +
> > +     fun_free_irq(funq);
> > +
> > +     if (rc1)
> > +             return rc1;
> > +     return rc2 ? rc2 : rc3;
>
> What's the caller going to do with that error code?
> Destroy functions are best kept void.
>
> Actually I don't see any callers of this function at all.
> Please make sure to remove all dead code.

Removed.

> > +}
> > +
> > +void fun_free_irq(struct fun_queue *funq)
> > +{
> > +     if (funq->irq_handler) {
> > +             unsigned int vector = funq_irq(funq);
> > +
> > +             synchronize_irq(vector);
>
> free_irq() will synchronize, why is this needed?

Removed.

> > +             free_irq(vector, funq->irq_data);
> > +             funq->irq_handler = NULL;
> > +             funq->irq_data = NULL;
> > +     }
> > +}
