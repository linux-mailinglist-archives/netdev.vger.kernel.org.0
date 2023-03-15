Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787EF6BB414
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCONNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCONNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2227986
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/39Zgpcewqyz1W0Q+jpZhIpjo/Ddjd7RXA2Mw0b+j2z5Fvo+WXXoT2fR+EfM8Z1o+ffpprJ1BkpB5egaezGTM0jqiZ2ALwR84fP7LtjqxMvoWs7FTKG0KTl13HWdBkVIewhEwJBxVBeH1WtfX2ma3Ex4JKM5gHW98s/VOU8aRsaq9Qt+3BAVAmHluVBuyuh7+PZhXr9Q6MU5jGkI0XEODOtmuE7dh2cdE3Lntvy+cYgmqhwKBsGHkn6S6PCcQtoQKUb9RSdtoroBjSVo4i6L+HKL5dqfWYQRY/vMlaxYuy/gpaTINTZGdl2oI+T4Iq7qGzLmD0idQT/WSsVhn0cVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hogRoRe32ZEXLLI8cZNnSdtBjQxQi3l5i28H5Rj8VhQ=;
 b=f2QUEb1f53B1Guqy4g2BT8e56MkGsQDXJ9UIrbf9JJ8XASUv8BoZxfP/Y90zvJVXpAafHmHnFPyDn1+IOGhLqDHxTwAbqTUflgt1br+W8S7LMnhLFUtLb+3s6vDbaCcC1KxjS6WoBl1R5ceWbyQlg6fMnleaM+r24/PywhpJpa9+Bn4lw1768tzaoU3jpeS1kER7tVhwYXxQS6AnJK4wLRrWmgOS7zzS7HY8UjzffgwRxvwHm1tOykmekp2R5RhROyqJ/ng+Q5wllGBlQHTCCspRoBmkMqLoHKy7jfGYXVpyyxvYiedAOF3z3+9xRvzCdsgup9mS5BVwuON10geZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hogRoRe32ZEXLLI8cZNnSdtBjQxQi3l5i28H5Rj8VhQ=;
 b=YFCa974kZZCR1pUUza8ysIOd+Rz/5TgECoskE08r2hOrDT9MnD6htkXbc+yIGsrweBGA8fBmrWk5hsgSmIGxbiLe3rYBMF3mzY/YoubRpnNqT3GQ5U4LpP+5UK1KMusxhTt7Hs6WbTkKMjGht5FGgPRD9ajP1AwN1RmmQzBGmsntd7U0j9ZUhIWptowkpaR22NHqLo5QzozR7uMFEi3141TF1HOk8vZCZLrfwKNHSvKD+Yv9dmSlk+2qns7M96kisr7klbfIKN1xrMQPz4Nv5SwO1HOjekhoyZLD+QQLMkqtO260vhdy8+wKYGJGOOoLK6pZ3AwzgZH9A1Wh6R1Ytw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:13:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/11] bridge: mcast: Implement MDB net device operations
Date:   Wed, 15 Mar 2023 15:11:46 +0200
Message-Id: <20230315131155.4071175-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0007.eurprd05.prod.outlook.com
 (2603:10a6:803:1::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: b8794b5a-824c-4df6-e306-08db2557040a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzImh9wpp0yZd/wZJ063IDzGMhSJ79AUmkV5Ki+bbjKwRQIQqm6Cs082hiYQAuFO6DilsWBpZa3oIrL5V9RLK955JnGuQrAD1isDpaWix2w1WLLMiHJQHSiEN7POnhiUyraDPbyGC+XfpAfPm/uBp7xhXN1HmEywLN4R/h3ewT8TJ6EMp6ey63PH3t0f7QT9b0nSf8fwuAXU+Hbl232BtGw1J+Sh9ijKJbNV10eEFvAwI070baeq0xwirIl/APmRPe/tGn1S3EN0YAS26PN+rRCHNLOZEEFw01f/2E0cKPIYBSCIPJJFGM/+7bVDnT9vBX+JhSSjcqzOXB6Oc8IcQCVe8HkQDEBIKYMx6FDUIM6sQmcyhKI633kXWuiI5WS2yynbFRbNlUH6MwxrUx5aPjuuCiLM9JPkgWeVsBBWu2KBIOChHs8k+prIwmn7n0Gn5M8lfSuGu22GqfA2qgXVWwLnX7IVOpzsEF0UAj7/EjLRKiqezeoOVygxLjNAuHTmjzJcEploP6olgI3Tgdqnsn3eFMe+9Izf7lkV1SfWXt7ajTDhfaJyNLsDczF33hvis+7wE4NdvZW3Rg5XyjQFNOURrlAn5GjQFwzA5Bd7O6PpROp0F8e5OBbl06QBNzv/uM1zCW2EhFe96uoDyrgyDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199018)(8936002)(5660300002)(41300700001)(2906002)(38100700002)(86362001)(36756003)(478600001)(8676002)(66476007)(66946007)(66556008)(6486002)(107886003)(6666004)(4326008)(316002)(6512007)(26005)(6506007)(186003)(2616005)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mhGM2R6RjXCa5gQOKPw8Tm9+NWvd1gT6IgSluDZUJK9DE4KB7luYxuarbyAc?=
 =?us-ascii?Q?YwMVEKqM8TAmWzxmDvadvMJb0UbwkBGGQUtXIGFgaIRvt1L1/OIz/1dFUQjj?=
 =?us-ascii?Q?p3PAKbw+vQJ+bn1D7oNMouXKPRG1djl0Qx+4jCmKL1383wbjS96B11TpTEB1?=
 =?us-ascii?Q?hrzLgs+B5OsbqJu3OoWcgwM9iGLedwd2HsQ/VtoCwJ6MEWDWE48G0ZXRZfPt?=
 =?us-ascii?Q?CHwU9s3MZTeVEPUN6v82iUMuxcBALhxCsEuF76QacICronz2d0O5pHg9uIfM?=
 =?us-ascii?Q?Yp7qvG4AwhDjXxGA/Qp1UtlnJQrVnpr1y7R6Hsjw7LQcD24Wb0G6MXVNNMxJ?=
 =?us-ascii?Q?FToGPitF2BNV7PjfZY/l8jWIV4vObdgX91RrmhV0SJZw5l++VqxwYrH4nXL4?=
 =?us-ascii?Q?C08e8yAgplYRqwb4kRrDYOITfz/6708XeKW80QBC0izDcKXInNaQWeHHAt4v?=
 =?us-ascii?Q?9H9naxmjJiXdsTJE/q0pMqpS5m1hlKj5ZMJF84/Wam+rgA46FUHGGNYwFK/P?=
 =?us-ascii?Q?UMadj9VUjQwqBT/m8Lpn4sw0emBH5zsADpvNwZ9LSCS18Cp8TYHiI+79nIIk?=
 =?us-ascii?Q?hJA5SQDfO21uL0tSQFLm3k74h4W+oeH3nvNGcCVwFkp+zwOWTOBgPHm5qNba?=
 =?us-ascii?Q?UVyFQD7/rtrvdSY2zkvN5O2BVf8ONv7RQUGBqVGeOEh3jxSrfrVdSznWPue+?=
 =?us-ascii?Q?adxKo3W8Wx79xUuHBC0iYWbGRGzirvw3+fLRUfNVsRntLWjI7m9kvEHRtv3u?=
 =?us-ascii?Q?Ya8dWdW5ywCtlUGAuSL/mBgo1FDH4sekrwMS9Qj2qJ1HjP74OGnMVDzPh74V?=
 =?us-ascii?Q?Rt/w15Cy9xoRgeMsdngaPuBpo5YR2UMXURUcC2EzO7I0Ruzj61flX3KXE3YM?=
 =?us-ascii?Q?DKiRtWGNwGU3WHxw0zJrsP19920AqZ3rl5pZ9QvGdyh430osFfnz/LXFs/32?=
 =?us-ascii?Q?SRSBw8oAQyQr8eKWPgmVKHIKOO/FPui7V45v73pkWyJ/SIRT799Cb7MqvyhX?=
 =?us-ascii?Q?uP9CHZY5H65U+51246nzDzO6dmwjsuvpK90ypjcnuf+Lf46+9jLNH+o1sEkd?=
 =?us-ascii?Q?H85gIOOLnoc4WzOqdwAIoP3sskP3etu1QeMftgpdHd0/ZvRIvZK4Fg+qXpWL?=
 =?us-ascii?Q?vhQkvU0/duS/JS6WkqqiDLprh/gOtga6sDeo8FKr7U7nFZQUzqE/j3yXhPMz?=
 =?us-ascii?Q?h4UtUckCvL7Q7BbmUOC4/5rynPpPtD87PkjUz+qGGo5MxL5qv6LAV3rkd1jp?=
 =?us-ascii?Q?uyKANqgOsMZ8xin452KHUHiLVZ4Wsk0r3PILCDxBlpwMjJ4BOJYCEQ1Cm8HP?=
 =?us-ascii?Q?EUqcXpjt4uwuqWqlpzN3KKJUr7s9GbW1ih1Ip6tRoazbvOII0Uj4q93G9mXe?=
 =?us-ascii?Q?suFpnPtNeZPZtPrFEHf8evggQpCguA74ijh1E9MiG+LuHXArxFz3NRfx1Vzq?=
 =?us-ascii?Q?r6hHP5nTeC8+G7EV5+zqVmOgSqDifAoBoA19Gr94QC9Yqc46anyedxUrmtQd?=
 =?us-ascii?Q?cWqSt70cB5cJgrFgeXQMVFHRWSp8lg2uDA2CoUTFrGz0paONoRP6YaXECSMe?=
 =?us-ascii?Q?uNMy5bpLeIWvc82fujShI5vseU/QpT3Co8l4eDj6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8794b5a-824c-4df6-e306-08db2557040a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:06.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXqMHnRfxcq0Hc7j9AqryBKa2H7jBoh9c/KFlI9UTCeQre/9gQJK11pZJ1ymQgT7c9/dxRre9IFqRKizwSq4gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the previously added MDB net device operations in the bridge
driver so that they could be invoked by core rtnetlink code in the next
patch.

The operations are identical to the existing br_mdb_{dump,add,del}
functions. The '_new' suffix will be removed in the next patch. The
functions are re-implemented in this patch to make the conversion in the
next patch easier to review.

Add dummy implementations when 'CONFIG_BRIDGE_IGMP_SNOOPING' is
disabled, so that an error will be returned to user space when it is
trying to add or delete an MDB entry. This is consistent with existing
behavior where the bridge driver does not even register rtnetlink
handlers for RTM_{NEW,DEL,GET}MDB messages when this Kconfig option is
disabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_device.c  |   3 +
 net/bridge/br_mdb.c     | 124 ++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |  25 ++++++++
 3 files changed, 152 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b82906fc999a..85fa4d73bb53 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -468,6 +468,9 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
+	.ndo_mdb_add		 = br_mdb_add_new,
+	.ndo_mdb_del		 = br_mdb_del_new,
+	.ndo_mdb_dump		 = br_mdb_dump_new,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 25c48d81a597..cb8270a5480b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -458,6 +458,39 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb)
+{
+	struct net_bridge *br = netdev_priv(dev);
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			cb->nlh->nlmsg_seq, RTM_GETMDB, sizeof(*bpm),
+			NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->ifindex = dev->ifindex;
+
+	rcu_read_lock();
+
+	err = br_mdb_fill_info(skb, cb, dev);
+	if (err)
+		goto out;
+	err = br_rports_fill_info(skb, &br->multicast_ctx);
+	if (err)
+		goto out;
+
+out:
+	rcu_read_unlock();
+	nlmsg_end(skb, nlh);
+	return err;
+}
+
 static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 				   struct net_device *dev,
 				   struct net_bridge_mdb_entry *mp,
@@ -1459,6 +1492,65 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err;
+
+	/* Configuration structure will be initialized here. */
+
+	err = -EINVAL;
+	/* host join errors which can happen before creating the group */
+	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
+		/* don't allow any flags for host-joined IP groups */
+		if (cfg.entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
+			goto out;
+		}
+		if (!br_multicast_is_star_g(&cfg.group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
+			goto out;
+		}
+	}
+
+	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		goto out;
+	}
+
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
+			goto out;
+		}
+		vg = nbp_vlan_group(cfg.p);
+	} else {
+		vg = br_vlan_group(cfg.br);
+	}
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * install mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_add(&cfg, extack);
+			if (err)
+				break;
+		}
+	} else {
+		err = __br_mdb_add(&cfg, extack);
+	}
+
+out:
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
@@ -1535,6 +1627,38 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err = 0;
+
+	/* Configuration structure will be initialized here. */
+
+	if (cfg.p)
+		vg = nbp_vlan_group(cfg.p);
+	else
+		vg = br_vlan_group(cfg.br);
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * delete mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_del(&cfg);
+		}
+	} else {
+		err = __br_mdb_del(&cfg);
+	}
+
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 void br_mdb_init(void)
 {
 	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMDB, NULL, br_mdb_dump, 0);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cef5f6ea850c..a72847c1dc9f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -981,6 +981,12 @@ void br_multicast_get_stats(const struct net_bridge *br,
 u32 br_multicast_ngroups_get(const struct net_bridge_mcast_port *pmctx);
 void br_multicast_ngroups_set_max(struct net_bridge_mcast_port *pmctx, u32 max);
 u32 br_multicast_ngroups_get_max(const struct net_bridge_mcast_port *pmctx);
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack);
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack);
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1374,6 +1380,25 @@ static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 	return false;
 }
 
+static inline int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[],
+				 u16 nlmsg_flags,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	return 0;
+}
+
 static inline void br_mdb_init(void)
 {
 }
-- 
2.37.3

