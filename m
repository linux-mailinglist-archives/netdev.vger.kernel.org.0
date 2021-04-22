Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7D368393
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhDVPlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236547AbhDVPlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F3D961421;
        Thu, 22 Apr 2021 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619106056;
        bh=YK/mYeF8fQ1m5TErzr3eFt/+hGpUkqTRFRJGvXPYdLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkjQNZe86TPLmm71ILDZZxefx1pSVOZqOgOca1bSFXAU4WLaZdtU7J/Q/u84oletT
         lBsSZKc2JOuGXv8GtvNqF3QF14OnEmTLUwCftpKKXaDfuJOCLfFe1X7yKqmfcCYuKv
         CQF49vqXlaQfRpfqvcw2pW+5Qas84v9g0SBx1XjAX3VJ1MmfFxULL1v+yY9/DCThwO
         LYb1eQXVoNnp387u4WB7YzRpC8kKfn5asabm9caYAiFEYSR3FOlUOjMwbAkvm+bTvc
         F6d8bbgfcdpf85pilHMzJduWaXJgEEf/MqAP3tw6R9X26OIUTEMB9BOLvvIS3esh9o
         btGkcMGroAuBw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 7/7] netlink: stats: add on --all-groups option
Date:   Thu, 22 Apr 2021 08:40:50 -0700
Message-Id: <20210422154050.3339628-8-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422154050.3339628-1-kuba@kernel.org>
References: <20210422154050.3339628-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a switch for querying all statistic groups available
in the kernel.

To reject --groups and --all-groups being specified
for one request add a concept of "parameter equivalency"
in the parser. Alternative of having a special group
type like "--groups all" seems less clean.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.8.in     |  5 ++++-
 ethtool.c        |  2 +-
 netlink/parser.c | 17 ++++++++++++++-
 netlink/parser.h |  4 ++++
 netlink/stats.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index d4e01778d738..652e98af0384 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -240,7 +240,7 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-S|\-\-statistics
 .I devname
-.RB [\fB\-\-groups
+.RB [\fB\-\-all\-groups\fP|\fB\-\-groups
 .RB [\fBeth\-phy\fP]
 .RB [\fBeth\-mac\fP]
 .RB [\fBeth\-ctrl\fP]
@@ -667,6 +667,9 @@ devices may implement either, both or none. There is little commonality between
 naming of NIC- and driver-specific statistics across vendors.
 .RS 4
 .TP
+.B \fB\-\-all\-groups
+.E
+.TP
 .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBrmon\fP]
 Request groups of standard device statistics.
 .RE
diff --git a/ethtool.c b/ethtool.c
index b23fb05a3016..34ea64229244 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5764,7 +5764,7 @@ static const struct option args[] = {
 		.nlchk	= nl_gstats_chk,
 		.nlfunc	= nl_gstats,
 		.help	= "Show adapter statistics",
-		.xhelp	= "               [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]\n"
+		.xhelp	= "               [ --all-groups | --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]\n"
 	},
 	{
 		.opts	= "--phy-statistics",
diff --git a/netlink/parser.c b/netlink/parser.c
index c2eae93efb69..d15fa332cc55 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -919,6 +919,17 @@ static void __parser_set(uint64_t *map, unsigned int idx)
 	map[idx / 64] |= (1 << (idx % 64));
 }
 
+static void __parser_set_group(const struct param_parser *params,
+			       uint64_t *map, unsigned int equiv_group)
+{
+	const struct param_parser *parser;
+	unsigned int idx = 0;
+
+	for (parser = params; parser->arg; parser++, idx++)
+		if (parser->equiv_group == equiv_group)
+			__parser_set(map, idx);
+}
+
 struct tmp_buff {
 	struct nl_msg_buff	*msgbuff;
 	unsigned int		id;
@@ -1074,7 +1085,11 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 			parser_err_min_argc(nlctx, parser->min_argc);
 			goto out_free;
 		}
-		__parser_set(params_seen, parser - params);
+		if (parser->equiv_group)
+			__parser_set_group(params, params_seen,
+					   parser->equiv_group);
+		else
+			__parser_set(params_seen, parser - params);
 
 		buff = NULL;
 		if (parser->group)
diff --git a/netlink/parser.h b/netlink/parser.h
index 28f26ccc2a1c..57ad6d0498a8 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -43,6 +43,10 @@ struct param_parser {
 	unsigned int		min_argc;
 	/* if @dest is passed to nl_parser(), offset to store value */
 	unsigned int		dest_offset;
+	/* parameter equivalency group - only one parameter from a group
+	 * can be specified, 0 means no group
+	 */
+	unsigned int		equiv_group;
 };
 
 /* data structures used for handler data */
diff --git a/netlink/stats.c b/netlink/stats.c
index e3ca58b0010c..0a2569c349a4 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -220,6 +220,54 @@ static const struct bitset_parser_data stats_parser_data = {
 	.force_hex	= false,
 };
 
+static int stats_parse_all_groups(struct nl_context *nlctx, uint16_t type,
+				  const void *data, struct nl_msg_buff *msgbuff,
+				  void *dest)
+{
+	const struct stringset *std_str;
+	struct nlattr *nest;
+	int i, ret, nbits;
+	uint32_t *bits;
+
+	if (data || dest)
+		return -EFAULT;
+
+	/* ethnl2 and strset code already does caching */
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		return ret;
+	std_str = global_stringset(ETH_SS_STATS_STD, nlctx->ethnl2_socket);
+
+	nbits = get_count(std_str);
+	bits = calloc(DIV_ROUND_UP(nbits, 32), sizeof(uint32_t));
+	if (!bits)
+		return -ENOMEM;
+
+	for (i = 0; i < nbits; i++)
+		bits[i / 32] |= 1U << (i % 32);
+
+	ret = -EMSGSIZE;
+	nest = ethnla_nest_start(msgbuff, type);
+	if (!nest)
+		goto err_free;
+
+	if (ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_NOMASK, true) ||
+	    ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_SIZE, nbits) ||
+	    ethnla_put(msgbuff, ETHTOOL_A_BITSET_VALUE,
+		       DIV_ROUND_UP(nbits, 32) * sizeof(uint32_t), bits))
+		goto err_cancel;
+
+	ethnla_nest_end(msgbuff, nest);
+	free(bits);
+	return 0;
+
+err_cancel:
+	ethnla_nest_cancel(msgbuff, nest);
+err_free:
+	free(bits);
+	return ret;
+}
+
 static const struct param_parser stats_params[] = {
 	{
 		.arg		= "--groups",
@@ -227,6 +275,13 @@ static const struct param_parser stats_params[] = {
 		.handler	= nl_parse_bitset,
 		.handler_data	= &stats_parser_data,
 		.min_argc	= 1,
+		.equiv_group	= 1,
+	},
+	{
+		.arg		= "--all-groups",
+		.type		= ETHTOOL_A_STATS_GROUPS,
+		.handler	= stats_parse_all_groups,
+		.equiv_group	= 1,
 	},
 	{}
 };
-- 
2.30.2

