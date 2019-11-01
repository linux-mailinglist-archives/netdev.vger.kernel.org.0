Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DDCEC320
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfKAMqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:46:52 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32896 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKAMqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:46:51 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so7152165lfc.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRmAVX0LKzbwaoPbTw2s+8QG+vaakhy1/lXDson76Zo=;
        b=WVnfw1qw2kzwmwk+Bp9IpqrORLjhdpN8OhiSzo8Xv72VKXWy2tLbyIGD3mCh1W0Px2
         qYwa3YUXQc3Ju0aOvn01M+LsQvckfc1hSkoa7sLG3s7EqFxUMPiluPy8qavqc3SlcKLk
         fbsPVon9M7sQ8Uk8iw0gKZERg44ug1XALBwJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRmAVX0LKzbwaoPbTw2s+8QG+vaakhy1/lXDson76Zo=;
        b=fCrFrNUZD0j/a5DhHnRjgBo/qfMIPRxkSpUEoCB03v5Hi3UVCGVQUG3mvyoYBeyoo0
         3rlsiVP0S8rbb+Iu9vVulEgItKpKjubcBuUm3Pu3navi2P2DngPdzSIPkVE7Z1tzjPt1
         knzSQYWRDJylqAo2YriqW3Gb6+97mtnejk+X0xCVTV9cmRKtBSDAUnB917ye2fcqs6GH
         drLPRgxcVV65LcjUjVUFXOylwNCN+VJkEDIFA12KYvj6y7UADcPcXlzy3IjpiwWkkTj5
         yE9dQLXY8+SnvKd9kiQX11oI407A0+4lIVWizwhIclaStOXApqcACQU8peknMlX2Hrr3
         RUAg==
X-Gm-Message-State: APjAAAWr+0dXygckLvV91i/hVz9uc9OQXNkjMfsV2QvxprE1OXVv+bog
        BT4iQFWncABOQOgTmoiqdmyGiIJvPiA=
X-Google-Smtp-Source: APXvYqwCAEQcQrFVqGdlSE1891H5EOu7bWUh3BXQnRMvTS02wzyPLYP0zf9hHcuC75XLsgRsUwYgeA==
X-Received: by 2002:ac2:5f0a:: with SMTP id 10mr7129371lfq.57.1572612409262;
        Fri, 01 Nov 2019 05:46:49 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t4sm2297909lji.40.2019.11.01.05.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:46:48 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 3/3] net: bridge: fdb: restore unlikely() when taking over externally added entries
Date:   Fri,  1 Nov 2019 14:46:39 +0200
Message-Id: <20191101124639.32140-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
References: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
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

