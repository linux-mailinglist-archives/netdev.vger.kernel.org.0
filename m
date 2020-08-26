Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006C9252A0C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgHZJar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:30:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727854AbgHZJaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598434244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIFpYXnMBOqbh9sUvKB9k5AmLKgqS7phPYgWhAo81EI=;
        b=Tkyk+zpzzTQbKjrtnCYpuys/U/XoexH03ECslznPTKcx1VNHZrJPB9JPKk38swVQmGUVIk
        a77dWVxrBXX2vWKm8TxdjRx4ZeTJU2U0K4zSoMU7e2TJ/VCGsCNdAysn2GSZg8TR8eWS8A
        zjbc3Oqd6kJa9n4b5MLptF46mLHe3Yc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-sAPp14RnP8-Zay7gCO39hQ-1; Wed, 26 Aug 2020 05:30:39 -0400
X-MC-Unique: sAPp14RnP8-Zay7gCO39hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3B861800D41;
        Wed, 26 Aug 2020 09:30:37 +0000 (UTC)
Received: from krava (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAC4760D34;
        Wed, 26 Aug 2020 09:30:31 +0000 (UTC)
Date:   Wed, 26 Aug 2020 11:30:30 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v12 bpf-next 13/14] selftests/bpf: Add test for d_path
 helper
Message-ID: <20200826093030.GB703542@krava>
References: <20200825192124.710397-1-jolsa@kernel.org>
 <20200825192124.710397-14-jolsa@kernel.org>
 <CAADnVQ+_X4-eWW_wNDr9G+Ac6LObQeJ5uCxgetGpR2F33BFk5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+_X4-eWW_wNDr9G+Ac6LObQeJ5uCxgetGpR2F33BFk5A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 04:06:14PM -0700, Alexei Starovoitov wrote:
> On Tue, Aug 25, 2020 at 12:22 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > +
> > +static int trigger_fstat_events(pid_t pid)
> > +{
> > +       int sockfd = -1, procfd = -1, devfd = -1;
> > +       int localfd = -1, indicatorfd = -1;
> > +       int pipefd[2] = { -1, -1 };
> > +       struct stat fileStat;
> > +       int ret = -1;
> > +
> > +       /* unmountable pseudo-filesystems */
> > +       if (CHECK(pipe(pipefd) < 0, "trigger", "pipe failed\n"))
> > +               return ret;
> > +       /* unmountable pseudo-filesystems */
> > +       sockfd = socket(AF_INET, SOCK_STREAM, 0);
> > +       if (CHECK(sockfd < 0, "trigger", "scoket failed\n"))
> > +               goto out_close;
> > +       /* mountable pseudo-filesystems */
> > +       procfd = open("/proc/self/comm", O_RDONLY);
> > +       if (CHECK(procfd < 0, "trigger", "open /proc/self/comm failed\n"))
> > +               goto out_close;
> > +       devfd = open("/dev/urandom", O_RDONLY);
> > +       if (CHECK(devfd < 0, "trigger", "open /dev/urandom failed\n"))
> > +               goto out_close;
> > +       localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);
> 
> The work-in-progress CI caught a problem here:
> 
> In file included from /usr/include/fcntl.h:290:0,
> 4814                 from ./test_progs.h:29,
> 4815                 from
> /home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:3:
> 4816In function ‘open’,
> 4817    inlined from ‘trigger_fstat_events’ at
> /home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:50:10,
> 4818    inlined from ‘test_d_path’ at
> /home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:119:6:
> 4819/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:4: error: call to
> ‘__open_missing_mode’ declared with attribute error: open with O_CREAT
> or O_TMPFILE in second argument needs 3 arguments
> 4820    __open_missing_mode ();
> 4821    ^~~~~~~~~~~~~~~~~~~~~~

ok, looks like it's missing the permission bits

> 
> I don't see this bug in my setup, since I'm using an older glibc that
> doesn't have this check,
> so I've pushed it anyway since it was taking a bit long to land and folks were
> eagerly waiting for the allowlist and d_path features.
> But some other folks may complain about build breakage really soon.
> So please follow up asap.

time to upadte my systems, I'm missing new warnings ;-)

I'll send the fix

thanks,
jirka

