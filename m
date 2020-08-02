Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710832359C9
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHBS0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:26:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgHBS0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 14:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596392811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m4ZEC7OhluV+W96KXLUZXn0tjvD0qGEj9H9evHmPVNw=;
        b=P5Ih+SVkollo+LFpQyp3bF3G74vIa1h90JfIPqAlR4xZ2GFsjjrxt3WJFUZ04HA8tByX8z
        zq80CGaQP+5CajiRS7MKYeOhXKgssIzd3+tjosCiwglEqSQoCuK0yEIcKZpTiXq6GuZMAA
        Lx/8DtynzwzBo8N6KZVwXIbQ4fnbvdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-l_infEziPbOXnAOUpnc7cA-1; Sun, 02 Aug 2020 14:26:47 -0400
X-MC-Unique: l_infEziPbOXnAOUpnc7cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8F8C1005504;
        Sun,  2 Aug 2020 18:26:44 +0000 (UTC)
Received: from krava (unknown [10.40.192.18])
        by smtp.corp.redhat.com (Postfix) with SMTP id 28B2F8A195;
        Sun,  2 Aug 2020 18:26:40 +0000 (UTC)
Date:   Sun, 2 Aug 2020 20:26:40 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200802182640.GA139274@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-11-jolsa@kernel.org>
 <20200802031342.3bfxqo22ezi2zzu4@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802031342.3bfxqo22ezi2zzu4@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 08:13:42PM -0700, Alexei Starovoitov wrote:
> On Sat, Aug 01, 2020 at 07:03:18PM +0200, Jiri Olsa wrote:
> > Adding d_path helper function that returns full path for
> > given 'struct path' object, which needs to be the kernel
> > BTF 'path' object. The path is returned in buffer provided
> > 'buf' of size 'sz' and is zero terminated.
> > 
> >   bpf_d_path(&file->f_path, buf, size);
> > 
> > The helper calls directly d_path function, so there's only
> > limited set of function it can be called from. Adding just
> > very modest set for the start.
> > 
> > Updating also bpf.h tools uapi header and adding 'path' to
> > bpf_helpers_doc.py script.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 13 +++++++++
> >  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
> >  scripts/bpf_helpers_doc.py     |  2 ++
> >  tools/include/uapi/linux/bpf.h | 13 +++++++++
> >  4 files changed, 76 insertions(+)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index eb5e0c38eb2c..a356ea1357bf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3389,6 +3389,18 @@ union bpf_attr {
> >   *		A non-negative value equal to or less than *size* on success,
> >   *		or a negative error in case of failure.
> >   *
> > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> 
> Please make it return 'long'. As you well ware the generated code will be better.
> 

will do, thanks

jirka

