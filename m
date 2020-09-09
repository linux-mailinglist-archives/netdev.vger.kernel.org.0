Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB52262616
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIIEIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:08:36 -0400
Received: from mail-bn8nam11on2090.outbound.protection.outlook.com ([40.107.236.90]:15745
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgIIEIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:08:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTTfe01AjGxEV/61d+5FsJGIdiep/KRD/CzxjTpAPORLC5fSHbShrih5JUsVjdNYG7xx0IxX+a4rhmtfe5ZgmQv/JSNWpHoaHpqHoc2cm8HF6oB70zGOUuWGoM/uz09c53pXs9FsxtF/rJB4k1Rso6fv/A4eXM6LxXE/nzyS0zAIlplaloRtzTiukwDdAaObmD8o0RXvIXX3hfo7ZGCitGmx5BxNHu3iHr5n66NdM+9idTSlr5435O604e9C6cZ4YnpMLyykAOHqOCNkndfWfLqAozlTxsWEB3XlayRMdT8m3stBc/B926sGRXcYIOP7I308lyPygTT9IXjZdWD6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAZEOVX7g1a1ZcTGNjuqSfur8+qlUrOwMcXOjA5HnGU=;
 b=gOWspdFi6XUON4LuL7hpJaeA/IBvoyU3tq35WTsqC6/h0/Pn18nEhreVyimpCAnGN1EYRCn6qtH0aPKsMfAO1CKzgJBNH1s+JWEyi011/wxZtZxRXlYmGdi3iPTebAJMZox6xiZ0GuygiJ4Gz6HHi596IssN9r1/qQSvdSW13vz2W5WMs9KdBrmBPDuu/N6owCb/RBVSznqTmXB3AKzCzudd+RP/ctCW8vQdTMh6FDqED65y8s/0iMmLOXy0UrECbuIGaSBCqOEouLFsLzp0FVmO9Q0nmOhJcuGNTyO5vVBwys9AcXXlUYUimqTZLT0UwDf+Nk8cTVZB5BlI3KwzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAZEOVX7g1a1ZcTGNjuqSfur8+qlUrOwMcXOjA5HnGU=;
 b=RAJxkAUX8evBWTb2HiKwHPc5hQKcge2T+GaA7VPFdi+y8Un3TMShYPup/HHa2ZztgTp2OBpE7N6aJObwqGvcL0rHkXQGTP4X2sQMDCxfUczl/fkSDvsmieNhKjNwr/xEFJijResgRqRr5YxyEuINHKRdQp+j25Aq00Osm3ZDC9M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
Received: from BN6PR21MB0162.namprd21.prod.outlook.com (10.173.200.8) by
 BN7PR21MB1618.namprd21.prod.outlook.com (52.135.254.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.3; Wed, 9 Sep 2020 04:08:32 +0000
Received: from BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39]) by BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39%7]) with mapi id 15.20.3391.004; Wed, 9 Sep 2020
 04:08:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kuba@kernel.org, wei.liu@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com
Cc:     saeedm@mellanox.com, markb@mellanox.com,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net 2/2] hv_netvsc: Cache the current data path to avoid duplicate call and message
Date:   Tue,  8 Sep 2020 21:08:19 -0700
Message-Id: <20200909040819.19053-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:1:fe14:50ca:c8bf:219c]
X-ClientProxiedBy: MWHPR22CA0004.namprd22.prod.outlook.com
 (2603:10b6:300:ef::14) To BN6PR21MB0162.namprd21.prod.outlook.com
 (2603:10b6:404:94::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:1:fe14:50ca:c8bf:219c) by MWHPR22CA0004.namprd22.prod.outlook.com (2603:10b6:300:ef::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:08:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 152cd3a0-6106-4be2-57dd-08d8547603d1
X-MS-TrafficTypeDiagnostic: BN7PR21MB1618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR21MB16181CED55D5B6E170A2DD46BF260@BN7PR21MB1618.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:98;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCkMNrVdniXyfEvPEra3fQenZh7vb/FSTqx8/t5xpBntnY2N8iH6GwcQS4zxEq6BwDfXyx3aBLn4TttLNmLJ4YW3PPi52JE97kCt3acfs0M6EeLBCUEZei/R1Lh3vViXQEE8TKV0kyqR+PZrFXH/O0jrj/U54hQf6bklSdp2ePkuAx9KYhCd0F9BomCNFLJYSXx9lQQ5mnwrJpsRg4DxRdyswC+zBvZ30nk5mQfY6Sa+ahzXKyEXCQ5MRM30kopaFCdKKwSlIxrxS8oFLppVSdwtWV1xo03lgmAqpJO2XzVcpyHzt1X/8ucqB5fkxs6lH5CVZCysaGi0kK17u8EbWCimTTNjxW0DiQZTTnP3K1kQF26WP9GLJmb8rkM0byYnoCa9jLISzEXFJjRnjyiUiMoUaepDMMeninUKIox6bPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0162.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(36756003)(5660300002)(4326008)(66556008)(66476007)(66946007)(2906002)(7696005)(52116002)(6486002)(3450700001)(82950400001)(82960400001)(83380400001)(186003)(16526019)(15650500001)(107886003)(6666004)(2616005)(86362001)(8936002)(316002)(478600001)(10290500003)(8676002)(1076003)(6636002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1YWj4xwi6HuSoZ0zTK+tWbzQxiLpuFca1hNMH7szk6PQGy0u1JopROLv+0XnPNwlImcriCHSE5gQUJxf8wwtFMum6TFoPckS85ICTFsobhUIwXL5xTBTp8PTYmjItCdJ3a9m2BkZy0kVXRm7tzen6AsylKjYvrOMyIO/rB1uRMEbOzn7By0B8SylNpaCiz/Yku0FCL4eIgF01PFkIkeFJY+s9HWgstH8SDGiBJYTSZh5s9nCbyxdHakmIvD+YnydJG4gsUR1Svj/AOt7XBs5ZCYF+HO7oX+zU46jMjOUSC+BXv4Lp8rXBwMUA8orm6qjIJx0YmMvzyfsjyqluNQKsaHfvUyVGVDzd+HgkxwN2e9tLujfCCSXOqXoxHs+oXEtlQbl8A0ybCQpVCWMFrrSbClthDC3Ytw4qWF5dYYhmso+dd3inlxhkzAawe3LRREcwo6SYl4p81PAhX8DU7Z3EaTWTFjhYn2TDU3SlHsJEYwVRLqs/wU/iyuQ0VW1klHmd1suIOr+TdJH6P7DjuiqeOWNmilG6iNXbGhJFwp34oW0XkhDj68Zk6FbCQqHJC53JhSpjDki9EuEQT+dMysIy6H3dyTySMUK9x91qhmkuE0X/cdHsfXBwx9WAf+KzytB9IOE1VIq6pK2p/Q/ZYdbnF09e8Km2bDsbRsr/Ul8rf2NRQThXH3MeOkUHukLVZf8yUmyMw6PdkqiU0FivO5fkQ==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152cd3a0-6106-4be2-57dd-08d8547603d1
X-MS-Exchange-CrossTenant-AuthSource: BN6PR21MB0162.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:08:32.2249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5omDCj2tyUs0/D/Rd9VXhY5YEFmrtCLIOhgiZWsjM53C3ongAa2K53irVNDmebWE+BSatIGbds5CcfhjCjyWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR21MB1618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous change "hv_netvsc: Switch the data path at the right time
during hibernation" adds the call of netvsc_vf_changed() upon
NETDEV_CHANGE, so it's necessary to avoid the duplicate call and message
when the VF is brought UP or DOWN.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |  3 +++
 drivers/net/hyperv/netvsc_drv.c | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2181d4538ab7..ff33f27cdcd3 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -974,6 +974,9 @@ struct net_device_context {
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
 
+	/* Is the current data path through the VF NIC? */
+	bool  data_path_is_vf;
+
 	/* Used to temporarily save the config info across hibernation */
 	struct netvsc_device_info *saved_netvsc_dev_info;
 };
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 4a25886e2346..b7db3766f5b9 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2366,7 +2366,16 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	return NOTIFY_OK;
 }
 
-/* VF up/down change detected, schedule to change data path */
+/* Change the data path when VF UP/DOWN/CHANGE are detected.
+ *
+ * Typically a UP or DOWN event is followed by a CHANGE event, so
+ * net_device_ctx->data_path_is_vf is used to cache the current data path
+ * to avoid the duplicate call of netvsc_switch_datapath() and the duplicate
+ * message.
+ *
+ * During hibernation, if a VF NIC driver (e.g. mlx5) preserves the network
+ * interface, there is only the CHANGE event and no UP or DOWN event.
+ */
 static int netvsc_vf_changed(struct net_device *vf_netdev)
 {
 	struct net_device_context *net_device_ctx;
@@ -2383,6 +2392,10 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 	if (!netvsc_dev)
 		return NOTIFY_DONE;
 
+	if (net_device_ctx->data_path_is_vf == vf_is_up)
+		return NOTIFY_OK;
+	net_device_ctx->data_path_is_vf = vf_is_up;
+
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
 		    vf_is_up ? "to" : "from", vf_netdev->name);
@@ -2624,6 +2637,12 @@ static int netvsc_resume(struct hv_device *dev)
 	rtnl_lock();
 
 	net_device_ctx = netdev_priv(net);
+
+	/* Reset the data path to the netvsc NIC before re-opening the vmbus
+	 * channel. Later netvsc_netdev_event() will switch the data path to
+	 * the VF upon the UP or CHANGE event.
+	 */
+	net_device_ctx->data_path_is_vf = false;
 	device_info = net_device_ctx->saved_netvsc_dev_info;
 
 	ret = netvsc_attach(net, device_info);
-- 
2.19.1

