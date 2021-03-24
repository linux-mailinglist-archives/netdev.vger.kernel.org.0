Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB10534803E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhCXSSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237126AbhCXSRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:17:50 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DFEC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:50 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id f9so21767131oiw.5
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bBO2cd1qd3fbWL44FOOcOnUmpEptHmAjPUxtPNN1Qro=;
        b=BGA+FZ6tiBV2pFUuuR6ngyXsVTwOMfGKhsGGHFUZu+PDql6qa+KwPqZzM1m+ovzcL7
         cyGA5zazACxzAc4tRdYeYrs9hHrqIRxgVZJbwWlHFXaO2l+e5l70W/mNdvJcdnxrbwvv
         ZTY9CQfDzV3+Rfl5QM6VuaEr8dLCbqkkcDMuohY/lyQ+rU5fhkeO5o+UjSEHuvxpHV5S
         Fsp6QRCHOOJ6egla51xQNR7B/4HbjIjd++0AsXfadJCzTlHHR4/iwEO3baZ5E6Akr0c2
         bYVP0O+xP+0GwxXFW8XRgoGHFTgDF8J7thTB9fVxJhxg2pM+EgufNcBiTB9wRiOxtmXe
         Uhkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bBO2cd1qd3fbWL44FOOcOnUmpEptHmAjPUxtPNN1Qro=;
        b=ghTIaxetbFJ7jTGvj4up+pBCuCBQXzYZ4u3oOH6hsEIbr9y7vI/CigDb2uWxHePY3Y
         VUBEbslK7bYm8qxcR+wfpvBZEXYbw4/fKnZoi3sn5LcW16UMvx6//Sk8dPUYx6kAGUXS
         gh8+o7opGX8ahE5+cGLkbiHhxNckYgXwGJzCe1gvCqg0rHawqezXNPE1U6PnRPw3LjLu
         bdAL67py6f8jynURtKrdoW51lFP93famSuvWzUmgU8RHVvuG0V1mzmMGqf7eEffp3HSD
         Ta1jlKrliioxfMRj1bkTxPnT+a0QOSZNcIbVrtjndxxkx6iM1CphyXbcUBNJ4NdvCk+N
         A4Vg==
X-Gm-Message-State: AOAM530Y320rCNrVQpcAze/BgsfrKWaEty9ULA7l01OXkEtWKmFn/cj+
        Uu/u7vEPKQSDFJmaZAa8poJwYNKGo2U=
X-Google-Smtp-Source: ABdhPJzI40yEj8HAfT75RBX5bkP9bqlwBf4R+fIifCox1G1+OePDc5IOD5cknIif9D9JBe7J5Ibi7Q==
X-Received: by 2002:a05:6808:907:: with SMTP id w7mr3279935oih.94.1616609869482;
        Wed, 24 Mar 2021 11:17:49 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id x20sm431187oiv.35.2021.03.24.11.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:17:49 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 1/6] icmp: add support for RFC 8335 PROBE
Date:   Wed, 24 Mar 2021 11:17:47 -0700
Message-Id: <558c61137abc5c8b016e2b23050ad37c36f2b4eb.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
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

