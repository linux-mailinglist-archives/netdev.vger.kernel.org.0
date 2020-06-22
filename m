Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44617204432
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgFVXCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731268AbgFVXCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 19:02:13 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C730720738;
        Mon, 22 Jun 2020 23:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592866932;
        bh=6/yCpyjWjtd5QDSuX8I0LLUq4Bd1x+0uiGkmMMhUS0A=;
        h=Date:From:To:Cc:Subject:From;
        b=dw14yVKDOtzqB8fZZ4UnYecQOb8+XUo3yiNw6ZP4jeGZSEZAUftgZfmGvIRbGQUN4
         bDnsUxgzkhrEC0oCczHV/H2jrRHIrtqi2GanhqG0myZQnLatWFsusiz5QIR8agR57B
         8KvzrCM3bOy9TJDABAoVE4H7f3akJ72VywG+iwyg=
Date:   Mon, 22 Jun 2020 18:07:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: ipv6: Use struct_size() helper and kcalloc()
Message-ID: <20200622230741.GA28911@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes. Also, remove unnecessary
function ipv6_rpl_srh_alloc_size() and replace kzalloc() with kcalloc(),
which has a 2-factor argument form for multiplication.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/net/rpl.h       | 6 ------
 net/ipv6/exthdrs.c      | 2 +-
 net/ipv6/rpl_iptunnel.c | 3 +--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/net/rpl.h b/include/net/rpl.h
index dceff60e8baf..308ef0a05cae 100644
--- a/include/net/rpl.h
+++ b/include/net/rpl.h
@@ -26,12 +26,6 @@ static inline void rpl_exit(void) {}
 /* Worst decompression memory usage ipv6 address (16) + pad 7 */
 #define IPV6_RPL_SRH_WORST_SWAP_SIZE (sizeof(struct in6_addr) + 7)
 
-static inline size_t ipv6_rpl_srh_alloc_size(unsigned char n)
-{
-	return sizeof(struct ipv6_rpl_sr_hdr) +
-		((n + 1) * sizeof(struct in6_addr));
-}
-
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre);
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 5a8bbcdcaf2b..e9b366994475 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -580,7 +580,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	hdr->segments_left--;
 	i = n - hdr->segments_left;
 
-	buf = kzalloc(ipv6_rpl_srh_alloc_size(n + 1) * 2, GFP_ATOMIC);
+	buf = kcalloc(struct_size(hdr, segments.addr, n + 2), 2, GFP_ATOMIC);
 	if (unlikely(!buf)) {
 		kfree_skb(skb);
 		return -1;
diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index c3ececd7cfc1..5fdf3ebb953f 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -136,8 +136,7 @@ static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
 
 	oldhdr = ipv6_hdr(skb);
 
-	buf = kzalloc(ipv6_rpl_srh_alloc_size(srh->segments_left - 1) * 2,
-		      GFP_ATOMIC);
+	buf = kcalloc(struct_size(srh, segments.addr, srh->segments_left), 2, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 
-- 
2.27.0

