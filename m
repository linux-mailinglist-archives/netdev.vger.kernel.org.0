Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9900B1039DD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfKTMQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:16:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbfKTMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:16:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574252196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWaVnaz8RstxNE3lcMqcdMGrh3NHR58Op5ZleG5vvi4=;
        b=FdeIwDeyhrHJm2YDcEP+veMPP3/QlIMwRPII+rMxRiraHUGeuOvUhg+zQBOgwLu/POrk9W
        m+4/Trg0nADVI4EUcnUC1Xfb6Mjd16QStB/3OZPBHYXQj5istdJ1EKTv8fDAxeZDWuh3HX
        hX8UUI/vBKXmOkFmuOh55FrRC34+s7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-4_7EX-wTN4eEsG-VipjqBA-1; Wed, 20 Nov 2019 07:16:33 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FB3107B012;
        Wed, 20 Nov 2019 12:16:31 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 877F863646;
        Wed, 20 Nov 2019 12:16:27 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:16:26 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH net-next V3 3/3] net/mlx5e: Rx, Update page pool numa
 node when changed
Message-ID: <20191120131626.013c0c9e@carbon>
In-Reply-To: <20191120001456.11170-4-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
        <20191120001456.11170-4-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 4_7EX-wTN4eEsG-VipjqBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:15:21 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> Once every napi poll cycle, check if numa node is different than
> the page pool's numa id, and update it using page_pool_update_nid().
>=20
> Alternatively, we could have registered an irq affinity change handler,
> but page_pool_update_nid() must be called from napi context anyways, so
> the handler won't actually help.
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
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

