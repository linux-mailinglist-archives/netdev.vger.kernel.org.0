Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141BD30358
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfE3Uhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:37:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3Uhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 16:37:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6910FA8C6;
        Thu, 30 May 2019 20:37:17 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F87A7E329;
        Thu, 30 May 2019 20:37:04 +0000 (UTC)
Date:   Thu, 30 May 2019 16:37:02 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 08/10] audit: add containerid filtering
Message-ID: <20190530203702.fibsrazabbiifjvf@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <0785ee2644804f3ec6af1243cc0dcf89709c1fd4.1554732921.git.rgb@redhat.com>
 <CAHC9VhRV-0LSEcRvPO1uXtKdpEQsaLZnBV3T=zcMTZPN5ugz5w@mail.gmail.com>
 <20190530141951.iofimovrndap4npq@madcap2.tricolour.ca>
 <CAHC9VhQhkzCtVOXhPL7BzaqvF0y+8gBQwhOo1EQDS2OUyZbV5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQhkzCtVOXhPL7BzaqvF0y+8gBQwhOo1EQDS2OUyZbV5g@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 30 May 2019 20:37:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-30 10:34, Paul Moore wrote:
> On Thu, May 30, 2019 at 10:20 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > On 2019-05-29 18:16, Paul Moore wrote:
> > > On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >
> > > > Implement audit container identifier filtering using the AUDIT_CONTID
> > > > field name to send an 8-character string representing a u64 since the
> > > > value field is only u32.
> > > >
> > > > Sending it as two u32 was considered, but gathering and comparing two
> > > > fields was more complex.
> > > >
> > > > The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.
> > > >
> > > > Please see the github audit kernel issue for the contid filter feature:
> > > >   https://github.com/linux-audit/audit-kernel/issues/91
> > > > Please see the github audit userspace issue for filter additions:
> > > >   https://github.com/linux-audit/audit-userspace/issues/40
> > > > Please see the github audit testsuiite issue for the test case:
> > > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > > Please see the github audit wiki for the feature overview:
> > > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > > ---
> > > >  include/linux/audit.h      |  1 +
> > > >  include/uapi/linux/audit.h |  5 ++++-
> > > >  kernel/audit.h             |  1 +
> > > >  kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  kernel/auditsc.c           |  4 ++++
> > > >  5 files changed, 57 insertions(+), 1 deletion(-)
> > >
> > > ...
> > >
> > > > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > > > index 63f8b3f26fab..407b5bb3b4c6 100644
> > > > --- a/kernel/auditfilter.c
> > > > +++ b/kernel/auditfilter.c
> > > > @@ -1206,6 +1224,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
> > > >         }
> > > >  }
> > > >
> > > > +int audit_comparator64(u64 left, u32 op, u64 right)
> > > > +{
> > > > +       switch (op) {
> > > > +       case Audit_equal:
> > > > +               return (left == right);
> > > > +       case Audit_not_equal:
> > > > +               return (left != right);
> > > > +       case Audit_lt:
> > > > +               return (left < right);
> > > > +       case Audit_le:
> > > > +               return (left <= right);
> > > > +       case Audit_gt:
> > > > +               return (left > right);
> > > > +       case Audit_ge:
> > > > +               return (left >= right);
> > > > +       case Audit_bitmask:
> > > > +               return (left & right);
> > > > +       case Audit_bittest:
> > > > +               return ((left & right) == right);
> > > > +       default:
> > > > +               BUG();
> > >
> > > A little birdy mentioned the BUG() here as a potential issue and while
> > > I had ignored it in earlier patches because this is likely a
> > > cut-n-paste from another audit comparator function, I took a closer
> > > look this time.  It appears as though we will never have an invalid op
> > > value as audit_data_to_entry()/audit_to_op() ensure that the op value
> > > is a a known good value.  Removing the BUG() from all the audit
> > > comparators is a separate issue, but I think it would be good to
> > > remove it from this newly added comparator; keeping it so that we
> > > return "0" in the default case seems reasoanble.
> >
> > Fair enough.  That BUG(); can be removed.
> 
> Please send a fixup patch for this.

The fixup patch is trivial.  The rebase to v5.2-rc1 audit/next had merge
conflicts with four recent patchsets.  It may be simpler to submit a new
patchset and look at a diff of the two sets.  I'm testing the rebase
now.

> paul moore www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
