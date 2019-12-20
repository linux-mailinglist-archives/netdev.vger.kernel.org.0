Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A689B127BCE
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLTNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:37:01 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40285 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLTNhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:37:01 -0500
Received: by mail-oi1-f195.google.com with SMTP id c77so4009769oib.7;
        Fri, 20 Dec 2019 05:37:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1fCOA/Sv1KGJSA6mRhrFG67s6gpWFpFbY2201u/RCQ=;
        b=PWwBA0+ipxLwsdIDQLVU9Opbl240+SDJgommm+PZ69gXiO11VtmYzH3wYtNDRrtA0L
         xVlhl7BJ4k12iU+3FjdWkQ9/QPcDljn2tEBAEcV5ExQ4y+X13r5iw1tGwzaV0BYLnfDD
         jOq9aavLXueP6irHasTrkwBV7gJV6F1wwirPQnmX/6VWFvzxk5j8aA1g9q2pC+qcXIjL
         JKNI6VFcz4g/byZrXbx7DLzc3sznJO8QWpG4hLhCmbX+q2MfmOYMvtDpFGzPq6QgP51e
         mWc6Z1cbQTszouo45g5c+2iPnLjlK8hPnB406/nAfhlopXmhZs755PAE3viOR5fbjoIT
         R5gg==
X-Gm-Message-State: APjAAAXerdouZvwrWX6Yd1ULmFBnED/lLA4kaWMF4CbeigKxE898V+yG
        5pnvC0z9ZURSuv66lF83sBq8iA18VHmrRmi/sl8=
X-Google-Smtp-Source: APXvYqx99YdXrtAVo+2lBsGy+1MasKuJ6va9hTNxUc2EXy1QdfUgsmv0s+kIJ0R5ysWOYRqLdQ9XYSQAnclfK9n+XcY=
X-Received: by 2002:aca:1a06:: with SMTP id a6mr3453327oia.148.1576849020359;
 Fri, 20 Dec 2019 05:37:00 -0800 (PST)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
 <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com>
 <CAM_iQpWOhXR=x10i0S88qXTfG2nv9EypONTp6_vpBzs=iOySRQ@mail.gmail.com>
 <CAMuHMdXL8kycJm5EG6Ubx4aYGVGJH9JuJzP-vSM55wZ6RtyT+w@mail.gmail.com> <CAM_iQpXJiiiFdEZ1XYf0v0CNEwT=fSmpxWPVJ_L2_tPSd8u+-w@mail.gmail.com>
In-Reply-To: <CAM_iQpXJiiiFdEZ1XYf0v0CNEwT=fSmpxWPVJ_L2_tPSd8u+-w@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 Dec 2019 14:36:49 +0100
Message-ID: <CAMuHMdVYqfEF4NxwR64jDno9KdzX3pgVRSphBzfsJjQ6ORTq_g@mail.gmail.com>
Subject: Re: refcount_warn_saturate WARNING (was: Re: cls_flower: Fix the
 behavior using port ranges with hw-offload)
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On Thu, Dec 19, 2019 at 10:52 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Dec 19, 2019 at 1:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Dec 19, 2019 at 9:50 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > On Thu, Dec 19, 2019 at 2:12 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > I still see the below warning on m68k/ARAnyM during boot with v5.5-rc2
> > > > and next-20191219.
> > > > Reverting commit 8ffb055beae58574 ("cls_flower: Fix the behavior using
> > > > port ranges with hw-offload") fixes that.
> > > >
> > > > As this is networking, perhaps this is seen on big-endian only?
> > > > Or !CONFIG_SMP?
> > > >
> > > > Do you have a clue?
> > > > I'm especially worried as this commit is already being backported to stable.
> > > > Thanks!
> > >
> > > I did a quick look at the offending commit, I can't even connect it to
> > > any dst refcnt.
> > >
> > > Do you have any more information? Like what happened before the
> > > warning? Does your system use cls_flower filters at all? If so, please
> > > share your tc configurations.
> >
> > No, I don't use clf_flower filters.  This is just a normal old Debian boot,
> > where the root file system is being remounted, followed by the warning.
>
> > To me, it also looks very strange.  But it's 100% reproducible for me.
> > Git bisect pointed to this commit, and reverting it fixes the issue.
>
> Hmm, does the attached patch have any luck to fix it?

Thanks, but unfortunately it doesn't help.

More investigation revealed that the above commit caused some shifts in the
kernel binary, moving dst_default_metrics to a 2-byte aligned address.
This is incompatible with the use of DST_METRICS_FLAGS and
__DST_METRICS_PTR().

Fix sent: "[PATCH] net: dst: Force 4-byte alignment of dst_metrics"
https://lore.kernel.org/linux-m68k/20191220133140.5684-1-geert@linux-m68k.org/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
