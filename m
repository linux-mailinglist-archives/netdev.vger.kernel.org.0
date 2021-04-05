Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CDF35486C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbhDEV6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241318AbhDEV6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 17:58:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617659918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rp0B3Z0gvL548SBUOTCx5smRmcVt/tRjB04FMO2XAaU=;
        b=IaYUlTDipOQet/miNz55hBWZ5Yz9AXj0I2mhv+MbrVdIF7UfRn3X+Gp/PmP1XLqOvfL/te
        hgBhvJQ8RLPmhxAzqmkGnvr9ut2jOrUbaZM2LuyNjil8IhyMNcsWyr7VlN48V6y1EZWNSb
        nTlKPNd4veNgYdySnmjXSsWPwXyP/GU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-m2NPmldfNDCt_1mt-l5W0g-1; Mon, 05 Apr 2021 17:58:34 -0400
X-MC-Unique: m2NPmldfNDCt_1mt-l5W0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA7991005D54;
        Mon,  5 Apr 2021 21:58:32 +0000 (UTC)
Received: from krava (unknown [10.40.192.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12EB819C45;
        Mon,  5 Apr 2021 21:58:26 +0000 (UTC)
Date:   Mon, 5 Apr 2021 23:58:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Message-ID: <YGuIAWA4kRJCfI4U@krava>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
 <87blavd31f.fsf@toke.dk>
 <20210403182155.upi6267fh3gsdvrq@ast-mbp>
 <YGsZ0VGMk/hBfr2y@krava>
 <87ft04rf51.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ft04rf51.fsf@toke.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 04:15:54PM +0200, Toke Høiland-Jørgensen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > On Sat, Apr 03, 2021 at 11:21:55AM -0700, Alexei Starovoitov wrote:
> >> On Sat, Apr 03, 2021 at 01:24:12PM +0200, Toke Høiland-Jørgensen wrote:
> >> > >  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> >> > > -		err = -ENOENT;
> >> > > -		goto out_unlock;
> >> > > +		/*
> >> > > +		 * Allow re-attach for tracing programs, if it's currently
> >> > > +		 * linked, bpf_trampoline_link_prog will fail.
> >> > > +		 */
> >> > > +		if (prog->type != BPF_PROG_TYPE_TRACING) {
> >> > > +			err = -ENOENT;
> >> > > +			goto out_unlock;
> >> > > +		}
> >> > > +		if (!prog->aux->attach_btf) {
> >> > > +			err = -EINVAL;
> >> > > +			goto out_unlock;
> >> > > +		}
> >> > 
> >> > I'm wondering about the two different return codes here. Under what
> >> > circumstances will aux->attach_btf be NULL, and why is that not an
> >> > ENOENT error? :)
> >> 
> >> The feature makes sense to me as well.
> >> I don't quite see how it would get here with attach_btf == NULL.
> >> Maybe WARN_ON then?
> >
> > right, that should be always there
> >
> >> Also if we're allowing re-attach this way why exclude PROG_EXT and LSM?
> >> 
> >
> > I was enabling just what I needed for the test, which is so far
> > the only use case.. I'll see if I can enable that for all of them
> 
> How would that work? For PROG_EXT we clear the destination on the first
> attach (to avoid keeping a ref on it), so re-attach can only be done
> with an explicit target (which already works just fine)...

right, I'm just looking on it ;-) extensions already seem allow for that,
I'll check LSM

jirka

