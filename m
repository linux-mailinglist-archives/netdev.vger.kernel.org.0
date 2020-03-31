Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C07E199C38
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbgCaQyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:54:55 -0400
Received: from [50.116.126.2] ([50.116.126.2]:40853 "EHLO
        gateway36.websitewelcome.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1730099AbgCaQyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:54:54 -0400
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2020 12:54:54 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 3C8A4405F3733
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 10:48:07 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id JJnQjSBPcSl8qJJnQjyDbH; Tue, 31 Mar 2020 11:31:24 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EHrjxQ0PBuyIpRl7KvpdYCDJDONL0mpYpyg5zK+DvTw=; b=ElCS6utXYq4w8jevd53lQnRTLg
        e34rAxmkiqLkbB50uJDIxzdcuFPd/i5IMpAbbyWPAQQW+kK+7j/SbmLP9bDRPd7D2AocOZNAJktA4
        zFfLm2Sb91zq27E8scRxR+9+8cndO8BXd0lNh6FefKamEbvR5Dm3aQXjQy41xgmQzWB5yc8E9PcDf
        b2zfbyGZbzn2TRMCGARs/1cC/Cn5Q4iXAZHKl4L7Ow/wsB0bq5mvQbDL0iDuyYiHlcFa/Nb4nL3cr
        lduw0lvTcXk654EWLmsfqAyGsgmshe1y2mCZxow57bewu8N/kdutCOUYVyFXsB8t85XluYm0xtio9
        gEHNEl2w==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:37440 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jJJnO-001Mca-Dn; Tue, 31 Mar 2020 11:31:22 -0500
Date:   Tue, 31 Mar 2020 11:35:06 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: ipv6: rpl_iptunnel: Fix potential memory leak
 in rpl_do_srh_inline
Message-ID: <20200331163506.GA5124@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jJJnO-001Mca-Dn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:37440
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case memory resources for buf were allocated, release them before
return.

Addresses-Coverity-ID: 1492011 ("Resource leak")
Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/ipv6/rpl_iptunnel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 203037afe001..a49ddc6cd020 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -155,8 +155,10 @@ static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
 	hdrlen = ((csrh->hdrlen + 1) << 3);
 
 	err = skb_cow_head(skb, hdrlen + skb->mac_len);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		kfree(buf);
 		return err;
+	}
 
 	skb_pull(skb, sizeof(struct ipv6hdr));
 	skb_postpull_rcsum(skb, skb_network_header(skb),
-- 
2.26.0

