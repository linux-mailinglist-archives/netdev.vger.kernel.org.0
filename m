Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7214117250
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLIRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:00:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30188 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726335AbfLIRAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575910821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJHLoeY90NAlolHvN1HWnn+e8ua3YFn8GakUKjiul2c=;
        b=O5Wkm/dDKHq+bGTWLbTnxEaC7bdjp8roV06WAtdGLxCj7hSHjpO/nCn9pwTrj1yLpaFfA+
        h928mcPOzLv2fTcziFyUFl8nXry3pl307bP5Us7cvjgADUUztfWaVaGMTKCVelneGaMX2j
        xx8flbGCJYnC4yMJyXvtiuSzSjqq2vU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-_q4LzPVZPza6N7zIgRqMnQ-1; Mon, 09 Dec 2019 12:00:20 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 392C7107ACC5;
        Mon,  9 Dec 2019 17:00:18 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 821FD1001B09;
        Mon,  9 Dec 2019 17:00:09 +0000 (UTC)
Date:   Mon, 9 Dec 2019 18:00:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org,
        magnus.karlsson@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ecree@solarflare.com,
        thoiland@redhat.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
Message-ID: <20191209180008.72c98c53@carbon>
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: _q4LzPVZPza6N7zIgRqMnQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Dec 2019 14:55:16 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The tests were performed using the xdp_rxq_info sample program with
> the following command-line:
>=20
> 1. XDP_DRV:
>   # xdp_rxq_info --dev eth0 --action XDP_DROP
> 2. XDP_SKB:
>   # xdp_rxq_info --dev eth0 -S --action XDP_DROP
> 3. xdp-perf, from selftests/bpf:
>   # test_progs -v -t xdp_perf
>=20
>=20
> Run with mitigations=3Dauto
> -------------------------
>=20
> Baseline:
> 1. 22.0 Mpps
> 2. 3.8 Mpps
> 3. 15 ns
>=20
> Dispatcher:
> 1. 29.4 Mpps (+34%)
> 2. 4.0 Mpps  (+5%)
> 3. 5 ns      (+66%)

Thanks for providing these extra measurement points.  This is good
work.  I just want to remind people that when working at these high
speeds, it is easy to get amazed by a +34% improvement, but we have to
be careful to understand that this is saving approx 10 ns time or
cycles.

In reality cycles or time saved in #2 (3.8 Mpps -> 4.0 Mpps) is larger
(1/3.8-1/4)*1000 =3D 13.15 ns.  Than #1 (22.0 Mpps -> 29.4 Mpps)
(1/22-1/29.4)*1000 =3D 11.44 ns. Test #3 keeps us honest 15 ns -> 5 ns =3D
10 ns.  The 10 ns improvement is a big deal in XDP context, and also
correspond to my own experience with retpoline (approx 12 ns overhead).

To Bj=C3=B8rn, I would appreciate more digits on your Mpps numbers, so I ge=
t
more accuracy on my checks-and-balances I described above.  I suspect
the 3.8 Mpps -> 4.0 Mpps will be closer to the other numbers when we
get more accuracy.

=20
> Dispatcher (full; walk all entries, and fallback):
> 1. 20.4 Mpps (-7%)
> 2. 3.8 Mpps =20
> 3. 18 ns     (-20%)
>=20
> Run with mitigations=3Doff
> ------------------------
>=20
> Baseline:
> 1. 29.6 Mpps
> 2. 4.1 Mpps
> 3. 5 ns
>=20
> Dispatcher:
> 1. 30.7 Mpps (+4%)
> 2. 4.1 Mpps
> 3. 5 ns

While +4% sounds good, but could be measurement noise ;-)

 (1/29.6-1/30.7)*1000 =3D 1.21 ns

As both #3 says 5 ns.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

