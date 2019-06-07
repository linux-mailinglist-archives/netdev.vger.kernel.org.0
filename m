Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E428394E7
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfFGSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:55:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39348 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731177AbfFGSzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:55:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so1686636pfe.6
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AFsrz4MnIZhN/Ff2+bpCYCTdE107aPSUu5QDkNt++tc=;
        b=y8+mim6PJ6A/kmBtbnShJwlX60LMKV0W1ZEQ1aCiCnjDQR7jHXVMBOo/ecUacvAEtv
         qw5vU5LFE2EZuhh2wpLo74oiNlQ7psgzvXLCJ4qMgaFaZ3nHtAhHd1DZ4UhY5eqOYuOO
         alvoxLs1ju96r5DQ478CpeCYunv1CV6AVq61glnZJJg2SCYlN2XNYlCISUnRuLxMJyio
         Br4de5l6rbQtDmbosTTTbVR3aXJ/G6OMfY5bhnFZeefv0ddEcsJU7uXpweX8qUYC8MbK
         ksoM4n/t42vZGqJwTP462SvE5IU+oFI9dhDRlbfSToWJB6nRC8NBMfjbe78MoBL04Wx/
         wQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AFsrz4MnIZhN/Ff2+bpCYCTdE107aPSUu5QDkNt++tc=;
        b=VcWd3VBTFrDWBKwgRkIRNLHTKE3TfXWnBcP8zCqVdIJXy5A/GxBiZzSzH5U3RWxaFO
         TpqOshNfJzXUj4IAjLMmtcB39D/mCxL0nAWyHc8HmYZkJ53ew/JN5YGuCAQP/GMZNaUY
         fWQBj5RjdgtMBPN3fkEjUwTP490StsJvtnlDvTu4EBtOkI5uKk3pObp2E1acg6FAp9aY
         TbYbuGntbK2AVti+ULLlXBb4Z+OyCf1z7biByqRY8sGu6D+4Iabrx09pTlUWVTg9FycY
         pUzJN3crJGgczD9WhWhongaJ6AFfmS5cKbMPUIycdBK9goPgwnyqIkvxlws45+i7uxZP
         r7ug==
X-Gm-Message-State: APjAAAV77vZpgSvGqEW2qBvOhcCX5wv3TCEP5DQZWJ/CWhrBfamzuGBl
        hrAe/08BrV2CjwjQaESppQERYA==
X-Google-Smtp-Source: APXvYqyPVioKwgCXdFICKW82N3w1+n5oKwRF/zz/EAgMMBT0pdjtVkEgTiOxveGCKCwvpCfHKjP2tQ==
X-Received: by 2002:a17:90a:5d15:: with SMTP id s21mr7375444pji.125.1559933751187;
        Fri, 07 Jun 2019 11:55:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:55:50 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 2/5] seg6: Obsolete unused SRH flags
Date:   Fri,  7 Jun 2019 11:55:05 -0700
Message-Id: <1559933708-13947-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently no flags are defined for segment routing in
draft-ietf-6man-segment-routing-header-19. Mark them as being
obsolete.

The HMAC flag is the only one used by the stack. This needs
additional consideration. Rewrite sr_has_hmac in uapi/linux/seg6.h
to properly parse a segment routing header as opposed to relying
on the now obsolete flag.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/seg6.h | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/seg6.h b/include/uapi/linux/seg6.h
index 3a7d324..0d19a9c 100644
--- a/include/uapi/linux/seg6.h
+++ b/include/uapi/linux/seg6.h
@@ -33,11 +33,10 @@ struct ipv6_sr_hdr {
 	struct in6_addr segments[0];
 };
 
-#define SR6_FLAG1_PROTECTED	(1 << 6)
-#define SR6_FLAG1_OAM		(1 << 5)
-#define SR6_FLAG1_ALERT		(1 << 4)
-#define SR6_FLAG1_HMAC		(1 << 3)
-
+#define SR6_FLAG1_PROTECTED	(1 << 6)	/* obsoleted */
+#define SR6_FLAG1_OAM		(1 << 5)	/* obsoleted */
+#define SR6_FLAG1_ALERT		(1 << 4)	/* obsoleted */
+#define SR6_FLAG1_HMAC		(1 << 3)	/* obsoleted */
 
 #define SR6_TLV_INGRESS		1	/* obsoleted */
 #define SR6_TLV_EGRESS		2	/* obsoleted */
@@ -47,12 +46,42 @@ struct ipv6_sr_hdr {
 #define SR6_TLV_PADN		1
 #define SR6_TLV_HMAC		5
 
-#define sr_has_hmac(srh) ((srh)->flags & SR6_FLAG1_HMAC)
-
 struct sr6_tlv {
 	__u8 type;
 	__u8 len;
 	__u8 data[0];
 };
 
+static inline int sr_hmac_offset(struct ipv6_sr_hdr *srh)
+{
+	unsigned char *opt = (unsigned char *)srh;
+	unsigned int off = sizeof(*srh) + ((srh->first_segment + 1) << 4);
+	int len = ((srh->hdrlen + 1) << 8) - off;
+	unsigned int optlen;
+
+	while (len > 0) {
+		switch (opt[off]) {
+		case SR6_TLV_PAD1:
+			optlen = 1;
+			break;
+		case SR6_TLV_HMAC:
+			return off;
+		default:
+			if (len < sizeof(struct sr6_tlv))
+				return 0;
+
+			optlen = sizeof(struct sr6_tlv) +
+				 ((struct sr6_tlv *)&opt[off])->len;
+			break;
+		}
+
+		off += optlen;
+		len -= optlen;
+	}
+
+	return 0;
+}
+
+#define sr_has_hmac(srh) (!!sr_hmac_offset(srh))
+
 #endif
-- 
2.7.4

