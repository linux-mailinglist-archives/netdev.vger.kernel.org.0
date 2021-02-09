Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED930315392
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhBIQP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:15:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhBIQPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:15:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612887229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nnY4e3bu7/a3DG+aVrgYbco1QCGV9rZ/D0QUrkcNoPQ=;
        b=JohqIKN+DUrgFdoAKz/drYKp1+vssVEhlz1w4MsTtmeqAbzYmkxrqwVawyiZDtnojRV4mA
        09QyqiKKP4OabR0/CflnC8vh/mS21mTKiECcx+xd60VeAJVDaEHi6q7fSu9veDgfKtNyki
        Ovi8cSec0iWeQEIHxjBAX3aQ77UENSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-xaAYfVgPOkWgPiVw3qTkgw-1; Tue, 09 Feb 2021 11:13:45 -0500
X-MC-Unique: xaAYfVgPOkWgPiVw3qTkgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD735801979;
        Tue,  9 Feb 2021 16:13:42 +0000 (UTC)
Received: from krava (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with SMTP id 725F060861;
        Tue,  9 Feb 2021 16:13:39 +0000 (UTC)
Date:   Tue, 9 Feb 2021 17:13:38 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCKwxNDkS9rdr43W@krava>
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
 <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCKlrLkTQXc4Cyx7@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:

SNIP

> > > > >                 DW_AT_prototyped        (true)
> > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > >                 DW_AT_external  (true)
> > > > >
> > > > 
> > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > pahole ignores it. I don't know why this happens and it's quite
> > > > strange, given vfs_truncate is just a normal global function.
> > 
> > right, I can't see it in mcount adresses.. but it begins with instructions
> > that appears to be nops, which would suggest it's traceable
> > 
> > 	ffff80001031f430 <vfs_truncate>:
> > 	ffff80001031f430: 5f 24 03 d5   hint    #34
> > 	ffff80001031f434: 1f 20 03 d5   nop
> > 	ffff80001031f438: 1f 20 03 d5   nop
> > 	ffff80001031f43c: 3f 23 03 d5   hint    #25
> > 
> > > > 
> > > > I'd like to understand this issue before we try to fix it, but there
> > > > is at least one improvement we can make: pahole should check ftrace
> > > > addresses only for static functions, not the global ones (global ones
> > > > should be always attachable, unless they are special, e.g., notrace
> > > > and stuff). We can easily check that by looking at the corresponding
> > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> 
> I'm still trying to build the kernel.. however ;-)

I finally reproduced.. however arm's not using mcount_loc
but some other special section.. so it's new mess for me

however I tried the same build without LLVM=1 and it passed,
so my guess is that clang is doing something unexpected

jirka

