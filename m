Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272C8376115
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhEGHZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhEGHZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:25:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CEFC061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 00:24:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n84so4668852wma.0
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 00:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K42tngszNSdkaHIJaExOS3M8P/GdvDfzingPlFrUO8M=;
        b=JhxJBXe7c46BVXHMdifT13YizrYqt7E/iTew+fYZJxlQec/CQ5T5gz/zzpZf8kNyMX
         /ufjLdbMPtYbShxA0IMTKayOFKl/rOkAWEYHB/QOd3IZB67EMe26Ewn927d3wpZR0mfP
         dYPmRPkD6eHyB7uJYgBzOMfSbx6zBaFWTQl2PJaXdGBGBkKSX7umfsyDzRwhCG9kh00f
         6H2rPUdgDxkX35rrZZLVsnGRzRqs8/l6ws7lnhT1JtK/+DB3/T/Ko1+XEuLT/z1C9GQn
         UPy/gXjyrV8yLf+AB7AQ6v+n13SwoA9FTVYmmIxM6gWI3fte1GbG3otRG6PvJ3oxup73
         m4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K42tngszNSdkaHIJaExOS3M8P/GdvDfzingPlFrUO8M=;
        b=fHkpGIuDDZGQD7IBQ/KVtCsXFmxJAG7y209li27ESer4luMMatJyoEoyykU0aSPLMI
         INYic63jimKtafZD9LJ0woGpCnC7cqmSqxMAbowQaBRK4VvuwcBOv3yYN53hkAObonhB
         SpCpA8NdhZC0l/nx6vKwymVCPwFcy1bKr6eA+tQTleepN8Z2ZqFO2uzBes3XtttmdMpF
         LkVw3Eui/OiAcUVC8uzAvbODjwFSAbmaDsh7icpUfK77ooPDbfjHIvYjp6zjJzLuiP68
         TyCEPs1kPlUny0/7n3wAl8+e+C4uo0ufJapJRoYjaeLLak9sT40F0D02IUMize5blkYy
         WwoA==
X-Gm-Message-State: AOAM533yLywtMT/Ousx/LjcstuV7Jjp3t/wqG8afLzzrilcUCMUb7QxU
        22aQDnVeztY3lTwqtAYMwyxr7m39feXFsquI9WHIp7afpT0=
X-Google-Smtp-Source: ABdhPJxgj3g+lVjMSuTxpErj8fIA9nSaCWRKVuHWeO+sh4LXI9mFDhcsLJc9TKcSP/zT7zoEOrf+cHayuXXcOd+UGHA=
X-Received: by 2002:a05:600c:3643:: with SMTP id y3mr19183472wmq.159.1620372279560;
 Fri, 07 May 2021 00:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210504191142.2872696-1-drt@linux.ibm.com> <CAOhMmr5T_BLkqGspnzck=xtiX0rPABv8oX4=LCRbH00T8-B6qw@mail.gmail.com>
 <CAOhMmr5ucF3pa4jp9RLEzJNs29oVT0qAXmywNnd+Xe2seoRJfg@mail.gmail.com> <54060bf8c570a52eaa74a034b6096c99@imap.linux.ibm.com>
In-Reply-To: <54060bf8c570a52eaa74a034b6096c99@imap.linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 7 May 2021 02:24:28 -0500
Message-ID: <CAOhMmr5vwZv6Dv2pegx8Uvq_iTvhRLoHbigdiADBaE7L2Gtf2A@mail.gmail.com>
Subject: Re: [PATCH net v3] ibmvnic: Continue with reset if set link down failed
To:     Dany Madden <drt@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 3:24 PM Dany Madden <drt@linux.ibm.com> wrote:
>
> On 2021-05-04 12:31, Lijun Pan wrote:
> > On Tue, May 4, 2021 at 2:27 PM Lijun Pan <lijunp213@gmail.com> wrote:
> >>
> >> On Tue, May 4, 2021 at 2:14 PM Dany Madden <drt@linux.ibm.com> wrote:
> >> >
> >> > When ibmvnic gets a FATAL error message from the vnicserver, it marks
> >> > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> >> > FATAL reset fails and a transmission timeout reset follows, the CRQ is
> >> > still inactive, ibmvnic's attempt to set link down will also fail. If
> >> > ibmvnic abandons the reset because of this failed set link down and this
> >> > is the last reset in the workqueue, then this adapter will be left in an
> >> > inoperable state.
> >> >
> >> > Instead, make the driver ignore this link down failure and continue to
> >> > free and re-register CRQ so that the adapter has an opportunity to
> >> > recover.
> >> >
> >> > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> >> > Signed-off-by: Dany Madden <drt@linux.ibm.com>
> >> > Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> >> > Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> >> > ---
> >> > Changes in V2:
> >> > - Update description to clarify background for the patch
> >> > - Include Reviewed-by tags
> >> > Changes in V3:
> >> > - Add comment above the code change
> >> > ---
> >> >  drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
> >> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> >> > index 5788bb956d73..9e005a08d43b 100644
> >> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> >> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> >> > @@ -2017,8 +2017,15 @@ static int do_reset(struct ibmvnic_adapter *adapter,
> >> >                         rtnl_unlock();
> >> >                         rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
> >> >                         rtnl_lock();
> >> > -                       if (rc)
> >> > -                               goto out;
> >> > +
> >> > +                       /* Attempted to set the link down. It could fail if the
> >> > +                        * vnicserver has already torn down the CRQ. We will
> >> > +                        * note it and continue with reset to reinit the CRQ.
> >> > +                        */
> >> > +                       if (rc) {
> >> > +                               netdev_dbg(netdev,
> >> > +                                          "Setting link down failed rc=%d. Continue anyway\n", rc);
> >> > +                       }
> >>
> >> There are other places which check and rely on the return value of
> >> this function. Your change makes that inconsistent. Can you stop
> >
> > To be more specific, __ibmvnic_close, __ibmvnic_open both call this
> > set_link_state.
> Inconsistent would have been not checking for the rc at all. Here we
> checked and noted it that there are times that it's ok to continue.
>
> >
> >> posting new versions and soliciting the maintainer to accept it before
> >> there is material change? There are many ways to make reset
> >> successful. I think this is the worst approach of all.
>
> Can you show me a patch that is better than this one, that has gone thru
> a 30+ hours of testing?

The patch review convention is: community review the patch, and the
patch author modifies the patch and resend. We are talking about the
patch itself, you came up with something about testing. You do not
take the reviewer's opinions but ask the reviewer to write a patch,
which is a little bit odd.
