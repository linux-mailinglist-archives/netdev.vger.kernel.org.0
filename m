Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3C8FCE08
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKNSpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:18 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39074 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfKNSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id 29so4342925pgm.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+ExKxfOT/Th93uAzKkGBPLkIVwaHS47X1LnIewKNKg=;
        b=Jx6Bgr7OwiyBrv9XwlgAsSg8fB3hGAJCkT+4nsx1I465GEmLhT1sx5CIbDJSvTaIuB
         rV40GkylC3E799Myh/jc1xnkP1is3JgGj9nx3thE8NwTfrLMn9lhNpPgYhi0HtUeTZ8o
         E31SPEoKaDSdlNTsTx+WO5Ya7twx45q1Nv+avQHMWf2B1zFViED/aQqpSqqWgLe79iTu
         fOTUxXSwEGLJbtLucVMN97twZZ3Myl47Fee4wdAK8bKph9Da8wDlf7odPiLEUCWTZfKN
         PboF1q2ZtOyGE9R1TvXvJ2EdR+otMhYBLM9D1LXZZ9T4544e8JJEoidmEVdxBKoEXacp
         q7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+ExKxfOT/Th93uAzKkGBPLkIVwaHS47X1LnIewKNKg=;
        b=bxFFexsj5oiWd44lmwnImfxBCLPdVsMzGebBSs4Qwb3W+xQWzd/hKalggXJ8cM3Cnw
         aio8a/k25SvSNgYOUkvEbCVH0R/ZglVfBcz+cZ5mOYKjIjUVfj3W3o4vxK/u91s1B1WU
         dMXHbNEm7RE79ux/J3QNDGFw+DeW+Pa2x2HqC6vDL9BpH3BSyMRG6t0b7XlklNl84Gnl
         ZI3X94/12VrILupRGe1bWhXBxUleOc9Qg3+Ye1VpEoE7qWSmiAFAkzrHF2DIji6aH68T
         jcgdQE469rFbrZu+ZC5E90C9y5ATmmlDQ3dLB6OjWiT6FRtLx1SlBhA/uxKmCNMqnBuu
         Ckvg==
X-Gm-Message-State: APjAAAUN1T00aMrXPu/VUhWsuIJCpjxaO2cnDDejHw85hri9e+JaDFl0
        Jtwsz9qJu+WLWSSsxIHdyYSP13wv
X-Google-Smtp-Source: APXvYqx3b14oHrv5YzdxYBi25JaKUfo00uMLj9uVDs6L3mpvlGNoXso0STPsIC//nadxvp49vaY45w==
X-Received: by 2002:a63:d901:: with SMTP id r1mr11706173pgg.328.1573757116811;
        Thu, 14 Nov 2019 10:45:16 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:16 -0800 (PST)
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
        Stefan Sorensen <stefan.sorensen@spectralink.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net 05/13] igb: reject unsupported external timestamp flags
Date:   Thu, 14 Nov 2019 10:44:59 -0800
Message-Id: <20191114184507.18937-6-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix the igb PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

This HW always time stamps both edges:

  flags                                                 Meaning
  ----------------------------------------------------  --------------------------
  PTP_ENABLE_FEATURE                                    Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp both edges

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 4997963149f6..0bce3e0f1af0 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -521,6 +521,12 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE))
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
 					   rq->extts.index);
-- 
2.20.1

