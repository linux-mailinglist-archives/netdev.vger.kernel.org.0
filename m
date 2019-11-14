Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341F3FCE10
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKNSpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:25 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43648 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfKNSpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:23 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so4324921pgh.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM0Xa5CiudMEuYb8SLKHiBcKyURm3GM8uH2aZPmH6I0=;
        b=sL6ewae8cqR2iO+Y3fQIcpw/lBi9VN+TvYmQIPf8SdGeqK1yvGsXEIOikxFGOthKP5
         Qi8JCFRJe0p3e6SDGszPrH3vPeZVbP/yxyiEt9uBvrwbVVclBrcbdNRKwFQ+3lkg7oli
         6eY1iAqbSnxGH4wbYockkaV+J9k0c99OR2u8D90WuGOt+/83fI6+y5X9Q0EM1puHm0uy
         CFSQG3v+cNFym/crT0bTl8nR/LQCrsIWqVWeCR/yVNLI/PhR/t5oE5Ptc9ctWa+jWWNG
         StO+vPb4gtiXltQZb/QnFGlepkR06X8Hq89Myn+iTaDGtW0IPfjdgeGo54WPWsiXo91s
         dnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM0Xa5CiudMEuYb8SLKHiBcKyURm3GM8uH2aZPmH6I0=;
        b=gSaZLRVbNAqBIBFtOMPA3SZIp0/VL9z0JqG1i97eepvPiPrRYj0bG3eDm+364pW25A
         SR0AyQZlfvKwh3zj5+1Q/rQAWbG5btumHbez96P/5A5mQ7Z+N5fw3McKKp0kW9W3kzPJ
         Rc+03Y6NZqR0/ecV1Lf+WhABa7aoudXXo1pFtsMsxH4OxNLan2TTNurXSQCeN8m3zw5m
         floUAjMEFWXyupJQ+UqG02ibLJtTRMA8Bw9AEyzuiYOuA+1eaHrZJjpxDYMq5jAqbA9y
         tIAO9f3+AvgR9qWvERLaoSQFEPqX4aEPCyMSUlhxuLZK7p0IoHZ3ceFZf3CSgCepcWsi
         ndhQ==
X-Gm-Message-State: APjAAAUkwoeTjtK0cbwQ/+WtTda0XfKyFifw3W54AG4UqeFf7M1DI1Li
        NjQ07EL9uas4CvAxiYz74Lxhg0Ua
X-Google-Smtp-Source: APXvYqyBqA+/yf0s54xrqKe3oPWTtSleHncUSgQ1wUUX2iDg3/6htOF9EV3okmf551jJuYXw92P00Q==
X-Received: by 2002:a63:7210:: with SMTP id n16mr11119972pgc.397.1573757122328;
        Thu, 14 Nov 2019 10:45:22 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:21 -0800 (PST)
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
Subject: [PATCH net 09/13] mv88e6xxx: Reject requests to enable time stamping on both edges.
Date:   Thu, 14 Nov 2019 10:45:03 -0800
Message-Id: <20191114184507.18937-10-richardcochran@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 3b1985902f95..d838c174dc0d 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -280,6 +280,12 @@ static int mv88e6352_ptp_enable_extts(struct mv88e6xxx_chip *chip,
 				PTP_STRICT_FLAGS))
 		return -EOPNOTSUPP;
 
+	/* Reject requests to enable time stamping on both edges. */
+	if ((rq->extts.flags & PTP_STRICT_FLAGS) &&
+	    (rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_EXTTS_EDGES) == PTP_EXTTS_EDGES)
+		return -EOPNOTSUPP;
+
 	pin = ptp_find_pin(chip->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
 
 	if (pin < 0)
-- 
2.20.1

