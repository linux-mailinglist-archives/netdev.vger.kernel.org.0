Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F54A65CE9E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbjADIqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbjADIpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:45:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855671B9E9;
        Wed,  4 Jan 2023 00:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672821928; x=1704357928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TBiocUlMd4lgD3UieKC9lMwBVyukIc3JWqKRD/9Iuek=;
  b=qAGnfVwhtvHN5KC07/1gtb12B5+ogSubJy3fi5XKYtiN55ZdZ8m+120j
   di6DMuz6uM1erV026EYMUT0IXDddl97H5eegojgxBjWvd/ixhlKdoAHuW
   ivL8b5WZExntGdo5A17CkCHQOwA8zJswKVBvP1P5UR1Dsn5SJTULHXD4O
   4d+FvSecdPbJxhhhefKLTke2gIkrWBlQQpJTc+UojQwbh0482Oa0Ej87X
   gRFWNp1Qbbe4WftMonzIoyfzgsMe5oa0c1e9y75B6fH87PMCO/nRJbwOf
   k+YhLxq5tiYwLZ8/FQ9cFjEvyMKTls6s/wLXZdmrTBtZJqMXYnwBBGt5r
   A==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="130719920"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2023 01:45:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 01:45:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 01:45:19 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P clocks
Date:   Wed, 4 Jan 2023 14:13:09 +0530
Message-ID: <20230104084316.4281-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230104084316.4281-1-arun.ramadoss@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

For P2P delay measurement, the ingress time stamp of the PDelay_Req is
required for the correction field of the PDelay_Resp. The application
echoes back the correction field of the PDelay_Req when sending the
PDelay_Resp.

Some hardware (like the ZHAW InES PTP time stamping IP core) subtracts
the ingress timestamp autonomously from the correction field, so that
the hardware only needs to add the egress timestamp on tx. Other
hardware (like the Microchip KSZ9563) reports the ingress time stamp via
an interrupt and requires that the software provides this time stamp via
tail-tag on tx.

In order to avoid introducing a further application interface for this,
the driver can simply emulate the behavior of the InES device and
subtract the ingress time stamp in software from the correction field.

On egress, the correction field can either be kept as it is (and the
time stamp field in the tail-tag is set to zero) or move the value from
the correction field back to the tail-tag.

Changing the correction field requires updating the UDP checksum (if UDP
is used as transport).

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1 -> v2
- Fixed compilation issue when PTP_CLASSIFY not selected in menuconfig
as reported by kernel test robot <lkp@intel.com>
---
 include/linux/ptp_classify.h | 71 ++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 2b6ea36ad162..6e5869c2504c 100644
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
@@ -129,6 +133,67 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
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
+ * ptp_header_update_correction - Update PTP header's correction field
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ * @hdr: ptp header
+ * @correction: new correction value
+ *
+ * This updates the correction field of a PTP header and updates the UDP
+ * checksum (if UDP is used as transport). It is needed for hardware capable of
+ * one-step P2P that does not already modify the correction field of Pdelay_Req
+ * event messages on ingress.
+ */
+static inline
+void ptp_header_update_correction(struct sk_buff *skb, unsigned int type,
+				  struct ptp_header *hdr, s64 correction)
+{
+	__be64 correction_old;
+	struct udphdr *uhdr;
+
+	/* previous correction value is required for checksum update. */
+	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
+
+	/* write new correction value */
+	put_unaligned_be64((u64)correction, &hdr->correction);
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+	case PTP_CLASS_IPV6:
+		/* locate udp header */
+		uhdr = (struct udphdr *)((char *)hdr - sizeof(struct udphdr));
+		break;
+	default:
+		return;
+	}
+
+	/* update checksum */
+	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
+						hdr->correction,
+						~csum_unfold(uhdr->check)));
+	if (!uhdr->check)
+		uhdr->check = CSUM_MANGLED_0;
+}
+
 /**
  * ptp_msg_is_sync - Evaluates whether the given skb is a PTP Sync message
  * @skb: packet buffer
@@ -166,5 +231,11 @@ static inline bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type)
 {
 	return false;
 }
+
+static inline
+void ptp_header_update_correction(struct sk_buff *skb, unsigned int type,
+				  struct ptp_header *hdr, s64 correction)
+{
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
-- 
2.36.1

