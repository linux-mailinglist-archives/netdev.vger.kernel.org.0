Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2B202B5F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgFUPfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730206AbgFUPfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 11:35:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA717C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 08:35:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t194so13431734wmt.4
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u1F47OjLEvdJLtomdPMpoNwNoPdGWwLJMwh9Gi35qIU=;
        b=Mum9y8JufJdM5k7RMduK3Thua6GY4abqog0nMj3N25th+j+uIVbxpZYU5xM39J5vAW
         z/kTf8ODOL3/C31L5RfNXAvascbAoaXVafVHQ9Pcvzi556+pH+OpgfY70RzJEjoJgmsn
         x6fvoZXSWrWKJhPU4KiUGJAYVptSF50heuSD4LhODmFNCJjvSig21aUZq7mWHoSch3wR
         T+thoZMAeGr0ptVDDAsHYXSkAMmQwcmLWkCVgfOoNRcjVnzlXgUW+nybBfwZlWln4ydF
         oyP6USCRBxZYanerCiu755WjwuhG5YXGByRuicRVimfTA4IpjqhdKgcylZUththJKan/
         trww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u1F47OjLEvdJLtomdPMpoNwNoPdGWwLJMwh9Gi35qIU=;
        b=iGj/pLXyNZ+yd6zvwol/f1dFYEOTTKCUFCQl/emWM319QXkKONa8W83LT3mJbL0AG/
         42KaRpNyfio58Rzb/qHQPzHDl5I/s3ZqbeoTPttJAA6YctxM0fcO6/V8VjjYiijF28tj
         gGduZq/6IRWj+pjm+K3NxxnBTjjA3c7+hHnD0aYF4xDeAodqTI2eNNmO0Rl1A4c+BU4I
         /ywoZKE0Mip+jsrFav69PhLDM6/27GrGipfORSyLxSRvB0DOVN0R7gcYgvuY2k47K8aU
         1tZNq3DZAHbGtgGtnWjPX0Qr4OGGjdUN0MRLtyotXdhmx+RdycLUgC94MQ0BSKdWqrTI
         /owQ==
X-Gm-Message-State: AOAM532leHS5CcKpOM+jDLmTfO3m3AOYArAw5O7mirb6sAKp0+1DhQJA
        QqscsPdWAHhuXPH8RrHI92tuZC06ktZUwQ==
X-Google-Smtp-Source: ABdhPJy59pd/6nCCo0YWAlYj1Sab369vLRQIk6RB+gyyFDkhbau17SRBN3JyHA7iBCODBVQ4pKFdqw==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr14075166wml.58.1592753705157;
        Sun, 21 Jun 2020 08:35:05 -0700 (PDT)
Received: from localhost.localdomain (82-64-167-122.subs.proxad.net. [82.64.167.122])
        by smtp.gmail.com with ESMTPSA id b81sm14479968wmc.5.2020.06.21.08.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 08:35:04 -0700 (PDT)
From:   Alexandre Cassen <acassen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        nikolay@cumulusnetworks.com, idosch@mellanox.com,
        dsahern@gmail.com, vladbu@mellanox.com
Subject: [PATCH net-next] rtnetlink: add keepalived rtm_protocol
Date:   Sun, 21 Jun 2020 17:34:54 +0200
Message-Id: <20200621153454.3325-1-acassen@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keepalived can set global static ip routes or virtual ip routes dynamically
following VRRP protocol states. Using a dedicated rtm_protocol will help
keeping track of it.

Signed-off-by: Alexandre Cassen <acassen@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 45 +++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 073e71ef6bdd..1463a422d837 100644
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
+#define RTPROT_DHCP		16      /* DHCP client */
+#define RTPROT_MROUTED		17      /* Multicast daemon */
+#define RTPROT_KEEPALIVED	18      /* Keepalived daemon */
+#define RTPROT_BABEL		42      /* Babel daemon */
+#define RTPROT_BGP		186     /* BGP Routes */
+#define RTPROT_ISIS		187     /* ISIS Routes */
+#define RTPROT_OSPF		188     /* OSPF Routes */
+#define RTPROT_RIP		189     /* RIP Routes */
+#define RTPROT_EIGRP		192     /* EIGRP Routes */
 
 /* rtm_scope
 
-- 
2.17.1

