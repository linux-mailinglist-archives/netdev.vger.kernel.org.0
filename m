Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007BCFCE03
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKNSpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41336 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKNSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id h4so4333369pgv.8
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TxLlnJ4BoD9B2pwZqmboySs4KscSO6XXXhYyisKwIU=;
        b=Yhgj/vq+K/+BgF6v37h/l60TDGEItYnX6OCRofzkA61wbx49rVsGKH+4YsuHT2Uhnp
         4QpbcgT1wxH4xljcubgW+/bugWjNhDnNs+2gkJ2KTbc+Ei0sZYtYF4c8FK5Yl8U+uJaB
         G4KL+ATeMI5EFBbLr1HIFt0bE3yEfFN6BQkwQQZ30ww9FSJFrVx/o/+Nqoz7E9kQNQjK
         g7t4PFtSI2VgBFCmolQFS9rWrcy8bwypgG63oBwvE70CJ4greNJgg0fpu9XJuH7Bh8AB
         BzPosknm+rZTNH475+KpvoRmLpmDbrHeqqoixq0Lv0LkSnZy0KZRPHIYr83AXVB2IRk/
         N4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TxLlnJ4BoD9B2pwZqmboySs4KscSO6XXXhYyisKwIU=;
        b=nY7BJ5Slc8K3vzUL4mOJKfuVoNy64SvN75I5OL/5H+XJlB0mXtsIz2r9ZZlGv4wmxw
         aLogLvjoAS1iibvJM2jfJUUvzu9DGymlB/4nDUVgkQnq6RavAxQQPd6ryBgIXJ75qclv
         U6LC+i8efFqbsmAt6vSh1u6vyTH7G+3pYvq1NR1M8zcyuwgWdhyzp3p5sgnMfHnAK0C/
         17BpFZ9Zbe4WaElZNS2m1u9ONAleph3W4JDIIK0P9qeP9eMdr75otW5J4Q5rMojFjAfV
         iw0Oq/Kqx3E2pcQ+w+t33sBdvjXRhDlawfv09omFnuOBsmQef0CMrs3dVKk4dsPaG4C0
         dueA==
X-Gm-Message-State: APjAAAWLbpqgceL59REf1LXfkhi0SQiQnxInw5QfJe/KT7QpcmWz3cDN
        pjn03QQIQUhDzjVV7MEoWcd8iorG
X-Google-Smtp-Source: APXvYqwdUBwNxm3Oy7UhcAMIgUJqoM+tDDV+OBw4iaOzMUqv+8BqU++lw7P+Laz3rFiRtH1VW7yWXw==
X-Received: by 2002:a63:4d12:: with SMTP id a18mr11506093pgb.451.1573757110991;
        Thu, 14 Nov 2019 10:45:10 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:10 -0800 (PST)
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
Subject: [PATCH net 01/13] ptp: Validate requests to enable time stamping of external signals.
Date:   Thu, 14 Nov 2019 10:44:55 -0800
Message-Id: <20191114184507.18937-2-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 415606588c61 ("PTP: introduce new versions of IOCTLs")
introduced a new external time stamp ioctl that validates the flags.
This patch extends the validation to ensure that at least one rising
or falling edge flag is set when enabling external time stamps.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_chardev.c      | 18 +++++++++++++-----
 include/uapi/linux/ptp_clock.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 67d0199840fd..cbbe1237ff8d 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -149,11 +149,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
-		if (((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
-			req.extts.rsv[0] || req.extts.rsv[1]) &&
-			cmd == PTP_EXTTS_REQUEST2) {
-			err = -EINVAL;
-			break;
+		if (cmd == PTP_EXTTS_REQUEST2) {
+			/* Make sure no reserved bit is set. */
+			if ((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
+			    req.extts.rsv[0] || req.extts.rsv[1]) {
+				err = -EINVAL;
+				break;
+			}
+			/* Ensure one of the rising/falling edge bits is set. */
+			if ((req.extts.flags & PTP_ENABLE_FEATURE) &&
+			    (req.extts.flags & PTP_EXTTS_EDGES) == 0) {
+				err = -EINVAL;
+				break;
+			}
 		} else if (cmd == PTP_EXTTS_REQUEST) {
 			req.extts.flags &= PTP_EXTTS_V1_VALID_FLAGS;
 			req.extts.rsv[0] = 0;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 59e89a1bc3bb..304059b1609d 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -31,6 +31,7 @@
 #define PTP_ENABLE_FEATURE (1<<0)
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
+#define PTP_EXTTS_EDGES    (PTP_RISING_EDGE | PTP_FALLING_EDGE)
 
 /*
  * flag fields valid for the new PTP_EXTTS_REQUEST2 ioctl.
-- 
2.20.1

