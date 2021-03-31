Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30234FBF7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhCaIxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234523AbhCaIxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617180801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQ2n3EyanSF3qXDhAsFkDmrzVT/a6o5xFDgb/T/cMsM=;
        b=IckUOL6SYkNPOnsjVcRSCwDfttTFQkR6jxgcxQhPln80Zlbt/KT/X9eFVthgc6KQlJVmLH
        72AaCx+nJ0GxRWQ9KxnpJWVJXLmVnWwp8BKtE9H0d5MULmEv2evduEJxjTlFMuNcqteTTu
        eS2mLEVus71+l7czQPD0YQh5zz6KCyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-JDmegdEANPq-fw31zqM9og-1; Wed, 31 Mar 2021 04:53:19 -0400
X-MC-Unique: JDmegdEANPq-fw31zqM9og-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6897108BD07;
        Wed, 31 Mar 2021 08:53:17 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 583AB179E6;
        Wed, 31 Mar 2021 08:53:08 +0000 (UTC)
Date:   Wed, 31 Mar 2021 10:53:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH net 1/1] xdp: fix xdp_return_frame() kernel BUG throw
 for page_pool memory model
Message-ID: <20210331105306.5c7f09a6@carbon>
In-Reply-To: <87lfa6rkpn.fsf@toke.dk>
References: <20210329080039.32753-1-boon.leong.ong@intel.com>
        <20210329170209.6db77c3d@carbon>
        <87lfa6rkpn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ong,

Patch is in "Changes Requested".
Thus, please send a V2 patch with suggested code changes below.

--Jesper


On Mon, 29 Mar 2021 18:25:08 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Mon, 29 Mar 2021 16:00:39 +0800
> > Ong Boon Leong <boon.leong.ong@intel.com> wrote:
> > =20
> >> xdp_return_frame() may be called outside of NAPI context to return
> >> xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
> >> napi_direct =3D false. For page_pool memory model, __xdp_return() calls
> >> xdp_return_frame_no_direct() unconditionally and below false negative
> >> kernel BUG throw happened under preempt-rt build:
> >>=20
> >> [  430.450355] BUG: using smp_processor_id() in preemptible [00000000]=
 code: modprobe/3884
> >> [  430.451678] caller is __xdp_return+0x1ff/0x2e0
> >> [  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E=
     5.12.0-rc2+ #45
> >>=20
> >> So, this patch fixes the issue by adding "if (napi_direct)" condition
> >> to skip calling xdp_return_frame_no_direct() if napi_direct =3D false.
> >>=20
> >> Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_re=
turn_frame")
> >> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> >> --- =20
> >
> > This looks correct to me.
> >
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >
> > =20
> >>  net/core/xdp.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/net/core/xdp.c b/net/core/xdp.c
> >> index 05354976c1fc..4eaa28972af2 100644
> >> --- a/net/core/xdp.c
> >> +++ b/net/core/xdp.c
> >> @@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_me=
m_info *mem, bool napi_direct,
> >>  		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
> >>  		xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> >>  		page =3D virt_to_head_page(data);
> >> -		napi_direct &=3D !xdp_return_frame_no_direct();
> >> +		if (napi_direct)
> >> +			napi_direct &=3D !xdp_return_frame_no_direct(); =20
> >
> > if (napi_direct && xdp_return_frame_no_direct())
> > 	napi_direct =3D false;
> >
> > I wonder if this code would be easier to understand? =20
>=20
> Yes, IMO it would! :)
>=20
> -Toke
>=20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

