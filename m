Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A357813CDF6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAOURu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:17:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726085AbgAOURu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579119468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/snfIp/FJ94DduEsrtBIVfyYSYZLZYomQt1YSF8VnQ=;
        b=ROG9T8x7iENn34AvSXdrAHLGJgOSwQPDoZIBQxaeBGQ8P3nnTEPJGSOCPHqLZKBAJBpfXF
        BFDb6hgrzZT0LQoCRFXzSa54BQYX4AkPQdE1Igwnh30JmpqLKdH+e/wJjMWI+WaeZe49+s
        VBGzsswO42MLnPt/5lubglQx6KzSpCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-Z3wj_UrnOCqeUoK5tgffwA-1; Wed, 15 Jan 2020 15:17:47 -0500
X-MC-Unique: Z3wj_UrnOCqeUoK5tgffwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E363E800A02;
        Wed, 15 Jan 2020 20:17:45 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B65A05C219;
        Wed, 15 Jan 2020 20:17:35 +0000 (UTC)
Date:   Wed, 15 Jan 2020 21:17:34 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct
 net_device
Message-ID: <20200115211734.2dfcffd4@carbon>
In-Reply-To: <157893905569.861394.457637639114847149.stgit@toke.dk>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
        <157893905569.861394.457637639114847149.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 19:10:55 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index da9c832fc5c8..030d125c3839 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
[...]
> @@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32=
 flags)
>  out:
>  	bq->count =3D 0;
> =20
> -	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
> -			      sent, drops, bq->dev_rx, dev, err);
> +	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err);

Hmm ... I don't like that we lose the map_id and map_index identifier.
This is part of our troubleshooting interface. =20

>  	bq->dev_rx =3D NULL;
>  	__list_del_clearprev(&bq->flush_node);
>  	return 0;



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

