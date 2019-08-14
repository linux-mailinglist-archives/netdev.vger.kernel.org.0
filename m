Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130358C7A4
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfHNCZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729979AbfHNCXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:23:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720242084F;
        Wed, 14 Aug 2019 02:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749432;
        bh=vvnmxWGe7xYwSO7HBkdkW6FikXeZlBPOXGfmicpzVMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZ9qul14ym2Cu6gluOicT1ZJbzDRK/XgWmpvhEd2es3PmzlngsPygTlvBRyb6LIMX
         sSlyxD+RSSKKgXXoLinz4HuJ19N5pyp1LNPaFnwOyu+jru2Gphjz7sWzXm1RWVjCC7
         KGNqHhLL70uvXD7fgG2nLpRZgV+EMcgV7iasuEbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/33] net: usb: pegasus: fix improper read if get_registers() fail
Date:   Tue, 13 Aug 2019 22:23:06 -0400
Message-Id: <20190814022323.17111-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>

[ Upstream commit 224c04973db1125fcebefffd86115f99f50f8277 ]

get_registers() may fail with -ENOMEM and in this
case we can read a garbage from the status variable tmp.

Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com
Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index ee40ac23507a0..5fe9f1273fe20 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -285,7 +285,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 {
 	int i;
-	__u8 tmp;
+	__u8 tmp = 0;
 	__le16 retdatai;
 	int ret;
 
-- 
2.20.1

