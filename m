Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86C731AFBF
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 09:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 03:34:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhBNIeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 03:34:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E8D64E23;
        Sun, 14 Feb 2021 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613291621;
        bh=vXIzBAR96RWOmojxAGhSBdAI4j+TNc+J95m0Q6RhefA=;
        h=From:To:Cc:Subject:Date:From;
        b=sKgUNqJYyYwTxvtNFF2Ws762u8W1fk4uJmGSuDuOi70y+bK576IngD8g06mpo1kIT
         fTcfgwjKPTL1NJpXraave90oL3Nx+rOGz6ye9NetWnKgctixSDAVqPfIfsszOppjBk
         qdo9pH+XI015ibBGlj1J5wXrf3MFDTteGVNR4nebm6KO4db4UzpQsql7ll3aasOHj/
         i3kMlOafjY16mfQ3/EbwoY77xzv30pTtGJ4b/fdUyMb/Z2+2NGvbOgrBQfm9sGbl0z
         51HXEf7MMXKmOg7HamdenbBlI5I71Qe2DhJPk2iEQ8p4Deq4t5AXa9koQix3Mb8zm2
         sv57hJOJjgSQg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Ido Kalir <idok@nvidia.com>, David Ahern <dsahern@gmail.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument handling
Date:   Sun, 14 Feb 2021 10:33:35 +0200
Message-Id: <20210214083335.19558-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Kalir <idok@nvidia.com>

The dump isn't supported for the statistics bind/unbind commands
because they operate on specific QP counters. This is different
from query commands that can operate on many objects at the same
time.

Let's check the user input and ensure that arguments are valid.

Fixes: a6d0773ebecc ("rdma: Add stat manual mode support")
Signed-off-by: Ido Kalir <idok@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/rdma.h  |  1 +
 rdma/stat.c  | 21 +++++++++++++++++++++
 rdma/utils.c |  7 +++++++
 3 files changed, 29 insertions(+)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index 735b1bf7..7f96c051 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -83,6 +83,7 @@ struct rd_cmd {
  * Parser interface
  */
 bool rd_no_arg(struct rd *rd);
+bool rd_is_multiarg(struct rd *rd);
 void rd_arg_inc(struct rd *rd);

 char *rd_argv(struct rd *rd);
diff --git a/rdma/stat.c b/rdma/stat.c
index 8d4b7a11..a6b6dfbf 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -455,6 +455,12 @@ static int stat_get_arg(struct rd *rd, const char *arg)
 		return -EINVAL;

 	rd_arg_inc(rd);
+
+	if (rd_is_multiarg(rd)){
+		pr_err("The parameter %s shouldn't include range\n", arg);
+		return -EINVAL;
+	}
+
 	value = strtol(rd_argv(rd), &endp, 10);
 	rd_arg_inc(rd);

@@ -476,6 +482,8 @@ static int stat_one_qp_bind(struct rd *rd)
 		return ret;

 	lqpn = stat_get_arg(rd, "lqpn");
+	if (lqpn < 0)
+		return lqpn;

 	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET,
 		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
@@ -490,6 +498,9 @@ static int stat_one_qp_bind(struct rd *rd)

 	if (rd_argc(rd)) {
 		cntn = stat_get_arg(rd, "cntn");
+		if (cntn < 0)
+			return cntn;
+
 		mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_COUNTER_ID,
 				 cntn);
 	}
@@ -560,13 +571,23 @@ static int stat_one_qp_unbind(struct rd *rd)
 	unsigned int portid;
 	uint32_t seq;

+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
 	ret = rd_build_filter(rd, stat_valid_filters);
 	if (ret)
 		return ret;

 	cntn = stat_get_arg(rd, "cntn");
+	if (cntn < 0)
+		return cntn;
+
 	if (rd_argc(rd)) {
 		lqpn = stat_get_arg(rd, "lqpn");
+		if (lqpn < 0)
+			return lqpn;
 		return do_stat_qp_unbind_lqpn(rd, cntn, lqpn);
 	}

diff --git a/rdma/utils.c b/rdma/utils.c
index e25c3adf..bbfa23ba 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -47,6 +47,13 @@ bool rd_no_arg(struct rd *rd)
 	return rd_argc(rd) == 0;
 }

+bool rd_is_multiarg(struct rd *rd)
+{
+	if (!rd_argc(rd))
+		return false;
+	return strpbrk(rd_argv(rd), ",-") != NULL;
+}
+
 /*
  * Possible input:output
  * dev/port    | first port | is_dump_all
--
2.29.2

