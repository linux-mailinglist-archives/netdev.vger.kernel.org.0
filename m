Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245BE118AB8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfLJOYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:24:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727345AbfLJOYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575987839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1m4l6D3s+2g8XxkMBtJ4pgp0ukAmRJI6+mhxccXIzk=;
        b=UC3R+fJiZXkjOI1H4UCgO7buU0DfkMqJvDLjiQHY3m76bd5WUsq/4ec0xF5rcQaMmW0k4G
        ORQehvwhQMKp5CVGeLc5RsHnM/KZpQF7ABvFt17iPuCykXLAKmHJ87BtiVM/sVPWLpHmrw
        hgWB7qnwAIc4R8f+X3+qWfQ5McxUlPw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-84Mpp5VJNUODdD4zxbKKZw-1; Tue, 10 Dec 2019 09:23:59 -0500
Received: by mail-wr1-f70.google.com with SMTP id f17so9035685wrt.19
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=arAx5zhnIVjaTnukE0oB8KOOT1PX3zCb62NUiTGRsxo=;
        b=aKbNDJz5YyJ/7hRSz2oW0TWuJKqO2mxQOdmPP2wfZjIgxWylqJkCwPCZ5lS/Biz31q
         hyKM/+lEYUkjThS8RvN8YRM4uzdP/z1cv9vvvOovTlDAPBvyIjHUm4JEXmgSVsOY6sbU
         Fm3Ju4p4J398idkqfDe58k5UzVqbeKKPRnjtvTlQKvxw8exjtItJYyxZaXiJZNfj1NS3
         2DNTA7jrbrjkPR1N/AQPJIBeV1WKvV7PaAsdMjTgRuA3DwEFeMKIULZD7o4fsmZXA9Kc
         l9hlJAd8x5V5U+ykIm7fhzMus/Rh5OE3DNN4l3WTg5LEdks/73uAy1bZC+W3QulMj5An
         C4Sg==
X-Gm-Message-State: APjAAAWOJGhbmIkev6tDUADHXGqS8OHaFS37k/UFbgYC9SpdDQfDyFlL
        w4FGHUepAVoo0tn+VWySnrgiMl1bUBKRwFM4EHVsb6Nc4WOTcGww+tCVjfIpRUKFOYG2zpnngm+
        ZNl6ifcRbTX4jGaIl
X-Received: by 2002:a05:600c:388:: with SMTP id w8mr5408428wmd.177.1575987837744;
        Tue, 10 Dec 2019 06:23:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3iXOMR3qEF6e0xi6D2sYK7FHbDpCppXr1B3M6TQgnyG1PzoKqeN8Vu22ZrU4aPQPWYkHNDQ==
X-Received: by 2002:a05:600c:388:: with SMTP id w8mr5408414wmd.177.1575987837599;
        Tue, 10 Dec 2019 06:23:57 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id a14sm3533644wrx.81.2019.12.10.06.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:23:57 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:23:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com
Subject: [PATCH net-next v12 2/3] mlx4: use new txqueue timeout argument
Message-ID: <20191210142305.52171-3-mst@redhat.com>
References: <20191210142305.52171-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210142305.52171-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 84Mpp5VJNUODdD4zxbKKZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/e=
thernet/mellanox/mlx4/en_netdev.c
index 71c083960a87..43dcbd8214c6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1367,20 +1367,14 @@ static void mlx4_en_tx_timeout(struct net_device *d=
ev, unsigned int txqueue)
 {
 =09struct mlx4_en_priv *priv =3D netdev_priv(dev);
 =09struct mlx4_en_dev *mdev =3D priv->mdev;
-=09int i;
+=09struct mlx4_en_tx_ring *tx_ring =3D priv->tx_ring[TX][txqueue];
=20
 =09if (netif_msg_timer(priv))
 =09=09en_warn(priv, "Tx timeout called on port:%d\n", priv->port);
=20
-=09for (i =3D 0; i < priv->tx_ring_num[TX]; i++) {
-=09=09struct mlx4_en_tx_ring *tx_ring =3D priv->tx_ring[TX][i];
-
-=09=09if (!netif_tx_queue_stopped(netdev_get_tx_queue(dev, i)))
-=09=09=09continue;
-=09=09en_warn(priv, "TX timeout on queue: %d, QP: 0x%x, CQ: 0x%x, Cons: 0x=
%x, Prod: 0x%x\n",
-=09=09=09i, tx_ring->qpn, tx_ring->sp_cqn,
-=09=09=09tx_ring->cons, tx_ring->prod);
-=09}
+=09en_warn(priv, "TX timeout on queue: %d, QP: 0x%x, CQ: 0x%x, Cons: 0x%x,=
 Prod: 0x%x\n",
+=09=09txqueue, tx_ring->qpn, tx_ring->sp_cqn,
+=09=09tx_ring->cons, tx_ring->prod);
=20
 =09priv->port_stats.tx_timeout++;
 =09en_dbg(DRV, priv, "Scheduling watchdog\n");
--=20
MST

