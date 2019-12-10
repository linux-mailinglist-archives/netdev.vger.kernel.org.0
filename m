Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6AC11891F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLJNFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:05:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727296AbfLJNE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575983098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eNW85TJiVrfXL/ZGCG2VfYculhggK+TL5+4s0Y/nnQ=;
        b=WaBWhAPVcpbBFzMMw/0hkd01SN8K0rDAysOSmkOzk18qarXsGmKf3sEiiXJzlDhQnEEpnr
        3xa3J/3MiGCj/r2UiqOiMb/Q2LPmZEKKMsyId/KIvKhJ/ujnliqvzgmgWHt1d7tibxSXfC
        4QHAtnWP45/5gxCjB5vb7ksgpkdWycI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-HPsFR3lTMhiQ_Lh6R_WDOQ-1; Tue, 10 Dec 2019 08:04:58 -0500
Received: by mail-qk1-f198.google.com with SMTP id m13so12185359qka.9
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:04:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h9ppGS7fm6SZMGx/U7neET6k7mTCQfQI5kEQjvcd/YA=;
        b=hpzbNToJjooh01rCttrRhV3asp5HHJmt+0j2qD34yG42tx8Ag/s1wSnUryAOzC1b68
         aJe+9SgmLbxL9OKa3lRt4RghKXMPHbfKLtl+gRbYBD4nnq2HuTkXf7wutTOlicMkJ75G
         npCmA98jaJqg6FBny9Y5VhY0yvotesFVfTEGX6LLRuzu/zUMVAhMCjf5+Psou6UScnG+
         Xd/UiFcRopULNadKLsyKMdF7VV7Gyn9ESbf+hIOSLB8sjJEFAlv/2q7YFMp4ahzMdTVf
         AWi7arxSiL7E6ALyz8UAew+8CD/jmoxSDD35ahXEMMGqlu6NCEl10fpKchPJ/q8W1ODa
         32eA==
X-Gm-Message-State: APjAAAXcMBwY3Souu0hbaFY+r45hHQNmD8CefnkCOov9c/h4CdjVwp3I
        mwdcng99W0Ju092fuTpXjp1UF5gKOpBGgDQRrW7ibpvViwcj/sE2ZV3gBFoQVHYIfBQ+R5VfbD5
        NR1MIKNWz60rdn0c8
X-Received: by 2002:ac8:936:: with SMTP id t51mr27723079qth.212.1575983096239;
        Tue, 10 Dec 2019 05:04:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzWPe3g8zfEiNjmoeJrevzpnBuyLsoh4sh45qptZPEMLWSJ0KDxY9JnMocSEHn/0pDfmr1CGQ==
X-Received: by 2002:ac8:936:: with SMTP id t51mr27723059qth.212.1575983095995;
        Tue, 10 Dec 2019 05:04:55 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id d23sm1112811qte.32.2019.12.10.05.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:04:55 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:04:50 -0500
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
X-MC-Unique: HPsFR3lTMhiQ_Lh6R_WDOQ-1
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

