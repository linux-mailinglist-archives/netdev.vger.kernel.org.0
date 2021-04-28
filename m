Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5C336D6D6
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhD1L4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 07:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhD1L4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 07:56:07 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B2CC061574;
        Wed, 28 Apr 2021 04:55:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e5so34071780wrg.7;
        Wed, 28 Apr 2021 04:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wFVlZsZ+heSlhDiUDM4jdsWEkeRvPBP/0Wu0oaYtrFc=;
        b=hdH6GYWdfmHqxZz/sXPZXlHlyWXrxY3Qp1PlYjPmRYXfyT+TPE5zVwsEP1N5E9hayN
         bz+Y2ohnj+urGYHpcsJqHVCdLm0sEX0bqpM50uzK09EtLBKC1uzWGtPwJqo3vyV0uXu3
         iFCzJe6+kFO3pFVQ2Ns8Ix25yW2/80IkCwDZrviKqwXQE0IvyO0/RP5hiSbIwDcHr7VG
         T5JlmibjhcLRhPbGTIpcRLEG8TI3BQs8AMD9QKqtoEKxUT47RtF9qFz8VEY4vetWj+z+
         bNtAuR24nw4aJt1ZAHyjikiVgvfFcNFMfnaIinVw79KGSUAAVnPQ/VWN9NOc+C243xRY
         ug4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFVlZsZ+heSlhDiUDM4jdsWEkeRvPBP/0Wu0oaYtrFc=;
        b=jfakcI9P14fT/dZYBQR3r/G5xRy0ZBorBc8EtSZXGtANCc49dh4ZP3G4HmVC+BcVmy
         XsBfFk8ZA1f6cK0Dhxw2/W+STtVMGbpEw/lowUAR3yqQCQMoLVG66Ioul8+j4USTlug5
         bQUxTqRmjGd7vJQkt9h/i01g83IFN+8Q1lkqow90yvpSm3yfcEm6Rbw2kugvokje3TIa
         42/zd93mC37w82qgN0mlGdtaFItoO0c3I6jtrMfNkqWUxeB02pwOeEvefKh+D4dIkyCE
         PA9YtFvmqb9pxgyq+bpqwBNMxIfzVYtEU109u7PfvtbVV4vJMSE0RnXSu4V01hUMIJpE
         pd4Q==
X-Gm-Message-State: AOAM530ImlJ7CAlndYKE5oUmTJru0qgbE3ku0Y8vTosDcWFG1mWuCwve
        p6/tsZetwLWXXUpN5FAEceLVsPmKWBWDnZRH
X-Google-Smtp-Source: ABdhPJyc4U4H2WokTiue7gy0nKH8mHu+ubb+IDt/e+SUp9eiqkUU4zQNZlUv3pYA7+h8y2FKXlzSYQ==
X-Received: by 2002:adf:9d88:: with SMTP id p8mr35435030wre.138.1619610919503;
        Wed, 28 Apr 2021 04:55:19 -0700 (PDT)
Received: from ubuntudesktop.lan (210.53.7.51.dyn.plus.net. [51.7.53.210])
        by smtp.gmail.com with ESMTPSA id c2sm3493626wmr.22.2021.04.28.04.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 04:55:18 -0700 (PDT)
From:   Lee Gibson <leegib@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
Subject: [PATCH v2] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
Date:   Wed, 28 Apr 2021 12:55:08 +0100
Message-Id: <20210428115508.25624-1-leegib@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317121807.389169-1-leegib@gmail.com>
References: <20210317121807.389169-1-leegib@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function wl1251_cmd_scan calls memcpy without checking the length.
Harden by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
---
v2: use clamp_val() instead of min_t()

 drivers/net/wireless/ti/wl1251/cmd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 498c8db2eb48..d7a869106782 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -454,9 +454,12 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 		cmd->channels[i].channel = channels[i]->hw_value;
 	}
 
-	cmd->params.ssid_len = ssid_len;
-	if (ssid)
-		memcpy(cmd->params.ssid, ssid, ssid_len);
+	if (ssid) {
+		int len = clamp_val(ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		cmd->params.ssid_len = len;
+		memcpy(cmd->params.ssid, ssid, len);
+	}
 
 	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
 	if (ret < 0) {
-- 
2.25.1

