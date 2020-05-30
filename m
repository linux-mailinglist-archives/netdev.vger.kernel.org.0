Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A061E9386
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgE3UGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3UGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:06:46 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15270C03E969;
        Sat, 30 May 2020 13:06:46 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id be9so4344045edb.2;
        Sat, 30 May 2020 13:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qMYm4gCDy0jA8FhDmI0VM/+E4QUpwC9SeAQPLfubsM=;
        b=SxMZF+XVe9FbMkdimvUhjH04ZO9i6emI1hJ9KfIfsaaq6iR3ddqbeoAcJ8OxbyxLqM
         J1lIXEx3ebgt4ifT0vQB+yo7gZbo1MRsn1N/e6XNLwHQMXIn/Hj9W6eDMZOeYBnDhiQc
         R71F3rJePssjbyb+y6x4oxNJcOw51WbKzs/S5i9TUF2gYIFhsnb3mPA3PQmINYhQLVtZ
         KyBvchMd0rS8Aeth834j0/3pjesFcwN6/VHhKnbTx4jG5zwuQ04e1Yk8LHZ+KmCNOs3G
         9fZay1rZTG2v6NGJCTMVCuvEZAeU/2i22UF6pr5z1N0wc/Pg24ltxu4+n9ClwUvwozHK
         qv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qMYm4gCDy0jA8FhDmI0VM/+E4QUpwC9SeAQPLfubsM=;
        b=gjyxKSYYul7F63qR/IBnCS+Cn+IZHh5m7W+1iK0dXj6DnyvfQMmLe3O+xToy09uUcY
         SnEPxV7vWcZdwdRtiJ1E9KtXrAZLDVDW6rnZWm35o/hn6qJpGsZ2GDf8aY0EyClMcV9U
         A4xU9V1FBB+SAr3s1ceVAW9Z6eeGyxghfv8RAZsVP8DPQJlHhZMP9tHsQh4ex/JkGUVw
         5OniT7+kzSaD5a6xQpG4IDiU+Ibtlw7ihmRgzWE5DUjbHx74SKy/oXhG0o/S9p7mAy63
         S8o9FMV9Q5lDdOuivpPfMoga2CphRAf5sIfLqevVR1QSf85KXnVztoBMb66yPAAQJPiF
         ntnw==
X-Gm-Message-State: AOAM5317VWtcDAQddeX/6RbzdzsWf3uvikJPFOaUWptncFHa6JZHr91O
        6pLFZDoG8MFwcCMyyWOvsZ0=
X-Google-Smtp-Source: ABdhPJyNp3mgVMzPaId5AbBQumweBorBHp8AIQI088ruzJ+/2boJUn0WsRWvg+3wSEhapgHTcMVzDg==
X-Received: by 2002:aa7:c418:: with SMTP id j24mr14717628edq.313.1590869204648;
        Sat, 30 May 2020 13:06:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id d5sm10767255edu.5.2020.05.30.13.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 13:06:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org
Cc:     sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] devres: keep both device name and resource name in pretty name
Date:   Sat, 30 May 2020 23:06:30 +0300
Message-Id: <20200530200630.1029139-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some device drivers have many memory regions, and sometimes debugging is
easiest using devmem on its register map. Take for example a networking
switch. Its memory map used to look like this in /proc/iomem:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : sys
    1fc030000-1fc03ffff : rew
    1fc060000-1fc0603ff : s2
    1fc070000-1fc0701ff : devcpu_gcb
    1fc080000-1fc0800ff : qs
    1fc090000-1fc0900cb : ptp
    1fc100000-1fc10ffff : port0
    1fc110000-1fc11ffff : port1
    1fc120000-1fc12ffff : port2
    1fc130000-1fc13ffff : port3
    1fc140000-1fc14ffff : port4
    1fc150000-1fc15ffff : port5
    1fc200000-1fc21ffff : qsys
    1fc280000-1fc28ffff : ana

But after said patch, the information is now presented in a much more
opaque way:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : 0000:00:00.5
    1fc030000-1fc03ffff : 0000:00:00.5
    1fc060000-1fc0603ff : 0000:00:00.5
    1fc070000-1fc0701ff : 0000:00:00.5
    1fc080000-1fc0800ff : 0000:00:00.5
    1fc090000-1fc0900cb : 0000:00:00.5
    1fc100000-1fc10ffff : 0000:00:00.5
    1fc110000-1fc11ffff : 0000:00:00.5
    1fc120000-1fc12ffff : 0000:00:00.5
    1fc130000-1fc13ffff : 0000:00:00.5
    1fc140000-1fc14ffff : 0000:00:00.5
    1fc150000-1fc15ffff : 0000:00:00.5
    1fc200000-1fc21ffff : 0000:00:00.5
    1fc280000-1fc28ffff : 0000:00:00.5

It is a fair comment that /proc/iomem might be confusing when it shows
resources without an associated device, but we can do better than just
hide the resource name altogether. Namely, we can print the device
name _and_ the resource name. Like this:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : 0000:00:00.5 sys
    1fc030000-1fc03ffff : 0000:00:00.5 rew
    1fc060000-1fc0603ff : 0000:00:00.5 s2
    1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
    1fc080000-1fc0800ff : 0000:00:00.5 qs
    1fc090000-1fc0900cb : 0000:00:00.5 ptp
    1fc100000-1fc10ffff : 0000:00:00.5 port0
    1fc110000-1fc11ffff : 0000:00:00.5 port1
    1fc120000-1fc12ffff : 0000:00:00.5 port2
    1fc130000-1fc13ffff : 0000:00:00.5 port3
    1fc140000-1fc14ffff : 0000:00:00.5 port4
    1fc150000-1fc15ffff : 0000:00:00.5 port5
    1fc200000-1fc21ffff : 0000:00:00.5 qsys
    1fc280000-1fc28ffff : 0000:00:00.5 ana

Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 lib/devres.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/lib/devres.c b/lib/devres.c
index 6ef51f159c54..25b78b0cb5cc 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 {
 	resource_size_t size;
 	void __iomem *dest_ptr;
+	char *pretty_name;
 
 	BUG_ON(!dev);
 
@@ -129,7 +130,16 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 
 	size = resource_size(res);
 
-	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
+	if (res->name) {
+		int len = strlen(dev_name(dev)) + strlen(res->name) + 2;
+
+		pretty_name = devm_kzalloc(dev, len, GFP_KERNEL);
+		sprintf(pretty_name, "%s %s", dev_name(dev), res->name);
+	} else {
+		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	}
+
+	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
-- 
2.25.1

