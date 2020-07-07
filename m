Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C952216638
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGGGJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:09:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727003AbgGGGJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 02:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594102152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6vzX4pgRklp7CNc1swxRtrbo/Er7OvueNgs+gb+Ros=;
        b=WyEIavzCc60FG286YsPer+CBa8owZj/uu88a5xw4bwdcbk7gpmec6kOT9J22l85Dep4uow
        2Od95tDl7QSddv9BMughGIH+8ILhMdFaYc0d6/nQx7X1DejAChDK/ok11dkUSl6sA404DF
        WtYhBs8Z8COkbhWMka41Q/A/nibxS80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-sQPcG_A1O8m0LYGZvKO0OQ-1; Tue, 07 Jul 2020 02:09:09 -0400
X-MC-Unique: sQPcG_A1O8m0LYGZvKO0OQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6975880058A;
        Tue,  7 Jul 2020 06:09:08 +0000 (UTC)
Received: from carbon (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 528D25C1B2;
        Tue,  7 Jul 2020 06:08:59 +0000 (UTC)
Date:   Tue, 7 Jul 2020 08:08:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 2/2] selftests/bpf: test_progs avoid minus
 shell exit codes
Message-ID: <20200707080857.29d45856@carbon>
In-Reply-To: <CAEf4BzZ=v1fMxfxP9XdtEOmQV97XdwJ+Ago++VyVN19-TmeF3A@mail.gmail.com>
References: <159405478968.1091613.16934652228902650021.stgit@firesoul>
        <159405481655.1091613.6475075949369245359.stgit@firesoul>
        <CAEf4BzZ=v1fMxfxP9XdtEOmQV97XdwJ+Ago++VyVN19-TmeF3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 15:17:57 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Mon, Jul 6, 2020 at 10:00 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > There are a number of places in test_progs that use minus-1 as the argument
> > to exit(). This improper use as a process exit status is masked to be a
> > number between 0 and 255 as defined in man exit(3).  
> 
> nit: I wouldn't call it improper use, as it's a well defined behavior
> (lower byte of returned integer).
> 
> >
> > This patch use two different positive exit codes instead, to allow a shell  
> 
> typo: uses
> 
> > script to tell the two error cases apart.
> >
> > Fixes: fd27b1835e70 ("selftests/bpf: Reset process and thread affinity after each test/sub-test")
> > Fixes: 811d7e375d08 ("bpf: selftests: Restore netns after each test")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index e8f7cd5dbae4..50803b080593 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -12,7 +12,9 @@
> >  #include <string.h>
> >  #include <execinfo.h> /* backtrace */
> >
> > -#define EXIT_NO_TEST 2
> > +#define EXIT_NO_TEST           2
> > +#define EXIT_ERR_NETNS         3
> > +#define EXIT_ERR_RESET_AFFINITY        4  
> 
> Let's not overdo this with too granular error codes? All of those seem
> to be just a failure, is there any practical need to differentiate
> between NETNS vs RESET_AFFINITY failure?

I agree, because both cases (NETNS vs RESET_AFFINITY) print to stderr,
which makes it possible to troubleshoot for a human afterwards.  The
shell script just need to differentiate that is an "infra" setup issue,
as we e.g. might want to allow the RPM build to continue in those cases.


> I'd go with 3 values:
> 
> 1 - at least one test failed
> 2 - no tests were selected
> 3 - "infra" (not a test-specific failure) error (like netns or affinity failed).
> 
> Thoughts?

Sure, I can do this.

What define name reflect this best:
 EXIT_ERR_SETUP ?
 EXIT_ERR_INFRA ?
 EXIT_ERR_SETUP_INFRA ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

