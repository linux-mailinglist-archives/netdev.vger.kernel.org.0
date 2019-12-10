Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7197211890F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfLJNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:01:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26472 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727462AbfLJNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575982868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eNW85TJiVrfXL/ZGCG2VfYculhggK+TL5+4s0Y/nnQ=;
        b=JFL9NhOF1uWB0WyQh5jkRB5dIApXsRuQKyblBuYgMxcIQjBRfqZMSTily7zWK7LzNKZ4uu
        XW9DTJL91dRfv8Sv0PDBjuq8T/BVnifeI8zJUAiQxXw/qyxcpKZqJr1vJZVRmgO0YT3QiV
        vinsQBypYBiDZ4QvrDnVR3hScbAAQJY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-0AAE4_tZMeyCqwkziccXDQ-1; Tue, 10 Dec 2019 08:01:07 -0500
Received: by mail-qt1-f197.google.com with SMTP id q17so1803165qtc.8
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h9ppGS7fm6SZMGx/U7neET6k7mTCQfQI5kEQjvcd/YA=;
        b=QrDCeIp8LDnekjIfvRFU/bVI/22xZz50TJRzgysgsO2h/LhRDgjj8UW+NoQT91k7BA
         70p1v/V7r4SbIOht9Uj7W2m3HjB865fSIGsWbGksiVYkRft2GSi2zx9nmxZ/rj7KBe4k
         mLQb7LOhNI0NNasjHOYQ6SXNw6dVfdwcV9j6EECMKOWvixTr+THwyDBMPUgaIzdi9wLx
         znEiaYl3lEYDimsGXdp4qbpxGysGrS0dkK5dHPDJ/kPdU/uqQrvPnPOyEdfoyB65LDkF
         0q/gdCot8xU9JbmRAImRcjJ1rvOxqOfil8on6WeIbTXUkRKgFLOymMtWUIdUfqfSO4t1
         CdNQ==
X-Gm-Message-State: APjAAAWiLypwcFowooDW1xFIIu2H+xQ+Qt9Vxbk5Xj3Ie5reZzE+qVNR
        IWE+jKxMjxwJ+UrHKd2R4MrYbopS/whffE3BaTECMj68+bB8G8dQOs7AnaezjZkJ5NQCHitrsh7
        W5Df2MTv6EYLhaSjC
X-Received: by 2002:a37:9345:: with SMTP id v66mr3975291qkd.195.1575982866623;
        Tue, 10 Dec 2019 05:01:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHMG7fHBREIQP5xXEtbXFAXxXmprGvs+2LXAytwLYY15kf2vYIZ5QNpJ3t9gx8gh4i5FTAbA==
X-Received: by 2002:a37:9345:: with SMTP id v66mr3975268qkd.195.1575982866415;
        Tue, 10 Dec 2019 05:01:06 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id x65sm902458qkd.15.2019.12.10.05.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:01:05 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:01:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com
Subject: [PATCH net-next v10 2/3] mlx4: use new txqueue timeout argument
Message-ID: <20191210130014.47179-3-mst@redhat.com>
References: <20191210130014.47179-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210130014.47179-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 0AAE4_tZMeyCqwkziccXDQ-1
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
index aa348230bd39..2c2ff1f0ea6d 100644
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

