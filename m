Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19023CF32
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgHETQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:16:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729147AbgHESAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596650443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x7wUh8ZexL7KK6TXDeSUui6HhK29BUIFxrtlXH2p+X0=;
        b=SKz9B1GlNf9IKnblEJG5H6kYKB/hw4Rb7MTecmctgYHXtZOWP3QMy97gR5IJcMYd6Lbjxs
        p5kC7okKB350BC9M8uEQswe2lqP6O+hiBQpO6o/ry7cCo6qByGzzsNYS/FVeX/KZpErJFu
        U0CX2VMZpc1AusNZOyA3/ZDgL/jN9Ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-KBeJp0gSNJmafExVxB_dFw-1; Wed, 05 Aug 2020 14:00:41 -0400
X-MC-Unique: KBeJp0gSNJmafExVxB_dFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC23F8CE800;
        Wed,  5 Aug 2020 18:00:38 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9C46770105;
        Wed,  5 Aug 2020 18:00:35 +0000 (UTC)
Date:   Wed, 5 Aug 2020 20:00:34 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 13/14] selftests/bpf: Add test for d_path
 helper
Message-ID: <20200805180034.GE319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-14-jolsa@kernel.org>
 <CAEf4BzYq5jhTPZRiRzDmi_92qg+0vwobmkyLEqB50mrG_39BeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYq5jhTPZRiRzDmi_92qg+0vwobmkyLEqB50mrG_39BeQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:40:05PM -0700, Andrii Nakryiko wrote:

SNIP

> > +SEC("fentry/vfs_getattr")
> > +int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
> > +            __u32 request_mask, unsigned int query_flags)
> > +{
> > +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> > +       int ret;
> > +
> > +       if (pid != my_pid)
> > +               return 0;
> > +
> > +       if (cnt_stat >= MAX_FILES)
> > +               return 0;
> > +       ret = bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
> > +
> > +       /* We need to recheck cnt_stat for verifier. */
> > +       if (cnt_stat >= MAX_FILES)
> > +               return 0;
> > +       rets_stat[cnt_stat] = ret;
> > +
> > +       cnt_stat++;
> > +       return 0;
> > +}
> > +
> > +SEC("fentry/filp_close")
> > +int BPF_PROG(prog_close, struct file *file, void *id)
> > +{
> > +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> > +       int ret;
> > +
> > +       if (pid != my_pid)
> > +               return 0;
> > +
> > +       if (cnt_close >= MAX_FILES)
> > +               return 0;
> > +       ret = bpf_d_path(&file->f_path,
> > +                        paths_close[cnt_close], MAX_PATH_LEN);
> > +
> > +       /* We need to recheck cnt_stat for verifier. */
> 
> you need to do it because you are re-reading a global variable; if you
> stored cnt_close in a local variable, then did >= MAX_FILES check
> once, you probably could have avoided this duplication. Same for
> another instance above.

I see, nice.. I'll update both comments

thanks,
jirka

