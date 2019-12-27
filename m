Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA93C12B030
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfL0BYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:24:52 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32984 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:24:51 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so5980608wmd.0;
        Thu, 26 Dec 2019 17:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=R+uckJGNala33NMmXRczdflH+UHpS2SgqeFgbFnBl88=;
        b=kxtkHo621a4sPzJLjzffPydjrnf85sQqOMuLbLAtRtdwbUzEPRPzetheF4mIzDoxue
         74KNaBKELpzeywJnEdmR/ZRdwsSIuX7Mc3NxJNAqpD47D7dekMB/OPe07tgU9bRzV8me
         gSbK3ZR/++Wh4SL0KcHHwNEIuoCPgofGtBLrzHaCss7MWr2EAoaDr02eQaemFhjNgCX3
         eCrH2t2bGWmSuiW7xbfddnG/T3I664j5FCZF7BqmDjCxSKtrDMLbVcITld4fuqo3DdgI
         /VaminP61T4Vkk5AOODuU6pAh/tW3WXAICKiZW52C34D++lepOpDhHuHRap9C4EEU+RR
         xTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R+uckJGNala33NMmXRczdflH+UHpS2SgqeFgbFnBl88=;
        b=A2g1FU496lhyvjy7iIONNvtMCgpoEmkmQCiFs22CyIEu7S0P32NFGwoHFHMI43htWt
         j9sr4juiq0WKnlyMSEQpBkpw6j+3U5TGEy1y5svXa4C8g7pi3oXj5hB+40z4APz6bLuL
         kUnlBP5B6WvRVCpqoHkMqWmmysEdLC6lOy1VtT1ZLdpNGHLlINueA4EyqU/7e4DHIknI
         jAYodQuyzE82E7YlkO7YjYnmNMco4Gsbc7wrmFSlsW3LGl60bUDtZfyUR4VGBu4fVFnB
         ycpZ6KS1o/4KHfHOeBgIBsAxdaZE0l9j3re5C6J0Pv64jpz2TcuRZduAzZqJWaEeGvG4
         C90A==
X-Gm-Message-State: APjAAAXJ/unamkcdMk7elqnUpFA5ozbKzZXsmHMRH3+TAHfgQJwuKirf
        fEjuanLWr+WUzY8fWofxazko8NDh
X-Google-Smtp-Source: APXvYqyFPrM1I4SqjbUUrawWiFa5w6NMRtFk3hrtNvIUNsnzt90H6lfQOsyLv9UWnm0SMUzhHDu3FA==
X-Received: by 2002:a1c:6605:: with SMTP id a5mr16143378wmc.112.1577409889626;
        Thu, 26 Dec 2019 17:24:49 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l15sm32818215wrv.39.2019.12.26.17.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:24:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi] spi: Catch improper use of PTP system timestamping API
Date:   Fri, 27 Dec 2019 03:24:44 +0200
Message-Id: <20191227012444.1204-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can catch whether the SPI controller has declared it can take care of
software timestamping transfers, but didn't. So do it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8994545367a2..dc4538963271 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1674,6 +1674,13 @@ void spi_finalize_current_message(struct spi_controller *ctlr)
 		}
 	}
 
+	if (unlikely(ctlr->ptp_sts_supported)) {
+		list_for_each_entry(xfer, &mesg->transfers, transfer_list) {
+			WARN_ON_ONCE(xfer->ptp_sts && !xfer->timestamped_pre);
+			WARN_ON_ONCE(xfer->ptp_sts && !xfer->timestamped_post);
+		}
+	}
+
 	spi_unmap_msg(ctlr, mesg);
 
 	if (ctlr->cur_msg_prepared && ctlr->unprepare_message) {
-- 
2.17.1

