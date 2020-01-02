Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD86112E8E8
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgABQr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:47:59 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39917 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbgABQr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 11:47:59 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 788c11af;
        Thu, 2 Jan 2020 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=+xbH0+5KnPLYCpQC34RESx3BY
        Bs=; b=wjdK86hmzO1iIQdfWDuooT6IbcmLUfX+ahMz81cahPxIIhLjS0FyRcxIH
        wLpvl/q/7Pr5sZ+ASNTOHA6QYbDczM313tvw9cgnHTRdW5vdkVLjQAPMj3pU1byv
        y+tIU/PdN92IwG1U4BXJWTKveb5eVmbmJwKuy9BtVdmvKfohXw+BSS+j/EaiKs30
        N+3xAoQsAyfaNIeif+GlOWMoTSo1tBPrsUjRmf3/vNHviaj83GiqXeqaa6Pbpbih
        pkwv+Vl0F5xPNLN35x6qo77XneeZyuVEVRAc7Bu6V6GKQ2nP0eedJpP/zwGf70tl
        XZbmVmNQEzGu9wNlPeUPL7t9ZqEVg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e6e7a26a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jan 2020 15:49:26 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 2/3] wireguard: queueing: do not account for pfmemalloc when clearing skb header
Date:   Thu,  2 Jan 2020 17:47:50 +0100
Message-Id: <20200102164751.416922-3-Jason@zx2c4.com>
In-Reply-To: <20200102164751.416922-1-Jason@zx2c4.com>
References: <20200102164751.416922-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before 8b7008620b84 ("net: Don't copy pfmemalloc flag in __copy_skb_
header()"), the pfmemalloc flag used to be between headers_start and
headers_end, which is a region we clear when preparing the packet for
encryption/decryption. This is a parameter we certainly want to
preserve, which is why 8b7008620b84 moved it out of there. The code here
was written in a world before 8b7008620b84, though, where we had to
manually account for it. This commit brings things up to speed.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/queueing.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index e49a464238fd..fecb559cbdb6 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -83,13 +83,10 @@ static inline __be16 wg_skb_examine_untrusted_ip_hdr(struct sk_buff *skb)
 
 static inline void wg_reset_packet(struct sk_buff *skb)
 {
-	const int pfmemalloc = skb->pfmemalloc;
-
 	skb_scrub_packet(skb, true);
 	memset(&skb->headers_start, 0,
 	       offsetof(struct sk_buff, headers_end) -
 		       offsetof(struct sk_buff, headers_start));
-	skb->pfmemalloc = pfmemalloc;
 	skb->queue_mapping = 0;
 	skb->nohdr = 0;
 	skb->peeked = 0;
-- 
2.24.1

