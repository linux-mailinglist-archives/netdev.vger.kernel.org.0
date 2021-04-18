Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC7F3634F6
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhDRMDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhDRMDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:35 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045BFC061763
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id y5-20020a05600c3645b0290132b13aaa3bso4821379wmq.1
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ssRpSujeKUYFK0HQ+R/6RY8ue2oV1kYrGO5GO9Gink=;
        b=odLurbwYIkRhDSDRzJPqjXKVuYGm+X53q6vdHqvZvMx32pYMsXeDa5CGIvyA35SDy8
         W9d9MNVTZMGRFEQoe/rdqU1SU/QipKhNSALiWo8KIS5VTLYiioIKz+eXR3ziJDrZYILv
         QHWC0G8xEBBVD7vMO/Uv/2Ly7fKUyUxf7A1w5hgeHNqcwRHowwmCL6boLkZn6iiFVdbo
         0FdGCcm51JsIXmaIzcutTYhhS82CI9U97wPMzoysiHS5GBe501tCglW9cqcg1khqcIqz
         aNIW9cpCxOtI4ymQcXLI0tHlhwpx4QaR6wtTrutiXQFKdmGs+9x8SNB3xhkd1iOknc6T
         Fl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ssRpSujeKUYFK0HQ+R/6RY8ue2oV1kYrGO5GO9Gink=;
        b=MEp5/aTMOQdsA8a8wca6KdS5411xTJNJ4XXN64w4m+iPqlY7qJXpTh/lftRPT99aO2
         v28YZnUWBhMwY8w80WgbhKSwnBlEVpeRvr58dKytyeWhvOGMZTQjtGKcF4Pu5+mBX2fK
         64qHsan3n1ldX/y0TiRIzbih6PFMxCQSdbez/WsV5FWmBAxaPMTzEf1lb9LYveQja4Oi
         NZ7d13dZ+tsg2jXK5j9elKIbcgImWE0jjNORaonNilcvLmXZH0C3m9JE06R9I7ZPnQNZ
         o4YJHIk3zz5EItWEz/ZAjWm0FJ7ripa/8uJ0M/HUf2Jhd/PeHHnX98L/lxyUzE3EabVN
         OWJg==
X-Gm-Message-State: AOAM533GgBiSJGYHWqsy22nPmqHwxlXs3C+KiC3SXIRCXu8HT1/7Sw1y
        DHhmcxYWWOcMcrlVmrG30z1azRYFHcwHM02H
X-Google-Smtp-Source: ABdhPJw014SYF3psdIDGjlhid1fRVNEBBQbY1YwCDqvTnYr/doIwp44uOR05AZwjnNRQT9mQjprejA==
X-Received: by 2002:a05:600c:2141:: with SMTP id v1mr16762792wml.22.1618747385562;
        Sun, 18 Apr 2021 05:03:05 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:05 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 4/6] libnetlink: add bridge vlan dump request helper
Date:   Sun, 18 Apr 2021 15:01:35 +0300
Message-Id: <20210418120137.2605522-5-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add rtnl bridge vlan dump request helper which will be used to retrieve
bridge vlan information and options.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/libnetlink.h |  2 ++
 lib/libnetlink.c     | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index e8ed5d7fb495..da96c69b9ede 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -69,6 +69,8 @@ int rtnl_neightbldump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
 int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
+int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags)
+	__attribute__((warn_unused_result));
 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
 
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 6885087b34f9..2f2cc1fe0a61 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -450,6 +450,25 @@ int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
+int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct br_vlan_msg bvm;
+		char buf[256];
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct br_vlan_msg)),
+		.nlh.nlmsg_type = RTM_GETVLAN,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
+		.bvm.family = family,
+	};
+
+	addattr32(&req.nlh, sizeof(req), BRIDGE_VLANDB_DUMP_FLAGS, dump_flags);
+
+	return send(rth->fd, &req, sizeof(req), 0);
+}
+
 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 {
 	struct {
-- 
2.30.2

