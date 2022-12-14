Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94C764CE26
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiLNQgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiLNQgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:36:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32B92A258
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4BUsKenTT/xSTJkdHJbUjjnIHaXWG/WKPiDh/TvfJPU=;
        b=geVQsCQ8wunzsMJNtEUZgyot6t4Wx2zu5a1635dUDBmaLxg9iOOMAluJLi3RYskbZntICj
        l6aZowurS9zozf0lsbj5aE+5NWnh/0qBv/LwBqopM3G/Cecump0jr9kDoODU/Dv1EJF7Vq
        pAaJvVzbLq0tzciTqKx8PQNRfHfligE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-8PT9EY1dNai9LG2VPzK6rw-1; Wed, 14 Dec 2022 11:34:02 -0500
X-MC-Unique: 8PT9EY1dNai9LG2VPzK6rw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F15428027F8;
        Wed, 14 Dec 2022 16:34:01 +0000 (UTC)
Received: from ebuild.redhat.com (unknown [10.39.195.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A78811121314;
        Wed, 14 Dec 2022 16:34:00 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     pshelar@ovn.org, davem@davemloft.net, dev@openvswitch.org,
        i.maximets@ovn.org, aconole@redhat.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net v2] openvswitch: Fix flow lookup to use unmasked key
Date:   Wed, 14 Dec 2022 17:33:56 +0100
Message-Id: <167103556314.309509.17490804498492906420.stgit@ebuild>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit mentioned below causes the ovs_flow_tbl_lookup() function
to be called with the masked key. However, it's supposed to be called
with the unmasked key.

This change reverses the commit below, but rather than having the key
on the stack, it's allocated.

Fixes: 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 bytes warning.")

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

---
Version history:
 - v2: Fixed ENOME(N/M) error. Forgot to do a stg refresh.

 net/openvswitch/datapath.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 861dfb8daf4a..55b697c4d576 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct sw_flow_mask mask;
 	struct sk_buff *reply;
 	struct datapath *dp;
+	struct sw_flow_key *key;
 	struct sw_flow_actions *acts;
 	struct sw_flow_match match;
 	u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
@@ -975,24 +976,26 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Extract key. */
-	ovs_match_init(&match, &new_flow->key, false, &mask);
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	if (!key) {
+		error = -ENOMEM;
+		goto err_kfree_key;
+	}
+
+	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
 		goto err_kfree_flow;
 
+	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
+
 	/* Extract flow identifier. */
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
-				       &new_flow->key, log);
+				       key, log);
 	if (error)
 		goto err_kfree_flow;
 
-	/* unmasked key is needed to match when ufid is not used. */
-	if (ovs_identifier_is_key(&new_flow->id))
-		match.key = new_flow->id.unmasked_key;
-
-	ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
-
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
@@ -1019,7 +1022,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (ovs_identifier_is_ufid(&new_flow->id))
 		flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
 	if (!flow)
-		flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
+		flow = ovs_flow_tbl_lookup(&dp->table, key);
 	if (likely(!flow)) {
 		rcu_assign_pointer(new_flow->sf_acts, acts);
 
@@ -1089,6 +1092,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	if (reply)
 		ovs_notify(&dp_flow_genl_family, reply, info);
+
+	kfree(key);
 	return 0;
 
 err_unlock_ovs:
@@ -1098,6 +1103,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_nla_free_flow_actions(acts);
 err_kfree_flow:
 	ovs_flow_free(new_flow, false);
+err_kfree_key:
+	kfree(key);
 error:
 	return error;
 }

