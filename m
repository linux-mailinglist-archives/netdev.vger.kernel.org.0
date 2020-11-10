Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B082AD26E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgKJJZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:25:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7623 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbgKJJZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:25:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVjC56z34zLrgq;
        Tue, 10 Nov 2020 17:25:37 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Nov 2020
 17:25:46 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
Date:   Tue, 10 Nov 2020 17:29:32 +0800
Message-ID: <20201110092933.3342784-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201110092933.3342784-1-zhangqilong3@huawei.com>
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
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
to decrease the usage counter when it failed, which could resulted in
reference leak. It has been discussed a lot[0][1]. So we add a function
to deal with the usage counter for better coding.

[0]https://lkml.org/lkml/2020/6/14/88
[1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 include/linux/pm_runtime.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 4b708f4e8eed..b492ae00cc90 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
 	return __pm_runtime_resume(dev, RPM_GET_PUT);
 }
 
+/**
+ * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
+ * @dev: Target device.
+ *
+ * Resume @dev synchronously and if that is successful, increment its runtime
+ * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
+ * incremented or a negative error code otherwise.
+ */
+static inline int pm_runtime_resume_and_get(struct device *dev)
+{
+	int ret;
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

