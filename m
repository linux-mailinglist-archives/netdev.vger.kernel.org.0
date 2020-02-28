Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F61173EFE
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB1SBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:01:54 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33986 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:01:54 -0500
Received: by mail-pj1-f68.google.com with SMTP id f2so4543301pjq.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=q4MFo5bjVCZH4uqjjKMHTGirPSQBeeM7T0vVU3JGwlo=;
        b=E/g3eo9Cast0PPxafdSzb7ct4d6PsM0P41k6yikUdle7dNXKOKMID+4O3mPYAmYfdy
         knb997OvADOaZoTSMcVKfmhOy3wDy2MrnbZNRP3ORoluFawcYU4d89Iujt6K6dEQ5bb7
         4jYN2cqyPWyMpUNoEKTSae6BVdIICDSKVAOBPjHuGqorEYH+pgPC4ojSDZTipX7Sd8/l
         ewwwyFQD85sOUkf4zdqgKxxeO5WStmWvDUeaTetamhJGZkKBoR1SNR7t7Ho9TGeMSMG5
         7zYWdR8Zlu+IEwg4UGfe3a2Urz/CsO44OmV2RuBZIzfBnNqf1WeLY1Q36wqOpOBQbspy
         Q44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q4MFo5bjVCZH4uqjjKMHTGirPSQBeeM7T0vVU3JGwlo=;
        b=FzuSEVbRzYdfcvzKAbKbSzyoRd/XP/so+D4j97IyMbJIOxzoh7klxkd91UE5CxJ3Hv
         wa7wLajEAvApt1MjSpNpBg0Nee8PyhGx8ZVnjAPHmZA8BmnmYGmL2kT0qt+C+6+o8mkk
         9HihCccdvgclKBVf7LVnMtUYHhR5lS7rlRUq7C45pQtsgBu7Pw+Qj0xd8eyF+YN+jliP
         ss1bQpcT3gh1f7mqVHK8BlK/SDhZDboj2vbcMwQrHy/VCaqtKEXaEfmz9YUfQhprIQrs
         cQCEvqrnVt29hODEXSZtl3QEZbiYZG117QI2P66UzFHoG0jTp6RDCNv7MiNiX7ijEX9p
         L9Jg==
X-Gm-Message-State: APjAAAVK4pJ1AefwqHf0rY6to8FEbmscyS3YM7Sdu5Nc1z6tOQ4Y7GYS
        zdQ826rgDaZCPHVxdsnbSvg=
X-Google-Smtp-Source: APXvYqxO5CT4qosA2aQlpbpxtx/n34mCU5dhrSpdCQWaatxDFSyHnN2LxaNCpV5AF3DFJ5OWIzkQzg==
X-Received: by 2002:a17:90a:7f93:: with SMTP id m19mr5787623pjl.92.1582912912107;
        Fri, 28 Feb 2020 10:01:52 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id a9sm11557625pfo.35.2020.02.28.10.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:01:51 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 3/5] hsr: use netdev_err() instead of WARN_ONCE()
Date:   Fri, 28 Feb 2020 18:01:46 +0000
Message-Id: <20200228180146.27762-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When HSR interface is sending a frame, it finds a node with
the destination ethernet address from the list.
If there is no node, it calls WARN_ONCE().
But, using WARN_ONCE() for this situation is a little bit overdoing.
So, in this patch, the netdev_err() is used instead.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 364ea2cc028e..36cf582afad2 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -317,7 +317,8 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		WARN_ONCE(1, "%s: Unknown node\n", __func__);
+		if (net_ratelimit())
+			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
 	if (port->type != node_dst->addr_B_port)
-- 
2.17.1

