Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3749D25A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbiAZTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244371AbiAZTLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201AEC06174E
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF425616D6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64108C340EB;
        Wed, 26 Jan 2022 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224277;
        bh=AevhdFTBTW9OIurvhykP2rB2wGBcxt7p/InAn4l3nR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtMc+D8qOPrG0pIzGhufvdoPiX/oCdFi/JWz1j4rLWq4McFDQvs0wt2CNnTUdvYUd
         4Q8xVnD3S5/0AufBP4P9nES++uOj7fVD/93xcMXCJ4qEN6rhqYMaaL31m1upCWYQqA
         TRMVKhWGhBZGL5XUzls2jx5hU2NK1gE2ieFA4ldNrzF3CJ1MmrTuKdX3ZkEUMCZaid
         YieNluf1L+3xF7qE4ScgorbxxhNvDkfEYpvJmyoqeNV/KDI2SkPlXDumG0Z/rtfRI6
         RfVBMp0/5CcqapJ47nxJWTr8Ru3G/DsGZvP2lAMvnVCuP7OQYkdrSgMQ4axZwj5QLg
         1cTgTwi3qhNDw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/15] udplite: remove udplite_csum_outgoing()
Date:   Wed, 26 Jan 2022 11:11:05 -0800
Message-Id: <20220126191109.2822706-12-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not used since v4.0.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/udplite.h | 43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/include/net/udplite.h b/include/net/udplite.h
index 9185e45b997f..a3c53110d30b 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -70,49 +70,6 @@ static inline int udplite_checksum_init(struct sk_buff *skb, struct udphdr *uh)
 	return 0;
 }
 
-/* Slow-path computation of checksum. Socket is locked. */
-static inline __wsum udplite_csum_outgoing(struct sock *sk, struct sk_buff *skb)
-{
-	const struct udp_sock *up = udp_sk(skb->sk);
-	int cscov = up->len;
-	__wsum csum = 0;
-
-	if (up->pcflag & UDPLITE_SEND_CC) {
-		/*
-		 * Sender has set `partial coverage' option on UDP-Lite socket.
-		 * The special case "up->pcslen == 0" signifies full coverage.
-		 */
-		if (up->pcslen < up->len) {
-			if (0 < up->pcslen)
-				cscov = up->pcslen;
-			udp_hdr(skb)->len = htons(up->pcslen);
-		}
-		/*
-		 * NOTE: Causes for the error case  `up->pcslen > up->len':
-		 *        (i)  Application error (will not be penalized).
-		 *       (ii)  Payload too big for send buffer: data is split
-		 *             into several packets, each with its own header.
-		 *             In this case (e.g. last segment), coverage may
-		 *             exceed packet length.
-		 *       Since packets with coverage length > packet length are
-		 *       illegal, we fall back to the defaults here.
-		 */
-	}
-
-	skb->ip_summed = CHECKSUM_NONE;     /* no HW support for checksumming */
-
-	skb_queue_walk(&sk->sk_write_queue, skb) {
-		const int off = skb_transport_offset(skb);
-		const int len = skb->len - off;
-
-		csum = skb_checksum(skb, off, (cscov > len)? len : cscov, csum);
-
-		if ((cscov -= len) <= 0)
-			break;
-	}
-	return csum;
-}
-
 /* Fast-path computation of checksum. Socket may not be locked. */
 static inline __wsum udplite_csum(struct sk_buff *skb)
 {
-- 
2.34.1

