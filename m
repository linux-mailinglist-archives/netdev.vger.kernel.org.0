Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CF16A0E78
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBWROY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBWROW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:14:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A243D925;
        Thu, 23 Feb 2023 09:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C26FB81A88;
        Thu, 23 Feb 2023 17:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4429C433EF;
        Thu, 23 Feb 2023 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677172453;
        bh=tMD0j0e568N2lfxiR0Fj9qTsU20UwP3oQEtQV2YKoYc=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=mC3yLHQT82ZBLG61PVB34U13cA2dF5VCIuw9KaZktUx/MBzYTXJXleTR1YX23XJf+
         YGH1UaPj26K58cSNd5ThyoTrGnLNeq6oPWEaQO/j01IFNgm4IwwTX3up8lAAWptVER
         xg4V0jo8/NUXsiwGmuFe8GFtRSRUG0lJc+ArQ70T6AtYtVhJoRSDpdTMkahVP4oIFm
         MoLFgrbJyOLqwLgIe0D0inmO+2L0Lypb2JhgNN0zrb6Q6Esk7FV2X/iGlVqxAAWghs
         pQ6gNcKNNS0e4Tuz0oVybiXF7kDiwKOth4YE2uSvMihqZW3IJXvMdoLDUFDUwz2dtH
         FqUNAlwOTmSfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id A7B82C61DA4;
        Thu, 23 Feb 2023 17:14:13 +0000 (UTC)
From:   Rob Bradford via B4 Relay 
        <devnull+rbradford.rivosinc.com@kernel.org>
Date:   Thu, 23 Feb 2023 17:13:57 +0000
Subject: [PATCH] virtio-net: Fix probe of virtio-net on kvmtool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230223-virtio-net-kvmtool-v1-1-fc23d29b9d7a@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIANSe92MC/22OwQrCMBBEf6Xs2YV0Q6n4K+IhqVu7qIlsQiiU/
 rur4M3LwGN4w2xQWIULnLoNlJsUycmgP3QwLSHdGOVqDOTIOyKPTbRKxsQV7+1Zc37gcZz9OPR
 DZCIwMYbCGDWkafmp6AgtZ1n/DHycl7KV3yPny76/AQAyPqCYAAAA
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Bradford <rbradford@rivosinc.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1677172452; l=1694;
 i=rbradford@rivosinc.com; s=20230223; h=from:subject:message-id;
 bh=z4BoSYh1zWAdqXeZO03vzqGwuNOqVDWaqEjXIgKixEQ=;
 b=sG/nKDOFR38MMLity9ZDXFHvYN9SbTx8eCMH1h1jh/fv3AC+ZcaV5qNk+SkzIcizdScKvRc4B
 RhVLyHozFqaD3+B2TZTIjArEVoS4xdsMmCsqDmkkHd/1yM2EsnO0tNV
X-Developer-Key: i=rbradford@rivosinc.com; a=ed25519;
 pk=LZhCh/kJ+nOqxgEGWkLfx2jKUM5LlyU0Jlip8qsjuA8=
X-Endpoint-Received: by B4 Relay for rbradford@rivosinc.com/20230223 with auth_id=34
X-Original-From: Rob Bradford <rbradford@rivosinc.com>
Reply-To: <rbradford@rivosinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rob Bradford <rbradford@rivosinc.com>

kvmtool does not support the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature
but does advertise the VIRTIO_NET_F_GUEST_TSO{4,6} features. Check that
the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is present before setting
the NETIF_F_GRO_HW feature bit as otherwise an attempt will be made to
program the virtio-net device using the ctrl queue which will fail.

This resolves the following error when running on kvmtool:

[    1.865992] net eth0: Fail to set guest offload.
[    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wanted 0x0000000000134829, left 0x0080000000134829

Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
---
 drivers/net/virtio_net.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 61e33e4dd0cd..59951e51fe76 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3781,9 +3781,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
 		dev->features |= NETIF_F_RXCSUM;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_GRO_HW;
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) &&
+	    virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
 		dev->hw_features |= NETIF_F_GRO_HW;
 
 	dev->vlan_features = dev->features;

---
base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
change-id: 20230223-virtio-net-kvmtool-87f37515be22

Best regards,
-- 
Rob Bradford <rbradford@rivosinc.com>

