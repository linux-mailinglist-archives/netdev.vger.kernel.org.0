Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED64FCE05
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKNSpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:16 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38451 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfKNSpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:15 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so4346221pgh.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJweYauEUzN1el5H7+jNKGxHUTrlFVlLLYMrPDFTPrw=;
        b=HmCxMPjYWo4iAoeAvkA0YrUNRCfDp1kQAfnh91Fp3uRWxaBE8edhI5L0TDjakPMYzV
         BrPSnGSnpa3jJwgggdbsPyazW2K26o2sJNohfKsVpf5zzr5ljGrOfaTNzonfZ7/oK/bs
         QuEdvxPcckNhDFqVg/yFdW4oTyA1V+6NLziwdH40RObMg/CDDFiZYLTCHvo8A7ZHQ0P1
         ULIScUZc89s9Z/ial9FcSnpjLnRVcV2vOsVoJaLaOo5ALiRcuv0K+dUcD6dUkcBZiIST
         kf25itJeHboIZnhkHRDHzcA7W1KCXMMh4Sj6s8SQFdCPiDbSfHz+MXOQkbXaXUXcmgB7
         rwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJweYauEUzN1el5H7+jNKGxHUTrlFVlLLYMrPDFTPrw=;
        b=ZNzAAHZP02sjgbRUVo5u+xMoikmq/Ub8eD7+yrzl4HlzQVSZFfwU/u+wwve5YO439j
         cUy0Z+1PDqjYXRQiTnvpe8Y8cKtO/DRDOUwC7ciphPgffEkQR/Juo/lj0EjqAPTpwiy3
         t/e/FfvK/Hf/AEbU6d/DzBvrrfMSjSYlBrj6tjfklY0DMrnUDYHAJeUjEzSBL4B7zReC
         RD6OkmruqavsN7umep/ny5N4ljp857Fdx7FWApHrDr6cgPacwjuCHjvE28Z68gq6/b1o
         4fnkS0Btzx2HgE4sx+Pj+xE/RUw5eKnCn7UoMZhW1WHwHCW4izKfTPQUelpO0edcQFLi
         re1A==
X-Gm-Message-State: APjAAAVD/I9ZbTRdEnqmRqCPMGI3QVogp+q57wuNr0NAkg9t//5U27tf
        7eg0KESaVUTSKHw/HCLsf0CW7zIi
X-Google-Smtp-Source: APXvYqzS8fKT7yamtldHOoBnAh+S2ZqlWam+5y5daaHTtrUwTXblAXw1esOngPaDfBJCQHEfoTdLFQ==
X-Received: by 2002:a65:678a:: with SMTP id e10mr11686445pgr.258.1573757113982;
        Thu, 14 Nov 2019 10:45:13 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:13 -0800 (PST)
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
Subject: [PATCH net 03/13] mv88e6xxx: reject unsupported external timestamp flags
Date:   Thu, 14 Nov 2019 10:44:57 -0800
Message-Id: <20191114184507.18937-4-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix the mv88e6xxx PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

For the record, the semantics of this driver are:

  flags                                                 Meaning
  ----------------------------------------------------  --------------------------
  PTP_ENABLE_FEATURE                                    Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp rising edge

Cc: Brandon Streiff <brandon.streiff@ni.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 073cbd0bb91b..076e622a64d6 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -273,6 +273,12 @@ static int mv88e6352_ptp_enable_extts(struct mv88e6xxx_chip *chip,
 	int pin;
 	int err;
 
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	pin = ptp_find_pin(chip->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
 
 	if (pin < 0)
-- 
2.20.1

