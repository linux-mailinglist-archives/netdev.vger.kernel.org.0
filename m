Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB70633E68
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiKVOF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiKVOFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:05:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3761F9E7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dwl7SbsKJoZEUQcBj1alw3gjGL8Zf4MEaXU4djfJOx0=;
        b=Pf1/UoLE/DuNnCIY2PUYI9gJoZOvTw32XAgEntwCjps2u9KkgXCodHdww12duhanvzWirV
        EA9HMxq/zpOC1obSz8hpzmd1TO6DclLDUX+jEqBvULWnkFgWro2beaksSuzTKwhX+yTdLf
        J9vEl4lmH2vO566zb+uh8GVwKEwp510=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-Pe1qYOMCPw-rHDPPfBq8NA-1; Tue, 22 Nov 2022 09:03:11 -0500
X-MC-Unique: Pe1qYOMCPw-rHDPPfBq8NA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8A38811E75;
        Tue, 22 Nov 2022 14:03:10 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.16.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33BDC40C6EC6;
        Tue, 22 Nov 2022 14:03:10 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC net-next 1/6] openvswitch: exclude kernel flow key from upcalls
Date:   Tue, 22 Nov 2022 09:03:02 -0500
Message-Id: <20221122140307.705112-2-aconole@redhat.com>
In-Reply-To: <20221122140307.705112-1-aconole@redhat.com>
References: <20221122140307.705112-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing upcall commands, two groups of data are available to
userspace for processing: the actual packet data and the kernel
sw flow key data.  The inclusion of the flow key allows the userspace
avoid running through the dissection again.

However, the userspace can choose to ignore the flow key data, as is
the case in some ovs-vswitchd upcall processing.  For these messages,
having the flow key data merely adds additional data to the upcall
pipeline without any actual gain.  Userspace simply throws the data
away anyway.

Introduce a new feature OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY which signals
that the userspace doesn't want upcalls included with specific class
of message (for example MISS messages).  The associated attribute
OVS_DP_ATTR_EXCLUDE_CMDS tells which specific commands to omit via a
bitmask.

A test will be added to showcase using the feature.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 include/uapi/linux/openvswitch.h |  6 ++++++
 net/openvswitch/datapath.c       | 26 ++++++++++++++++++++++----
 net/openvswitch/datapath.h       |  2 ++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 94066f87e9ee..238e62ecba46 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -95,6 +95,9 @@ enum ovs_datapath_attr {
 				     * per-cpu dispatch mode
 				     */
 	OVS_DP_ATTR_IFINDEX,
+	OVS_DP_ATTR_EXCLUDE_CMDS,	/* u32 mask of OVS_PACKET_CMDs for
+					 * omitting FLOW_KEY attribute
+					 */
 	__OVS_DP_ATTR_MAX
 };
 
@@ -138,6 +141,9 @@ struct ovs_vport_stats {
 /* Allow per-cpu dispatch of upcalls */
 #define OVS_DP_F_DISPATCH_UPCALL_PER_CPU	(1 << 3)
 
+/* Drop Flow key data from upcall packet cmds */
+#define OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY	(1 << 4)
+
 /* Fixed logical ports. */
 #define OVSP_LOCAL      ((__u32)0)
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 861dfb8daf4a..6afde7de492c 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -470,9 +470,13 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	}
 	upcall->dp_ifindex = dp_ifindex;
 
-	err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false, user_skb);
-	if (err)
-		goto out;
+	if (!(dp->user_features & OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY) ||
+	    !(dp->upcall_exclude_cmds & (1U << upcall_info->cmd))) {
+		err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false,
+				      user_skb);
+		if (err)
+			goto out;
+	}
 
 	if (upcall_info->userdata)
 		__nla_put(user_skb, OVS_PACKET_ATTR_USERDATA,
@@ -1526,6 +1530,7 @@ static size_t ovs_dp_cmd_msg_size(void)
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
 	msgsize += nla_total_size(sizeof(u32) * nr_cpu_ids); /* OVS_DP_ATTR_PER_CPU_PIDS */
+	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_EXCLUDE_CMDS */
 
 	return msgsize;
 }
@@ -1574,6 +1579,10 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
+	if (nla_put_u32(skb, OVS_DP_ATTR_EXCLUDE_CMDS,
+			dp->upcall_exclude_cmds))
+		goto nla_put_failure;
+
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
@@ -1684,7 +1693,8 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 		if (user_features & ~(OVS_DP_F_VPORT_PIDS |
 				      OVS_DP_F_UNALIGNED |
 				      OVS_DP_F_TC_RECIRC_SHARING |
-				      OVS_DP_F_DISPATCH_UPCALL_PER_CPU))
+				      OVS_DP_F_DISPATCH_UPCALL_PER_CPU |
+				      OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY))
 			return -EOPNOTSUPP;
 
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
@@ -1705,6 +1715,14 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 
 	dp->user_features = user_features;
 
+	if (dp->user_features & OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY) {
+		if (!a[OVS_DP_ATTR_EXCLUDE_CMDS])
+			return -EINVAL;
+
+		dp->upcall_exclude_cmds =
+			nla_get_u32(a[OVS_DP_ATTR_EXCLUDE_CMDS]);
+	}
+
 	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
 	    a[OVS_DP_ATTR_PER_CPU_PIDS]) {
 		/* Upcall Netlink Port IDs have been updated */
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 0cd29971a907..3c951e25509e 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -101,6 +101,8 @@ struct datapath {
 
 	u32 max_headroom;
 
+	u32 upcall_exclude_cmds;
+
 	/* Switch meters. */
 	struct dp_meter_table meter_tbl;
 
-- 
2.34.3

