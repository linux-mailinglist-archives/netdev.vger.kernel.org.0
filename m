Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130433DF33E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhHCQw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:52:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:64065 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237446AbhHCQwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:52:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194016036"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194016036"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="479592823"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 03 Aug 2021 09:51:59 -0700
Received: from alobakin-mobl.ger.corp.intel.com (mszymcza-mobl.ger.corp.intel.com [10.213.25.231])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173Gpg79004325;
        Tue, 3 Aug 2021 17:51:54 +0100
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
Subject: [PATCH ethtool-next 3/5] stats: add support for per-channel statistics [blocks]
Date:   Tue,  3 Aug 2021 18:51:38 +0200
Message-Id: <20210803165140.172-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165140.172-1-alexandr.lobakin@intel.com>
References: <20210803165140.172-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat ETHTOOL_A_STATS_GRP_STAT_BLOCK as a block of the standard
stats for one channel and print them prefixed with "channel%u-".
The index will be started from 0 and incremented automatically
for each new attr of that type.
This means that stats blocks should follow each other one by one
according to their channel number, otherwise the output can mess
up with the indices.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 netlink/stats.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

diff --git a/netlink/stats.c b/netlink/stats.c
index 9d950b77d656..36a9dad97f15 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -87,8 +87,8 @@ err_close_rmon:
 	return 1;
 }
 
-static int parse_stat(const struct nlattr *attr, const char *grp_name,
-		      const struct stringset *stat_str)
+static int parse_stat(const struct nlattr *attr, const char *ch_name,
+		      const char *grp_name, const struct stringset *stat_str)
 {
 	const struct nlattr *stat;
 	unsigned long long val;
@@ -108,8 +108,12 @@ static int parse_stat(const struct nlattr *attr, const char *grp_name,
 	if (!name || !name[0])
 		return 0;
 
-	if (!is_json_context())
+	if (!is_json_context()) {
+		if (ch_name)
+			fprintf(stdout, "%s-", ch_name);
+
 		fprintf(stdout, "%s-%s: ", grp_name, name);
+	}
 
 	val = mnl_attr_get_u64(stat);
 	print_u64(PRINT_ANY, name, "%llu\n", val);
@@ -117,12 +121,62 @@ static int parse_stat(const struct nlattr *attr, const char *grp_name,
 	return 0;
 }
 
+static int parse_one_block(const struct nlattr *block, const char *grp_name,
+			   const struct stringset *stat_str,
+			   unsigned int channel)
+{
+	char ch_name[ETH_GSTRING_LEN];
+	const struct nlattr *attr;
+
+	snprintf(ch_name, sizeof(ch_name), "channel%u", channel);
+	open_json_object(ch_name);
+
+	mnl_attr_for_each_nested(attr, block) {
+		if (mnl_attr_get_type(attr) != ETHTOOL_A_STATS_GRP_STAT ||
+		    parse_stat(attr, ch_name, grp_name, stat_str))
+			goto err_close_block;
+	}
+
+	close_json_object();
+
+	return 0;
+
+err_close_block:
+	close_json_object();
+
+	return 1;
+}
+
+static int parse_blocks(const struct nlattr *grp, const char *grp_name,
+			const struct stringset *stat_str)
+{
+	const struct nlattr *attr;
+	unsigned int channel = 0;
+
+	open_json_array("per-channel", "");
+
+	mnl_attr_for_each_nested(attr, grp) {
+		if (mnl_attr_get_type(attr) == ETHTOOL_A_STATS_GRP_STAT_BLOCK &&
+		    parse_one_block(attr, grp_name, stat_str, channel++))
+			goto err_close_block;
+	}
+
+	close_json_array("");
+
+	return 0;
+
+err_close_block:
+	close_json_array("");
+
+	return 1;
+}
+
 static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 		     const struct stringset *std_str)
 {
 	const struct nlattr *tb[ETHTOOL_A_STATS_GRP_SS_ID + 1] = {};
 	DECLARE_ATTR_TB_INFO(tb);
-	bool hist_rx = false, hist_tx = false;
+	bool hist_rx = false, hist_tx = false, blocks = false;
 	const struct stringset *stat_str;
 	const struct nlattr *attr;
 	unsigned int ss_id, id;
@@ -156,6 +210,9 @@ static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 		case ETHTOOL_A_STATS_GRP_HIST_TX:
 			hist_tx = true;
 			continue;
+		case ETHTOOL_A_STATS_GRP_STAT_BLOCK:
+			blocks = true;
+			continue;
 		default:
 			continue;
 		}
@@ -170,6 +227,8 @@ static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
 	if (hist_tx)
 		parse_rmon_hist(grp, std_name, "tx-pktsNtoM", "tx",
 				ETHTOOL_A_STATS_GRP_HIST_TX);
+	if (blocks)
+		parse_blocks(grp, std_name, stat_str);
 
 	close_json_object();
 
-- 
2.31.1

