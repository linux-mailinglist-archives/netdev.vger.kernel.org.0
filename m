Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A835BB0FA
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIPQPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiIPQPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:15:06 -0400
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7930945F62
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:15:05 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5973C57d0711F6270f7F2CD25.dip0.t-ipconnect.de [IPv6:2003:c5:973c:57d0:711f:6270:f7f2:cd25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4CA71FA2A7;
        Fri, 16 Sep 2022 18:15:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1663344903; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PuTOt8b+OPbDqWTsMFNEW4UtlKlZMhSm80wCFhpgQFA=;
        b=fX+10PJQREX9GAhImHT9aAFydYB7tbDH1c3M1NDxwYDrkjDEBXQRHs/uP/pR2kbJNQAsix
        9hTPk0rW4vORg48EDnjFaWM70lhkeLoUvMhZtm8nbsB50fZoLxXIjyb6bVmTPtJjDDvex7
        oN0pGePKs9U0vcHpHz7phK+Zu623gb92jNIZ8+mPrcZgMXN5IGWmtxX13yS1gwiER9dRoX
        JCTS8L7q63Thdo+BrTcCtNOv7U7SO73k7xFrdGz5WY1za0unezPfHtHL4bnqHuqUYLzeN6
        2+xTYDU1/28ggux1vSlfolujNkg5/pgaeJOOll5ixlccnR/DLLzD5yqY/EMNkw==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/4] batman-adv: Drop initialization of flexible ethtool_link_ksettings
Date:   Fri, 16 Sep 2022 18:14:53 +0200
Message-Id: <20220916161454.1413154-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220916161454.1413154-1-sw@simonwunderlich.de>
References: <20220916161454.1413154-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1663344903;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PuTOt8b+OPbDqWTsMFNEW4UtlKlZMhSm80wCFhpgQFA=;
        b=zAatyyZRKG8RL25MUZFBL4Qmxopnd8q5ojZTF8b3zHKKjSI3GGllrz5awh1s7nOB02Evd1
        F50Upogr9IFjF1201rkdzB/w7fZbA1D+lpVVAE7MCfnsXLBbPwRIVp4UDV3KY9Vs8mXhMA
        tgsfgu6IBkBRkhSYY+D0y9yEjeWzqoPM7LxXobr5z8DKxc+peYCBRDASxNc08qERbhC/WT
        8wX+5zjW+RwMw4QllmQA4RRDFGDl+rO+9crrWrYHyRrPjZuqo/M8IPdinj4R4ZcMlrCf/1
        FzI5xNL8bczWyY2rlBbGH0prdJg0l/Sl6wsqCj597otWsEH4TjZh+3jdreSiYQ==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1663344903; a=rsa-sha256;
        cv=none;
        b=I8onI6JRjo0D91JgKAsesJRXJ99w7AVAb84PFEO6PROVdx/grF6+jqwvPXD6kRqTnKerty+1KAGsgDmjeYBlF46Vo2MqSyZxF0l1PjeH0QzjoYVtgHR4WPFXlGkclti56kMyeaqKgF4VLhjqQxxuthgv1r/TMd17bz0ZSTFHgmoaJ2QCWy/UtLU7qlT5/TbTRSkAcLG7WeP43JQb7AIgDT8dTYn2e3gFGBhguR/sJs9pFu/wVGqSa+1+gtNvcd7hYnTD2g3vJQtM0n3MydUe+0Cu/nze+Ou23KHh2nNTQMYk4nwcr20i6t3Of9X9vPK4sT0/PitAmpHBMIJVVxBCuA==
ARC-Authentication-Results: i=1;
        simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
flexible-array members") changed various structures from using 0-length
arrays to flexible arrays

  net/batman-adv/bat_v_elp.c: note: in included file:
  ./include/linux/ethtool.h:148:38: warning: nested flexible array
  net/batman-adv/bat_v_elp.c:128:9: warning: using sizeof on a flexible structure

In theory, this could be worked around by using {} as initializer for the
variable on the stack. But this variable doesn't has to be initialized at
all by the caller of __ethtool_get_link_ksettings - everything will be
initialized by the callee when no error occurs.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_elp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index b6db999abf75..f1741fbfb617 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -125,7 +125,6 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 	/* if not a wifi interface, check if this device provides data via
 	 * ethtool (e.g. an Ethernet adapter)
 	 */
-	memset(&link_settings, 0, sizeof(link_settings));
 	rtnl_lock();
 	ret = __ethtool_get_link_ksettings(hard_iface->net_dev, &link_settings);
 	rtnl_unlock();
-- 
2.30.2

