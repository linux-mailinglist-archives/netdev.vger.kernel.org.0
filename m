Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B17DFCE0E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKNSpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45609 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfKNSpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id k1so3027536pgg.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xN6Ff/rEmda33ktJVzl9KCXqa8Sx0iaIjbPXMuf+NBQ=;
        b=AlEKTmOxNzExN9wdwBJvmv0HnbxXq1IGPPAOjrul0f//SeZAyapcuM+wRs24y3ZSfJ
         N146GR1cZ5+UBaUA2yGMWpQZ4x3dD31x4WG93L34XXvtjSng4ZWYZVitWj53MvFlSCml
         NYVbAHg6RkS6z2BOwCv/hUA5fGn0JOFY8tvv/VDBdhHFRJPeZxVyJzpD7kZF1LlCt/F4
         uIL2Z8Uo+geC/x/dUQdwJ8lB23Wqypbn2AEXSCnlulaZp8sJ6bJVcd9FHFZ27IglZH32
         lyholkefIYZEkqBz56FfeRjNL+UsNakB+6klomVEldPPZumS3tyvQH4W321erYo3iH4T
         1xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xN6Ff/rEmda33ktJVzl9KCXqa8Sx0iaIjbPXMuf+NBQ=;
        b=jNfVmvVvoLcnLdsI3wY27lXV3Sg/8CNi/zytXo/IyhY29HcB5ZLYv2QwjTlBEtTLhl
         qKqtkc4rX+XpESn2dQ8fQausT3yLuZMEuAqo1N+QMifu/kwKfA5SZ65sRLfQyV6nXfxr
         oKe98Wr0h3G376SXmt4z41JM5qXR47PT15aNkJUknIeD2C+smlsvcwurW8ZCH07E0zmw
         2bUDBHihAjo5aZpmRN/icCRbvk3OQGA9VNQPs5A4prs5ciPz/GVh9Br7EfoLNQrDn0Rd
         PYDJDQ8AsEyiB/0J1wvhzIKuzdpoh7aMZxGtuH64hGYt9IGPxlcwzJ3j4Xn+fmw9KWkq
         1+xw==
X-Gm-Message-State: APjAAAXM3gvSC6QPs+2mKwEeJlmOclyXuRhJpidsxAU4pH5uYPrFo1Gt
        3oIOw5g8mVReZhFV62L/a7GwgoUa
X-Google-Smtp-Source: APXvYqyDM6CBaERu9pdWS5TIezYmH40TxWm+Pok5B/6Lxu+q5I4mi1XpJkzUaRDheD35nYOcra1FHg==
X-Received: by 2002:aa7:9432:: with SMTP id y18mr913814pfo.250.1573757119716;
        Thu, 14 Nov 2019 10:45:19 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:19 -0800 (PST)
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
Subject: [PATCH net 07/13] renesas: reject unsupported external timestamp flags
Date:   Thu, 14 Nov 2019 10:45:01 -0800
Message-Id: <20191114184507.18937-8-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix the renesas PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
 drivers/net/ethernet/renesas/ravb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 638f1fc2166f..666dbee48097 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -182,6 +182,12 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
 
+	/* Reject requests with unsupported flags */
+	if (req->flags & ~(PTP_ENABLE_FEATURE |
+			   PTP_RISING_EDGE |
+			   PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	if (req->index)
 		return -EINVAL;
 
-- 
2.20.1

