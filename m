Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB3128B22
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfLUThC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:37:02 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43809 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfLUTg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:58 -0500
Received: by mail-pl1-f195.google.com with SMTP id p27so5532384pli.10;
        Sat, 21 Dec 2019 11:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=X325lpMWT/wOdHHeM+FSu6A0zveoZlGY5BZAcWyb0fL/oQm0D0UP7jhdWzKYt/XXcE
         WBDnZSWa9aNoXKo8skS+BeEBXHNhIBp6Q+O/e2ZNcBvJkWNS74KOETibv6/9YZC+Diql
         2F/EFNQo/TijNIYYhhV/GvtufaWHxYoS7VHdYYdKCUs+8h/x9uJoyhf+suhQE3+pk9FB
         2BVw97EaoTLxc454cQXsAUVQwzX6FP//X8KHAXcTgREfUwHsTcKTs7xMRkqmRluA+hLq
         gNLAyMQ4JJU0KmwU9trTKbPz5qYCwxCXUeNXNKkgmvATLo9fy32Qyk5WJzDwzBIu2Zj6
         TEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24u9G4DyTIAy2pTqFGAddxQF2MRw+baziGMZlPjerS0=;
        b=eFLLRV9AKyeiLvFw5fkWq0Gyu3ytk5D9P0fDUzE1PsQAryhb9Vygan4cge4S3I3AzL
         znckB9JPrLtkKPRgxwzRErqVd06EyCr1HPE6WJu3R3+Q18sK1lTHVesQcqozdLwWhSVW
         0bywdmWKgOYsbIMvCCXs7swo4U9PcLN/2kZggXDKbhD8KK7YRvWFE12x5lafkgrlw1PA
         94zzcQO2S1bCSbajN3HYUCVzWAmHMYqClxjy6Pzs8CvQxbtevJ7YT1wuh8DQlsQj4/oP
         TfZ+9Lx75f1elJIty95lxXZJH30IZOSaNtQp8UYRYfaYnkLCatNPg+Xki0Nk2bv2Mp3W
         NM2w==
X-Gm-Message-State: APjAAAUD554z0Py6tCE9rhOu8qk/6IaaaoNfl6R4j0+LoM+9cetruIwE
        C8rDfxHgB2HMzTPp2/W6APx8hCbi
X-Google-Smtp-Source: APXvYqxCZRJNKp4OHblFlT8TV1HFCeLUk+DnAbga8zk0KA+2qmb9Ky2TydF2WomKznM+GrgSNhM4TQ==
X-Received: by 2002:a17:902:6b85:: with SMTP id p5mr22318645plk.32.1576957017243;
        Sat, 21 Dec 2019 11:36:57 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:56 -0800 (PST)
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
Subject: [PATCH V8 net-next 11/12] net: Introduce peer to peer one step PTP time stamping.
Date:   Sat, 21 Dec 2019 11:36:37 -0800
Message-Id: <bacf421e497281ebf3e1d7fc91301e6727a98762.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
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

