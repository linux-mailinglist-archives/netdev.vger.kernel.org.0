Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2401E32D4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404089AbgEZWoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403813AbgEZWoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:44:04 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68644C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:44:04 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id v79so12447525qkb.10
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kc/okzUydsoti3vjkA2/22w6bk77rEL1lNaQR8D0PVY=;
        b=hRysCUy3rVYoerdo7DnuqfWVcuor9z2Be3U1IW3jsonh5k5gyl0zgafZbdXbY4IJv/
         XK9ZCFvsOCviaEKVHQ/pcWnAaTrerZRA9T6TcDE2eccl33B2bNPxVt93kl8UwwH+OZir
         bYTQAaAF+7Zmc/wZ4/CFeST0WugVWYnjwfgGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kc/okzUydsoti3vjkA2/22w6bk77rEL1lNaQR8D0PVY=;
        b=hN0MlXfbx+UKIuQjD6uh2xyVM7h573wNUgRpwWohbVIOujK3ZkfIWDEi0Besj0689F
         Qa2CA+9Q4ubf7gXkTtD8Kq+8dZDoE/Hjll90S1WY7ENWAmM7dx2NzzJVdHpDhAiCTqdc
         oP89XnJ1oxFk8zxPldEJtbDn2bVzN078lQIGGWs/vxqoH3asaDoi3DnL4CBPlrYfjJ6B
         ZIDI2MyR/YccYvJzVRhBBV2gehqXVoJR69j+8ex6pqT0+SVohfmX54Z9IvcnrMjX7DXB
         DXccCuzgixYlQVW4fAxyeR5OzIWAeaNKDz4x3zsWQAKpVO/E7oqWz24CasnHlriPaAPJ
         rCnQ==
X-Gm-Message-State: AOAM530whS0nAGE4P1PhsXt/X5tIB90BXINlaH1TUWsmq6rxy2GU1mYf
        jMovBJ9mZF0NBnf3izkRPBOJ9S8OQtGoeHaFbWXILCpQ
X-Google-Smtp-Source: ABdhPJxZ6gVXZPh5sRcD24cQiRf4FF2MSfWuEpEMRr7+XK3CJC1FsS/ywchjt0aE8EIkR2C5Wrvh33H0psZv1bK1XFE=
X-Received: by 2002:a37:470e:: with SMTP id u14mr1159112qka.424.1590533043476;
 Tue, 26 May 2020 15:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
 <1590442879-18961-2-git-send-email-michael.chan@broadcom.com> <20200526150443.7a91ce77@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526150443.7a91ce77@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 26 May 2020 15:43:52 -0700
Message-ID: <CACKFLikEenWcFw+q6Kk=Cm8H-LSU4kNFJwVujWcHq_Mna981Dw@mail.gmail.com>
Subject: Re: [PATCH net 1/3] bnxt_en: Fix accumulation of bp->net_stats_prev.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 3:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 May 2020 17:41:17 -0400 Michael Chan wrote:
> > We have logic to maintain network counters across resets by storing
> > the counters in bp->net_stats_prev before reset.  But not all resets
> > will clear the counters.  Certain resets that don't need to change
> > the number of rings do not clear the counters.  The current logic
> > accumulates the counters before all resets, causing big jumps in
> > the counters after some resets, such as ethtool -G.
> >
> > Fix it by only accumulating the counters during reset if the irq_re_init
> > parameter is set.  The parameter signifies that all rings and interrupts
> > will be reset and that means that the counters will also be reset.
> >
> > Reported-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> > Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>
> Hi Michael!
>
> Could you explain why accumulating counters causes a jump?

Yes, during chip reset, we free most hardware resources including
possibly hardware counter resources.  After freeing the hardware
counters, the counters will go to zero.  To preserve the counters, we
take a snapshot of the hardware counters and add them to the
bp->net_stats_prev.  The counters in bp->net_stats_prev are always
added to the current hardware counters to provide the true counters.

The problem is that not all resets will free the hardware counters.
The old code is unconditionally taking the snapshot during reset.  So
when we don't free the hardware counters, the snapshot will cause us
to effectively double the hardware counters after the reset.
