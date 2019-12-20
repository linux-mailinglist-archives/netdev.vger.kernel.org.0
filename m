Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD00128217
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfLTSPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:46 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38052 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfLTSPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:41 -0500
Received: by mail-pj1-f67.google.com with SMTP id l35so4477320pje.3;
        Fri, 20 Dec 2019 10:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=eboj4urtU5Fqn46J7jFD0hSJZmNeeR1Hon0KMReH2R5q9mTT7Jst3Q2PsMYCSXxig+
         GBRTtdonhRf0q7eQqK+2moeaB/daH7TqQVks+ocCjGiN1SNZBTgRyUf5WHwtnNfXsbmU
         5zSCVg/DeM2F7LTUAWqpgyF2XrznyQ3DC3zWyOkLtwqG6C1ot2YpHBj0T+Cv0w5xd9JO
         k03qZbjhMz54+I+sonFp6ZqjlYWK0VDry9ptg1eZ/00FzcBB7HPdawSeXVobZdvN4C6f
         tYn9wxplSnm47MqHmfzC6pVSe0jFRsczqrEwQpXgy+1Pnkk3Djt4cYyt6VnuUjZ0Z07V
         G3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=AqlxuLygcvlNDUx4cUJNCLfjgChL4uXq4EHS+F6uYCMVXyVHw7KjPRUHRW4f5zbWQr
         UscxsJyZ1PoJL68QhfLmohUtZ5cvZy+zk959h97eQbdOJ6J3jqDLRHB6sW96Nygy5DPx
         3YoIKxhfY6kf6T9Ckbr7LTyi/zNtzaNmPuwGtaW55I37XGfeT5tQvm+sp/lgBpWn5pVg
         mJDx3LhkD8LaHhPd2huUHYksmyx+aewCidl2ryRqyv1J50u2gPH7inDvfMsdLbN6AxtQ
         h7W3HKY6ShGDlKr9i+RtdPV4PWPhkaOwaqXGT2SrWSL4ARttNVf7b/mdonWNUSjd64Qt
         mtmg==
X-Gm-Message-State: APjAAAXhv7/s/P+ORJ30x4eT0SWqMEa3jsniHRyJrbvoGLtjjx3G46oX
        ySeITjQ1CzRoujGJox4sAUhqcIN8
X-Google-Smtp-Source: APXvYqwD2XOs4ZyTpaD0T0E9Bv2cF09T8gih1k0jgG7Ha3eCxYr6VrpeCQAlFNskKc04N6Mb7W0sqA==
X-Received: by 2002:a17:902:8343:: with SMTP id z3mr16297127pln.178.1576865740066;
        Fri, 20 Dec 2019 10:15:40 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:39 -0800 (PST)
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
Subject: [PATCH V7 net-next 10/11] net: Introduce peer to peer one step PTP time stamping.
Date:   Fri, 20 Dec 2019 10:15:19 -0800
Message-Id: <1cbca872dd1889567e603dd31a742df86b84715b.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
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
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 1 +
 include/uapi/linux/net_tstamp.h                  | 8 ++++++++
 net/core/dev_ioctl.c                             | 1 +
 3 files changed, 10 insertions(+)

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

