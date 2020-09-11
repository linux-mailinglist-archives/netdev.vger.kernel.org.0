Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD4B265973
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgIKGiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgIKGiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 02:38:06 -0400
Received: from coco.lan (ip5f5ad5a5.dynamic.kabel-deutschland.de [95.90.213.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E9A221EB;
        Fri, 11 Sep 2020 06:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599806285;
        bh=7xtKkhTMP8zlP2NRtWtUkisBFNL9KG8dstYJftmDzeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=piTeFRX5NswG5r1l+/c/NAUXYkn9kvb1bSJE+If98KzLYFBzqGLfl2D/2DJ6B0YwC
         A2TSlr9BdQhdp2FqNFDKhkCBu6196HySyNp5fkKfnm254dQqk6pSIk8BKXVWX8WTbj
         M/XebDfTVTAXOWq9PAjBoH3H4JRDRjUoIrKSIr2o=
Date:   Fri, 11 Sep 2020 08:38:00 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH bpf] docs/bpf: fix ringbuf documentation
Message-ID: <20200911083800.2b03fac4@coco.lan>
In-Reply-To: <20200910225245.2896991-1-andriin@fb.com>
References: <20200910225245.2896991-1-andriin@fb.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

Em Thu, 10 Sep 2020 15:52:45 -0700
Andrii Nakryiko <andriin@fb.com> escreveu:

> Remove link to litmus tests that didn't make it to upstream. Fix ringbuf
> benchmark link.

That work, thanks!

> I wasn't able to test this with `make htmldocs`, unfortunately, because of
> Sphinx dependencies. 

Weird. "make htmldocs" should be calling ./scripts/sphinx-pre-install, which
tells what's needed to install Sphinx:

	$ make htmldocs
	Documentation/Makefile:30: The 'sphinx-build' command was not found. Make sure you have Sphinx installed and in PATH, or set the SPHINXBUILD make variable to point to the full path of the 'sphinx-build' executable.

	Detected OS: Ubuntu 19.10.
	Warning: It is recommended at least Sphinx version 1.7.9.
	         If you want pdf, you need at least 2.4.4.
	Note: It is recommended at least Sphinx version 2.4.4 if you need PDF support.
		/usr/bin/python3 -m venv sphinx_2.4.4
		. sphinx_2.4.4/bin/activate
		pip install -r ./Documentation/sphinx/requirements.txt

By default, it recommends installing LaTeX, as this is needed by some
books that use LaTeX markup for formulas (and also to make pdfdocs).
That would require installing lots of things. You can get a lightweight
dependency chain by calling:

	./scripts/sphinx-pre-install --no-pdf

Please let me know if you find any troubles with that.

> But bench_ringbufs.c path is certainly correct now.

It still produces this warning for bench_ringbufs.c:

	/devel/v4l/docs/Documentation/bpf/ringbuf.rst:194: WARNING: Unknown target name: "bench_ringbufs.c".

That's said, I'm not sure if it is possible to do a cross-reference
like this:

	tools/testing/selftests/bpf/benchs/bench_ringbufs.c_

The thing is that bench_ringbufs.c won't be at the doc output
directory (Documentation/output, by default), so Sphinx won't
be able to solve the reference. 

Maybe it could still be possible to use that without including
the file at the documentation output dir, but with some extension like:

	https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html

Such extension creates "external" cross-references to some website.

There were some inconclusive discussions about using it at linux-doc ML,
but nobody so far tested doing it or sent any patches moving toward such
direction.

Another possibility would be to include bench_ringbufs.c inside
the documentation book, using kernel-include::, literalinclude:: or
include:: tags.

Se, for example:

	Documentation/kbuild/issues.rst
	Documentation/netlabel/draft_ietf.rst

Regards,
Mauro

> 
> Reported-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Fixes: 97abb2b39682 ("docs/bpf: Add BPF ring buffer design notes")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  Documentation/bpf/ringbuf.rst | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/Documentation/bpf/ringbuf.rst b/Documentation/bpf/ringbuf.rst
> index 75f943f0009d..4d4f3bcb1477 100644
> --- a/Documentation/bpf/ringbuf.rst
> +++ b/Documentation/bpf/ringbuf.rst
> @@ -182,9 +182,6 @@ in the order of reservations, but only after all previous records where
>  already committed. It is thus possible for slow producers to temporarily hold
>  off submitted records, that were reserved later.
>  
> -Reservation/commit/consumer protocol is verified by litmus tests in
> -Documentation/litmus_tests/bpf-rb/_.
> -
>  One interesting implementation bit, that significantly simplifies (and thus
>  speeds up as well) implementation of both producers and consumers is how data
>  area is mapped twice contiguously back-to-back in the virtual memory. This
> @@ -200,7 +197,7 @@ a self-pacing notifications of new data being availability.
>  being available after commit only if consumer has already caught up right up to
>  the record being committed. If not, consumer still has to catch up and thus
>  will see new data anyways without needing an extra poll notification.
> -Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbuf.c_) show that
> +Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c_) show that
>  this allows to achieve a very high throughput without having to resort to
>  tricks like "notify only every Nth sample", which are necessary with perf
>  buffer. For extreme cases, when BPF program wants more manual control of



Thanks,
Mauro
