Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9872511EA59
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfLMS3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:29:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55836 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728792AbfLMS3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576261744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EuipFtcR9CV/PUK4gZJD69/BC6ZNJnPtOUYxgz6hIYs=;
        b=Lbiw5D6Ienk9rSXCuN6ilACSV5mCmYDnk5S+00GDAogIgLH7oqT4UQvN2IuA1kIPe2x44p
        laaQigM+PiOlDVucAuh8KFrSKO9ksmn3o2PO325LQjQZOSwqGtmsQMLCPn0JZX3htva/Yy
        BXu0vmgKook+rYFByH3Ek74qLVWID2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-8BbtPYfgOsqEYAs5wK98og-1; Fri, 13 Dec 2019 13:29:02 -0500
X-MC-Unique: 8BbtPYfgOsqEYAs5wK98og-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B880F107ACC5;
        Fri, 13 Dec 2019 18:28:59 +0000 (UTC)
Received: from krava (ovpn-204-48.brq.redhat.com [10.40.204.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74C2519C4F;
        Fri, 13 Dec 2019 18:28:50 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:28:47 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213182847.GA8994@krava>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
 <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
 <20191213121118.236f55b8@gandalf.local.home>
 <20191213173016.posmo4pxjwjvv4bh@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213173016.posmo4pxjwjvv4bh@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 09:30:18AM -0800, Alexei Starovoitov wrote:
> On Fri, Dec 13, 2019 at 12:11:18PM -0500, Steven Rostedt wrote:
> > On Fri, 13 Dec 2019 08:51:57 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > > It had two choices. Both valid. I don't know why gdb picked this one.
> > > So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
> > > good. I think renaming ftrace one would be better, since gdb picked perf one
> > > for whatever reason.
> > 
> > Because of the sort algorithm. But from a technical perspective, the
> > ring buffer that ftrace uses is generic, where the perf ring buffer can
> > only be used for perf. Call it "event_ring_buffer" or whatever, but
> > it's not generic and should not have a generic name.
> 
> I don't mind whichever way. Just saying it would be good to rename :)
> 

Peter,
any chance we could use the 'struct perf_buffer' for perf?

thanks,
jirka

