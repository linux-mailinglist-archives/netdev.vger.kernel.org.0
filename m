Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E171136B3B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgAJKp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:45:58 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:39766 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgAJKp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:45:58 -0500
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2020 05:45:50 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=g2tbO
        +qzlpA2w5Cd7SBiifcvdUZuxRzhuQ247WytjJ4=; b=bREENsEDpS/bG1RHE+i7N
        Hn7cEFqrreokTkfTFoS6clEiQwS18uhJ7iGiXxCoISmha84Bqq0TehL6mxkq/Jdg
        u+n0JBaZdCh3x9bG50fHzx+4z6O1Kd/Z9EmGShVlzwSHMoQ4NSAJ0rzO+biT2KIG
        yWj58sXe7wRHwFRtE1ctJ4=
Received: from xilei-TM1604.mioffice.cn (unknown [114.247.175.196])
        by smtp5 (Coremail) with SMTP id HdxpCgCHCsjgURheqcdzDA--.474S4;
        Fri, 10 Jan 2020 18:29:26 +0800 (CST)
From:   Niu Xilei <niu_xilei@163.com>
To:     davem@davemloft.net
Cc:     tglx@linutronix.de, fw@strlen.de, peterz@infradead.org,
        pabeni@redhat.com, anshuman.khandual@arm.com,
        linyunsheng@huawei.com, bigeasy@linutronix.de,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Niu Xilei <niu_xilei@163.com>
Subject: [PATCH]     pktgen: create packet use  IPv6 source address between src6_min and src6_max.
Date:   Fri, 10 Jan 2020 18:28:42 +0800
Message-Id: <20200110102842.13585-1-niu_xilei@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCHCsjgURheqcdzDA--.474S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3AFyUZF4kGF4Uuw4UuryUJrb_yoWxWF1fpF
        W5JF98Jry7CF13Jw43JF9Iyw4a9ryvya47WayrZ34FkFs8XrW0vrn7KFy3tF4jqr1fA39x
        tw4UKa1jgan0vr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jNOz3UUUUU=
X-Originating-IP: [114.247.175.196]
X-CM-SenderInfo: pqlxs5plohxqqrwthudrp/1tbiTRmmgFc7O6dgPgAAsc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Pktgen can use only one IPv6 source address from output device, or src6 command
    setting. When in pressure test need create lots of session more than 65536.
    If IPSRC_RND flag is use random  address between src6_min and src6_max.

    The GCC  generates code that calls functions in the libgcc library to implement
    the / and % operations with 128-bit operands on 64-bit CPUs. So kernel need
    implement the function  to do / and % operation.

    Signed-off-by: Niu Xilei <niu_xilei@163.com>
---
 net/core/pktgen.c | 183 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 294bfcf0ce0e..b07ab5984fa8 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -254,6 +254,111 @@ struct flow_state {
 /* flow flag bits */
 #define F_INIT   (1<<0)		/* flow has been initialized */
 
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+
+__extension__ typedef  unsigned __int128 u128;
+
+/* Kernel not implement __int128's divide and modulo operator. Implement these
+ * operation use shift-subtract division algorithm  adpater from
+ * https://chromium.googlesource.com/chromium/src/third_party/+/master/abseil-cpp/absl/numeric/int128.cc */
+
+/* find first bit set of u128 */
+static inline int fls128(u128 n)
+{
+	u64 hi = n >> 64;
+
+	if (hi)
+		return fls64(hi) + 64;
+
+	return fls64((__u64)n);
+}
+
+/**
+ * div128_u128 - unsigned 128bit int divide with unsigned 128bit int divisor
+ * @dividend:   128bit dividend
+ * @divisor:    128bit divisor
+ * @remainder:  128bit  remainder
+ * @return:     128bit quotient
+ */
+u128 div128_u128(u128 dividend, u128 divisor, u128 *remainder)
+{
+	int i;
+	int shift;
+	u128 quotient = 0;
+	u128 denominator = divisor;
+
+	if (divisor > dividend) {
+		*remainder = dividend;
+		return 0;
+	}
+	if (divisor == dividend) {
+		*remainder = 0;
+		return 1;
+	}
+
+	/* Left aligns the MSB of the dividend and the dividend. */
+	shift = fls128(dividend) - fls128(denominator);
+	denominator <<= shift;
+	/* Uses shift-subtract algorithm to divide dividend by denominator. The
+	 * remainder will be left in dividend. */
+	for (i = 0; i <= shift; ++i) {
+		quotient <<= 1;
+		if (dividend >= denominator) {
+			dividend -= denominator;
+			quotient |= 1;
+		}
+		denominator >>= 1;
+	}
+	*remainder = dividend;
+	return quotient;
+}
+
+#ifdef __LITTLE_ENDIAN
+
+static inline u128 be128_to_cpu(u128 net128)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	u64 *pnet = (u64 *)&net128;
+
+	return (((__force u128)swab64(pnet[0]) << 64) |
+		(__force u128)swab64(pnet[1]));
+#else
+
+	u32 *pnet = (u32 *)&net128;
+
+	return (((__force u128)swap32(pnet[0])) << 96 |
+		((__force u128)swap32(pnet[1])) << 64 |
+		((__force u128)swap32(pnet[2])) << 32 |
+		(__force u128)swap32(pnet[3]));
+
+#endif
+}
+
+static inline u128 cpu_to_be128(u128 host128)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	u64 *phost = (u64 *)&host128;
+
+	return  (((__force u128)swab64(phost[0])) << 64 |
+		(__force u128)swab64(phost[1]));
+#else
+	u32 *phost = (u32 *)&host128;
+
+	return (((__force u128)swap32(phost[0])) << 96 |
+		((__force u128)swap32(phost[1])) << 64 |
+		((__force u128)swap32(phost[2])) << 32 |
+		(__force u128)swap32(phost[3]));
+#endif
+}
+
+#else /* !__LITTLE_ENDIAN  */
+
+#define be128_to_cpu(x) (x)
+#define cpu_to_be128(x) (x)
+
+#endif /* __LITTLE_ENDIAN */
+#endif /* CONFIG_ARCH_SUPPORTS_INT128 */
+
 struct pktgen_dev {
 	/*
 	 * Try to keep frequent/infrequent used vars. separated.
@@ -1355,6 +1460,49 @@ static ssize_t pktgen_if_write(struct file *file,
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
@@ -2286,6 +2434,38 @@ static void set_cur_queue_map(struct pktgen_dev *pkt_dev)
 	pkt_dev->cur_queue_map  = pkt_dev->cur_queue_map % pkt_dev->odev->real_num_tx_queues;
 }
 
+/* create ipv6 source addr, random generator or iterator between the range  */
+static inline void set_src_in6_addr(struct pktgen_dev *pkt_dev)
+{
+	u128 t;
+	u128 imn6, imx6;
+
+	if (!ipv6_addr_any(&pkt_dev->min_in6_saddr)) {
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+		imn6 = be128_to_cpu(*(u128 *)pkt_dev->min_in6_saddr.s6_addr);
+		imx6 = be128_to_cpu(*(u128 *)pkt_dev->max_in6_saddr.s6_addr);
+		if (imn6 < imx6) {
+			if (pkt_dev->flags & F_IPSRC_RND) {
+				do {
+					prandom_bytes(&t, sizeof(t));
+					/*t = t % range */
+					div128_u128(t, imx6 - imn6, &t);
+					t = imn6 + t;
+				} while (ipv6_addr_loopback((struct in6_addr *)&t) ||
+					 ipv6_addr_v4mapped((struct in6_addr *)&t) ||
+					 ipv6_addr_is_multicast((struct in6_addr *)(&t)));
+			} else {
+				t = be128_to_cpu(*(u128 *)pkt_dev->cur_in6_saddr.s6_addr);
+				t++;
+				if (t > imx6)
+					t = imn6;
+			}
+			t = cpu_to_be128(t);
+			pkt_dev->cur_in6_saddr = *(struct in6_addr *)&t;
+		}
+#endif
+	}
+}
 /* Increment/randomize headers according to flags and current values
  * for IP src/dest, UDP src/dst port, MAC-Addr src/dst
  */
@@ -2293,6 +2473,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 {
 	__u32 imn;
 	__u32 imx;
+
 	int flow = 0;
 
 	if (pkt_dev->cflows)
@@ -2454,6 +2635,8 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
+		set_src_in6_addr(pkt_dev);
+
 		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
-- 
2.20.1

