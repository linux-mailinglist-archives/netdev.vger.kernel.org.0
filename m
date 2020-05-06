Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ABC1C6DFA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgEFKGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:06:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:53192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgEFKGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 06:06:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1564AF85;
        Wed,  6 May 2020 10:06:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6FC051E12B1; Wed,  6 May 2020 12:06:49 +0200 (CEST)
Date:   Wed, 6 May 2020 12:06:49 +0200
From:   Jan Kara <jack@suse.cz>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Tony Luck <tony.luck@intel.com>, fenghua.yu@intel.com,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, benchan@chromium.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        santosh.shilimkar@oracle.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        inux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        tee-dev@lists.linaro.org, Linux-MM <linux-mm@kvack.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [RFC] mm/gup.c: Updated return value of
 {get|pin}_user_pages_fast()
Message-ID: <20200506100649.GI17863@quack2.suse.cz>
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
 <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 06-05-20 02:06:56, Souptick Joarder wrote:
> On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
> >
> > On 2020-05-05 12:14, Souptick Joarder wrote:
> > > Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> > > and no of pinned pages. The only case where these two functions will
> > > return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> > > But if at all any, then a -ERRNO will be returned instead of 0, which
> > > means {get|pin}_user_pages_fast() will have 2 return values -errno &
> > > no of pinned pages.
> > >
> > > Update all the callers which deals with return value 0 accordingly.
> >
> > Hmmm, seems a little shaky. In order to do this safely, I'd recommend
> > first changing gup_fast/pup_fast so so that they return -EINVAL if
> > the caller specified nr_pages==0, and of course auditing all callers,
> > to ensure that this won't cause problems.
> 
> While auditing it was figured out, there are 5 callers which cares for
> return value
> 0 of gup_fast/pup_fast. What problem it might cause if we change
> gup_fast/pup_fast
> to return -EINVAL and update all the callers in a single commit ?

Well, first I'd ask a different question: Why do you want to change the
current behavior? It's not like the current behavior is confusing.  Callers
that pass >0 pages can happily rely on the simple behavior of < 0 return on
error or > 0 return if we mapped some pages. Callers that can possibly ask
to map 0 pages can get 0 pages back - kind of expected - and I don't see
any benefit in trying to rewrite these callers to handle -EINVAL instead...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
