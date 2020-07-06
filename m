Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB7215552
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgGFKPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:15:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728628AbgGFKPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594030547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y68mMxEzC0O/oSar6VvuB9qVZfYoFFGVqLRrOjB+/5U=;
        b=Pp82W0QjRsNTojdh043g1CQHEN9vRTs1zySsSVNaQtDKhV7x9D3XFJKzbS39ghXe6K2Q1p
        N9lVwc9OHcvrhSh3fPQAYhHRM8IlIHE7h7/vvJLImIw5UUtsCAy7spU4rhVCAa9nPS+V3/
        FZ6UZkRlZJ5F1jlZZmkRBvV1kVMaFs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-N3QhGbUdMMqeQFS9DGYDag-1; Mon, 06 Jul 2020 06:15:43 -0400
X-MC-Unique: N3QhGbUdMMqeQFS9DGYDag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47DF2106B248;
        Mon,  6 Jul 2020 10:15:41 +0000 (UTC)
Received: from krava (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5224F7B416;
        Mon,  6 Jul 2020 10:15:35 +0000 (UTC)
Date:   Mon, 6 Jul 2020 12:15:34 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc:     agordeev@linux.ibm.com, ast@kernel.org, bas@baslab.org,
        bpf@vger.kernel.org, brendan.d.gregg@gmail.com,
        daniel@iogearbox.net, dxu@dxuuu.xyz, linux-s390@vger.kernel.org,
        mat@mmarchini.me, netdev@vger.kernel.org,
        yauheni.kaliuta@redhat.com, Sumanth.Korikkar@ibm.com
Subject: Re: bpf: bpf_probe_read helper restriction on s390x
Message-ID: <20200706101534.GA3401866@krava>
References: <OFDA9C9258.BBAFD274-ON0025859D.001E3F9D-C125859D.001E497A@notes.na.collabserv.com>
 <f95739ee-59a9-4dfc-8da0-dfef2c73bd6a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f95739ee-59a9-4dfc-8da0-dfef2c73bd6a@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 08:33:15AM +0200, Sumanth Korikkar wrote:
> Hi Jiri,
> 
> s390 has overlapping address space. As suggested by the commit,
> ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should not be enabled for s390
> kernel.
> 
> This should be changed in bpftrace application.
> 
> Even if we enable ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, bpf_probe_read
> will only work in certain cases like kernel pointer deferences (kprobes). 
> User pointer deferences in uprobes/kprobes/etc will fail or have some
> invalid data
> 
> I am looking forward to this fix:
> https://github.com/iovisor/bpftrace/pull/1141 OR probe split in bpftrace.

did not see this, will review ;-) thanks a lot!

jirka

> 
> (Resending as some cc from my email client failed.)
> 
> Thank you
> 
> Best Regards
> Sumanth Korikkar
> > Jiri Olsa <jolsa@redhat.com> wrote on 07/05/2020 09:42:25 PM:
> > 
> > > Subject: [EXTERNAL] bpf: bpf_probe_read helper restriction on s390x
> > >
> > > hi,
> > > with following commit:
> > >   0ebeea8ca8a4 bpf: Restrict bpf_probe_read{, str}() only to archs
> > > where they work
> > >
> > > the bpf_probe_read BPF helper is restricted on architectures that
> > > have 'non overlapping address space' and select following config:
> > >
> > >    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> > >
> > > there's also nice explanation in this commit's changelog:
> > >   6ae08ae3dea2 bpf: Add probe_read_{user, kernel} and probe_read_
> > > {user, kernel}_str helpers
> > >
> > >
> > > We have a problem with bpftrace not working properly on s390x because
> > > bpf_probe_read is no longer available, and bpftrace does not use
> > > bpf_probe_read_(user/kernel) variants yet.
> > >
> > > My question is if s390x is 'arch with overlapping address space' and we
> > > could fix this by adding ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE for
> > s390x
> > > or we need to fix bpftrace to detect this, which we probably need to do
> > > in any case ;-)
> > >
> > > thanks,
> > > jirka
> > >
> > 
> -- 
> Sumanth Korikkar
> 

