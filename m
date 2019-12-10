Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0813E118905
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfLJNA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:00:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727272AbfLJNA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575982857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9e82RZxMOLIpTiokhMnuko25lsVYhsTU5bajYGHD3E0=;
        b=V8zu9xI+ef3gpnHazMZjMQOemwfbPUiWLpeT3GSH+fU7axnNWwqrqeT/vq+xbq3zCfz+c6
        eiDcsdCR/KS2ddqH/NzlgCFExiHmmS0ENFWurm0mHYVu93Shie+Xui8GSLJR8MFLulQJwS
        jDbuqMSVIlD7iz861L2n9MuatQhDVK0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-E0SdH3OROWKISMyjp4ikoA-1; Tue, 10 Dec 2019 08:00:56 -0500
Received: by mail-qv1-f69.google.com with SMTP id m9so1031109qvx.17
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:00:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrMmlrBt1X+KXyyzVL2v0JpYF8+uVnrQFFbGuDQ2s1k=;
        b=IILzdKRowgZyZpZcKR7DxR28odRAl4SWQlcn5sZpJKjhBHRa/aanobJWwBDIFm3gra
         TTOIGm5xz1mWroKsY2S7Nro4/sa6u9W/fZvwuecOEKmHc7SbbHmLob8cA8gmBQ7W7WBW
         /EJBlJ1AkWlSE8u5g9ThAVrocrJH7i4/Of3tUjCJsoHEsbChREd2ZtvQtlOou+qn6P1F
         uXjcmcyiT7EUsYOEOEKFe1QaL/Y5Jsx3rbYrzuRYKX6OxIwETPtN3S4OoweH5eaq9+oO
         twZaJWPARHqbuD3/RtpVp63TKiMvZx8qDa7XUaH3DrJLPbTlQlhiho1ys5Dq9rjbcqeW
         jBgQ==
X-Gm-Message-State: APjAAAWghiX0gRVmvakg838Ioch4H18pps/8thYaOXHkgNcg9nLaWkzE
        kR/2LF0a3Q2HEVViQa6JXkT0CiLnfHHfvE0QPRi5YCji2lroJ2DagaKVQoh9hFnj3VdSeMy0pgn
        z9Ly4HWQWLz9AXh8U
X-Received: by 2002:ae9:ec0a:: with SMTP id h10mr30081123qkg.303.1575982856003;
        Tue, 10 Dec 2019 05:00:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdPfBVccegJ+sVSh7D3UbOkyDGw8L3+H+QRIw+97A58lq6K5FGQi/nFFUXP/L4WSIDyLcgYg==
X-Received: by 2002:ae9:ec0a:: with SMTP id h10mr30081108qkg.303.1575982855810;
        Tue, 10 Dec 2019 05:00:55 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id n20sm138085qkk.54.2019.12.10.05.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:00:55 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:00:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v10 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191210130014.47179-4-mst@redhat.com>
References: <20191210130014.47179-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210130014.47179-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: E0SdH3OROWKISMyjp4ikoA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index 41a808b14d76..eb1f9bed4833 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1323,14 +1323,8 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct =
nfp_net_tx_ring *tx_ring)
 static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct nfp_net *nn =3D netdev_priv(netdev);
-=09int i;
=20
-=09for (i =3D 0; i < nn->dp.netdev->real_num_tx_queues; i++) {
-=09=09if (!netif_tx_queue_stopped(netdev_get_tx_queue(netdev, i)))
-=09=09=09continue;
-=09=09nn_warn(nn, "TX timeout on ring: %d\n", i);
-=09}
-=09nn_warn(nn, "TX watchdog timeout\n");
+=09nn_warn(nn, "TX watchdog timeout on ring: %u\n", txqueue);
 }
=20
 /* Receive processing
--=20
MST

