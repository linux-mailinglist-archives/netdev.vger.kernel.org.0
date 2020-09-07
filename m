Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1530126010D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgIGQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgIGQdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C2D21D40;
        Mon,  7 Sep 2020 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496432;
        bh=9pBF9ZbIvJKK5XQjnCwUnMHDSkOr58cnXFyuulM/huQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9Y6laXqrCjsf/nHNr0ealNnyo0pS/MZYxl0F/Ku2qm06/dDJ1u8NcyM+e4JOTvOG
         TzmNXc15VzorizREsOygaUJ690iq5aP3ch+JOARFi10OMRvRY9s0Sb8LRFLSz799VS
         FEFyTcYOc1Su6KOEaV3UY2jfT2U61HYiKnrx/zNQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/43] net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()
Date:   Mon,  7 Sep 2020 12:33:03 -0400
Message-Id: <20200907163329.1280888-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Himadri Pandya <himadrispandya@gmail.com>

[ Upstream commit a092b7233f0e000cc6f2c71a49e2ecc6f917a5fc ]

The buffer size is 2 Bytes and we expect to receive the same amount of
data. But sometimes we receive less data and run into uninit-was-stored
issue upon read. Hence modify the error check on the return value to match
with the buffer size as a prevention.

Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e39f41efda3ec..7bc6e8f856fe0 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -296,7 +296,7 @@ int asix_read_phy_addr(struct usbnet *dev, int internal)
 
 	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
 
-	if (ret < 0) {
+	if (ret < 2) {
 		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
 		goto out;
 	}
-- 
2.25.1

