Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5605F2CE655
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgLDDRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLDDRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:17:12 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C40C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:16:32 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id r9so2259492pjl.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+NJ183lW8pLtZPUZUZ5nx/Wuq0zFK6HVT2A/DaRECak=;
        b=eP9HV8CgEK+vywN/jwojM1A2TKzPqijc2pDHbMdyKxiaWfy9GbYQ01omXa/YiswSVT
         T0lr6mJKGeax397EB+JocR5tPXs5LuiZR9O9nCZx2xX3M70VFAKlnA3yYWU+Bdg5UYFK
         CbJwMJjVjuPufme0pLrQ7Z+Z6a6dFAnZNOUsB57dK+UmnDTCFd9FGUFMVxYBheBHVJHX
         b90ZzYf4wrffoWp0gIl7fLgABhdl1wTtg0YU4aLhuqvrNLDM/r18xqZklGGWnmyqpRHB
         intsgENgV2QeMo9l6fZY0f9kqSbWShJOF4JhOARqMbbm2oTwh757lvXAW1wSSHJUTxYN
         QJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+NJ183lW8pLtZPUZUZ5nx/Wuq0zFK6HVT2A/DaRECak=;
        b=OhIuiz7N5oLei75fYhB/6oJfuhc0oO1Nr6YFxLJAe40G6ckqHEvsX412F+ctbqOAMv
         B1R3ge2Oc9l4rqIoo8wffF9+71a/oJ5ZYl1jfNoZ3SkUgAhgNsAeQ+Y7qPwlCVTHVGaE
         hlcUwLuGOMtWPN0OPrZGUGfl28CLSAPqf9ghugMEA1cXNoCUjDaOcs1P4zSD1g+PrDHL
         fpceGxCRGLHUpftosibIeze+V0CO60vOPTOG/PgJsAzGNpvcQPG7yw6vCE+kanDmUxq9
         U7iGzQp+pVM3VUEgeY+nRyUX1xeUT1bywlUdQeXTUJ5ySVBPlptVWkV1xg9AoOr70JL8
         TjFQ==
X-Gm-Message-State: AOAM530jZ0NARY6oBqNB8bDqLG9i1psGJFOpF2UePLVaOUk0TFLgoIYp
        JgNslzaxGeSvNVYHLp3SZXo=
X-Google-Smtp-Source: ABdhPJzq1ahAdU838h9w0N0AY6wqZ3dDBjqVAMMQ+74MNY/9dEDlYpSkpkKVjNFA4Tbdei4M+Ch4tQ==
X-Received: by 2002:a17:90a:17a4:: with SMTP id q33mr183715pja.0.1607051791945;
        Thu, 03 Dec 2020 19:16:31 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id z25sm2264439pge.66.2020.12.03.19.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:16:31 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] icmp: support for RFC 8335
Date:   Thu,  3 Dec 2020 19:16:30 -0800
Message-Id: <370f8a83f83bc201ef7f9fdd35aff86f632619a7.1607050389.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for PROBE ICMP types and codes.

Add a struct to represent the additional header when probing by IP
address (ctype == 3) for use in parsing incoming PROBE messages.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

---
 include/uapi/linux/icmp.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..0b69f1492f85 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -66,6 +66,21 @@
 #define ICMP_EXC_TTL		0	/* TTL count exceeded		*/
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
+/* Codes for EXT_ECHO (PROBE) */
+#define ICMP_EXT_ECHO		42
+#define ICMP_EXT_ECHOREPLY	43
+#define ICMP_EXT_MAL_QUERY	1	/* Malformed Query */
+#define ICMP_EXT_NO_IF		2	/* No such Interface */
+#define ICMP_EXT_NO_TABLE_ENT	3	/* No such Table Entry */
+#define ICMP_EXT_MULT_IFS	4	/* Multiple Interfaces Satisfy Query */
+
+/* constants for EXT_ECHO (PROBE) */
+#define EXT_ECHOREPLY_ACTIVE	(1 << 2)/* position of active flag in reply */
+#define EXT_ECHOREPLY_IPV4	(1 << 1)/* position of ipv4 flag in reply */
+#define EXT_ECHOREPLY_IPV6	1	/* position of ipv6 flag in reply */
+#define CTYPE_NAME		1
+#define CTYPE_INDEX		2
+#define CTYPE_ADDR		3
 
 struct icmphdr {
   __u8		type;
@@ -118,4 +133,11 @@ struct icmp_extobj_hdr {
 	__u8		class_type;
 };
 
+/* RFC 8335: 2.1 Header for C-type 3 payload */
+struct icmp_ext_ctype3_hdr {
+	__u16		afi;
+	__u8		addrlen;
+	__u8		reserved;
+};
+
 #endif /* _UAPI_LINUX_ICMP_H */
-- 
2.25.1

