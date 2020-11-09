Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E02ABF4F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgKIPAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:00:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7506 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbgKIPAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:00:45 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVDgr5GkxzhfKR;
        Mon,  9 Nov 2020 23:00:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 23:00:27 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 1/2] PM: runtime: Add a general runtime get sync operation to deal with usage counter
Date:   Mon, 9 Nov 2020 23:04:15 +0800
Message-ID: <20201109150416.1877878-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201109150416.1877878-1-zhangqilong3@huawei.com>
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many case, we need to check return value of pm_runtime_get_sync, but
it brings a trouble to the usage counter processing. Many callers forget
to decrease the usage counter when it failed. It has been discussed a
lot[0][1]. So we add a function to deal with the usage counter for better
coding.

[0]https://lkml.org/lkml/2020/6/14/88
[1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520095148.10995-1-dinghao.liu@zju.edu.cn/
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 include/linux/pm_runtime.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 4b708f4e8eed..6549ce764400 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -386,6 +386,36 @@ static inline int pm_runtime_get_sync(struct device *dev)
 	return __pm_runtime_resume(dev, RPM_GET_PUT);
 }
 
+/**
+ * pm_runtime_general_get - Bump up usage counter of a device and resume it.
+ * @dev: Target device.
+ *
+ * Increase runtime PM usage counter of @dev first, and carry out runtime-resume
+ * of it synchronously. If __pm_runtime_resume return negative value(device is in
+ * error state), we to need decrease the usage counter before it return. If
+ * __pm_runtime_resume return positive value, it means the runtime of device has
+ * already been in active state, and we let the new wrapper return zero instead.
+ *
+ * The possible return values of this function is zero or negative value.
+ * zero:
+ *    - it means resume succeeed or runtime of device has already been active, the
+ *      runtime PM usage counter of @dev remains incremented.
+ * negative:
+ *    - it means failure and the runtime PM usage counter of @dev has been balanced.
+ */
+static inline int pm_runtime_general_get(struct device *dev)
+{
+	int ret = 0;
+
+	ret = __pm_runtime_resume(dev, RPM_GET_PUT);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * pm_runtime_put - Drop device usage counter and queue up "idle check" if 0.
  * @dev: Target device.
-- 
2.25.4

