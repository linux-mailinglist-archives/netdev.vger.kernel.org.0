Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8A5218F91
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgGHSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:16:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45587 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726144AbgGHSQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 14:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594232218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iAQg13RIc/6fdgwYC3LjOS6qKUgfGuA+h5I0+AO5bfM=;
        b=gedCFhC+dsOd8J2wsomTQOYAxWsNj4YjbxJk3lMuZrUxiodeRO3AHZ7ff1N6BAtbL7bZ+S
        TrEUtG52b5qxpDNzq59FIy6iF74oxhD7UlieqiNlSmIfnFYfqQc3GYAOCPfecoC2toTeQY
        5yzLjoUonvCgCOMIb1Fo7ElEIrIPrxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-nqZOZTZQPemOdt1FTRxOpw-1; Wed, 08 Jul 2020 14:16:54 -0400
X-MC-Unique: nqZOZTZQPemOdt1FTRxOpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6A8F1800D42;
        Wed,  8 Jul 2020 18:16:52 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDD8C5BAC3;
        Wed,  8 Jul 2020 18:16:45 +0000 (UTC)
Date:   Wed, 8 Jul 2020 20:16:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V3 0/2] BPF selftests test runner 'test_progs'
 use proper shell exit codes
Message-ID: <20200708201644.0a02602a@carbon>
In-Reply-To: <CAEf4Bzb07mdCQ5DS_gao4b9GSyeg406wpteC9uDaGdfOAHXFVA@mail.gmail.com>
References: <159410590190.1093222.8436994742373578091.stgit@firesoul>
        <CAEf4Bzb07mdCQ5DS_gao4b9GSyeg406wpteC9uDaGdfOAHXFVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jul 2020 00:23:48 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Tue, Jul 7, 2020 at 12:12 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > This patchset makes it easier to use test_progs from shell scripts, by using
> > proper shell exit codes. The process's exit status should be a number
> > between 0 and 255 as defined in man exit(3) else it will be masked to comply.
> >
> > Shell exit codes used by programs should be below 127. As 127 and above are
> > used for indicating signals. E.g. 139 means 11=SIGSEGV $((139 & 127))=11.
> > POSIX defines in man wait(3p) signal check if WIFSIGNALED(STATUS) and
> > WTERMSIG(139)=11. (Hint: cmd 'kill -l' list signals and their numbers).
> >
> > Using Segmentation fault as an example, as these have happened before with
> > different tests (that are part of test_progs). CI people writing these
> > shell-scripts could pickup these hints and report them, if that makes sense.
> >
> > ---
> >
> > Jesper Dangaard Brouer (2):
> >       selftests/bpf: test_progs use another shell exit on non-actions
> >       selftests/bpf: test_progs avoid minus shell exit codes
> >
> >
> >  tools/testing/selftests/bpf/test_progs.c |   13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > --
> >  
> 
> For the series:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> My preference was shorter EXIT_ERR_SETUP, but it doesn't matter.

I can just resend the patchset, if you prefer?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

