Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C33325982
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhBYWSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232982AbhBYWRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 17:17:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614291366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IulShgPja5LFMfmJrciYQfwwOAfu+I3HWxw771WxVkc=;
        b=eEXP7nTOr4rz/p9W1XFyZNEclybe1IFhdxIz3UKven/eCBB0lughmvWsfvTOs+frV3DUzr
        xs249f7Poru4BMtdxArrnalo2PKUd3wBRHVGSNWxGh67p6/oUPN/5cYzaoTK7R2P7x3h5u
        IxnEXk67GeQ461zzIvYkNU9QotJWg8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-auyIovefOMC4XwAfcpTe9w-1; Thu, 25 Feb 2021 17:16:01 -0500
X-MC-Unique: auyIovefOMC4XwAfcpTe9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 002BE107ACE8;
        Thu, 25 Feb 2021 22:15:59 +0000 (UTC)
Received: from krava (unknown [10.40.192.91])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0838677701;
        Thu, 25 Feb 2021 22:15:55 +0000 (UTC)
Date:   Thu, 25 Feb 2021 23:15:55 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [RFC] dwarves/pahole: Add test scripts
Message-ID: <YDghm2BMSjcgDfPe@krava>
References: <20210223132321.220570-1-jolsa@kernel.org>
 <20210224173045.GA51663@24bbad8f3778>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224173045.GA51663@24bbad8f3778>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 10:30:45AM -0700, Nathan Chancellor wrote:

SNIP

> > +
> > +build()
> > +{
> > +	local name=$1
> > +	local opts=$2
> 
> A more robust way to handle this might be
> 
> shift
> local opts=$@
> 
> > +
> > +	echo "build ${name} (${OUTPUT}/output)"
> > +
> > +	mkdir -p ${OBJECTS}/${name}
> > +	mkdir -p ${OUTPUT}
> > +
> > +	pushd ${KDIR}
> > +	make ${opts} -j"$(nproc)" O=${OUTPUT} olddefconfig > ${OUTPUT}/output 2>&1
> 
> Then change this to
> 
> make "${opts[@]}"
> 
> shellcheck complains about implicit word splitting (and finds some other
> things in the other script).

I have no doutbs ;-) ok

SNIP

> > +
> > +	PAHOLE=$(realpath ${PAHOLE})
> > +	OBJECTS=$(realpath ${OBJECTS})
> > +
> > +	echo "output:  ${OUTPUT}"
> > +	echo "kdir:    ${KDIR}"
> > +	echo "pahole:  ${PAHOLE}"
> > +	echo "objects: ${OBJECTS}"
> > +	echo
> > +
> > +	mkdir -p ${OBJECTS}
> > +
> > +	echo "cleanup ${KDIR}"
> > +	make -C ${KDIR} mrproper
> > +
> > +
> > +	build x86-clang     "LLVM=1"
> 
> With that change above, you could unquote these options and just pass
> them in as regular parameters.

ok I see, that'd be easier and better looking, I'll change this

> 
> > +	build x86-gcc       ""
> > +
> > +	build aarch64-clang "ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1"
> > +	build aarch64-gcc   "ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"
> > +
> > +#	build powerpc-clang "ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu- LLVM=1"
> > +	build powerpc-gcc   "ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu-"
> > +
> > +#	build powerpcle-clang "ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1"
> > +	build powerpcle-gcc   "ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu-"
> > +
> > +#	build s390x-clang   "ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- LLVM=1"
> 
> powerpc64le and s390 can build with CC=clang, instead of LLVM=1.

I got some strange error when building ppc and s390 with LLVM=1,
but I did not check it deeply.. I'll try with CC=clang then, great

> 
> I will see if I can give this a run locally over the next week or so.

thanks,
jirka

