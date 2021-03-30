Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579D534DDBA
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC3BpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhC3BpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:19 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1085C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:18 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so14136401otk.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bBO2cd1qd3fbWL44FOOcOnUmpEptHmAjPUxtPNN1Qro=;
        b=R42vDIR6GfweOhu3rbVBepbmFGdE305ETGOyGpMc9LqDesYccyAgW0SBOjMSJ4sZIW
         aIoP483hvgynG8fNFqXX9G8FXHcLAcmnQFQ4+JQLZyRKbbXIrHzVUgPRdwiLK65WZKJz
         8FH3wZw2E6rgJh1MqePCJIJZyxCJHSAvr7IMbYH7xMAlZjEUHperEI0JXZS6CjNlKeBb
         kTv6+YGJleEwqM1qL4J9BZarb9K1BzP3N9EChCZtBqPJ+42JHna3PPiy/vpnHsVI/RjF
         D/X2VM8wykjurYaCK2Vpr1RskVy5Er/b3FrP/K7+agVYmp7CkIj+03ROGt7tuT0atJyL
         KIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bBO2cd1qd3fbWL44FOOcOnUmpEptHmAjPUxtPNN1Qro=;
        b=VjIq9zlqvJocKVEpWqYlOmRlTqLhsOHYDYA3yrp3gYltcfSEAPI9bp25hDMMB9d4bP
         EdF7BHmoenreNfY9bOFeTSiwzSFQ9G0Fxc01wqC5MYAJm8efx9gjDjnHKLrEvY+E6daq
         qe1nVio/YEccpI95c5zQsoZHnLmXS4VkPXibuVy6qyJ+SHKQqggeyZVbz2KcPfM4N9zY
         bOQDtXscquf49iHiZI4CQGpydd9Hs/1raTOWn4ZchswY20KB5qP2XAONqZvXiV6dIVX+
         1PiMpNHTPmrLH4YX2MEoTjdQ0ablhL9sEfIDVPkxeyNyUY+TsRAHK1maYuHvxVd1dJBV
         SZjQ==
X-Gm-Message-State: AOAM530AkwRCU52GVernko1+f9gn1iWQD2CkRrNNFGV4cQQNrN31c8Kx
        6Q1tHrDssk5Z5sP7SqTox5TV7e363k8=
X-Google-Smtp-Source: ABdhPJzSBLvchHjrc3Cn568tFSAGg8PmUcsRPyXQb4uTWFWyMZ9egk+CBPMN98OnyIznU5Nhz6LLwA==
X-Received: by 2002:a05:6830:1506:: with SMTP id k6mr25846180otp.26.1617068718024;
        Mon, 29 Mar 2021 18:45:18 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id m14sm4916001otn.69.2021.03.29.18.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:17 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 1/6] icmp: add support for RFC 8335 PROBE
Date:   Mon, 29 Mar 2021 18:45:15 -0700
Message-Id: <ba81dcf8097c4d3cc43f4e2ed5cc6f5a7a4c33b6.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for PROBE ICMP types and codes.

Add AFI definitions for IP and IPV6 as specified by IANA

Add a struct to represent the additional header when probing by IP
address (ctype == 3) for use in parsing incoming PROBE messages

Add a struct to represent the entire Interface Identification Object
(IIO) section of an incoming PROBE packet

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
 - Add AFI_IP and AFI_IP6 definitions

v2 -> v3:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Add prefix for PROBE specific defined variables
 - Create struct icmp_ext_echo_iio for parsing incoming packet

v3 -> v4:
 - Use in_addr instead of __be32 for storing IPV4 addresses
 - Use IFNAMSIZ to statically allocate space for name in
   icmp_ext_echo_iio 

v4 -> v5:
 - Use __be32 instead of __u32 in defined structs
---
 include/uapi/linux/icmp.h | 42 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..222325d1d80e 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -20,6 +20,9 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <linux/in.h>
+#include <linux/if.h>
+#include <linux/in6.h>
 
 #define ICMP_ECHOREPLY		0	/* Echo Reply			*/
 #define ICMP_DEST_UNREACH	3	/* Destination Unreachable	*/
@@ -66,6 +69,23 @@
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
+/* Constants for EXT_ECHO (PROBE) */
+#define EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
+#define EXT_ECHOREPLY_IPV4	(1 << 1)/* ipv4 bit in reply message */
+#define EXT_ECHOREPLY_IPV6	1	/* ipv6 bit in reply message */
+#define EXT_ECHO_CTYPE_NAME	1
+#define EXT_ECHO_CTYPE_INDEX	2
+#define EXT_ECHO_CTYPE_ADDR	3
+#define ICMP_AFI_IP		1	/* Address Family Identifier for ipv4 */
+#define ICMP_AFI_IP6		2	/* Address Family Identifier for ipv6 */
 
 struct icmphdr {
   __u8		type;
@@ -118,4 +138,26 @@ struct icmp_extobj_hdr {
 	__u8		class_type;
 };
 
+/* RFC 8335: 2.1 Header for c-type 3 payload */
+struct icmp_ext_echo_ctype3_hdr {
+	__be16		afi;
+	__u8		addrlen;
+	__u8		reserved;
+};
+
+/* RFC 8335: 2.1 Interface Identification Object */
+struct icmp_ext_echo_iio {
+	struct icmp_extobj_hdr extobj_hdr;
+	union {
+		char name[IFNAMSIZ];
+		__be32 ifindex;
+		struct {
+			struct icmp_ext_echo_ctype3_hdr ctype3_hdr;
+			union {
+				struct in_addr	ipv4_addr;
+				struct in6_addr	ipv6_addr;
+			} ip_addr;
+		} addr;
+	} ident;
+};
 #endif /* _UAPI_LINUX_ICMP_H */
-- 
2.17.1

