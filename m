Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0313F20080D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgFSLsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 07:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732090AbgFSLsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 07:48:46 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E66E20CC7;
        Fri, 19 Jun 2020 11:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592567325;
        bh=pIYFOsIO9JFOBAMAqjmb+st8lbhFlIO5wWXf/14Et40=;
        h=From:To:Cc:Subject:Date:From;
        b=Rqv8xIA0FrS4Ygkw2yYy5g84FYP81lLIg6Q3Q9DXJaTDk0cruiK75IFEVGrelQv+o
         /AwZyM7oUh1/wr0oWomIQkkRP7i3X4wUjT/u55ZWrtJzj9Lm4zvf3y6toGIWu5404V
         lw22doxXtsfDb9RFnriPXkTVZ9iD73UAgk34xuhE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nusiddiq@redhat.com, gvrose8192@gmail.com,
        pshelar@ovn.org, lorenzo.bianconi@redhat.com, dev@openvswitch.org
Subject: [PATCH net] openvswitch: take into account de-fragmentation in execute_check_pkt_len
Date:   Fri, 19 Jun 2020 13:48:32 +0200
Message-Id: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ovs connection tracking module performs de-fragmentation on incoming
fragmented traffic. Take info account if traffic has been de-fragmented
in execute_check_pkt_len action otherwise we will perform the wrong
nested action considering the original packet size. This issue typically
occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.

Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index fc0efd8833c8..9f4dd64e53bb 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 				 struct sw_flow_key *key,
 				 const struct nlattr *attr, bool last)
 {
+	struct ovs_skb_cb *ovs_cb = OVS_CB(skb);
 	const struct nlattr *actions, *cpl_arg;
 	const struct check_pkt_len_arg *arg;
-	int rem = nla_len(attr);
+	int len, rem = nla_len(attr);
 	bool clone_flow_key;
 
 	/* The first netlink attribute in 'attr' is always
@@ -1180,7 +1181,8 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 	cpl_arg = nla_data(attr);
 	arg = nla_data(cpl_arg);
 
-	if (skb->len <= arg->pkt_len) {
+	len = ovs_cb->mru ? ovs_cb->mru : skb->len;
+	if (len <= arg->pkt_len) {
 		/* Second netlink attribute in 'attr' is always
 		 * 'OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL'.
 		 */
-- 
2.26.2

