Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760361757FD
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 11:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgCBKJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 05:09:04 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45380 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgCBKJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 05:09:03 -0500
Received: by mail-io1-f65.google.com with SMTP id w9so10815463iob.12;
        Mon, 02 Mar 2020 02:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3j1I17+GMU5nli/eqh+4aHS314u76TvdcOFFOJfXKk=;
        b=Zz9KQgn5w37Q58MHosY4nzSk/GbOnDoClikcNpoVkOlCovZmZxzyw4g6xXoqFS170A
         7z3BQMzBR/24hVtj349LRY3f0H//LAJYegYMnpbPdeL8K8Q5lDhwdeU8DnC6QayHRsNF
         fDx4xA9yORMrUEKWPfT07oTjmZBqhw/ZQNntcZOODgVL5KL6xQ6O+I6xVRSEcq248Loj
         ktzKr2hMbaqm00hSYoK5nCeUBlKM9MhkwgQgE9HvKYkKfDZ3FkLh4Mu10JjMZn8NuR5k
         ZLgxKGwk87QtnJAolVDPo4kIFHolnmrmRj6vl41JxN24JrsTL3s9C2fpjnP1elsQrbkb
         I6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3j1I17+GMU5nli/eqh+4aHS314u76TvdcOFFOJfXKk=;
        b=LHO+NyFQXEaqr42PynjouJgr8S50GONKKMn15bQYtab9Lybr33oK8LPT1aOTKRQCrj
         TEJnVKYxNGH3P2/c75zMmwG0/eZ7lx1YAJM9zQgskVd6xa8wCe4jLnDlnZ/Q/Bs+e4Zv
         y5jOnonUXuG54QKITT3TddDJJ9lYeQLlxuEKjiPYkjO7k485KZMTH+hF4rIpBNK0JvDr
         3rRm/GjM7H9vVmFJ6HTMIfuLOKBAujFsHCfExluHkJBFUJbz2ITTy6JMFjcw15XTKPml
         x1oUznTeGj1yqHA3kDoqPo4IzxbkMqTmKlnOIqbuM6v+iI861dSNoQ1Cl8AHjgH9Dp8q
         xN9Q==
X-Gm-Message-State: APjAAAX+etE7OmZ/excKWZbwK4gl/sFPhphQimtBtv8jkJGO99n4e6/j
        4HduWEngZ1ew50pGeSnEO/PK1xuz+VM2KeVqViGb0P1aBuI=
X-Google-Smtp-Source: APXvYqxLqFYFwdl0+uj9r6fVvf6OhWq/lUDow87s3COEogE3QO36C2e42sZIX+vYtyNcueS7MJjf+2ulrAuoQNr5KYc=
X-Received: by 2002:a02:c84d:: with SMTP id r13mr13284971jao.76.1583143741759;
 Mon, 02 Mar 2020 02:09:01 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com> <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
 <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com>
 <CAOi1vP_opdc=OP70T2eiamMWa-o71nU8t_LYyTCytqT5BT8gdQ@mail.gmail.com> <CAB9OAC08TGgXGFJsZCNpMzqnorn=jw1S_i8Ux2euaG=4-=JGwg@mail.gmail.com>
In-Reply-To: <CAB9OAC08TGgXGFJsZCNpMzqnorn=jw1S_i8Ux2euaG=4-=JGwg@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 2 Mar 2020 11:08:58 +0100
Message-ID: <CAOi1vP-BKfaL-d2GMWDHf7tD=LpDLEug0-NY9dgT=qEi00gpLQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 3:30 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> On Fri, Feb 28, 2020 at 10:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Fri, Feb 28, 2020 at 12:41 PM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > >
> > > On Fri, Feb 28, 2020 at 6:23 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > >
> > > > On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > > > >
> > > > > OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
> > > > >
> > > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > > ---
> > > > >  fs/ceph/file.c                  |  6 ++++--
> > > > >  include/linux/ceph/osd_client.h |  2 ++
> > > > >  include/linux/ceph/osdmap.h     |  3 ++-
> > > > >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> > > > >  4 files changed, 21 insertions(+), 13 deletions(-)
> > > > >
> > > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > > index 7e0190b1f821..60ea1eed1b84 100644
> > > > > --- a/fs/ceph/file.c
> > > > > +++ b/fs/ceph/file.c
> > > > > @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > > >         }
> > > > >
> > > > >         /* FIXME: not complete since it doesn't account for being at quota */
> > > > > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > > > > +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > > +                               CEPH_POOL_FLAG_FULL)) {
> > > > >                 err = -ENOSPC;
> > > > >                 goto out;
> > > > >         }
> > > > > @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > > >         }
> > > > >
> > > > >         if (written >= 0) {
> > > > > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > > > +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > > +                                       CEPH_POOL_FLAG_NEARFULL))
> > > >
> > > > Hi Yanhu,
> > > >
> > > > Have you considered pre-mimic clusters here?  They are still supported
> > > > (and will continue to be supported for the foreseeable future).
> > > >
> > > > Thanks,
> > > >
> > > >                 Ilya
> > >
> > > I have tested it work on Luminous, I think it work too since
> > > ceph-v0.80(https://github.com/ceph/ceph/blob/b78644e7dee100e48dfeca32c9270a6b210d3003/src/osd/osd_types.h#L815)
> > > alread have pool FLAG_FULL.
> >
> > But not FLAG_NEARFULL, which appeared in mimic.
> FLAG_NEARFULL appeared in Luminous.

Well, it appeared in mimic in v13.0.1 and was backported to luminous
in v12.2.2.  So technically, some luminous releases don't have it.

>
> >
> > >
> > > CephFS doesn't write synchronously even if CEPH_OSDMAP_NEARFULL is
> > > used, then should fixed by CEPH_POOL_FLAG_NEARFULL.
> >
> > I'm not sure I follow.
> >
> > -    if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > +    if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > +                            CEPH_POOL_FLAG_NEARFULL))
> >
> > AFAICT this change would effectively disable this branch for pre-mimic
> > clusters.  Are you saying this branch is already broken?
> >
> > Thanks,
> >
> >                 Ilya
> CEPH_OSDMAP_NEARFULL is not set in Jewel, so it has no effect. And in
> Luminous version, this flag is cleared as a legacy and has no effect
> too.

Are you sure?  What about this code in OSDMonitor::tick() that showed
up in kraken in v11.0.1 and was backported to jewel in v10.2.4?

  if (!mon->pgmon()->pg_map.nearfull_osds.empty()) {
    ...
    add_flag(CEPH_OSDMAP_NEARFULL);
  } else if (osdmap.test_flag(CEPH_OSDMAP_NEARFULL)){
    ...
    remove_flag(CEPH_OSDMAP_NEARFULL);
  }
  if (pending_inc.new_flags != -1 &&
     (pending_inc.new_flags ^ osdmap.flags) & (CEPH_OSDMAP_FULL |
                                               CEPH_OSDMAP_NEARFULL)) {
    ...
    do_propose = true;

It's there in v10.2.11 (the final jewel release).  It's also there
in hammer since v0.94.10...

Thanks,

                Ilya
