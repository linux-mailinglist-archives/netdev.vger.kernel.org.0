Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6031514A41F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgA0MvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:51:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA0MvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:51:06 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7220153DBDB4;
        Mon, 27 Jan 2020 04:51:05 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:51:04 +0100 (CET)
Message-Id: <20200127.135104.544840622177386473.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     niu_xilei@163.com
Subject: [PATCH] Revert "pktgen: Allow configuration of IPv6 source address
 range"
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 04:51:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This reverts commit 7786a1af2a6bceb07860ec720e74714004438834.

It causes build failures on 32-bit, for example:

   net/core/pktgen.o: In function `mod_cur_headers':
>> pktgen.c:(.text.mod_cur_headers+0xba0): undefined reference to `__umoddi3'

Signed-off-by: David S. Miller <davem@davemloft.net>
---

As promised...

 net/core/pktgen.c | 98 -----------------------------------------------
 1 file changed, 98 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 890be1b4877e..294bfcf0ce0e 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -323,10 +323,6 @@ struct pktgen_dev {
 	struct in6_addr max_in6_daddr;
 	struct in6_addr min_in6_saddr;
 	struct in6_addr max_in6_saddr;
-	u64  max_in6_h;
-	u64  max_in6_l;
-	u64  min_in6_h;
-	u64  min_in6_l;
 
 	/* If we're doing ranges, random or incremental, then this
 	 * defines the min/max for those ranges.
@@ -1359,59 +1355,6 @@ static ssize_t pktgen_if_write(struct file *file,
 		sprintf(pg_result, "OK: dst6_max=%s", buf);
 		return count;
 	}
-	if (!strcmp(name, "src6_min")) {
-		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
-		if (len < 0)
-			return len;
-
-		pkt_dev->flags |= F_IPV6;
-
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
-		buf[len] = 0;
-
-		in6_pton(buf, -1, pkt_dev->min_in6_saddr.s6_addr, -1, NULL);
-		snprintf(buf, sizeof(buf), "%pI6c", &pkt_dev->min_in6_saddr);
-
-		memcpy(&pkt_dev->min_in6_h, pkt_dev->min_in6_saddr.s6_addr, 8);
-		memcpy(&pkt_dev->min_in6_l, pkt_dev->min_in6_saddr.s6_addr + 8, 8);
-		pkt_dev->min_in6_h = be64_to_cpu(pkt_dev->min_in6_h);
-		pkt_dev->min_in6_l = be64_to_cpu(pkt_dev->min_in6_l);
-
-		pkt_dev->cur_in6_saddr = pkt_dev->min_in6_saddr;
-		if (debug)
-			pr_debug("src6_min set to: %s\n", buf);
-
-		i += len;
-		sprintf(pg_result, "OK: src6_min=%s", buf);
-		return count;
-	}
-	if (!strcmp(name, "src6_max")) {
-		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
-		if (len < 0)
-			return len;
-
-		pkt_dev->flags |= F_IPV6;
-
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
-		buf[len] = 0;
-
-		in6_pton(buf, -1, pkt_dev->max_in6_saddr.s6_addr, -1, NULL);
-		snprintf(buf, sizeof(buf), "%pI6c", &pkt_dev->max_in6_saddr);
-
-		memcpy(&pkt_dev->max_in6_h, pkt_dev->max_in6_saddr.s6_addr, 8);
-		memcpy(&pkt_dev->max_in6_l, pkt_dev->max_in6_saddr.s6_addr + 8, 8);
-		pkt_dev->max_in6_h = be64_to_cpu(pkt_dev->max_in6_h);
-		pkt_dev->max_in6_l = be64_to_cpu(pkt_dev->max_in6_l);
-
-		if (debug)
-			pr_debug("src6_max set to: %s\n", buf);
-
-		i += len;
-		sprintf(pg_result, "OK: src6_max=%s", buf);
-		return count;
-	}
 	if (!strcmp(name, "src6")) {
 		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
 		if (len < 0)
@@ -2343,45 +2286,6 @@ static void set_cur_queue_map(struct pktgen_dev *pkt_dev)
 	pkt_dev->cur_queue_map  = pkt_dev->cur_queue_map % pkt_dev->odev->real_num_tx_queues;
 }
 
-/* generate ipv6 source addr */
-static void set_src_in6_addr(struct pktgen_dev *pkt_dev)
-{
-	u64 min6, max6, rand, i;
-	struct in6_addr addr6;
-	__be64 addr_l, *t;
-
-	min6 = pkt_dev->min_in6_l;
-	max6 = pkt_dev->max_in6_l;
-
-	/* only generate source address in least significant 64 bits range
-	 * most significant 64 bits must be equal
-	 */
-	if (pkt_dev->max_in6_h != pkt_dev->min_in6_h || min6 >= max6)
-		return;
-
-	addr6 = pkt_dev->min_in6_saddr;
-	t = (__be64 *)addr6.s6_addr + 1;
-
-	if (pkt_dev->flags & F_IPSRC_RND) {
-		do {
-			prandom_bytes(&rand, sizeof(rand));
-			rand = rand % (max6 - min6) + min6;
-			addr_l = cpu_to_be64(rand);
-			memcpy(t, &addr_l, 8);
-		} while (ipv6_addr_loopback(&addr6) ||
-			 ipv6_addr_v4mapped(&addr6) ||
-			 ipv6_addr_is_multicast(&addr6));
-	} else {
-		addr6 = pkt_dev->cur_in6_saddr;
-		i = be64_to_cpu(*t);
-		if (++i > max6)
-			i = min6;
-		addr_l = cpu_to_be64(i);
-		memcpy(t, &addr_l, 8);
-	}
-	pkt_dev->cur_in6_saddr = addr6;
-}
-
 /* Increment/randomize headers according to flags and current values
  * for IP src/dest, UDP src/dst port, MAC-Addr src/dst
  */
@@ -2550,8 +2454,6 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
-		set_src_in6_addr(pkt_dev);
-
 		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
-- 
2.21.1

