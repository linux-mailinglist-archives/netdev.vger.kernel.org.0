Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1123D357
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 23:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHEVBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 17:01:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725920AbgHEVBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 17:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596661278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwlhS9A6gXAAkqCmgiXaqnLD4HXkSIN9WLGrUCy1lAs=;
        b=M2M5h65OKDAnwsNW31i/es0xpGuBLEoRdU4jk2c2c4gGPywF1bE+gtWUrBMXA4NX2t7x1w
        Mu6/5K20XG1HDFgobHzHmnlP7nwoqVvMFjWCIsAh20nyLSgTM8jOC2Dms3WTds/DEsBQgr
        1DSX2ag0WI7Qkbms6Y19IP+zCnQuiGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-NwTBjdllMtOzSlQa0ra2Nw-1; Wed, 05 Aug 2020 17:01:14 -0400
X-MC-Unique: NwTBjdllMtOzSlQa0ra2Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51BC1100AA22;
        Wed,  5 Aug 2020 21:01:12 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id A597A5F9DB;
        Wed,  5 Aug 2020 21:01:07 +0000 (UTC)
Date:   Wed, 5 Aug 2020 23:01:01 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200805210101.GF319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-11-jolsa@kernel.org>
 <CAEf4BzY5b8GhoovkKZgT4YSUUW=GPZBU0Qjg4eqeHNjoPHCMTw@mail.gmail.com>
 <20200805175850.GD319954@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805175850.GD319954@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 07:58:54PM +0200, Jiri Olsa wrote:
> On Tue, Aug 04, 2020 at 11:35:53PM -0700, Andrii Nakryiko wrote:
> > On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding d_path helper function that returns full path for
> > > given 'struct path' object, which needs to be the kernel
> > > BTF 'path' object. The path is returned in buffer provided
> > > 'buf' of size 'sz' and is zero terminated.
> > >
> > >   bpf_d_path(&file->f_path, buf, size);
> > >
> > > The helper calls directly d_path function, so there's only
> > > limited set of function it can be called from. Adding just
> > > very modest set for the start.
> > >
> > > Updating also bpf.h tools uapi header and adding 'path' to
> > > bpf_helpers_doc.py script.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/uapi/linux/bpf.h       | 13 +++++++++
> > >  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
> > >  scripts/bpf_helpers_doc.py     |  2 ++
> > >  tools/include/uapi/linux/bpf.h | 13 +++++++++
> > >  4 files changed, 76 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index eb5e0c38eb2c..a356ea1357bf 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -3389,6 +3389,18 @@ union bpf_attr {
> > >   *             A non-negative value equal to or less than *size* on success,
> > >   *             or a negative error in case of failure.
> > >   *
> > > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > 
> > nit: probably would be good to do `const struct path *` here, even if
> > we don't do const-ification properly in all helpers.

hum, for this I need to update scripts/bpf_helpers_doc.py and it looks
like it's not ready for const struct yet:

  CLNG-LLC [test_maps] get_cgroup_id_kern.o
In file included from progs/test_lwt_ip_encap.c:7:
In file included from /home/jolsa/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:11:
/home/jolsa/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:32:1: warning: 'const' ignored on this declaration [-Wmissing-declarations]
const struct path;
^

would it be ok as a follow up change? I'll need to check
on bpf_helpers_doc.py script first

jirka

