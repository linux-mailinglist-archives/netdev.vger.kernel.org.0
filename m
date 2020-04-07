Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA471A0A5D
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgDGJqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:46:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53169 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726725AbgDGJqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:46:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586252768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Su0ReTVX7Cb33fcFL+lR2+jV5JDoxhihoJOmLDMgeLw=;
        b=PyeRhW3RmO95SbRnk5+zMOnIEnR4QdLdDx8o0m40msptYemsPtf72G/Mn0iTdrsZWvm76n
        S67PCimmbXZ/MG9ujwYArb+YQJIaUSx1WlwPbXHr4l51JGU1lw3oBSZ3OZf9jtBx1i3mwu
        qaCyO5dG+rJyrxGLKCZOaQAbB1pCqC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-xLq7ZSX6M1ix20yGWkVWlA-1; Tue, 07 Apr 2020 05:46:04 -0400
X-MC-Unique: xLq7ZSX6M1ix20yGWkVWlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80D6B800D50;
        Tue,  7 Apr 2020 09:46:02 +0000 (UTC)
Received: from krava (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30111271B2;
        Tue,  7 Apr 2020 09:45:59 +0000 (UTC)
Date:   Tue, 7 Apr 2020 11:45:56 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     KP Singh <kpsingh@chromium.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200407094556.GC3144092@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
 <20200403090828.GF2784502@krava>
 <20200406031602.GR23230@ZenIV.linux.org.uk>
 <20200406090918.GA3035739@krava>
 <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
 <20200407092753.GA109512@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407092753.GA109512@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 11:27:53AM +0200, KP Singh wrote:
> On 06-Apr 18:10, Alexei Starovoitov wrote:
> > On Mon, Apr 06, 2020 at 11:09:18AM +0200, Jiri Olsa wrote:
> > > 
> > > is there any way we could have d_path functionality (even
> > > reduced and not working for all cases) that could be used
> > > or called like that?
> > 
> > I agree with Al. This helper cannot be enabled for all of bpf tracing.
> > We have to white list its usage for specific callsites only.
> > May be all of lsm hooks are safe. I don't know yet. This has to be
> > analyzed carefully. Every hook. One by one.
> 
> I agree with this, there are some LSM hooks which do get called in
> interrupt context, eg. task_free (which gets called in an RCU
> callback).
> 
> The hooks that we are using it for and we know that it works (using
> our experimental helpers similar to this) are the bprm_* hooks in the
> exec pathway (for logic based on the path of the executable).
> 
> It might be worth whitelisting these functions by adding verifier ops
> for LSM programs?
> 
> Would you want to do it as a part of this series?

I guess we should to do some generic whitelist solution that
would be usable by any prog type.. I'll try to put something
together

jirka

