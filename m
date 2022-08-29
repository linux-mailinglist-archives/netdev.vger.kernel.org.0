Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28A5A465D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiH2Jrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiH2Jre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:47:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A845C9DC
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661766452; x=1693302452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7TkI2g42TiyDpYroOfN0n4SxRBLUdO83QwuhHROSfFc=;
  b=ACEacM+hjEcvmTadm06ZePQ4ufAVtD5zNj1Zk4Xqsrdgj3amSPEB3FFX
   QuZVLO8SRpDSPHvdB6Jy+8+085e55Z9+9YBeKzCN9f2E/3WD+6xE3cg1Z
   ZuwUqK3oWDTEQrjG/coht3IvK1r0csiAp1x3y29xK1xGCp/THwGu/ZDE5
   vRTewikD+pyGreTBrND1SGB7ZcM3Gv5g70Db52c67KyZQN8KAhnpCffc3
   8wBz/JGn9DjCBYi/41MgKHgfjx0I2Tj/sGSHEZnRJEKILl0pLMySAfElV
   nhieB2IisCAIb5HAMLuFEKN1QtsZFuubqwEG7diiVX17E89EDhEs6k0K+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="296131459"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="296131459"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 02:47:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="787028187"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 29 Aug 2022 02:47:26 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27T9lK8g021475;
        Mon, 29 Aug 2022 10:47:25 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next v2 3/5] net/sched: flower: Add L2TPv3 filter
Date:   Mon, 29 Aug 2022 11:44:10 +0200
Message-Id: <20220829094412.554018-4-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220829094412.554018-1-wojciech.drewek@intel.com>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for matching on L2TPv3 session ID.
Session ID can be specified only when ip proto was
set to IPPROTO_L2TP.

Example filter:
  # tc filter add dev $PF1 ingress prio 1 protocol ip \
      flower \
        ip_proto l2tp \
        l2tpv3_sid 1234 \
        skip_sw \
      action mirred egress redirect dev $VF1_PR

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/pkt_cls.h |  2 ++
 net/sched/cls_flower.c       | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 877309d6ca3c..648a82f32666 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -592,6 +592,8 @@ enum {
 	TCA_FLOWER_KEY_PPPOE_SID,	/* be16 */
 	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
 
+	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 041d63ff809a..22d32b82bc09 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -69,6 +69,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_hash hash;
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
 	struct flow_dissector_key_pppoe pppoe;
+	struct flow_dissector_key_l2tpv3 l2tpv3;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -712,6 +713,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_NUM_OF_VLANS]	= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
 
 };
 
@@ -1790,6 +1792,11 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		fl_set_key_val(tb, key->arp.tha, TCA_FLOWER_KEY_ARP_THA,
 			       mask->arp.tha, TCA_FLOWER_KEY_ARP_THA_MASK,
 			       sizeof(key->arp.tha));
+	} else if (key->basic.ip_proto == IPPROTO_L2TP) {
+		fl_set_key_val(tb, &key->l2tpv3.session_id,
+			       TCA_FLOWER_KEY_L2TPV3_SID,
+			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
+			       sizeof(key->l2tpv3.session_id));
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1970,6 +1977,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_NUM_OF_VLANS, num_of_vlans);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3196,6 +3205,13 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 				  mask->arp.tha, TCA_FLOWER_KEY_ARP_THA_MASK,
 				  sizeof(key->arp.tha))))
 		goto nla_put_failure;
+	else if (key->basic.ip_proto == IPPROTO_L2TP &&
+		 fl_dump_key_val(skb, &key->l2tpv3.session_id,
+				 TCA_FLOWER_KEY_L2TPV3_SID,
+				 &mask->l2tpv3.session_id,
+				 TCA_FLOWER_UNSPEC,
+				 sizeof(key->l2tpv3.session_id)))
+		goto nla_put_failure;
 
 	if ((key->basic.ip_proto == IPPROTO_TCP ||
 	     key->basic.ip_proto == IPPROTO_UDP ||
-- 
2.31.1

