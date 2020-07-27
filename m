Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81D22FBA0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgG0VuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:50:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:24391 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0VuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:50:23 -0400
IronPort-SDR: 4/Vq0bzU6nOoJZ6Krohr2haElrgNpNlHEhL1cjuPHPo3L4Sa1SJ0JWPTbcu0nQjZYAU3uV7h2p
 +3vKo0+HcPwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="150287651"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="150287651"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 14:50:23 -0700
IronPort-SDR: U7lsxqTe59BfIHFnOBGcqbtxcv2wRGamZvTe63eEsVx4lh1+n2kBgM3XtO/+3kzsxwPl/+mRVC
 0y7KHmI5OWiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="364266573"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-stp-glorfindel.jf.intel.com) ([10.166.241.33])
  by orsmga001.jf.intel.com with ESMTP; 27 Jul 2020 14:50:22 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Date:   Mon, 27 Jul 2020 14:47:00 -0700
Message-Id: <20200727214700.5915-1-jacob.e.keller@intel.com>
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

The dump_link_modes and bitset_get_bit functions are designed so they
can print either the values or the mask. For a nomask bitmap, this
doesn't make sense. There is no mask.

Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
regardless of the request to display the mask or the value. For full
size bitmaps, the set of provided bits indicates the valid values,
without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
bits without this attribute if nomask is set. This essentially means
that dump_link_modes will treat a NOMASK bitset as having a mask
equivalent to all of its set bits.

For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
For full bitmaps, if nomask is set, then always return true of the bit
is in the set, rather than only if it provides an
ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
bits.

This fixes display of link partner advertised fields when using the
netlink API.

Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 netlink/bitset.c   | 9 ++++++---
 netlink/settings.c | 8 +++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/netlink/bitset.c b/netlink/bitset.c
index 130bcdb5b52c..ba5d3ea77ff7 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 	DECLARE_ATTR_TB_INFO(bitset_tb);
 	const struct nlattr *bits;
 	const struct nlattr *bit;
+	bool nomask;
 	int ret;
 
 	*retptr = 0;
@@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 	if (ret < 0)
 		goto err;
 
-	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
-		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
+
+	bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
+		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
 	if (bits) {
 		const uint32_t *bitmap =
 			(const uint32_t *)mnl_attr_get_payload(bits);
@@ -87,7 +90,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 
 		my_idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
 		if (my_idx == idx)
-			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
+			return mask || nomask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
 	}
 
 	return false;
diff --git a/netlink/settings.c b/netlink/settings.c
index 35ba2f5dd6d5..29557653336e 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -280,9 +280,11 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 	const struct nlattr *bit;
 	bool first = true;
 	int prev = -2;
+	bool nomask;
 	int ret;
 
 	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
 	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
 	if (ret < 0)
 		goto err_nonl;
@@ -297,8 +299,8 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 			goto err_nonl;
 		lm_strings = global_stringset(ETH_SS_LINK_MODES,
 					      nlctx->ethnl2_socket);
-		bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
-			      bitset_tb[ETHTOOL_A_BITSET_VALUE];
+		bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
+			                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
 		ret = -EFAULT;
 		if (!bits || !bitset_tb[ETHTOOL_A_BITSET_SIZE])
 			goto err_nonl;
@@ -354,7 +356,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
 		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
 			goto err;
-		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
+		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
 			continue;
 
 		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
-- 
2.26.2

