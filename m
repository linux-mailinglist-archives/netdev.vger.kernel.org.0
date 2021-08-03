Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748BA3DF34A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhHCQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:52:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:30464 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237443AbhHCQwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:52:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200924744"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200924744"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="500887399"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2021 09:51:55 -0700
Received: from alobakin-mobl.ger.corp.intel.com (mszymcza-mobl.ger.corp.intel.com [10.213.25.231])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173Gpg78004325;
        Tue, 3 Aug 2021 17:51:50 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH ethtool-next 2/5] stats: factor out one stat field printing
Date:   Tue,  3 Aug 2021 18:51:37 +0200
Message-Id: <20210803165140.172-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165140.172-1-alexandr.lobakin@intel.com>
References: <20210803165140.172-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the code that takes one stat field nlattr, validates and prints
it in either stdout or JSON, into a separate function.
It will later be reused by per-channel statistics printing.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 netlink/stats.c | 53 +++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/netlink/stats.c b/netlink/stats.c
index 9f609a4ec550..9d950b77d656 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -87,6 +87,36 @@ err_close_rmon:
 	return 1;
 }
 
+static int parse_stat(const struct nlattr *attr, const char *grp_name,
+		      const struct stringset *stat_str)
+{
+	const struct nlattr *stat;
+	unsigned long long val;
+	const char *name;
+	unsigned int s;
+	int ret;
+
+	stat = mnl_attr_get_payload(attr);
+	ret = mnl_attr_validate(stat, MNL_TYPE_U64);
+	if (ret) {
+		fprintf(stderr, "invalid kernel response - bad statistic entry\n");
+		return 1;
+	}
+
+	s = mnl_attr_get_type(stat);
+	name = get_string(stat_str, s);
+	if (!name || !name[0])
+		return 0;
+
+	if (!is_json_context())
+		fprintf(stdout, "%s-%s: ", grp_name, name);
+
+	val = mnl_attr_get_u64(stat);
+	print_u64(PRINT_ANY, name, "%llu\n", val);
+
+	return 0;
+}
+
 static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 		     const struct stringset *std_str)
 {
@@ -94,10 +124,9 @@ static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 	DECLARE_ATTR_TB_INFO(tb);
 	bool hist_rx = false, hist_tx = false;
 	const struct stringset *stat_str;
-	const struct nlattr *attr, *stat;
-	const char *std_name, *name;
-	unsigned int ss_id, id, s;
-	unsigned long long val;
+	const struct nlattr *attr;
+	unsigned int ss_id, id;
+	const char *std_name;
 	int ret;
 
 	ret = mnl_attr_parse_nested(grp, attr_cb, &tb_info);
@@ -131,22 +160,8 @@ static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 			continue;
 		}
 
-		stat = mnl_attr_get_payload(attr);
-		ret = mnl_attr_validate(stat, MNL_TYPE_U64);
-		if (ret) {
-			fprintf(stderr, "invalid kernel response - bad statistic entry\n");
+		if (parse_stat(attr, NULL, std_name, stat_str))
 			goto err_close_grp;
-		}
-		s = mnl_attr_get_type(stat);
-		name = get_string(stat_str, s);
-		if (!name || !name[0])
-			continue;
-
-		if (!is_json_context())
-			fprintf(stdout, "%s-%s: ", std_name, name);
-
-		val = mnl_attr_get_u64(stat);
-		print_u64(PRINT_ANY, name, "%llu\n", val);
 	}
 
 	if (hist_rx)
-- 
2.31.1

