Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937D110F8BB
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 08:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfLCHcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 02:32:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfLCHcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 02:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575358338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDZ6zkutNb+UsMTsOrqqbjPx6wHX610gfsQwcSvpFp8=;
        b=i/oHZG93xGRnBNU63Or9vBXMJ4oZKXltrxB/xB12lXJQktZ7Nqknqa29Fx6O6mxTkcnJk/
        N9LFhngI7Ohpz0I+TKl5x+N7bpniLn5NRb3ZUnnJFdRLGyTLzg3ysx2CovPRBHqHZhNQFc
        GkImd7uhqRHlwuJ5f9VdL2S6Z25K2S8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-drs503-2NXaYJKuT_gpO9A-1; Tue, 03 Dec 2019 02:32:14 -0500
Received: by mail-qt1-f199.google.com with SMTP id l4so1793540qte.18
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 23:32:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6xKT/ZrBuwY/dROOLKR3Rna6H1BFhaRlBSFPw3pHzCk=;
        b=e/yMHtNRqJ7BlyWgEHUkKhjM/BB2Px3iGsyiT8pig/K7Ebb4aiHuM+gDy/8fdnng4X
         Tas921wT2i2RUVrHbbTPE3oQGnH2kL5kmF5fMURDJFhgjTtBi02BbN241xypuwgsJ8LX
         4RVRqj5NV3qxXqxWrlnidQziM3ehoFRCpVcRJRsicK9SFAk0eHEKA7s3wKe4ROWO9ouB
         U/iecFEqknyfDqfeLodp+Ac20PIAw7kZ2/JAn5tBfpZcGeltppH6Q/fn4hndz+x3HbeU
         DgfLBezrDjHWKGbYZECPECBPQRqv48IPGe8Te408niKnBULWDhwi+ga+0EtDYCxtxXx7
         rqbg==
X-Gm-Message-State: APjAAAUTWfCjSZVTVW/4U0HxJWSjoP9EgQ/iNtQFODWnTEAUfUktWeJE
        EaihGqJmRcWAvpmFMuEM19V66Z0ZEtnHUtEwAC2hRXlO2J0TflrYKmdkxSHWj4AG2CI5LtOl44O
        +is+irPQ1tycDnWHC
X-Received: by 2002:a37:4f83:: with SMTP id d125mr3826268qkb.205.1575358334436;
        Mon, 02 Dec 2019 23:32:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9SwwNQE59WdoMcrLUQeGGNOBWpqfUZPXMhfa3nkO1AfEgg7+4frtIMTFsaovZ3lKFFAH+BA==
X-Received: by 2002:a37:4f83:: with SMTP id d125mr3826243qkb.205.1575358334155;
        Mon, 02 Dec 2019 23:32:14 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id q126sm1299731qkd.21.2019.12.02.23.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 23:32:13 -0800 (PST)
Date:   Tue, 3 Dec 2019 02:32:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH RFC v7 net-next 2/1] mlx4: use new txqueue timeout argument
Message-ID: <20191203072757.429125-1-mst@redhat.com>
References: <20191203071101.427592-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191203071101.427592-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: drs503-2NXaYJKuT_gpO9A-1
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

untested

 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/e=
thernet/mellanox/mlx4/en_netdev.c
index d2728933d420..3bcf5f682af5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1363,15 +1363,9 @@ static void mlx4_en_tx_timeout(struct net_device *de=
v, unsigned int txqueue)
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

