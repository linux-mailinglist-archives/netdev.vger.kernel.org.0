Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B592236FA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgGQI2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:28:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29130 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgGQI2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 04:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594974526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ebzPxKx30CQyplH+LkiqZt7FL3B4q7uPFxCsqIq4uBU=;
        b=dvihuoM0vm1LaOi1E/3QdS5mueJCws3eTDLTlvFOjfWlv9UQfxtSsEFAQIEu/JsqT4X/r4
        h/1I2PqDYC5zavi8zQ3p+750pNXr+mYaNQZMpFZuXr2Kd6RDX0VY64zIgFHn+h1JFQV84A
        MvthuhGFhNujEDpWiBf7zZZsbEM/8r0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-3JeaU9XpMvCh2MEPS-Z0TA-1; Fri, 17 Jul 2020 04:28:42 -0400
X-MC-Unique: 3JeaU9XpMvCh2MEPS-Z0TA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 282A1107BEF5;
        Fri, 17 Jul 2020 08:28:40 +0000 (UTC)
Received: from krava (unknown [10.40.192.81])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8AF661A7CF;
        Fri, 17 Jul 2020 08:28:36 +0000 (UTC)
Date:   Fri, 17 Jul 2020 10:28:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     KP Singh <kpsingh@chromium.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200717082835.GB522549@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-11-jolsa@kernel.org>
 <CAEf4BzY4EqkbB7Ob9EZAJrWdBRtH_k3sL=4JZzAiqkMXjYjNKA@mail.gmail.com>
 <20200628194242.GB2988321@krava>
 <6f3fd6b0-cc3d-57e7-0444-dcaf399e6abd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f3fd6b0-cc3d-57e7-0444-dcaf399e6abd@chromium.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:13:23AM +0200, KP Singh wrote:
> 
> 
> On 6/28/20 9:42 PM, Jiri Olsa wrote:
> > On Fri, Jun 26, 2020 at 01:38:27PM -0700, Andrii Nakryiko wrote:
> >> On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >>>
> >>> Adding d_path helper function that returns full path
> >>> for give 'struct path' object, which needs to be the
> >>> kernel BTF 'path' object.
> >>>
> >>> The helper calls directly d_path function.
> >>>
> >>> Updating also bpf.h tools uapi header and adding
> >>> 'path' to bpf_helpers_doc.py script.
> >>>
> >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >>> ---
> >>>  include/uapi/linux/bpf.h       | 14 +++++++++-
> >>>  kernel/trace/bpf_trace.c       | 47 ++++++++++++++++++++++++++++++++++
> >>>  scripts/bpf_helpers_doc.py     |  2 ++
> >>>  tools/include/uapi/linux/bpf.h | 14 +++++++++-
> >>>  4 files changed, 75 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index 0cb8ec948816..23274c81f244 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -3285,6 +3285,17 @@ union bpf_attr {
> >>>   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
> >>>   *     Return
> >>>   *             *sk* if casting is valid, or NULL otherwise.
> >>> + *
> >>> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> >>> + *     Description
> >>> + *             Return full path for given 'struct path' object, which
> >>> + *             needs to be the kernel BTF 'path' object. The path is
> >>> + *             returned in buffer provided 'buf' of size 'sz'.
> >>> + *
> >>> + *     Return
> >>> + *             length of returned string on success, or a negative
> >>> + *             error in case of failure
> >>
> >> It's important to note whether string is always zero-terminated (I'm
> >> guessing it is, right?).
> > 
> > right, will add
> 
> Also note that bpf_probe_read_{kernel, user}_str return the length including
> the NUL byte:
> 
>  * 	Return
>  * 		On success, the strictly positive length of the string,
>  * 		including the trailing NUL character. On error, a negative
>  * 		value.
> 
> It would be good to keep this uniform. So you will need a len += 1 here as well.

good point, will keep it that way

thanks,
jirka

