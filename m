Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C957300DAD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbhAVU1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:27:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729626AbhAVUZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611347057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XzwvF2fSb3OX9OE+OjVvXhaC5ymgR7sWG/hoQvSQubI=;
        b=ECSDNS8+AlYcVNdvA1uI5qNQ8hJSrr3AywAcwnAxyHLfgattAzlLfDA7ZpzPePKmqknzjN
        1DdjaHFfApZSk26r9WI4u75G8xetuYEp0UxslWXJ339jerDBhQri3QUELRv/TNpu0vuyI5
        TZUSxwOOL5GdkeH3YYgOiZh7M674Uoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-fngIOAcvO0mKOGlzcTs_Xg-1; Fri, 22 Jan 2021 15:24:15 -0500
X-MC-Unique: fngIOAcvO0mKOGlzcTs_Xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 930A48030A3;
        Fri, 22 Jan 2021 20:24:13 +0000 (UTC)
Received: from krava (unknown [10.40.192.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4073D19C44;
        Fri, 22 Jan 2021 20:24:04 +0000 (UTC)
Date:   Fri, 22 Jan 2021 21:24:03 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Yulia Kopkova <ykopkova@redhat.com>
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210122202403.GC35850@krava>
References: <20210122163920.59177-1-jolsa@kernel.org>
 <20210122163920.59177-3-jolsa@kernel.org>
 <20210122195228.GB617095@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122195228.GB617095@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 04:52:28PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 22, 2021 at 05:39:20PM +0100, Jiri Olsa escreveu:
> > For very large ELF objects (with many sections), we could
> > get special value SHN_XINDEX (65535) for symbol's st_shndx.
> > 
> > This patch is adding code to detect the optional extended
> > section index table and use it to resolve symbol's section
> > index.
> > 
> > Adding elf_symtab__for_each_symbol_index macro that returns
> > symbol's section index and usign it in collect functions.
> 
> From a quick look it seems you addressed Andrii's review comments,
> right?

yep, it's described in the cover email

> 
> I've merged it locally, but would like to have some detailed set of
> steps on how to test this, so that I can add it to a "Committer testing"
> section in the cset commit log and probably add it to my local set of
> regression tests.

sorry I forgot to mention that:

The test was to run pahole on kernel compiled with:
  make KCFLAGS="-ffunction-sections -fdata-sections" -j$(nproc) vmlinux

and ensure FUNC records are generated and match normal
build (without above KCFLAGS)

Also bpf selftest passed.


> 
> Who originally reported this? Joe? Also can someone provide a Tested-by:
> in addition to mine when I get this detailed set of steps to test?

oops, it was reported by Yulia Kopkova (just cc-ed)

Joe tested the v2 of the patchset, I'll make a dwarves scratch
build with v3 and let them test it

jirka

