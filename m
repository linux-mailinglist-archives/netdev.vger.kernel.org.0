Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64031FCE07
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKNSpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:17 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41702 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfKNSpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:16 -0500
Received: by mail-pl1-f194.google.com with SMTP id d29so3016946plj.8
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5PpCROqLUVCSPUX0tvoqkWmvSCrAux1rzZqUUXzDoo=;
        b=cPhBmbIdmtQyfQF5AzbqYAvH2xoRj/40g6d2qV5pdY0c1+x9QJjtVhWv32MQqPBmNc
         Sk6GtuGCYW8VDpn/EN2UxzavB3UQ97D36VdcOf+oVrOKj8VG6hJUtXZo7kYhh/Y8TFKn
         E2uKmuVao6l+yWztnczXHEXRQt/NKrdxorFH7K+nk19Obb34h7PhMpC2hk6ewz8CAMxW
         Oc1q41H87UAMM/EpVkDyJAbTMcE1/bIjmru0tVvXGVBnd/vbvQwcp4UR+DE4Os4Rfq37
         fStGwklceIwevHB10wpqPsz8vj6wfNcplYtGBWKOGQiowq1zh9MttEduJM2LX+jcC9Lw
         7VUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5PpCROqLUVCSPUX0tvoqkWmvSCrAux1rzZqUUXzDoo=;
        b=YZEM42Vl4t5PhmG8OfFulEZdKIudCMhvSwVkZjKZX+yECmCmhly2WDmhKLggpLEVHu
         kR4M6q+CMeBbizIiHwBzl1l+d8jBOQT8UWIvG4bNL6yZ5wN3mI/URytlnnk9c3kMxI/C
         IVbf14iNjoi0E8jQNX6OpyfGDk/qlHS6JUiXJ2SWp84LnZgDWBWH7fP6yVsU0/U/t/Og
         Pv2kzTWCYBg5jHPZ2OZAPHivlk4COVc8/HNkqeYb9kPB410QGOjW9EckV5e9auPjjtXp
         iWXl5itD4NqNr4V+4XWWf+g0MthFxlzJ5SaWtLDbqoE+tu2iYZVppzdFYre7sg5Cc8IO
         SIew==
X-Gm-Message-State: APjAAAWFgxsmx696DwNTwUKWS3SRsQ3CPf0Kut0Bsw4YbTq4uCfQUJ7P
        j0KQgJmG56o3LXSzm6rNj1pzlG1c
X-Google-Smtp-Source: APXvYqxwXzvhDmITW4QOWmuk5/jUBwai9RuM5ACXa/w6RYjVf9/qTI18CLm1V501Va+erWE2fXAFHA==
X-Received: by 2002:a17:902:6a88:: with SMTP id n8mr637917plk.226.1573757115373;
        Thu, 14 Nov 2019 10:45:15 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:14 -0800 (PST)
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
Subject: [PATCH net 04/13] dp83640: reject unsupported external timestamp flags
Date:   Thu, 14 Nov 2019 10:44:58 -0800
Message-Id: <20191114184507.18937-5-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix the dp83640 PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

For the record, the semantics of this driver are:

  flags                                                 Meaning
  ----------------------------------------------------  --------------------------
  PTP_ENABLE_FEATURE                                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp falling edge

Cc: Stefan Sørensen <stefan.sorensen@spectralink.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 04ad77758920..2781b0e2d947 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -469,6 +469,11 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE))
+			return -EOPNOTSUPP;
 		index = rq->extts.index;
 		if (index >= N_EXT_TS)
 			return -EINVAL;
-- 
2.20.1

