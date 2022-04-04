Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875FA4F133D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357230AbiDDKn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245317AbiDDKnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:43:55 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBED3CA77;
        Mon,  4 Apr 2022 03:41:59 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id E15841C000C;
        Mon,  4 Apr 2022 10:41:54 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>, Andy Zhou <azhou@ovn.org>,
        Yifeng Sun <pkusunyifeng@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net] net: openvswitch: don't send internal clone attribute to the userspace.
Date:   Mon,  4 Apr 2022 12:41:50 +0200
Message-Id: <20220404104150.2865736-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'OVS_CLONE_ATTR_EXEC' is an internal attribute that is used for
performance optimization inside the kernel.  It's added by the kernel
while parsing user-provided actions and should not be sent during the
flow dump as it's not part of the uAPI.

The issue doesn't cause any significant problems to the ovs-vswitchd
process, because reported actions are not really used in the
application lifecycle and only supposed to be shown to a human via
ovs-dpctl flow dump.  However, the action list is still incorrect
and causes the following error if the user wants to look at the
datapath flows:

  # ovs-dpctl add-dp system@ovs-system
  # ovs-dpctl add-flow "<flow match>" "clone(ct(commit),0)"
  # ovs-dpctl dump-flows
  <flow match>, packets:0, bytes:0, used:never,
    actions:clone(bad length 4, expected -1 for: action0(01 00 00 00),
                  ct(commit),0)

With the fix:

  # ovs-dpctl dump-flows
  <flow match>, packets:0, bytes:0, used:never,
    actions:clone(ct(commit),0)

Additionally fixed an incorrect attribute name in the comment.

Fixes: b233504033db ("openvswitch: kernel datapath clone action")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 net/openvswitch/actions.c      | 2 +-
 net/openvswitch/flow_netlink.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 7056cb1b8ba0..1b5d73079dc9 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1051,7 +1051,7 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
 	int rem = nla_len(attr);
 	bool dont_clone_flow_key;
 
-	/* The first action is always 'OVS_CLONE_ATTR_ARG'. */
+	/* The first action is always 'OVS_CLONE_ATTR_EXEC'. */
 	clone_arg = nla_data(attr);
 	dont_clone_flow_key = nla_get_u32(clone_arg);
 	actions = nla_next(clone_arg, &rem);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index cc282a58b75b..dbdcaaa27f5b 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3458,7 +3458,9 @@ static int clone_action_to_attr(const struct nlattr *attr,
 	if (!start)
 		return -EMSGSIZE;
 
-	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
+	/* Skipping the OVS_CLONE_ATTR_EXEC that is always the first attribute. */
+	attr = nla_next(nla_data(attr), &rem);
+	err = ovs_nla_put_actions(attr, rem, skb);
 
 	if (err)
 		nla_nest_cancel(skb, start);
-- 
2.34.1

