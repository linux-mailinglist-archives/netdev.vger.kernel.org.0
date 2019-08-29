Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D19A23BF
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbfH2SRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbfH2SRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A4423405;
        Thu, 29 Aug 2019 18:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102672;
        bh=8s7uHJyYdr3pWYZ1sw1kll+haNg/5Bq+5TloACJDxac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCNJX3cmtTyJI/9saJPntRuz6jmgBB9f2ihp4ODcRbsgJD+uNqK8J6XAsjs1ddF7d
         6qAeRdwCVvI6MX48w5qiKGQEP7tcTFJ+EdAVTCo+o7BZAx/28CgbWzt3Q9qkWmPa3N
         g/yxSqj3ud4LTNoSVAZcl23SjXO6H73l8qY3VUTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/16] net: kalmia: fix memory leaks
Date:   Thu, 29 Aug 2019 14:17:27 -0400
Message-Id: <20190829181736.9040-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181736.9040-1-sashal@kernel.org>
References: <20190829181736.9040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit f1472cb09f11ddb41d4be84f0650835cb65a9073 ]

In kalmia_init_and_get_ethernet_addr(), 'usb_buf' is allocated through
kmalloc(). In the following execution, if the 'status' returned by
kalmia_send_init_packet() is not 0, 'usb_buf' is not deallocated, leading
to memory leaks. To fix this issue, add the 'out' label to free 'usb_buf'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/kalmia.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 3e37724d30ae7..0c4f4190c58ee 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -117,16 +117,16 @@ kalmia_init_and_get_ethernet_addr(struct usbnet *dev, u8 *ethernet_addr)
 	status = kalmia_send_init_packet(dev, usb_buf, sizeof(init_msg_1)
 		/ sizeof(init_msg_1[0]), usb_buf, 24);
 	if (status != 0)
-		return status;
+		goto out;
 
 	memcpy(usb_buf, init_msg_2, 12);
 	status = kalmia_send_init_packet(dev, usb_buf, sizeof(init_msg_2)
 		/ sizeof(init_msg_2[0]), usb_buf, 28);
 	if (status != 0)
-		return status;
+		goto out;
 
 	memcpy(ethernet_addr, usb_buf + 10, ETH_ALEN);
-
+out:
 	kfree(usb_buf);
 	return status;
 }
-- 
2.20.1

