Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473FE576AE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfF0AlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbfF0Ak6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:40:58 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D00F21852;
        Thu, 27 Jun 2019 00:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596058;
        bh=yQj7GRZcrGmqj0rAa2h+OxBqbAmyi4APGjFARM4z0DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqzCKYuPlOzVcapu50M8NF0vJpRYHlkfY018WgSoL3Zes3AvKfvMGJ60DJNeZDebF
         bpn66negVl9Hz8UBLLTEoCs4jDJ+kmrg2DGggZWQWfKy0b3A/yYbTzEJwhXmdB0QIW
         z+JYoMlVJ/MPwcDSQ17pqJn2kyZzZakyr/jmm3qY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinhard Speyerer <rspmn@arcor.de>,
        Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 27/35] qmi_wwan: extend permitted QMAP mux_id value range
Date:   Wed, 26 Jun 2019 20:39:15 -0400
Message-Id: <20190627003925.21330-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003925.21330-1-sashal@kernel.org>
References: <20190627003925.21330-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 36815b416fa48766ac5a98e4b2dc3ebc5887222e ]

Permit mux_id values up to 254 to be used in qmimux_register_device()
for compatibility with ip(8) and the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 4 ++--
 drivers/net/usb/qmi_wwan.c                    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index 7122d6264c49..c310db4ccbc2 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -29,7 +29,7 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to add a qmap mux
+		Write a number ranging from 1 to 254 to add a qmap mux
 		based network device, supported by recent Qualcomm based
 		modems.
 
@@ -46,5 +46,5 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to delete a previously
+		Write a number ranging from 1 to 254 to delete a previously
 		created qmap mux based network device.
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index a77223887022..65b1ea4f5baf 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -363,8 +363,8 @@ static ssize_t add_mux_store(struct device *d,  struct device_attribute *attr, c
 	if (kstrtou8(buf, 0, &mux_id))
 		return -EINVAL;
 
-	/* mux_id [1 - 0x7f] range empirically found */
-	if (mux_id < 1 || mux_id > 0x7f)
+	/* mux_id [1 - 254] for compatibility with ip(8) and the rmnet driver */
+	if (mux_id < 1 || mux_id > 254)
 		return -EINVAL;
 
 	if (!rtnl_trylock())
-- 
2.20.1

