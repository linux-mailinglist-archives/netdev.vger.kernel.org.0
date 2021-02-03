Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176B130E73F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhBCXZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbhBCXZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:25:00 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B64C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:20 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u15so733758plf.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sJGIJ6AFFiqYqAD2YyawfECDbtzTFn0Yy5uqy/fB82Q=;
        b=LslCFBH+7QjchyirWchD1IORaXHay0OsIL1w7kHU8fdDmxCJLWHTjhQzgbI9ksuVPp
         DBs8NVbnQAPauJSLUwQ8J6uc7gMNTIaPdF+fHsWOdKG88sdnxS2VHcQZDlJBFM3K0SYA
         Nm7BmjCwuNarYq7lRQBcjskNNa9W0iXLmMY40r58a2WAENIswf1B2oNu4VPNvhO5jdPJ
         D5aTfAKkuF9yn3gE48cYBkoBkzIWq+FpHgIBLbMQYOd8WUUkyOj70GhFoZAQOk//jzZl
         KVj08HXMBW4EeNQrwoV7a3pJDfnVDhvjTPimjN57rP2x2ujWC5wuDJ8RJT8unew6n/Jx
         iogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJGIJ6AFFiqYqAD2YyawfECDbtzTFn0Yy5uqy/fB82Q=;
        b=OswZrqn6d4j1ZzaqvqWsIaIjQf/jlTfrZqvOsd4uNX1HSkdYYwGeio2yTVyuzAc4lr
         lKlukF4tePc/aBaM/+3rZiji5qETuMo5VVDUtxW8T9kfGs4k98haWR+2D8YUOSTloq28
         D0HHXdI8HOLm+kLXBmUhZTYHTFHmfsEFDlmXH5bib0XsjeKF85IMtHEKhQmA/LRK9Ea4
         PTP3qYod55QPByOhulkYt6+M1jn1c0Btpw3PlMP2OTvBn4DvodTRA3BNHfseV4joI+Hu
         Plar3WowCcK2pfYI9pV904+vW96/0kmGMgJ8CAhuyh0v7p/6bqD0+XFXeP0eaeKEDhj3
         jQnw==
X-Gm-Message-State: AOAM532Fq0VsWt42RHKB95BcULr0/BGKj8DvktwmAoev2o03GSQ2m/FX
        zkyCrYNZNZ0JPx9KB3F1Dqw=
X-Google-Smtp-Source: ABdhPJzaVrRE4p3jSQDbYKdbH3KgHuUUYO7mleJMfl469w5SLN5aeCJ9M8g+WJc56mQQGe87r9l7jw==
X-Received: by 2002:a17:90a:7e94:: with SMTP id j20mr5536988pjl.218.1612394659898;
        Wed, 03 Feb 2021 15:24:19 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id n128sm4122182pga.55.2021.02.03.15.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:19 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 1/5] icmp: add support for RFC 8335 PROBE
Date:   Wed,  3 Feb 2021 15:24:18 -0800
Message-Id: <2f3de06143c4191c53be4b96d98759afb5f09a5e.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for PROBE ICMP types and codes.

Add AFI definitions for IP and IPV6 as specified by IANA

Add a struct to represent the additional header when probing by IP
address (ctype == 3) for use in parsing incoming PROBE messages.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Add AFI_IP and AFI_IP6 definitions
---
 include/uapi/linux/icmp.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..e70bfcc06247 100644
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
+#define CTYPE_NAME		1
+#define CTYPE_INDEX		2
+#define CTYPE_ADDR		3
+#define AFI_IP			1	/* Address Family Identifier for IPV4 */
+#define AFI_IP6			2	/* Address Family Identifier for IPV6 */
 
 struct icmphdr {
   __u8		type;
@@ -118,4 +135,11 @@ struct icmp_extobj_hdr {
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

