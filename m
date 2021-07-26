Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1123D52D7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 07:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhGZEuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 00:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhGZEuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 00:50:11 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397BBC061757
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 22:30:38 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 96DC98365A;
        Mon, 26 Jul 2021 17:30:32 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1627277432;
        bh=exJYd7du+PGHHw+mkZbiwYCJstw++sVoWARZeuq1qmo=;
        h=From:To:Cc:Subject:Date;
        b=TxJwODeDcSDlstP+t9HgQR8MsR1AF1ybDoL0ed+nlgRPnPp6KRUzJZo2eir7fMM49
         6Pea+RHGQYrsERefUJIM0w5E4pZlQkHylop5n6SUJJJw2xm5ugQU2Hi27qB/CI6TYu
         6Hpx8E83WImh+hO9dJC7QMxpNJCkGld193a3Q12bosB1YAiFe8WvUREwcm6btRKb/0
         U0yL0sZdHzshkgDpgIAQbhyA7d05J1KG1dLssxdV29UirCt4C99dZE+qcNLK+NXLyC
         m9zoXRCHe36zFt/s40Ea6kncWd0pyDO45jD36G67rxcxPMeE4ZgAmEPoXQFYbEDIb5
         jjScBkmOU3/sA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60fe48780000>; Mon, 26 Jul 2021 17:30:32 +1200
Received: from richardl-dl.ws.atlnz.lc (richardl-dl.ws.atlnz.lc [10.33.23.13])
        by pat.atlnz.lc (Postfix) with ESMTP id 70CF113EE4B;
        Mon, 26 Jul 2021 17:30:32 +1200 (NZST)
Received: by richardl-dl.ws.atlnz.lc (Postfix, from userid 1481)
        id 6C1D5320AE4; Mon, 26 Jul 2021 17:30:32 +1200 (NZST)
From:   Richard Laing <richard.laing@alliedtelesis.co.nz>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        linux-kernel@vger.kernel.org,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: [PATCH] net: mhi: Improve MBIM packet counting
Date:   Mon, 26 Jul 2021 17:30:03 +1200
Message-Id: <20210726053003.29857-1-richard.laing@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=Qj9HRg2PlNJ9qBswoWQA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets are aggregated over the MBIM link and currently the MHI net
device will count each aggregated packet rather then the actual
packets themselves.

If a protocol handler module is specified, use that to count the
packets rather than directly in the MHI net device. This is in line
with the behaviour of the USB net cdc_mbim driver.

Signed-off-by: Richard Laing <richard.laing@alliedtelesis.co.nz>
---
 drivers/net/mhi/net.c        | 14 +++++++-------
 drivers/net/mhi/proto_mbim.c |  4 ++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index a5a2aa19bb91..0cc7dcd0ff96 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -205,11 +205,6 @@ static void mhi_net_dl_callback(struct mhi_device *m=
hi_dev,
 			mhi_netdev->skbagg_head =3D NULL;
 		}
=20
-		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.rx_packets);
-		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
-		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-
 		switch (skb->data[0] & 0xf0) {
 		case 0x40:
 			skb->protocol =3D htons(ETH_P_IP);
@@ -222,10 +217,15 @@ static void mhi_net_dl_callback(struct mhi_device *=
mhi_dev,
 			break;
 		}
=20
-		if (proto && proto->rx)
+		if (proto && proto->rx) {
 			proto->rx(mhi_netdev, skb);
-		else
+		} else {
+			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+			u64_stats_inc(&mhi_netdev->stats.rx_packets);
+			u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
+			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 			netif_rx(skb);
+		}
 	}
=20
 	/* Refill if RX buffers queue becomes low */
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index f1cc7f35bb85..761d90b28ee6 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -211,6 +211,10 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, =
struct sk_buff *skb)
 				continue;
 			}
=20
+			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+			u64_stats_inc(&mhi_netdev->stats.rx_packets);
+			u64_stats_add(&mhi_netdev->stats.rx_bytes, skbn->len);
+			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 			netif_rx(skbn);
 		}
 next_ndp:
--=20
2.32.0

