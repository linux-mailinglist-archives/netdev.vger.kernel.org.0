Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63774A94D5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 09:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiBDIDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 03:03:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58500 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiBDIDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 03:03:09 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643961788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Q9w9cCPiizS9c08viXczkQ5y2iVATK7Ure0+P8y1WA=;
        b=ljChLCBbv7pau6AmdP7lrZKgMaXOBH5xuPDQSv6n5Cxlvl7kOFDnMh4+NcPTLcyPE50T0H
        OHaKZJTqyDObo1ihgDWeO9g1ozkEh1AlkIN+kCl3EGUa0j/uMDg/35fl8Kzzc3ABqZJib0
        rsuM5DRLRPIy3Vtu66zrC599ckiBvmG6aLpYg+zr5BcUvRRQ+wY9Osmbwo6HD9xGNZbcaz
        cr5k25Cg4Qjnbdr2t7siEAC9Pkt0hBEB8vpTT/1ZmE5pzWfMjT6LszwOqPksez4/+xIju7
        FLJ3Xkzljt5cD7jQZq+t4DfYn3/DAlGIpJYbkMnaza6XKISQ5icpY+2it3yeCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643961788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Q9w9cCPiizS9c08viXczkQ5y2iVATK7Ure0+P8y1WA=;
        b=eLzMILb0aJ6QOt9v0QzfE+irTbFbevFZeS2k8zVF4bzdF3a3nQtm6s5bJ1Mcgqpf/Y2boP
        vHVy0UUAp7KLgWCw==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net] igc: Clear old XDP info when changing ring settings
Date:   Fri,  4 Feb 2022 09:02:17 +0100
Message-Id: <20220204080217.70054-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing ring sizes the driver triggers kernel warnings in XDP code.

For instance, running 'ethtool -G $interface tx 1024 rx 1024' yields:

|[  754.838136] Missing unregister, handled but fix driver
|[  754.838143] WARNING: CPU: 4 PID: 704 at net/core/xdp.c:170 xdp_rxq_info_reg+0x7d/0xe0

The newly allocated ring is copied by memcpy() and still contains the old XDP
information. Therefore, it has to be cleared before allocating new resources
by igc_setup_rx_resources().

Igb does it the same way. Keep the code in sync.

Fixes: 4609ffb9f615 ("igc: Refactor XDP rxq info registration")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..93839106504d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -671,6 +671,10 @@ igc_ethtool_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igc_ring));
 
+			/* Clear copied XDP RX-queue info */
+			memset(&temp_ring[i].xdp_rxq, 0,
+			       sizeof(temp_ring[i].xdp_rxq));
+
 			temp_ring[i].count = new_rx_count;
 			err = igc_setup_rx_resources(&temp_ring[i]);
 			if (err) {
-- 
2.30.2

