Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243255B2449
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiIHRRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiIHRRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:17:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4B8CCD72
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662657441; x=1694193441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c5dge/CkU6e3Ca5jKPDZgXZ0vNo3NmBlxuEfNBj7OAQ=;
  b=XKbzu6WDw4SY1M3uh+bWUe15KGbdcNTbMqG8XSv5TxQtDbGrnHLwiPp7
   ulB+JqI1pnuI8LfDKc0uC2wyno0PmcyU34bH+vAmsIpqiESqUkZTi1mdj
   GqVeJEVHdQ2tV5bOzIsApVufJ58IHzKOE48HGm2jnf7MTu2pZUBkHT4W/
   B+xVIO+gRB5BgBWDuE09YWeKe7+eAKy3epBYBeSHv6xHDQsNa+169JHyq
   0IAjSoAvooZHGa93cE2jBbkwlE6knvjFpQ2LefWT46ingKgCv2Iyriycf
   /pA8qc9TuuSigk+N2Wq/4ewVXiZzghYt0Xd0WTkjD1RR59yg3pFirfaDu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297267572"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297267572"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="860117835"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 10:16:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        simon.horman@corigine.com, kurt@linutronix.de,
        komachi.yoshiki@gmail.com, jchapman@katalix.com,
        boris.sukholitko@broadcom.com, louis.peens@corigine.com,
        gnault@redhat.com, vladbu@nvidia.com, pablo@netfilter.org,
        baowen.zheng@corigine.com, maksym.glubokiy@plvision.eu,
        jiri@resnulli.us, paulb@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next v1 3/5] net/sched: flower: Add L2TPv3 filter
Date:   Thu,  8 Sep 2022 10:16:42 -0700
Message-Id: <20220908171644.1282191-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
References: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

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

Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.35.1

