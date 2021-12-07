Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4F346B2FA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhLGGjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbhLGGjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:39:10 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C5AC0611F7
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 22:35:40 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id m24so1271062pgn.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 22:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOVDJjmjj4hLTjat7OUu9/MMuAZJaeKFjI5VvP80Sr0=;
        b=Kbe1be42VDtOUWuyAxH9naNFdn22bhb0PWWRnKlhU4LRtbk5C3qQ1yWv5O8Tf1xaYm
         oHi75nahMVk+pBVru/TX8Evu++VydsdeYq4KncKE32NwgMXW7KZEu/m12afu5PmFMK5V
         z++MP4jZY3iPRd8TfjF6XCTaajLbIfaaPW3Ns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOVDJjmjj4hLTjat7OUu9/MMuAZJaeKFjI5VvP80Sr0=;
        b=gn4QaJjkitvjCP2rEF+y5if8xLnLnoYajRrUQuz30mqy2HcuxkNQDmNIbPm0lsxGxa
         XF2W07SdLWOli1BR9wVX0+nvf+JwHgD12zeKKLMjTyHpPvQRZcpS60AePj4w5QdhmcIc
         5UxupwveEst0cIiu/wX9RvTyVXZrQ4cj4ld222f+N33N/2JK6Y6rzkUv9V+wYX1zIka2
         LRltG6YASrpuP27z+4+PBMZ4UJbPqFZaOiwa9diJHk+c6DRy7YpWxgOk0Ee/dD6ct0Ie
         OTj1NACi48xElYfyR3jioUf4FZfhaY95ZE2VEuxYd6gdm6Hr/rEHFACNU6uYPicUlzG9
         48FQ==
X-Gm-Message-State: AOAM532vXa3pFWIhC/DpAKxYdy08wtM6N8n0O8kusZpSY7w7rS2/15my
        c+jWOlXx+LbdfAjmkR3Ywa5zUA==
X-Google-Smtp-Source: ABdhPJw4OdnTlYTah6sMJYxRBKcOVLvja72f+MUSEBWLwv5PThpZtJKcMzEeXc4VyCMZMsdCKAQGDQ==
X-Received: by 2002:a05:6a00:cc4:b0:4a0:e97:fe97 with SMTP id b4-20020a056a000cc400b004a00e97fe97mr41656686pfv.74.1638858940040;
        Mon, 06 Dec 2021 22:35:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b19sm14938169pfv.63.2021.12.06.22.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 22:35:39 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] ath6kl: Use struct_group() to avoid size-mismatched casting
Date:   Mon,  6 Dec 2021 22:35:38 -0800
Message-Id: <20211207063538.2767954-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3525; h=from:subject; bh=gMIiB4KaTnR35ffD7gt6zl0cwWYPiUE9+pb15EV8f5A=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhrwC5FoqRGEH5aDrVc1O409fT3C87dkmvAVyNkfWg ZVhquVyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYa8AuQAKCRCJcvTf3G3AJnR+EA CkJOBiiicx3wiHCrpJQgpwZg2CYcsFxGkaBGzqJj9pwuDubqibmw8T03RfGOjv8cthmZC2VnZP/s+E +ocDnRJgesw6aS9nRoiASGvg+/LjOPt6HUjSYywpy9oyWtBU6/pBAIOxa8Q3PKb6DBgL0+xobEL8k1 m5kJ1MEBDp1dZLVI/cvi8HKamvKUErNmHpaSCmi3mFlz+JNING9jMIWBXcyc26N5DC+mGxXheinDQi 5YSi/t1iWcVLP6IEsVgD3bH2ycFQbaNk5ZNKpxWGr6sitiMKZHR2D63a64TaOPCt03pJx6VGDrbilj 52XKn9NvCJ/+k8431PPZUOJHVZPOGnPr9gV0arRLbqjrmbBHBYIRjUd6p9ewMz/TeKhjKt0HFQntSE IZsOsix+AgMKLct3z/HpB1X4svJt6Lpn0y8auu1KCCkuNrCA4Ou99KgK/0KJPqTEMHuVlRqocjvup7 J/0FwBIsAvUhAzUmhdj59DqS5XlwvgNfpEQP+PWWyM44v/Bv912v0SiwJio6wmX3OZ716n7keVdIpX vo4lIosDNj7bfx23VkByP8CxQDUxScCxZkfzOxrnPtW41VVLn/RYBJQorUGS/f0nW0+vYGraGCsE56 1Kwv5JnFhQDBZ6QkJmUCzwtQE4f5so0PBFIU9oRZ8c2grEJZOC5eGgbVRzTQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In builds with -Warray-bounds, casts from smaller objects to larger
objects will produce warnings. These can be overly conservative, but since
-Warray-bounds has been finding legitimate bugs, it is desirable to turn
it on globally. Instead of casting a u32 to a larger object, redefine
the u32 portion of the header to a separate struct that can be used for
both u32 operations and the distinct header fields. Silences this warning:

drivers/net/wireless/ath/ath6kl/htc_mbox.c: In function 'htc_wait_for_ctrl_msg':
drivers/net/wireless/ath/ath6kl/htc_mbox.c:2275:20: error: array subscript 'struct htc_frame_hdr[0]' is partly outside array bounds of 'u32[1]' {aka 'unsigned int[1]'} [-Werror=array-bounds]
 2275 |         if (htc_hdr->eid != ENDPOINT_0)
      |                    ^~
drivers/net/wireless/ath/ath6kl/htc_mbox.c:2264:13: note: while referencing 'look_ahead'
 2264 |         u32 look_ahead;
      |             ^~~~~~~~~~

This change results in no executable instruction differences.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath6kl/htc.h      | 19 +++++++++++++------
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 15 ++++++---------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 112d8a9b8d43..d3534a29c4f0 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -153,12 +153,19 @@
  * implementations.
  */
 struct htc_frame_hdr {
-	u8 eid;
-	u8 flags;
-
-	/* length of data (including trailer) that follows the header */
-	__le16 payld_len;
-
+	struct_group_tagged(htc_frame_look_ahead, header,
+		union {
+			struct {
+				u8 eid;
+				u8 flags;
+
+				/* length of data (including trailer) that follows the header */
+				__le16 payld_len;
+
+			};
+			u32 word;
+		};
+	);
 	/* end of 4-byte lookahead */
 
 	u8 ctrl[2];
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 998947ef63b6..e3874421c4c0 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2260,19 +2260,16 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 {
 	struct htc_packet *packet = NULL;
-	struct htc_frame_hdr *htc_hdr;
-	u32 look_ahead;
+	struct htc_frame_look_ahead look_ahead;
 
-	if (ath6kl_hif_poll_mboxmsg_rx(target->dev, &look_ahead,
+	if (ath6kl_hif_poll_mboxmsg_rx(target->dev, &look_ahead.word,
 				       HTC_TARGET_RESPONSE_TIMEOUT))
 		return NULL;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc rx wait ctrl look_ahead 0x%X\n", look_ahead);
-
-	htc_hdr = (struct htc_frame_hdr *)&look_ahead;
+		   "htc rx wait ctrl look_ahead 0x%X\n", look_ahead.word);
 
-	if (htc_hdr->eid != ENDPOINT_0)
+	if (look_ahead.eid != ENDPOINT_0)
 		return NULL;
 
 	packet = htc_get_control_buf(target, false);
@@ -2281,8 +2278,8 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 		return NULL;
 
 	packet->info.rx.rx_flags = 0;
-	packet->info.rx.exp_hdr = look_ahead;
-	packet->act_len = le16_to_cpu(htc_hdr->payld_len) + HTC_HDR_LENGTH;
+	packet->info.rx.exp_hdr = look_ahead.word;
+	packet->act_len = le16_to_cpu(look_ahead.payld_len) + HTC_HDR_LENGTH;
 
 	if (packet->act_len > packet->buf_len)
 		goto fail_ctrl_rx;
-- 
2.30.2

