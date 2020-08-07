Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D447023F1E9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGR0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:26:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57571 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726015AbgHGR0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596821156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1OKvA0TNCXh+ztrd8AvHmGOv+UMmuzg53pWAJG5mrDk=;
        b=XCTG/EVXH/EuI40YKo6MBShX02c57stJiXkAs9FMk9pv8uq5U33XStRb54rouPa45nLfxF
        yeyEuUd4bsnqQxWV40Jt58okjc/aS6evB7JRTJ3CWdyrsIo1jtqD9YEMQmZNZta1WMuvhI
        f+xtuuQfYznLQkJQV+9QYAW5n2fRu+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-8eQRjAnaMeqj5qKSf_ezAQ-1; Fri, 07 Aug 2020 13:25:51 -0400
X-MC-Unique: 8eQRjAnaMeqj5qKSf_ezAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66803107BA68;
        Fri,  7 Aug 2020 17:25:49 +0000 (UTC)
Received: from krava (unknown [10.40.193.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id A1B2D8AC13;
        Fri,  7 Aug 2020 17:25:44 +0000 (UTC)
Date:   Fri, 7 Aug 2020 19:25:43 +0200
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
Subject: Re: [PATCH v10 bpf-next 00/14] bpf: Add d_path helper
Message-ID: <20200807172543.GB561444@krava>
References: <20200807094559.571260-1-jolsa@kernel.org>
 <20200807163503.ytoej6qxsjuedty7@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807163503.ytoej6qxsjuedty7@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 09:35:03AM -0700, Alexei Starovoitov wrote:
> On Fri, Aug 07, 2020 at 11:45:45AM +0200, Jiri Olsa wrote:
> > hi,
> > adding d_path helper function that returns full path for
> > given 'struct path' object, which needs to be the kernel
> > BTF 'path' object. The path is returned in buffer provided
> > 'buf' of size 'sz' and is zero terminated.
> > 
> >   long bpf_d_path(struct path *path, char *buf, u32 sz);
> > 
> > The helper calls directly d_path function, so there's only
> > limited set of function it can be called from.
> > 
> > The patchset also adds support to add set of BTF IDs for
> > a helper to define functions that the helper is allowed
> > to be called from.
> > 
> > Also available at:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/d_path
> > 
> > v10 changes:
> >   - added few acks
> >   - returned long instead of int in bpf_d_path helper [Alexei]
> >   - used local cnt variable in d_path test [Andrii]
> >   - fixed tyo in d_path comment [Andrii]
> >   - get rid of reg->off condition in check_func_arg [Andrii]
> 
> bpf-next is closed.
> I still encourage developers to submit new features for review, but please tag
> them as RFC, so the purpose is clear to both maintainers and authors.

sry, did not know this was the rule

jirka

