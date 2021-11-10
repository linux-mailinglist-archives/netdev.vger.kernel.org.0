Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4D244BA4C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 03:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhKJC0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 21:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhKJC0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 21:26:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B38C061764;
        Tue,  9 Nov 2021 18:23:37 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c126so1293838pfb.0;
        Tue, 09 Nov 2021 18:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hi3UyLz4FDGsulwQ2yrywXyu+XWYJmVes0wEr2hSCPY=;
        b=Ke7KTwjvqtlzvHql0SpyyBrrUxrU/qzaYWBsQXEAGd4/OGVHeoN/IJEu4fYZ5Rz6XC
         BJ5LU0ssTGo01Xx7tFYnPT4dmEhfv7j6GpdSq3Y4Y/HYzHfcx8xCjUfMl//Bp05/nIh+
         epwyYVhigBHCeExEI4rkTbZ+TnyKFMc6WzUHswW4xHwjo48Fv+o84du3+y2SIrP9aaQ2
         qR9p0ooObPxXZJwVfIrs0IotBx0QcsR+pvsCR8ucNZcIFQPUYTH3RjTCD2ZuIH20MTp3
         l1bCUo5uEkxQ8kHS3E6T0cboj1IFKHWjZCbP4r+ny6MpScLDHmFBU1QmfEDPVzCay+dZ
         h6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hi3UyLz4FDGsulwQ2yrywXyu+XWYJmVes0wEr2hSCPY=;
        b=ozDdzyESkQVWi5QEnKinXopu6IAN62YZDzIqyO7Ie037RZkRi4Qbv/u75E9yWhewNl
         rBz3O3DgAba8ggCO65Pd7iJfwFErY1iO/RUnbGR4hdoFRfKbdBhugctpQwP0f2dhqPgq
         afr4hnCNqKuC5CzBXB+VAqNs4gxUB6bRSdPMp9chg4epkRRH6441DI0p657qD9MOZ5Bj
         g+AzPWKIu2qDQkTY3QRIxdpWWlATEVSJodVoKztXGK68ioQzpTpKDSpue/SOwQojKGIk
         /HKnoq7u4eovN0zfFM9gkVHZULE5Ai2nd4kwMaKZSS4sfwV6I9CBpr3ogmT9wijl8ciq
         5Uxg==
X-Gm-Message-State: AOAM530Qlnm/fyFefan8KGD48p/4eD5h9CkV8fWQL+sk6y9Z+dGZwjeA
        lcPWqIYcQ0hJsrcneQx8dUMVavngUlE=
X-Google-Smtp-Source: ABdhPJyZbW4lvRrf8kvt5Uliksk5/rclO97Q7I7KvfRBsVY/56QS5qBNEk9HMbqQ4oHDDdXoO8hibw==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr9711205pgd.86.1636511016629;
        Tue, 09 Nov 2021 18:23:36 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y9sm4013055pjt.27.2021.11.09.18.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 18:23:36 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ptp: Replace snprintf in show functions with  sysfs_emit
Date:   Wed, 10 Nov 2021 02:23:31 +0000
Message-Id: <20211110022331.135418-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/ptp/ptp_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 41b92dc2f011..867435df912a 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -86,7 +86,7 @@ static ssize_t extts_fifo_show(struct device *dev,
 	if (!qcnt)
 		goto out;
 
-	cnt = snprintf(page, PAGE_SIZE, "%u %lld %u\n",
+	cnt = sysfs_emit(page, "%u %lld %u\n",
 		       event.index, event.t.sec, event.t.nsec);
 out:
 	mutex_unlock(&ptp->tsevq_mux);
@@ -387,7 +387,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
-- 
2.25.1

