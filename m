Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3D502FE4
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 22:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351787AbiDOUzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 16:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiDOUzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 16:55:41 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E0A43489;
        Fri, 15 Apr 2022 13:53:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r13so11815875wrr.9;
        Fri, 15 Apr 2022 13:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyOgwEJ9l8EA5lTTda7+EsCqxDSAHYk8KWdTQlUMJjs=;
        b=hURxvbcmXHZE0cQH3he2QePF/JGuwU07L7NGIqE/2niCHabgXwWqBKJKSoyZOLoD7u
         sz3kg9MLB33erxci1PiAerJBsobmblASO5dM6QkSEdatwtp9cYp/a7/Eh1MvKxZptgql
         aKud9nAnTNe2KL+vZidB4WUXvykVT8eoPBPEsx5wApTLFqievy5rjge9ym8ILqBBYMl5
         zrYkDoubRBWNgQ5SFhp+FaIpbqA7aUXtfS9IUD5uMvL3V5bWGEJBk0F60dhKqEaAHMH+
         G1BfjyOAQ6tQy/YEjoiNZ9iiLkwqYf6RrRc5OVrG4CGOuIJDF5v0r3MxQ5wwfaWXJaML
         ABcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyOgwEJ9l8EA5lTTda7+EsCqxDSAHYk8KWdTQlUMJjs=;
        b=gjt0nhrIpQy8VskasuDYp8XqP+LjCtRt9Jfwuf8sabqDLUjVjfYtfXxi9G//NukDo/
         HfZuGLpAOz5rERKUEj7el0eOQgyWJM+5L2wGakIOyPnfgYR08oXgL82wAHUogzEytrlb
         p4F2JzIytYOz9jMuazb21apYH8Y415spiXmeJs160T4Un21oiifgoPuvY7qxc13SpPaq
         u/HYWU4YPW+D0x6vXp8pWgr6QxbqjcoWsGKV2ZbOS2ZFoKfv7xqLxSrb2GdVE/4RSNpX
         Lhyg7zTKGtP8SIC3DzpU7I9wPev5ogzdpavOhvhfQ5oZGafKWSZGqkbKSs/iqCjk0Ek5
         U1SQ==
X-Gm-Message-State: AOAM532ZHc3nmFDPRKLGi3i9mOnCfjC+TW42eHLnqwqZihvMKNknYTG3
        ef71XoRl/wFQuSGqGNYIhnl8xXqFuH9N3w==
X-Google-Smtp-Source: ABdhPJyIDzuWNU+lgGyISF0WOPX13KdzXq4i1qTNAc+fd86+SmAMO+2T2lNd4SeTSq93uytVO66I+Q==
X-Received: by 2002:a5d:4085:0:b0:207:b13e:e8dd with SMTP id o5-20020a5d4085000000b00207b13ee8ddmr538897wrp.557.1650055990836;
        Fri, 15 Apr 2022 13:53:10 -0700 (PDT)
Received: from alaa-emad ([197.57.90.163])
        by smtp.gmail.com with ESMTPSA id v5-20020a5d6785000000b0020a792848eesm3181988wru.82.2022.04.15.13.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:53:10 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH] intel: igb: igb_ethtool.c: Convert kmap() to kmap_local_page()
Date:   Fri, 15 Apr 2022 22:53:07 +0200
Message-Id: <20220415205307.675650-1-eng.alaamohamedsoliman.am@gmail.com>
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

The use of kmap() is being deprecated in favor of kmap_local_page()
where it is feasible.

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2a5782063f4c..ba93aa4ae6a0 100644
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
+	kunmap_local(rx_buffer->page);
 
 	return match;
 }
-- 
2.35.2

