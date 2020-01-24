Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CDC14899E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391184AbgAXOTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391270AbgAXOTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC592087E;
        Fri, 24 Jan 2020 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875543;
        bh=Pn9ScWTH0zprbEN/kgqNSjE7Dcize02YCTsDYoWUOAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYWmynhAWAsKANyoqJr+RSAuqK92xAMQI/7vJOcxhBdyk5PlFYbr4r8UWID4Wwt+4
         wMg/QYb6fSbTJqebYcqctS+guLDnASPQbEdhbHfuiVgTOVkT5sobCP1GzRxxUry+GX
         vUGPTcqr/vhyp5uRIco2Dh3izVBuTDhyTScQ/0Rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 039/107] ixgbevf: Remove limit of 10 entries for unicast filter list
Date:   Fri, 24 Jan 2020 09:17:09 -0500
Message-Id: <20200124141817.28793-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit aa604651d523b1493988d0bf6710339f3ee60272 ]

Currently, though the FDB entry is added to VF, it does not appear in
RAR filters. VF driver only allows to add 10 entries. Attempting to add
another causes an error. This patch removes limitation and allows use of
all free RAR entries for the FDB if needed.

Fixes: 46ec20ff7d ("ixgbevf: Add macvlan support in the set rx mode op")
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 076f2da36f278..64ec0e7c64b49 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2081,11 +2081,6 @@ static int ixgbevf_write_uc_addr_list(struct net_device *netdev)
 	struct ixgbe_hw *hw = &adapter->hw;
 	int count = 0;
 
-	if ((netdev_uc_count(netdev)) > 10) {
-		pr_err("Too many unicast filters - No Space\n");
-		return -ENOSPC;
-	}
-
 	if (!netdev_uc_empty(netdev)) {
 		struct netdev_hw_addr *ha;
 
-- 
2.20.1

