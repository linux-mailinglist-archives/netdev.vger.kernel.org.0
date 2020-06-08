Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B784B1F1EA9
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgFHSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:04:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40142 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbgFHSEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:04:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591639439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uw5NjJ0WopWX8Tckd6/nHTcQhEVOsQbonk1220jJm6A=;
        b=D9fTI1IW3bvq2obozeWrpvNTqCyeK7j7sa1GVbd3Vl4DH0ZkXpG1d9SEM18UrJotlvSisA
        4W6Yjblw3JzQOaEVZSPMx4F3JI7tl6NLgbeKu9HGydcpwW7ucnyoEeAg2xw3djxfsrBdhp
        CFEE0kZnlETzWYzAGQX38wCmqzSuf+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-mA0IjPaLOdWDFywZFnhrIg-1; Mon, 08 Jun 2020 14:03:52 -0400
X-MC-Unique: mA0IjPaLOdWDFywZFnhrIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FAD91005510;
        Mon,  8 Jun 2020 18:03:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9756760BF3;
        Mon,  8 Jun 2020 18:03:33 +0000 (UTC)
Date:   Mon, 8 Jun 2020 14:03:30 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200608180330.z23hohfa2nclhxf5@madcap2.tricolour.ca>
References: <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
 <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
 <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
 <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
 <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
 <871ronf9x2.fsf@x220.int.ebiederm.org>
 <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
 <871rol7nw3.fsf@x220.int.ebiederm.org>
 <CAHC9VhQvhja=vUEbT3uJgQqpj-480HZzWV7b5oc2GWtzFN1qJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQvhja=vUEbT3uJgQqpj-480HZzWV7b5oc2GWtzFN1qJw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 13:24, Paul Moore wrote:
> On Fri, Apr 17, 2020 at 6:26 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Paul Moore <paul@paul-moore.com> writes:
> > > On Thu, Apr 16, 2020 at 4:36 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >> Paul Moore <paul@paul-moore.com> writes:
> > >> > On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> On 2020-03-30 13:34, Paul Moore wrote:
> > >> >> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> > > On 2020-03-30 10:26, Paul Moore wrote:
> > >> >> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> > > > > On 2020-03-28 23:11, Paul Moore wrote:
> > >> >> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> > >> >> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> > >> >
> > >> > ...
> > >> >
> > >> >> > > Well, every time a record gets generated, *any* record gets generated,
> > >> >> > > we'll need to check for which audit daemons this record is in scope and
> > >> >> > > generate a different one for each depending on the content and whether
> > >> >> > > or not the content is influenced by the scope.
> > >> >> >
> > >> >> > That's the problem right there - we don't want to have to generate a
> > >> >> > unique record for *each* auditd on *every* record.  That is a recipe
> > >> >> > for disaster.
> > >> >> >
> > >> >> > Solving this for all of the known audit records is not something we
> > >> >> > need to worry about in depth at the moment (although giving it some
> > >> >> > casual thought is not a bad thing), but solving this for the audit
> > >> >> > container ID information *is* something we need to worry about right
> > >> >> > now.
> > >> >>
> > >> >> If you think that a different nested contid value string per daemon is
> > >> >> not acceptable, then we are back to issuing a record that has only *one*
> > >> >> contid listed without any nesting information.  This brings us back to
> > >> >> the original problem of keeping *all* audit log history since the boot
> > >> >> of the machine to be able to track the nesting of any particular contid.
> > >> >
> > >> > I'm not ruling anything out, except for the "let's just completely
> > >> > regenerate every record for each auditd instance".
> > >>
> > >> Paul I am a bit confused about what you are referring to when you say
> > >> regenerate every record.
> > >>
> > >> Are you saying that you don't want to repeat the sequence:
> > >>         audit_log_start(...);
> > >>         audit_log_format(...);
> > >>         audit_log_end(...);
> > >> for every nested audit daemon?
> > >
> > > If it can be avoided yes.  Audit performance is already not-awesome,
> > > this would make it even worse.
> >
> > As far as I can see not repeating sequences like that is fundamental
> > for making this work at all.  Just because only the audit subsystem
> > should know about one or multiple audit daemons.  Nothing else should
> > care.
> 
> Yes, exactly, this has been mentioned in the past.  Both the
> performance hit and the code complication in the caller are things we
> must avoid.
> 
> > >> Or are you saying that you would like to literraly want to send the same
> > >> skb to each of the nested audit daemons?
> > >
> > > Ideally we would reuse the generated audit messages as much as
> > > possible.  Less work is better.  That's really my main concern here,
> > > let's make sure we aren't going to totally tank performance when we
> > > have a bunch of nested audit daemons.
> >
> > So I think there are two parts of this answer.  Assuming we are talking
> > about nesting audit daemons in containers we will have different
> > rulesets and I expect most of the events for a nested audit daemon won't
> > be of interest to the outer audit daemon.
> 
> Yes, this is another thing that Richard and I have discussed in the
> past.  We will basically need to create per-daemon queues, rules,
> tracking state, etc.; that is easy enough.  What will be slightly more
> tricky is the part where we apply the filters to the individual
> records and decide if that record is valid/desired for a given daemon.
> I think it can be done without too much pain, and any changes to the
> callers, but it will require a bit of work to make sure it is done
> well and that records are needlessly duplicated in the kernel.
> 
> > Beyond that it should be very straight forward to keep a pointer and
> > leave the buffer as a scatter gather list until audit_log_end
> > and translate pids, and rewrite ACIDs attributes in audit_log_end
> > when we build the final packet.  Either through collaboration with
> > audit_log_format or a special audit_log command that carefully sets
> > up the handful of things that need that information.
> 
> In order to maximize record re-use I think we will want to hold off on
> assembling the final packet until it is sent to the daemons in the
> kauditd thread.  We'll also likely need to create special
> audit_log_XXX functions to capture fields which we know will need
> translation, e.g. ACID information.  (the reason for the new
> audit_log_XXX functions would be to mark the new sg element and ensure
> the buffer is handled correctly)
> 
> Regardless of the details, I think the scatter gather approach is the
> key here - that seems like the best design idea I've seen thus far.
> It enables us to replace portions of the record as needed ... and
> possibly use the existing skb cow stuff ... it has been a while, but
> does the skb cow functions handle scatter gather skbs or do they need
> to be linear?

How does the selection of this data management technique affect our
choice of field format?  Does this lock the field value to a fixed
length?  Does the use of scatter/gather techniques or structures allow
the use of different lengths of data for each destination (auditd)?  I
could see different target audit daemons triggering or switching to a
different chunk of data and length.  This does raise a concern related
to the previous sig_info2 discussion that the struct contobj that exists
at the time of audit_log_exit called could have been reaped by the time
the buffer is pulled from the queue for transmission to auditd, but we
could hold a reference to it as is done for sig_info2.

Looking through the kernel scatter/gather possibilities, I see struct
iovec which is used by the readv/writev/preadv/pwritev syscalls, but I'm
understanding that this is a kernel implementation that will be not
visible to user space.  So would the struct scatterlist be the right
choice?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

