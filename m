Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD341185CC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfLJLF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:05:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727259AbfLJLFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:05:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575975924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Khwyb+GgQklbY0sQzo2bnVinuaUK0YwpqCimn/St+jI=;
        b=Z5/qvlYIvr3ENznfZBW5nnlaPolLqfKfWaxXW8gg6LoiENy1rYLdUfPq//cQztvEDnThUv
        sQz2qpZcTeKmXJBWw2IEnw1lyo6yk5sKJAwX7NBkfnr6dQgKE0r6nouwgJk7CMaV33ok7I
        7KMvdy5E69Zb94/MVfbRMqMSFYGtCwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-UrLwHmnNOBOcidDg0GHOAg-1; Tue, 10 Dec 2019 06:05:21 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94F831007273;
        Tue, 10 Dec 2019 11:05:19 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 137C960BE0;
        Tue, 10 Dec 2019 11:05:11 +0000 (UTC)
Date:   Tue, 10 Dec 2019 12:05:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v3 5/6] selftests: bpf: add xdp_perf test
Message-ID: <20191210120450.3375fc4a@carbon>
In-Reply-To: <20191209135522.16576-6-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
        <20191209135522.16576-6-bjorn.topel@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: UrLwHmnNOBOcidDg0GHOAg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Dec 2019 14:55:21 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> The xdp_perf is a dummy XDP test, only used to measure the the cost of
> jumping into a XDP program.

I really like this idea of performance measuring XDP-core in isolation.
This is the ultimate zoom-in micro-benchmarking.  I see a use-case for
this, where I will measure the XDP-core first, and then run same XDP
prog (e.g. XDP_DROP) on a NIC driver, then I can deduct/isolate the
driver-code and hardware overhead.  We/I can also use it to optimize
e.g. REDIRECT code-core (although redir might not actually work).

IMHO it would be valuable to have bpf_prog_load() also measure the
perf-HW counters for 'cycles' and 'instructions', as in your case the
performance optimization was to improve the instructions-per-cycle
(which you showed via perf stat in cover letter).


If you send a V4 please describe how to use this prog to measure the
cost, as you describe in cover letter.

from selftests/bpf run:
 # test_progs -v -t xdp_perf

(This is a nitpick, so only do this if something request a V4)


> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_perf.c       | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_perf.c b/tools/te=
sting/selftests/bpf/prog_tests/xdp_perf.c
> new file mode 100644
> index 000000000000..7185bee16fe4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +void test_xdp_perf(void)
> +{
> +=09const char *file =3D "./xdp_dummy.o";
> +=09__u32 duration, retval, size;
> +=09struct bpf_object *obj;
> +=09char in[128], out[128];
> +=09int err, prog_fd;
> +
> +=09err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
> +=09if (CHECK_FAIL(err))
> +=09=09return;
> +
> +=09err =3D bpf_prog_test_run(prog_fd, 1000000, &in[0], 128,
> +=09=09=09=09out, &size, &retval, &duration);
> +
> +=09CHECK(err || retval !=3D XDP_PASS || size !=3D 128,
> +=09      "xdp-perf",
> +=09      "err %d errno %d retval %d size %d\n",
> +=09      err, errno, retval, size);
> +
> +=09bpf_object__close(obj);
> +}



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

