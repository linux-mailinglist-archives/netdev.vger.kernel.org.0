Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE944DB948
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbiCPUZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiCPUZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:25:46 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3122AC54
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:24:31 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id pv16so6681892ejb.0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2BUOg6nzpx/rS6eVs0jjAsHQW75uUaBJm76wT5d4W1I=;
        b=hfTSxmFC2vx3RQuiyx4WPTUpEZxKUCw9PCHT/9Y7hyvbvDZFbzIVDsjA7wvQH1KnsY
         h0R+rs9a62Ps7GCnrZig3oPEwNHny6HOgL78b4zaKlOdEQzPP3q1RvAhoJ4diHifAWEt
         Pw4FquwXZRhGWmQO4qPEI/uF5ol5s/7hY2hBqJiP6tAgQHivSG8jsICqQAlrwkemyFAb
         VzFVOunUcHOhwM1n/W/WFJxI1sGNprEcnNVATM217WOAo0wPXBFVSlzcyPQCsejkMXyQ
         RPYSTVZ5CiJDoP0/NEROU+9p4U+RO8uTBiFbg1KNwwBBw/qtfcokNEgn48ophucJPpc6
         q9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2BUOg6nzpx/rS6eVs0jjAsHQW75uUaBJm76wT5d4W1I=;
        b=ILttmOaoiEzk/vtEoXx9DKACunzZS+aOexExtkKf7upzcWedGdcKtKnxlPxramg7Kz
         VTedkBX837Ca/30/r1etyfmG6vIom2YD7g+gPTKSUEzd/whvwhUkoyAJDspJBP91d3p1
         UCvmvXdU0x1NSLdYXhSwtID9UdaZt/0xTLAeumfXWjvjW0940mT942UbNnnZa3x6M4OU
         +o0THIBK/S7pVj9m+DjYy6g1jiJTwe4p9WJRriPhV5m/FpwAmSwDZHnz/T+qm/LmJBZT
         gH7QjJCDx0zFqJEHPdEh6yYHvuYzDvVdlorOAJDy50Tz78s8yTH+bbClHoWvoSO2dDSC
         bVcQ==
X-Gm-Message-State: AOAM53221lXjy/dec88WXRtA9fy70d2Q9ys87fuJyH/TR1cQHPZyLOdV
        JGc69yq3q4839hmpHoPvOEyyN5hA3zUOEiwJJ0Y=
X-Google-Smtp-Source: ABdhPJwWTg8xJQVRTfB71CCllxTbaKuUleo9hhXFrZpvFEDzResFK5/SSFfYY45QA5cDHNf7FxS/6N9bvsw397WqcWQ=
X-Received: by 2002:a17:906:2584:b0:6d6:e5c9:221b with SMTP id
 m4-20020a170906258400b006d6e5c9221bmr1450972ejb.514.1647462269917; Wed, 16
 Mar 2022 13:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
 <20220315211225.2923496-2-anthony.l.nguyen@intel.com> <20220315202941.64319c5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e0d1a5caf1714f303ae89c909dfa4d04ebdde3e4.camel@intel.com>
In-Reply-To: <e0d1a5caf1714f303ae89c909dfa4d04ebdde3e4.camel@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 16 Mar 2022 13:24:18 -0700
Message-ID: <CAKgT0Uc3MPiVijAMc3opdqUmEXMT3umqYWMrowHznoT=L=-5nw@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>, lkp <lkp@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 12:01 PM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Tue, 2022-03-15 at 20:29 -0700, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 14:12:23 -0700 Tony Nguyen wrote:
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

<snip>

> > > pointer is valid, but later on ring is accessed to propagate
> > > gathered Tx
> > > stats onto VSI stats.
> > >
> > > Change the existing logic to move to next ring when ring is NULL.
> > >
> > > Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate
> > > structs")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > > Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
> > > worker at Intel)
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > > b/drivers/net/ethernet/intel/ice/ice_main.c
> > > index 493942e910be..d4a7c39fd078 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -5962,8 +5962,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi
> > > *vsi,
> > >                 u64 pkts = 0, bytes = 0;
> > >
> > >                 ring = READ_ONCE(rings[i]);
> >
> > Not really related to this patch but why is there a read_once() here?
> > Aren't stats read under rtnl_lock? What is this protecting against?
>
> It looks like it was based on a patch from i40e [1]. From the commit, I
> gather this is the reason:
>
> "Previously the stats were 64 bit but highly racy due to the fact that
> 64 bit transactions are not atomic on 32 bit systems."
>
> Thanks,
>
> Tony
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=980e9b1186424fa3eb766d59fc91003d0ed1ed6a
>
>
> (Resending as some non-text formatting snuck in to my reply. Sorry for
> the spam)

Actually the rcu locking and READ_ONCE has to do with the fact that
the driver code for the igb/ixgbe/i40e driver had a bunch of code that
could kick in from the sysfs and/or PCIe paths that would start
tearing things down without necessarily holding the rtnl_lock as it
should have.

It might make sense to reevaluate the usage of the READ_ONCE and rcu
locking to determine if it is actually needed since much of that is a
hold over from when we were doing this in the watchdog and not while
holding the rtnl_lock in the stats call.
