Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FD12951D3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503767AbgJURxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503763AbgJURxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 13:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603302810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0aM6MG+N6GRh+zh31VWFPduo2rgWm3emASszSAw8inM=;
        b=OWDTTe0SiGQKjc0mlEJCoVfy8KB0qeKRwNh34kmfl75kbHUp2t1k4Pqpi9YDFtoYuu/++3
        fa+5IzxIDvNRpnolkxrwuA4Gs7N+uZ2IoeO9rD33K3nvcBofBo/4A51eQeG5wGWloi3uCM
        oMV/LW+Vvw7kojkSlkSwJUO8gTQd7J4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-0BAAGVqzMda2Ab5lMPFbVA-1; Wed, 21 Oct 2020 13:53:23 -0400
X-MC-Unique: 0BAAGVqzMda2Ab5lMPFbVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57DDD804B66;
        Wed, 21 Oct 2020 17:53:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E934B5D9EF;
        Wed, 21 Oct 2020 17:53:06 +0000 (UTC)
Date:   Wed, 21 Oct 2020 13:53:03 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
Message-ID: <20201021175303.GH2882171@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <20201002195231.GH2882171@madcap2.tricolour.ca>
 <20201021163926.GA3929765@madcap2.tricolour.ca>
 <2174083.ElGaqSPkdT@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2174083.ElGaqSPkdT@x2>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-21 12:49, Steve Grubb wrote:
> On Wednesday, October 21, 2020 12:39:26 PM EDT Richard Guy Briggs wrote:
> > > I think I have a way to generate a signal to multiple targets in one
> > > syscall...  The added challenge is to also give those targets different
> > > audit container identifiers.
> > 
> > Here is an exmple I was able to generate after updating the testsuite
> > script to include a signalling example of a nested audit container
> > identifier:
> > 
> > ----
> > type=PROCTITLE msg=audit(2020-10-21 10:31:16.655:6731) :
> > proctitle=/usr/bin/perl -w containerid/test type=CONTAINER_ID
> > msg=audit(2020-10-21 10:31:16.655:6731) :
> > contid=7129731255799087104^3333941723245477888 type=OBJ_PID
> > msg=audit(2020-10-21 10:31:16.655:6731) : opid=115583 oauid=root ouid=root
> > oses=1 obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > ocomm=perl type=CONTAINER_ID msg=audit(2020-10-21 10:31:16.655:6731) :
> > contid=3333941723245477888 type=OBJ_PID msg=audit(2020-10-21
> > 10:31:16.655:6731) : opid=115580 oauid=root ouid=root oses=1
> > obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 ocomm=perl
> > type=CONTAINER_ID msg=audit(2020-10-21 10:31:16.655:6731) :
> > contid=8098399240850112512^3333941723245477888 type=OBJ_PID
> > msg=audit(2020-10-21 10:31:16.655:6731) : opid=115582 oauid=root ouid=root
> > oses=1 obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > ocomm=perl type=SYSCALL msg=audit(2020-10-21 10:31:16.655:6731) :
> > arch=x86_64 syscall=kill success=yes exit=0 a0=0xfffe3c84 a1=SIGTERM
> > a2=0x4d524554 a3=0x0 items=0 ppid=115564 pid=115567 auid=root uid=root
> > gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root
> > tty=ttyS0 ses=1 comm=perl exe=/usr/bin/perl
> > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > key=testsuite-1603290671-AcLtUulY ----
> > 
> > There are three CONTAINER_ID records which need some way of associating
> > with OBJ_PID records.  An additional CONTAINER_ID record would be present
> > if the killing process itself had an audit container identifier.  I think
> > the most obvious way to connect them is with a pid= field in the
> > CONTAINER_ID record.
> 
> pid is the process sending the signal, opid is the process receiving the 
> signal. I think you mean opid?

If the process sending the signal (it has a pid= field) has an audit
container identifier, it will generate a CONTAINER_ID record.  Each
process being signalled (each has an opid= field) that has an audit
container identifier will also generate a CONTAINER_ID record.  The
former will be much more common.  Which do we use in the CONTAINER_ID
record?  Having swinging fields, pid vs opid does not seem like a
reasonable solution.  Do we go back to "ref=pid=..." vs "ref=opid=..."?

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

