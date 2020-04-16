Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B0A1ABC4C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502780AbgDPJKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:10:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502776AbgDPIok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587026631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yfqMRGU6yHVFX9cCKgS+CRJdfA4wWPecTL3stc+FBg=;
        b=VqqrFgrWkIKxqwAdxD9hjSGJXKRhwmRVC4utwx8SvNDFgOpna0gbs0HQXsR7z5PGh7R5Ua
        dBIITFIeyO+YR/07oN4djHubleTB7TRjTFnUu4vmLD6mmC99s26T2Os160DhYCTSWk9KgY
        JYMEHgIO39JXXh0fSJ5deq/7z1+vtZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-LE1fw699Mvqmw4O02XVxAA-1; Thu, 16 Apr 2020 04:43:49 -0400
X-MC-Unique: LE1fw699Mvqmw4O02XVxAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EC5C192D786;
        Thu, 16 Apr 2020 08:43:48 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 383C494B40;
        Thu, 16 Apr 2020 08:43:40 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:43:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf v2] cpumap: Avoid warning when
 CONFIG_DEBUG_PER_CPU_MAPS is enabled
Message-ID: <20200416104339.3a8b85c4@carbon>
In-Reply-To: <20200416083120.453718-1-toke@redhat.com>
References: <20200416083120.453718-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020 10:31:20 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap code
> can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. Th=
is
> happens because in this configuration, NR_CPUS can be larger than
> nr_cpumask_bits, so the initial check in cpu_map_alloc() is not sufficient
> to guard against hitting the warning in cpumask_check().
>=20
> Fix this by explicitly checking the supplied key against the
> nr_cpumask_bits variable before calling cpu_possible().
>=20
> Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CP=
UMAP")
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> v2:
>   - Move check to cpu_map_update_elem() to not affect max size of map
>=20
>  kernel/bpf/cpumap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 70f71b154fa5..3fe0b006d2d2 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -469,7 +469,7 @@ static int cpu_map_update_elem(struct bpf_map *map, v=
oid *key, void *value,
>  		return -EOVERFLOW;
> =20
>  	/* Make sure CPU is a valid possible cpu */
> -	if (!cpu_possible(key_cpu))
> +	if (key_cpu >=3D nr_cpumask_bits || !cpu_possible(key_cpu))

Toke use 'nr_cpumask_bits' here, because cpumask_check() also uses it,
which is the warning we are trying to avoid.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

