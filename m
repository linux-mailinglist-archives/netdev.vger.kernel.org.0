Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222503211D1
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhBVIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:12:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhBVIMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613981465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ymspKXx+r61BVVhTTBoqv6EmxdYAJFHI1OaKWh9Z7k=;
        b=Dq2cpF6rqpbYnnOPnC/Q9LBjE7WBeuUr/hQ9igptVqIigpUBh/g9HJXFUL6YOQma9oQppd
        naZNLj5sZisaMRP+nl3EDH6plXcKmymzjjr4eCKjrfwDNZ5Dlb2ZpI7TzyahdIaZmSk3nK
        U27gecKohkhlLsBcMSixcr3UdraTMs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-kDrCP_yXOOWV9r9kj8cN6A-1; Mon, 22 Feb 2021 03:11:01 -0500
X-MC-Unique: kDrCP_yXOOWV9r9kj8cN6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AC09801978;
        Mon, 22 Feb 2021 08:10:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BCA560C04;
        Mon, 22 Feb 2021 08:10:48 +0000 (UTC)
Date:   Mon, 22 Feb 2021 09:10:47 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v3 2/2] bpf, xdp: restructure redirect actions
Message-ID: <20210222091047.39b4644c@carbon>
In-Reply-To: <20210221200954.164125-3-bjorn.topel@gmail.com>
References: <20210221200954.164125-1-bjorn.topel@gmail.com>
        <20210221200954.164125-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Feb 2021 21:09:54 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> The XDP_REDIRECT implementations for maps and non-maps are fairly
> similar, but obviously need to take different code paths depending on
> if the target is using a map or not. Today, the redirect targets for
> XDP either uses a map, or is based on ifindex.
>=20
> Here, an explicit redirect type is added to bpf_redirect_info, instead
> of the actual map. Redirect type, map item/ifindex, and the map_id (if
> any) is passed to xdp_do_redirect().
>=20
> In addition to making the code easier to follow, using an explicit
> type in bpf_redirect_info has a slight positive performance impact by
> avoiding a pointer indirection for the map type lookup, and instead
> use the cacheline for bpf_redirect_info.
>=20
> Since the actual map is not passed via bpf_redirect_info anymore, the
> map lookup is only done in the BPF helper. This means that the
> bpf_clear_redirect_map() function can be removed. The actual map item
> is RCU protected.
>=20
> The bpf_redirect_info flags member is not used by XDP, and not
> read/written any more. The map member is only written to when
> required/used, and not unconditionally.
>=20
> v1->v2 : Removed warning when CONFIG_BPF_SYSCALL was not set. (lkp)
>        : Cleaned up case-clause in xdp_do_generic_redirect_map(). (Toke)
> rfc->v1: Use map_id, and remove bpf_clear_redirect_map(). (Toke)
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/bpf.h        |   1 +
>  include/linux/filter.h     |  11 ++-
>  include/trace/events/xdp.h |  66 +++++++++------
>  kernel/bpf/cpumap.c        |   1 -
>  kernel/bpf/devmap.c        |   1 -
>  net/core/filter.c          | 165 ++++++++++++++++---------------------
>  net/xdp/xskmap.c           |   1 -
>  7 files changed, 122 insertions(+), 124 deletions(-)

I like it! :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

