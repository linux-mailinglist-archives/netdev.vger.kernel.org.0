Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4072510275C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfKSOwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:52:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39492 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726637AbfKSOwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574175120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zK34bLZfC0kMTqcBrBRGMoyuea89Tp/PR9ZllIQfK5s=;
        b=NvExESGXFJMwhTeVvpaIHvduFTU5fKl8suyLmDDOyMCIsc4VJlOYtPf8Uotijy/TkCuN2L
        qH1NNMlIBozSHcVAfwfBh7XYWRz75gjOfdoJkRMIL+wXygpWIETWuDmmH7IkiWKf3EoFEy
        bX5jglk4EDilEA7mAECmmsB/xKil2Aw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-Ur00PPigN-uPprX8Vu_kpQ-1; Tue, 19 Nov 2019 09:51:57 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB66D18BDCE7;
        Tue, 19 Nov 2019 14:51:53 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C6C25F795;
        Tue, 19 Nov 2019 14:51:45 +0000 (UTC)
Date:   Tue, 19 Nov 2019 15:51:43 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync
 in mvneta_rx_refill
Message-ID: <20191119155143.0683f754@carbon>
In-Reply-To: <20191119121911.GC3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
        <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
        <20191119123850.5cd60c0e@carbon>
        <20191119121911.GC3449@localhost.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Ur00PPigN-uPprX8Vu_kpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 14:19:11 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Mon, 18 Nov 2019 15:33:46 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >  =20
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethe=
rnet/marvell/mvneta.c
> > > index f7713c2c68e1..a06d109c9e80 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c =20
> > [...] =20
> > > @@ -2097,8 +2093,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct =
mvneta_rx_queue *rxq,
> > >  =09=09err =3D xdp_do_redirect(pp->dev, xdp, prog);
> > >  =09=09if (err) {
> > >  =09=09=09ret =3D MVNETA_XDP_DROPPED;
> > > -=09=09=09page_pool_recycle_direct(rxq->page_pool,
> > > -=09=09=09=09=09=09 virt_to_head_page(xdp->data));
> > > +=09=09=09__page_pool_put_page(rxq->page_pool,
> > > +=09=09=09=09=09virt_to_head_page(xdp->data),
> > > +=09=09=09=09=09xdp->data_end - xdp->data_hard_start,
> > > +=09=09=09=09=09true);
> > >  =09=09} else {
> > >  =09=09=09ret =3D MVNETA_XDP_REDIR;
> > >  =09=09}
> > > @@ -2107,8 +2105,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct =
mvneta_rx_queue *rxq,
> > >  =09case XDP_TX:
> > >  =09=09ret =3D mvneta_xdp_xmit_back(pp, xdp);
> > >  =09=09if (ret !=3D MVNETA_XDP_TX)
> > > -=09=09=09page_pool_recycle_direct(rxq->page_pool,
> > > -=09=09=09=09=09=09 virt_to_head_page(xdp->data));
> > > +=09=09=09__page_pool_put_page(rxq->page_pool,
> > > +=09=09=09=09=09virt_to_head_page(xdp->data),
> > > +=09=09=09=09=09xdp->data_end - xdp->data_hard_start,
> > > +=09=09=09=09=09true);
> > >  =09=09break;
> > >  =09default:
> > >  =09=09bpf_warn_invalid_xdp_action(act);
> > > @@ -2117,8 +2117,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct =
mvneta_rx_queue *rxq,
> > >  =09=09trace_xdp_exception(pp->dev, prog, act);
> > >  =09=09/* fall through */
> > >  =09case XDP_DROP:
> > > -=09=09page_pool_recycle_direct(rxq->page_pool,
> > > -=09=09=09=09=09 virt_to_head_page(xdp->data));
> > > +=09=09__page_pool_put_page(rxq->page_pool,
> > > +=09=09=09=09     virt_to_head_page(xdp->data),
> > > +=09=09=09=09     xdp->data_end - xdp->data_hard_start,
> > > +=09=09=09=09     true); =20
> >=20
> > This does beg for the question: Should we create an API wrapper for
> > this in the header file?
> >=20
> > But what to name it?
> >=20
> > I know Jonathan doesn't like the "direct" part of the  previous functio=
n
> > name page_pool_recycle_direct.  (I do considered calling this 'napi'
> > instead, as it would be inline with networking use-cases, but it seemed
> > limited if other subsystem end-up using this).
> >=20
> > Does is 'page_pool_put_page_len' sound better?
> >=20
> > But I want also want hide the bool 'allow_direct' in the API name.
> > (As it makes it easier to identify users that uses this from softirq)
> >=20
> > Going for 'page_pool_put_page_len_napi' starts to be come rather long. =
=20
>=20
> What about removing the second 'page'? Something like:
> - page_pool_put_len_napi()

Well, we (unfortunately) already have page_pool_put(), which is used
for refcnt on the page_pool object itself.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

