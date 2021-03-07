Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E032FFA1
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCGI3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCGI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 03:29:16 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B2C06174A;
        Sun,  7 Mar 2021 00:29:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id w34so3319999pga.8;
        Sun, 07 Mar 2021 00:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NNQWmSWoSMwDPekS2cJkkWfDwB9RRl0DHBbIEF+uvUc=;
        b=YATLHDQ3SHj8htbm6yMAQsgzZe2syhBKTToCP4Ux6uqcySeMjwxiO+vSu8lh3GYgV5
         euct7+9AnmN+kC3ZPvaRGFfXYokM5HoQZtWeJp/LXHIImT3qpPctG7+V8cDU2gTdkvcv
         6ZYFo8Tn5IQKkTV4Ud7iZ+MBwKQ9YGs+hF1S7Lo0aviPnNm6U7EE3VuDU3Zj+nwJzZGe
         xl23g3VU+M3YXt8kaoNrl44ggr4yDlhkidNX30I2QQLIWIPyX35Yf/7PTSEO9pDvDrr0
         7X7Tb6/hLhi9apxUWZx2+6t214In6ymjKRvglUw61X38eT0ksC2pYkijr8LBcApXbX1O
         b7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NNQWmSWoSMwDPekS2cJkkWfDwB9RRl0DHBbIEF+uvUc=;
        b=hxsQb4lAwcEHx5PWLUSKFAor7sY0e8dZJRu9hrJm0YRk8ET5V97Na/ZelQ5QE9nDZe
         gRkvGgNFHCQy94skHW8nuCxN+MlDWVvr02ZzkkAT1jAZnDDr9s5IE6ILR9d45Qjwng+O
         L7WnM2BG7DUfDZAsBjN/h7R9vef6vcatZfPZETjfkSlJfeyls/39VIOxYsKHG6i2fYS0
         lpCMNSIesMdq1vbDm3WfaS4Q26ohieC3KJGgrBHMEfnuazUlp447odmV75QON/ubeDyy
         eRRUtRbZbN5UkUgbGaso0S1ZQs/nTAnOp7SmTKAmlzx79EMsM4FpgrOkbAo+C4lwe2D5
         HKbg==
X-Gm-Message-State: AOAM533g1sDt14pCVV55gEC6Pjo7j7zLHma+2Zd5Jf2V+KiunxlVcyJQ
        nqEIMOlbDe7N2e9cejD9aR4=
X-Google-Smtp-Source: ABdhPJwP46rKvb4tExS2PYbbcbYqOSAR02QpneY1E41ik5pABMVSlYepxR7VPdGT2LhzjSGD1GNqug==
X-Received: by 2002:a62:3507:0:b029:1ed:a492:fda6 with SMTP id c7-20020a6235070000b02901eda492fda6mr16182275pfa.37.1615105753894;
        Sun, 07 Mar 2021 00:29:13 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id z22sm7050684pfa.41.2021.03.07.00.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 00:29:13 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        lee.jones@linaro.org, colin.king@canonical.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ti: wlcore: fix error return code of wl1271_cmd_build_ps_poll()
Date:   Sun,  7 Mar 2021 00:29:06 -0800
Message-Id: <20210307082906.20950-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ieee80211_pspoll_get() returns NULL to skb, no error return code of
wl1271_cmd_build_ps_poll() is assigned.
To fix this bug, ret is assigned with -ENOMEM in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 32a2e27cc561..7bf8b8201fdd 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1120,8 +1120,10 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	int ret = 0;
 
 	skb = ieee80211_pspoll_get(wl->hw, vif);
-	if (!skb)
+	if (!skb) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
 				      CMD_TEMPL_PS_POLL, skb->data,
-- 
2.17.1

