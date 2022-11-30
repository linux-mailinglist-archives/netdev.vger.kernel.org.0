Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5D963E2AA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiK3V0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3V0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:26:50 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7572C8DBDD
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 13:26:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p24so14240980plw.1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 13:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6saT+q5ezDQ177rT53B59Pf17d135h+Oe9v073LR0cQ=;
        b=TYLgl4SDIlOgIM1p5/s3P0/xE+k81DJUqppgCSnPchv8RIojqA/1XCiDCoxM93+n3i
         jYMlN9hLJMl30itHOyj8vzuPMhYxr4q/6FakXZFxsenGV25bvMIV3cmimYgHYOPhoiBJ
         DoM8sM3D6JrzbfwFyjn9nIBo3Bg3QK9iavMGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6saT+q5ezDQ177rT53B59Pf17d135h+Oe9v073LR0cQ=;
        b=L1I0cAz+v5c4+5HeN+1UvwelrTfW/YPV+De1XqgWi/VnpnuRo7nixa3P6Wwl9QI7uD
         Qf+KLvY32jkODkXw0j/gjPjtL82ZLrxhhrUDAJE46ApgAKbIBep2NNy3nL1odS6uLbyH
         4c1SErl7VZpWvAOvwGQwVCQ23dhjkgEoZ9liBvatC5JMiQR8iBk4It27Py1Dm7/xj0Pl
         TckuKJkIIGinWTiBdWQR3cnH1Gb/JHWANh7madxKKlhgHmiYVBrwWqXMYhEfNxJ4Fx7C
         mcqo9dMd4ijReEPJsyi5snWBFugIu9FJq6fpm2LM2+iIumKofNL9ARfFMitir2pQM1Yq
         HDqQ==
X-Gm-Message-State: ANoB5pm1J59qvGEEZopYBB1J2jruFyWpEEnejPe0jVZgg5HqHchU6tSY
        Vo70T5i8A/JDENB28lCzHcXlqVBx230//Q==
X-Google-Smtp-Source: AA0mqf6LUlZ3xGSjUHJvfh7bTIQnzkZsoyONol/ka/ZULyta/NTEd7BwDqAVAkl+pmc9nDZTUyOrsw==
X-Received: by 2002:a17:90b:3c45:b0:20a:db08:8a8a with SMTP id pm5-20020a17090b3c4500b0020adb088a8amr72164973pjb.141.1669843608744;
        Wed, 30 Nov 2022 13:26:48 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m8-20020a1709026bc800b001897e2fd65dsm1965267plt.9.2022.11.30.13.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 13:26:48 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kees Cook <keescook@chromium.org>, Kalle Valo <kvalo@kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] wifi: ieee80211: Do not open-code qos address offsets
Date:   Wed, 30 Nov 2022 13:26:45 -0800
Message-Id: <20221130212641.never.627-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3438; h=from:subject:message-id; bh=qZxXxI21JC4mN+ljaOuKqxqbLwAquUPCxUGbmUAdtlE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjh8qVfqRVaiLZwrWKZBsTnGkWYgjdX4AEocT03P5E +egjltSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY4fKlQAKCRCJcvTf3G3AJnGbD/ 9eLN44SC31Sfm16KmOEF+mtK8blu718iQGEZTvgbxx0w2aSj4UFjBWqJ1BEKMex8I87jo5WHNo922P ESqDuHRWT/xFXiHBP86/C93S5/ko/+1stUjOkZBJq0+/qR/eN78gpLx6Eo7xMzFB8DYT1EnSHDNwo/ ifPp2uYIaiAICdjVry3ZXELwzqZ70+xmsJuTzLxh+0V/d0ADGwSabRzjm34oD9QB+yxrLZeJrUCFS9 CtKMwLXVXBfQc7SBR47izPMtJlTr5TO1vqNXNjBl4DWDAjwLXUH1H5gyj5Lb0+icPqES1oYhtSo1kK kZzF5vEAMTwBVJx3dzDEmbxecHx8eJhgqHy22hsbHy1OfYr1GhINi5ItTltq0NjKCTotCyWhQATIB4 esln3aWsvU4q3zbvA6f22XnTtMUb1mAAJc/0fAQru5YjqI4eMc+TKIYtxx4FBpeEBBM4IPLd0d+U1y UW52ozdZHEITFf5/tVPObbZAZFTCNI3ISBYQvNXJYNoNbcVrPq2FeGLP+nN78afpxmxb9Qeat7YuRd inBgAjjtIjUE1gfsXLkoI0GT5ST2nll+8GX4DiPSkJ4G3wT/G8M0o2qpM5bfPbNi64tqYFdJA3FZT+ 4rJdCpRqYHSCOIbVvv7VqkxiV+ZVI4da0EKftcFprsutzwC5dG7Sv/CGygdA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with -Wstringop-overflow, GCC's KASAN implementation does
not correctly perform bounds checking within some complex structures
when faced with literal offsets, and can get very confused. For example,
this warning is seen due to literal offsets into sturct ieee80211_hdr
that may or may not be large enough:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c: In function 'iwl_mvm_rx_mpdu_mq':
drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:2022:29: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
 2022 |                         *qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
In file included from drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h:32,
                 from drivers/net/wireless/intel/iwlwifi/mvm/sta.h:15,
                 from drivers/net/wireless/intel/iwlwifi/mvm/mvm.h:27,
                 from drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:10:
drivers/net/wireless/intel/iwlwifi/mvm/../fw/api/rx.h:559:16: note: at offset [78, 166] into destination object 'mpdu_len' of size 2
  559 |         __le16 mpdu_len;
      |                ^~~~~~~~

Refactor ieee80211_get_qos_ctl() to avoid using literal offsets,
requiring the creation of the actual structure that is described in the
comments. Explicitly choose the desired offset, making the code more
human-readable too. This is one of the last remaining warning to fix
before enabling -Wstringop-overflow globally.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
Link: https://github.com/KSPP/linux/issues/181
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/ieee80211.h | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6252f02f38b7..80d6308dea06 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -338,6 +338,17 @@ struct ieee80211_qos_hdr {
 	__le16 qos_ctrl;
 } __packed __aligned(2);
 
+struct ieee80211_qos_hdr_4addr {
+	__le16 frame_control;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctrl;
+	u8 addr4[ETH_ALEN];
+	__le16 qos_ctrl;
+} __packed __aligned(2);
+
 struct ieee80211_trigger {
 	__le16 frame_control;
 	__le16 duration;
@@ -4060,16 +4071,21 @@ struct ieee80211_he_6ghz_capa {
  * @hdr: the frame
  *
  * The qos ctrl bytes come after the frame_control, duration, seq_num
- * and 3 or 4 addresses of length ETH_ALEN.
- * 3 addr: 2 + 2 + 2 + 3*6 = 24
- * 4 addr: 2 + 2 + 2 + 4*6 = 30
+ * and 3 or 4 addresses of length ETH_ALEN. Checks frame_control to choose
+ * between struct ieee80211_qos_hdr_4addr and struct ieee80211_qos_hdr.
  */
 static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr)
 {
-	if (ieee80211_has_a4(hdr->frame_control))
-		return (u8 *)hdr + 30;
+	union {
+		struct ieee80211_qos_hdr	addr3;
+		struct ieee80211_qos_hdr_4addr	addr4;
+	} *qos;
+
+	qos = (void *)hdr;
+	if (ieee80211_has_a4(qos->addr3.frame_control))
+		return (u8 *)&qos->addr4.qos_ctrl;
 	else
-		return (u8 *)hdr + 24;
+		return (u8 *)&qos->addr3.qos_ctrl;
 }
 
 /**
-- 
2.34.1

