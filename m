Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDD19D320
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbgDCJIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 05:08:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58487 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727635AbgDCJIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 05:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585904923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5i0edoPAgKxHAz25npw6diYParUrlfrwTTYIH1aAF8=;
        b=CCIwSuKRlDW20oI/GfJIZtE7viL0LABjxQElXaqUT2WjWFnbpbyQ9yJ+Od4KEpBhfJStm2
        zPBGjjqWCGfJ6UMxJaCD60k7fY/IGYI5eE6viFJ6gVR8x3j6/7Q9ZqXdLY8jl38EZrC+Xk
        zM5UzQVl4ks2DQNU5rP7yAc/GjJuSgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-nST81jgjMp24FPGVzIM8vA-1; Fri, 03 Apr 2020 05:08:41 -0400
X-MC-Unique: nST81jgjMp24FPGVzIM8vA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B3A8017F6;
        Fri,  3 Apr 2020 09:08:39 +0000 (UTC)
Received: from krava (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9917B196AE;
        Fri,  3 Apr 2020 09:08:33 +0000 (UTC)
Date:   Fri, 3 Apr 2020 11:08:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200403090828.GF2784502@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402142106.GF23230@ZenIV.linux.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 03:21:06PM +0100, Al Viro wrote:
> On Wed, Apr 01, 2020 at 01:09:04PM +0200, Jiri Olsa wrote:
> > hi,
> > adding d_path helper to return full path for 'path' object.
> > 
> > I originally added and used 'file_path' helper, which did the same,
> > but used 'struct file' object. Then realized that file_path is just
> > a wrapper for d_path, so we'd cover more calling sites if we add
> > d_path helper and allowed resolving BTF object within another object,
> > so we could call d_path also with file pointer, like:
> > 
> >   bpf_d_path(&file->f_path, buf, size);
> > 
> > This feature is mainly to be able to add dpath (filepath originally)
> > function to bpftrace, which seems to work nicely now, like:
> > 
> >   # bpftrace -e 'kretfunc:fget { printf("%s\n", dpath(args->ret->f_path));  }' 
> > 
> > I'm not completely sure this is all safe and bullet proof and there's
> > no other way to do this, hence RFC post.
> > 
> > I'd be happy also with file_path function, but I thought it'd be
> > a shame not to try to add d_path with the verifier change.
> > I'm open to any suggestions ;-)
> 
> What are the locking conditions guaranteed to that sucker?  Note that d_path()
> is *NOT* lockless - call it from an interrupt/NMI/etc. and you are fucked.
> It can grab rename_lock and mount_lock; usually it avoids that, so you won't
> see them grabbed on every call, but after the first seqlock mismatch it will
> fall back to grabbing the spinlock in question.  And then there's ->d_dname(),
> with whatever things _that_ chooses to do....

if we limit it just to task context I think it would still be
helpful for us:

  if (in_task())
	d_path..

perhaps even create a d_path version without d_dname callback
if that'd be still a problem, because it seems to be there mainly
for special filesystems..?

thanks,
jirka

