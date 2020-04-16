Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD591AB8CE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437013AbgDPG4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:56:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436660AbgDPGzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587020150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8d5KTj5+PK359cjQwUOIl5jgLBU5QMldhnLB2LHJrHk=;
        b=BN6OgyaLQro1TXXdsy2RQ2UworIx5dplr73MpgZ+88DkI5p4xG0wrJy9Dv9uGIU9PgnOcc
        Aj22k6BbJcjTFBtVbCFqCq38/Mv6/hK2PBS+OBITtu0nI17BuVWYiY968ayMhJA7kybc7c
        43yekk3ZwFBR4F1SvnKrXy8Jba/r+CE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-IybPFKrFMPC7dSK7pmlIJQ-1; Thu, 16 Apr 2020 02:55:47 -0400
X-MC-Unique: IybPFKrFMPC7dSK7pmlIJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 366DA107ACCC;
        Thu, 16 Apr 2020 06:55:46 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70F8B18A85;
        Thu, 16 Apr 2020 06:55:38 +0000 (UTC)
Date:   Thu, 16 Apr 2020 08:55:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf] cpumap: Avoid warning when
 CONFIG_DEBUG_PER_CPU_MAPS is enabled
Message-ID: <20200416085537.65dde42e@carbon>
In-Reply-To: <20200415140151.439943-1-toke@redhat.com>
References: <20200415140151.439943-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020 16:01:51 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap code
> can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. Th=
is
> happens because in this configuration, NR_CPUS can be larger than
> nr_cpumask_bits, so the initial check in cpu_map_alloc() is not sufficient
> to guard against hitting the warning in cpumask_check().
>=20
> Fix this by using the nr_cpumask_bits variable in the map creation code
> instead of the NR_CPUS constant.

Shouldn't you use 'nr_cpu_ids' instead of 'nr_cpumask_bits' ?

Else this will still fail on systems with CONFIG_CPUMASK_OFFSTACK=3Dn.

>=20
> Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CP=
UMAP")
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/cpumap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 70f71b154fa5..23902afb3bba 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -99,8 +99,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *at=
tr)
> =20
>  	bpf_map_init_from_attr(&cmap->map, attr);
> =20
> -	/* Pre-limit array size based on NR_CPUS, not final CPU check */
> -	if (cmap->map.max_entries > NR_CPUS) {
> +	/* Pre-limit array size based on nr_cpumask_bits, not final CPU check */
> +	if (cmap->map.max_entries > nr_cpumask_bits) {

Shouldn't you use 'nr_cpu_ids' instead of 'nr_cpumask_bits' ?

>  		err =3D -E2BIG;
>  		goto free_cmap;
>  	}



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

