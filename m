Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C12E1C866A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:44474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGKN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 06:13:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 696B8AF99;
        Thu,  7 May 2020 10:13:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 17D0D1E12B0; Thu,  7 May 2020 12:13:22 +0200 (CEST)
Date:   Thu, 7 May 2020 12:13:22 +0200
From:   Jan Kara <jack@suse.cz>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        Tony Luck <tony.luck@intel.com>, fenghua.yu@intel.com,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, benchan@chromium.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        santosh.shilimkar@oracle.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        inux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        tee-dev@lists.linaro.org, Linux-MM <linux-mm@kvack.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [RFC] mm/gup.c: Updated return value of
 {get|pin}_user_pages_fast()
Message-ID: <20200507101322.GB30922@quack2.suse.cz>
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
 <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
 <20200506100649.GI17863@quack2.suse.cz>
 <CAFqt6zYaNkJ4AfVzutXS=JsN4fE41ZAvnw03vHWpdyiRHY1m_w@mail.gmail.com>
 <20200506125930.GJ17863@quack2.suse.cz>
 <CAFqt6zZztn_AiaGAhV+_uwrnVdKY-xLsxOwYBt-zGmLaat+OhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6zZztn_AiaGAhV+_uwrnVdKY-xLsxOwYBt-zGmLaat+OhQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 06-05-20 21:38:40, Souptick Joarder wrote:
> On Wed, May 6, 2020 at 6:29 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 06-05-20 17:51:39, Souptick Joarder wrote:
> > > On Wed, May 6, 2020 at 3:36 PM Jan Kara <jack@suse.cz> wrote:
> > > >
> > > > On Wed 06-05-20 02:06:56, Souptick Joarder wrote:
> > > > > On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > > > > >
> > > > > > On 2020-05-05 12:14, Souptick Joarder wrote:
> > > > > > > Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> > > > > > > and no of pinned pages. The only case where these two functions will
> > > > > > > return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> > > > > > > But if at all any, then a -ERRNO will be returned instead of 0, which
> > > > > > > means {get|pin}_user_pages_fast() will have 2 return values -errno &
> > > > > > > no of pinned pages.
> > > > > > >
> > > > > > > Update all the callers which deals with return value 0 accordingly.
> > > > > >
> > > > > > Hmmm, seems a little shaky. In order to do this safely, I'd recommend
> > > > > > first changing gup_fast/pup_fast so so that they return -EINVAL if
> > > > > > the caller specified nr_pages==0, and of course auditing all callers,
> > > > > > to ensure that this won't cause problems.
> > > > >
> > > > > While auditing it was figured out, there are 5 callers which cares for
> > > > > return value
> > > > > 0 of gup_fast/pup_fast. What problem it might cause if we change
> > > > > gup_fast/pup_fast
> > > > > to return -EINVAL and update all the callers in a single commit ?
> > > >
> > > > Well, first I'd ask a different question: Why do you want to change the
> > > > current behavior? It's not like the current behavior is confusing.  Callers
> > > > that pass >0 pages can happily rely on the simple behavior of < 0 return on
> > > > error or > 0 return if we mapped some pages. Callers that can possibly ask
> > > > to map 0 pages can get 0 pages back - kind of expected - and I don't see
> > > > any benefit in trying to rewrite these callers to handle -EINVAL instead...
> > >
> > > Callers with a request to map 0 pages doesn't have a valid use case. But if any
> > > caller end up doing it mistakenly, -errno should be returned to caller
> > > rather than 0
> > > which will indicate more precisely that map 0 pages is not a valid
> > > request from caller.
> >
> > Well, I believe this depends on the point of view. Similarly as reading 0
> > bytes is successful, we could consider mapping 0 pages successful as well.
> > And there can be valid cases where number of pages to map is computed from
> > some input and when 0 pages should be mapped, it is not a problem and your
> > change would force such callers to special case this with explicitely
> > checking for 0 pages to map and not calling GUP in that case at all.
> >
> > I'm not saying what you propose is necessarily bad, I just say I don't find
> > it any better than the current behavior and so IMO it's not worth the
> > churn. Now if you can come up with some examples of current in-kernel users
> > who indeed do get the handling of the return value wrong, I could be
> > convinced otherwise.
> 
> There are 5 callers of {get|pin}_user_pages_fast().

Oh, there are *much* more callers that 5. It's more like 70. Just grep the
source... And then you have all other {get|pin}_user_pages() variants that
need to be kept consistent. So overall we have over 200 calls to some
variant of GUP.

> arch/ia64/kernel/err_inject.c#L145
> staging/gasket/gasket_page_table.c#L489
> 
> Checking return value 0 doesn't make sense for above 2.
> 
> drivers/platform/goldfish/goldfish_pipe.c#L277
> net/rds/rdma.c#L165
> drivers/tee/tee_shm.c#L262
> 
> These 3 callers have calculated the no of pages value before passing it to
> {get|pin}_user_pages_fast(). But if they end up passing nr_pages <= 0, a return
> value of either 0 or -EINVAL doesn't going to harm any existing
> behavior of callers.
> 
> IMO, it is safe to return -errno for nr_pages <= 0, for
> {get|pin}_user_pages_fast().

OK, so no real problem with any of these callers. I still don't see a
justification for the churn you suggest... Auditting all those code sites
is going to be pretty tedious.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
