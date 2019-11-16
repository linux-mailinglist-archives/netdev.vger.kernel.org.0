Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C80FF0C9
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbfKPQHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbfKPPu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:27 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D362083E;
        Sat, 16 Nov 2019 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919426;
        bh=v5l74EKbWgA7xuDajmxN81xwZrHg0s9j8HKcj2TwGZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4Om+k2Dg1Sf8Z21krZhFZh+8CZ+dzzuQg3CNYgf03m81gSgodO8NkRKEm8lBdhP9
         bxPTsb3JWEczAAfI5aGxpZcOiJyqe5xD3/EgJ+oN565No6dQmXKh72eK1NTmO078Y8
         kE/vjUNIUrAyfjd30cs/OoIEj05u6SM/7RShC3uk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 124/150] wireless: airo: potential buffer overflow in sprintf()
Date:   Sat, 16 Nov 2019 10:47:02 -0500
Message-Id: <20191116154729.9573-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3d39e1bb1c88f32820c5f9271f2c8c2fb9a52bac ]

It looks like we wanted to print a maximum of BSSList_rid.ssidLen bytes
of the ssid, but we accidentally use "%*s" (width) instead of "%.*s"
(precision) so if the ssid doesn't have a NUL terminator this could lead
to an overflow.

Static analysis.  Not tested.

Fixes: e174961ca1a0 ("net: convert print_mac to %pM")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 54201c02fdb8b..fc49255bab009 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5464,7 +5464,7 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
            we have to add a spin lock... */
 	rc = readBSSListRid(ai, doLoseSync, &BSSList_rid);
 	while(rc == 0 && BSSList_rid.index != cpu_to_le16(0xffff)) {
-		ptr += sprintf(ptr, "%pM %*s rssi = %d",
+		ptr += sprintf(ptr, "%pM %.*s rssi = %d",
 			       BSSList_rid.bssid,
 				(int)BSSList_rid.ssidLen,
 				BSSList_rid.ssid,
-- 
2.20.1

