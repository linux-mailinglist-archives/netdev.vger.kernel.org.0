Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DED302122
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbhAYEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbhAYEfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:35:31 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F55C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:34:51 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id o10so9764510wmc.1
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bbeEvVOba4VXo8Nj9FZx3pZL50E5br1lQiQNoIUDTZQ=;
        b=sUp4zYLyDJiJ77NADPzzAI+RQVJdT3YOtTjXHYuSMbciI1T+zKk+XS9/rSxXbqmjk8
         PO13llfEZlcgeV3NFF1IJozB218PmtGHjTNgXNTabkkR5o3zdvD3uKrxZs9MUA88q4GA
         Fcu7Zz0CdALlq0qrP/A94TdRCeM0kLsLAugbYCH+QDhCIFuJSQ/4QtIi1LJ+WBm7jiuN
         dn2vOjCPg4xSS605ubgN4D/rLizpHxTuiKM8l7Eent7/GfpWJga+GOq/jvSLIApDMSv5
         sN+ZbH2VLvF/SPn8m5yY2FPGUhZIlJUBwlMJcOmg0jZN/Nxvr0MZ4oxnX0AHVFHFJFQz
         aOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bbeEvVOba4VXo8Nj9FZx3pZL50E5br1lQiQNoIUDTZQ=;
        b=cg8e0BoQI1+Nd/wgkQWlgyMRb7BMYDvE+LOaVchcEwClJSPNv10UikKDxXldEjIuF4
         BdoPFSp1gquGKG1u/lCkIgA+aMS7efxgSnoRcl4LNky86nhiJSEc1kJe7dwKuoF8YfRv
         5wPrnFZPHHCM+fLYPbX4ZShrGfNdJhzaZ7/IygNlPb9s33jOM36dl89GL9yI+Xqcs4QA
         3l4BrzgGF1NUKCzcdf4NbTxb1X3lFGXNN1Numns9LsFsEgR4mv5NuxMJZiPisZ4gG4Su
         WbmaYd/j2WcSINqlEwfMiGytgEcRB8GQjEtMcF18cmMymGmBVYIg/CCgOLYpzh1qgesV
         Xc8g==
X-Gm-Message-State: AOAM532gqSBlIgHBwVgNRxtJc7qloCapErWWbX76IoRUrSWgY9GFcqw0
        jOloZNoWBSOYWI6UCLfHudBdNkPa/GnXbJPVpnA=
X-Google-Smtp-Source: ABdhPJzx9fJqeKg3J855kZlVY081C+lp6FidJxhje9OdzsOMgoZjuZxy0D0RuV2lDBkF1b+x+1f+mQP6DaVdBQmeZQY=
X-Received: by 2002:a7b:cbd7:: with SMTP id n23mr32305wmi.162.1611549290091;
 Sun, 24 Jan 2021 20:34:50 -0800 (PST)
MIME-Version: 1.0
References: <20210121061710.53217-1-ljp@linux.ibm.com> <20210121061710.53217-2-ljp@linux.ibm.com>
 <20210123210833.21f6b8de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123210833.21f6b8de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Sun, 24 Jan 2021 22:34:39 -0600
Message-ID: <CAOhMmr7upfLThTcKQ3G4yg4t27JMpT0EfL5earuANvZG+V_n7g@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ibmvnic: rework to ensure SCRQ entry reads are
 properly ordered
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 11:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 21 Jan 2021 00:17:08 -0600 Lijun Pan wrote:
> > Move the dma_rmb() between pending_scrq() and ibmvnic_next_scrq()
> > into the end of pending_scrq(), and explain why.
> > Explain in detail why the dma_rmb() is placed at the end of
> > ibmvnic_next_scrq().
> >
> > Fixes: b71ec9522346 ("ibmvnic: Ensure that SCRQ entry reads are correctly ordered")
> > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
>
> I fail to see why this is a fix. You move the barrier from caller to
> callee but there are no new barriers here. Did I miss some?

I want to save the code since it is used more than twice.
Maybe I should send to net-next.

>
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> > index 9778c83150f1..8e043683610f 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -2511,12 +2511,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
> >
> >               if (!pending_scrq(adapter, rx_scrq))
> >                       break;
> > -             /* The queue entry at the current index is peeked at above
> > -              * to determine that there is a valid descriptor awaiting
> > -              * processing. We want to be sure that the current slot
> > -              * holds a valid descriptor before reading its contents.
> > -              */
> > -             dma_rmb();
> >               next = ibmvnic_next_scrq(adapter, rx_scrq);
> >               rx_buff =
> >                   (struct ibmvnic_rx_buff *)be64_to_cpu(next->
> > @@ -3256,13 +3250,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
> >               int total_bytes = 0;
> >               int num_packets = 0;
> >
> > -             /* The queue entry at the current index is peeked at above
> > -              * to determine that there is a valid descriptor awaiting
> > -              * processing. We want to be sure that the current slot
> > -              * holds a valid descriptor before reading its contents.
> > -              */
> > -             dma_rmb();
> > -
> >               next = ibmvnic_next_scrq(adapter, scrq);
> >               for (i = 0; i < next->tx_comp.num_comps; i++) {
> >                       if (next->tx_comp.rcs[i])
> > @@ -3636,11 +3623,25 @@ static int pending_scrq(struct ibmvnic_adapter *adapter,
> >                       struct ibmvnic_sub_crq_queue *scrq)
> >  {
> >       union sub_crq *entry = &scrq->msgs[scrq->cur];
> > +     int rc;
> >
> >       if (entry->generic.first & IBMVNIC_CRQ_CMD_RSP)
> > -             return 1;
> > +             rc = 1;
> >       else
> > -             return 0;
> > +             rc = 0;
> > +
> > +     /* Ensure that the entire SCRQ descriptor scrq->msgs
> > +      * has been loaded before reading its contents.
>
> This comment is confusing. IMHO the comments you're removing are much
> clearer.

I did not quite get what fields in the data structure are supposed to
be guarded from the old comment. Then I asked around and figured it out.
So I updated it with the new comment, which tells specifically what
the barrier protects against.

>
> > +      * This barrier makes sure this function's entry, esp.
> > +      * entry->generic.first & IBMVNIC_CRQ_CMD_RSP
> > +      * 1. is loaded before ibmvnic_next_scrq()'s
> > +      * entry->generic.first & IBMVNIC_CRQ_CMD_RSP;
> > +      * 2. OR is loaded before ibmvnic_poll()'s
> > +      * disable_scrq_irq()'s scrq->hw_irq.
> > +      */
> > +     dma_rmb();
> > +
> > +     return rc;
> >  }
> >
> >  static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
>
