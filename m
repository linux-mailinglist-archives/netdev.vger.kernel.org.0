Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6362DFCE0A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKNSpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42130 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfKNSpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:19 -0500
Received: by mail-pl1-f195.google.com with SMTP id j12so3019831plt.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsKoGi0FAC/KrsCxzqHSC+UAZbZLyyk3Sb9n5a/c8+M=;
        b=UF7sT9Huk8CwaoJ/o40DDCTT/XQXjkRS/Kkm9BTkDPq++KwOvvi7SjA3kI4g1gV//E
         8zyDRdmJcBKoEwbeZFLPX+ZWyeMO9Cgn7ASWB8f8qTEGJB/MR4xc8JfTbqhu/u71ydRo
         bMrjIqT4CQ7a7pwFX0QyUXEyWeC/RQg7200s9OY7X4zPlnMqMLPKxABcttFK1hOL5NnC
         KiodeB6VYv4LEiBiDk+KbKpy45MPT5G+PzU/rXv18b+75ZGmvhyJKjEsJtIKRRJSzm5+
         l2IdXNpUvOs2ig0EuIcNIcvjn8mKWySh3g7VQ+MAkWyZsx8AVe/UTtbieL3eLjtS/5yN
         AjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsKoGi0FAC/KrsCxzqHSC+UAZbZLyyk3Sb9n5a/c8+M=;
        b=qujvHfQyyRyVlSZaMPQogGbBUVBd3JAOti4Cu1HToedfUpgpKOpOeN86wry1IJLpWs
         rzUQ+9iqK0632r7M3a6s5/oUxh5cEK7V2gTW7aStIimFrJKY9LVJJxPD6vkZCvgrDQBF
         zX4/2EI26LbOuqe7KK5ua4fe77P6taBjV6N7gIbeqVFuLKoQxgLTe0SrW9i/Lnyz+aZT
         dmPz955mizeMGrZO2EwznVSakcFSxLF34C+TM37JTUtx1K6uPo76x5CTtQP1t/fsaGgg
         JfW6hB67B+zN0y+MU88By9dq63CkktOUmkzLs3JUSMHu+7TOPbkdgKeM7LCDQt5gtzGX
         kjrQ==
X-Gm-Message-State: APjAAAU4qWnMMIU78+q4wndV4JEuEKnpDUSeM1GRxqqoFievf3aVB8S/
        yr9k6cpIl9d/we2zCVZIeRj3cEZu
X-Google-Smtp-Source: APXvYqwhciTpKJzbRyHRYFGGedeC3yTKw8ODZa10zfyFovb9ZxO8M1O59zcAlG4HNhdnokF2i5QCYg==
X-Received: by 2002:a17:902:b702:: with SMTP id d2mr11057777pls.104.1573757118249;
        Thu, 14 Nov 2019 10:45:18 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:17 -0800 (PST)
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
Subject: [PATCH net 06/13] mlx5: reject unsupported external timestamp flags
Date:   Thu, 14 Nov 2019 10:45:00 -0800
Message-Id: <20191114184507.18937-7-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix the mlx5 core PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

[ RC: I'm not 100% sure what this driver does, but if I'm not wrong it
      follows the dp83640:

  flags                                                 Meaning
  ----------------------------------------------------  --------------------------
  PTP_ENABLE_FEATURE                                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp falling edge
]

Cc: Feras Daoud <ferasda@mellanox.com>
Cc: Eugenia Emantayev <eugenia@mellanox.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index cff6b60de304..9a40f24e3193 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -236,6 +236,12 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	if (!MLX5_PPS_CAP(mdev))
 		return -EOPNOTSUPP;
 
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	if (rq->extts.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
-- 
2.20.1

