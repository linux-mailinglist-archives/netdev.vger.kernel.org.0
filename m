Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7B43627E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhJUNOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhJUNOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C3D6121F;
        Thu, 21 Oct 2021 13:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821940;
        bh=EKSxiCTHrf1sYq99nEa7eA9EPElWQmpoFWjzK0FaXeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpP7nuUcfRPO5cYlHdVthyFD+7YPfUvk42YfF5PrX79LEB8vK7Qn9cXOdI9i6FucY
         Y+9e+ce0oZ7djC6XgQHSfi6I/EgRJ66brYKOC4XFx72Bpb/AcIXde0BdkWQQdK54Hk
         957QiXpL40ic9QYntGWTPA4K6HHf/i4QaL8LvOHa2nT25cewL6CmD5CylGSi4Rrfo0
         GhSDjFNApHsVEQtJclv07hUqk7gf+xLiBO2N6VH8iBz7yTOu0fgkNnJeaihR0xPuBF
         s1BQfLkaPHUoqMsY4aTIug/+1ui6sMvVDhx4glPO84hmjn2hHxCNf43N09NBiWtQU+
         yHqItHUzJFbRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next v2 03/12] net: qmi_wwan: use dev_addr_mod()
Date:   Thu, 21 Oct 2021 06:12:05 -0700
Message-Id: <20211021131214.2032925-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: linux-usb@vger.kernel.org
---
 drivers/net/usb/qmi_wwan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 33ada2c59952..86b814e99224 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -835,8 +835,11 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* make MAC addr easily distinguishable from an IP header */
 	if (possibly_iphdr(dev->net->dev_addr)) {
-		dev->net->dev_addr[0] |= 0x02;	/* set local assignment bit */
-		dev->net->dev_addr[0] &= 0xbf;	/* clear "IP" bit */
+		u8 addr = dev->net->dev_addr[0];
+
+		addr |= 0x02;	/* set local assignment bit */
+		addr &= 0xbf;	/* clear "IP" bit */
+		dev_addr_mod(dev->net, 0, &addr, 1);
 	}
 	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
 	dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
-- 
2.31.1

