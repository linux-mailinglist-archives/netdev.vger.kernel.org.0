Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3765345EAA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhCWM4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231424AbhCWM4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE9F60C3E;
        Tue, 23 Mar 2021 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616504175;
        bh=aqKRpulSPCrh/zMHeH6x9tZrAsAvxFVCeqlmNTkK6XU=;
        h=From:To:Cc:Subject:Date:From;
        b=kpgeUNTpkeKgQ5LtZe9cwXIrCX4EBUhQe0ntE9chwd7cZ1CAV5ThoOgemX8vzdUwf
         1/AXCrmc+yGTQUcLOj32vOcYxffBmNrw3NEqwHtDWMc4qMS1S78enwBVOFmL4bDx8N
         ZDkqn9dFKXXaD/TD3NNoV5iqA0eQBIrdBqlzHSijpro5YZi8AZVY5d0gG6l/o5Sifd
         USNEIPvKeMesLNsZoZtlpeq8IwjZKBQFR0jlDFhzxyqg6wm4+dU6zJBfbwIdQ/aK8z
         igZlUpx+wlTakVB8uCg/pv3WuY9FX7rGOweXS655PbI8f1kD8wpCrlg/3Jd0isn+DU
         IFLZ//L0s3+pg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hinic: avoid gcc -Wrestrict warning
Date:   Tue, 23 Mar 2021 13:56:05 +0100
Message-Id: <20210323125611.1905563-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With extra warnings enabled, gcc complains that snprintf should not
take the same buffer as source and destination:

drivers/net/ethernet/huawei/hinic/hinic_ethtool.c: In function 'hinic_set_settings_to_hw':
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:480:9: error: 'snprintf' argument 4 overlaps destination object 'set_link_str' [-Werror=restrict]
  480 |   err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  481 |           "%sspeed %d ", set_link_str, speed);
      |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:464:7: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
  464 |  char set_link_str[SET_LINK_STR_MAX_LEN] = {0};

Rewrite this to remember the offset of the previous printf output
instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index c340d9acba80..74aefc8fc4d8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -464,7 +464,7 @@ static int hinic_set_settings_to_hw(struct hinic_dev *nic_dev,
 	char set_link_str[SET_LINK_STR_MAX_LEN] = {0};
 	struct net_device *netdev = nic_dev->netdev;
 	enum nic_speed_level speed_level = 0;
-	int err;
+	int err, off;
 
 	err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN, "%s",
 		       (set_settings & HILINK_LINK_SET_AUTONEG) ?
@@ -475,10 +475,11 @@ static int hinic_set_settings_to_hw(struct hinic_dev *nic_dev,
 		return -EFAULT;
 	}
 
+	off = err;
 	if (set_settings & HILINK_LINK_SET_SPEED) {
 		speed_level = hinic_ethtool_to_hw_speed_level(speed);
-		err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
-			       "%sspeed %d ", set_link_str, speed);
+		err = snprintf(set_link_str + off, SET_LINK_STR_MAX_LEN - off,
+			       "speed %d ", speed);
 		if (err <= 0 || err >= SET_LINK_STR_MAX_LEN) {
 			netif_err(nic_dev, drv, netdev, "Failed to snprintf link speed, function return(%d) and dest_len(%d)\n",
 				  err, SET_LINK_STR_MAX_LEN);
-- 
2.29.2

