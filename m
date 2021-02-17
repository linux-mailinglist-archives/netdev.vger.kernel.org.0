Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6181231DED0
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhBQSIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhBQSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:08:36 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9EFC061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:07:56 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o7so8992359pgl.1
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mq4jIowVCJDBpsMy8oSEIRebwN9HreAuVKbDCOXh2ug=;
        b=a01YoAoaPSTUufe0H+c33gJSkp7O5VzMZ9IG15S6teFnvF/Xi8v1w05KuwaBcGJ9Ch
         yVVJfGdeqZ0LsL7gOat+nhMwaTDsZOiVAb9H1U/wSu/ZZS0HeYuWAN3ah4MYKxEygNdQ
         pvZEJxDxX2L+jfra6fASzkEwB2vlbVvRckkcOiBUA9G4pnKyZ6rtvxmUQj47UslDQKiG
         QbsP2fBoCKwnmVhBcEmCE4qcgDwkeCJ0wmU9jPeWRVV7qA2Dsf0joxSi/rxBtKiSuKIF
         T/eWtD32ZWXhi7rzyRGFnEGxkbvPQ5YzDAE1Lo18jHfDm0bbMCfbr6MmLe5VvZRIeKOm
         KrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mq4jIowVCJDBpsMy8oSEIRebwN9HreAuVKbDCOXh2ug=;
        b=WbjVZ0/ddHKNygJoLw2dpwm/xzytkGqkDP57Fb8k5C3qvFxW4fxjcZnfiBx2c5IWkj
         IcEd+fbC3njvmOLimk+5EHZjjd6/00ur4WY7DNAkhOu9rsHxDitdrkOvQ6ybUMeaAv8l
         4p6kFSX+4NlC4t/uJWxnTxl1TEAp/8VXueEySqORnCjes9SLgZf/4p8Ah502q8hFLuHe
         IKS3q5/m+Xc5Yg18JEnOGvi2J2XeD/OirWB9CELB0ogHfZJKKZs1v47Il4vU3UXoxN0e
         Dmujzd5jVqXENnV9y+z1pDIKppdTMzSlV9kS1x8BJwHZ+KHjmoSd/HR0aEuMogXn5IC5
         GwXg==
X-Gm-Message-State: AOAM530b1Lg64D8mJVLazOHNG+ckOXDo1XOw6zRhEyy2FbmA3wYCyTMj
        j/BUPjoNOhrI5tx+3Wvmrgo=
X-Google-Smtp-Source: ABdhPJzxSho5+xQ+Q1Y77DqHDhxSRpptAPXY1oYKY8NFFuCAnf3kSITcTVVcTtT0Nlgh60Y4dLK5iQ==
X-Received: by 2002:a63:c148:: with SMTP id p8mr536825pgi.188.1613585275749;
        Wed, 17 Feb 2021 10:07:55 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id w3sm2902460pjt.4.2021.02.17.10.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:07:55 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V3 net-next 1/5] icmp: add support for RFC 8335 PROBE
Date:   Wed, 17 Feb 2021 10:07:54 -0800
Message-Id: <a0c1d3cd75accdf9cad0b32efa0fc1dae2d3d8ed.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for PROBE ICMP types and codes.

Add AFI definitions for IP and IPV6 as specified by IANA

Add a struct to represent the additional header when probing by IP
address (ctype == 3) for use in parsing incoming PROBE messages.

Add a struct to represent the entire Interface Identification Object
(IIO) section of an incoming PROBE packet

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Add AFI_IP and AFI_IP6 definitions

Changes since v2:
Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
 - Add prefix for PROBE specific defined variables
 - Create struct icmp_ext_echo_iio for parsing incoming packet
---
 include/uapi/linux/icmp.h | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..166ca77561de 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -66,6 +66,23 @@
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
+#define EXT_ECHO_CTYPE_NAME	1
+#define EXT_ECHO_CTYPE_INDEX	2
+#define EXT_ECHO_CTYPE_ADDR	3
+#define EXT_ECHO_AFI_IP		1	/* Address Family Identifier for IPV4 */
+#define EXT_ECHO_AFI_IP6	2	/* Address Family Identifier for IPV6 */
 
 struct icmphdr {
   __u8		type;
@@ -118,4 +135,27 @@ struct icmp_extobj_hdr {
 	__u8		class_type;
 };
 
+/* RFC 8335: 2.1 Header for C-type 3 payload */
+struct icmp_ext_echo_ctype3_hdr {
+	__u16		afi;
+	__u8		addrlen;
+	__u8		reserved;
+};
+
+/* RFC 8335: Interface Identification Object */
+struct icmp_ext_echo_iio {
+	struct icmp_extobj_hdr	extobj_hdr;
+	union {
+		__u32	ifIndex;
+		char name;
+		struct {
+			struct icmp_ext_echo_ctype3_hdr	ctype3_hdr;
+			union {
+				__be32		ipv4_addr;
+				struct in6_addr	ipv6_addr;
+			} ip_addr;
+		} addr;
+	} ident;
+};
+
 #endif /* _UAPI_LINUX_ICMP_H */
-- 
2.25.1

