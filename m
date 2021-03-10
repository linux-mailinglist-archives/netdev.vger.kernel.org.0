Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2C5333A18
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCJKeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:34:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50925 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230266AbhCJKeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 05:34:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 742E85C0094;
        Wed, 10 Mar 2021 05:34:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 05:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1Hyqd1G4Oj74/6vd6
        ZWulU74O6MszGw7YX2pQhKzjpg=; b=u5bgFwYQhJTX1HOPwq/eBcdu7j2NE3RIF
        tmHFrgosxKQVn/lGTOSLYrEOzpmfvAX7Og36OfCLWleroBzQ0jgoSVQ1o/NFo2ZL
        HQhOJQOBblla5caZZ0TMDPMBIQStJYnS/O996NqCyi2iG+2QqtiSuXawlALBWl3k
        f8jvW+v2z6QtFSWPWE5UwRH/0mQbdHUrFKRvotaLEfo3tAFlyrOZE9wegcWtAhC8
        a30oBSTRM38aPI5c5x9Up5u6sFsuzTcUAPyChmeqzDXFFyehVyc2wtQTrMI83OSH
        fSPHdiY53BB2FrnuGdP/04XXdbusdcy5o/p7DADB78CF574Pa0rWA==
X-ME-Sender: <xms:l6BIYMUoiy4LRpWa1icuEZ-2TOX9rTjDHw9KXVSIdeHsBTodsF3wVw>
    <xme:l6BIYAl2c4vfAYBVi5_8h9b1NchcsrlqGBPjnK5N4ngqLgnblWyHpgd-toSbqRuHD
    Qk9MehTDygBbJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:l6BIYAaw4bGHSnqaLm_aALd89bs1ke5jnZ-lKmMSWsfAJFbD3tKIiQ>
    <xmx:l6BIYLXCqD-ExQ1mGF3j6hl7x31xFExSwZzZJMG7u_f7DluOPYCqOw>
    <xmx:l6BIYGlJ6WofdqkssRd9i62LDwoloochTzdF-xyIyBt7gU3DgNQHdw>
    <xmx:mKBIYNvFr3ZK7CdFbDMqgIlLNOXStvzz_U9nWvlLA3JqR5IfDf-1UQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95172108005F;
        Wed, 10 Mar 2021 05:33:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] sched: act_sample: Implement stats_update callback
Date:   Wed, 10 Mar 2021 12:33:20 +0200
Message-Id: <20210310103320.2531933-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement this callback in order to get the offloaded stats added to the
kernel stats.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/sched/act_sample.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 3ebf9ede3cf1..db8ee9e5c8c2 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -194,6 +194,16 @@ static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
 	return retval;
 }
 
+static void tcf_sample_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				    u64 drops, u64 lastuse, bool hw)
+{
+	struct tcf_sample *s = to_sample(a);
+	struct tcf_t *tm = &s->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
 static int tcf_sample_dump(struct sk_buff *skb, struct tc_action *a,
 			   int bind, int ref)
 {
@@ -280,6 +290,7 @@ static struct tc_action_ops act_sample_ops = {
 	.id	  = TCA_ID_SAMPLE,
 	.owner	  = THIS_MODULE,
 	.act	  = tcf_sample_act,
+	.stats_update = tcf_sample_stats_update,
 	.dump	  = tcf_sample_dump,
 	.init	  = tcf_sample_init,
 	.cleanup  = tcf_sample_cleanup,
-- 
2.29.2

