Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B24E41DC00
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351777AbhI3OJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:09:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50390 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351669AbhI3OJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:09:05 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633010842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IyrJmCu4eyZQOsViNW5NAFasbLvR7GyoPKIT5sQFDmc=;
        b=G4iMSzg1dC4/NYjfjfq6v9nSYh3KMTMxB1ItgZAGBVk7bVCx2nHxNdlBDa7gSL+VUc9FHY
        x177GYvSXVLXjoa4RZ3LYblskOqhaiMzBLoHfNqzjJ5ove0n0bbRYX9XefNWO5YbYU61tW
        yOxvQD873WOO67GKOeYrRJ1z86qFWuRNl/hE+ro7poo6+w/K2aWdbrNHoIE3Cxcurk4U3x
        ioxeswCvxmcFQC9aP10bjEL2LNSB8/5U4pWy99+qNAr065qNBg3943I+5OkjjuPPHU9CVb
        /IqSSaARF3sAXJdRjSEObelX0tDHPwXUXk+I5C1voHeWjr8r3apUodFXS/gVXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633010842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IyrJmCu4eyZQOsViNW5NAFasbLvR7GyoPKIT5sQFDmc=;
        b=UYqWDFCFbK5h07G8dyDHF4UJEMOC531yauPYAliwBIDZa0GOrD279WBo0Vucg1mguFQAbK
        V8jz11H9kuZHpeBg==
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next v2] ixgbe: Consider xsk pool's frame size for MTU size
Date:   Thu, 30 Sep 2021 16:06:51 +0200
Message-Id: <20210930140651.2249972-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver has to a ensure that a network packet is not using more than
one page for its data if a XDP program is used.
This results in an upper limit of 1500 bytes. This can be increased a
little if the MTU was programmed to 1514..3072 bytes before loading the
XDP program. By setting this increased MTU size the driver will set the
__IXGBE_RX_3K_BUFFER flag which in turn will allow to use 3KiB as the
upper limit.
This looks like a hack and the upper limit is could increased further.
If the user configured a memory pool then PAGE_SIZE is used as BSIZEPKT
and RLPML is set to pool's memory size as is the card's maximum frame
size.
The result is that a MTU of 3520 bytes can be programmed and every
packet is stored a single page.

If a RX ring has a pool assigned use its size while comparing for the
maximal MTU size.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2: Remove RFC. Repost of
	https://lore.kernel.org/r/20210622162616.eadk2u5hmf4ru5jd@linutronix.de

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 24e06ba6f5e93..ed451f32e1980 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6722,6 +6722,23 @@ static void ixgbe_free_all_rx_resources(struct ixgbe=
_adapter *adapter)
 			ixgbe_free_rx_resources(adapter->rx_ring[i]);
 }
=20
+static int ixgbe_validate_frame_size(unsigned int frame_size,
+				     struct ixgbe_ring *ring)
+{
+	struct xsk_buff_pool *xsk_pool;
+	unsigned int buf_len;
+
+	xsk_pool =3D ring->xsk_pool;
+	if (xsk_pool)
+		buf_len =3D xsk_pool_get_rx_frame_size(xsk_pool);
+	else
+		buf_len =3D ixgbe_rx_bufsz(ring);
+
+	if (frame_size > buf_len)
+		return -EINVAL;
+	return 0;
+}
+
 /**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
@@ -6741,7 +6758,7 @@ static int ixgbe_change_mtu(struct net_device *netdev=
, int new_mtu)
 		for (i =3D 0; i < adapter->num_rx_queues; i++) {
 			struct ixgbe_ring *ring =3D adapter->rx_ring[i];
=20
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
+			if (ixgbe_validate_frame_size(new_frame_size, ring)) {
 				e_warn(probe, "Requested MTU size is not supported with XDP\n");
 				return -EINVAL;
 			}
@@ -10126,7 +10143,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, =
struct bpf_prog *prog)
 		if (ring_is_rsc_enabled(ring))
 			return -EINVAL;
=20
-		if (frame_size > ixgbe_rx_bufsz(ring))
+		if (ixgbe_validate_frame_size(frame_size, ring))
 			return -EINVAL;
 	}
=20
--=20
2.33.0

