Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D403053E817
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbiFFP12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240758AbiFFP1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B572C273C
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654529237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wW/VcmnyuPmyTc0cB29IPmzOcWbwpXdiZClc5Wxs0yk=;
        b=MmZAAmPwf9IS0+60d97mN3JUyn1s+9Kk1fHQM7wLAtt+j3OTFGRr1hh8EShoGzTMBdk91R
        xWEryQCnNtgZzj7ieI5DWxsx5+rWTxBGocMmuTkls1k8TDAhE+Gcb6hrMcTH5DY6bbEOu7
        UGtRPk7lmLgr9LJs0KNXFjMKHcfg8cM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-DmnNlsPgPZegLPhndiOucA-1; Mon, 06 Jun 2022 11:27:14 -0400
X-MC-Unique: DmnNlsPgPZegLPhndiOucA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7C8E80159B;
        Mon,  6 Jun 2022 15:27:13 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 555F382882;
        Mon,  6 Jun 2022 15:27:13 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [net-next 1/2] bonding: netlink error message support for options
Date:   Mon,  6 Jun 2022 11:26:52 -0400
Message-Id: <ac422216e35732c59ef8ca543fb4b381655da2bf.1654528729.git.jtoppins@redhat.com>
In-Reply-To: <cover.1654528729.git.jtoppins@redhat.com>
References: <cover.1654528729.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
    Removed the printf support and just added static messages for various
    error events.

 drivers/net/bonding/bond_netlink.c | 101 +++++++++++++++++++----------
 drivers/net/bonding/bond_options.c |  29 +++++++--
 include/net/bond_options.h         |   3 +-
 3 files changed, 92 insertions(+), 41 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 6f404f9c34e3..5a6f44455b95 100644
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
@@ -292,7 +304,9 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
 			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
-					     &newval);
+					     &newval,
+					     data[IFLA_BOND_NS_IP6_TARGET],
+					     extack);
 			if (err)
 				break;
 			i++;
@@ -307,12 +321,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
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
@@ -321,7 +337,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_ARP_ALL_TARGETS]);
 
 		bond_opt_initval(&newval, arp_all_targets);
-		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval,
+				     data[IFLA_BOND_ARP_ALL_TARGETS], extack);
 		if (err)
 			return err;
 	}
@@ -335,7 +352,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			primary = dev->name;
 
 		bond_opt_initstr(&newval, primary);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval,
+				     data[IFLA_BOND_PRIMARY], extack);
 		if (err)
 			return err;
 	}
@@ -344,7 +362,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_PRIMARY_RESELECT]);
 
 		bond_opt_initval(&newval, primary_reselect);
-		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval,
+				     data[IFLA_BOND_PRIMARY_RESELECT], extack);
 		if (err)
 			return err;
 	}
@@ -353,7 +372,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_FAIL_OVER_MAC]);
 
 		bond_opt_initval(&newval, fail_over_mac);
-		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval,
+				     data[IFLA_BOND_FAIL_OVER_MAC], extack);
 		if (err)
 			return err;
 	}
@@ -362,7 +382,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_XMIT_HASH_POLICY]);
 
 		bond_opt_initval(&newval, xmit_hash_policy);
-		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval,
+				     data[IFLA_BOND_XMIT_HASH_POLICY], extack);
 		if (err)
 			return err;
 	}
@@ -371,7 +392,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_RESEND_IGMP]);
 
 		bond_opt_initval(&newval, resend_igmp);
-		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval,
+				     data[IFLA_BOND_RESEND_IGMP], extack);
 		if (err)
 			return err;
 	}
@@ -380,7 +402,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_NUM_PEER_NOTIF]);
 
 		bond_opt_initval(&newval, num_peer_notif);
-		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval,
+				     data[IFLA_BOND_NUM_PEER_NOTIF], extack);
 		if (err)
 			return err;
 	}
@@ -389,7 +412,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_ALL_SLAVES_ACTIVE]);
 
 		bond_opt_initval(&newval, all_slaves_active);
-		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval,
+				     data[IFLA_BOND_ALL_SLAVES_ACTIVE], extack);
 		if (err)
 			return err;
 	}
@@ -398,7 +422,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_MIN_LINKS]);
 
 		bond_opt_initval(&newval, min_links);
-		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval,
+				     data[IFLA_BOND_MIN_LINKS], extack);
 		if (err)
 			return err;
 	}
@@ -407,7 +432,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_LP_INTERVAL]);
 
 		bond_opt_initval(&newval, lp_interval);
-		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval,
+				     data[IFLA_BOND_LP_INTERVAL], extack);
 		if (err)
 			return err;
 	}
@@ -416,7 +442,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u32(data[IFLA_BOND_PACKETS_PER_SLAVE]);
 
 		bond_opt_initval(&newval, packets_per_slave);
-		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval,
+				     data[IFLA_BOND_PACKETS_PER_SLAVE], extack);
 		if (err)
 			return err;
 	}
@@ -425,7 +452,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int lacp_active = nla_get_u8(data[IFLA_BOND_AD_LACP_ACTIVE]);
 
 		bond_opt_initval(&newval, lacp_active);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval,
+				     data[IFLA_BOND_AD_LACP_ACTIVE], extack);
 		if (err)
 			return err;
 	}
@@ -435,7 +463,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_LACP_RATE]);
 
 		bond_opt_initval(&newval, lacp_rate);
-		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval,
+				     data[IFLA_BOND_AD_LACP_RATE], extack);
 		if (err)
 			return err;
 	}
@@ -444,7 +473,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u8(data[IFLA_BOND_AD_SELECT]);
 
 		bond_opt_initval(&newval, ad_select);
-		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval,
+				     data[IFLA_BOND_AD_SELECT], extack);
 		if (err)
 			return err;
 	}
@@ -453,7 +483,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_ACTOR_SYS_PRIO]);
 
 		bond_opt_initval(&newval, actor_sys_prio);
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval,
+				     data[IFLA_BOND_AD_ACTOR_SYS_PRIO], extack);
 		if (err)
 			return err;
 	}
@@ -462,7 +493,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			nla_get_u16(data[IFLA_BOND_AD_USER_PORT_KEY]);
 
 		bond_opt_initval(&newval, port_key);
-		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval,
+				     data[IFLA_BOND_AD_USER_PORT_KEY], extack);
 		if (err)
 			return err;
 	}
@@ -472,7 +504,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 		bond_opt_initval(&newval,
 				 nla_get_u64(data[IFLA_BOND_AD_ACTOR_SYSTEM]));
-		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval,
+				     data[IFLA_BOND_AD_ACTOR_SYSTEM], extack);
 		if (err)
 			return err;
 	}
@@ -480,7 +513,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int dynamic_lb = nla_get_u8(data[IFLA_BOND_TLB_DYNAMIC_LB]);
 
 		bond_opt_initval(&newval, dynamic_lb);
-		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval,
+				     data[IFLA_BOND_TLB_DYNAMIC_LB], extack);
 		if (err)
 			return err;
 	}
@@ -489,7 +523,8 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
 
 		bond_opt_initval(&newval, missed_max);
-		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
+		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval,
+				     data[IFLA_BOND_MISSED_MAX], extack);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 1f8323ad5282..5de5f6674f0e 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -632,27 +632,35 @@ static int bond_opt_check_deps(struct bonding *bond,
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
+				    "option not supported in mode");
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
@@ -674,13 +682,17 @@ static void bond_opt_error_interpret(struct bonding *bond,
 			   opt->name, minval ? minval->value : 0, maxval->value);
 		break;
 	case -EACCES:
-		bond_opt_dep_print(bond, opt);
+		bond_opt_dep_print(bond, opt, bad_attr, extack);
 		break;
 	case -ENOTEMPTY:
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+				    "unable to set option because the bond device has slaves");
 		netdev_err(bond->dev, "option %s: unable to set because the bond device has slaves\n",
 			   opt->name);
 		break;
 	case -EBUSY:
+		NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+				    "unable to set option because the bond is up");
 		netdev_err(bond->dev, "option %s: unable to set because the bond device is up\n",
 			   opt->name);
 		break;
@@ -691,6 +703,8 @@ static void bond_opt_error_interpret(struct bonding *bond,
 				*p = '\0';
 			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
 				   opt->name, val->string);
+			NL_SET_ERR_MSG_ATTR(extack, bad_attr,
+					    "interface does not exist");
 		}
 		break;
 	default:
@@ -709,7 +723,8 @@ static void bond_opt_error_interpret(struct bonding *bond,
  * must be obtained before calling this function.
  */
 int __bond_opt_set(struct bonding *bond,
-		   unsigned int option, struct bond_opt_value *val)
+		   unsigned int option, struct bond_opt_value *val,
+		   struct nlattr *bad_attr, struct netlink_ext_ack *extack)
 {
 	const struct bond_opt_value *retval = NULL;
 	const struct bond_option *opt;
@@ -731,7 +746,7 @@ int __bond_opt_set(struct bonding *bond,
 	ret = opt->set(bond, retval);
 out:
 	if (ret)
-		bond_opt_error_interpret(bond, opt, ret, val);
+		bond_opt_error_interpret(bond, opt, ret, val, bad_attr, extack);
 
 	return ret;
 }
@@ -753,7 +768,7 @@ int __bond_opt_set_notify(struct bonding *bond,
 
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

