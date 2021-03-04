Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0AB32D9D4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbhCDS6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:31 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8025 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbhCDS6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412da40000>; Thu, 04 Mar 2021 10:57:40 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:39 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:37 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 4 Mar 2021 20:57:08 +0200
Message-ID: <1614884228-8542-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884260; bh=DeOB9+NkbYAtogFD9xnt6dCwP9zWklALwJih4wOs3sA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=BKKPRim7isNSlXknLzDS2DNv7zQolpQH0aLi0LuXniFK+NsD4Qcrms4YjcxoP3fG/
         IGx1JtgiirpYXlwo4mqTXiMUtfxBHbpjS8DdFx82Ibe5xoHj5BnOi70cYV+8qmRgDo
         VHhKaYwQWHW9tZ/kVNW2+3Y1Bm0hSJ2YjLiHCOAOxUbag9/RvDzFHwXP3aP3foqVem
         TL3BBqFHtAEnUniTfUdqGq4C7Q1DYIPWKoszCWZ+EZwNv/3omL/iC31qZdAXqFPlWI
         J5SeH6f+p9YA797RV3VcY/FTxqoRojYSDpicCuWAiiUWPd2J74OCtApF6XfIylSmUB
         xWdcSWiWXP0wQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

In case netlink get_module_eeprom_data_by_page() callback is not
implemented by the driver, try to call old get_module_info() and
get_module_eeprom() pair. Recalculate parameters to get_module_eeprom()
offset and len using page number and their sizes. Return error if
this can't be done.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 net/ethtool/eeprom.c | 84 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 2618a55b9a40..72c7714a9d37 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -26,6 +26,88 @@ struct eeprom_data_reply_data {
 #define EEPROM_DATA_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eeprom_data_reply_data, base)
 
+static int fallback_set_params(struct eeprom_data_req_info *request,
+			       struct ethtool_modinfo *modinfo,
+			       struct ethtool_eeprom *eeprom)
+{
+	u32 offset = request->offset;
+	u32 length = request->length;
+
+	if (request->page)
+		offset = 128 + request->page * 128 + offset;
+
+	if (!length)
+		length = modinfo->eeprom_len;
+
+	if (offset >= modinfo->eeprom_len)
+		return -EINVAL;
+
+	if (modinfo->eeprom_len < offset + length)
+		length = modinfo->eeprom_len - offset;
+
+	eeprom->cmd = ETHTOOL_GMODULEEEPROM;
+	eeprom->len = length;
+	eeprom->offset = offset;
+
+	switch (modinfo->type) {
+	case ETH_MODULE_SFF_8079:
+		if (request->page > 1)
+			return -EINVAL;
+		break;
+	case ETH_MODULE_SFF_8472:
+		if (request->page > 3)
+			return -EINVAL;
+		break;
+	case ETH_MODULE_SFF_8436:
+	case ETH_MODULE_SFF_8636:
+		if (request->page > 3)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+static int eeprom_data_fallback(struct eeprom_data_req_info *request,
+				struct eeprom_data_reply_data *reply,
+				struct genl_info *info)
+{
+	struct net_device *dev = reply->base.dev;
+	struct ethtool_modinfo modinfo = {0};
+	struct ethtool_eeprom eeprom = {0};
+	u8 *data;
+	int err;
+
+	if ((!dev->ethtool_ops->get_module_info &&
+	     !dev->ethtool_ops->get_module_eeprom) ||
+	    request->bank || request->i2c_address) {
+		return -EOPNOTSUPP;
+	}
+	modinfo.cmd = ETHTOOL_GMODULEINFO;
+	err = dev->ethtool_ops->get_module_info(dev, &modinfo);
+	if (err < 0)
+		return err;
+
+	err = fallback_set_params(request, &modinfo, &eeprom);
+	if (err < 0)
+		return err;
+
+	data = kmalloc(eeprom.len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	err = dev->ethtool_ops->get_module_eeprom(dev, &eeprom, data);
+	if (err < 0)
+		goto err_out;
+
+	reply->data = data;
+	reply->length = eeprom.len;
+
+	return 0;
+
+err_out:
+	kfree(data);
+	return err;
+}
+
 static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
 				    struct ethnl_reply_data *reply_base,
 				    struct genl_info *info)
@@ -37,7 +119,7 @@ static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
 	int err;
 
 	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
-		return -EOPNOTSUPP;
+		return eeprom_data_fallback(request, reply, info);
 
 	page_data.offset = request->offset;
 	page_data.length = request->length;
-- 
2.18.2

