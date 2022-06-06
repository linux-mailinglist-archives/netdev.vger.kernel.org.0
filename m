Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E864053F1FD
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiFFWME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiFFWMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:12:03 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C392D66AFC;
        Mon,  6 Jun 2022 15:12:01 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id EE60640003;
        Mon,  6 Jun 2022 22:11:54 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Paolo Valerio <pvalerio@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>, stable@vger.kernel.org,
        Frode Nordahl <frode.nordahl@canonical.com>
Subject: [PATCH net] net: openvswitch: fix misuse of the cached connection on tuple changes
Date:   Tue,  7 Jun 2022 00:11:40 +0200
Message-Id: <20220606221140.488984-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If packet headers changed, the cached nfct is no longer relevant
for the packet and attempt to re-use it leads to the incorrect packet
classification.

This issue is causing broken connectivity in OpenStack deployments
with OVS/OVN due to hairpin traffic being unexpectedly dropped.

The setup has datapath flows with several conntrack actions and tuple
changes between them:

  actions:ct(commit,zone=8,mark=0/0x1,nat(src)),
          set(eth(src=00:00:00:00:00:01,dst=00:00:00:00:00:06)),
          set(ipv4(src=172.18.2.10,dst=192.168.100.6,ttl=62)),
          ct(zone=8),recirc(0x4)

After the first ct() action the packet headers are almost fully
re-written.  The next ct() tries to re-use the existing nfct entry
and marks the packet as invalid, so it gets dropped later in the
pipeline.

Clearing the cached conntrack entry whenever packet tuple is changed
to avoid the issue.

The flow key should not be cleared though, because we should still
be able to match on the ct_state if the recirculation happens after
the tuple change but before the next ct() action.

Cc: stable@vger.kernel.org
Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
Reported-by: Frode Nordahl <frode.nordahl@canonical.com>
Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-May/051829.html
Link: https://bugs.launchpad.net/ubuntu/+source/ovn/+bug/1967856
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---

The function ovs_ct_clear() looks a bit differently on older branches,
but the change should be exactly the same, i.e. move the
ovs_ct_fill_key() under the 'if (key)'.

The same behavior for userspace datapath was introduced along with
the conntrack caching support here:
  https://github.com/openvswitch/ovs/commit/594570ea1cdecc7ef7880d707cbc7a4a4ecef09f

Interestingly, above commit also introduced the system test that can
check the issue for the kernel as well, but the test sends only one
packet and this packet goes via upcall to userspace and back to the
kernel effectively clearing the cached connection along the way and
avoiding the issue.  If the test is modified to send more than a few
packets [1], it starts to fail without the kernel fix:

  make check-kernel TESTSUITEFLAGS='-k negative'
  142: conntrack - negative test for recirculation optimization FAILED

[1] https://pastebin.com/H1YMqaLa

 net/openvswitch/actions.c   | 6 ++++++
 net/openvswitch/conntrack.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 1b5d73079dc9..868db4669a29 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -373,6 +373,7 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 	update_ip_l4_checksum(skb, nh, *addr, new_addr);
 	csum_replace4(&nh->check, *addr, new_addr);
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	*addr = new_addr;
 }
 
@@ -420,6 +421,7 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 		update_ipv6_checksum(skb, l4_proto, addr, new_addr);
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
@@ -660,6 +662,7 @@ static int set_nsh(struct sk_buff *skb, struct sw_flow_key *flow_key,
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			__be16 new_port, __sum16 *check)
 {
+	ovs_ct_clear(skb, NULL);
 	inet_proto_csum_replace2(check, skb, *port, new_port, false);
 	*port = new_port;
 }
@@ -699,6 +702,7 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		uh->dest = dst;
 		flow_key->tp.src = src;
 		flow_key->tp.dst = dst;
+		ovs_ct_clear(skb, NULL);
 	}
 
 	skb_clear_hash(skb);
@@ -761,6 +765,8 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	sh->checksum = old_csum ^ old_correct_csum ^ new_csum;
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
+
 	flow_key->tp.src = sh->source;
 	flow_key->tp.dst = sh->dest;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4a947c13c813..4e70df91d0f2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1342,7 +1342,9 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-	ovs_ct_fill_key(skb, key, false);
+
+	if (key)
+		ovs_ct_fill_key(skb, key, false);
 
 	return 0;
 }
-- 
2.34.3

