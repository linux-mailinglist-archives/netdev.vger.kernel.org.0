Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8EFFD04E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKNV2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:28:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50456 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbfKNV2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573766883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YXgw6O2agEnfzZAy/AT+kr3Qxl6Aqsnont9EVvAp0VI=;
        b=BX4ZI57v5D9W4iohL46I5PmCDRV5q9rxjtZ0LAQCaaE3+CYtzE/jkB8ObhtxWLExZyI7RB
        5ssvUyC50KJ4MnEQhJk/wg/AJmoQkMzYdH/JPr+Sme/MxIrFv8QY5f+KXiDQjbq8LzMdwk
        sY+KMFjvHxMAiMblajmrBJJBcA5bMT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-i0-lMuDCO_GSrGJv2ideDw-1; Thu, 14 Nov 2019 16:28:01 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79674800C77;
        Thu, 14 Nov 2019 21:28:00 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 503F1101E814;
        Thu, 14 Nov 2019 21:27:55 +0000 (UTC)
Date:   Thu, 14 Nov 2019 22:27:53 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>, <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [net-next PATCH v2 1/2] page_pool: do not release pool until
 inflight == 0.
Message-ID: <20191114222753.03e50613@carbon>
In-Reply-To: <20191114163715.4184099-2-jonathan.lemon@gmail.com>
References: <20191114163715.4184099-1-jonathan.lemon@gmail.com>
        <20191114163715.4184099-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: i0-lMuDCO_GSrGJv2ideDw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 08:37:14 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> The page pool keeps track of the number of pages in flight, and
> it isn't safe to remove the pool until all pages are returned.
>=20
> Disallow removing the pool until all pages are back, so the pool
> is always available for page producers.

I like this patch.
=20
> Make the page pool responsible for its own delayed destruction
> instead of relying on XDP, so the page pool can be used without
> the xdp memory model.
>=20
> When all pages are returned, free the pool and notify xdp if the
> pool is registered with the xdp memory system.  Have the callback
> perform a table walk since some drivers (cpsw) may share the pool
> among multiple xdp_rxq_info.
>=20
> Note that the increment of pages_state_release_cnt may result in
> inflight =3D=3D 0, releasing the pool.

Maybe we can just do the atomic_inc_return trick, and this patch can
itself can go in.

Alternative is to release the pool via RCU, like the xa
structure is freed via RCU (which have a pointer to the pool).


> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warni=
ng")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

