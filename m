Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7D1BFD3D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgD3OLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgD3Nva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9C720873;
        Thu, 30 Apr 2020 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254689;
        bh=Nh7gMGFbFDqRDU6KRwGLRELYcn+AP104P30Mc9SedG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ua0SLt/tnmOW2etG8W0WtrGyWNx+WnEccOpK+FiBClgfuIQw3CScxXeW/T95nC8i7
         EmCyI3JDwHQDpmlXe0dE/kyYTTZoJQz8feoo1mqBkAhSmXRBrR7MAIkRLcSPa+HEkR
         nA58g7kNBkJo0oxOBsc9JnbCXms3/CjtDp2RVHbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 40/79] wimax/i2400m: Fix potential urb refcnt leak
Date:   Thu, 30 Apr 2020 09:50:04 -0400
Message-Id: <20200430135043.19851-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 7717cbec172c3554d470023b4020d5781961187e ]

i2400mu_bus_bm_wait_for_ack() invokes usb_get_urb(), which increases the
refcount of the "notif_urb".

When i2400mu_bus_bm_wait_for_ack() returns, local variable "notif_urb"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The issue happens in all paths of i2400mu_bus_bm_wait_for_ack(), which
forget to decrease the refcnt increased by usb_get_urb(), causing a
refcnt leak.

Fix this issue by calling usb_put_urb() before the
i2400mu_bus_bm_wait_for_ack() returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wimax/i2400m/usb-fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/usb-fw.c b/drivers/net/wimax/i2400m/usb-fw.c
index 529ebca1e9e13..1f7709d24f352 100644
--- a/drivers/net/wimax/i2400m/usb-fw.c
+++ b/drivers/net/wimax/i2400m/usb-fw.c
@@ -354,6 +354,7 @@ out:
 		usb_autopm_put_interface(i2400mu->usb_iface);
 	d_fnend(8, dev, "(i2400m %p ack %p size %zu) = %ld\n",
 		i2400m, ack, ack_size, (long) result);
+	usb_put_urb(&notif_urb);
 	return result;
 
 error_exceeded:
-- 
2.20.1

