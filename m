Return-Path: <netdev+bounces-10463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5CD72E9CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46B9428125E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC5B3C0BE;
	Tue, 13 Jun 2023 17:29:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4C63924F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:29:41 +0000 (UTC)
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3961727
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:29:15 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-KpDEogI_MdOgJJfRYSAt4w-1; Tue, 13 Jun 2023 13:28:22 -0400
X-MC-Unique: KpDEogI_MdOgJJfRYSAt4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF64F85A5BA;
	Tue, 13 Jun 2023 17:28:20 +0000 (UTC)
Received: from hog (unknown [10.45.224.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37988C1604C;
	Tue, 13 Jun 2023 17:28:19 +0000 (UTC)
Date: Tue, 13 Jun 2023 19:28:15 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] netdevsim: add dummy macsec offload
Message-ID: <ZIinLxhts7GdknY1@hog>
References: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
 <ZIcRxM/xvozZ+H9c@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZIcRxM/xvozZ+H9c@corigine.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

2023-06-12, 14:38:28 +0200, Simon Horman wrote:
> On Sun, Jun 11, 2023 at 05:45:33PM +0200, Sabrina Dubroca wrote:
>=20
> ...
>=20
> > diff --git a/drivers/net/netdevsim/macsec.c b/drivers/net/netdevsim/mac=
sec.c
> > new file mode 100644
> > index 000000000000..355ba2f313df
> > --- /dev/null
>=20
> ...
>=20
> > +static int nsim_macsec_add_secy(struct macsec_context *ctx)
> > +{
> > +=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
> > +=09int idx;
> > +
> > +=09if (ns->macsec.nsim_secy_count =3D=3D NSIM_MACSEC_MAX_SECY_COUNT)
> > +=09=09return -ENOSPC;
> > +
> > +=09for (idx =3D 0; idx < NSIM_MACSEC_MAX_SECY_COUNT; idx++) {
> > +=09=09if (!ns->macsec.nsim_secy[idx].used)
> > +=09=09=09break;
> > +=09}
> > +
> > +=09if (idx =3D=3D NSIM_MACSEC_MAX_SECY_COUNT)
> > +=09=09netdev_err(ctx->netdev, "%s: nsim_secy_count not full but all Se=
cYs used\n",
> > +=09=09=09   __func__);
>=20
> Hi Sabrina,
>=20
> It seems that if this condition is met, then ns->macsec.nsim_secy will
> overflow below.

Right, thanks. It should never happen but I'll change that to return
-ENOSPC as well.

> > +
> > +=09netdev_dbg(ctx->netdev, "%s: adding new secy with sci %08llx at ind=
ex %d\n",
> > +=09=09   __func__, be64_to_cpu(ctx->secy->sci), idx);
> > +=09ns->macsec.nsim_secy[idx].used =3D true;
> > +=09ns->macsec.nsim_secy[idx].nsim_rxsc_count =3D 0;
> > +=09ns->macsec.nsim_secy[idx].sci =3D ctx->secy->sci;
> > +=09ns->macsec.nsim_secy_count++;
> > +
> > +=09return 0;
> > +}
>=20
> ...
>=20
> > +static int nsim_macsec_add_txsa(struct macsec_context *ctx)
> > +{
> > +=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
> > +=09struct nsim_secy *secy;
> > +=09int idx;
> > +
> > +=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
> > +=09if (idx < 0) {
> > +=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\=
n",
> > +=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
>=20
> Sparse seems pretty unhappy about the type of the argement to be64_to_cpu=
()
> here and elsewhere. I'm unsure what is the best option but one that
> sprang to mind would be conversion helpers, that cast appropriately.
> f.e. sci_to_cpu()

Ok. Since we've never needed that conversion in drivers/net/macsec.c,
I'll drop the helper in here, unless someone objects to that.

> > +=09=09return -ENOENT;
> > +=09}
> > +=09secy =3D &ns->macsec.nsim_secy[idx];
>=20
> As also reported by the kernel test robot, a W=3D1 build complains that s=
ecy
> is set but unused here and in to other places below.

Yes [facepalm]

Thanks for the review.

> > +
> > +=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> > +=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> > +
> > +=09return 0;
> > +}
> > +
> > +static int nsim_macsec_upd_txsa(struct macsec_context *ctx)
> > +{
> > +=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
> > +=09struct nsim_secy *secy;
> > +=09int idx;
> > +
> > +=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
> > +=09if (idx < 0) {
> > +=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\=
n",
> > +=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
> > +=09=09return -ENOENT;
> > +=09}
> > +=09secy =3D &ns->macsec.nsim_secy[idx];
> > +
> > +=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> > +=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> > +
> > +=09return 0;
> > +}
> > +
> > +static int nsim_macsec_del_txsa(struct macsec_context *ctx)
> > +{
> > +=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
> > +=09struct nsim_secy *secy;
> > +=09int idx;
> > +
> > +=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
> > +=09if (idx < 0) {
> > +=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\=
n",
> > +=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
> > +=09=09return -ENOENT;
> > +=09}
> > +=09secy =3D &ns->macsec.nsim_secy[idx];
> > +
> > +=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> > +=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> > +
> > +=09return 0;
> > +}
>=20
> ...

--=20
Sabrina


