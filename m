Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94331139FC8
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgANDNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:13:21 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:53584 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbgANDNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 22:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=sthfG
        cXx9SjArwQm3b4jw5yBTOD47j551bJkJ+Qm1Zo=; b=ek/NqwhzNK4T/UVf8HOfX
        srpCwW1haOsocXrwDE9CFulPVLw8NIJxvkvUn1d5I8phReHp4u27deTGLSvRkFGV
        dBCnL7DrEV+RF/YEHhpipvNoiCvaXIKREiy8Yac/xdxldReBqxIaVbp3/ujiw1Lg
        UzKUoq8bl8ygb5ipsv14gM=
Received: from xilei-TM1604.mioffice.cn (unknown [106.37.187.207])
        by smtp2 (Coremail) with SMTP id GtxpCgCnOBGeMR1eFuUiAA--.5247S4;
        Tue, 14 Jan 2020 11:12:31 +0800 (CST)
From:   Niu Xilei <niu_xilei@163.com>
To:     davem@davemloft.net
Cc:     tglx@linutronix.de, fw@strlen.de, peterz@infradead.org,
        steffen.klassert@secunet.com, bigeasy@linutronix.de,
        jonathan.lemon@gmail.com, pabeni@redhat.com,
        anshuman.khandual@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Niu Xilei <niu_xilei@163.com>
Subject: [v4] pktgen: Allow configuration of IPv6 source address range
Date:   Tue, 14 Jan 2020 11:12:29 +0800
Message-Id: <20200114031229.8569-1-niu_xilei@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgCnOBGeMR1eFuUiAA--.5247S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxur47Zr17uF4DAF47CryxAFb_yoWruryUpa
        y3Ja43XrW3Aw43tanxJr9Fvr43uw4v9345XFW7A3sY9F1DWry0yay8G3W7KFWjgry0krWq
        qr4UKr4qgF4qqFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jztC7UUUUU=
X-Originating-IP: [106.37.187.207]
X-CM-SenderInfo: pqlxs5plohxqqrwthudrp/1tbiTh+qgFUDB6rnvwAAsY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pktgen can use only one IPv6 source address from output device or src6
command setting. In pressure test we need create lots of sessions more
than 65535. So add src6_min and src6_max command to set the range.

Signed-off-by: Niu Xilei <niu_xilei@163.com>

Changes since v3:
 - function set_src_in6_addr use static instead of static inline
 - precompute min_in6_l,min_in6_h,max_in6_h,max_in6_l in setup time
Changes since v2:
 - reword subject line
Changes since v1:
 - only create IPv6 source address over least significant 64 bit range
---
 net/core/pktgen.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 294bfcf0ce0e..890be1b4877e 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -323,6 +323,10 @@ struct pktgen_dev {
 	struct in6_addr max_in6_daddr;
 	struct in6_addr min_in6_saddr;
 	struct in6_addr max_in6_saddr;
+	u64  max_in6_h;
+	u64  max_in6_l;
+	u64  min_in6_h;
+	u64  min_in6_l;
 
 	/* If we're doing ranges, random or incremental, then this
 	 * defines the min/max for those ranges.
@@ -1355,6 +1359,59 @@ static ssize_t pktgen_if_write(struct file *file,
 		sprintf(pg_result, "OK: dst6_max=%s", buf);
 		return count;
 	}
+	if (!strcmp(name, "src6_min")) {
+		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
+		if (len < 0)
+			return len;
+
+		pkt_dev->flags |= F_IPV6;
+
+		if (copy_from_user(buf, &user_buffer[i], len))
+			return -EFAULT;
+		buf[len] = 0;
+
+		in6_pton(buf, -1, pkt_dev->min_in6_saddr.s6_addr, -1, NULL);
+		snprintf(buf, sizeof(buf), "%pI6c", &pkt_dev->min_in6_saddr);
+
+		memcpy(&pkt_dev->min_in6_h, pkt_dev->min_in6_saddr.s6_addr, 8);
+		memcpy(&pkt_dev->min_in6_l, pkt_dev->min_in6_saddr.s6_addr + 8, 8);
+		pkt_dev->min_in6_h = be64_to_cpu(pkt_dev->min_in6_h);
+		pkt_dev->min_in6_l = be64_to_cpu(pkt_dev->min_in6_l);
+
+		pkt_dev->cur_in6_saddr = pkt_dev->min_in6_saddr;
+		if (debug)
+			pr_debug("src6_min set to: %s\n", buf);
+
+		i += len;
+		sprintf(pg_result, "OK: src6_min=%s", buf);
+		return count;
+	}
+	if (!strcmp(name, "src6_max")) {
+		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
+		if (len < 0)
+			return len;
+
+		pkt_dev->flags |= F_IPV6;
+
+		if (copy_from_user(buf, &user_buffer[i], len))
+			return -EFAULT;
+		buf[len] = 0;
+
+		in6_pton(buf, -1, pkt_dev->max_in6_saddr.s6_addr, -1, NULL);
+		snprintf(buf, sizeof(buf), "%pI6c", &pkt_dev->max_in6_saddr);
+
+		memcpy(&pkt_dev->max_in6_h, pkt_dev->max_in6_saddr.s6_addr, 8);
+		memcpy(&pkt_dev->max_in6_l, pkt_dev->max_in6_saddr.s6_addr + 8, 8);
+		pkt_dev->max_in6_h = be64_to_cpu(pkt_dev->max_in6_h);
+		pkt_dev->max_in6_l = be64_to_cpu(pkt_dev->max_in6_l);
+
+		if (debug)
+			pr_debug("src6_max set to: %s\n", buf);
+
+		i += len;
+		sprintf(pg_result, "OK: src6_max=%s", buf);
+		return count;
+	}
 	if (!strcmp(name, "src6")) {
 		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
 		if (len < 0)
@@ -2286,6 +2343,45 @@ static void set_cur_queue_map(struct pktgen_dev *pkt_dev)
 	pkt_dev->cur_queue_map  = pkt_dev->cur_queue_map % pkt_dev->odev->real_num_tx_queues;
 }
 
+/* generate ipv6 source addr */
+static void set_src_in6_addr(struct pktgen_dev *pkt_dev)
+{
+	u64 min6, max6, rand, i;
+	struct in6_addr addr6;
+	__be64 addr_l, *t;
+
+	min6 = pkt_dev->min_in6_l;
+	max6 = pkt_dev->max_in6_l;
+
+	/* only generate source address in least significant 64 bits range
+	 * most significant 64 bits must be equal
+	 */
+	if (pkt_dev->max_in6_h != pkt_dev->min_in6_h || min6 >= max6)
+		return;
+
+	addr6 = pkt_dev->min_in6_saddr;
+	t = (__be64 *)addr6.s6_addr + 1;
+
+	if (pkt_dev->flags & F_IPSRC_RND) {
+		do {
+			prandom_bytes(&rand, sizeof(rand));
+			rand = rand % (max6 - min6) + min6;
+			addr_l = cpu_to_be64(rand);
+			memcpy(t, &addr_l, 8);
+		} while (ipv6_addr_loopback(&addr6) ||
+			 ipv6_addr_v4mapped(&addr6) ||
+			 ipv6_addr_is_multicast(&addr6));
+	} else {
+		addr6 = pkt_dev->cur_in6_saddr;
+		i = be64_to_cpu(*t);
+		if (++i > max6)
+			i = min6;
+		addr_l = cpu_to_be64(i);
+		memcpy(t, &addr_l, 8);
+	}
+	pkt_dev->cur_in6_saddr = addr6;
+}
+
 /* Increment/randomize headers according to flags and current values
  * for IP src/dest, UDP src/dst port, MAC-Addr src/dst
  */
@@ -2454,6 +2550,8 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
+		set_src_in6_addr(pkt_dev);
+
 		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
-- 
2.20.1

