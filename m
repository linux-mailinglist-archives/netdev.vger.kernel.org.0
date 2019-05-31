Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104083082D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfEaF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:56:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38172 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEaF4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:56:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so3403135pgl.5;
        Thu, 30 May 2019 22:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=YLB2YTSYAnKeTxJB36Gsy+RjhAuOScVcZfng4enuT+NS4tm1LjmXNnu0+L3t5uNUAB
         9YFrnt9nohrNFtotp5Pg6p+IqpAHW/w6Lm8xfMZPeVmj6ls4e4A5RLEBPXS4QCyhFb2T
         9yLsUl6YTxBUdXfiYEUeeENxfz4JjHZIh3sKstg8SXF+GYUMP21uY2J6+zCrqKMaYF2k
         zTDUaI/zMWqjwRlfG3DRXAeotA8yPgOiOTlEls/dGNHRnBX22GDyMyfUhkXXQgDHOW5Z
         6wF7G+Nl72U6xZTd0Lc3hZ/h2BeTJBEFaUfGBQ+szFb56hYD9r60RVD3RgQb5wJbdm9Z
         3L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=OegQsf9NMc/SBuOXiigA9gYV9l6SB6k18rs7TtkSUCXjrX8p0Bb6AQ/rVGGrWsY0aa
         R2ckju6FTIjOeIrnt5x2ievaNEI0KMlVKmSa8RB56JJmENQXpY3X6ftJFmM4VS3DwyxJ
         L+cgUiyUl/CHFge8pAe//ixcLDLHzZgVbMj9nNYsnyKDhAvumdb73rUL5G4DL5zjAswc
         HVwyPyxzE8aWA4tsZHL09WFXbr2Pw8IFkWz3wVXYgrRoxUJGOYBtZ8R2tcZciSR4jFjG
         86P+2G1ZZnjaiF1xFsq9rooOxd/8P8hMIR98tuz96U9tt+1p/kyibGTtGiDrQ0xoAsWo
         c68g==
X-Gm-Message-State: APjAAAU5K3igvwJklOzEH7OaxBN8E30QnLZXXcs2PNsN96lNskHP1W6f
        cxGAngwAkL5vv7vk6dCjIemJEkBP
X-Google-Smtp-Source: APXvYqxXpLfGZ1rlYKC8BajV38Qff3zd7V+CKhOAZmxRibEkG/5xrmyrOZRS049JA02IG0hose02ig==
X-Received: by 2002:a63:231d:: with SMTP id j29mr6992429pgj.278.1559282190105;
        Thu, 30 May 2019 22:56:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u2sm4554184pjv.30.2019.05.30.22.56.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:56:29 -0700 (PDT)
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
Subject: [PATCH V5 net-next 1/6] net: Introduce peer to peer one step PTP time stamping.
Date:   Thu, 30 May 2019 22:56:21 -0700
Message-Id: <b8b49d5085143ff08ff5e7146c15bc4f6786131c.1559281985.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559281985.git.richardcochran@gmail.com>
References: <cover.1559281985.git.richardcochran@gmail.com>
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

