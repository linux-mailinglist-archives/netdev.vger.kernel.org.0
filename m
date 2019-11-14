Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AF2FCE18
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfKNSpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42140 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfKNSp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:26 -0500
Received: by mail-pl1-f193.google.com with SMTP id j12so3020002plt.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EgZP9Qg8jKjpYCoDh3oNRwu6jLyNFPvdVGbrs0P5gb0=;
        b=QKP/0O4PMONo3xuGbZDoiCP+GoyoTIvuu+fdiqkeYkxppDvBf5cHolmMn0r6KzxOwz
         KIojTVA54ky42bwHGtf7NSOZ9nVRu0zOkf+u3y7KbvOfERfoN+kZl+7UH0E3KU3MNgG7
         IiFOOPXKGxjscRIkF2pYkeGRmth5ABZK3mbXftYCS0dZDXfHXoKdVSPSc6T3HywHoMgW
         8jfTe4uNr/iWdPiz6XzKj6BRzVRqLd1end1+M5Aicszem0FHIkAWs3rTQLlQQcPUMgms
         zql7sulv+U9j50eYWjH5iyRVbdE1cMoj/wZi03mVkM/HmAjIo2sS/VPCqBEF4tbct521
         izQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EgZP9Qg8jKjpYCoDh3oNRwu6jLyNFPvdVGbrs0P5gb0=;
        b=NEPgOPrXnHr3d8MyvttrJ3umSkG8xhxIEAXylGAXcU1LsrXhRHAex6En3x7G9x7unW
         rFUt6O3sfRIrketmgP/Bh+Oc3lcV17Yxk6mL+EfqOmnft3EUHizq1/ohEKJjylHXhVg6
         P4+m1QQju9UK4QTpt5OCbgGBdTGCXCrjO6FDYpI9lEQ4Oa0DBS7Gbx7MGiqO5SI2/e2k
         cVPf+iwP+ZJ0IwFGM5OiCPgOB/9qrYsAHRHCdxtKkDQdKExaYjcWB//FZCkOucLASyRy
         RJT9mTWzHCOFK5x1BUqA1dMsBPpHrGP6cgNPEkluC78L5nDyWy8CSpOyvaxWvwNrbFvI
         dC0g==
X-Gm-Message-State: APjAAAXREWcFDyylW4940HhXi4cONxcOfglGcEkhTqRUPby2rZoo8MFV
        Zp5fGhGgV1goBdbVW+Ubaw1kScZU
X-Google-Smtp-Source: APXvYqwbWZHVJXyM6LwZqG93BFEVswnKFIib/1vA31agwuV1XgvHF/y2aw+qgyQO4OxTpj8+2SWDzA==
X-Received: by 2002:a17:90a:b109:: with SMTP id z9mr13948112pjq.108.1573757125454;
        Thu, 14 Nov 2019 10:45:25 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:24 -0800 (PST)
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
Subject: [PATCH net 11/13] igb: Reject requests that fail to enable time stamping on both edges.
Date:   Thu, 14 Nov 2019 10:45:05 -0800
Message-Id: <20191114184507.18937-12-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This hardware always time stamps rising and falling edges, and so this
patch validates that the request does contains both edges.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 3fd60715bca7..c39e921757ba 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -528,6 +528,12 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 					PTP_STRICT_FLAGS))
 			return -EOPNOTSUPP;
 
+		/* Reject requests failing to enable both edges. */
+		if ((rq->extts.flags & PTP_STRICT_FLAGS) &&
+		    (rq->extts.flags & PTP_ENABLE_FEATURE) &&
+		    (rq->extts.flags & PTP_EXTTS_EDGES) != PTP_EXTTS_EDGES)
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
 					   rq->extts.index);
-- 
2.20.1

