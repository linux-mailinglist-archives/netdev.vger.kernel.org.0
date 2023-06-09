Return-Path: <netdev+bounces-9558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4FF729C1A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89552281977
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41EB1775B;
	Fri,  9 Jun 2023 14:00:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52C3747F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:00:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7BB35B6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686319200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h7/Xf5Toe34wsk9morWfdaW8uhzw5Xjamq9aeozLMqY=;
	b=ixyt3zZJwPZRsryqVUfPoXB8SoeJ1IucC2th+qDpjN4KTIQnpoeXx78qONEKo++FxMKOjW
	GJT/u8xsQAxJ4LDH1K4GGRgaiiToX3iiyftZxHedJVB9j33EQXy4G9cFOt+xU3ZmnzJxx6
	Uknn54r4SrmxQrKrpKl8MVJD2F8Q6As=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-okLFairfP_SVYewF52FZlg-1; Fri, 09 Jun 2023 09:59:56 -0400
X-MC-Unique: okLFairfP_SVYewF52FZlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22488800962;
	Fri,  9 Jun 2023 13:59:56 +0000 (UTC)
Received: from RHTPC1VM0NT.lan (unknown [10.22.17.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 962D010724;
	Fri,  9 Jun 2023 13:59:55 +0000 (UTC)
From: Aaron Conole <aconole@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	Pravin B Shelar <pshelar@ovn.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Dumitru Ceara <dceara@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next] net: openvswitch: add support for l4 symmetric hashing
Date: Fri,  9 Jun 2023 09:59:55 -0400
Message-Id: <20230609135955.3024931-1-aconole@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since its introduction, the ovs module execute_hash action allowed
hash algorithms other than the skb->l4_hash to be used.  However,
additional hash algorithms were not implemented.  This means flows
requiring different hash distributions weren't able to use the
kernel datapath.

Now, introduce support for symmetric hashing algorithm as an
alternative hash supported by the ovs module using the flow
dissector.

Output of flow using l4_sym hash:

    recirc_id(0),in_port(3),eth(),eth_type(0x0800),
    ipv4(dst=64.0.0.0/192.0.0.0,proto=6,frag=no), packets:30473425,
    bytes:45902883702, used:0.000s, flags:SP.,
    actions:hash(sym_l4(0)),recirc(0xd)

Some performance testing with no GRO/GSO, two veths, single flow:

    hash(l4(0)):      4.35 GBits/s
    hash(l4_sym(0)):  4.24 GBits/s

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 include/uapi/linux/openvswitch.h |  1 +
 net/openvswitch/actions.c        | 12 ++++++++++--
 net/openvswitch/flow_netlink.c   |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index c5d62ee825673..e94870e77ee96 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -765,6 +765,7 @@ struct ovs_action_push_vlan {
  */
 enum ovs_hash_alg {
 	OVS_HASH_ALG_L4,
+	OVS_HASH_ALG_SYM_L4,
 };
 
 /*
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index a8cf9a88758ef..35b20d03c14a6 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1072,8 +1072,16 @@ static void execute_hash(struct sk_buff *skb, struct sw_flow_key *key,
 	struct ovs_action_hash *hash_act = nla_data(attr);
 	u32 hash = 0;
 
-	/* OVS_HASH_ALG_L4 is the only possible hash algorithm.  */
-	hash = skb_get_hash(skb);
+	if (hash_act->hash_alg == OVS_HASH_ALG_L4) {
+		/* OVS_HASH_ALG_L4 hasing type. */
+		hash = skb_get_hash(skb);
+	} else if (hash_act->hash_alg == OVS_HASH_ALG_SYM_L4) {
+		/* OVS_HASH_ALG_SYM_L4 hashing type.  NOTE: this doesn't
+		 * extend past an encapsulated header.
+		 */
+		hash = __skb_get_hash_symmetric(skb);
+	}
+
 	hash = jhash_1word(hash, hash_act->hash_basis);
 	if (!hash)
 		hash = 0x1;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index ead5418c126e3..41116361433da 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3221,6 +3221,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 			switch (act_hash->hash_alg) {
 			case OVS_HASH_ALG_L4:
+				fallthrough;
+			case OVS_HASH_ALG_SYM_L4:
 				break;
 			default:
 				return  -EINVAL;
-- 
2.40.1


