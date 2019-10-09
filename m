Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495AAD164D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbfJIR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732221AbfJIRYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:16 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC812196E;
        Wed,  9 Oct 2019 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641856;
        bh=a+jnrrLUjZCnLTg1MYH2H3uUUeyvZnRqF6KjRTHV+GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a80hqOndue49JhE9aBAcvhgUtSd+2kXohLai90K5PFJxng0Ak0Mm4skb1uOwn+AzV
         d+pLBc7w8Xbqv24cwCgUtdKIoZGZHDwg/7X4nTN2tALigSnlpHc1NJG0ecjNGc45a7
         /VhK+Q46uz5VZUzSi8d9hc8lXyWTyvkVcZgc17yM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/26] r8152: Set macpassthru in reset_resume callback
Date:   Wed,  9 Oct 2019 13:05:56 -0400
Message-Id: <20191009170558.32517-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit a54cdeeb04fc719e4c7f19d6e28dba7ea86cee5b ]

r8152 may fail to establish network connection after resume from system
suspend.

If the USB port connects to r8152 lost its power during system suspend,
the MAC address was written before is lost. The reason is that The MAC
address doesn't get written again in its reset_resume callback.

So let's set MAC address again in reset_resume callback. Also remove
unnecessary lock as no other locking attempt will happen during
reset_resume.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a065a6184f7e4..a291e5f2daef6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4474,10 +4474,9 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
-	mutex_lock(&tp->control);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	mutex_unlock(&tp->control);
+	set_ethernet_addr(tp);
 	return rtl8152_resume(intf);
 }
 
-- 
2.20.1

