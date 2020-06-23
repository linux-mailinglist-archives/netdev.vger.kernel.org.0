Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF72204C77
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgFWId7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731831AbgFWId4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 04:33:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3486BC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 01:33:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q15so501370wmj.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 01:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ToWZL43tF3Urwd8i/BsV3EgAZBwn0D0GlsbC/FJOSx4=;
        b=hMRWmGO6CyTzHaktpZSU+2lW5rtPHeGqo6kzDzm431YaI184J0kBXNJ5tRUCe3xqC1
         DkIp/bag+Lm4BppOIGZVDF5Or9+qaWsuZ7knZVRQaq8FZPZCRzc65DvYiZpkiVMVr+Se
         OanKJOFo6iDuWm73mX5qQ606YdkPOCOfcOSLMxGcWgjUOSI1LWAZfjP+hcOAKLcAbnc0
         paCq6K3atN+Tn12VNoliU/MzhTLS0C5VmxDsqqR4W20TvlDx/qEQV3iNShWDYENOSCy+
         liyI+4pyete4N9e6OitLtpveC8a2ZcCen+/iksdU8Oe6lC1SzDYxfZBerdHmHKNhvOLF
         CBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ToWZL43tF3Urwd8i/BsV3EgAZBwn0D0GlsbC/FJOSx4=;
        b=pbIbkkq3SlCF2hgdBfLdQgZD3/gz6l2zANo0avq1CJc1HQxHdBJM7npG5Upwmbwenk
         yrCaSTJHuDNrVJpdaFCYTjlFTgOLKXQP4zBfV/14DjjmX+aypbf25K+kWmZU+D2moaWQ
         N1uzeix7N+KmMxrS3lm5bO37Emp7Wq8imgJwQupZ1YVidDTANNZcTXzY7PixDPHJZ0xe
         LTNxQ5ALM5rhTbR0XyIPOSLQEApNXtJa3Mb39G8sTeQbZYKAIK/BraiRdeLIlm1uKMkz
         maWh5l8AEbl6XC/uG1G6XZsqArNS3vNuxc+D84CFHK6oTvnjyasCxV15HZs972v7P/8d
         jscw==
X-Gm-Message-State: AOAM530QMVoT5bgTNPiwHF86OJxUmoL5xKX7oafk2nBf0dNz6/brEN+x
        6eoLfyg6xKkOc5PzJO0sbZxs7o5TrFl2Kw==
X-Google-Smtp-Source: ABdhPJxtTcGwzwywlKu1Pl0G6wN1MPZp3vRmdUzYdgrNYBTaa83Z/BZYnUfz+8czE18UvVBR3mrJ2Q==
X-Received: by 2002:a1c:a1c3:: with SMTP id k186mr6819994wme.15.1592901234286;
        Tue, 23 Jun 2020 01:33:54 -0700 (PDT)
Received: from localhost.localdomain (82-64-167-122.subs.proxad.net. [82.64.167.122])
        by smtp.gmail.com with ESMTPSA id p17sm2618499wma.47.2020.06.23.01.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 01:33:53 -0700 (PDT)
From:   Alexandre Cassen <acassen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        nikolay@cumulusnetworks.com, idosch@mellanox.com,
        vladbu@mellanox.com
Subject: [PATCH net-next,v2] rtnetlink: add keepalived rtm_protocol
Date:   Tue, 23 Jun 2020 10:33:45 +0200
Message-Id: <20200623083345.30842-1-acassen@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keepalived can set global static ip routes or virtual ip routes dynamically
following VRRP protocol states. Using a dedicated rtm_protocol will help
keeping track of it.

Changes in v2:
 - fix tab/space indenting

Signed-off-by: Alexandre Cassen <acassen@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 45 +++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 073e71ef6bdd..879e64950a0a 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -257,12 +257,12 @@ enum {
 
 /* rtm_protocol */
 
-#define RTPROT_UNSPEC	0
-#define RTPROT_REDIRECT	1	/* Route installed by ICMP redirects;
-				   not used by current IPv4 */
-#define RTPROT_KERNEL	2	/* Route installed by kernel		*/
-#define RTPROT_BOOT	3	/* Route installed during boot		*/
-#define RTPROT_STATIC	4	/* Route installed by administrator	*/
+#define RTPROT_UNSPEC		0
+#define RTPROT_REDIRECT		1	/* Route installed by ICMP redirects;
+					   not used by current IPv4 */
+#define RTPROT_KERNEL		2	/* Route installed by kernel		*/
+#define RTPROT_BOOT		3	/* Route installed during boot		*/
+#define RTPROT_STATIC		4	/* Route installed by administrator	*/
 
 /* Values of protocol >= RTPROT_STATIC are not interpreted by kernel;
    they are just passed from user and back as is.
@@ -271,22 +271,23 @@ enum {
    avoid conflicts.
  */
 
-#define RTPROT_GATED	8	/* Apparently, GateD */
-#define RTPROT_RA	9	/* RDISC/ND router advertisements */
-#define RTPROT_MRT	10	/* Merit MRT */
-#define RTPROT_ZEBRA	11	/* Zebra */
-#define RTPROT_BIRD	12	/* BIRD */
-#define RTPROT_DNROUTED	13	/* DECnet routing daemon */
-#define RTPROT_XORP	14	/* XORP */
-#define RTPROT_NTK	15	/* Netsukuku */
-#define RTPROT_DHCP	16      /* DHCP client */
-#define RTPROT_MROUTED	17      /* Multicast daemon */
-#define RTPROT_BABEL	42      /* Babel daemon */
-#define RTPROT_BGP	186     /* BGP Routes */
-#define RTPROT_ISIS	187     /* ISIS Routes */
-#define RTPROT_OSPF	188     /* OSPF Routes */
-#define RTPROT_RIP	189     /* RIP Routes */
-#define RTPROT_EIGRP	192     /* EIGRP Routes */
+#define RTPROT_GATED		8	/* Apparently, GateD */
+#define RTPROT_RA		9	/* RDISC/ND router advertisements */
+#define RTPROT_MRT		10	/* Merit MRT */
+#define RTPROT_ZEBRA		11	/* Zebra */
+#define RTPROT_BIRD		12	/* BIRD */
+#define RTPROT_DNROUTED		13	/* DECnet routing daemon */
+#define RTPROT_XORP		14	/* XORP */
+#define RTPROT_NTK		15	/* Netsukuku */
+#define RTPROT_DHCP		16	/* DHCP client */
+#define RTPROT_MROUTED		17	/* Multicast daemon */
+#define RTPROT_KEEPALIVED	18	/* Keepalived daemon */
+#define RTPROT_BABEL		42	/* Babel daemon */
+#define RTPROT_BGP		186	/* BGP Routes */
+#define RTPROT_ISIS		187	/* ISIS Routes */
+#define RTPROT_OSPF		188	/* OSPF Routes */
+#define RTPROT_RIP		189	/* RIP Routes */
+#define RTPROT_EIGRP		192	/* EIGRP Routes */
 
 /* rtm_scope
 
-- 
2.17.1

