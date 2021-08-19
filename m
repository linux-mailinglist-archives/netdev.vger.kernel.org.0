Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF973F19C3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhHSMu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:50:58 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:38912
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238878AbhHSMu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:50:56 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B15643F110;
        Thu, 19 Aug 2021 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629377418;
        bh=NlpNbKBlI8kqdEuf1BReGDXjCIxIm5jBGMFuDPejO0w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=jwaRhOCOuGRf9Ewe7FgdXMvPb49/D1vy5Cemnsx/RsO+VKPtDveRERHEsiYTjT1X5
         IiGmx0pj+PhPQ/uH7O4tVXQqAljKWl2SjwLzhXvq6Gw3LNr6aY7V4FJJCGjWLeULPv
         9p2QouV+WVSkgmMY1x23klII44FpwEV1FQFZewTft2tIr+95e/Ws1kPcBNrzWmCek+
         J+mDZAu09HpmUg5SGfSLknygRNAnfnxtQyWudN6+jgRJcEaY9GbXltXB52EOonj1+c
         M22F3vdy01up8OPI1W0wuYxM1T6H95ALiSWMkFvyuMXTPPZN8owT8oZROfHk+RndM7
         PP7cD+8S3dUJw==
From:   Colin King <colin.king@canonical.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: make array fsm_state static const, makes object smaller
Date:   Thu, 19 Aug 2021 13:50:18 +0100
Message-Id: <20210819125018.8577-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array fsm_state on the stack but instead it
static const. Makes the object code smaller by 154 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
   9213	   3904	      0	  13117	   333d	.../wireless/rsi/rsi_91x_debugfs.o

After:
   text	   data	    bss	    dec	    hex	filename
   8995	   3968	      0	  12963	   32a3	.../wireless/rsi/rsi_91x_debugfs.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 24a417ea2ae7..f404ca4c38e8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -117,7 +117,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 {
 	struct rsi_common *common = seq->private;
 
-	unsigned char fsm_state[][32] = {
+	static const unsigned char fsm_state[][32] = {
 		"FSM_FW_NOT_LOADED",
 		"FSM_CARD_NOT_READY",
 		"FSM_COMMON_DEV_PARAMS_SENT",
-- 
2.32.0

