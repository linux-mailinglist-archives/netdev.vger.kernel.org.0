Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2500B553FF
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbfFYQIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:08:16 -0400
Received: from sesbmg22.ericsson.net ([193.180.251.48]:63344 "EHLO
        sesbmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfFYQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1561478893; x=1564070893;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MunnddkiuxDa44z5VFhlH4foZ3OIsxxjgBGKwWbDa0k=;
        b=eP1DcMR3LnYTLouRcoE/2cNOC6sGG4DrBbdU9fyqc1OAR1VmXUTB+IH4wXaGYH2q
        BzXqUM0QAnsDpEzP3O3sKbi8Tr2y76ngcGqL44WxJrX8ciLSj6VNYvNiJDvVPzKs
        SdT8VjuJwG8cOk/AkxINBGMkTuZeO7m+0SlbHzEbHxE=;
X-AuditID: c1b4fb30-6ddff70000001814-5d-5d1246ed8529
Received: from ESESBMB503.ericsson.se (Unknown_Domain [153.88.183.116])
        by sesbmg22.ericsson.net (Symantec Mail Security) with SMTP id 90.9A.06164.DE6421D5; Tue, 25 Jun 2019 18:08:13 +0200 (CEST)
Received: from ESESBMR506.ericsson.se (153.88.183.202) by
 ESESBMB503.ericsson.se (153.88.183.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Jun 2019 18:08:13 +0200
Received: from ESESBMB505.ericsson.se (153.88.183.172) by
 ESESBMR506.ericsson.se (153.88.183.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Jun 2019 18:08:13 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.188) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 25 Jun 2019 18:08:12 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <jon.maloy@ericsson.com>,
        <canh.d.luu@dektech.com.au>, <ying.xue@windriver.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: eliminate unnecessary skb expansion during retransmission
Date:   Tue, 25 Jun 2019 18:08:13 +0200
Message-ID: <1561478893-31371-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsUyM2J7ie5bN6FYg8tv5CxuNPQwW8w538Ji
        sWL3JFaLt69msVscWyBmseV8lsWV9rPsFo+vX2d24PDYsvImk8e7K2weuxd8ZvL4vEnOY/2W
        rUwBrFFcNimpOZllqUX6dglcGUfWrWIuOMhWsfrrWdYGxiWsXYycHBICJhJ7lt1j72Lk4hAS
        OMoo8eVrI5TzjVHiVscPNjjn2Y53zBDOBUaJrus9jCD9bAIaEi+ndYDZIgLGEq9WdjKBFDEL
        PAaadX8VG0hCWCBC4s+mXywgNouAqsSbntNAcQ4OXgE3iee/wiDukJM4f/wnM4gtJKAsMffD
        NCYQm1dAUOLkzCdgrcwCEhIHX7xgnsDIPwtJahaS1AJGplWMosWpxUm56UZGeqlFmcnFxfl5
        enmpJZsYgeF7cMtvgx2ML587HmIU4GBU4uG9bicUK8SaWFZcmXuIUYKDWUmEd2miQKwQb0pi
        ZVVqUX58UWlOavEhRmkOFiVx3vXe/2KEBNITS1KzU1MLUotgskwcnFINjFUrmba0h0e5hm6O
        7VzxLXKq2fsTS0SMS2dva7ScmxbRUav9esLcuVeT9ikEKyxaP7U3Spd91xf2l2elJl0+71OQ
        NEfITfy9YdUdC8ZQX44bUovezl3mmZhywsZ/zpeDJ27NO7zEfIbtzYk1LmzKWQblf9borlGU
        D46pc5vomXVzsu3MJfVnfymxFGckGmoxFxUnAgCkl9x1WwIAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We increase the allocated headroom for the buffer copies to be
retransmitted. This eliminates the need for the lower stack levels
(UDP/IP/L2) to expand the headroom in order to add their own headers.

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index af50b53..aa79bf8 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1125,7 +1125,7 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 				continue;
 			TIPC_SKB_CB(skb)->nxt_retr = jiffies + TIPC_BC_RETR_LIM;
 		}
-		_skb = __pskb_copy(skb, MIN_H_SIZE, GFP_ATOMIC);
+		_skb = __pskb_copy(skb, LL_MAX_HEADER + MIN_H_SIZE, GFP_ATOMIC);
 		if (!_skb)
 			return 0;
 		hdr = buf_msg(_skb);
-- 
2.1.4

