Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FCC1E99CA
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 20:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEaSIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 14:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgEaSII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 14:08:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E011C061A0E;
        Sun, 31 May 2020 11:08:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k8so5582640edq.4;
        Sun, 31 May 2020 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRNzXlDsLeQ6UqKHVVyEnlF0fqK/zXLoqhFyK6Pdqyg=;
        b=jnWfK5zTLldATkZtCg9IxyO6NTehJ21NP8wqKGiI9OMyuihvbakB7RLb3B8Bbu0Ch/
         QM8hNDjuiS2ChKR7r6O8NcWT4EaL6Hi0kg7od8eqfXGaSOMY74hc+mqH9oxeSutvvTKm
         yUzN6BIDuYEukeG31Uy9tGlb4eMomrSOH/ibq4qiGppT9EIw17lQdB24PWCqAsyMxIGM
         r2VVdm7hJNe+1PVd+1gE6f238NxQ0xeBHuUeJHw0eb55HZDJ3hVbmXDRjCdwKHqMoyh6
         mjpmkMTtxo95UKmn0BPTwBScagE1NHsxjSsdWHSSApTwDzARUsAsGOV5akUQRsHTtC43
         Gdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRNzXlDsLeQ6UqKHVVyEnlF0fqK/zXLoqhFyK6Pdqyg=;
        b=queCoJhW35X2tTXzyVcECySDGA06/pul3iI9yXAK3QI325TnoTYqqx/styMhppWAJG
         R7GqEBWUCUfquo72Z4ooySPniIOkEkf3O8qKk9+hdGiPN7nBE4EObjEMmmD5XdVJKOeD
         vTXdcpe/cfKyzqj8i0sl8eIGKZyqGIAum4mhyiJkP7KoRyPRs9YkYdsFmxbrQvN5NumX
         GktHM0Zl35wVdmq54gnGixesMcw/vrItxTFCrMJXcV60alTRT2t+6Fm9UCeV25az8OhL
         rWPknFKyyp1SVx3RJ8Gd3p9hpS3rhR4Qz5AUe5vQhn38I5AJMMkF/TZymJZ290X6fLBh
         JMvA==
X-Gm-Message-State: AOAM531C82MLFUpjRi8nlrTpuwNt6Q2uzm0LIrusvtjnP/6SflrLAFAJ
        smaZMOClczqkdEqBQv9Xrow=
X-Google-Smtp-Source: ABdhPJwvGLIbgx5w0EkUAG/jnAnBYFOVCGmAVK3Y6J8U/v8A1dmKsm7zWPGz7BdUbTLcmAtlW/d6dA==
X-Received: by 2002:a05:6402:1d30:: with SMTP id dh16mr17543081edb.302.1590948487216;
        Sun, 31 May 2020 11:08:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id u23sm3461018eds.73.2020.05.31.11.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 11:08:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org
Cc:     sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] devres: keep both device name and resource name in pretty name
Date:   Sun, 31 May 2020 21:07:58 +0300
Message-Id: <20200531180758.1426455-1-olteanv@gmail.com>
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
 lib/devres.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/lib/devres.c b/lib/devres.c
index 6ef51f159c54..3d67588c15a7 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 {
 	resource_size_t size;
 	void __iomem *dest_ptr;
+	char *pretty_name;
 
 	BUG_ON(!dev);
 
@@ -129,7 +130,21 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 
 	size = resource_size(res);
 
-	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
+	if (res->name) {
+		int len = strlen(dev_name(dev)) + strlen(res->name) + 2;
+
+		pretty_name = devm_kzalloc(dev, len, GFP_KERNEL);
+		if (!pretty_name)
+			return IOMEM_ERR_PTR(-ENOMEM);
+
+		sprintf(pretty_name, "%s %s", dev_name(dev), res->name);
+	} else {
+		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+		if (!pretty_name)
+			return IOMEM_ERR_PTR(-ENOMEM);
+	}
+
+	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
-- 
2.25.1

