Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137A21039D7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfKTMQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:16:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728251AbfKTMQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:16:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574252171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUx/oPuU8l45zB4UFv6PrHlbcIdlFEBdtOeWR6Ax4ag=;
        b=fHASW/z7gwRarX2NqtrlBqM/MpSFuWcebacm/Lc6R6yY7WDiutLt5m6fe4oETS1Xnopr0+
        h+O/w8bdaT9y5S9px8yjl3IRkFysumPa5ieRmjFcT3ymQDKho0rYbrwKGG1ftOWJE+rlo/
        c4gWtVCzBsZMBRaIoy+guA12tXN/Uyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-ASlJa_AbN22MfG8N4rssBA-1; Wed, 20 Nov 2019 07:16:09 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7970107ACCC;
        Wed, 20 Nov 2019 12:16:07 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39ADFA7F4;
        Wed, 20 Nov 2019 12:16:02 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:16:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V3 2/3] page_pool: Don't recycle non-reusable
 pages
Message-ID: <20191120131601.700ad1c4@carbon>
In-Reply-To: <20191120001456.11170-3-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
        <20191120001456.11170-3-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ASlJa_AbN22MfG8N4rssBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:15:19 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> A page is NOT reusable when at least one of the following is true:
> 1) allocated when system was under some pressure. (page_is_pfmemalloc)
> 2) belongs to a different NUMA node than pool->p.nid.
>=20
> To update pool->p.nid users should call page_pool_update_nid().
>=20
> Holding on to such pages in the pool will hurt the consumer performance
> when the pool migrates to a different numa node.
>=20
> Performance testing:
> XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
> while migrating rx ring irq from close to far numa:
>=20
> mlx5 internal page cache was locally disabled to get pure page pool
> results.
>=20
> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
>=20
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.9 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
>=20
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 3.5 Mpps  | 4  Mpps
>=20
> Improvement is about 30% drop packet rate, 15% tx packet rate for numa
> far test.
> No degradation for numa close tests.
>=20
> TCP single/multi cpu/stream:
> NUMA  | #cpu | Before  | After
> --------------------------------------
> Close | 1    | 18 Gbps | 18 Gbps
> Far   | 1    | 15 Gbps | 18 Gbps
> Close | 12   | 80 Gbps | 80 Gbps
> Far   | 12   | 68 Gbps | 80 Gbps
>=20
> In all test cases we see improvement for the far numa case, and no
> impact on the close numa case.
>=20
> The impact of adding a check per page is very negligible, and shows no
> performance degradation whatsoever, also functionality wise it seems more
> correct and more robust for page pool to verify when pages should be
> recycled, since page pool can't guarantee where pages are coming from.
>=20
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

