Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E8813C754
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAOPVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:21:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729005AbgAOPVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579101689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zTA4sx+gNFDojMXAsEt7yLk4iNXaE/P+y/1BDCCWUNA=;
        b=KyBFHK4tuz2NBRrLscXv585YgCF8DrI2QkjiWDMar0tRgLOsMwlDWkS1yh8EkOANG6ngXN
        HE9S0Yt5btwoRW6zqb+wzU3118KuE8MsAhRxYpwFIu7FhrK56IM9l2CVPiZ7H+bSZ4zTH2
        90GifVtPXeXQYf5wuGzlc/mVVl8l2q8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-YiC0dQjHOfKz--2joi_dgQ-1; Wed, 15 Jan 2020 10:21:25 -0500
X-MC-Unique: YiC0dQjHOfKz--2joi_dgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A3A71136DFF;
        Wed, 15 Jan 2020 15:21:19 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D09DE196AE;
        Wed, 15 Jan 2020 15:21:07 +0000 (UTC)
Date:   Wed, 15 Jan 2020 16:21:05 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 01/10] samples/bpf: Don't try to remove
 user's homedir on clean
Message-ID: <20200115162105.51c2847a@carbon>
In-Reply-To: <157909756981.1192265.5504476164632952530.stgit@toke.dk>
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
        <157909756981.1192265.5504476164632952530.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 15:12:49 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> The 'clean' rule in the samples/bpf Makefile tries to remove backup
> files (ending in ~). However, if no such files exist, it will instead try
> to remove the user's home directory. While the attempt is mostly harmless,
> it does lead to a somewhat scary warning like this:
>=20
> rm: cannot remove '~': Is a directory
>=20
> Fix this by using find instead of shell expansion to locate any actual
> backup files that need to be removed.
>=20
> Fixes: b62a796c109c ("samples/bpf: allow make to be run from samples/bpf/=
 directory")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Kind of scary make clean command!

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


> ---
>  samples/bpf/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 5b89c0370f33..f86d713a17a5 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -254,7 +254,7 @@ all:
> =20
>  clean:
>  	$(MAKE) -C ../../ M=3D$(CURDIR) clean
> -	@rm -f *~
> +	@find $(CURDIR) -type f -name '*~' -delete


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

