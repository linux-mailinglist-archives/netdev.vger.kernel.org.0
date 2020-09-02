Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A9925AA55
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIBLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgIBL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:36 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A1C06125F
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:29 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v4so4124060wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YcxPQNiqZGfjRlM3agi/H9CXj/hoWpM61eljrbx6rLE=;
        b=WtJ+zPacVL8leVdtVXhM/VcdHCc/XQ9ai2STnwz8leWk31wiLaqlOt4eJpqcbJO0Sq
         omwLsTen3quNV8QaUHx6W920vl9qgqGcnzOYdB1oHEfs4RZsBHc7PegoeW64P5uLh40A
         SA0/iIlq973XfFHEOvdPYmsp3fdub8HKL/diU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YcxPQNiqZGfjRlM3agi/H9CXj/hoWpM61eljrbx6rLE=;
        b=pV13AqPjVBP7XoVtr/R+L/mMfZLAgtyJ8zY9w8zOUi6/8dP3QPZWFSJsNAOIhCQxat
         RBpP2mo1hilUoD/+tvpLdrv2M/dZR5uvudwJy8OX0Ksb4bPQ1u4EVT2hkqP6wqVZW0C3
         GgB20IjYIE/3lDlfn9jE5dSjBTGhZ7TdxzsQqxhy2weEDAHDeZFvc5q+NvPfiC8EPyk5
         +1yXZGZDS9/rt4YTgVBAhHYzmkCaKSl0XChIMPJyNwwn0Vmn7+YRZbr7TXQ4KL0RWhAu
         mAtoDiMc+weJUwJV098GXcuVKtHmUIAV6YF6ARbMQVtxz3ioFbCk59RKcSgn310GnDno
         rTbQ==
X-Gm-Message-State: AOAM533NbdJyBqhq6tx8TS2zd8K1v6+ClVPM73B7uL94bShphIJRmTJI
        626/15USk3GCBBAA7t8R1MCB7b50tBh0OdaX
X-Google-Smtp-Source: ABdhPJyTnKSDWgIjCNX+g1r3pUsps04FY1kk8UesBPXAGa3Pty7u7ysUK4vXKBa88zmU+DtF9+Lusw==
X-Received: by 2002:a1c:7c13:: with SMTP id x19mr198001wmc.45.1599046168215;
        Wed, 02 Sep 2020 04:29:28 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:27 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 14/15] net: bridge: mcast: improve v3 query processing
Date:   Wed,  2 Sep 2020 14:25:28 +0300
Message-Id: <20200902112529.1570040-15-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an IGMPv3 query is received and we're operating in v3 mode then we
need to avoid updating group timers if the suppress flag is set. Also we
should update only timers for groups in exclude mode.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7df192e9ec50..db4b2621631c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2034,7 +2034,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		}
 	} else if (transport_len >= sizeof(*ih3)) {
 		ih3 = igmpv3_query_hdr(skb);
-		if (ih3->nsrcs)
+		if (ih3->nsrcs ||
+		    (br->multicast_igmp_version == 3 && group && ih3->suppress))
 			goto out;
 
 		max_delay = ih3->code ?
@@ -2069,7 +2070,9 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
-		    try_to_del_timer_sync(&p->timer) >= 0)
+		    try_to_del_timer_sync(&p->timer) >= 0 &&
+		    (br->multicast_igmp_version == 2 ||
+		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
 
-- 
2.25.4

