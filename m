Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27EB2DFF19
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgLUR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 12:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgLUR7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 12:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608573456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVTTSIZ+4qn+SwwDnLlevQMhsrEFZG01AfUJnVXzFpk=;
        b=TfCyOqA2SivMCkf/I8XjXMp04bmPvcqtphEmVkjjIgkMM5On4nKiiJfYRxXpqI/PMTiT98
        wA3SGD7rLTorwtISPgYTLzu/JCexWRbsFY7scx5b36VYW80YC5LcMORzxiapoDbuXCDNqU
        1djA5r9+2SQ4VT1J4vRs4GUncPHXqkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-Hmj-eDYzNaCOHIZWZAk8lw-1; Mon, 21 Dec 2020 12:57:32 -0500
X-MC-Unique: Hmj-eDYzNaCOHIZWZAk8lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B338030A5;
        Mon, 21 Dec 2020 17:57:29 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B53BD1E5;
        Mon, 21 Dec 2020 17:57:15 +0000 (UTC)
Date:   Mon, 21 Dec 2020 12:57:12 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux Containers List <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Linux FSdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 v10 01/11] audit: collect audit task parameters
Message-ID: <20201221175712.GI1762914@madcap2.tricolour.ca>
References: <cover.1608225886.git.rgb@redhat.com>
 <982b9adffbd32264a853fe7f4f06f0d0a882c11d.1608225886.git.rgb@redhat.com>
 <CAHC9VhSTuBJ3LXxMY=nD7qBzmKLDjXY0V3hsuN34_siq_xRrig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSTuBJ3LXxMY=nD7qBzmKLDjXY0V3hsuN34_siq_xRrig@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-21 12:14, Paul Moore wrote:
> On Mon, Dec 21, 2020 at 11:57 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > The audit-related parameters in struct task_struct should ideally be
> > collected together and accessed through a standard audit API and the audit
> > structures made opaque to other kernel subsystems.
> >
> > Collect the existing loginuid, sessionid and audit_context together in a
> > new opaque struct audit_task_info called "audit" in struct task_struct.
> >
> > Use kmem_cache to manage this pool of memory.
> > Un-inline audit_free() to be able to always recover that memory.
> >
> > Please see the upstream github issues
> > https://github.com/linux-audit/audit-kernel/issues/81
> > https://github.com/linux-audit/audit-kernel/issues/90
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> 
> Did Neil and Ondrej really ACK/Review the changes that you made here
> in v10 or are you just carrying over the ACK/Review?  I'm hopeful it
> is the former, because I'm going to be a little upset if it is the
> latter.

It is the latter, sorry.  So, this needs to be reposted without their
ACK/Review lines.

> > ---
> >  fs/io-wq.c            |   8 +--
> >  fs/io_uring.c         |  16 ++---
> >  include/linux/audit.h |  49 +++++---------
> >  include/linux/sched.h |   7 +-
> >  init/init_task.c      |   3 +-
> >  init/main.c           |   2 +
> >  kernel/audit.c        | 154 +++++++++++++++++++++++++++++++++++++++++-
> >  kernel/audit.h        |   7 ++
> >  kernel/auditsc.c      |  24 ++++---
> >  kernel/fork.c         |   1 -
> >  10 files changed, 205 insertions(+), 66 deletions(-)
> 
> -- 
> paul moore
> www.paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

