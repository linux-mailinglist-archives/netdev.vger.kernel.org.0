Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF1F95A2B
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfHTItC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:49:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43875 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbfHTIs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 04:48:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so11480562wrn.10;
        Tue, 20 Aug 2019 01:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fJRlmlBru4RfFVqA4+d8k80FcuTjsj2jSzcYsHbb4+E=;
        b=dyFWDqJO4XA0IkhbohbgkMzHBaAbQwIP3GP05rJgMxEq0/IGlpRDPqYDJ5RMYoh8uW
         +FJV9zQ1cnNkLZcb20rIGmta29Dm7g1JnpWX0OSA9eGBU9fRvKpcI5ZGu0BHrg1eHMl5
         7m8qiWLgf4iF82ulGCVN83FbrHP28G3iKzBHeFmb0rrZTOoIlUmq1wkprPm3sxjfeROd
         T1sStWn2u/2CoqBropLYiqlS6cuDlCkceXMGC5bDFr64nqWxkpCX5hjgPAztSCCxWBY7
         dJrGpoN6MehS0DdYneTrtdr3ICvDcu/Wzuxpid49UotbyjXgxvxi09D8hmlqy0NcqN8c
         +m/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fJRlmlBru4RfFVqA4+d8k80FcuTjsj2jSzcYsHbb4+E=;
        b=hnAE3DHOFzVofNDzs6OrLBKkicVvs5UHyV3cC29w8pWyV0bBGCmA/mf2/tHud/22ze
         +2A2CCsOZnzmy965Vi5Iuo2fPme8cOFtWAcuZt4ktQSZ8g8xbClDJ+M+okZAhtQSgcX1
         U66ZWNjh/68dPhH1o8yXndCLMcjk83gKw3AqLG3CDQB2Mtzi/gP5WCAZxR6/qdSC2MlX
         BAw3vxjIbP5A2jmZWwVhaHB9z6yAdmIjtq7lSDSbcymNTsZsrd+jgBTEttG84JkuJpcu
         QAEgIkfzGWTIitY6gCUly8BgNa56Q4dk+aS6d85L/sXZwVEQyzFvyP/2cunMCj7wMH0f
         XOtw==
X-Gm-Message-State: APjAAAUS5SmfRU6vj/rwVeoIEsVyAKi50NfasoqmdAS0cX3bz9uPAbOy
        S/8M/aWMBKRh9humh0hakcnR8bSz8hk=
X-Google-Smtp-Source: APXvYqwn/ZfOKNJgtLt3QtCbOcefQ4f5jOUF4Txx8QAiKctbGE2Z4ye5dL1gLm0tzJ1XndGoex8msQ==
X-Received: by 2002:a5d:4b0e:: with SMTP id v14mr33485466wrq.24.1566290938142;
        Tue, 20 Aug 2019 01:48:58 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id s64sm36437105wmf.16.2019.08.20.01.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 01:48:57 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
Date:   Tue, 20 Aug 2019 10:48:31 +0200
Message-Id: <20190820084833.6019-3-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820084833.6019-1-hubert.feurstein@vahle.at>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

The slow MDIO access introduces quite a big offset (~13us) to the PTP
system time synchronisation. With this patch the driver has the possibility
to set the correct offset which can then be compensated.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 12 ++++++++++++
 include/linux/phy.h        |  8 ++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 4dba2714495e..50a37cf46f96 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -739,6 +739,18 @@ int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
 	if (!(bus->flags & MII_BUS_F_PTP_STS_SUPPORTED))
 		ptp_read_system_postts(sts);
 
+	/* PTP offset compensation:
+	 * After the MDIO access is completed (from the chip perspective), the
+	 * switch chip will snapshot the PHC timestamp. To make sure our system
+	 * timestamp corresponds to the PHC timestamp, we have to add the
+	 * duration of this MDIO access to sts->post_ts. Linuxptp's phc2sys
+	 * takes the average of pre_ts and post_ts to calculate the final
+	 * system timestamp. With this in mind, we have to add ptp_sts_offset
+	 * twice to post_ts, in order to not introduce an constant time offset.
+	 */
+	if (sts)
+		timespec64_add_ns(&sts->post_ts, 2 * bus->ptp_sts_offset);
+
 	return retval;
 }
 EXPORT_SYMBOL(__mdiobus_write_sts);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0b33662e0320..615df9c7f2c3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -283,8 +283,16 @@ struct mii_bus {
 	 * The ptp_read_system_*ts functions already check the ptp_sts pointer.
 	 * The MII_BUS_F_PTP_STS_SUPPORTED-bit must be set in flags, when the
 	 * MDIO bus driver takes the timestamps as described above.
+	 *
+	 * @ptp_sts_offset: This is the compensation offset for the system
+	 * timestamp which is introduced by the slow MDIO access duration. An
+	 * MDIO access consists of 32 clock cycles. Usually the MDIO bus runs
+	 * at ~2.5MHz, so we have to compensate ~12800ns offset.
+	 * Set the ptp_sts_offset to the exact duration of one MDIO frame
+	 * (= 32 * clock-period) in nano-seconds.
 	 */
 	struct ptp_system_timestamp *ptp_sts;
+	u32 ptp_sts_offset;
 };
 
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
-- 
2.22.1

