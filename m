Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040A741D8F1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350545AbhI3LlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350532AbhI3LlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4623CC06176D
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dn26so20828127edb.13
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4sGP3Guz9xCU5aSJe4hbX7plLMt6o+uQc/sFIGpykNs=;
        b=lVTl0VuLqcnuGzZrsw3T+eGWVh5SZ4sYwi2NWh02dCgPiqRj7O4ID77II+ViQHHrAb
         o2kXiK2BreR8nRscHOb6LqJ91fBF/s24DkQtQolKg1CvvuSt6fI0Zl3wkfAgCt4e86+l
         9wqATRO4IX18gjzfdv7zV8l0ikiNHTezHozl1ZG60+0pUGJyh0Po5y4bglCGUwfL0Fb4
         t0hYxIWs1BDyr9VJhgtfANwIPdPJkTOh6zHgAjg/N2J/omiNTPxupZ0EnLAO0Gc4tDK/
         A7ClmILcDO89DRdGrtLDQiZhFB7tYyKsAOscwPzwbK7OV047KXnK9v/JLaMQ0oFGoTr2
         pYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4sGP3Guz9xCU5aSJe4hbX7plLMt6o+uQc/sFIGpykNs=;
        b=KbzdT4PQrMe2oZSNxSFCnwI3OAfJ+az/RzUAjjZyXsqcIC932/ppTn+ag1RfqAwFzR
         7PJtd/jI8DArKg4d8wuMf+CH9sQdhodPl0lM7WJgCsXx0HmSAmmzBR10XyNEhm3xiziK
         Vk6f/+ZHhUN5MiniTNSPoSGaA5GlPWRmQQyc8P+u7RQr1dLevIogQraWp9A/0tnG1dXa
         jO5ULTrWWACnwmG9wKRXa7LlTfQZW/755o8TVBKJEBCN64nUBWQ/1RSaRJ1Zay3OVqUy
         amXTkRk3JFIGxM5yQdDbnB2l/uos5gl15+n1KBJSdBdy9FBTqjebsG/23MUk/Q7LlMe7
         c+8A==
X-Gm-Message-State: AOAM532XTcTb44elT7ACQDjMnVYslxQaPJxm6UUrJq++GBDTsWIhF/29
        +LOADLw1XJgvim+iNJAXy3KJTi152mQOxOhH
X-Google-Smtp-Source: ABdhPJzhN4SuWWv3LN/v/Qiyy4aAb3Nb4Aq0pnbaWvT7U3Z0tU4xFy7LYhdFKqhKk/2NEKZ9I5P8Lg==
X-Received: by 2002:a05:6402:42d4:: with SMTP id i20mr6632560edc.348.1633001966556;
        Thu, 30 Sep 2021 04:39:26 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:26 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 03/12] ip: nexthop: add resilient group structure
Date:   Thu, 30 Sep 2021 14:38:35 +0300
Message-Id: <20210930113844.1829373-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a structure which describes a resilient nexthop group. It will be
later used for parsing.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/nh_common.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 ip/nh_common.h

diff --git a/ip/nh_common.h b/ip/nh_common.h
new file mode 100644
index 000000000000..f747244cbcd0
--- /dev/null
+++ b/ip/nh_common.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NH_COMMON_H__
+#define __NH_COMMON_H__ 1
+
+struct nha_res_grp {
+	__u16			buckets;
+	__u32			idle_timer;
+	__u32			unbalanced_timer;
+	__u64			unbalanced_time;
+};
+
+#endif /* __NH_COMMON_H__ */
-- 
2.31.1

