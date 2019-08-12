Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A97689B2A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfHLKRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:17:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49111 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbfHLKRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 06:17:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 32E5E21F16;
        Mon, 12 Aug 2019 06:17:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 12 Aug 2019 06:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zP+6oYsL0xPCrmAPh
        ZSWiKhgiLkwj7fMru3h03QugCQ=; b=Grdvk3xtKK2y1UAUP6z71CeFh/pBx0cxr
        +x3YJzPDR764kzMiEBua6tZ7EjCMhr13NEufYKb5G22O7Qdb+XWTXaAmiuZWj6XY
        90md75rq16i4Fdip6ZDos7QcZvOQFgOXaH7Z6gyrpN1lO17tm1KAv/GUruOci7Iu
        YCeUJO7gm55wIkZcKJ06by469BjC/9PJwg2oQNQszkdUwBTVyplJ3Nk1LLheWdvm
        dd9UCCbKVhu0EA8es8ASkwXXb+jU5WrAvUlH9jxono2ZLfrSeAoxBPjmamGC1E99
        SMQK0Eglmr2D6b50tBRoo7Ull9pkHJOYopHQSbCM94CLgCKJII5fA==
X-ME-Sender: <xms:uTxRXVQnNgUV4A9Iu_X-0V3NG-GUhExByejC5X8pnk6E-sFQWyJIHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:uTxRXWi6nuHW_1IhXsyXr9rCIkNI1NyEbgAxQPqkHDoYQMciAP75OA>
    <xmx:uTxRXd5JUB4lPEjLke5SmPMvmx_LcF8WGjOSol7X36hfXHzUdX79Jw>
    <xmx:uTxRXbBoxrHv2U9ds07ZkIHe6NRqoWwcQNYGqzcRO_VWdF2aTB2XDw>
    <xmx:ujxRXZbr_1Djul419f_VZ8WpQMNtoDkd5h2jWgUpsAsCf2TsrfmArg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91A6380059;
        Mon, 12 Aug 2019 06:17:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2] tc: Fix block-handle support for filter operations
Date:   Mon, 12 Aug 2019 13:17:06 +0300
Message-Id: <20190812101706.15778-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Commit e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and
actions"") reverted more than it should and broke shared block
functionality. Fix this by restoring the original functionality.

To reproduce:

# tc qdisc add dev swp1 ingress_block 10 ingress
# tc filter add block 10 proto ip pref 1 flower \
	dst_ip 192.0.2.0/24 action drop
Unknown filter "block", hence option "10" is unparsable

Fixes: e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and actions"")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tc/tc_filter.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 53759a7a8876..23e21d89d7d1 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -74,6 +74,7 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv)
 	__u32 prio = 0;
 	__u32 protocol = 0;
 	int protocol_set = 0;
+	__u32 block_index = 0;
 	__u32 chain_index;
 	int chain_index_set = 0;
 	char *fhandle = NULL;
@@ -89,7 +90,21 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv)
 			NEXT_ARG();
 			if (d[0])
 				duparg("dev", *argv);
+			if (block_index) {
+				fprintf(stderr, "Error: \"dev\" and \"block\" are mutually exclusive\n");
+				return -1;
+			}
 			strncpy(d, *argv, sizeof(d)-1);
+		} else if (matches(*argv, "block") == 0) {
+			NEXT_ARG();
+			if (block_index)
+				duparg("block", *argv);
+			if (d[0]) {
+				fprintf(stderr, "Error: \"dev\" and \"block\" are mutually exclusive\n");
+				return -1;
+			}
+			if (get_u32(&block_index, *argv, 0) || !block_index)
+				invarg("invalid block index value", *argv);
 		} else if (strcmp(*argv, "root") == 0) {
 			if (req.t.tcm_parent) {
 				fprintf(stderr,
@@ -184,6 +199,9 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv)
 			fprintf(stderr, "Cannot find device \"%s\"\n", d);
 			return 1;
 		}
+	} else if (block_index) {
+		req.t.tcm_ifindex = TCM_IFINDEX_MAGIC_BLOCK;
+		req.t.tcm_block_index = block_index;
 	}
 
 	if (q) {
-- 
2.21.0

