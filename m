Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1523D2B08D0
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgKLPsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:48:53 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:54152 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgKLPsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:48:53 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CX5cG0Xfjz41lg;
        Thu, 12 Nov 2020 16:48:46 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5Zh6hgnz2xCK;
        Thu, 12 Nov 2020 16:47:24 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:40:21 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 08/11] net: ptp: add helper for one-step P2P clocks
Date:   Thu, 12 Nov 2020 16:35:34 +0100
Message-ID: <20201112153537.22383-9-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-164726-4CX5Zh6hgnz2xCK-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function subtracts the ingress hardware time stamp from the
correction field of a PTP header and updates the UDP checksum (if UDP is
used as transport. It is needed for hardware capable of one-step P2P
that does not already modify the correction field of Pdelay_Req event
messages on ingress.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 include/linux/ptp_classify.h | 97 ++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 56b2d7d66177..f27b512e1abd 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -10,8 +10,12 @@
 #ifndef _PTP_CLASSIFY_H_
 #define _PTP_CLASSIFY_H_
 
+#include <asm/unaligned.h>
 #include <linux/ip.h>
+#include <linux/ktime.h>
 #include <linux/skbuff.h>
+#include <linux/udp.h>
+#include <net/checksum.h>
 
 #define PTP_CLASS_NONE  0x00 /* not a PTP event message */
 #define PTP_CLASS_V1    0x01 /* protocol version 1 */
@@ -118,6 +122,91 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	return msgtype;
 }
 
+/**
+ * ptp_check_diff8 - Computes new checksum (when altering a 64-bit field)
+ * @old: old field value
+ * @new: new field value
+ * @oldsum: previous checksum
+ *
+ * This function can be used to calculate a new checksum when only a single
+ * field is changed. Similar as ip_vs_check_diff*() in ip_vs.h.
+ *
+ * Return: Updated checksum
+ */
+static inline __wsum ptp_check_diff8(__be64 old, __be64 new, __wsum oldsum)
+{
+	__be64 diff[2] = { ~old, new };
+
+	return csum_partial(diff, sizeof(diff), oldsum);
+}
+
+/**
+ * ptp_onestep_p2p_move_t2_to_correction - Update PTP header's correction field
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ * @hdr: ptp header
+ * @t2: ingress hardware time stamp
+ *
+ * This function subtracts the ingress hardware time stamp from the correction
+ * field of a PTP header and updates the UDP checksum (if UDP is used as
+ * transport). It is needed for hardware capable of one-step P2P that does not
+ * already modify the correction field of Pdelay_Req event messages on ingress.
+ */
+static inline
+void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
+					   unsigned int type,
+					   struct ptp_header *hdr,
+					   ktime_t t2)
+{
+	u8 *ptr = skb_mac_header(skb);
+	struct udphdr *uhdr = NULL;
+	s64 ns = ktime_to_ns(t2);
+	__be64 correction_old;
+	s64 correction;
+
+	/* previous correction value is required for checksum update. */
+	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
+	correction = (s64)be64_to_cpu(correction_old);
+
+	/* PTP correction field consists of 32 bit nanoseconds and 16 bit
+	 * fractional nanoseconds.  Avoid shifting negative numbers.
+	 */
+	if (ns >= 0)
+		correction -= ns << 16;
+	else
+		correction += -ns << 16;
+
+	/* write new correction value */
+	put_unaligned_be64((u64)correction, &hdr->correction);
+
+	/* locate udp header */
+	if (type & PTP_CLASS_VLAN)
+		ptr += VLAN_HLEN;
+
+	ptr += ETH_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		ptr += ((struct iphdr *)ptr)->ihl << 2;
+		uhdr = (struct udphdr *)ptr;
+		break;
+	case PTP_CLASS_IPV6:
+		ptr += IP6_HLEN;
+		uhdr = (struct udphdr *)ptr;
+		break;
+	}
+
+	if (!uhdr)
+		return;
+
+	/* update checksum */
+	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
+						hdr->correction,
+						~csum_unfold(uhdr->check)));
+	if (!uhdr->check)
+		uhdr->check = CSUM_MANGLED_0;
+}
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
@@ -140,5 +229,13 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	 */
 	return 0;
 }
+
+static inline
+void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
+					   unsigned int type,
+					   struct ptp_header *hdr,
+					   ktime_t t2)
+{
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

