Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831E93691C3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhDWMLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhDWMLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:11:05 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3327C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:10:27 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so73514077ejc.10
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n2h8x30cr2GRrRe+1Rk0gDSltGo8YeAb0BaTO/vi93s=;
        b=2AQik+GYqKIBde6dyFc8QTWclNU166IlYgzXi/Gs+MouZqspURF3d6eQqBAbdiM2jW
         qYucptzcL+Nk+et47E+eiXAgDKKD+oroefDLW4Vpq121ACeTg8SSGTyCOkF7Q1von91B
         9+vvUBTE/NKQhwIJPwYChrE9BQtIWXp1vOOdjGEfWXpmzlMotAmiJyuAQcQwH6sLBL3u
         LaL41he4bDhy99NfdpmB/uUOdxebUd0KgUXEHxbU8ALuu5AOvgWoUvGDh29ajrn3gipo
         SG9UPUovi7F3t4NVIGSTCdeF7785HP73kDvxNI7e5DXGtd7+epgznIQbsC/XeeCvlAlH
         1snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n2h8x30cr2GRrRe+1Rk0gDSltGo8YeAb0BaTO/vi93s=;
        b=bq9Ji9ejMFWKMqXYA3Z76NXjYZtMcDmI15czNeGUApa9MMhWrx922HIGzjcP8rQTV5
         EjcAl7n5eI3ODDfuAhYw9niebW5S4rU2BHTbpTVaHF3HICIxP1RBJVdTXLqt6f8H9Mab
         iHDzd0an5cGtNboQYPZ+6CTexF9faRrA59jPK1bWzd02QLpX7liCHR+Coud1Hz8Egq1k
         oJdWavbIt1Fou94Vf8Mb2rp/RgKkkiU+nesZlBamT91s+s4+LBXsgqrNLsB3LgzaFvUY
         I1iXu7nxC+KRFSPE7zhuyMj1DvtHwYrIbqpihnQYFtU/b94oy6mSJFqKhg+51yoZc+Zb
         co1g==
X-Gm-Message-State: AOAM532GQeAorCP/myJj5ofc41zm73YnMs5WF59E/J+5xH9x1cbAYoUA
        JUexd5V6SN6n/Kgf20S/Qb8SzR5PJUvGDwub
X-Google-Smtp-Source: ABdhPJyCaUFYUnC5Novm8z4MP9sfFgUHLE6mmWRDKBaLxSF+FnQCbQLNSV/w5BE46hbxkLLZy87fxw==
X-Received: by 2002:a17:906:3549:: with SMTP id s9mr3659752eja.327.1619179826278;
        Fri, 23 Apr 2021 05:10:26 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l14sm4645520edc.0.2021.04.23.05.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 05:10:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2] bridge: vlan: dump port only if there are any vlans
Date:   Fri, 23 Apr 2021 15:10:18 +0300
Message-Id: <20210423121018.3662866-1-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423115259.3660733-1-razor@blackwall.org>
References: <20210423115259.3660733-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When I added support for new vlan rtm dumping, I made a mistake in the
output format when there are no vlans on the port. This patch fixes it by
not printing ports without vlan entries (similar to current situation).

Example (no vlans):
$ bridge -d vlan show
port              vlan-id

Fixes: e5f87c834193 ("bridge: vlan: add support for the new rtm dump call")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: sent proper patch version, fixed the vlan port closing only when opened
    added an example

Targeted at next since the patches were applied there recently.

 bridge/vlan.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 9bb9e28d11bb..9b6511f189ff 100644
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
+	if (vlan_rtm_cur_ifidx != -1 && vlan_rtm_cur_ifidx != bvm->ifindex) {
+		close_vlan_port();
+		vlan_rtm_cur_ifidx = -1;
 	}
 
 	rem = len;
@@ -707,11 +703,14 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 				vstats.tx_bytes = rta_getattr_u64(attr);
 			}
 		}
-		open_json_object(NULL);
-		if (!newport)
+		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
+			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
+			open_json_object(NULL);
+			vlan_rtm_cur_ifidx = bvm->ifindex;
+		} else {
+			open_json_object(NULL);
 			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
-		else
-			newport = false;
+		}
 		print_range("vlan", vinfo->vid, vrange);
 		print_vlan_flags(vinfo->flags);
 		print_nl();
-- 
2.30.2

