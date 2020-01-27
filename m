Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D6414A147
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgA0J5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41277 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so4887132pgk.8
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AE4i9DBZawLRA4+hTy9ux3mggfiCFx9jNJrS3dBXSuA=;
        b=OMSwdse/5tJHDQjfmy1acwSweIe/j3RiQ2o/Ga2Ftke0AhvHhUdU0xy1KKpLGbBhee
         0UI+sH+PJE7xu2fAjc+9q0R8I+0FB+l5O6AIzio22++9E2V57f5of1HIT01eC7rXrxfJ
         Gatmm/qh4Kk2vk6njrjSslnhqpZm8ftltDFn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AE4i9DBZawLRA4+hTy9ux3mggfiCFx9jNJrS3dBXSuA=;
        b=p5pEKx3570bLk3GbRaF1si+aDQGDqIiv3b3+0kWumhgZgtqRjkJw3yicsdhL29dzYo
         6BjFixkIWEPXJRqVv5sqXFUxuXwhWlQy69ztcpFMqeJyFQRzhcta3thUlxh1KpLC5HsX
         i/wDHHk6cbMINF4Mb1ifLw9/ilFDYFSXpXg8hqDjluwIh040QeNfDMNX38vLn7J27srj
         /iiDu2l3mMTRNL6tIi8nHcRTyijnWWAEyNMk6aRt5OnJQw/ZakjmBFFeLWwn4VGt6ins
         c2EYWQ1cptK76uKHEZvF5Z3z5oI6u5kS3DVq9e7QgopAX6R5FKpAjc5XI/xs9Sqi5NZC
         aRAw==
X-Gm-Message-State: APjAAAUtqkvJwBgi+H1k6HW0W8Zpog6Qai/M97UlsWUsU8x0uE93ZRG5
        lupZy3kVFuShjAgobpD/UVrjo3Zjzn8=
X-Google-Smtp-Source: APXvYqwVnEfBsA/O5Moc9rYGvF8IzQWUOzjIzKwB0kmwlVAfWIz09LQDqjBMNj1j3reB5jbJJ8091w==
X-Received: by 2002:aa7:968c:: with SMTP id f12mr2818092pfk.235.1580119029307;
        Mon, 27 Jan 2020 01:57:09 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:08 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next v2 06/15] bnxt_en: Periodically check and remove aged-out ntuple filters
Date:   Mon, 27 Jan 2020 04:56:18 -0500
Message-Id: <1580118987-30052-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Currently the only time we check and remove expired filters is
when we are inserting new filters.
Improving the aRFS expiry handling by adding code to do the above
work periodically.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fb67e66..7d53672 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10040,6 +10040,13 @@ static void bnxt_timer(struct timer_list *t)
 		bnxt_queue_sp_work(bp);
 	}
 
+#ifdef CONFIG_RFS_ACCEL
+	if ((bp->flags & BNXT_FLAG_RFS) && bp->ntp_fltr_count) {
+		set_bit(BNXT_RX_NTP_FLTR_SP_EVENT, &bp->sp_event);
+		bnxt_queue_sp_work(bp);
+	}
+#endif /*CONFIG_RFS_ACCEL*/
+
 	if (bp->link_info.phy_retry) {
 		if (time_after(jiffies, bp->link_info.phy_retry_expires)) {
 			bp->link_info.phy_retry = false;
-- 
2.5.1

