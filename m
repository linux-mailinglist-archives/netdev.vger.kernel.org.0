Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F725A6C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfEUWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:47:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46722 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUWr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:47:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id o11so37506pgm.13;
        Tue, 21 May 2019 15:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=af+kvdp65tgUyPMboBW1Z0GJVgDD8UdGu7tCC8ncdg71Ufga4yGKAOE4eRuZPDuy0L
         MIoWMyzlRhw8nE9zlBFxNenmRSMzQECGjuLm6EBoHsogG5oVvCqlF5PuwKo3CUACmeaa
         IuDnb7ZBzCDDVLsqyzfgj7+vo9MdLZpeOUK8I7ro/EZIp1dV7WyrIQIvr2Lxk/11zRAl
         1WE4LzrWN/fJ01KxvCF6AhEXZq8Xm6OdgR7PbxVR9gnNAP+6udEhTomm0wgDdfSRJpac
         vaPq6JkPgIFypNeVBESbbMx+kf7L1y1bRDVfuy9Sie8622hUhAx9TpoojCsldlKY37pG
         0zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cx8Ilw4znmXClRGpigbzhVQkcqiKWTMxkBato++bvpI=;
        b=GZMtyc8J6wki4pieLfGM2nwcl0ydHH3nOqq+T4iexBl7MEI4dDgXw4doYyBE6VANNv
         FHiWgoBvQDEGOcC3/oZnsswz8iI7I7SefrL0L1/Gp+ZfWtq6VAaH5VsWqKYpsqBRQ4qu
         aOJ+ufNPmv4HFkaU7W5jZyTja25CFYTso5LZubP5xXPXQfR2sKZ/H1KuCm7als7bPv60
         tsjxFqozlAeiD0lawr0EgyP39JitdeqO9q436E41ZuB2Jx0+evWut1VWSoAxwoOd5eE0
         Jv1ozidSWuJGWzDgssVs7E9NjmvhG0H2/AgE8nhl9/Y6c+UNw70vdOsqry19nStXkdTW
         M3nQ==
X-Gm-Message-State: APjAAAVIwQE7aHm3e73kpjUqTd/N5cY7HKOrdewzObIHc71JjoqvihWs
        rdoS6Bop5tGX3RQ7XDl6Bwa1XhPZ
X-Google-Smtp-Source: APXvYqzvWq2+3p9w+uqawukog64IsHDi/8LATPvfFsRVF7ThFpza32XdJsn+FswyWeju0osqCa2J3A==
X-Received: by 2002:a63:42:: with SMTP id 63mr86289620pga.337.1558478846799;
        Tue, 21 May 2019 15:47:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r29sm34122419pgn.14.2019.05.21.15.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:47:26 -0700 (PDT)
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
Subject: [PATCH V3 net-next 1/6] net: Introduce peer to peer one step PTP time stamping.
Date:   Tue, 21 May 2019 15:47:18 -0700
Message-Id: <20190521224723.6116-2-richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
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

