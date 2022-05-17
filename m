Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C0152ACC1
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352934AbiEQUbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiEQUbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D3DF527E9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652819489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1fCHWMKtSaq0LAO2nF/TgdmuRUOtifbIUs682Prxj8k=;
        b=ILrhveDmYBLKScvZsZfoRI9jB8VIJ/PGcLbCrYGJQb2rzs/xqMq6zOax6+3W7eDK5rD1lL
        rblOnr49WChITX5b02yFw5H0YubiCBfi3hcEfUeVp3o1RK5WAUbg2PLaA+xaignqiQuAlK
        UVtf7o2WU+HuPGFzjY6ekrMFzUQg3Cg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-DIWlciprM26s8idb4aZ0Dw-1; Tue, 17 May 2022 16:31:25 -0400
X-MC-Unique: DIWlciprM26s8idb4aZ0Dw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB4891C068CA;
        Tue, 17 May 2022 20:31:24 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DE8F492C3B;
        Tue, 17 May 2022 20:31:24 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC net-next] bonding: netlink error message support for options
Date:   Tue, 17 May 2022 16:31:19 -0400
Message-Id: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 Error: option mode: unable to set because the bond device is up.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    This is an RFC because the current NL_SET_ERR_MSG() macros do not support
    printf like semantics so I rolled my own buffer setting in __bond_opt_set().
    The issue is I could not quite figure out the life-cycle of the buffer, if
    rtnl lock is held until after the text buffer is copied into the packet
    then we are ok, otherwise, some other type of buffer management scheme will
    be needed as this could result in corrupted error messages when modifying
    multiple bonds.

 drivers/net/bonding/bond_netlink.c | 87 ++++++++++++++++++------------
 drivers/net/bonding/bond_options.c | 62 +++++++++++++--------
 include/net/bond_options.h         |  2 +-
 3 files changed, 96 insertions(+), 55 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..418a4f3d00a3 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -151,7 +151,7 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 		snprintf(queue_id_str, sizeof(queue_id_str), "%s:%u\n",
 			 slave_dev->name, queue_id);
 		bond_opt_initstr(&newval, queue_id_str);
-		err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -175,7 +175,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int mode = nla_get_u8(data[IFLA_BOND_MODE]);
 
 		bond_opt_initval(&newval, mode);
-		err = __bond_opt_set(bond, BOND_OPT_MODE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MODE, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -192,7 +192,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			active_slave = slave_dev->name;
 		}
 		bond_opt_initstr(&newval, active_slave);
-		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -200,7 +201,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		miimon = nla_get_u32(data[IFLA_BOND_MIIMON]);
 
 		bond_opt_initval(&newval, miimon);
-		err = __bond_opt_set(bond, BOND_OPT_MIIMON, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MIIMON, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -208,7 +209,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int updelay = nla_get_u32(data[IFLA_BOND_UPDELAY]);
 
 		bond_opt_initval(&newval, updelay);
-		err = __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -216,7 +217,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int downdelay = nla_get_u32(data[IFLA_BOND_DOWNDELAY]);
 
 		bond_opt_initval(&newval, downdelay);
-		err = __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -224,7 +225,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
 
 		bond_opt_initval(&newval, delay);
-		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -232,7 +234,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int use_carrier = nla_get_u8(data[IFLA_BOND_USE_CARRIER]);
 
 		bond_opt_initval(&newval, use_carrier);
-		err = __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -240,12 +243,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int arp_interval = nla_get_u32(data[IFLA_BOND_ARP_INTERVAL]);
 
 		if (arp_interval && miimon) {
-			netdev_err(bond->dev, "ARP monitoring cannot be used with MII monitoring\n");
+			NL_SET_ERR_MSG(extack,
+				       "ARP monitoring cannot be used with MII monitoring");
 			return -EINVAL;
 		}
 
 		bond_opt_initval(&newval, arp_interval);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -264,7 +269,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			bond_opt_initval(&newval, (__force u64)target);
 			err = __bond_opt_set(bond, BOND_OPT_ARP_TARGETS,
-					     &newval);
+					     &newval, extack);
 			if (err)
 				break;
 			i++;
@@ -297,7 +302,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
 			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
-					     &newval);
+					     &newval, extack);
 			if (err)
 				break;
 			i++;
@@ -312,12 +317,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int arp_validate = nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
 
 		if (arp_validate && miimon) {
-			netdev_err(bond->dev, "ARP validating cannot be used with MII monitoring\n");
+			NL_SET_ERR_MSG(extack,
+				       "ARP validating cannot be used with MII monitoring");
 			return -EINVAL;
 		}
 
 		bond_opt_initval(&newval, arp_validate);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -326,7 +333,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_ARP_ALL_TARGETS]);
 
 		bond_opt_initval(&newval, arp_all_targets);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -340,7 +348,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			primary = dev->name;
 
 		bond_opt_initstr(&newval, primary);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -349,7 +357,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_PRIMARY_RESELECT]);
 
 		bond_opt_initval(&newval, primary_reselect);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -358,7 +367,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_FAIL_OVER_MAC]);
 
 		bond_opt_initval(&newval, fail_over_mac);
-		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -367,7 +377,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_XMIT_HASH_POLICY]);
 
 		bond_opt_initval(&newval, xmit_hash_policy);
-		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -376,7 +386,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_RESEND_IGMP]);
 
 		bond_opt_initval(&newval, resend_igmp);
-		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -385,7 +396,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_NUM_PEER_NOTIF]);
 
 		bond_opt_initval(&newval, num_peer_notif);
-		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -394,7 +406,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_ALL_SLAVES_ACTIVE]);
 
 		bond_opt_initval(&newval, all_slaves_active);
-		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -403,7 +416,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_MIN_LINKS]);
 
 		bond_opt_initval(&newval, min_links);
-		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -412,7 +425,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_LP_INTERVAL]);
 
 		bond_opt_initval(&newval, lp_interval);
-		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -421,7 +435,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_PACKETS_PER_SLAVE]);
 
 		bond_opt_initval(&newval, packets_per_slave);
-		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -430,7 +445,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int lacp_active = nla_get_u8(data[IFLA_BOND_AD_LACP_ACTIVE]);
 
 		bond_opt_initval(&newval, lacp_active);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -440,7 +456,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_LACP_RATE]);
 
 		bond_opt_initval(&newval, lacp_rate);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -449,7 +465,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_SELECT]);
 
 		bond_opt_initval(&newval, ad_select);
-		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval, extack);
 		if (err)
 			return err;
 	}
@@ -458,7 +474,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_ACTOR_SYS_PRIO]);
 
 		bond_opt_initval(&newval, actor_sys_prio);
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -467,7 +484,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_USER_PORT_KEY]);
 
 		bond_opt_initval(&newval, port_key);
-		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -477,7 +495,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 		bond_opt_initval(&newval,
 				 nla_get_u64(data[IFLA_BOND_AD_ACTOR_SYSTEM]));
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -485,7 +504,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int dynamic_lb = nla_get_u8(data[IFLA_BOND_TLB_DYNAMIC_LB]);
 
 		bond_opt_initval(&newval, dynamic_lb);
-		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
@@ -494,7 +514,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
 
 		bond_opt_initval(&newval, missed_max);
-		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval,
+				     extack);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..4a95503384a3 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -636,7 +636,8 @@ static int bond_opt_check_deps(struct bonding *bond,
 }
 
 static void bond_opt_dep_print(struct bonding *bond,
-			       const struct bond_option *opt)
+			       const struct bond_option *opt,
+			       char *buf, size_t bufsize)
 {
 	const struct bond_opt_value *modeval;
 	struct bond_params *params;
@@ -644,16 +645,18 @@ static void bond_opt_dep_print(struct bonding *bond,
 	params = &bond->params;
 	modeval = bond_opt_get_val(BOND_OPT_MODE, params->mode);
 	if (test_bit(params->mode, &opt->unsuppmodes))
-		netdev_err(bond->dev, "option %s: mode dependency failed, not supported in mode %s(%llu)\n",
-			   opt->name, modeval->string, modeval->value);
+		scnprintf(buf, bufsize, "option %s: mode dependency failed, not supported in mode %s(%llu)\n",
+			  opt->name, modeval->string, modeval->value);
 }
 
 static void bond_opt_error_interpret(struct bonding *bond,
 				     const struct bond_option *opt,
-				     int error, const struct bond_opt_value *val)
+				     int error, const struct bond_opt_value *val,
+				     char *buf, size_t bufsize)
 {
 	const struct bond_opt_value *minval, *maxval;
 	char *p;
+	int i = 0;
 
 	switch (error) {
 	case -EINVAL:
@@ -663,38 +666,45 @@ static void bond_opt_error_interpret(struct bonding *bond,
 				p = strchr(val->string, '\n');
 				if (p)
 					*p = '\0';
-				netdev_err(bond->dev, "option %s: invalid value (%s)\n",
-					   opt->name, val->string);
+				i = scnprintf(buf, bufsize,
+					      "option %s: invalid value (%s)",
+					      opt->name, val->string);
 			} else {
-				netdev_err(bond->dev, "option %s: invalid value (%llu)\n",
-					   opt->name, val->value);
+				i = scnprintf(buf, bufsize,
+					      "option %s: invalid value (%llu)",
+					      opt->name, val->value);
 			}
 		}
 		minval = bond_opt_get_flags(opt, BOND_VALFLAG_MIN);
 		maxval = bond_opt_get_flags(opt, BOND_VALFLAG_MAX);
 		if (!maxval)
 			break;
-		netdev_err(bond->dev, "option %s: allowed values %llu - %llu\n",
-			   opt->name, minval ? minval->value : 0, maxval->value);
+		if (i) {
+			// index buf to overwirte '\n' from above
+			buf = &buf[i];
+			bufsize -= i;
+		}
+		scnprintf(buf, bufsize, " allowed values %llu - %llu",
+			  minval ? minval->value : 0, maxval->value);
 		break;
 	case -EACCES:
-		bond_opt_dep_print(bond, opt);
+		bond_opt_dep_print(bond, opt, buf, bufsize);
 		break;
 	case -ENOTEMPTY:
-		netdev_err(bond->dev, "option %s: unable to set because the bond device has slaves\n",
-			   opt->name);
+		scnprintf(buf, bufsize, "option %s: unable to set because the bond device has slaves",
+			  opt->name);
 		break;
 	case -EBUSY:
-		netdev_err(bond->dev, "option %s: unable to set because the bond device is up\n",
-			   opt->name);
+		scnprintf(buf, bufsize, "option %s: unable to set because the bond device is up",
+			  opt->name);
 		break;
 	case -ENODEV:
 		if (val && val->string) {
 			p = strchr(val->string, '\n');
 			if (p)
 				*p = '\0';
-			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
-				   opt->name, val->string);
+			scnprintf(buf, bufsize, "option %s: interface %s does not exist!",
+				  opt->name, val->string);
 		}
 		break;
 	default:
@@ -713,7 +723,8 @@ static void bond_opt_error_interpret(struct bonding *bond,
  * must be obtained before calling this function.
  */
 int __bond_opt_set(struct bonding *bond,
-		   unsigned int option, struct bond_opt_value *val)
+		   unsigned int option, struct bond_opt_value *val,
+		   struct netlink_ext_ack *extack)
 {
 	const struct bond_opt_value *retval = NULL;
 	const struct bond_option *opt;
@@ -734,8 +745,17 @@ int __bond_opt_set(struct bonding *bond,
 	}
 	ret = opt->set(bond, retval);
 out:
-	if (ret)
-		bond_opt_error_interpret(bond, opt, ret, val);
+	if (ret) {
+		static char buf[120];
+		buf[0] = '\0';
+		bond_opt_error_interpret(bond, opt, ret, val, buf, sizeof(buf));
+		if (buf[0] != '\0') {
+			if (extack)
+				extack->_msg = buf;
+			else
+				netdev_err(bond->dev, "Error: %s\n", buf);
+		}
+	}
 
 	return ret;
 }
@@ -757,7 +777,7 @@ int __bond_opt_set_notify(struct bonding *bond,
 
 	ASSERT_RTNL();
 
-	ret = __bond_opt_set(bond, option, val);
+	ret = __bond_opt_set(bond, option, val, NULL);
 
 	if (!ret && (bond->dev->reg_state == NETREG_REGISTERED))
 		call_netdevice_notifiers(NETDEV_CHANGEINFODATA, bond->dev);
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 61b49063791c..ae38557adc25 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -107,7 +107,7 @@ struct bond_option {
 };
 
 int __bond_opt_set(struct bonding *bond, unsigned int option,
-		   struct bond_opt_value *val);
+		   struct bond_opt_value *val, struct netlink_ext_ack *extack);
 int __bond_opt_set_notify(struct bonding *bond, unsigned int option,
 			  struct bond_opt_value *val);
 int bond_opt_tryset_rtnl(struct bonding *bond, unsigned int option, char *buf);
-- 
2.27.0

