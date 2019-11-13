Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3CFB3E1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfKMPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:40:22 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46193 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKMPkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:40:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id r18so1583346pgu.13;
        Wed, 13 Nov 2019 07:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ki1SPD44lh1SNybw/5rgBcA9dSnsxmRipdKWolsiTPQ=;
        b=ldo4ffH/lXYIRRC9tzF8JwFZccS5LE1eNAXXtU1VS/5IB4wnVJb7htBqIKuKI8178C
         tO9TJGxlsknv5aUpJySM+Wem8RH82ICkpo3nAenXYrfA3W6c9rUby7YKTlE6RJAC+fef
         +Vqi2ABeS++Z6YTbuqfZ4XBVt1uRMel9RyjDYlCAOnzEFPh4ikQRyJ7ZtDPm2XzKbLCk
         0XvxdQphfr5HEwRpCp95eJ8HHjMwXFOB83ep+96dGDqMu6lwB1BQp90HYfRnqAoTFsMu
         70ciVkQJS00t2lYlajUIKEOc2C6gWu0mrj8z/hQMDmoUShmuHCGmicWJLKfFgkuaAiVp
         pCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ki1SPD44lh1SNybw/5rgBcA9dSnsxmRipdKWolsiTPQ=;
        b=hpCavwQvju1slM1Zk9QHnyCZJSpZ7szvMbuUmRbiVSno4LsbFmk0B7gxk5cz8r+Hoy
         ommMV9UC4l218md/RdtMi0rO5rVnwy2CvWtm4y+QDlftdk/norRc9GhNWFzCpFfU39NK
         poy3I0tm84VJUHE1pqJPw1M9fENGqxp1fUBtngziarQuyM0n0TqQ2ylBk269tRWlh8kk
         cTNw8neXYw3gufuHbfp3nGUSihC1jUglvFRTrfPcRy1POTfPWFJkXcY36mBNfum8T79w
         2Hx/ycBhJdsBM5ZVIbtEvfH+5IsV5Jfa0baTeuIfhEo4bMuZJbLjqFf7hOMiz919Yhw1
         wTvQ==
X-Gm-Message-State: APjAAAX2Loj6wkaFuSLVw/PPoc+BHRK1++FY9tom/W3xlblnYEJRX1Yp
        FdRM7UwwX44HC8DKIG56VLE=
X-Google-Smtp-Source: APXvYqzV4a9iYr/kLopHbCKtDwEFBpFCvcaVBZZ4KkPQvS54XiRuxUSsvQNuQJEpJnmCLUzjZnLo6w==
X-Received: by 2002:a63:db15:: with SMTP id e21mr4399962pgg.21.1573659620998;
        Wed, 13 Nov 2019 07:40:20 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id q8sm2911407pgg.15.2019.11.13.07.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 07:40:20 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH v2] ath10k: Fix qmi init error handling
Date:   Wed, 13 Nov 2019 07:40:16 -0800
Message-Id: <20191113154016.42836-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ath10k_qmi_init() fails, the error handling does not free the irq
resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
(re-)register irqs which are already registered.

Fix this by doing a power off since we just powered on the hardware, and
freeing the irqs as error handling.

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
---

v2:
-Call power_off() as well

 drivers/net/wireless/ath/ath10k/snoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index cd22c8654aa9..50b3d443ad37 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1563,13 +1563,16 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ret = ath10k_qmi_init(ar, msa_size);
 	if (ret) {
 		ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
-		goto err_core_destroy;
+		goto err_power_off;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
 
 	return 0;
 
+err_power_off:
+	ath10k_hw_power_off(ar);
+
 err_free_irq:
 	ath10k_snoc_free_irq(ar);
 
-- 
2.17.1

