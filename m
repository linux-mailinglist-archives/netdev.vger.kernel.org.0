Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C111354298
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbhDEOIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237271AbhDEOIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 10:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617631707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kds2HNIrOSBVMRE8AkMvF2kwivsUAU3ayRmgSX22+j4=;
        b=SA1Kpts+z8b3+yHVhaZovLU2K747oLeil9U6YAMBTwJqJauObeYxbql67/v6hglp88hXZz
        t7sRFuuLQBIr553kRcqrTSai37JT0G8GfQqy2YEOcTmDeF8azM0bEo7pAfhDiWucMZP9nN
        xJL/hm+jgpcYl3PCsvhYCB7/yDvFp2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-QIMO-kMiOkqFBKqk1CHBbA-1; Mon, 05 Apr 2021 10:08:26 -0400
X-MC-Unique: QIMO-kMiOkqFBKqk1CHBbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DE931019630;
        Mon,  5 Apr 2021 14:08:24 +0000 (UTC)
Received: from krava (unknown [10.40.192.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 790F25D741;
        Mon,  5 Apr 2021 14:08:18 +0000 (UTC)
Date:   Mon, 5 Apr 2021 16:08:17 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Message-ID: <YGsZ0VGMk/hBfr2y@krava>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
 <87blavd31f.fsf@toke.dk>
 <20210403182155.upi6267fh3gsdvrq@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210403182155.upi6267fh3gsdvrq@ast-mbp>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 11:21:55AM -0700, Alexei Starovoitov wrote:
> On Sat, Apr 03, 2021 at 01:24:12PM +0200, Toke Høiland-Jørgensen wrote:
> > >  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> > > -		err = -ENOENT;
> > > -		goto out_unlock;
> > > +		/*
> > > +		 * Allow re-attach for tracing programs, if it's currently
> > > +		 * linked, bpf_trampoline_link_prog will fail.
> > > +		 */
> > > +		if (prog->type != BPF_PROG_TYPE_TRACING) {
> > > +			err = -ENOENT;
> > > +			goto out_unlock;
> > > +		}
> > > +		if (!prog->aux->attach_btf) {
> > > +			err = -EINVAL;
> > > +			goto out_unlock;
> > > +		}
> > 
> > I'm wondering about the two different return codes here. Under what
> > circumstances will aux->attach_btf be NULL, and why is that not an
> > ENOENT error? :)
> 
> The feature makes sense to me as well.
> I don't quite see how it would get here with attach_btf == NULL.
> Maybe WARN_ON then?

right, that should be always there

> Also if we're allowing re-attach this way why exclude PROG_EXT and LSM?
> 

I was enabling just what I needed for the test, which is so far
the only use case.. I'll see if I can enable that for all of them

jirka

