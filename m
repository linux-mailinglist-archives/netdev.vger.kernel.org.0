Return-Path: <netdev+bounces-9617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 197CB72A055
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21BB281776
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36D119BD3;
	Fri,  9 Jun 2023 16:41:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F0717ADE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:41:36 +0000 (UTC)
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E23A9E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:41:09 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-o6MR5zBrNdeppXYYwN4WJQ-1; Fri, 09 Jun 2023 12:37:48 -0400
X-MC-Unique: o6MR5zBrNdeppXYYwN4WJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDA923C13516;
	Fri,  9 Jun 2023 16:37:31 +0000 (UTC)
Received: from hog (unknown [10.45.224.200])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F31A40CFD00;
	Fri,  9 Jun 2023 16:37:29 +0000 (UTC)
Date: Fri, 9 Jun 2023 18:37:28 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net/tls: handle MSG_EOR for tls_sw TX flow
Message-ID: <ZINVSBkUyBMW_ZeB@hog>
References: <20230609125153.3919-1-hare@suse.de>
 <20230609125153.3919-2-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230609125153.3919-2-hare@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

Hi Hannes,

2023-06-09, 14:51:50 +0200, Hannes Reinecke wrote:
> tls_sw_sendmsg() / tls_do_sw_sendpage() already handles
> MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails out on MSG_EOR.
> But seeing that MSG_EOR is basically the opposite of
> MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
> MSG_EOR by treating it as the negation of MSG_MORE.
>=20
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  net/tls/tls_sw.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 635b8bf6b937..be8e0459d403 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -953,9 +953,12 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *m=
sg, size_t size)
>  =09int pending;
> =20
>  =09if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> -=09=09=09       MSG_CMSG_COMPAT))
> +=09=09=09       MSG_EOR | MSG_CMSG_COMPAT))
>  =09=09return -EOPNOTSUPP;
> =20
> +=09if (msg->msg_flags & MSG_EOR)
> +=09=09eor =3D true;

Is MSG_EOR supposed to be incompatible with MSG_MORE, or is it
supposed to cancel it? (ie: MSG_MORE | MSG_EOR is invalid, or
MSG_MORE | MSG_EOR behaves like MSG_EOR) The current code already
behaves as if _EOR was passed as long as MSG_MORE isn't passed, so
_EOR is only needed to cancel out _MORE (or in your case, because
NVMe-over-TLS sets it).

If _EOR and _MORE (or MSG_SENDPAGE_NOTLAST below) are supposed to be
incompatible, we should return an error when they're both set. If we
accept both flags being set at the same time, I think we should
document the expected behavior ("_EOR overrides _MORE/_NOTLAST") and
add specific selftests to avoid regressions.

--=20
Sabrina


