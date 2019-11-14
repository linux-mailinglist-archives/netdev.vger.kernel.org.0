Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B561BFD0DE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 23:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKNWRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 17:17:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726818AbfKNWRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 17:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573769866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ljVPuYzQqz8tGaer1ovZw7P5Xq69+nDp+Xd7M5XvWZM=;
        b=eVaLUffXxArcsMM7jCChnuKwKtUS8vOYgXF5cyVay/+6rumbDJ1m04SsW2w43Xf9mCn2Q1
        2q60l8u2wWpFtx1OBTndcJC5bWdBjnWjm1vhauRDVl6okj243iVcWbrYrZvdQiyrIEMqPz
        +37h7hlXLpnLhO6YMKnwhdgBYq4SV40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-B0KGshOIOBGdkQhBhRAg7g-1; Thu, 14 Nov 2019 17:17:45 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE019800A1A;
        Thu, 14 Nov 2019 22:17:43 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7001D60C05;
        Thu, 14 Nov 2019 22:17:39 +0000 (UTC)
Date:   Thu, 14 Nov 2019 23:17:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <ilias.apalodimas@linaro.org>, <kernel-team@fb.com>,
        brouer@redhat.com
Subject: Re: [net-next PATCH v3 1/1] page_pool: do not release pool until
 inflight == 0.
Message-ID: <20191114231737.29b46690@carbon>
In-Reply-To: <20191114221300.1002982-2-jonathan.lemon@gmail.com>
References: <20191114221300.1002982-1-jonathan.lemon@gmail.com>
        <20191114221300.1002982-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: B0KGshOIOBGdkQhBhRAg7g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 14:13:00 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> The page pool keeps track of the number of pages in flight, and
> it isn't safe to remove the pool until all pages are returned.
>=20
> Disallow removing the pool until all pages are back, so the pool
> is always available for page producers.
>=20
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
> inflight =3D=3D 0, resulting in the pool being released.
>=20
> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warni=
ng")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

