Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F498188D23
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgCQS24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:28:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48837 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgCQS24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584469734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K+IwNfCaU/P1ux5HKJF3z1NkFX7txjGZvGBam0p510E=;
        b=eTqnZyuGttuLlwqatpUrLdFnAanCa7vMCj9/ecVvnTMu2nprrmxSFwK47NwSW6/NNVrLkF
        aulW674PGQjcPaEAgLhbPesWP+ucSVAg+SJPjgvSiZmDklJeRHakXtI1FXD/zHB3wEfUjo
        Ytnp4R5vMr92SHFMNQd7yyOLdIyeb5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-5pYTBthUM_qAjZ1-ibWyTw-1; Tue, 17 Mar 2020 14:28:51 -0400
X-MC-Unique: 5pYTBthUM_qAjZ1-ibWyTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 054BF1857BE9;
        Tue, 17 Mar 2020 18:28:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D19B36E3EE;
        Tue, 17 Mar 2020 18:28:33 +0000 (UTC)
Date:   Tue, 17 Mar 2020 14:28:29 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Message-ID: <20200317182828.t4ewyw2l5epy2s6n@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca>
 <CAHC9VhSVN3mNb5enhLR1hY+ekiAyiYWbehrwd_zN7kz13dF=1w@mail.gmail.com>
 <20200205235056.e5365xtgz7rbese2@madcap2.tricolour.ca>
 <CAHC9VhTM6MDHLcBfwJ_9DCroG0VA-meO770ihjn1sVy6=0JrHw@mail.gmail.com>
 <20200312205147.plxs4czjeuu4davj@madcap2.tricolour.ca>
 <CAHC9VhTqWdXMsbSbsWJzRRvVbSaaFBmnFFsVutM7XSx5NT_FJA@mail.gmail.com>
 <20200314224203.ncyx3rgwwe6zet4e@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314224203.ncyx3rgwwe6zet4e@madcap2.tricolour.ca>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-14 18:42, Richard Guy Briggs wrote:
> On 2020-03-13 12:47, Paul Moore wrote:
> > On Thu, Mar 12, 2020 at 4:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-02-13 16:49, Paul Moore wrote:
> > > > On Wed, Feb 5, 2020 at 6:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-02-05 18:05, Paul Moore wrote:
> > > > > > On Thu, Jan 30, 2020 at 2:28 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > On 2020-01-22 16:29, Paul Moore wrote:
> > > > > > > > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > Track the parent container of a container to be able to filter and
> > > > > > > > > report nesting.
> > > > > > > > >
> > > > > > > > > Now that we have a way to track and check the parent container of a
> > > > > > > > > container, modify the contid field format to be able to report that
> > > > > > > > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > > > > > > > original field format was "contid=<contid>" for task-associated records
> > > > > > > > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > > > > > > > records.  The new field format is
> > > > > > > > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> > > > > > > >
> > > > > > > > Let's make sure we always use a comma as a separator, even when
> > > > > > > > recording the parent information, for example:
> > > > > > > > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
> > > > > > >
> > > > > > > The intent here is to clearly indicate and separate nesting from
> > > > > > > parallel use of several containers by one netns.  If we do away with
> > > > > > > that distinction, then we lose that inheritance accountability and
> > > > > > > should really run the list through a "uniq" function to remove the
> > > > > > > produced redundancies.  This clear inheritance is something Steve was
> > > > > > > looking for since tracking down individual events/records to show that
> > > > > > > inheritance was not aways feasible due to rolled logs or search effort.
> > > > > >
> > > > > > Perhaps my example wasn't clear.  I'm not opposed to the little
> > > > > > carat/hat character indicating a container's parent, I just think it
> > > > > > would be good to also include a comma *in*addition* to the carat/hat.
> > > > >
> > > > > Ah, ok.  Well, I'd offer that it would be slightly shorter, slightly
> > > > > less cluttered and having already written the parser in userspace, I
> > > > > think the parser would be slightly simpler.
> > > > >
> > > > > I must admit, I was a bit puzzled by your snippet of code that was used
> > > > > as a prefix to the next item rather than as a postfix to the given item.
> > > > >
> > > > > Can you say why you prefer the comma in addition?
> > > >
> > > > Generally speaking, I believe that a single delimiter is both easier
> > > > for the eyes to parse, and easier/safer for machines to parse as well.
> > > > In this particular case I think of the comma as a delimiter and the
> > > > carat as a modifier, reusing the carat as a delimiter seems like a bad
> > > > idea to me.
> > >
> > > I'm not crazy about this idea, but I'll have a look at how much work it
> > > is to recode the userspace search tools.  It also adds extra characters
> > > and noise into the string format that seems counterproductive.
> > 
> > If anything the parser should be *easier* (although both parsers
> > should fall into the "trivial" category).  The comma is the one and
> > only delimiter, and if the ACID starts with a carat then it is a
> > parent of the preceding ACID.
> 
> Ok, after a day of staring at the code and getting nowhere due to
> multiple distractions, I was able to rework this code fairly easily and
> it turned out simpler which should not surprise you.  Both kernel and
> userspace code are now in the format you recommended.
> 
> > > > > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > > > > index ef8e07524c46..68be59d1a89b 100644
> > > > > > > > > --- a/kernel/audit.c
> > > > > > > > > +++ b/kernel/audit.c
> > > > > > > >
> > > > > > > > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> > > > > > > > >                 audit_netns_contid_add(new->net_ns, contid);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> > > > > > > >
> > > > > > > > If we need a forward declaration, might as well just move it up near
> > > > > > > > the top of the file with the rest of the declarations.
> > > > > > >
> > > > > > > Ok.
> > > > > > >
> > > > > > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > > > > > > > +{
> > > > > > > > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > > > > > > > +       int h;
> > > > > > > >
> > > > > > > > It seems safer to pass the audit container ID object and not the u64.
> > > > > > >
> > > > > > > It would also be faster, but in some places it isn't available such as
> > > > > > > for ptrace and signal targets.  This also links back to the drop record
> > > > > > > refcounts to hold onto the contobj until process exit, or signal
> > > > > > > delivery.
> > > > > > >
> > > > > > > What we could do is to supply two potential parameters, a contobj and/or
> > > > > > > a contid, and have it use the contobj if it is valid, otherwise, use the
> > > > > > > contid, as is done for names and paths supplied to audit_log_name().
> > > > > >
> > > > > > Let's not do multiple parameters, that begs for misuse, let's take the
> > > > > > wrapper function route:
> > > > > >
> > > > > >  func a(int id) {
> > > > > >    // important stuff
> > > > > >  }
> > > > > >
> > > > > >  func ao(struct obj) {
> > > > > >    a(obj.id);
> > > > > >  }
> > > > > >
> > > > > > ... and we can add a comment that you *really* should be using the
> > > > > > variant that passes an object.
> > > > >
> > > > > I was already doing that where it available, and dereferencing the id
> > > > > for the call.  But I see an advantage to having both parameters supplied
> > > > > to the function, since it saves us the trouble of dereferencing it,
> > > > > searching for the id in the hash list and re-locating the object if the
> > > > > object is already available.
> > > >
> > > > I strongly prefer we not do multiple parameters for the same "thing";
> > >
> > > So do I, ideally.  However...
> > >
> > > > I would much rather do the wrapper approach as described above.  I
> > > > would also like to see us use the audit container ID object as much as
> > > > possible, using a bare integer should be a last resort.
> > >
> > > It is not clear to me that you understood what I wrote above.  I can't
> > > use the object pointer where preferable because there are a few cases
> > > where only the ID is available.  If only the ID is available, I would
> > > have to make a best effort to look up the object pointer and am not
> > > guaranteed to find it (invalid, stale, signal info...).  If I am forced
> > > to use only one, it becomes the ID that is used, and I no longer have
> > > the benefit of already having the object pointer for certainty and
> > > saving work.  For all cases where I have the object pointer, which is
> > > most cases, and most frequently used cases, I will have to dereference
> > > the object pointer to an ID, then go through the work again to re-locate
> > > the object pointer.  This is less certain, and more work.  Reluctantly,
> > > the only practical solution I see here is to supply both, favouring the
> > > object pointer if it is valid, then falling back on the ID from the next
> > > parameter.
> > 
> > It has been a while since I last looked at the patchset, but my
> > concern over the prefered use of the ACID number vs the ACID object is
> > that the number offers no reuse protection where the object does.  I
> > really would like us to use the object everywhere it is possible.
> 
> Ok, so I take it from this that I go ahead with the dual format since
> the wrapper funciton to convert from object to ID strips away object
> information negating any benefit of favouring the object pointer.  I'll
> look at the remaining calls that use a contid (rather than contobj) and
> convert all that I can over to storing an object using the dual counters
> that track process exits versus signal2 and trace references.

After reworking all the signal code to use the contobj and open coding
unnested single contid appearances, I was able to stick with just
passing a contobj to audit_contiainer_id() and audit_log_contid(), so
the dual format conundrum went away.

It issues the death certificate on process exit, and will issue an error
indicating the contid is dead and can't be reused yet until it is reaped
by a sig2 call.

> > paul moore
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

