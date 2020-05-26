Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE9E1E29A6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgEZSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:07:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54013 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgEZSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:07:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jddyl-0007H4-4U; Tue, 26 May 2020 18:07:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netfilter: conntrack: fix an unsigned int comparison to less than zero
Date:   Tue, 26 May 2020 19:07:06 +0100
Message-Id: <20200526180706.199338-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error check to see if protoff is less than zero is always false
because it is a unsigned int.  The call to ipv6_skip_exthdr can return
negative values for an error so cast protoff to int to fix this check.

Addresses-Coverity: ("Macro compares unsigned to 0 (no effect)")
Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 08e0c19f6b39..2933b96a90c6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2114,7 +2114,7 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 		pnum = ipv6_hdr(skb)->nexthdr;
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
 					   &frag_off);
-		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+		if ((int)protoff < 0 || (frag_off & htons(~0x7)) != 0)
 			return 0;
 		break;
 	}
-- 
2.25.1

