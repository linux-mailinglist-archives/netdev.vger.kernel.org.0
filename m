Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5713C234055
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgGaHnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731743AbgGaHng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:43:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3FCC061574;
        Fri, 31 Jul 2020 00:43:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f1so26528969wro.2;
        Fri, 31 Jul 2020 00:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WhzbRSw5E6SHkGA8pDiRZO+zNyS5dxi3MpLammaq7UA=;
        b=KfyuTJ4Gtk4hGsA1Wq1IhjgVPtiQ36dnZa/t6fRXzAwwm6XusZGjrt5Ea7xLBjic6Z
         u9qpiWc2x9xVKc16FqRRjcnOGajwNWfFR6BLGWdVI3fhZUMrRt8JiBxZJvEtquDid74q
         Rzvdbp2T0e9TD+0uPaajJreFTbL04Yk0LjcDD30S77y4txCk4NDiwTfuUmL/ah4wwzLp
         uJWyaKiu3PDXxAIcFwB7ajCKFtwUOCKCfiJCdh61NmS+chD8vx4Cq+bm4UOqujBFWc1m
         JW+aCvrfEA0k8LOdbNs2T+9c5OlGQ05PMgA+/uH+lAMt7JZVI8UHY8qOy2NGI8aocRuL
         txng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WhzbRSw5E6SHkGA8pDiRZO+zNyS5dxi3MpLammaq7UA=;
        b=LISZDs1RAxWUyOaiT3/vGDkjYEov2r0pMX6z9bqnwpbvgSCPB7XirCi3Dm8DAuNgsV
         vEgsNhB3Hi4+r9i8Id/rs1AfGP8kYmYxJ1nwg12No32QKWSC89ixTMiSQ1JmfF/StNJ8
         Etm3hoI/Q7EOm7GU/tvlLSsm3D0M3mI+pb4df3p6mj2C/CYLfECcOuz375WBNVZWgwl4
         nD9CxT8yhNlsmjHorzsl7gWNFJYw7Dt9cDaW4eroWkZQQ9BQKp64huGL51pLZTJ9po0I
         xduV0gLqACZQQHWH9c4menY1hJyZrqt0uH432+0T/Dqkm84qNVx1jDVWqCJPh7pnsLKi
         gyyQ==
X-Gm-Message-State: AOAM530Ld69xUnptwiQE6Twwf89T7hu4iugQy/cd/8AxN7aDRmh/9/NO
        pFaLqGUeGxjPa76nxM24027DWvy+UncfNw==
X-Google-Smtp-Source: ABdhPJw4WcKfjS1GuA3Jd1DuXEjmQr39V60Xh485uf1E+Ip8EQDwNnO5vR32lZv2cfV8gs9SsIh9lQ==
X-Received: by 2002:adf:ea85:: with SMTP id s5mr2451331wrm.55.1596181414749;
        Fri, 31 Jul 2020 00:43:34 -0700 (PDT)
Received: from stancioi.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 129sm12386124wmd.48.2020.07.31.00.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 00:43:34 -0700 (PDT)
From:   Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
To:     david.lebrun@uclouvain.be, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     elver@google.com, glider@google.com,
        =?UTF-8?q?Ioana-Ruxandra=20St=C4=83ncioi?= <stancioi@google.com>
Subject: [PATCH v2] seg6_iptunnel: Refactor seg6_lwt_headroom out of uapi header
Date:   Fri, 31 Jul 2020 07:40:32 +0000
Message-Id: <20200731074032.293456-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stăncioi <stancioi@google.com>

Refactor the function seg6_lwt_headroom out of the seg6_iptunnel.h uapi
header, because it is only used in seg6_iptunnel.c. Moreover, it is only
used in the kernel code, as indicated by the "#ifdef __KERNEL__".

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Ioana-Ruxandra Stăncioi <stancioi@google.com>
---
v2:
* Apply David's suggestion and just move the function.
---
 include/uapi/linux/seg6_iptunnel.h | 21 ---------------------
 net/ipv6/seg6_iptunnel.c           | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index 09fb608a35ec..eb815e0d0ac3 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -37,25 +37,4 @@ enum {
 	SEG6_IPTUN_MODE_L2ENCAP,
 };
 
-#ifdef __KERNEL__
-
-static inline size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
-{
-	int head = 0;
-
-	switch (tuninfo->mode) {
-	case SEG6_IPTUN_MODE_INLINE:
-		break;
-	case SEG6_IPTUN_MODE_ENCAP:
-		head = sizeof(struct ipv6hdr);
-		break;
-	case SEG6_IPTUN_MODE_L2ENCAP:
-		return 0;
-	}
-
-	return ((tuninfo->srh->hdrlen + 1) << 3) + head;
-}
-
-#endif
-
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e0e9f48ab14f..d8aa9fdc5819 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -27,6 +27,23 @@
 #include <net/seg6_hmac.h>
 #endif
 
+static inline size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
+{
+	int head = 0;
+
+	switch (tuninfo->mode) {
+	case SEG6_IPTUN_MODE_INLINE:
+		break;
+	case SEG6_IPTUN_MODE_ENCAP:
+		head = sizeof(struct ipv6hdr);
+		break;
+	case SEG6_IPTUN_MODE_L2ENCAP:
+		return 0;
+	}
+
+	return ((tuninfo->srh->hdrlen + 1) << 3) + head;
+}
+
 struct seg6_lwt {
 	struct dst_cache cache;
 	struct seg6_iptunnel_encap tuninfo[];
-- 
2.28.0.163.g6104cc2f0b6-goog

