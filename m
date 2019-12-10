Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1911894A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfLJNJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:09:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLJNJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575983389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1m4l6D3s+2g8XxkMBtJ4pgp0ukAmRJI6+mhxccXIzk=;
        b=U4wQY3OD5zBqSGPPAydgjlouJGbc1vkhxJprkBkCSqUCjBJQzfXhhQdh5Wa0SLAt3l9zZl
        wBEpsrQd7IbqfPCAND6AzZ4K4VWklHsBL2TzlN+FnpRqQexeYMPbiFCc7/hW1wOkVxyzkx
        /3qImb+mvCN/r6cPKL2z/GWV15sPLBU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-7jel5xUrPailTVFW5esgxQ-1; Tue, 10 Dec 2019 08:09:46 -0500
Received: by mail-qv1-f72.google.com with SMTP id d12so6740029qvj.16
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:09:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=arAx5zhnIVjaTnukE0oB8KOOT1PX3zCb62NUiTGRsxo=;
        b=iEPJI6PgiEm3HpIdwPRsc47o3ETxo1AIfnkkPlAA3kjgwNOenu3+1Po/+d/wL/Uq0z
         sEI+KLk+pw+ayT013c3NUJ0FT8Rsr8cOk9bPPSE11tciaEuXNeDgTFl5veLmq2Azs7AJ
         N279DNSGAfOd4uMb9X26L39EWgLAI+k19auuHuMGuaEWbB9Az6QtIU2JT/I4FmxcqjCI
         neN1RwtPdgax/qqd3ukD9ZMGqoTTa98JkVJ08sSOPgL6/OuIxt6wJXMFrECPcr7y9fSd
         c6/6K10XXsBLBDWzq40HSP0CBjg8XC9mnHQkwvXo13TGVMKt+JuC9845Jur1W0Ty3Y5t
         1/nQ==
X-Gm-Message-State: APjAAAWcbqZHpfmoRsxTy6CaxdAqcE8Woidd7vNgpkdKYM+nytJSe9On
        IVhCMUdvOvc+UZODJUXOdAgb0SN+AXfa9SZYfwJInc7EJQi9+HMlyEsaQjaeIf6fPUv0Ivx9zAu
        V2OANjs5luXBdJEc7
X-Received: by 2002:ac8:1c4e:: with SMTP id j14mr968385qtk.300.1575983385757;
        Tue, 10 Dec 2019 05:09:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0NdqPQY5+CMuG066RsSLy1C9s67XUjynq5xyNWeBMJDtPlMed8sZPRLdRNcHBm75IprM/Dw==
X-Received: by 2002:ac8:1c4e:: with SMTP id j14mr968365qtk.300.1575983385613;
        Tue, 10 Dec 2019 05:09:45 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id w29sm1102558qtc.72.2019.12.10.05.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:09:44 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:09:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com
Subject: [PATCH net-next v11 2/3] mlx4: use new txqueue timeout argument
Message-ID: <20191210130837.47913-3-mst@redhat.com>
References: <20191210130837.47913-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210130837.47913-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 7jel5xUrPailTVFW5esgxQ-1
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

