Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D93A4B245
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbfFSGlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50163 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:41:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B9883221B2;
        Wed, 19 Jun 2019 02:41:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=P10UpEvScDhUJb2J7x8JTfORQQzuZggnZ7pncb+ZHkU=; b=Yi9x7Va1
        Z+6XGCzkyx2qr3ye9uFlcyr0sg1cq/MAfX69uHgSc/lAOD+HU/f+0j7YSuG/pj6U
        a2So0uWfQVU8L9FX9O9MITOekTMBGlxk3DsGfq2+dOAQIxjG5A8MJwHaA05Fk6j6
        u90uFVVSJYF14jUNg7TehMJ2ITY2LHec8+tc+Q8g7oaA7Ra3EQNGPedj3V1Xm1DY
        bl51v6oB8ToCzWUsp/A39XJxIC+qmv027Vr6SQ1Doofy7wo+M57ilP2nHWuHyuNs
        scraShJVeniN7ZkcoZh61NbRw/4sL1bXfoJMXsa0PQepbiCnW9X9QbEY+HdBhxD5
        63ijOr991L4loA==
X-ME-Sender: <xms:LtkJXUQ_M_Px4w9cejGZ8dbAi-mBCuwycbc8PCOt69ExsR762K9paQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:LtkJXcoRLFDPOQK4jZP--45ySFDmSaKbxz6sSpojZEbzhyp2ZWd29A>
    <xmx:LtkJXZrPJbDlMuuiHxJUrBY1rzI9BKB0xZSRo98DbB9NHcoPawPNIg>
    <xmx:LtkJXWPOf1QhnyptJU6PfJQivW0uNsSe-1TD8rlC8kNi4YdEEy4E_A>
    <xmx:LtkJXSnGWBmdWobOjweKHzaJOrW0nZTXh2Eg0YOieQddLsBS6UBigQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0947E80060;
        Wed, 19 Jun 2019 02:41:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/8] net: sched: cls_flower: use flow_dissector for ingress ifindex
Date:   Wed, 19 Jun 2019 09:41:03 +0300
Message-Id: <20190619064109.849-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Use previously introduced infra to obtain and store ingress ifindex
instead doing it locally.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/sched/cls_flower.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index bd1767da8353..ce2e9b1c9850 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -27,7 +27,7 @@
 #include <net/dst_metadata.h>
 
 struct fl_flow_key {
-	int	indev_ifindex;
+	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
 	struct flow_dissector_key_control enc_control;
 	struct flow_dissector_key_basic basic;
@@ -284,7 +284,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	list_for_each_entry_rcu(mask, &head->masks, list) {
 		fl_clear_masked_range(&skb_key, mask);
 
-		skb_key.indev_ifindex = skb->skb_iif;
+		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);
 		/* skb_flow_dissect() does not set n_proto in case an unknown
 		 * protocol, so do it rather here.
 		 */
@@ -1026,8 +1026,8 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		int err = tcf_change_indev(net, tb[TCA_FLOWER_INDEV], extack);
 		if (err < 0)
 			return err;
-		key->indev_ifindex = err;
-		mask->indev_ifindex = 0xffffffff;
+		key->meta.ingress_ifindex = err;
+		mask->meta.ingress_ifindex = 0xffffffff;
 	}
 
 	fl_set_key_val(tb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
@@ -1281,6 +1281,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 	struct flow_dissector_key keys[FLOW_DISSECTOR_KEY_MAX];
 	size_t cnt = 0;
 
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_META, meta);
 	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CONTROL, control);
 	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_BASIC, basic);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
@@ -2122,10 +2124,10 @@ static int fl_dump_key_enc_opt(struct sk_buff *skb,
 static int fl_dump_key(struct sk_buff *skb, struct net *net,
 		       struct fl_flow_key *key, struct fl_flow_key *mask)
 {
-	if (mask->indev_ifindex) {
+	if (mask->meta.ingress_ifindex) {
 		struct net_device *dev;
 
-		dev = __dev_get_by_index(net, key->indev_ifindex);
+		dev = __dev_get_by_index(net, key->meta.ingress_ifindex);
 		if (dev && nla_put_string(skb, TCA_FLOWER_INDEV, dev->name))
 			goto nla_put_failure;
 	}
-- 
2.20.1

