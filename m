Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8846E16D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhLIETf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLIETe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:19:34 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC618C061746;
        Wed,  8 Dec 2021 20:16:01 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u1so7470187wru.13;
        Wed, 08 Dec 2021 20:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QvcCewx4ONddsyUZZDQLzMbRo9ldHh+zbmO8bXkm56c=;
        b=SjiTzOBLRsd7O7JbOYvXtiRodLFnuxpkuTB0cWZU1dSETelghHzcFhE1wXPtddgKOw
         6AHIx3enARG3If+hcMiygy4SifSwX3j5CgC1tJTHsttDuB+cacOdZf0AUv9O8h70FJ6d
         l3RcpPpPcN2RjibceBYYV1w35jI5x5MPrPczqXDbKor4cKbO4MyzQYVKGKXvPSDZh215
         yGdLnzftqIUo8pHpNIVm97Hd/4HRTgy/7fe3WjfxKmBGFYYfWtxnCvp/yFwOfQzFj0Mb
         ZcNMyM4fibMuhSv1v6CsFr67T8XOZMJNJXLrEWUPMFzs2R36E8bFKAr5KlcBjhwxNWLI
         6h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvcCewx4ONddsyUZZDQLzMbRo9ldHh+zbmO8bXkm56c=;
        b=OeXrhgUv2GxLKtO+vFKoBqLGxYHGgKP4MmoT8Z0fK+nm66hTCxsx8/ZyY4f8MAqvkh
         Iwu8AKOiq2720l6qVj6SL/9taZRIZ1JtLsPrL/Z7KpIdSQAvo2DbqG16Ds1d8bQ9FUsz
         rNC0lRCdR1bb/cRya58zSCHLESVyhla4OPggeIuu3yYe7Bu90v0jklLBglzUPe/8qNmP
         ogYRxM3EajcxCifzY9N5CGLyOkHbxarvoTLFRdFFxrFABjszpq87XRlSd50vbItIPb2a
         RT9jWbgX6UkXY7m+Z6LYjcrzvQTKpKEcZ0fWmP7PJ3dc5XgVMEJkNoAX0lfLfr5frV+O
         S2Fw==
X-Gm-Message-State: AOAM5328q17ql3PWeg0GsBrudFk+HyjEcr5+KSt5iMPmOkZEFs+hs46h
        tYPTAxFaU/y0uyCym98DyZA=
X-Google-Smtp-Source: ABdhPJw9WLOiPE1UDFamtWlcB9Gaw/zZSM1TJyfMALRK9gwdgrSiDgg1fLoQswCLxfQcQYy3GTGSTA==
X-Received: by 2002:a5d:6d8b:: with SMTP id l11mr3420890wrs.458.1639023360463;
        Wed, 08 Dec 2021 20:16:00 -0800 (PST)
Received: from localhost.localdomain ([39.48.134.175])
        by smtp.gmail.com with ESMTPSA id z6sm5474767wmp.9.2021.12.08.20.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 20:15:59 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, amhamza.mgc@gmail.com
Subject: [PATCH v4] net: dsa: mv88e6xxx: error handling for serdes_power functions
Date:   Thu,  9 Dec 2021 09:15:52 +0500
Message-Id: <20211209041552.9810-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209040746.9299-1-amhamza.mgc@gmail.com>
References: <20211209040746.9299-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added default case to handle undefined cmode scenario in
mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.

Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
Fixes: 21635d9203e1c (net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X)
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
Changes in v4:
Correct commit message in fix tag
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 55273013bfb5..2b05ead515cd 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -842,6 +842,9 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (!err && up)
@@ -1541,6 +1544,9 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (err)
-- 
2.25.1

