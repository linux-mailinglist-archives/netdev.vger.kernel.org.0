Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E834F1EE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhC3UDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233332AbhC3UCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 16:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617134565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XXbvDbH/Mrp7xxaK/1Pr1j9vGAejLeqioS3do8lG9EI=;
        b=GwsJrWtf6/3ZWrf6A/pVdILQXrIZavN3e+Td0FK6ZQ66LlKRMXV3kihE+GJM8gKW3hMj3E
        yfHr2V27Cy5zIsSSpTlsiM8dDxjwpa1D+KDK2zcP+MjpFWSWV2PfDg/uW6VnYhp2JxcYHO
        kYns0Oc1jF+bFFbDDzB7fmr0XymP1nE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-Z-wD3WdVMwirSGLrg6bYbw-1; Tue, 30 Mar 2021 16:02:43 -0400
X-MC-Unique: Z-wD3WdVMwirSGLrg6bYbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D71C501FE;
        Tue, 30 Mar 2021 20:02:42 +0000 (UTC)
Received: from krava (unknown [10.40.192.25])
        by smtp.corp.redhat.com (Postfix) with SMTP id 560A560871;
        Tue, 30 Mar 2021 20:02:36 +0000 (UTC)
Date:   Tue, 30 Mar 2021 22:02:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC PATCH bpf-next 2/4] selftests/bpf: Add re-attach test to
 fentry_test
Message-ID: <YGOD2xtqR+zMw0o8@krava>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-3-jolsa@kernel.org>
 <A0B730F5-758F-4F28-9543-4ED08F0BDECB@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A0B730F5-758F-4F28-9543-4ED08F0BDECB@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 01:23:15AM +0000, Song Liu wrote:
> 
> 
> > On Mar 28, 2021, at 4:26 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> > 
> > Adding the test to re-attach (detach/attach again) tracing
> > fentry programs, plus check that already linked program can't
> > be attached again.
> > 
> > Fixing the number of check-ed results, which should be 8.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > 
> [...]
> > +
> > +void test_fentry_test(void)
> > +{
> > +	struct fentry_test *fentry_skel = NULL;
> > +	struct bpf_link *link;
> > +	int err;
> > +
> > +	fentry_skel = fentry_test__open_and_load();
> > +	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> > +		goto cleanup;
> > +
> > +	err = fentry_test__attach(fentry_skel);
> > +	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> > +		goto cleanup;
> > +
> > +	err = fentry_test(fentry_skel);
> > +	if (CHECK(err, "fentry_test", "fentry test failed: %d\n", err))
> > +		goto cleanup;
> > +
> > +	fentry_test__detach(fentry_skel);
> > +
> > +	/* Re-attach and test again */
> > +	err = fentry_test__attach(fentry_skel);
> > +	if (CHECK(err, "fentry_attach", "fentry re-attach failed: %d\n", err))
> > +		goto cleanup;
> > +
> > +	link = bpf_program__attach(fentry_skel->progs.test1);
> > +	if (CHECK(!IS_ERR(link), "attach_fentry re-attach without detach",
> > +		  "err: %ld\n", PTR_ERR(link)))
> 
> nit: I guess we shouldn't print PTR_ERR(link) when link is not an error code?
> This shouldn't break though. 

true, makes no sense.. I'll remove it

thanks,
jirka

