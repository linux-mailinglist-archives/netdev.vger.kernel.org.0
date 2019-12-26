Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2599712A9A7
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfLZCQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41337 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfLZCQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id w62so12533333pfw.8;
        Wed, 25 Dec 2019 18:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zXk4i0KLuY4F8k54STdAEaNIexx5qy18ypFiNvNJ2Q=;
        b=l6+PaU0eOVky+XIjhFUt4/UIPR3WM2ohcyOLe0l1XUdLBIrywfhD7HYWNR8b5oMwab
         1WMvDtCtZbKrPGLReHFTSCrs87+IQXHfGfYA/fBztRvOlf6668I2YvaQOQUQ+MkUUgvN
         j0Qtb0WAmfLxpMbUqYa8oixU7DEo671Q5g6NEfz+R6ZGHlcnj/vIuprvx+iarEDqkSpD
         rwd51GHDMy2dlZCOSITTcwz5Hp75/+JWkVUV6Z2/2cgsyIhLi029nuKJBNigFHKeev9s
         uRMV0/jJxNSv0qx6OJx4K0KPz34GEtRVASCsYFj4WWmrDdEisF8ZvDUfAU0H33sLzLgF
         cONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zXk4i0KLuY4F8k54STdAEaNIexx5qy18ypFiNvNJ2Q=;
        b=OBoRp7frlW4/Po3sTelhT+Jn2Gea5lJWYkr3VlrOj9ijuwKmrHuTtkv8Od+Ep2eec7
         08HsDgt6UApqDDOy6yCAmBvVgPzU/srymBPHZq20cmfJJB3bUXh5VeHA65JclmfY+IQT
         BfHoiGEXhZiGOPmhG2lEr4IbqrXWrSYM7gLRObLZpi7i24MWd4gcbi+o3CBaOO0WTlsb
         4RgCEHSxO/59sHMO8fM2eyRbG7cfhXvsxFhchRs8uvLBLJDDvtyuGr+FS+KeLW+T/uDW
         PtubFnb9bDwCzk+b1gU23k4p+YJo+nqFt+fcDRQwSfupwmbAl0z2s+ax34fFS+qrUN/t
         /Zrw==
X-Gm-Message-State: APjAAAWnBGTgoXpoDO5LY49TPlQc//wA2GkjGfrnVmtaaT+gFMv0Q6Pq
        Yw1LJZLMXLNCARxzbN6h1dxOQcqz
X-Google-Smtp-Source: APXvYqxjBgWS+n4zSdCVxaXCBkFaPa6/avY/087acctDAx1KFjxAlfKlt6x0C8XNCFVx7l1kRf5mGg==
X-Received: by 2002:a65:66ce:: with SMTP id c14mr47413769pgw.262.1577326598116;
        Wed, 25 Dec 2019 18:16:38 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:37 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 11/12] net: Introduce peer to peer one step PTP time stamping.
Date:   Wed, 25 Dec 2019 18:16:19 -0800
Message-Id: <6e42816f229f4c8688dd1f87335a7938cc030bb0.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 1 +
 drivers/net/ethernet/microchip/lan743x_ptp.c       | 3 +++
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 1 +
 include/uapi/linux/net_tstamp.h                    | 8 ++++++++
 net/core/dev_ioctl.c                               | 1 +
 6 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 192ff8d5da32..7343d7a28327 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15402,6 +15402,7 @@ int bnx2x_configure_ptp_filters(struct bnx2x *bp)
 		REG_WR(bp, rule, BNX2X_PTP_TX_ON_RULE_MASK);
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		BNX2X_ERR("One-step timestamping is not supported\n");
 		return -ERANGE;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ec2ff3d7f41c..4aaaa4937b1a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -920,6 +920,7 @@ static int mlxsw_sp_ptp_get_message_types(const struct hwtstamp_config *config,
 		egr_types = 0xff;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		return -ERANGE;
 	}
 
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index afe52463dc57..9399f6a98748 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1265,6 +1265,9 @@ int lan743x_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 		lan743x_ptp_set_sync_ts_insert(adapter, true);
 		break;
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		ret = -ERANGE;
+		break;
 	default:
 		netif_warn(adapter, drv, adapter->netdev,
 			   "  tx_type = %d, UNKNOWN\n", config.tx_type);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index f815435cf106..4c7f7a7fc151 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -247,6 +247,7 @@ static int qede_ptp_cfg_filters(struct qede_dev *edev)
 		break;
 
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		DP_ERR(edev, "One-step timestamping is not supported\n");
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
2.20.1

