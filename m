Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6BA10D248
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfK2INM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:13:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21605 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726791AbfK2INL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575015190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ifxEBGz5Za3713/6wxZ5x5c+04Mqb6wSjHpoWmP22g=;
        b=g7Wj6BBIoFQeyH3YewWFPa3nMMEKO14Z2kuZDOel3ZyxHOBjFZNggnw7J5uVbcfnY13tVJ
        4C4c2ICH0Dz6NfRGjqS5pXlns3Gb/2Dyb57Os4kukOzwxzX4qaGhPyC6i1cp9wlrEuGNQi
        ShfGVKoOC1rtlkEH1WNleR1e3QkpW1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-jxWKkpjJN2aIP2zyAxxTJg-1; Fri, 29 Nov 2019 03:13:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2734C8024E7;
        Fri, 29 Nov 2019 08:13:04 +0000 (UTC)
Received: from krava (ovpn-205-32.brq.redhat.com [10.40.205.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90C7461F37;
        Fri, 29 Nov 2019 08:12:52 +0000 (UTC)
Date:   Fri, 29 Nov 2019 09:12:51 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191129081251.GA14169@krava>
References: <20191128145316.1044912-1-toke@redhat.com>
 <20191128160712.1048793-1-toke@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191128160712.1048793-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jxWKkpjJN2aIP2zyAxxTJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 05:07:12PM +0100, Toke H=F8iland-J=F8rgensen wrote:

SNIP

>  ifeq ($(srctree),)
>  srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
> @@ -63,6 +72,19 @@ RM ?=3D rm -f
>  FEATURE_USER =3D .bpftool
>  FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib
>  FEATURE_DISPLAY =3D libbfd disassembler-four-args zlib
> +ifdef LIBBPF_DYNAMIC
> +  FEATURE_TESTS   +=3D libbpf
> +  FEATURE_DISPLAY +=3D libbpf
> +
> +  # for linking with debug library run:
> +  # make LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/opt/libbpf
> +  ifdef LIBBPF_DIR
> +    LIBBPF_CFLAGS  :=3D -I$(LIBBPF_DIR)/include
> +    LIBBPF_LDFLAGS :=3D -L$(LIBBPF_DIR)/$(libdir_relative)
> +    FEATURE_CHECK_CFLAGS-libbpf  :=3D $(LIBBPF_CFLAGS)
> +    FEATURE_CHECK_LDFLAGS-libbpf :=3D $(LIBBPF_LDFLAGS)
> +  endif
> +endif
> =20
>  check_feat :=3D 1
>  NON_CHECK_FEAT_TARGETS :=3D clean uninstall doc doc-clean doc-install do=
c-uninstall
> @@ -88,6 +110,18 @@ ifeq ($(feature-reallocarray), 0)
>  CFLAGS +=3D -DCOMPAT_NEED_REALLOCARRAY
>  endif
> =20
> +ifdef LIBBPF_DYNAMIC
> +  ifeq ($(feature-libbpf), 1)
> +    # bpftool uses non-exported functions from libbpf, so just add the d=
ynamic
> +    # version of libbpf and let the linker figure it out
> +    LIBS    :=3D -lbpf $(LIBS)

nice, so linker will pick up the missing symbols and we
don't need to check on particular libbpf version then

thanks,
jirka

> +    CFLAGS  +=3D $(LIBBPF_CFLAGS)
> +    LDFLAGS +=3D $(LIBBPF_LDFLAGS)
> +  else
> +    dummy :=3D $(error Error: No libbpf devel library found, please inst=
all libbpf-devel or libbpf-dev.)
> +  endif
> +endif
> +
>  include $(wildcard $(OUTPUT)*.d)
> =20
>  all: $(OUTPUT)bpftool
> --=20
> 2.24.0
>=20

