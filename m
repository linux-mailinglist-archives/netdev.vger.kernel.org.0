Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2431EA165
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgFAJ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFAJ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:58:36 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3209AC061A0E;
        Mon,  1 Jun 2020 02:58:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id q13so6812288edi.3;
        Mon, 01 Jun 2020 02:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Nr1ZQGFJaNCIty4ZNfUX5gFKPjZr6dIZsFLVA9cnaM=;
        b=QAmL93IoWB0IqtBNU2q+vDO9yAPP5kLIcVIzjnYBPV+/mJkMdQUAy7H8XGPlz+VL6G
         OZmyqP3IDvrXa6SRv2Z/apcjg5xF9l1f3mLc0JFu9IUMhopRQIf1P4Kyl0wO0j6rwoEI
         HhrlOumKQq7ufu4iGEzCWpvKblv4vLkxfOnagm71xFynz1eoZ0ZUWyCiTLC3l0Z3RgZT
         H7kxmIj0GSukQpjAnexQ8KZjTRkDqUiERdMd5bmfbFPpPo0lH9sJeDTi4RQBd+9btsz8
         dBJ7jmULCstJgh4lIKuNyZekBcXyTCsy/FPYCRx5AHf+96b7YkVzJ8aiylYwJrSMbJ4z
         MW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Nr1ZQGFJaNCIty4ZNfUX5gFKPjZr6dIZsFLVA9cnaM=;
        b=DC6Sr9qpFVZEnzFFJbch8iZL0PgRprwgWizTS5OocYQpiBQFn1R/NjLC82iOEbL6l3
         nAlGs/LATFtoJ0joOa+MZgPpWyQlk/JZMkR5JRpbxtSV+Uj8sP8fjgzPBPhxX4l2iVyd
         9g47XpiKjWrr462j3nvn7IfpiTUQh4P5qua1MjvuKiSd74h73ucplWMwn1TTa0Nw4kdP
         38KjwBsbefAJx+3VISEECK5fnkuwMmnDGAY5sNRZmQEEMgJiYzsn1W00/dcuMFHrfPSA
         kLZvihOYTOctypWEOb7jMr+8QCJQ00IuSUVFfSGxBrS+mdBUlUsj7i5Q3NNfc9dJmbCi
         WhZw==
X-Gm-Message-State: AOAM531RVVq/xeHeHoM+ZbBFuHzuynQGKrDCx8sjzCpe3XE4JGUbH8CG
        dXRoWEZhiGcCbYbVAO6fGKw=
X-Google-Smtp-Source: ABdhPJz4rtIRGhlGHeaV+hNLjqoUsCKfePs4vbXAFblZ0KYfrCLm0MB8HDK8XaONZvVn/ojg7R2F6Q==
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr10441815edv.40.1591005514858;
        Mon, 01 Jun 2020 02:58:34 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id k22sm7204065edr.93.2020.06.01.02.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 02:58:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org
Cc:     sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3] devres: keep both device name and resource name in pretty name
Date:   Mon,  1 Jun 2020 12:58:26 +0300
Message-Id: <20200601095826.1757621-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Sometimes debugging a device is easiest using devmem on its register
map, and that can be seen with /proc/iomem. But some device drivers have
many memory regions. Take for example a networking switch. Its memory
map used to look like this in /proc/iomem:

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

But after the patch in Fixes: was applied, the information is now
presented in a much more opaque way:

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

That patch made a fair comment that /proc/iomem might be confusing when
it shows resources without an associated device, but we can do better
than just hide the resource name altogether. Namely, we can print the
device name _and_ the resource name. Like this:

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
Changes in v2:
Checking for memory allocation errors and returning -ENOMEM.

Changes in v3:
Using devm_kasprintf instead of open-coding it.

 lib/devres.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/devres.c b/lib/devres.c
index 6ef51f159c54..ca0d28727cce 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 {
 	resource_size_t size;
 	void __iomem *dest_ptr;
+	char *pretty_name;
 
 	BUG_ON(!dev);
 
@@ -129,7 +130,15 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 
 	size = resource_size(res);
 
-	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
+	if (res->name)
+		pretty_name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
+					     dev_name(dev), res->name);
+	else
+		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!pretty_name)
+		return IOMEM_ERR_PTR(-ENOMEM);
+
+	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
-- 
2.25.1

