Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2974DF93B6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKLPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:12:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44364 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbfKLPMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573571518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TfFdbFjC2KscWwLRPip4lmdJHlV2IlAU59rraMvKkE=;
        b=dspnmdWZf6j3oM9p2ofeJif0B3N6HdYct22AFGyLydJI/aatAfXbtQ+52UhqWU5/E7tbvt
        Ldj8IkLSJFuO2cVRbCCqHTlVmDTJcnCprcWxhLWRHeBcDr7ZI6W2G4FX5kEL8hFc8tlYEa
        Po/2vdtnj/hdRl9xylXh971HtqZekgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-Gyq9c7vdPq2Ox92ZfNS-hA-1; Tue, 12 Nov 2019 10:11:55 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 027EF107ACC4;
        Tue, 12 Nov 2019 15:11:54 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93E5D611DB;
        Tue, 12 Nov 2019 15:11:46 +0000 (UTC)
Date:   Tue, 12 Nov 2019 16:11:45 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>, <ilias.apalodimas@linaro.org>,
        brouer@redhat.com, Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191112161145.68d2dbd2@carbon>
In-Reply-To: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Gyq9c7vdPq2Ox92ZfNS-hA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 21:32:10 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> The page pool keeps track of the number of pages in flight, and
> it isn't safe to remove the pool until all pages are returned.
>=20
> Disallow removing the pool until all pages are back, so the pool
> is always available for page producers.
>=20
> Make the page pool responsible for its own delayed destruction
> instead of relying on XDP, so the page pool can be used without
> xdp.
>=20
> When all pages are returned, free the pool and notify xdp if the
> pool is registered with the xdp memory system.  Have the callback
> perform a table walk since some drivers (cpsw) may share the pool
> among multiple xdp_rxq_info.
>=20
> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warni=
ng")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

FYI: I'm using this work-in-progress bpftrace script to test your patch:

 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/=
page_pool_track_shutdown01.bt
=20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

