Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84071F2121
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgFHVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:01:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20019 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726840AbgFHVBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 17:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591650095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=njC/3EtrSHYr3N+lofsXRFJb5f8U26RH2zCjj0w9AP4=;
        b=LqLsd4Ky1c3pZScjGu7rn10jwtDRGTiS1iKLvqX0GU9m3T/RVAhJBtAfwBVyYFY3neEX/T
        yuYK0PScuymApZosTas9cJUa1hH6k/kkGlm7lTDxGJ3RupV5ulRMJ5wBlioZ5almtqCXY7
        o9LvGqCbNxBOl6yalfXDupoKmo72Seo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-_BQUvvBRO0GcfxK2MtbdNg-1; Mon, 08 Jun 2020 17:01:15 -0400
X-MC-Unique: _BQUvvBRO0GcfxK2MtbdNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27478BFD0;
        Mon,  8 Jun 2020 21:01:13 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CAB861169;
        Mon,  8 Jun 2020 21:01:11 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] mlx5: become aware of when running as a bonding slave
Date:   Mon,  8 Jun 2020 17:00:58 -0400
Message-Id: <20200608210058.37352-5-jarod@redhat.com>
In-Reply-To: <20200608210058.37352-1-jarod@redhat.com>
References: <20200608210058.37352-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been unable to get my hands on suitable supported hardware to date,
but I believe this ought to be all that is needed to enable the mlx5
driver to also work with bonding active-backup crypto offload passthru.

CC: Boris Pismenny <borisp@mellanox.com>
CC: Saeed Mahameed <saeedm@mellanox.com>
CC: Leon Romanovsky <leon@kernel.org>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 92eb3bad4acd..72ad6664bd73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -210,6 +210,9 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	struct net_device *netdev = x->xso.dev;
 	struct mlx5e_priv *priv;
 
+	if (x->xso.slave_dev)
+		netdev = x->xso.slave_dev;
+
 	priv = netdev_priv(netdev);
 
 	if (x->props.aalgo != SADB_AALG_NONE) {
@@ -291,6 +294,9 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	unsigned int sa_handle;
 	int err;
 
+	if (x->xso.slave_dev)
+		netdev = x->xso.slave_dev;
+
 	priv = netdev_priv(netdev);
 
 	err = mlx5e_xfrm_validate_state(x);
-- 
2.20.1

