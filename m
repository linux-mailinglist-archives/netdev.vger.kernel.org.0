Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C441DFEBB1
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 11:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKPK5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 05:57:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30134 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726794AbfKPK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 05:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573901821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idEemdPMBikcwuqbCnV2wwyYeIIR9t0wn5/qWR2cpWU=;
        b=YK5NNCmr8BnXjA+RbAfLvs1s75duJYcjvVN6MMviKSxDigLD9+j4QjfSdv/e+7yV/ZASJg
        TQioe2bNkpy0gYCXexogmb74GuyG8/AEs/xc1fordC6GTW8VdmB4Q5dPEPgWl4U2xiOU8T
        naEpXwvsxS+XvADSKt8abjAqHiGvZJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-jKyod6iMM0SwVOgU_NKzbw-1; Sat, 16 Nov 2019 05:57:00 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3631800EBA;
        Sat, 16 Nov 2019 10:56:58 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 849AD1019611;
        Sat, 16 Nov 2019 10:56:50 +0000 (UTC)
Date:   Sat, 16 Nov 2019 11:56:49 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, brouer@redhat.com
Subject: Re: [net-next v1 PATCH 2/4] page_pool: add destroy attempts counter
 and rename tracepoint
Message-ID: <20191116115649.25567878@carbon>
In-Reply-To: <87h835kskx.fsf@toke.dk>
References: <157383032789.3173.11648581637167135301.stgit@firesoul>
        <157383036409.3173.14386381829936652438.stgit@firesoul>
        <87h835kskx.fsf@toke.dk>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: jKyod6iMM0SwVOgU_NKzbw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 17:33:18 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > When Jonathan change the page_pool to become responsible to its
> > own shutdown via deferred work queue, then the disconnect_cnt
> > counter was removed from xdp memory model tracepoint.
> >
> > This patch change the page_pool_inflight tracepoint name to
> > page_pool_release, because it reflects the new responsability
> > better.  And it reintroduces a counter that reflect the number of
> > times page_pool_release have been tried.
> >
> > The counter is also used by the code, to only empty the alloc
> > cache once.  With a stuck work queue running every second and
> > counter being 64-bit, it will overrun in approx 584 billion
> > years. For comparison, Earth lifetime expectancy is 7.5 billion
> > years, before the Sun will engulf, and destroy, the Earth. =20
>=20
> I love how you just casually threw that last bit in there; and now I'm
> thinking about under which conditions that would not be enough. Maybe
> someone will put this code on a space probe bound for interstellar
> space, which will escape the death of our solar system only to be
> destined to increment this counter forever in the cold, dead void of
> space?

Like with performance numbers, when ever presenting a number, I always
strive to relate it some something else, as without that the number is
just a number.


> I think that is a risk we can live with, so:
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thx

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

