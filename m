Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8492732FFCD
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCGJIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCGJIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 04:08:09 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C2CC06174A;
        Sun,  7 Mar 2021 01:08:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so3431766plg.13;
        Sun, 07 Mar 2021 01:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z5qBeDr73mu1Ohkca0kOr2L7Gmyz2MrOVp0HQy/wugc=;
        b=lcE0KkdSv2Ghm7BZvnD5M7N25DsTIlsHNdJhND3axG20OJEXaQvWuYTzTbBbteRTdL
         dVwm1ay15zRv59FsOotVdVWm+bGocg++UT2ZLXQtEFoYtdQNEZl6pzB9vD/raIef/pmp
         NZl96AEeZNSxmsMSC7f/otCCHeV+ZutIgbQnlMmScK15QkZQB/lRuIpqD5XVJtZtmrWS
         VORfZ7zb/vVhuUBz200A0UaYqWCaT8mvEOOuvFOh12u6Jq7TSZV/cer/K5dN5pn5+l0R
         wW1LIeIgrTIB3Li/XoXUodfs5L0voveGlc2fafGeqMx0Ee405WsKotDazr1FmOUoUzek
         6qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z5qBeDr73mu1Ohkca0kOr2L7Gmyz2MrOVp0HQy/wugc=;
        b=TkHk4KbHxa4ne2PGW7ZALJv0MkTDM5ZsigiX+w3MxO2CaFEtazduIKU8dk8v66u5ez
         H+85/dce2WzfRPrYATdFlN6qXMeC1QT7DFMtqE/HL3DZvCu4+MJJ4C7vsiE0OYjBoBm2
         w0DIN7eR0IWF9cAlsoREdgFja/+HovRG4gUKgJnESOpnEBT3wqZxwNiCj6vYIjjoUwFH
         UEidoHHAso1cpt24bHv2W/KwZ8uE6W/9cBk+J2E8/ClCyU5rQwgZGxFSmhfQJDE6E+j/
         8pGEdKL9KDB4P+9hLwK2XFMFmDUUFg1XdiUCoXJ11AvyrGwwXHPTLO8QgeXoMdYrtBsu
         v1CA==
X-Gm-Message-State: AOAM533VhTuOCFYqSIdJE+b4/rbSylAm1MtKXPCLaj1wmnhPkNCuq6tn
        PTvBqbxCCg+4crmVoO+Nr8Ez3XP+LlE6lmv9
X-Google-Smtp-Source: ABdhPJyUZMWW/XQh/XPTCutpNf98E6TOQK9R+90dXDRFagLwTxSwMH7n953OClbRyV5kPLZ5+DWZmw==
X-Received: by 2002:a17:902:9691:b029:e3:dd4b:f6bb with SMTP id n17-20020a1709029691b02900e3dd4bf6bbmr15801956plp.77.1615108088407;
        Sun, 07 Mar 2021 01:08:08 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id t5sm6600065pgl.89.2021.03.07.01.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 01:08:07 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ath: ath6kl: fix error return code of ath6kl_htc_rx_bundle()
Date:   Sun,  7 Mar 2021 01:07:57 -0800
Message-Id: <20210307090757.22617-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hif_scatter_req_get() returns NULL to scat_req, no error return
code of ath6kl_htc_rx_bundle() is assigned.
To fix this bug, status is assigned with -EINVAL in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 998947ef63b6..3f8857d19a0c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -1944,8 +1944,10 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
 
 	scat_req = hif_scatter_req_get(target->dev->ar);
 
-	if (scat_req == NULL)
+	if (scat_req == NULL) {
+		status = -EINVAL;
 		goto fail_rx_pkt;
+	}
 
 	for (i = 0; i < n_scat_pkt; i++) {
 		int pad_len;
-- 
2.17.1

