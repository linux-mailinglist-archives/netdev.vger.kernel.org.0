Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FDB4A7EBB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 05:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349296AbiBCEqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 23:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiBCEqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 23:46:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A7C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 20:46:03 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n32so1189078pfv.11
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 20:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7mtko7/bowsES4YZCNSGm1luZCJVBdOiLfbZm0MhZAA=;
        b=SeNMkS/hhhLRgy4T0TjYHOzZ/nawf93XsiAzRvLx4rimagSEPhZkcowZJZRlvyvtVc
         GLCdFVhnjSG5RxjOFe/SoxAW8HHSKs1p+fAz/mWt9Nf89UHqekwrep7tVui6Tb/SUvct
         A/pwCyMUj0UD5x48VteK6T9qsEp7s3xfqxPeN8WtIZ/EfjX/QkMAoS+FWm653N5uALo0
         f3A1PZgkzhisF/S1NsZ8VyAZz49rWCKnU7tGLDOuGB349Hjh3xqNcmxmzKNsFA/5lOct
         k4Ht0hw85+uu42Jo1blgKt0LEEKtod66fagvqgQ5IkFVntBJsSbjnmiJCNbO2WODtxAQ
         OwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7mtko7/bowsES4YZCNSGm1luZCJVBdOiLfbZm0MhZAA=;
        b=rfCEvbZz8HockxiyNrwuAoKqNwibSXM2pDOOd4Z+VH1RRMLgw7/Y0YxgPehEA0YE+J
         jb+O6R/RwGxxLsTPM4wXZdCmQNVtS8Oq1Ea65gGVXcqqgp7motN79sWKf/xsO9V7gWQT
         3+boj8uMUPfnmeqpWObWj3evvDHQ5Kqy3pqbufVLAuGZjy7RUD8QgvVS+VMwQLASnSr4
         S8ZHcwQgmf/ItK6KRsWBKYraMSoxqFFwYQKFFbl2DWg+SJOEqDKTIEpVfNFSMV7xszBc
         MRoM7Ql74mM1nBnew421bQTzYWMByIYGTMl92+hw5Jr/mG81Hhv/TLQcTXAnwl8Ij9/T
         1BPA==
X-Gm-Message-State: AOAM531YyCnrwre1kJLMJi6JZIZUCMlq0aFTmLBWYFC72vVnUZxSmIMt
        Jgs66icu4ZXeYZ4VbNB90Es=
X-Google-Smtp-Source: ABdhPJzS9kUwmbp7INI8D7RKJOBoOBB7o9XzOiYjZMUCTAkaYVd44wkQtb1gb5NtLsDKXVfyvW9B4w==
X-Received: by 2002:a63:f650:: with SMTP id u16mr26677510pgj.2.1643863562742;
        Wed, 02 Feb 2022 20:46:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id b22sm28349513pfl.121.2022.02.02.20.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 20:46:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH v2 iproute2] iplink: add gro_max_size attribute handling
Date:   Wed,  2 Feb 2022 20:45:58 -0800
Message-Id: <20220203044558.3039122-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

Add the ability to display or change the gro_max_size attribute.

ip link set dev eth1 gro_max_size 60000
ip -d link show eth1
5: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 9198 qdisc mq master eth0 state UP mode DEFAULT group default qlen 1000
    link/ether bc:ae:c5:39:69:66 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 46 maxmtu 9600
    <...> gro_max_size 60000

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 ip/ipaddress.c |  6 ++++++
 ip/iplink.c    | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 4109d8bd2c43640bee40656c124ea6393d95a345..739b0b9c9f348141b0e51f6231b547385af00eae 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1219,6 +1219,12 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 				   "gso_max_segs %u ",
 				   rta_getattr_u32(tb[IFLA_GSO_MAX_SEGS]));
 
+		if (tb[IFLA_GRO_MAX_SIZE])
+			print_uint(PRINT_ANY,
+				   "gro_max_size",
+				   "gro_max_size %u ",
+				   rta_getattr_u32(tb[IFLA_GRO_MAX_SIZE]));
+
 		if (tb[IFLA_PHYS_PORT_NAME])
 			print_string(PRINT_ANY,
 				     "phys_port_name",
diff --git a/ip/iplink.c b/ip/iplink.c
index a3ea775d2b23c47916e9554b8615d430a58c6a55..c0a3a9ad3e629986ee2da0ee80eaf758f98aee5f 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -118,6 +118,7 @@ void iplink_usage(void)
 		"		[ protodown { on | off } ]\n"
 		"		[ protodown_reason PREASON { on | off } ]\n"
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
+		"		[ gro_max_size BYTES ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
 		"		[nomaster]\n"
@@ -942,6 +943,15 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				       *argv);
 			addattr32(&req->n, sizeof(*req),
 				  IFLA_GSO_MAX_SEGS, max_segs);
+		}  else if (strcmp(*argv, "gro_max_size") == 0) {
+			unsigned int max_size;
+
+			NEXT_ARG();
+			if (get_unsigned(&max_size, *argv, 0))
+				invarg("Invalid \"gro_max_size\" value\n",
+				       *argv);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_GRO_MAX_SIZE, max_size);
 		} else if (strcmp(*argv, "parentdev") == 0) {
 			NEXT_ARG();
 			addattr_l(&req->n, sizeof(*req), IFLA_PARENT_DEV_NAME,
-- 
2.35.0.rc2.247.g8bbb082509-goog

