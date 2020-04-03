Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041FD19D2C4
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390433AbgDCI4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:56:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727856AbgDCI4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585904158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUO2hpzrUb4O8Yw0h3ZZcshPOPBcVYEzfp73urzKT10=;
        b=iLvsTEEgKWX4TaeGph6n6HkiGZCtmJVJkyKinIIkVXNXULe/st5wgFUidCOane8dZgQ5J3
        koZYHpT4j2DPEIH53/FlpPGOsxpATiqka1NZByBLF/BCluRcfRTGmLrpEV5fkdQsY3KF2i
        nP3yDHWdtaFLkdjzbh0VTrzRvlD6xCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-HneTfMmuPouWBW5cJc_5hQ-1; Fri, 03 Apr 2020 04:55:55 -0400
X-MC-Unique: HneTfMmuPouWBW5cJc_5hQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82876477;
        Fri,  3 Apr 2020 08:55:52 +0000 (UTC)
Received: from krava (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36ED35DA76;
        Fri,  3 Apr 2020 08:55:35 +0000 (UTC)
Date:   Fri, 3 Apr 2020 10:55:29 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Florent Revest <revest@chromium.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200403085529.GD2784502@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <5968eda68bfec39387c34ffaf0ecc3ed5d8afd6f.camel@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5968eda68bfec39387c34ffaf0ecc3ed5d8afd6f.camel@chromium.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 04:03:00PM +0200, Florent Revest wrote:
> On Wed, 2020-04-01 at 13:09 +0200, Jiri Olsa wrote:
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
> >   # bpftrace -e 'kretfunc:fget { printf("%s\n", dpath(args->ret-
> > >f_path));  }' 
> > 
> > I'm not completely sure this is all safe and bullet proof and there's
> > no other way to do this, hence RFC post.
> > 
> > I'd be happy also with file_path function, but I thought it'd be
> > a shame not to try to add d_path with the verifier change.
> > I'm open to any suggestions ;-)
> 
> First of all I want to mention that we are really interested in this
> feature so thanks a lot for bringing it up Jiri! I have experimented
> with similar BPF helpers in the past few months so I hope my input can
> be helpful! :)
> 
> One of our use-cases is to gather information about execution events,
> including a bunch of paths (such as the executable command, the
> resolved executable file path and the current-working-directory) and
> then output them to Perf.
> Each of those paths can be up to PATH_MAX(one page) long so we would
> pre-allocate a data structure with a few identifiers (to later
> reassemble the event from userspace) and a page of data and then we
> would output it using bpf_perf_event_output. However, with three mostly
> empty pages per event, we would quickly fill up the ring buffer and
> loose many events.
> This might be a bit out-of-scope at this moment but one of the
> teachings we got from playing with such a helper is that we would also
> need a helper for outputting strings to Perf, pre-pended with a header
> buffer.

I think bpftrace uses fixed size as well at some point,
but very small one, which is still sufficent for tools usage,
but we can always send only data with the size of the path

thanks for info
jirka

