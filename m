Return-Path: <netdev+bounces-1861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6626FF56F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9918E1C20F77
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A8562A;
	Thu, 11 May 2023 15:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520FD629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F0CC433D2;
	Thu, 11 May 2023 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683817636;
	bh=VRMniVLBTOi5ZQYefU/ECsSzJJiSsUxbGragDiwwd8w=;
	h=From:Date:Subject:To:Cc:From;
	b=q/Bep2eSjNhBtoyYnB99q2b5tw9u5PufZptSJB55NZeIyqOslzgi8pyEUB8OwHdW4
	 gywDazu7RaBf5P8lNWn27iuyNOsVzkCQjtRHDmHCnaMIiXM3HSKhi+NkEQXNf/cfAk
	 r1ukb0TzU3tNIQtZLvsBQEFvq12FYqYpocAAvbT50A1Eb3d5gjWrq5y0RDLv8AjH6B
	 5C0onJAWXdFF9mHKQct74fzEEBrT6W3vwL++StayWvU/V+oeQNtRFmDZmD1vfY8D+Z
	 5WwPXV2MQ4IW5IB3JsMvusm5IP6fizXBD0xPsdkZj31IatAFvnQmQt/taRpBIs3JXw
	 jKPwjP4GhhlEg==
From: Simon Horman <horms@kernel.org>
Date: Thu, 11 May 2023 17:07:12 +0200
Subject: [PATCH net-next v2] bonding: Always assign be16 value to
 vlan_proto
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ8EXWQC/4WOQQ6CMBBFr0Jm7Zi2gIgr72FYtDBAI5mStjYYw
 t1tuIDL939+3t8hkLcU4FHs4CnZYB1nUJcC+lnzRGiHzKCEKkWlBBrHg+UJDWFaNOPqXXRYlz2
 pmyLR0B3y1uhAaLzmfs5r/ixLDldPo91O2QuYIjJtEbrczDZE57/niyTP/o8wSZTY1FXZtmMtB
 yGfb/JMy9X5CbrjOH7rWcXm2gAAAA==
To: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>, 
 Andy Gospodarek <andy@greyhouse.net>, Vladimir Oltean <olteanv@gmail.com>, 
 netdev@vger.kernel.org
X-Mailer: b4 0.12.2

The type of the vlan_proto field is __be16.
And most users of the field use it as such.

In the case of setting or testing the field for the special VLAN_N_VID
value, host byte order is used. Which seems incorrect.

It also seems somewhat odd to store a VLAN ID value in a field that is
otherwise used to store Ether types.

Address this issue by defining BOND_VLAN_PROTO_NONE, a big endian value.
0xffff was chosen somewhat arbitrarily. What is important is that it
doesn't overlap with any valid VLAN Ether types.

I don't believe the problems described above are a bug because
VLAN_N_VID in both little-endian and big-endian byte order does not
conflict with any supported VLAN Ether types in big-endian byte order.

Reported by sparse as:

 .../bond_main.c:2857:26: warning: restricted __be16 degrades to integer
 .../bond_main.c:2863:20: warning: restricted __be16 degrades to integer
 .../bond_main.c:2939:40: warning: incorrect type in assignment (different base types)
 .../bond_main.c:2939:40:    expected restricted __be16 [usertype] vlan_proto
 .../bond_main.c:2939:40:    got int

No functional changes intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
Changes in v2:
- Decribe Ether Type aspect of problem in patch description
- Use an Ether Type rather than VID valie as sential
- Link to v1: https://lore.kernel.org/r/20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org
---
 drivers/net/bonding/bond_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fed888629f7..ebf61c19dcef 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2871,6 +2871,8 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
 	return ret;
 }
 
+#define BOND_VLAN_PROTO_NONE cpu_to_be16(0xffff)
+
 static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
 			     struct sk_buff *skb)
 {
@@ -2878,13 +2880,13 @@ static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
 	struct net_device *slave_dev = slave->dev;
 	struct bond_vlan_tag *outer_tag = tags;
 
-	if (!tags || tags->vlan_proto == VLAN_N_VID)
+	if (!tags || tags->vlan_proto == BOND_VLAN_PROTO_NONE)
 		return true;
 
 	tags++;
 
 	/* Go through all the tags backwards and add them to the packet */
-	while (tags->vlan_proto != VLAN_N_VID) {
+	while (tags->vlan_proto != BOND_VLAN_PROTO_NONE) {
 		if (!tags->vlan_id) {
 			tags++;
 			continue;
@@ -2960,7 +2962,7 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
 		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		tags[level].vlan_proto = VLAN_N_VID;
+		tags[level].vlan_proto = BOND_VLAN_PROTO_NONE;
 		return tags;
 	}
 


