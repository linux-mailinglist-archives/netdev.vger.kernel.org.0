Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7422FC82
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgG0WxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:53:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:27607 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgG0WxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:53:00 -0400
IronPort-SDR: tFf1f86n9ab5Qy13iy1xyo1om4BlZEnI6iZGMy+Y71063x+n3LILHtEP9cQw05ET0c+11+SYBh
 IdxjoxjUg/UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="138638236"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="138638236"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:52:59 -0700
IronPort-SDR: KTMC6GW2ytUPQRY+KzDudNnxizOrXVDknnfAwT2qTlzljNf7514XUp9pgsSZ/R8Tnlaz/U7+o8
 7B2MVrv8qyPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="434104240"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-stp-glorfindel.jf.intel.com) ([10.166.241.33])
  by orsmga004.jf.intel.com with ESMTP; 27 Jul 2020 15:52:59 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: [ethtool v2 1/2] ethtool: fix netlink bitmasks when sent as NOMASK
Date:   Mon, 27 Jul 2020 15:49:36 -0700
Message-Id: <20200727224937.9185-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool netlink API can send bitsets without an associated bitmask.
These do not get displayed properly, because the dump_link_modes, and
bitset_get_bit to not check whether the provided bitset is a NOMASK
bitset. This results in the inability to display peer advertised link
modes.

Both the dump_link_modes and bitset_git_bit functions do not check
ETHTOOL_A_BITSET_NOMASK, and thus do not properly handle bitsets which
do not have a provided mask.

For compact bitmaps, things work more or less ok, as long as mask was
provided as "false". This is because it will always use the
ETHTOOL_A_BITSET_BIT_VALUE section when mask is false. A NOMASK compact
bitmap will provide this.

Unfortunately, if the bitset is not sent in the compact format, these
functions do not behave correctly. When NOMASK is set, then the
ETHTOOL_A_BITSET_BIT_VALUE is not provided. Instead, the application is
supposed to treat it as a list of all the valid values.

Fix these functions so that they behave properly with NOMASK bitsets in
the non-compact form. Additionally, make these functions report an error
if requesting to operate with "mask" set on a NOMASK bitmap. This
ensures that we catch issues in the case where ethtool is trying to
print the mask of a bitset that has no mask. Doing so highlights a small
bug in the FEC settings where we accidentally set mask to true. Fix this
also.

Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 netlink/bitset.c   | 12 +++++++++++-
 netlink/settings.c | 16 +++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/netlink/bitset.c b/netlink/bitset.c
index 130bcdb5b52c..10ce8e9def9a 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 	DECLARE_ATTR_TB_INFO(bitset_tb);
 	const struct nlattr *bits;
 	const struct nlattr *bit;
+	bool nomask;
 	int ret;
 
 	*retptr = 0;
@@ -57,6 +58,15 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 	if (ret < 0)
 		goto err;
 
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
+	if (mask && nomask) {
+		/* Trying to determine if a bit is set in the mask of a "no
+		 * mask" bitset doesn't make sense.
+		 */
+		ret = -EFAULT;
+		goto err;
+	}
+
 	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
 		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
 	if (bits) {
@@ -87,7 +97,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 
 		my_idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
 		if (my_idx == idx)
-			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
+			return mask || nomask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
 	}
 
 	return false;
diff --git a/netlink/settings.c b/netlink/settings.c
index 35ba2f5dd6d5..66b0d4892cdd 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -280,12 +280,22 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 	const struct nlattr *bit;
 	bool first = true;
 	int prev = -2;
+	bool nomask;
 	int ret;
 
 	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
-	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
 	if (ret < 0)
 		goto err_nonl;
+
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
+	/* Trying to print the mask of a "no mask" bitset doesn't make sense */
+	if (mask && nomask) {
+		ret = -EFAULT;
+		goto err_nonl;
+	}
+
+	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
+
 	if (!bits) {
 		const struct stringset *lm_strings;
 		unsigned int count;
@@ -354,7 +364,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
 		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
 			goto err;
-		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
+		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
 			continue;
 
 		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
@@ -469,7 +479,7 @@ static int dump_peer_modes(struct nl_context *nlctx, const struct nlattr *attr)
 	printf("\tLink partner advertised auto-negotiation: %s\n",
 	       autoneg ? "Yes" : "No");
 
-	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
+	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
 			      "Link partner advertised FEC modes: ",
 			      " ", "\n", "No");
 	return ret;
-- 
2.26.2

