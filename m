Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4872D53F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfE2F6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:58:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45256 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfE2F6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:58:12 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so660961pga.12;
        Tue, 28 May 2019 22:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=GxcIhrlmFBf9mOmiefMsTydTIcIJZ+e6Sg1Gxg/d15dTtJngBniNmQPIO/bFNR/23P
         c+kA5k/p508OIc+lmLSJ1l2ZhqSA32crjpPXa1WDEDYZv+jJSx9PZhiIyVU6jh77seTd
         RPtFCLIVngA3HIVfB2wfRVRxUMK5AcSzrp6ZFhiQ8//LFKxa7eM//5bYpzGZYJtblx1z
         bZX5FTNKRMzUsZ9cPt/0/qemtNDMgK3iomQ52MuruNW7SKwSHcDlH4C3UqhIKmyBEbPU
         OhFBvQIg2sNXTJztMhFKopvyLOJsk1Lu2gusAWfKwKkZB2pTWMSVBEeV2TdC43UD/hC0
         XUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=oWBegFu7tpVFx2Y+NR/JdUctxsQ/rm/LCm+xV/vEPK5ieJO5wp0Tb3GP8Q7xSU/Tqq
         MZf3At8d7MMJJsYUdv2Qbc1MbQKC8t0kCrVHt7wWdulPs0YKXNIgwJG8b7nNz8x4yjFh
         8Dwn3XrjY27JyPYR2jAJTqor0RYw47e9MAzP/RiN0cxxU/VKaI2kfwBe1I/tF0Qx5UeS
         avomEPnfKB4ygI/8QrMJ3onqlUPJNTnOM9ahHy5lBHNNomjpBB0OVyDG0bIvqc1PnAyz
         prCrU2Y8NMrOJmTlqiawKKjE/fu7POVryTIeBU94yhZmPrNzgtSstCwAk0BfveZJAKu0
         UB6w==
X-Gm-Message-State: APjAAAWsBJAX29fQg3bKxmHSgEi41M6CXNkP2XIkxgl3NB+WTA3DIWF1
        0xiIQxugihkamHtl3+5j4llxqiSY
X-Google-Smtp-Source: APXvYqwan9vmrE71O7sWw8Z0MTC7GKeUpMzh0DNYUZ5K4oe713CP6oEtKeuBdNLS2UmK5/Goyp41wQ==
X-Received: by 2002:a17:90a:d14c:: with SMTP id t12mr10116787pjw.120.1559109491260;
        Tue, 28 May 2019 22:58:11 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w1sm19093127pfg.51.2019.05.28.22.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 22:58:10 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V4 net-next 1/6] net: Introduce peer to peer one step PTP time stamping.
Date:   Tue, 28 May 2019 22:58:02 -0700
Message-Id: <0c508bcc9552a078451dbe3dd66580cc353b6fec.1559109077.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559109076.git.richardcochran@gmail.com>
References: <cover.1559109076.git.richardcochran@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 1588 standard defines one step operation for both Sync and
PDelay_Resp messages.  Up until now, hardware with P2P one step has
been rare, and kernel support was lacking.  This patch adds support of
the mode in anticipation of new hardware developments.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 1 +
 include/uapi/linux/net_tstamp.h                  | 8 ++++++++
 net/core/dev_ioctl.c                             | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 03ac10b1cd1e..44a378f26bbd 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15380,6 +15380,7 @@ int bnx2x_configure_ptp_filters(struct bnx2x *bp)
 		REG_WR(bp, rule, BNX2X_PTP_TX_ON_RULE_MASK);
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		BNX2X_ERR("One-step timestamping is not supported\n");
 		return -ERANGE;
 	}
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index e5b39721c6e4..f96e650d0af9 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -90,6 +90,14 @@ enum hwtstamp_tx_types {
 	 * queue.
 	 */
 	HWTSTAMP_TX_ONESTEP_SYNC,
+
+	/*
+	 * Same as HWTSTAMP_TX_ONESTEP_SYNC, but also enables time
+	 * stamp insertion directly into PDelay_Resp packets. In this
+	 * case, neither transmitted Sync nor PDelay_Resp packets will
+	 * receive a time stamp via the socket error queue.
+	 */
+	HWTSTAMP_TX_ONESTEP_P2P,
 };
 
 /* possible values for hwtstamp_config->rx_filter */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 5163d900bb4f..dbaebbe573f0 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -187,6 +187,7 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		tx_type_valid = 1;
 		break;
 	}
-- 
2.11.0

