Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66942EC2D4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfKAMjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:39:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34239 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfKAMjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:39:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id 139so10145342ljf.1
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRmAVX0LKzbwaoPbTw2s+8QG+vaakhy1/lXDson76Zo=;
        b=Xrh7EMh8ZzcIz9hX2sDR0DJOKVDQoj4Nu3vjKEi+eq+VzrrV/x2n3lmXMHPT7Chosq
         t8UTBs3G1A30iC2xGNLOjpvsCkHi5wxwWbAhHtxbcIERSyVSDdxYvuYj/xc6iA55+6Zg
         dCdJ75Vkt65BxiPjxakhEq/v/8FobnlaDtqjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRmAVX0LKzbwaoPbTw2s+8QG+vaakhy1/lXDson76Zo=;
        b=XRA3NWyrpOiCGDpJ9ChRz/nzqrKssGIFacXNsXyf/01yVQ5vPpUPbtsOkyRV9LzUlN
         iWQcJfKAS80cD0Ka+FcGgnus1RI0te25q3fEaVzAuHbcS8D5c4JGChBOiC4A8TooiSRn
         Njzny9Z++S87gFFgRMS20IXcpjMHiReOVPVIeVrpizNO5GBJhOub2UqxtXj5rluPj9t1
         A3jy4lI+AIkHYQe0907l6eJSEPx4Z9G2vKRZpwXhpk5B+T7P78q//AbhbnfHAvmURbhW
         OFozFTVBl2P/rPdE8+Sn+E3fWHYHxC9zgWH9V7EBWxlH546LgJW9y2TlRqZPN9iI58ic
         IFCg==
X-Gm-Message-State: APjAAAVsG6MTKUVX1lb+WWiGoyf7CuKnK4bkUhx9AYLIeMW5+yc1h/vU
        mG+JLBYDkkw5rMgp2QzMuVzyl0lXXhs=
X-Google-Smtp-Source: APXvYqwWYr0F5q69cQb0x8WHQhuhEYUfvKb/FOLFgaNIxtBQmVWIgmZH8ZXdrS7SLCvIgOV8jZoIng==
X-Received: by 2002:a2e:b5c4:: with SMTP id g4mr8240839ljn.169.1572611941147;
        Fri, 01 Nov 2019 05:39:01 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f25sm2349909ljp.100.2019.11.01.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:39:00 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 3/3] net: bridge: fdb: restore unlikely() when taking over externally added entries
Date:   Fri,  1 Nov 2019 14:38:44 +0200
Message-Id: <20191101123844.17518-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
References: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taking over hw-learned entries is not a likely scenario so restore the
unlikely() use for the case of SW taking over externally learned
entries.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 7500c84fc675..284b3662d234 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -587,8 +587,10 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-				test_and_clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
-						   &fdb->flags);
+				if (unlikely(test_bit(BR_FDB_ADDED_BY_EXT_LEARN,
+						      &fdb->flags)))
+					clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
+						  &fdb->flags);
 			}
 			if (now != fdb->updated)
 				fdb->updated = now;
-- 
2.21.0

