Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6866DE3DF
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjDKS1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDKS1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:38 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6B8558B
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnCCeSDU/k7au+96Tyy9wgVre0AEg4Qbfg+NBHSx6aN8M7D8KpJvlR6FxYi0UlZFWsXUnllZcEnoypYQSLdnHbeZVKqDsTw91vOzJqcn4KVrITJIHRVkRiG+r4bLwusmQYL1iS7OYXMwPqX9sWTbUg8gsK2tiNdNyDoZlLNR/E7YJzbv4mFRf52JzU1Ieqjf5J+W2pHgL8FweuKuKnFJlc3JJpbC9j6oLZwbZy1zjIYs78m00CjLjcP+8UHkYMF9ma2BY1KZixAreWRtXNIxt0NaYJNjG0gOQdtxJ8MI20wfA9TJTX2YDoqZv/4uNG04JtLQKDnexe0vEigLSketdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8q3+8bWO0IKks9PnyqK41hvq8lRHxBSCwY+qeEw+zw=;
 b=eV7i0efSGtIrg01gXEpye1taqPMBtGMOsNqE2hgP9OSO2eOGtkiXk98TG8ap/8rKv2cuYu14scZ63Io9gtokL9UVXO5996CXJ8hxHh3LkkThbPA9j5F/91RoqVXxeMojTTrTaLOMMFP9lPqHkXgRjyTpd28W/UjEyjjunzMv58D5pkl2FP+TFxQgo3/MK71/dfm9A3IsVzvcN4WNuyHUY924sEFw29/ua3LeWSFgHRmMjgcrNjwR16OKn46vV65bEh3FiaM85QYCgub7qtItF441YAWIoTKuYrFd79OBGgpH2M6BjchW1YZTpmZ1YXip74+U4arVS6ttemLGJhQsHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8q3+8bWO0IKks9PnyqK41hvq8lRHxBSCwY+qeEw+zw=;
 b=1WeRiSzoA6c8GIbnbpF1kCA4CsAXShkvXOWTPh4qPmRPP0B+nnUJZp4ui3s4TS5alosYcI4DIythu5pz+esYvMa8r5ajdr1TrNy8MCJbUhaRIqKu/lyyInUwbLRJbROfAEuHjrGVoFuJQOiJC6dZNTe9aJCcA+FejE1mysaaym4=
Received: from DS7PR03CA0034.namprd03.prod.outlook.com (2603:10b6:5:3b5::9) by
 MN2PR12MB4224.namprd12.prod.outlook.com (2603:10b6:208:1dd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.38; Tue, 11 Apr 2023 18:27:31 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::41) by DS7PR03CA0034.outlook.office365.com
 (2603:10b6:5:3b5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.39 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 18:27:30 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:29 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:28 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting RSS contexts
Date:   Tue, 11 Apr 2023 19:26:14 +0100
Message-ID: <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|MN2PR12MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: 45fd83c6-9b1a-4f7a-57a2-08db3aba6902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/wIsCaa360tpwJ0YiZAxiA9TS1SZcFfaHmlaGF5Cm38puGBkGOSVxB40WtXExGIx2sH9QKJBuEk3IktFq7C+3RxKR/ZMvr1McXlABQdZqd8abd3SVCueQFt1HVjtwgef/pEWu9Erm01PAQTsaQW/3etGhScYu1pgPry2q+OQD0tXYMerVRFzCUZtQz6HlhwQuv0Js/YHSEyUg1dZVwHl85P9hNL2C8XQGWOL1V8pt/Kx0dOZJocRz6TlfA3toq8JzJjrr2i+gfOPoaC0Pv7aPh26hVKv0sMAX1/Y+BH3DBA27SeFADpUOV6ZlWoCQkxpl6ccUYjZj8pnR9n7NCPth7bNZlbOtVZLnZc+mMF6prN47jdOW6PNNKoffcRilVGpU+uQJ1fZ2MWG4A79qCRXDLrrO5h8Jil6bLlMmSnEd++cj3RKN0J9cFZPU5k+KkEchvsH99GqKBTiHeCvYfGWEIM/fWAgGfVotxvj2DCNkfw3qOqj19HKluceTMqvcmKqxIIdn/bTkP2m/nli++qfbZfKqn4nTSh9Vh4KALL6JHAxh4i83tsMIVfg8BuaRkPyEqczRNtNn6wkGfJcpQfA1T8t2zGbEVQusiiKJTacpFl6mrNhMVxTshH5P9Lcg+CRScwvJWW5knkGF7NmKaowY+tDD7MLRz+OcEnQ9Q+ecO4sWnYtR3nhgH8ZviZyYEHoS5W55OPoky6vvJh88zzRfOKzzqI54Y/5asrGaDvFsw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(4326008)(55446002)(70206006)(70586007)(86362001)(26005)(316002)(110136005)(9686003)(186003)(40460700003)(36756003)(6666004)(54906003)(40480700001)(478600001)(36860700001)(8676002)(8936002)(41300700001)(356005)(81166007)(2876002)(5660300002)(47076005)(2906002)(83380400001)(82310400005)(426003)(336012)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:30.2208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fd83c6-9b1a-4f7a-57a2-08db3aba6902
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4224
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

While this is not needed to serialise the ethtool entry points (which
 are all under RTNL), drivers may have cause to asynchronously access
 dev->ethtool->rss_ctx; taking dev->ethtool->rss_lock allows them to
 do this safely without needing to take the RTNL.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 include/linux/ethtool.h | 3 +++
 net/core/dev.c          | 5 +++++
 net/ethtool/ioctl.c     | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 724da9234cf1..e8e88d5900d3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -1026,11 +1026,14 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
  * struct ethtool_netdev_state - per-netdevice state for ethtool features
  * @rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
  * @rss_ctx:		IDR storing custom RSS context state
+ * @rss_lock:		Protects entries in @rss_ctx.  May be taken from
+ *			within RTNL.
  * @wol_enabled:	Wake-on-LAN is enabled
  */
 struct ethtool_netdev_state {
 	u32			rss_ctx_max_id;
 	struct idr		rss_ctx;
+	struct mutex		rss_lock;
 	unsigned		wol_enabled:1;
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 44668386f376..60c844b372e3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9987,6 +9987,7 @@ int register_netdevice(struct net_device *dev)
 	idr_init_base(&dev->ethtool->rss_ctx, 1);
 
 	spin_lock_init(&dev->addr_list_lock);
+	mutex_init(&dev->ethtool->rss_lock);
 	netdev_set_addr_lockdep_class(dev);
 
 	ret = dev_get_valid_name(net, dev, dev->name);
@@ -10792,6 +10793,7 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 	if (!dev->ethtool_ops->create_rxfh_context &&
 	    !dev->ethtool_ops->set_rxfh_context)
 		return;
+	mutex_lock(&dev->ethtool->rss_lock);
 	idr_for_each_entry(&dev->ethtool->rss_ctx, ctx, context) {
 		u32 *indir = ethtool_rxfh_context_indir(ctx);
 		u8 *key = ethtool_rxfh_context_key(ctx);
@@ -10806,6 +10808,7 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 							   &context, true);
 		kfree(ctx);
 	}
+	mutex_unlock(&dev->ethtool->rss_lock);
 }
 
 /**
@@ -10919,6 +10922,8 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
+		mutex_destroy(&dev->ethtool->rss_lock);
+
 		if (skb)
 			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, portid, nlh);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index abd1cf50e681..8b2e90ba03a1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1257,6 +1257,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	u8 *rss_config;
 	u32 rss_cfg_offset = offsetof(struct ethtool_rxfh, rss_config[0]);
 	bool create = false, delete = false;
+	bool locked = false; /* dev->ethtool->rss_lock taken */
 
 	if (!ops->get_rxnfc || !ops->set_rxfh)
 		return -EOPNOTSUPP;
@@ -1334,6 +1335,10 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
+	if (rxfh.rss_context) {
+		mutex_lock(&dev->ethtool->rss_lock);
+		locked = true;
+	}
 	if (create) {
 		if (delete) {
 			ret = -EINVAL;
@@ -1453,6 +1458,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	}
 
 out:
+	if (locked)
+		mutex_unlock(&dev->ethtool->rss_lock);
 	kfree(rss_config);
 	return ret;
 }
