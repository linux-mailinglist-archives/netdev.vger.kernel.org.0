Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08B3B0A49
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFVQ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:28:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58918 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVQ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:28:34 -0400
Date:   Tue, 22 Jun 2021 18:26:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624379178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xWFcUkjsYj/U7Vl6fUmZFOAgdOsjW6U1hvHsqY5Wvrg=;
        b=Lchuyf7GXEt8D5Bhjz3cBn1dhx0PYv0ZUBAgu4bIiLe/QVopnCGqz6ZBgQCcAw6o6v3sIC
        aztqW/TGqNvyV/55yPl7oJgcy6rW7Mo9kYZwOJ53+baPtWsmFlcBb+ifpQC0xt0oYgNLre
        +6dE0Mdq/pgJs/B/wb+ofDgtI2FIeSrrLBtJ2/UV7Zj3fL72iutpbhrS6sqllL47Sbn2qU
        JRaDqFyPw728eS6ApCJGFedNW/swnxnUTn89jKCU0JMzW+Hzu9saSOQQ0xRgzlQkFRiokw
        KYC+UfaAJms2vA1oyItJm9y+dgnTv8ytGbSQfgOpFk5YyQfnzm7jTIAtj2NEcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624379178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xWFcUkjsYj/U7Vl6fUmZFOAgdOsjW6U1hvHsqY5Wvrg=;
        b=tjXauT0/RUFc00CDyo8kmu08z3452eY34zA2u8QKvXww00+AqvC/dqOOo4XqmJQWkNeaX0
        Yb28V6EnWzmDFrDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] ixgbe: Consider xsk pool's frame size for MTU size
Message-ID: <20210622162616.eadk2u5hmf4ru5jd@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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

According to my traces incoming packets with a size 70 or 3520 bytes all
end up in one page.
There is currently only one ring/RX-queue. I'm not sure if it is
reasonable to assume to have one RX-queue with xsk_pool and one without.

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2ac5b82676f3b..d250c20a941e9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6723,6 +6723,23 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
 			ixgbe_free_rx_resources(adapter->rx_ring[i]);
 }
 
+static int ixgbe_validate_frame_size(unsigned int frame_size,
+				     struct ixgbe_ring *ring)
+{
+	struct xsk_buff_pool *xsk_pool;
+	unsigned int buf_len;
+
+	xsk_pool = ring->xsk_pool;
+	if (xsk_pool)
+		buf_len = xsk_pool_get_rx_frame_size(xsk_pool);
+	else
+		buf_len = ixgbe_rx_bufsz(ring);
+
+	if (frame_size > buf_len)
+		return -EINVAL;
+	return 0;
+}
+
 /**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
@@ -6742,7 +6759,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 		for (i = 0; i < adapter->num_rx_queues; i++) {
 			struct ixgbe_ring *ring = adapter->rx_ring[i];
 
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
+			if (ixgbe_validate_frame_size(new_frame_size, ring)) {
 				e_warn(probe, "Requested MTU size is not supported with XDP\n");
 				return -EINVAL;
 			}
@@ -10127,7 +10144,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 		if (ring_is_rsc_enabled(ring))
 			return -EINVAL;
 
-		if (frame_size > ixgbe_rx_bufsz(ring))
+		if (ixgbe_validate_frame_size(frame_size, ring))
 			return -EINVAL;
 	}
 
-- 
2.32.0

