Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F826A8BB1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbfIDQEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731439AbfIDQDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:03:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FCF20820;
        Wed,  4 Sep 2019 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612996;
        bh=rng0vklXFVK0a4LP4agVcs4rvO5G2fgDSggZLO0gOwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQ/u77R5fGloaBXA34GIrjLs1bXZFWx4Z3LFUhsVMSrXicgbc2HxbFXIBmWDUDpQy
         YJIGROm0yxPmha5bYqL5o+xLBM+rmJQgfW2u4Q1j5pUDkMbaDQGE6xZXC0Wn/geAzg
         K/rvQ5qbJrHoa141u+1JEUUMfdZEvEzOBhbR4HHY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/20] r8152: Set memory to all 0xFFs on failed reg reads
Date:   Wed,  4 Sep 2019 12:02:51 -0400
Message-Id: <20190904160303.5062-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160303.5062-1-sashal@kernel.org>
References: <20190904160303.5062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit f53a7ad189594a112167efaf17ea8d0242b5ac00 ]

get_registers() blindly copies the memory written to by the
usb_control_msg() call even if the underlying urb failed.

This could lead to junk register values being read by the driver, since
some indirect callers of get_registers() ignore the return values. One
example is:
  ocp_read_dword() ignores the return value of generic_ocp_read(), which
  calls get_registers().

So, emulate PCI "Master Abort" behavior by setting the buffer to all
0xFFs when usb_control_msg() fails.

This patch is copied from the r8152 driver (v2.12.0) published by
Realtek (www.realtek.com).

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Acked-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2d83689374bbb..10dd307593e89 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -671,8 +671,11 @@ int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 	ret = usb_control_msg(tp->udev, usb_rcvctrlpipe(tp->udev, 0),
 			      RTL8152_REQ_GET_REGS, RTL8152_REQT_READ,
 			      value, index, tmp, size, 500);
+	if (ret < 0)
+		memset(data, 0xff, size);
+	else
+		memcpy(data, tmp, size);
 
-	memcpy(data, tmp, size);
 	kfree(tmp);
 
 	return ret;
-- 
2.20.1

