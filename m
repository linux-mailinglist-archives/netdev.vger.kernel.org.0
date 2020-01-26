Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78406149D01
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAZV2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:28:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726294AbgAZV2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 16:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580074099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2dXaPIqCZ4DtJ5VPelnd8VdgkoxeuUaCO1gebA4wYE=;
        b=XMepY68Vo7YYgXcPZNyvl5mGzSzcyQn0f9+XIdDtb9JUc4b3GAuK5SBg/ULORjSIkei1kA
        qAosEXB5HsVXaIJWPcDetsslblux5oZ8pHq+fVkBgWlthgl2tA3XU2ACOaWDgfcs+XBc2q
        W7ex8mCrWvb33hpQn+W/yJ6RxPG4G6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-pWXYctnsNCu4ptAHRnKNcA-1; Sun, 26 Jan 2020 16:28:17 -0500
X-MC-Unique: pWXYctnsNCu4ptAHRnKNcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F1531005512;
        Sun, 26 Jan 2020 21:28:15 +0000 (UTC)
Received: from carbon (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D33F8E613;
        Sun, 26 Jan 2020 21:28:08 +0000 (UTC)
Date:   Sun, 26 Jan 2020 22:28:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, bjorn.topel@intel.com,
        songliubraving@fb.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/3] bpf: xdp, update devmap comments to
 reflect napi/rcu usage
Message-ID: <20200126222807.3f8e2268@carbon>
In-Reply-To: <1580011133-17784-2-git-send-email-john.fastabend@gmail.com>
References: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
        <1580011133-17784-2-git-send-email-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 19:58:51 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> Now that we rely on synchronize_rcu and call_rcu waiting to
> exit perempt-disable regions (NAPI) lets update the comments
> to reflect this.
>=20
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/devmap.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index da9c832..f0bf525 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -193,10 +193,12 @@ static void dev_map_free(struct bpf_map *map)
> =20
>  	/* At this point bpf_prog->aux->refcnt =3D=3D 0 and this map->refcnt =
=3D=3D 0,
>  	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding critical sections in
> -	 * these programs to complete. The rcu critical section only guarantees
> -	 * no further reads against netdev_map. It does __not__ ensure pending
> -	 * flush operations (if any) are complete.
> +	 * disconnected from events. The following synchronize_rcu() guarantees
> +	 * both rcu read critical sections complete and waits for
> +	 * preempt-disable regions (NAPI being the relavent context here) so we
                                                   ^^^^^^^^
Spelling: relevant

I would hate to block the patch this close to the release deadline, so
maybe DaveM can just adjust this before applying?

> +	 * are certain there will be no further reads against the netdev_map and
> +	 * all flush operations are complete. Flush operations can only be done
> +	 * from NAPI context for this reason.
>  	 */
> =20
>  	spin_lock(&dev_map_lock);
> @@ -498,12 +500,11 @@ static int dev_map_delete_elem(struct bpf_map *map,=
 void *key)
>  		return -EINVAL;
> =20
>  	/* Use call_rcu() here to ensure any rcu critical sections have
> -	 * completed, but this does not guarantee a flush has happened
> -	 * yet. Because driver side rcu_read_lock/unlock only protects the
> -	 * running XDP program. However, for pending flush operations the
> -	 * dev and ctx are stored in another per cpu map. And additionally,
> -	 * the driver tear down ensures all soft irqs are complete before
> -	 * removing the net device in the case of dev_put equals zero.
> +	 * completed as well as any flush operations because call_rcu
> +	 * will wait for preempt-disable region to complete, NAPI in this
> +	 * context.  And additionally, the driver tear down ensures all
> +	 * soft irqs are complete before removing the net device in the
> +	 * case of dev_put equals zero.
>  	 */
>  	old_dev =3D xchg(&dtab->netdev_map[k], NULL);
>  	if (old_dev)



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

