Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABC333A6E6
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhCNQsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbhCNQsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D8C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso10847521pjb.4
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j5rPyoTzarZd6mPM18ILvQ+eDIpaFnvVClhJ5rQSfmg=;
        b=Y0w4QTIC9rFw02lgb0CLozvnOsAPM2Mb+qgZ6OmVJmXt1te3OoPNirvkGinZeLcedC
         AU7P41WlCUsf0IW+r5Y+eiIQ4puTdR+I3wVXUvl3h8YqkQ3VMzH652vmO0icpnDgawbg
         8QMuNadpl+SA2Q/5ZyJ5N7+4hV2oktN7dJSR/d7bO+WHEJBRLnhRidXqJuscArxyp50o
         LnOXcMGvpegpD8GrjKuc4l/W15aj0/sUKjliI+hESIkJ6drCFElE4Hnm5n4milMJg4Ji
         UpOZad/A96fG5B3j5CGH06mc0KoQY/W0SpuynuTWrf2r6GexRLivT2dCgL1PiFLN3w4w
         YySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j5rPyoTzarZd6mPM18ILvQ+eDIpaFnvVClhJ5rQSfmg=;
        b=eGUFB4zFC+pLDXDzF56jNH1IKouTIYZIECvgjIyH9vFUnZLyWtzSdUjnaTIhdd7nvi
         06t5PPEyBt1D+FbuabZze9XNXy5EVCPQM/4p52yN96weJtbeJN2gYK8K0daocp/XkxIZ
         zj20oRBGB1xEVS9tCozNt9yXi0zD0GG51VbmoulMNRhrvcBAwqmaHXwaeX86jw/8re4z
         M92R9trhzDmhTflz/Zr2dPAkXK6OM1Tvx/jm2TC2cgaViOfrvrO+K0C+fejeskVKmyh/
         9KWoZaB2phx103z3jfsZU9NZ5lTl946kRDnIJ+BDOaPyvJBdVwX3GW30LzZ+aZqlTBof
         lm3g==
X-Gm-Message-State: AOAM532CsgXJOMvm0ILlr7LVZKrXxfHXj28W/UPJ/1ASjpl2sAv3ZwOG
        4mJf0QNSijwvZgvevkcOewE=
X-Google-Smtp-Source: ABdhPJzsDsiiEg6+0LmVEZNBD64hcc8P/zv28KjGvnnK7VOxMzplE8ZTkBssu8wWaN8/PyftVnZuQQ==
X-Received: by 2002:a17:90a:498d:: with SMTP id d13mr8864497pjh.47.1615740496199;
        Sun, 14 Mar 2021 09:48:16 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id n10sm899694pjo.15.2021.03.14.09.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:15 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 1/5] icmp: add support for RFC 8335 PROBE
Date:   Sun, 14 Mar 2021 09:48:13 -0700
Message-Id: <397a542fc27203ef67b69b680f14b4baacd12391.1615738431.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
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
---
 include/uapi/linux/icmp.h | 42 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..c074964aa4f3 100644
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
+	__u16		afi;
+	__u8		addrlen;
+	__u8		reserved;
+};
+
+/* RFC 8335: 2.1 Interface Identification Object */
+struct icmp_ext_echo_iio {
+	struct icmp_extobj_hdr extobj_hdr;
+	union {
+		char name[IFNAMSIZ];
+		__u32 ifindex;
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

