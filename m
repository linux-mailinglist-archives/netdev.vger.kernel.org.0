Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6431D29A7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgENIF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:05:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgENIF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589443527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C0js7bpun7x11RF1034oyvXB+h8XlXB8POsjugDkoeI=;
        b=VZwZ3GT+d3VBL95q7hmEHRODz7Q4sgEzDXn4gF6X3vSJy3EzWheg1b+IVKK+haADQEyaNs
        T6/nXh2mUGJ8vv60NG6cee+okqDAH2BaiI1tPWYVJP5HxfZd3u0Pb4xDLXQfp3xOkhenVb
        s5qp/xoTCA4fvVbJzNfefoaOxlvG3e8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-sF5EHEgNPmK04lQaLgj8-w-1; Thu, 14 May 2020 04:05:22 -0400
X-MC-Unique: sF5EHEgNPmK04lQaLgj8-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0231BFC1;
        Thu, 14 May 2020 08:05:19 +0000 (UTC)
Received: from krava (unknown [10.40.195.109])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5CF33619AE;
        Thu, 14 May 2020 08:05:16 +0000 (UTC)
Date:   Thu, 14 May 2020 10:05:15 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
Message-ID: <20200514080515.GH3343750@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:29:40AM -0700, Alexei Starovoitov wrote:

SNIP

> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index d09ab4afbda4..dee91c6bf450 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -130,16 +130,26 @@ gen_btf()
> >  	info "BTF" ${2}
> >  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> >  
> > -	# Create ${2} which contains just .BTF section but no symbols. Add
> > +	# Create object which contains just .BTF section but no symbols. Add
> >  	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
> >  	# deletes all symbols including __start_BTF and __stop_BTF, which will
> >  	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
> >  	# objcopy warnings: "empty loadable segment detected at ..."
> >  	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> > -		--strip-all ${1} ${2} 2>/dev/null
> > -	# Change e_type to ET_REL so that it can be used to link final vmlinux.
> > -	# Unlike GNU ld, lld does not allow an ET_EXEC input.
> > -	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> > +		--strip-all ${1} 2>/dev/null
> > +
> > +	# Create object that contains just .BTF_whitelist_* sections generated
> > +	# by bpfwl. Same as BTF section, BTF_whitelist_* data will be part of
> > +	# the vmlinux image, hence SHF_ALLOC.
> > +	whitelist=.btf.vmlinux.whitelist
> > +
> > +	${BPFWL} ${1} kernel/bpf/helpers-whitelist > ${whitelist}.c
> > +	${CC} -c -o ${whitelist}.o ${whitelist}.c
> > +	${OBJCOPY} --only-section=.BTF_whitelist* --set-section-flags .BTF=alloc,readonly \
> > +                --strip-all ${whitelist}.o 2>/dev/null
> > +
> > +	# Link BTF and BTF_whitelist objects together
> > +	${LD} -r -o ${2} ${1} ${whitelist}.o
> 
> Thank you for working on it!
> Looks great to me overall. In the next rev please drop RFC tag.
> 
> My only concern is this extra linking step. How many extra seconds does it add?

I did not meassure, but I haven't noticed any noticable delay,
I'll add meassurements to the next post

> 
> Also in patch 3:
> +               func = func__find(str);
> +               if (func)
> +                       func->id = id;
> which means that if somebody mistyped the name or that kernel function
> got renamed there will be no warnings or errors.
> I think it needs to fail the build instead.

it fails later on, when generating the array:

     if (!func->id) {
             fprintf(stderr, "FAILED: '%s' function not found in BTF data\n",
                     func->name);
             return -1;
     }

but it can clearly fail before that.. I'll change that

> 
> If additional linking step takes another 20 seconds it could be a reason
> to move the search to run-time.
> We already have that with struct bpf_func_proto->btf_id[].
> Whitelist could be something similar.
> I think this mechanism will be reused for unstable helpers and other
> func->btf_id mappings, so 'bpfwl' name would change eventually.
> It's not white list specific. It generates a mapping of names to btf_ids.
> Doing it at build time vs run-time is a trade off and it doesn't have
> an obvious answer.

I was thinking of putting the names in __init section and generate the BTF
ids on kernel start, but the build time generation seemed more convenient..
let's see the linking times with 'real size' whitelist and we can reconsider

thanks,
jirka

