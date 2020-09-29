Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD27D27BA05
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgI2Be7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbgI2Bba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C77DD221F0;
        Tue, 29 Sep 2020 01:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343073;
        bh=jCAJpA4MoOkk1Y3avzyE2lD63xoo8nkUKvGvEriN85g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLavY61MYerQcOgGrADRa9hSLRej/aL0v9BYn875PlSKO9jWdek5ox0ARWw+L98ob
         HmlOAk/sCDNhgmQIicyTav0TBWLQJDctTirCCP+KepxeE+l50kVXuXxrV+7iFlbjab
         xMjypz+nmUw7meRtjbuRdshTjmsmMK8oJCBymdpM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olympia Giannou <ogiannou@gmail.com>,
        Olympia Giannou <olympia.giannou@leica-geosystems.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/18] rndis_host: increase sleep time in the query-response loop
Date:   Mon, 28 Sep 2020 21:30:52 -0400
Message-Id: <20200929013105.2406634-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olympia Giannou <ogiannou@gmail.com>

[ Upstream commit 4202c9fdf03d79dedaa94b2c4cf574f25793d669 ]

Some WinCE devices face connectivity issues via the NDIS interface. They
fail to register, resulting in -110 timeout errors and failures during the
probe procedure.

In this kind of WinCE devices, the Windows-side ndis driver needs quite
more time to be loaded and configured, so that the linux rndis host queries
to them fail to be responded correctly on time.

More specifically, when INIT is called on the WinCE side - no other
requests can be served by the Client and this results in a failed QUERY
afterwards.

The increase of the waiting time on the side of the linux rndis host in
the command-response loop leaves the INIT process to complete and respond
to a QUERY, which comes afterwards. The WinCE devices with this special
"feature" in their ndis driver are satisfied by this fix.

Signed-off-by: Olympia Giannou <olympia.giannou@leica-geosystems.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rndis_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index bd9c07888ebb4..6fa7a009a24a4 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -201,7 +201,7 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 			dev_dbg(&info->control->dev,
 				"rndis response error, code %d\n", retval);
 		}
-		msleep(20);
+		msleep(40);
 	}
 	dev_dbg(&info->control->dev, "rndis response timeout\n");
 	return -ETIMEDOUT;
-- 
2.25.1

