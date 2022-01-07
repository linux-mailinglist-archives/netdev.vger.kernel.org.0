Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671134879FF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348170AbiAGP4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:56:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbiAGP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 10:56:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35C0760C07
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 15:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C107C36AEB;
        Fri,  7 Jan 2022 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641571012;
        bh=ZPRl4WCSKkyFZlLbymbqoKstFwAvdj0Au27mNKz+k+s=;
        h=From:To:Cc:Subject:Date:From;
        b=BMPZV3xbzpwVfeV2JncTA9csUZvRq8LQapTeS7C98gHqgtEZFspdHwyX6FB4pIHAr
         nvryeQJ1iMKAniyR27tfXky8N7rUg6EflmRDwwvRZ35ve6s7tZAyh1AaPjR4Sdw57U
         TvR5TAFXfctGh9b+EzE9QFjp1YKuepwOAVsuBV86sGiHpbq09bZTQxYdkhID6ImSmj
         kE4VEqp1J6heH9E+XH/GF2IWmWl54wrUw7s9aa3zkQJAxmB+Swtl4tE7PyBVkzs8W2
         GIQ66lbs4+EtFyuay9Jd3bS9tZ4OVZGuecJgHbfV4UDhDiMFB/NfayE9DfGdhq8R/I
         bY/s+9iJPDY1w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        broonie@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ptp: don't include ptp_clock_kernel.h in spi.h
Date:   Fri,  7 Jan 2022 07:56:45 -0800
Message-Id: <20220107155645.806985-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b42faeee718c ("spi: Add a PTP system timestamp
to the transfer structure") added an include of ptp_clock_kernel.h
to spi.h for struct ptp_system_timestamp but a forward declaration
is enough. Let's use that to limit the number of objects we have
to rebuild every time we touch networking headers.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Previous posting: https://lore.kernel.org/all/20210904013140.2377609-1-kuba@kernel.org/
---
 drivers/spi/spi.c       | 1 +
 include/linux/spi/spi.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fdd530b150a7..dc9cf7fc8829 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -33,6 +33,7 @@
 #include <linux/highmem.h>
 #include <linux/idr.h>
 #include <linux/platform_data/x86/apple.h>
+#include <linux/ptp_clock_kernel.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/spi.h>
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index eb7ac8a1e03c..7ab3fed7b804 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -14,12 +14,12 @@
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
 #include <linux/gpio/consumer.h>
-#include <linux/ptp_clock_kernel.h>
 
 #include <uapi/linux/spi/spi.h>
 
 struct dma_chan;
 struct software_node;
+struct ptp_system_timestamp;
 struct spi_controller;
 struct spi_transfer;
 struct spi_controller_mem_ops;
-- 
2.31.1

