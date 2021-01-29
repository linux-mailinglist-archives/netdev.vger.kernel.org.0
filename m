Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0A308C28
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhA2SIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:08:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232552AbhA2SHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611943582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9wwVs7bE4eUGywhu7/y58AMJb7GSg2J1O0tKjzQHCI=;
        b=cJkvcNrYX3NBrE5E8WQEfobIeayLBvLe2+F87OrwQQEyDiaRaHraUYfs4awamt5kh482Fr
        e1lYvceeFlHEyPV4mJfxd5pl7opgUEEjTNlnFc+miY3UVfFQCbRJaq4TwJv/skyiJPMtyN
        /A2eeIo2yoB7LBBQdpmoXQUMIzwVoW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104--BI2lw_SMW2OCKQ8iUs3KQ-1; Fri, 29 Jan 2021 13:06:18 -0500
X-MC-Unique: -BI2lw_SMW2OCKQ8iUs3KQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5223580DDE1;
        Fri, 29 Jan 2021 18:06:16 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96AAA5C1B4;
        Fri, 29 Jan 2021 18:06:09 +0000 (UTC)
Date:   Fri, 29 Jan 2021 19:06:06 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [RFC PATCH bpf-next] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
Message-ID: <20210129190606.33c697cf@carbon>
In-Reply-To: <CAJ+HfNiFtRd-KKMB1t3Mi3MZ=C+u5TTM5YFnzJFfR4Ruzc7c9Q@mail.gmail.com>
References: <20210129153215.190888-1-bjorn.topel@gmail.com>
        <CAJ+HfNiFtRd-KKMB1t3Mi3MZ=C+u5TTM5YFnzJFfR4Ruzc7c9Q@mail.gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 16:35:47 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On Fri, 29 Jan 2021 at 16:32, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
> >
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > =20
> [...]
> >
> > For AF_XDP rxdrop this yields +600Mpps. I'll do CPU/DEVMAP
> > measurements for the patch proper.
> > =20
>=20
> Kpps, not Mpps. :-P

+600Kpps from 24Mpps to 24.6Mpps I assume.  This corresponds to approx
1 ns ((1/24-1/24.6)*1000 =3D 1.01626 ns).

This also correlate with saving one function call, which is basically
what the patch does.

Fresh measurement "Intel(R) Xeon(R) CPU E5-1650 v4 @ 3.60GHz" with [1]:
 time_bench: Type:funcion_call_cost Per elem: 3 cycles(tsc) 1.053 ns
 time_bench: Type:func_ptr_call_cost Per elem: 4 cycles(tsc) 1.317 ns

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib=
/time_bench_sample.c
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

