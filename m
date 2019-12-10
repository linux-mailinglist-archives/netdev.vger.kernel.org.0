Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95389119B90
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfLJWJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfLJWE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B18F20838;
        Tue, 10 Dec 2019 22:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015468;
        bh=VJRtcpsfpAwpkoGFFGyFknZWq/Vw+SGLlryQ7+DE7Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8ctW28QztQldPAcvIgk5fDFzseZkXwkjn8KJWRAjGVh3nWzccMupCsmr7qhs9M0z
         Zhpo7Iw2N91yW4F+1CVIy4QeU8BQnuevi25O2W2CvzTKrfHV0At5XEUdxeQFCplmZW
         5GrLB4fr8yx0WdktX/pxyY+Mo/cdW7xSGRE4KtIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manjunath Patil <manjunath.b.patil@oracle.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 074/130] ixgbe: protect TX timestamping from API misuse
Date:   Tue, 10 Dec 2019 17:02:05 -0500
Message-Id: <20191210220301.13262-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manjunath Patil <manjunath.b.patil@oracle.com>

[ Upstream commit 07066d9dc3d2326fbad8f7b0cb0120cff7b7dedb ]

HW timestamping can only be requested for a packet if the NIC is first
setup via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the ixgbe
driver still allowed TX packets to request HW timestamping. In this
situation, we see 'clearing Tx Timestamp hang' noise in the log.

Fix this by checking that the NIC is configured for HW TX timestamping
before accepting a HW TX timestamping request.

Similar-to:
   commit 26bd4e2db06b ("igb: protect TX timestamping from API misuse")
   commit 0a6f2f05a2f5 ("igb: Fix a test with HWTSTAMP_TX_ON")

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4801d96c4fa91..0edfd199937d5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8379,7 +8379,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	    adapter->ptp_clock) {
-		if (!test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
 					   &adapter->state)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
-- 
2.20.1

