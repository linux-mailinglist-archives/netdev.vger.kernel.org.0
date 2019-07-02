Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116485CF10
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBMFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:05:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34183 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfGBMFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:05:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id u18so988962wru.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=idQcbvzPIu1BSdVQIplt97QLkM9ok6uSRBt+kD2R0VY=;
        b=Jcf5gvAuECDHnSqlWrJl59LMVaLbAq8Zcjj51ekAPjCZnrcPLabHmGPaEC/zzSNAPh
         REueJzvJg/hipwla5YFSjsi+BhDtSH0TpqY2lAxiiGvHbJ+3/HB8eyarYmn5Q3PdrQTy
         kwUI9wi0zeGfbhZDFT/O6IAGaK/a5cYvHspWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idQcbvzPIu1BSdVQIplt97QLkM9ok6uSRBt+kD2R0VY=;
        b=tJ2I7waBFJ2KAW/nYCXEhWLExxqT2/GOBudHQcRfPwGWvxQLBakujNWvBrdXOg9RzV
         8Z9zpUBZ/sQZPx/8DJzjEmVqtwRL3dux2bCMTgm0C+Ft6eRk6XW7BUUitevrVW7UtZ6k
         nQnfcCRwkVpJZ4mzoDyXMVcLPNPPysJ/MvnHW6ErwOpOrxT3co77tEuZmlV0wOBVDbjR
         z2o5pOFZEQbtfJgQzgRWyJx+XS2zfy5m+hILvCqjByQNnuqPdijT/IuaFPkIH1vdUWBZ
         SFcbiIOd7oWDm/4Tq1MXgH9r/M4nVwD2+gFXLPWSCoc/seJAxta+69+5V7JB/6SD8wCt
         HFBg==
X-Gm-Message-State: APjAAAXtBrH2l5cAqsk4/5tzdQqo/NIVZdnoN7uBz0Q7kXjKWOT+f4H1
        du/k9Y+0wcYp1McLp1jsSqI0nxC9eTI=
X-Google-Smtp-Source: APXvYqwfE1BZM0ah4AdPm6PvSxcO/B0fXqWs+cIVyF+4T5t9StbPfChMJtqePWxmMI2XbhzR6h38bA==
X-Received: by 2002:adf:ab0f:: with SMTP id q15mr7637137wrc.325.1562069106370;
        Tue, 02 Jul 2019 05:05:06 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x5sm2542655wmf.33.2019.07.02.05.05.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:05:05 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 4/4] net: bridge: stp: don't cache eth dest pointer before skb pull
Date:   Tue,  2 Jul 2019 15:00:21 +0300
Message-Id: <20190702120021.13096-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't cache eth dest pointer before calling pskb_may_pull.

Fixes: cf0f02d04a83 ("[BRIDGE]: use llc for receiving STP packets")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_stp_bpdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 68a6922b4141..7796dd9d42d7 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -143,7 +143,6 @@ void br_send_tcn_bpdu(struct net_bridge_port *p)
 void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 		struct net_device *dev)
 {
-	const unsigned char *dest = eth_hdr(skb)->h_dest;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	const unsigned char *buf;
@@ -172,7 +171,7 @@ void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 	if (p->state == BR_STATE_DISABLED)
 		goto out;
 
-	if (!ether_addr_equal(dest, br->group_addr))
+	if (!ether_addr_equal(eth_hdr(skb)->h_dest, br->group_addr))
 		goto out;
 
 	if (p->flags & BR_BPDU_GUARD) {
-- 
2.21.0

