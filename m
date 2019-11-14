Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7AFCE17
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKNSp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:29 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37229 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKNSp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id z24so4352866pgu.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM3VhSbSiafPaH1zDTjChkDXYC3HNrrA8QbibO1hxSM=;
        b=lzBnyKi+bZrh9wnaaq2maczx3IdNblvCteLtfehTKx3USUsi/YgVJfiyYCoJ8FwIMx
         jOszlkQOPBv7oUwdNL8Ma5NbuZ+bjI3QDV6px/IrnsL5e6RCuFx3oOsdfp6j1U9CDcR8
         h/YeE5zFtvUhJ0VEzErb5aB1q9OoT5cNtWfgII8Y9T8svrTQFXe986Y8VkFnSeALS4Yw
         lQ6mVbFnm0M0RAwSzmgpheESK+M5m3Umdj90RlC5g40WdFfY23+aM4LzX9upCNousnQB
         rqiVruVT2CFyYElyNfOqGEjgwV4L3MonyDqs6OSUpLd/Kc4UCnLlshKb05zqAVsUDILM
         ir/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM3VhSbSiafPaH1zDTjChkDXYC3HNrrA8QbibO1hxSM=;
        b=cixo/gtRBs8fSll/WWCZnqre5SATTs03oy7tIYWzpdW1891DC2k+SE9hx/iVJDqs+4
         nk7gXhn8q9a3SuuTJlA/dj8C0ttKCrz3Wd14+hgDJ5IM9w98x/a1X8L26oMRUPA09YI/
         HJf/N2bHi5CXQzljUjotdhck3DanTkvA8O6Q6Ih0M6E4JGUJz/3jK1RAxndxgtHLC5ph
         bacsaa5yScP+OQoeDhI1z7YF8jcVbU2pmSEfQbIIKq3rBocMIUcdHFVbASRA8GdDR+Gr
         6SaZzBDcNvgy7x1EN9yGVWzBybDiruC/2yWo152BjPkQuhXT+75xlwP75Fm22YbE5LO0
         fdvQ==
X-Gm-Message-State: APjAAAX/YeQCQ3h4GtjjsktdbiYQ9rbYjwmauqJOdXFSs/T2fvy+M6jd
        PF5BYy3VuXs0z6HxTeFPmj48Um2t
X-Google-Smtp-Source: APXvYqziilQvp1gfUwYWyoR6VkMNhcHXbr/HTWJJBPcj/7VRsUUQYaXZldCvOUmsEfrY2kMf0OUFnw==
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr13996788pjv.139.1573757126814;
        Thu, 14 Nov 2019 10:45:26 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:26 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Christopher Hall <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: [PATCH net 12/13] mlx5: Reject requests to enable time stamping on both edges.
Date:   Thu, 14 Nov 2019 10:45:06 -0800
Message-Id: <20191114184507.18937-13-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver enables rising edge or falling edge, but not both, and so
this patch validates that the request contains only one of the two
edges.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 819097d9b583..43f97601b500 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -243,6 +243,12 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 				PTP_STRICT_FLAGS))
 		return -EOPNOTSUPP;
 
+	/* Reject requests to enable time stamping on both edges. */
+	if ((rq->extts.flags & PTP_STRICT_FLAGS) &&
+	    (rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_EXTTS_EDGES) == PTP_EXTTS_EDGES)
+		return -EOPNOTSUPP;
+
 	if (rq->extts.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
-- 
2.20.1

