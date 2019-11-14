Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEC7FCE11
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKNSp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:26 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38468 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfKNSpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so4346469pgh.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0poRh66g/qqcAtxprleBKed73eICCEv6L8Oqc9jcrg=;
        b=miDGPt321IibkYm9srsINKjfZCosucoHt8gtkG+k7OX4GrhuTKA/j4l/Q6pXyiYoEU
         vnEcMx3/OqTBHAYzh/BEGEcBKyAUg/rpcivOFRCwbz+IphJg5lWYZR8rmGFAAAb27RlJ
         ku5qrWNtmE66LzaKsugPW8ZOZ7ChP3RbN0XaVlIjnmHhKiTJwOCgbbHtn8oqEeLKjcMW
         MHi4wQbrWuSE9qTcieRUDv2cB7E3O+7br0wbfhy//xEg7xbTi4yx7sjH4gK0FonNRDTW
         kvqlOX6FZD4+La2fO4iBYZ1CCxemvk502Qgz4/l7H0MYuTrwqZPkaLPwMZM6stcK+c70
         vBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0poRh66g/qqcAtxprleBKed73eICCEv6L8Oqc9jcrg=;
        b=ey1fU1h5cYHVuUZsIXZ1fINmKngdUhgevE+psLoNPgM4fzKXaCRGLgcC+6XhFhVvGg
         3hynPfA1qgqS10h+aQEvVH75QnxwFdGyvzv14rNPRw5UU0hv7V/+XPFIln4bx/8ND5Ll
         Z055BJ8FzBYYOrmLM9o5ehHkteAkj+O7Io3go9oqBC3lAAfZdpFkHfFMMy7JKDAbhYro
         k/TSIKiNXQhgrCNYAEDNM/JioQprLEVXznSWNLz2lOVWhQI7sRfd40CF2pR1tHZEfwM2
         sWSsE6Edhutp1gyL8ctJEeDTna+9BRuNJXkSSqBnMBgLzeZig9jeHhCaJ4BnVeYco2ih
         C6Jg==
X-Gm-Message-State: APjAAAVEE/YapsyNId1cZMRMII7fu/WZ8DcPhcO3YKnDsX9LFHzXBz7x
        ssXZvR2Iow9et8trvubeW7pM7fHr
X-Google-Smtp-Source: APXvYqyt+sDREmYpkh+77thPoRhBNaWyB0Ipzg5X3TtSKyogbAMclFXkc3Z+1wclRekRUL8UnSfYsg==
X-Received: by 2002:a65:6482:: with SMTP id e2mr8679115pgv.20.1573757123822;
        Thu, 14 Nov 2019 10:45:23 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:23 -0800 (PST)
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
Subject: [PATCH net 10/13] dp83640: Reject requests to enable time stamping on both edges.
Date:   Thu, 14 Nov 2019 10:45:04 -0800
Message-Id: <20191114184507.18937-11-richardcochran@gmail.com>
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
 drivers/net/phy/dp83640.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 3bba2bea3a88..8f241b57fcf6 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -475,6 +475,13 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 					PTP_FALLING_EDGE |
 					PTP_STRICT_FLAGS))
 			return -EOPNOTSUPP;
+
+		/* Reject requests to enable time stamping on both edges. */
+		if ((rq->extts.flags & PTP_STRICT_FLAGS) &&
+		    (rq->extts.flags & PTP_ENABLE_FEATURE) &&
+		    (rq->extts.flags & PTP_EXTTS_EDGES) == PTP_EXTTS_EDGES)
+			return -EOPNOTSUPP;
+
 		index = rq->extts.index;
 		if (index >= N_EXT_TS)
 			return -EINVAL;
-- 
2.20.1

