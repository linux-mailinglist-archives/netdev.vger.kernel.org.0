Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF2F36468C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbhDSO7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238544AbhDSO7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:59:24 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C352AC06174A;
        Mon, 19 Apr 2021 07:58:54 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s15so41111131edd.4;
        Mon, 19 Apr 2021 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WlmAetOa+5HxYf4TDISXX8Ux6wlKUWMqhMG/15ITEcw=;
        b=rj5ZewnpyD6W7aY3RDAuVO+SqM/hZvLXofs/Q0qLua1KnTiDz7qncKFueri2n8gxkq
         yGi8DNm2qLymf707ZT8rbH8KEpHMUTjEpxwyTp+QiVIZNRdwD4LimUNybiLZNu0EUImY
         r+15ue+FrTSD/DGhGBudKaxHLWB+nreqGSueRcgynLEUVex6+HLRGCu2Y6kLtqD5dW4V
         wt8LouLgpxGbodrtRAB08oiHavXTrjuK+7UQ4OJ8k8+8cX67PJjKz7dVT/z0Hu9eawdB
         TCihriwcM0nJxvjnHoxMmISUarwK+lcS/+91ZkWJN48JGdMQDc/4HhwU1svEeqAlTiye
         Rfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WlmAetOa+5HxYf4TDISXX8Ux6wlKUWMqhMG/15ITEcw=;
        b=FZiwVR9EygWpYQOSjJhm9S1dNUExQ2MSd1aKEQ0lbjCfvpDJpREjc3DLE30SXfllSL
         +vWwdbiY/7ypwAFSgSfjDGJN5q6jODVaWEEmyrHYg6OAmKc8Cq7VvyBbiEO4xDWHS0A+
         tR5LZTv/AQJFZpGgNLjopHAjT2pH7JrEG/cxUDGXlUcfAbHKOf+dyqyzm8jlHg/tyY4X
         JJavZPqQpgXfTHBE8fbw+bIl4hkCkI/NXLrgpP9tWFnMYDZoq7ffh8BpdqO11lDsYe/L
         zrUY3mwkEx5XkgGI8u2q2+HbHyNebzAYukiC+4jH0llgDP9zXYRahS+qhF7M9cbjxsqi
         eE4Q==
X-Gm-Message-State: AOAM531dON848FKBhphxqBXRgVzPn8+vSkDTuERRHBRsf78Toj/k/j26
        HyO/JTKt0xKIK4U8sL6ArSk=
X-Google-Smtp-Source: ABdhPJwDY2Exw6txlnSA9y+hQTpW93E8rqswX/sRBG4MQC5YRxy+oQ462t2AuOt8oxT9+p1KoYwZNA==
X-Received: by 2002:aa7:c391:: with SMTP id k17mr8156426edq.153.1618844333512;
        Mon, 19 Apr 2021 07:58:53 -0700 (PDT)
Received: from ubuntudesktop.lan (210.53.7.51.dyn.plus.net. [51.7.53.210])
        by smtp.gmail.com with ESMTPSA id l14sm1529578edc.0.2021.04.19.07.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 07:58:52 -0700 (PDT)
From:   Lee Gibson <leegib@gmail.com>
To:     kvalo@codeaurora.org
Cc:     imitsyanko@quantenna.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
Subject: [PATCH v2] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Mon, 19 Apr 2021 15:58:42 +0100
Message-Id: <20210419145842.345787-1-leegib@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317121706.389058-1-leegib@gmail.com>
References: <20210317121706.389058-1-leegib@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function qtnf_event_handle_external_auth calls memcpy without
checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
---

v2: use clamp_val() instead of min_t()

 drivers/net/wireless/quantenna/qtnfmac/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index c775c177933b..8dc80574d08d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -570,8 +570,10 @@ qtnf_event_handle_external_auth(struct qtnf_vif *vif,
 		return 0;
 
 	if (ev->ssid_len) {
-		memcpy(auth.ssid.ssid, ev->ssid, ev->ssid_len);
-		auth.ssid.ssid_len = ev->ssid_len;
+		int len = clamp_val(ev->ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		memcpy(auth.ssid.ssid, ev->ssid, len);
+		auth.ssid.ssid_len = len;
 	}
 
 	auth.key_mgmt_suite = le32_to_cpu(ev->akm_suite);
-- 
2.25.1

