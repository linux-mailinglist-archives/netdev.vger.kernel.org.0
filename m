Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E011744D957
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhKKPrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhKKPrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:47:15 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74504C061767
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:44:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so25913787edv.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPQ7vOyVbbdDApHDNZY5gQprN5zr7x8ve73iIkJlJYY=;
        b=0QU+TYq0W1sc8EeqjE/tNL4yaJ2SFpNf3JbfSJ6XIrpKAwitFcd/yhNROOgoDQwjkj
         1NMRGqLcfCZMpvPlHqan1c+mGhTrU6zkuQyIp+ySJiC9/Q4lWo3vjntt84USDZ+k21am
         Yln5xnwGUa2TRf7uWX/0J2QQw+MgU7rUQsfB1IVcQYKFqckaUvu0uZfFQL1/ExxFooFF
         s/SsXAhYMI4P2W4V6ll0c5VDrqiwvHDDsiF2YCUQo593d1kCA06mEik43mYDWUL1uDms
         bFOX+T1rjMLZtSH7cboYBKh/gb810BB/Fo1Se41dkIg5AHQm25qVdO6u70csjbkXtDSr
         O4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPQ7vOyVbbdDApHDNZY5gQprN5zr7x8ve73iIkJlJYY=;
        b=go1pWgmzOtogIJY8NJjBUjR0zAM3ihIz4JvdGH/yoER6o9lB7ir2S1G7JXo0TR1nmJ
         M3ul4QOjkYMW3VM+kFCeW7msBOjo0dtNWAUyh1Sc/yN57pr8mhQWK/XEZMb0Z0t4l7IK
         oyr4/mYdO7+r2XSdrjZ5z+O17eUea79GAT6fd9KwEIWvcBA71LmyOYDst6t23qz98MEu
         4eIvPX/H2L44s9TISrYhvTiojUHv5DRMnq0XFSUJZtrLIq3pswibFzyHbe1U4ylIeNcn
         fCy278a3U/E2Yd4GGae+BU/0/Xb8sMFPkNxWPEkP7T0R/Mtigts5kqX0SDK9aQUXxLOj
         V7cg==
X-Gm-Message-State: AOAM532PHDSttC6+ZgdnexQ+scSGwrVlP6W47ZrrZ7dYHMDl7r1hdHB+
        +AjaR2XhSE6tSZnGrSz+4IQsDs/7ESIn+loRy0Km
X-Google-Smtp-Source: ABdhPJw5AV/+6LHJGpXCxldUJSlAQrshxCBciUosbU8oRccWa5FSy8lbwzIVunwib2JpOIbLzgCLXChfqP/otc9BRVQ=
X-Received: by 2002:a17:907:9484:: with SMTP id dm4mr10250499ejc.307.1636645463777;
 Thu, 11 Nov 2021 07:44:23 -0800 (PST)
MIME-Version: 1.0
References: <20211104195949.135374-1-omosnace@redhat.com> <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHC9VhTVNOUHJp+NbqV5AgtwR6+3V6am0SKGKF0CegsPqjQ8pw@mail.gmail.com> <CAFqZXNuct_T-SkvoRg2n7+ye0--OkMJ_gS31V-t3Cm+Yy7FhxQ@mail.gmail.com>
In-Reply-To: <CAFqZXNuct_T-SkvoRg2n7+ye0--OkMJ_gS31V-t3Cm+Yy7FhxQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 11 Nov 2021 10:44:12 -0500
Message-ID: <CAHC9VhTmkQy1_1xFn9StgrwT2m8nyCwvHCMA+1sRdTW6xWR96A@mail.gmail.com>
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 7:59 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Tue, Nov 9, 2021 at 4:00 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Tue, Nov 9, 2021 at 9:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu,  4 Nov 2021 20:59:49 +0100 Ondrej Mosnacek wrote:
> > > > As agreed with Xin Long, I'm posting this fix up instead of him. I am
> > > > now fairly convinced that this is the right way to deal with the
> > > > immediate problem of client peeloff socket labeling. I'll work on
> > > > addressing the side problem regarding selinux_socket_post_create()
> > > > being called on the peeloff sockets separately.
> > >
> > > IIUC Paul would like to see this part to come up in the same series.
> >
> > Just to reaffirm the IIUC part - yes, your understanding is correct.
>
> The more I'm reading these threads, the more I'm getting confused...
> Do you insist on resending the whole original series with
> modifications? Or actual revert patches + the new patches? Or is it
> enough to revert/resend only the patches that need changes? Do you
> also insist on the selinux_socket_post_create() thing to be fixed in
> the same series? Note that the original patches are still in the
> net.git tree and it doesn't seem like Dave will want to rebase them
> away, so it seems explicit reverting is the only way to "respin" the
> series...

DaveM is stubbornly rejecting the revert requests so for now I would
continue to base any patches on top of the netdev tree.  If that
changes we can reconcile any changes as necessary, that should not be
a major issue.

As far as what I would like to see from the patches, ignoring the
commit description vs cover letter discussion, I would like to see
patches that fix all of the known LSM/SELinux/SCTP problems as have
been discussed over the past couple of weeks.  Even beyond this
particular issue I generally disapprove of partial fixes to known
problems; I would rather see us sort out all of the issues in a single
patchset so that we can review everything in a sane manner.  In this
particular case things are a bit more complicated because of the
current state of the patches in the netdev tree, but as mentioned
above just treat the netdev tree as broken and base your patches on
that with all of the necessary "Fixes:" metadata and the like.

> Regardless of the answers, this thing has rabbithole'd too much and
> I'm already past my free cycles to dedicate to this, so I think it
> will take me (and Xin) some time to prepare the corrected and
> re-documented patches. Moreover, I think I realized how to to deal
> with the peer_secid-vs.-multiple-assocs-on-one-socket problem that Xin
> mentions in patch 4/4, fixing which can't really be split out into a
> separate patch and will need some test coverage, so I don't think I
> can rush this up at this point...

It's not clear to me from your comments above if this is something you
are currently working on, planning to work on soon, or giving up on in
the near term.  Are we able to rely on you for a patchset to fix this
or are you unable to see this through at this time?

> In the short term, I'd suggest
> either reverting patches 3/4 and 4/4 (which are the only ones that
> would need re-doing; the first two are good changes on their own) or
> leaving everything as is (it's not functionally worse than what we had
> before...) and waiting for the proper fixes.

DaveM has thus far failed to honor the revert request so it doesn't
appear that reverting 3/4 and 4/4 is an option.  In the near term that
leaves us with the other two options: leave it as-is or fix it
properly.  I am firmly in the fix it properly camp, regardless of the
revert state, so that is the direction I would like to see things go.

-- 
paul moore
www.paul-moore.com
