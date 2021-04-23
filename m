Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFC5369184
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhDWLyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhDWLyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 07:54:13 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE85C06174A
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 04:53:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id x12so52735958ejc.1
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 04:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s4CvRSZzC/qiz/xSzCjiijPikdBh7/9TDJuVl6EF8BA=;
        b=1pp+nfOeomcyI5uIkfUvLfyB/La3NTkV1Ocern/n47aRD8BU70VGM/oD2sZUqalbY9
         hMtFH4zPURFhKXCChF+g/UhzdVIkIgbcoRwEFUjU7BigvEGSeQBzPxAMMz7KMcmMLjxC
         sSx8YjUcpMxxqy/wOjsKKPCqLwk0em26OC6uoX1Qt5hzLJyazrTm+S7eUSgiHmc72RXr
         vj4EI4siRYEe5cVscqrGsmLBvzMOI2lpx1OHiZx1aG/VpRQw9Zon8DuKLUEONlM0+lwz
         8+1fPjsK9K5hPLBKzX5Rcne02e9/nO49sRbpAisXetHxGrll/M23j4/677xQt4JB4PfR
         xl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s4CvRSZzC/qiz/xSzCjiijPikdBh7/9TDJuVl6EF8BA=;
        b=eANQWWQm1qws+sKG9Rc1ve+rP1ePkVN90N93fgs/JLTNuoJgiFCtEUeKdff/AtdSXJ
         FTba85+1KBATe+RV2L7GCrsbNmXgzgpT1JKsTRS9FVw8f6OnCnpzx2EX+46DAbhw5b97
         rKzZI3rO/trsjhQhz0q1uOUFItGrW3JnD5jrilAWCDQhkjkPjWpDsDbl67p8pUzlnuLd
         myHMYCr5NYdOvRhkj0SLoReluA2VCsGV2pq3DROzCp4NFI9+V6pHA2Ar5ycQL5B38+vi
         Lcdu136WGxCFm60kNPp5Yd+55ULKFhbz/5VHg9HrozCBxsVkMpyuIU/iWd7eG7kouzAf
         D41w==
X-Gm-Message-State: AOAM531LmuJzGG3x49I0Lo2dDFFN0Cq+HGInKoTaxav/+ws7mJxreri5
        BYkM0fp1HIpRvpN5rUmR1LhunHaqCoE6l/X/
X-Google-Smtp-Source: ABdhPJzbYF7oTRuoPRzdkdyKOpcXa1wM04UkOCGKFgV99PN/OBaRW66bD7yRd2Plvm5/r8YHAgCNiw==
X-Received: by 2002:a17:906:b28c:: with SMTP id q12mr3779833ejz.284.1619178813143;
        Fri, 23 Apr 2021 04:53:33 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f22sm3731497ejr.35.2021.04.23.04.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 04:53:32 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next] bridge: vlan: dump port only if there are any vlans
Date:   Fri, 23 Apr 2021 14:52:59 +0300
Message-Id: <20210423115259.3660733-1-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When I added support for new vlan rtm dumping, I made a mistake in the
output format when there are no vlans on the port. This patch fixes it by
not printing ports without vlan entries (similar to current situation).

Fixes: e5f87c834193 ("bridge: vlan: add support for the new rtm dump call")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
Targeted at next since the patches were applied there recently.

 bridge/vlan.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 9bb9e28d11bb..c6f68e5673a7 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -626,7 +626,6 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
-	bool newport = false;
 	int rem;
 
 	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
@@ -654,12 +653,9 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 	if (monitor)
 		vlan_rtm_cur_ifidx = -1;
 
-	if (vlan_rtm_cur_ifidx == -1 || vlan_rtm_cur_ifidx != bvm->ifindex) {
-		if (vlan_rtm_cur_ifidx != -1)
-			close_vlan_port();
-		open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
-		vlan_rtm_cur_ifidx = bvm->ifindex;
-		newport = true;
+	if (vlan_rtm_cur_ifidx != -1) {
+		close_vlan_port();
+		vlan_rtm_cur_ifidx = -1;
 	}
 
 	rem = len;
@@ -708,10 +704,12 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 			}
 		}
 		open_json_object(NULL);
-		if (!newport)
+		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
+			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
+			vlan_rtm_cur_ifidx = bvm->ifindex;
+		} else {
 			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
-		else
-			newport = false;
+		}
 		print_range("vlan", vinfo->vid, vrange);
 		print_vlan_flags(vinfo->flags);
 		print_nl();
-- 
2.30.2

