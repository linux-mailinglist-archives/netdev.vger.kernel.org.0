Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23B5139EB2
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 02:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgANBCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 20:02:15 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:55096 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgANBCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 20:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Uelvu
        7kF0s69Lu17ZLO/24scVGUTvnSP2RRh1v1R1g0=; b=pcB0715yLWgMmKIeWhFrZ
        M4sTc9Uxm7DogZHJWitnB0jlzkriBdxf97DmgBv2VKjua9mGkbzPx5fridxneq+p
        kwm4fTtO9aD2O9mMsIs6Gy86jXxwTXtTUJSHzT/kMDH1rVXGKULrSmaaBGBNQsq9
        O5UgNGCcSQ0b1y5/7aCc1A=
Received: from xilei-TM1604.mioffice.cn (unknown [114.247.175.223])
        by smtp4 (Coremail) with SMTP id HNxpCgAnDSLkEh1ewZVvDw--.2666S4;
        Tue, 14 Jan 2020 09:01:24 +0800 (CST)
From:   Niu Xilei <niu_xilei@163.com>
To:     davem@davemloft.net
Cc:     tglx@linutronix.de, fw@strlen.de, peterz@infradead.org,
        steffen.klassert@secunet.com, bigeasy@linutronix.de,
        jonathan.lemon@gmail.com, pabeni@redhat.com,
        anshuman.khandual@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Niu Xilei <niu_xilei@163.com>
Subject: [v3] pktgen: Allow configuration of IPv6 source address range
Date:   Tue, 14 Jan 2020 09:01:22 +0800
Message-Id: <20200114010122.5327-1-niu_xilei@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgAnDSLkEh1ewZVvDw--.2666S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxur47Zr45Gr45Aw43Gr17KFg_yoWrJw45pa
        y3GF9xJryxZr43twsxJF9rtr1S9w4v9345XayfA3sY9FyDWryrA397Ga47KFyjqryvk398
        tr42ga90ga1qqrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2c_-UUUUU=
X-Originating-IP: [114.247.175.223]
X-CM-SenderInfo: pqlxs5plohxqqrwthudrp/xtbBRQSqgFPAEO8rFwAAs7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pktgen can use only one IPv6 source address from output device or src6
command setting. In pressure test we need create lots of sessions more than
65535. So add src6_min and src6_max command to set the range.

Signed-off-by: Niu Xilei <niu_xilei@163.com>

Changes since v2:
 - reword subject line
Changes since v1:
 - only create IPv6 source address over least significant 64 bit range
---
 net/core/pktgen.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 294bfcf0ce0e..33435ae0ba68 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1355,6 +1355,49 @@ static ssize_t pktgen_if_write(struct file *file,
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
+		if (debug)
+			pr_debug("dst6_max set to: %s\n", buf);
+
+		i += len;
+		sprintf(pg_result, "OK: dst6_max=%s", buf);
+		return count;
+	}
 	if (!strcmp(name, "src6")) {
 		len = strn_len(&user_buffer[i], sizeof(buf) - 1);
 		if (len < 0)
@@ -2286,6 +2329,51 @@ static void set_cur_queue_map(struct pktgen_dev *pkt_dev)
 	pkt_dev->cur_queue_map  = pkt_dev->cur_queue_map % pkt_dev->odev->real_num_tx_queues;
 }
 
+/* generate ipv6 source addr */
+static inline void set_src_in6_addr(struct pktgen_dev *pkt_dev)
+{
+	__be64 min6_h, min6_l, max6_h, max6_l, addr_l, *t;
+	u64 min6, max6, rand, i;
+	struct in6_addr addr6;
+
+	memcpy(&min6_h, pkt_dev->min_in6_saddr.s6_addr, 8);
+	memcpy(&min6_l, pkt_dev->min_in6_saddr.s6_addr + 8, 8);
+	memcpy(&max6_h, pkt_dev->max_in6_saddr.s6_addr, 8);
+	memcpy(&max6_l, pkt_dev->max_in6_saddr.s6_addr + 8, 8);
+
+	/* only generate source address in least significant 64 bits range
+	 * most significant 64 bits must be equal
+	 */
+	if (max6_h != min6_h)
+		return;
+
+	addr6 = pkt_dev->min_in6_saddr;
+	t = (__be64 *)addr6.s6_addr + 1;
+	min6 = be64_to_cpu(min6_l);
+	max6 = be64_to_cpu(max6_l);
+
+	if (min6 < max6) {
+		if (pkt_dev->flags & F_IPSRC_RND) {
+			do {
+				prandom_bytes(&rand, sizeof(rand));
+				rand = rand % (max6 - min6) + min6;
+				addr_l = cpu_to_be64(rand);
+				memcpy(t, &addr_l, 8);
+			} while (ipv6_addr_loopback(&addr6) ||
+				 ipv6_addr_v4mapped(&addr6) ||
+				 ipv6_addr_is_multicast(&addr6));
+		} else {
+			addr6 = pkt_dev->cur_in6_saddr;
+			i = be64_to_cpu(*t);
+			if (++i > max6)
+				i = min6;
+			addr_l = cpu_to_be64(i);
+			memcpy(t, &addr_l, 8);
+		}
+	}
+	pkt_dev->cur_in6_saddr = addr6;
+}
+
 /* Increment/randomize headers according to flags and current values
  * for IP src/dest, UDP src/dst port, MAC-Addr src/dst
  */
@@ -2454,6 +2542,8 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
+		set_src_in6_addr(pkt_dev);
+
 		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
-- 
2.20.1

