Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B7641C867
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbhI2Pb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345289AbhI2PbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:25 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D401CC061760
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:43 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dj4so10523798edb.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ykMBYZicswPirsTO842dgZBWABg6Nz1Qsrzpfqs2cKw=;
        b=2Q73nUTPU6KOKBCQqzKKgwOguIxp+4l/otHkA87IhTxBrpvy/WqF3SShTE+htx5CIH
         pHZa2tobq8U7pTyvlWwWEN15AWLqVSs4AxhtcZsgUtCbyUR9imn6CclPj0hq5njNPky2
         TeU0/pV6ZpNs1SpG1YEgWZZx2t3FkH01sT37Yxi/+wahogdcjpW8SvzEcRpzeZH+R8k0
         7k0ffWclsicGbeD7CgUfeAfl8rDZK6jsYnx4bR/qq8JUxhoFYmYY94Z2iwIQ8Wz27+pd
         DGgqm06KQOJSzeFkH3sUtsUtmvDrLLROIRnXUoOq7c5to0kh3LNNGIyzIgdNJrqOOTAx
         wouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ykMBYZicswPirsTO842dgZBWABg6Nz1Qsrzpfqs2cKw=;
        b=lVhvFb4mWLRAlX6cjtKvJF7DYt1zAFBaFtMV/HExq2W5/hAPtqvzdZjG0rbngIsF7a
         XUjQNm2pEZZPFd39jZzqAKrx2qN5/uWTqeLs3NDvK2rzsuO6aMwOgSi179cT+710I3Gj
         ppZjELqmvXHJoPTxQrEYj45WNlpOzra9aLyiFuh0Gi6q6wzQ6gFvYUbw3G9J9pbxHHOZ
         sVfoKZyGNllg6/SxTCc/N0AEVUG++3Bn+w6ddhKkl/AtmOkspHtkrwRVlQLC8siqlhVl
         v+bfHTCKOFu7M9tV9Yv4EAHcE0fQqkEcYO2qJK4CFnvk5Q23yh8s1VdwvlmExux96RWa
         TouA==
X-Gm-Message-State: AOAM531BFChzhk7oiv6rU2leJRCck2jJs1RWq8IhGq7aPK95TIM0h1En
        5BN8PG+o8KqL+rPubvwOoKpPIo93TRbVKvdV
X-Google-Smtp-Source: ABdhPJxjXUJbOZ4P2nySPKI32fl5daSh8SklM8YHY9pFCG4XoaQiaKlaC6xqIhjYGBYNQLScQoydDg==
X-Received: by 2002:a17:906:1341:: with SMTP id x1mr318817ejb.277.1632929336880;
        Wed, 29 Sep 2021 08:28:56 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:56 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 04/11] ip: nexthop: parse resilient nexthop group attribute into structure
Date:   Wed, 29 Sep 2021 18:28:41 +0300
Message-Id: <20210929152848.1710552-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a structure which describes resilient nexthop groups and parse such
attributes into it.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 32 ++++++++++++++++++++++++++++++++
 ip/nh_common.h | 10 ++++++++++
 2 files changed, 42 insertions(+)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index be8541476fa6..9340d8941277 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -272,6 +272,33 @@ static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
 	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
 }
 
+static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
+				   struct nha_res_grp *res_grp)
+{
+	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
+	struct rtattr *rta;
+
+	parse_rtattr_nested(tb, NHA_RES_GROUP_MAX, res_grp_attr);
+
+	if (tb[NHA_RES_GROUP_BUCKETS])
+		res_grp->buckets = rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]);
+
+	if (tb[NHA_RES_GROUP_IDLE_TIMER]) {
+		rta = tb[NHA_RES_GROUP_IDLE_TIMER];
+		res_grp->idle_timer = rta_getattr_u32(rta);
+	}
+
+	if (tb[NHA_RES_GROUP_UNBALANCED_TIMER]) {
+		rta = tb[NHA_RES_GROUP_UNBALANCED_TIMER];
+		res_grp->unbalanced_timer = rta_getattr_u32(rta);
+	}
+
+	if (tb[NHA_RES_GROUP_UNBALANCED_TIME]) {
+		rta = tb[NHA_RES_GROUP_UNBALANCED_TIME];
+		res_grp->unbalanced_time = rta_getattr_u64(rta);
+	}
+}
+
 static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
 {
 	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
@@ -408,6 +435,11 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
 		       RTA_PAYLOAD(tb[NHA_GROUP]));
 	}
 
+	if (tb[NHA_RES_GROUP]) {
+		parse_nh_res_group_rta(tb[NHA_RES_GROUP], &nhe->nh_res_grp);
+		nhe->nh_has_res_grp = true;
+	}
+
 	nhe->nh_blackhole = !!tb[NHA_BLACKHOLE];
 	nhe->nh_fdb = !!tb[NHA_FDB];
 
diff --git a/ip/nh_common.h b/ip/nh_common.h
index f2ff0e6532d3..8c96f9993562 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -2,6 +2,13 @@
 #ifndef __NH_COMMON_H__
 #define __NH_COMMON_H__ 1
 
+struct nha_res_grp {
+	__u16			buckets;
+	__u32			idle_timer;
+	__u32			unbalanced_timer;
+	__u64			unbalanced_time;
+};
+
 struct nh_entry {
 	__u32			nh_id;
 	__u32			nh_oif;
@@ -26,6 +33,9 @@ struct nh_entry {
 		__u8		_buf[RTA_LENGTH(sizeof(__u16))];
 	}			nh_encap_type;
 
+	bool			nh_has_res_grp;
+	struct nha_res_grp	nh_res_grp;
+
 	int			nh_groups_cnt;
 	struct nexthop_grp	*nh_groups;
 };
-- 
2.31.1

