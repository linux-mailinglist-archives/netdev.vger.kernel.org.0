Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716F63B4B91
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFZAgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:48448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhFZAgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:05 -0400
IronPort-SDR: Yy5CwyWv8Me2Pt6jLtKgzDXGUeoOF1ssf+CDWcrUkwd/b5ywTl5yDCHUKkYyX+j1OeAM5Y7PEx
 rAmkp9l/j9KA==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054027"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054027"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:43 -0700
IronPort-SDR: ncMV3gqpUSq8RtdvrbTeRYf+4I4bkHxEZWY3c/CejROiu3MR5TGtcoNoUvwp9CEkS8o79CIVzK
 dKnnxf2G3pAA==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008625"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:43 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 10/12] ethtool: Add support for Frame Preemption verification
Date:   Fri, 25 Jun 2021 17:33:12 -0700
Message-Id: <20210626003314.3159402-11-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WIP WIP WIP

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  3 +++
 include/linux/ethtool.h                      |  2 ++
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/preempt.c                        | 11 +++++++++++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index a87f1716944e..bc44724e2cd5 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1494,6 +1494,8 @@ Request contents:
   ``ETHTOOL_A_PREEMPT_HEADER``           nested  reply header
   ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
   ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
+  ``ETHTOOL_A_PREEMPT_DISABLE_VERIFY``   u8      disable verification
+  ``ETHTOOL_A_PREEMPT_VERIFIED``         u8      verification procedure
   =====================================  ======  ==========================
 
 ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
@@ -1510,6 +1512,7 @@ Request contents:
   ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
   ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
   ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
+  ``ETHTOOL_A_PREEMPT_DISABLE_VERIFY``   u8      disable verification
   =====================================  ======  ==========================
 
 ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 7e449be8f335..64c31ab75e16 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -420,6 +420,8 @@ struct ethtool_module_eeprom {
 struct ethtool_fp {
 	u8 enabled;
 	u32 add_frag_size;
+	u8 disable_verify;
+	u8 verified;
 };
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 4600aba1c693..c2b4d7c3ed14 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -675,6 +675,8 @@ enum {
 	ETHTOOL_A_PREEMPT_HEADER,			/* nest - _A_HEADER_* */
 	ETHTOOL_A_PREEMPT_ENABLED,			/* u8 */
 	ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_PREEMPT_DISABLE_VERIFY,		/* u8 */
+	ETHTOOL_A_PREEMPT_VERIFIED,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PREEMPT_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index cc90a463a81c..671237d31ced 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -383,7 +383,7 @@ extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
 extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_HEADER + 1];
-extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE + 1];
+extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_VERIFIED + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/preempt.c b/net/ethtool/preempt.c
index 4f96d3c2b1d5..5d70374d9b01 100644
--- a/net/ethtool/preempt.c
+++ b/net/ethtool/preempt.c
@@ -48,6 +48,8 @@ static int preempt_reply_size(const struct ethnl_req_info *req_base,
 
 	len += nla_total_size(sizeof(u8)); /* _PREEMPT_ENABLED */
 	len += nla_total_size(sizeof(u32)); /* _PREEMPT_ADD_FRAG_SIZE */
+	len += nla_total_size(sizeof(u8)); /* _PREEMPT_DISABLE_VERIFY */
+	len += nla_total_size(sizeof(u8)); /* _PREEMPT_VERIFIED */
 
 	return len;
 }
@@ -66,6 +68,12 @@ static int preempt_fill_reply(struct sk_buff *skb,
 			preempt->add_frag_size))
 		return -EMSGSIZE;
 
+	if (nla_put_u8(skb, ETHTOOL_A_PREEMPT_DISABLE_VERIFY, preempt->disable_verify))
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, ETHTOOL_A_PREEMPT_VERIFIED, preempt->verified))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -86,6 +94,7 @@ ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_MAX + 1] = {
 	[ETHTOOL_A_PREEMPT_HEADER]			= NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PREEMPT_ENABLED]			= NLA_POLICY_RANGE(NLA_U8, 0, 1),
 	[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE]		= { .type = NLA_U32 },
+	[ETHTOOL_A_PREEMPT_DISABLE_VERIFY]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
 };
 
 int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
@@ -124,6 +133,8 @@ int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
 			tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
 	ethnl_update_u32(&preempt.add_frag_size,
 			 tb[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE], &mod);
+	ethnl_update_u8(&preempt.disable_verify,
+			tb[ETHTOOL_A_PREEMPT_DISABLE_VERIFY], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.32.0

