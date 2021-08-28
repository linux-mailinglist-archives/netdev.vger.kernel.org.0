Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AD93FA540
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhH1LJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhH1LJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:10 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC89CC0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:19 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u3so19573512ejz.1
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6CJLUELi4OYj8pc2y744ciouGC/ra4+49LNOIX5UUXM=;
        b=sbNWVsNJ+YaS4T0yaefxWuu4retgIMzDFRNekCH/8wEJXAHA+dZfrBrAmLtojzWBCm
         XVg65rVq5tnKh0nphr//tVZI53ZP5xOIrGd1YbDBb6iqYaNWARI9QeXZCRYWv+rGdOCQ
         VyWpd0bVWEuRWIZhxNPr2dciPXjmrqZPgjzRf/FEEp2M/aeHc46llA0a16Gfo9AHrH1m
         XthlFXyBzG5pijY/NvY6B9C9FE89Gz5mnHdZgPmZUh/AgZniFZ9pUV1CFPSJY/LlQbr6
         UAMCC60eVc0c+J8fs5BwBcE68BgqChPGSmwyb3eHxNxHy9PQJLcNBNO1QTym3xPkqKVM
         6ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6CJLUELi4OYj8pc2y744ciouGC/ra4+49LNOIX5UUXM=;
        b=G6x/zHEBntXG70joyGObn1B/fHbjzZiPP9Qg183HJiJR6Nlv52FWWAQNqi5GU+B+Wf
         oMAzwKg3lDQrFhCHOsReVacsPXPbTa60XBP9dMTzrSRZhJYjAwBhu+lusIlkdB7gzi71
         RISxRygTT0xIjn+bebWaKUExcyuJ41+FDwOhuru3WKMcr54+OmMRrn8SJF/6xgr5kwZ1
         mEEPXs5CDG5vmBcZUrKSHFZC5O9Cs+E2cL6zENuSmmjDVQ1QWSWZLkOXBbKqctdlQjl9
         Q1WVGRyvTZ/usw/1ZrYr2v9CIxowh3EQIH0zLovApNn2W92sFXJfhOA1W9CJjm7KTobs
         ZT7w==
X-Gm-Message-State: AOAM531CcuA0z29JHmWGpCJvU+sC460++7Cleqc2JPb2Lx6A9huTgDAg
        LnAkCN959GJKe8w0uL6WNGVKB+vOEIkzmik2
X-Google-Smtp-Source: ABdhPJx5G5VHqRyETDgS0gpTvBVQgmWP+4MZ+F7DQvLHj32a7XU7fkw87ftdgL33g+F0O4Iq47m4Tw==
X-Received: by 2002:a17:906:d541:: with SMTP id cr1mr14609014ejc.81.1630148898057;
        Sat, 28 Aug 2021 04:08:18 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:17 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 03/19] bridge: vlan: skip unknown attributes when printing options
Date:   Sat, 28 Aug 2021 14:07:49 +0300
Message-Id: <20210828110805.463429-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Skip unknown attributes when printing vlan options in print_vlan_rtm.
Make sure print_vlan_opts doesn't accept attributes it doesn't understand.
Currently we print only one type, later global vlan options support will
be added.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: new patch, split off of previous patch 02

 bridge/vlan.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index b9d928010cb4..7e4254283373 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -629,6 +629,9 @@ static void print_vlan_opts(struct rtattr *a)
 	__u16 vrange = 0;
 	__u8 state = 0;
 
+	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_ENTRY)
+		return;
+
 	parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
 			   RTA_PAYLOAD(a), NLA_F_NESTED);
 	vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
@@ -716,6 +719,12 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
 	rem = len;
 	for (a = BRVLAN_RTA(bvm); RTA_OK(a, rem); a = RTA_NEXT(a, rem)) {
+		unsigned short rta_type = a->rta_type & NLA_TYPE_MASK;
+
+		/* skip unknown attributes */
+		if (rta_type > BRIDGE_VLANDB_MAX)
+			continue;
+
 		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
 			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
 			open_json_object(NULL);
@@ -724,7 +733,11 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 			open_json_object(NULL);
 			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
 		}
-		print_vlan_opts(a);
+		switch (rta_type) {
+		case BRIDGE_VLANDB_ENTRY:
+			print_vlan_opts(a);
+			break;
+		}
 		close_json_object();
 	}
 
-- 
2.31.1

