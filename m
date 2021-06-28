Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274C43B5EDC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhF1N0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhF1N0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:26:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65F3C061574;
        Mon, 28 Jun 2021 06:24:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x22so8918368pll.11;
        Mon, 28 Jun 2021 06:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDHeI0eWYReS8YY9gGFnBiWrL9nGbp9CaS3tGTpgWPY=;
        b=tDbFTge6qf17tfEg5ZBR1GUf5B5LigcdxkXl8zhCnzpY5UmGfii5jeYzCy+JIuOgaK
         w6xmQJTqvBlmEzJ371uOXvH8rhLd9/0bdPiRpSod5JNujJ7p6om0vhdcCf+bM1MEFDy8
         YaDoYcnlSWaXFvxwHt6I0NgYIfhwIzXCfUN+y+inuIE0DK7wdRXvrqe3a7okTfNaSee3
         /rG/hQzhURZEEfQgKKTQyDCUQXrC6mkLG3qCnTgcaJKOQksKx4y57EbGPINl28ztyqAX
         UEdNpVJ0ugPtdtguiEbpUGSkS0cXX5lTkXIcKIDSdux+oRk0zFfk89RJbiQGokIYwtUC
         Xx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDHeI0eWYReS8YY9gGFnBiWrL9nGbp9CaS3tGTpgWPY=;
        b=Q8Ey4kfbupCNb7XPLlTyhJP5qm27CM9xigSmvG2uHCBA3kCoZp0qIT9N5NxGKWR9Bh
         AEEstN4dfbHsmcGZPNcWvDN6fkjU47yhNNivhyCJV44fgb3EjququSlGjoOGcLZVG0Eq
         LHOewwrmlDAAQ7oMUy61JCXOQKPX16k5kmHpQst2y+zOaLATnnERZb4xNoaqnORiXtYd
         +0B+CkTiVCM5dwnEpRnMhd9RF2Q/DK6u8BjAiYGCFwQm37ZaShHSDKAlsK2AWAiH/01y
         z+1eKlNBmIifJIc++JM+aUetsRdu0G+9B7UzcYTri8QUgFq7TLyI1z6w50+4e/PU0kFt
         DxmQ==
X-Gm-Message-State: AOAM530Q6i7TY92Vmt/7Xdf8YI79MlvILAx0LokLNanWA1l4Uh0IYv/U
        BOPpDLsae6WfACPi2Pv7ZP4=
X-Google-Smtp-Source: ABdhPJyEtBkT4U1E1c9TE1NUy5w+z2T4i2Fn9JFuaijGI3lm8CCha1Sn2Gjr4SEhAJ+fNJdQ/XmVeA==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr36896213pja.114.1624886654848;
        Mon, 28 Jun 2021 06:24:14 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id i18sm2738268pfa.37.2021.06.28.06.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 06:24:14 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH V2] cfg80211: Fix possible memory leak in function cfg80211_bss_update
Date:   Mon, 28 Jun 2021 21:23:34 +0800
Message-Id: <20210628132334.851095-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we exceed the limit of BSS entries, this function will free the
new entry, however, at this time, it is the last door to access the
inputed ies, so these ies will be unreferenced objects and cause memory
leak.
Therefore we should free its ies before deallocating the new entry, beside
of dropping it from hidden_list.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
V2:	- Add subsystem to the subject line.
	- Use bss_ref_put function for better clean-up dynamically allocated
	cfg80211_internal_bss objects. It helps to clean relative hidden_bss.

 net/wireless/scan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f03c7ac8e184..7897b1478c3c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1754,16 +1754,14 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			 * be grouped with this beacon for updates ...
 			 */
 			if (!cfg80211_combine_bsses(rdev, new)) {
-				kfree(new);
+				bss_ref_put(rdev, new);
 				goto drop;
 			}
 		}

 		if (rdev->bss_entries >= bss_entries_limit &&
 		    !cfg80211_bss_expire_oldest(rdev)) {
-			if (!list_empty(&new->hidden_list))
-				list_del(&new->hidden_list);
-			kfree(new);
+			bss_ref_put(rdev, new);
 			goto drop;
 		}

--
2.25.1

