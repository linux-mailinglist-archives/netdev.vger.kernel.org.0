Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4365367CB
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354594AbiE0UAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352784AbiE0T77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 15:59:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3C411A053
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 12:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653681597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmY5K/X6EsSC1o+Vcg32RPhZ46OcxmDlz9gsMSy3eXM=;
        b=UuJ8XbOgQzP1PzmBlcOh7MafmjRMqU2WMtgk4373BsKdmnP6LYzaNVyV9GdmB+zrOzLwgl
        YsvBHos/SsajcJUaF7HQFNpufjdGKlIQRYSFyB6pTOjNRCJZPTi0QTDLTKac+XaAKPqBrf
        4c4B4mEpt3dP1pDTqgTztkPXfmbgeCg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-leEAx3U7ON64q3cGy0xWsA-1; Fri, 27 May 2022 15:59:53 -0400
X-MC-Unique: leEAx3U7ON64q3cGy0xWsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 324F83C0ED5D;
        Fri, 27 May 2022 19:59:53 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B3592166B26;
        Fri, 27 May 2022 19:59:52 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, j.vosburgh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com, vfalico@gmail.com
Subject: [RFC net-next v2] bonding: netlink error message support for options
Date:   Fri, 27 May 2022 15:59:46 -0400
Message-Id: <4819dd95dce52d5f68d43a77563580c631593dde.1653681408.git.jtoppins@redhat.com>
In-Reply-To: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
References: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for reporting errors via extack in both bond_newlink
and bond_changelink.

Instead of having to look in the kernel log for why an option was not
correct just report the error to the user via the extack variable.

What is currently reported today:
  ip link add bond0 type bond
  ip link set bond0 up
  ip link set bond0 type bond mode 4
 RTNETLINK answers: Device or resource busy

After this change:
  ip link add bond0 type bond
  ip link set bond0 up
  ip link set bond0 type bond mode 4
 Error: unable to set option because the bond is up.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     Removed the printf support and just added static messages for various
     error events.

 drivers/net/bonding/bond_netlink.c | 101 +++++++++++++++++++----------
 drivers/net/bonding/bond_options.c |  29 +++++++--
 include/net/bond_options.h         |   3 +-
 3 files changed, 92 insertions(+), 41 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..565ee0ac3e60 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -151,7 +151,8 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 		snprintf(queue_id_str, sizeof(queue_id_str), "%s:%u\n",
 			 slave_dev->name, queue_id);
 		bond_opt_initstr(&newval, queue_id_str);
-		err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval,
+				     data[IFLA_BOND_SLAVE_QUEUE_ID], extack);
 		if (err)
 			return err;
 	}
@@ -175,7 +176,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int mode = nla_get_u8(data[IFLA_BOND_MODE]);
 
 		bond_opt_initval(&newval, mode);
-		err = __bond_opt_set(bond, BOND_OPT_MODE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MODE, &newval,
+				     data[IFLA_BOND_MODE], extack);
 		if (err)
 			return err;
 	}
@@ -192,7 +194,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			active_slave = slave_dev->name;
 		}
 		bond_opt_initstr(&newval, active_slave);
-		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval,
+				     data[IFLA_BOND_ACTIVE_SLAVE], extack);
 		if (err)
 			return err;
 	}
@@ -200,7 +203,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		miimon = nla_get_u32(data[IFLA_BOND_MIIMON]);
 
 		bond_opt_initval(&newval, miimon);
-		err = __bond_opt_set(bond, BOND_OPT_MIIMON, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MIIMON, &newval,
+				     data[IFLA_BOND_MIIMON], extack);
 		if (err)
 			return err;
 	}
@@ -208,7 +212,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int updelay = nla_get_u32(data[IFLA_BOND_UPDELAY]);
 
 		bond_opt_initval(&newval, updelay);
-		err = __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval,
+				     data[IFLA_BOND_UPDELAY], extack);
 		if (err)
 			return err;
 	}
@@ -216,7 +221,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int downdelay = nla_get_u32(data[IFLA_BOND_DOWNDELAY]);
 
 		bond_opt_initval(&newval, downdelay);
-		err = __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval,
+				     data[IFLA_BOND_DOWNDELAY], extack);
 		if (err)
 			return err;
 	}
@@ -224,7 +230,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
 
 		bond_opt_initval(&newval, delay);
-		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval,
+				     data[IFLA_BOND_PEER_NOTIF_DELAY], extack);
 		if (err)
 			return err;
 	}
@@ -232,7 +239,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int use_carrier = nla_get_u8(data[IFLA_BOND_USE_CARRIER]);
 
 		bond_opt_initval(&newval, use_carrier);
-		err = __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval,
+				     data[IFLA_BOND_USE_CARRIER], extack);
 		if (err)
 			return err;
 	}
@@ -240,12 +248,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int arp_interval = nla_get_u32(data[IFLA_BOND_ARP_INTERVAL]);
 
 		if (arp_interval && miimon) {
-			netdev_err(bond->dev, "ARP monitoring cannot be used with MII monitoring\n");
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_BOND_ARP_INTERVAL],
+					    "ARP monitoring cannot be used with MII monitoring");
 			return -EINVAL;
 		}
 
 		bond_opt_initval(&newval, arp_interval);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval,
+				     data[IFLA_BOND_ARP_INTERVAL], extack);
 		if (err)
 			return err;
 	}
@@ -264,7 +274,9 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			bond_opt_initval(&newval, (__force u64)target);
 			err = __bond_opt_set(bond, BOND_OPT_ARP_TARGETS,
-					     &newval);
+					     &newval,
+					     data[IFLA_BOND_ARP_IP_TARGET],
+					     extack);
 			if (err)
 				break;
 			i++;
@@ -297,7 +309,9 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
 			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
-					     &newval);
+					     &newval,
+					     data[IFLA_BOND_NS_IP6_TARGET],
+					     extack);
 			if (err)
 				break;
 			i++;
@@ -312,12 +326,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int arp_validate = nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
 
 		if (arp_validate && miimon) {
-			netdev_err(bond->dev, "ARP validating cannot be used with MII monitoring\n");
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_BOND_ARP_INTERVAL],
+					    "ARP validating cannot be used with MII monitoring");
 			return -EINVAL;
 		}
 
 		bond_opt_initval(&newval, arp_validate);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval,
+				     data[IFLA_BOND_ARP_VALIDATE], extack);
 		if (err)
 			return err;
 	}
@@ -326,7 +342,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_ARP_ALL_TARGETS]);
 
 		bond_opt_initval(&newval, arp_all_targets);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval,
+				     data[IFLA_BOND_ARP_ALL_TARGETS], extack);
 		if (err)
 			return err;
 	}
@@ -340,7 +357,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			primary = dev->name;
 
 		bond_opt_initstr(&newval, primary);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval,
+				     data[IFLA_BOND_PRIMARY], extack);
 		if (err)
 			return err;
 	}
@@ -349,7 +367,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_PRIMARY_RESELECT]);
 
 		bond_opt_initval(&newval, primary_reselect);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval,
+				     data[IFLA_BOND_PRIMARY_RESELECT], extack);
 		if (err)
 			return err;
 	}
@@ -358,7 +377,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_FAIL_OVER_MAC]);
 
 		bond_opt_initval(&newval, fail_over_mac);
-		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval,
+				     data[IFLA_BOND_FAIL_OVER_MAC], extack);
 		if (err)
 			return err;
 	}
@@ -367,7 +387,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_XMIT_HASH_POLICY]);
 
 		bond_opt_initval(&newval, xmit_hash_policy);
-		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval,
+				     data[IFLA_BOND_XMIT_HASH_POLICY], extack);
 		if (err)
 			return err;
 	}
@@ -376,7 +397,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_RESEND_IGMP]);
 
 		bond_opt_initval(&newval, resend_igmp);
-		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval,
+				     data[IFLA_BOND_RESEND_IGMP], extack);
 		if (err)
 			return err;
 	}
@@ -385,7 +407,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_NUM_PEER_NOTIF]);
 
 		bond_opt_initval(&newval, num_peer_notif);
-		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval,
+				     data[IFLA_BOND_NUM_PEER_NOTIF], extack);
 		if (err)
 			return err;
 	}
@@ -394,7 +417,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_ALL_SLAVES_ACTIVE]);
 
 		bond_opt_initval(&newval, all_slaves_active);
-		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval,
+				     data[IFLA_BOND_ALL_SLAVES_ACTIVE], extack);
 		if (err)
 			return err;
 	}
@@ -403,7 +427,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_MIN_LINKS]);
 
 		bond_opt_initval(&newval, min_links);
-		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval,
+				     data[IFLA_BOND_MIN_LINKS], extack);
 		if (err)
 			return err;
 	}
@@ -412,7 +437,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_LP_INTERVAL]);
 
 		bond_opt_initval(&newval, lp_interval);
-		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval,
+				     data[IFLA_BOND_LP_INTERVAL], extack);
 		if (err)
 			return err;
 	}
@@ -421,7 +447,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_PACKETS_PER_SLAVE]);
 
 		bond_opt_initval(&newval, packets_per_slave);
-		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval,
+				     data[IFLA_BOND_PACKETS_PER_SLAVE], extack);
 		if (err)
 			return err;
 	}
@@ -430,7 +457,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int lacp_active = nla_get_u8(data[IFLA_BOND_AD_LACP_ACTIVE]);
 
 		bond_opt_initval(&newval, lacp_active);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval,
+				     data[IFLA_BOND_AD_LACP_ACTIVE], extack);
 		if (err)
 			return err;
 	}
@@ -440,7 +468,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_LACP_RATE]);
 
 		bond_opt_initval(&newval, lacp_rate);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval,
+				     data[IFLA_BOND_AD_LACP_RATE], extack);
 		if (err)
 			return err;
 	}
@@ -449,7 +478,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_SELECT]);
 
 		bond_opt_initval(&newval, ad_select);
-		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval,
+				     data[IFLA_BOND_AD_SELECT], extack);
 		if (err)
 			return err;
 	}
@@ -458,7 +488,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_ACTOR_SYS_PRIO]);
 
 		bond_opt_initval(&newval, actor_sys_prio);
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval,
+				     data[IFLA_BOND_AD_ACTOR_SYS_PRIO], extack);
 		if (err)
 			return err;
 	}
@@ -467,7 +498,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_USER_PORT_KEY]);
 
 		bond_opt_initval(&newval, port_key);
-		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval,
+				     data[IFLA_BOND_AD_USER_PORT_KEY], extack);
 		if (err)
 			return err;
 	}
@@ -477,7 +509,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 		bond_opt_initval(&newval,
 				 nla_get_u64(data[IFLA_BOND_AD_ACTOR_SYSTEM]));
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval,
+				     data[IFLA_BOND_AD_ACTOR_SYSTEM], extack);
 		if (err)
 			return err;
 	}
@@ -485,7 +518,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int dynamic_lb = nla_get_u8(data[IFLA_BOND_TLB_DYNAMIC_LB]);
 
 		bond_opt_initval(&newval, dynamic_lb);
-		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval,
+				     data[IFLA_BOND_TLB_DYNAMIC_LB], extack);
 		if (err)
 			return err;
 	}
@@ -494,7 +528,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
 
 		bond_opt_initval(&newval, missed_max);
-		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval,
+				     data[IFLA_BOND_MISSED_MAX], extack);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..36945a513770 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -636,27 +636,35 @@ static int bond_opt_check_deps(struct bonding *bond,
 }
 
 static void bond_opt_dep_print(struct bonding *bond,
-			       const struct bond_option *opt)
+			       const struct bond_option *opt,
+			       struct nlattr *bad_attr,
+			       struct netlink_ext_ack *extack)
 {
 	const struct bond_opt_value *modeval;
 	struct bond_params *params;
 
 	params = &bond->params;
 	modeval = bond_opt_get_val(BOND_OPT_MODE, params->mode);
-	if (test_bit(params->mode, &opt->unsuppmodes))
+	if (test_bit(params->mode, &opt->unsuppmodes)) {
 		netdev_err(bond->dev, "option %s: mode dependency failed, not supported in mode %s(%llu)\n",
 			   opt->name, modeval->string, modeval->value);
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+                                    "option not supported in mode");
+	}
 }
 
 static void bond_opt_error_interpret(struct bonding *bond,
 				     const struct bond_option *opt,
-				     int error, const struct bond_opt_value *val)
+				     int error, const struct bond_opt_value *val,
+				     struct nlattr *bad_attr,
+				     struct netlink_ext_ack *extack)
 {
 	const struct bond_opt_value *minval, *maxval;
 	char *p;
 
 	switch (error) {
 	case -EINVAL:
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr, "invalid option value");
 		if (val) {
 			if (val->string) {
 				/* sometimes RAWVAL opts may have new lines */
@@ -678,13 +686,17 @@ static void bond_opt_error_interpret(struct bonding *bond,
 			   opt->name, minval ? minval->value : 0, maxval->value);
 		break;
 	case -EACCES:
-		bond_opt_dep_print(bond, opt);
+		bond_opt_dep_print(bond, opt, bad_attr, extack);
 		break;
 	case -ENOTEMPTY:
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+                                    "unable to set option because the bond device has slaves");
 		netdev_err(bond->dev, "option %s: unable to set because the bond device has slaves\n",
 			   opt->name);
 		break;
 	case -EBUSY:
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+                                    "unable to set option because the bond is up");
 		netdev_err(bond->dev, "option %s: unable to set because the bond device is up\n",
 			   opt->name);
 		break;
@@ -695,6 +707,8 @@ static void bond_opt_error_interpret(struct bonding *bond,
 				*p = '\0';
 			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
 				   opt->name, val->string);
+			NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+					    "interface does not exist");
 		}
 		break;
 	default:
@@ -713,7 +727,8 @@ static void bond_opt_error_interpret(struct bonding *bond,
  * must be obtained before calling this function.
  */
 int __bond_opt_set(struct bonding *bond,
-		   unsigned int option, struct bond_opt_value *val)
+		   unsigned int option, struct bond_opt_value *val,
+		   struct nlattr *bad_attr, struct netlink_ext_ack *extack)
 {
 	const struct bond_opt_value *retval = NULL;
 	const struct bond_option *opt;
@@ -735,7 +750,7 @@ int __bond_opt_set(struct bonding *bond,
 	ret = opt->set(bond, retval);
 out:
 	if (ret)
-		bond_opt_error_interpret(bond, opt, ret, val);
+		bond_opt_error_interpret(bond, opt, ret, val, bad_attr, extack);
 
 	return ret;
 }
@@ -757,7 +772,7 @@ int __bond_opt_set_notify(struct bonding *bond,
 
 	ASSERT_RTNL();
 
-	ret = __bond_opt_set(bond, option, val);
+	ret = __bond_opt_set(bond, option, val, NULL, NULL);
 
 	if (!ret && (bond->dev->reg_state == NETREG_REGISTERED))
 		call_netdevice_notifiers(NETDEV_CHANGEINFODATA, bond->dev);
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 61b49063791c..1618b76f4903 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -107,7 +107,8 @@ struct bond_option {
 };
 
 int __bond_opt_set(struct bonding *bond, unsigned int option,
-		   struct bond_opt_value *val);
+		   struct bond_opt_value *val,
+		   struct nlattr *bad_attr, struct netlink_ext_ack *extack);
 int __bond_opt_set_notify(struct bonding *bond, unsigned int option,
 			  struct bond_opt_value *val);
 int bond_opt_tryset_rtnl(struct bonding *bond, unsigned int option, char *buf);
-- 
2.27.0

