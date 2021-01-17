Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FD82F9156
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbhAQITL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbhAQIN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:13:56 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D5DC061573;
        Sun, 17 Jan 2021 00:12:25 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id y205so2499829pfc.5;
        Sun, 17 Jan 2021 00:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rSY/jrqLE+xOv61lVEk8pIJIbYebtwDyEErxSngDBhg=;
        b=ocYqFyxFVb5XjD7dZxd1w0rFvPHUXzYyn3XZUO1XQWXe9+z1ED0cUz0zNfOqNfIM04
         S+qSoHGs16IrD2KvoIsMdW7Iw4qZWEk753xhhHUsirZCnCcVNmkAORt+o+jqS7Wqa812
         eerlXnZRZnmrsIVwnEUt2W5JwwIHUOcKPlvtQuZQLgsulAk4mH03I2MlgqdNMbvphJMl
         zR7J502XkNLbPhPoI3PW2fXE8UJDvfMOIa8i8HN2LfisET7joAVR9jnCAjNM5YwE8ur6
         1x3ZHzZ0g9P5toOQRDE7yx7nsRbMKfqVg6aC2A/KtCnRc2+uyAOEYI31dpun4/7FliLy
         u5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rSY/jrqLE+xOv61lVEk8pIJIbYebtwDyEErxSngDBhg=;
        b=kwV/RempH4giVCII8sVN6tI7yQpuLmwMTaP573ayuAspEwkY3sOpOPn9ZT5R++fV0Q
         OeKMz7Gm/5btxDcRrd6cc1eGzV0wtXrnZAiT39yjye3DpwH0I0n9R+JkyMHVQmmmru2o
         tXGetFqkwmWwIOCdGxBmawLV9YlKbHKLQsPcWNRk7RvNDQDJTbdZBGvZnCYmFbYIyOhn
         3EC/nmlSjdjlQSdtpkYPUGq+zOHbcCh8E/hJnTMQKnTUhfrYmpx0k/+SQHapFyY7abUH
         RxG+tMvkLKRoDI1PXGRqmUMDu6agiJJ05m01U13qYhJW5sQIP8sMHflmbvts1n/xkkZI
         QuFQ==
X-Gm-Message-State: AOAM533dk/TnedCU/qf9997x0hlVsMiFPxlmQL562EKcG0T/OevWXoyU
        bjjVu7WpJHWokM/aT3XLOyufllM/4/8=
X-Google-Smtp-Source: ABdhPJzQjsbnPwQLrrx/8rMxLvvZ/XoCOYp/lUIKuo7V6rTsxJ4Wrwu8pd6EqiSrlW6BY35QlZfOrA==
X-Received: by 2002:a63:504e:: with SMTP id q14mr20922360pgl.21.1610871145026;
        Sun, 17 Jan 2021 00:12:25 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id h24sm13168401pfq.13.2021.01.17.00.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 00:12:24 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v4 net-next] net: bridge: check vlan with eth_type_vlan() method
Date:   Sun, 17 Jan 2021 16:09:50 +0800
Message-Id: <20210117080950.122761-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace some checks for ETH_P_8021Q and ETH_P_8021AD with
eth_type_vlan().

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
v4:
- remove unnecessary brackets.

v3:
- fix compile warning in br_vlan_set_proto() by casting 'val' to
  be16.

v2:
- use eth_type_vlan() in br_validate() and __br_vlan_set_proto()
  too.
---
 net/bridge/br_forward.c |  3 +--
 net/bridge/br_netlink.c | 12 +++---------
 net/bridge/br_vlan.c    |  2 +-
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index e28ffadd1371..6e9b049ae521 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -39,8 +39,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 	br_drop_fake_rtable(skb);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD))) {
+	    eth_type_vlan(skb->protocol)) {
 		int depth;
 
 		if (!__vlan_get_protocol(skb, skb->protocol, &depth))
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 49700ce0e919..762f273802cd 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1096,15 +1096,9 @@ static int br_validate(struct nlattr *tb[], struct nlattr *data[],
 		return 0;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-	if (data[IFLA_BR_VLAN_PROTOCOL]) {
-		switch (nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL])) {
-		case htons(ETH_P_8021Q):
-		case htons(ETH_P_8021AD):
-			break;
-		default:
-			return -EPROTONOSUPPORT;
-		}
-	}
+	if (data[IFLA_BR_VLAN_PROTOCOL] &&
+	    !eth_type_vlan(nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL])))
+		return -EPROTONOSUPPORT;
 
 	if (data[IFLA_BR_VLAN_DEFAULT_PVID]) {
 		__u16 defpvid = nla_get_u16(data[IFLA_BR_VLAN_DEFAULT_PVID]);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 701cad646b20..bb2909738518 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -917,7 +917,7 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val)
 {
-	if (val != ETH_P_8021Q && val != ETH_P_8021AD)
+	if (!eth_type_vlan(htons(val)))
 		return -EPROTONOSUPPORT;
 
 	return __br_vlan_set_proto(br, htons(val));
-- 
2.30.0

