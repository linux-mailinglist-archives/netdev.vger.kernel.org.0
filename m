Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C8C120EFC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfLPQNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36393 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLPQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:44 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so5843959pfb.3;
        Mon, 16 Dec 2019 08:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=TrFE40ITLCxoPAiyTUiqO+ShYmcdqQrl6y+gaI+eo+QPW7jFLeMmFAjYpPYPpL7U2b
         dppQGAteXeqb2+EhBZTvjTvsgo3tihs6uVvu4JhrVyy/tdm/BeUnTBGj78uSrFHJTfb3
         olX1wzhBTzwhOKuwyxytUSdsBuHufZ29K95NgRGt4wNfjrZ7Vlmb/9LnYH7/kVOGlRi4
         dNLKxX7eGgwmQhjRczFROy4M7RMcBwRvJyeTiGmHJQ/q8ID+NqiQARfXA9CQDhhjR9br
         F3yCni67QjeVIHra+9HSMszY0/VPHXSgUbI+Wze3VvRd5bwsjyKLzTkJLfbMlgyHVCMN
         GQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=Z+Zqmk6OWsmdosr/D8K0b1EMy44vymOxgAk0fbDUSQ5vjR6fGNoHTRexoeGOXQ/KQO
         bES0NpDiKbjRu4l701g/Plij5240tRPfF/vttxecK8pxgz2jleIgPb+RT0mtPC6IJJN1
         IA6xiVUJSAdCcIrm/0ICYUAVkavCbKpEJ+JmuzbXskjl5DGpAxbbBXLdYSD0BXcJ0v1D
         AD64EgsaEwQu0GN40AGa0nE4ymC27HUKa+CUwTX7bWHxHXZof5QWI4nrhVfsmSAY/E2E
         LUvsfy1r+eUoreGBUjr+ntxlLvMWab2LoG7Bhj5j9M83T0xcnFQ5XioARwAurWL9p5q4
         8t9w==
X-Gm-Message-State: APjAAAWwwg2M/AQlGsPBw/6LdYasrvFqvlSB3jkF0DFWTl26Rihfw+7l
        hb2DZePZDe2PYi1/mtxRIpsg5+ur
X-Google-Smtp-Source: APXvYqx49qBhRUn2focEHjZcB7PW9jAFMgUh8g25YkVit8DmWaAtNURd8rYivhC80zLd/S+BPy+atw==
X-Received: by 2002:a63:d802:: with SMTP id b2mr19165478pgh.414.1576512823626;
        Mon, 16 Dec 2019 08:13:43 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:42 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 10/11] net: Introduce peer to peer one step PTP time stamping.
Date:   Mon, 16 Dec 2019 08:13:25 -0800
Message-Id: <9c41276a28ba81c3181cc07f8223562e889de2b0.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
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

