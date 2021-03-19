Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A40D341C0D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCSMPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhCSMPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:15:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D89C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:15:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso4757576pjb.3
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfSg09eDrchIT/UwJzNK832U/gMwlaFSxHeBUAIORfw=;
        b=kfkdr9IpNqfXqhfwrgiCuaAf1q/faBvEq+SivCvEas5lqUWXYVP13boXnShLjzU3T/
         4IQCijSWiyZgGXcxruuYnRYwcZ9pajwi+NKUDtzdg0SJpNKCfXylknlB5mn89+LQqdp9
         0dFTvVF7PsDds+phWl1vmLE5bYe2R1tdITk/IcpjKfiXb9t73wwumVDHIDajIrien5oZ
         iJcspmtaEvK9KMF0k09XBVkz0YoYhxT/xjqtSiSkAXvpQUmfT8x+gTc0HnB+LoYxnX4S
         fIbnQNJU0JaaZ+s8perUBcwrrRAUpE66tYgoD2WEgkh6H+2Y6bxZS5XmubsD4/7SQ8Pw
         DJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfSg09eDrchIT/UwJzNK832U/gMwlaFSxHeBUAIORfw=;
        b=faWD74Etoya4U38kmEEAmK/zd45z08e4FpT6O7YeEXl80y9tYdJ9+5YizprR32z24f
         jrHh9d5BzcVCQOHJ1evJgwPhl/7qCQFXMoEs/0uZqDyp6HoMFC+KUME7UydcCZV126Yh
         lcvtko1f8yu/KROQCYQoq+XM+mHsWKWuRW4LiMYggxfWBMtLQc/Fk8yPRkL3f//0k4I1
         zpKlEAFsNgSH3tX+G+dCD2VMrEDiyOgyreZWyENi/SE3lDuq9S6FqWM2cBkF0Luo0+Uu
         kgG2G6KaFM2M+QB8DwMUIWKJDpWTmAzQ2HGWxNy8PCrES9X7xfkXeayP2SPNSz+V8IdL
         SnZA==
X-Gm-Message-State: AOAM531Ko/zVuxDxZr7ZhqHwXesasZw6Y9d8A65lZGrzm/0teh4ZzHux
        vhN9Rt2xfhRhmcM5yDD5tr4wOjsz7C41n2YVSh4=
X-Google-Smtp-Source: ABdhPJymNrL5ukw+vFfzWxFFqPNvtUCfPS6B7YJORd9LJy/iRnZ+Xniwqk7In2/dqIb5FRWkKPVy8RIjaxUvtPX8z5I=
X-Received: by 2002:a17:902:bf92:b029:e6:bc0:25ac with SMTP id
 v18-20020a170902bf92b02900e60bc025acmr14569333pls.49.1616156101426; Fri, 19
 Mar 2021 05:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210319094410.3633-1-magnus.karlsson@gmail.com> <20210319110023.GA20353@ranger.igk.intel.com>
In-Reply-To: <20210319110023.GA20353@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 19 Mar 2021 13:14:50 +0100
Message-ID: <CAJ8uoz3DPRaVswLZ58dTKJ6uJO1pZ6--XhnFFZ1seA8RvSgMVg@mail.gmail.com>
Subject: Re: [PATCH intel-net] i40e: fix receiving of single packets in xsk
 zero-copy mode
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        anthony.l.nguyen@intel.com,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Sreedevi Joshi <sreedevi.joshi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 12:10 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Mar 19, 2021 at 10:44:10AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix so that single packets are received immediately instead of in
> > batches of 8. If you sent 1 pss to a system, you received 8 packets
>
> pps?

Arghh, yes it should be pps, i.e. packets per second. I wonder what pss is?

> > every 8 seconds instead of 1 packet every second. The problem behind
> > this was that the work_done reporting from the Tx part of the driver
> > was broken. The work_done reporting in i40e controls not only the
> > reporting back to the napi logic but also the setting of the interrupt
> > throttling logic. When Tx or Rx reports that it has more to do,
> > interrupts are throttled or coalesced and when they both report that
> > they are done, interrupts are armed right away. If the wrong work_done
> > value is returned, the logic will start to throttle interrupts in a
> > situation where it should have just enabled them. This leads to the
> > undesired batching behavior seen in user-space.
> >
> > Fix this by returning the correct boolean value from the Tx xsk
> > zero-copy path. Return true if there is nothing to do or if we got
> > fewer packets to process than we asked for. Return false if we got as
> > many packets as the budget since there might be more packets we can
> > process.
> >
> > Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
> > Reported-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index fc32c5019b0f..12ca84113587 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -471,7 +471,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >
> >       nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
> >       if (!nb_pkts)
> > -             return false;
> > +             return true;
> >
> >       if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> >               nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > @@ -488,7 +488,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >
> >       i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> >
> > -     return true;
> > +     return nb_pkts < budget;
> >  }
> >
> >  /**
> >
> > base-commit: c79a707072fe3fea0e3c92edee6ca85c1e53c29f
> > --
> > 2.29.0
> >
