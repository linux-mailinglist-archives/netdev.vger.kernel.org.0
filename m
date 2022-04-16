Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD4503647
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiDPLRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiDPLRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:17:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119861C93A;
        Sat, 16 Apr 2022 04:15:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so6286580wmn.1;
        Sat, 16 Apr 2022 04:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uEhSMDHJtiuwdrj4dJJyu97KIVJOOD+nk/JiQfVUpZY=;
        b=dAvG/VUOiUi0sXwkQHoF+5NVAuiQMfKZcP1vqgjbrBMkds32W4S/eU8nfu9IqtPPMh
         RAk15ZLBRCzkyRWKkGVGJpTDzaSReBgjw+tB0S7YEMHgWwyGmXlgdNTTvue7wzattbWH
         6/vvwJXkAwZvshn54gexQbZcinhpcI4xzvXg3WLmsxJL7y0INjgfbhPUZKVTWaVHWPZs
         hUMyU6iVTLqHlA8iSHqeZj8/wn8dBw8KYI6VkbA5YMmL7AkLk5GoX42GmWcNeitGY8lq
         2LT9Kqd1NhYAjJYGdAgPh9rKu9HOKoKFVzLMflSZnl+3U1TQg8kn1sKUX7Tgj0kUP149
         66lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uEhSMDHJtiuwdrj4dJJyu97KIVJOOD+nk/JiQfVUpZY=;
        b=qh+bPghtsryiXw4+hE19bCotLpBxtz2JaRNrlFiuKhuGQ+eq0uORnrneCqtN20KkA0
         pxrhSD8aGp77LsVBoFU5FcVnc3cjhlkyBMZbdjiFYBD5uJz2xzdOwnT0FTn64qvyKgVh
         Z3bp3Nam2+/FOOJAE4EGz8/MSAsTjrzRQNbncRP3lu37Yhac7qKqFHWJuo1jSwwT4bVC
         ucX4eUIo0NlhqDm2YXguct9Z1+f6gqtc89c7mcbWuyPORjQ7g1ktHGFuRnGnzyWBHJ7a
         fO2/P39f+qsND0zvbx+GFTWUmEKz5+XAB0o6AusS8GcYbq5MAEjMG8zy1P6JIhM5yXnE
         K9Mw==
X-Gm-Message-State: AOAM5315ULPVazWXMF/BwNha9rWcYZgaR8sKZuLUMfCRm0DFDK1VDBSJ
        K3OcSC1Xk5cXUdsYR9l3q4k=
X-Google-Smtp-Source: ABdhPJxpvZFQaoNKdlYwE8qfxCxznE1bYGAnUYXCQP5HCgyf90I8tzuMZa59kHFBG+rR05HyfPdo7A==
X-Received: by 2002:a05:600c:1e8a:b0:38e:d57d:a3fe with SMTP id be10-20020a05600c1e8a00b0038ed57da3femr7027147wmb.59.1650107700553;
        Sat, 16 Apr 2022 04:15:00 -0700 (PDT)
Received: from alaa-emad ([197.57.90.163])
        by smtp.gmail.com with ESMTPSA id 2-20020a1c1902000000b00380d3873d6asm7344196wmz.43.2022.04.16.04.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 04:15:00 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH v3] intel: igb: igb_ethtool.c: Convert kmap() to kmap_local_page()
Date:   Sat, 16 Apr 2022 13:14:57 +0200
Message-Id: <20220416111457.5868-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert kmap() to kmap_local_page()

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in V2:
	fix kunmap_local path value to take address of the mapped page.
---
changes in V3:
	edit commit message to be clearer
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2a5782063f4c..c14fc871dd41 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page);
+	data = kmap_local_page(rx_buffer->page);
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
+	kunmap_local(data);
 
 	return match;
 }
-- 
2.35.2

