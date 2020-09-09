Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A986262612
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgIIEIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:08:19 -0400
Received: from mail-eopbgr750098.outbound.protection.outlook.com ([40.107.75.98]:2155
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgIIEIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:08:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OY4aHqteMUXh0uR4sI2nooc7r4qkLORFqsYKGjX3unZ9Fd6qtzWrBobKVbNZuZtCp7JX0VWqUSTmSHQ6fGlP/oJuk+0cIx4nHQcm6o4OnvkIsCqLT28Djhfun7s97XgIZeOSMkj0WnespoCB0i6ct8Ld/F043zxjgUqClkgzcXYJoe4NyXXV0LM30Glb7lTD+WE/uQqhZqSRoK+7ZMoVDvDGvI6a9lNDgfnoCBNgEoPyvXAITin0jWhYxtY7Zsu+S6TCz0RuiB3QqGoXJT8dgXcae2yvk61v4jaHzTwRfWfbCV04LolRb0fmYHBgfcGfM/RTTirC73ajbNRZbT/mfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPQvYCsrO060JXZuS50ZLOidghTMJVVVrYfxEOeTuP8=;
 b=bB8a4On30mR/CZCCQWczij5IUmChFVtatLrNhuASRkpwcXZ0DlpN+ZkrBiS6dznWHap95o1dgUpzpvtYJDMiENs5f0XYO8Die7rn3cJSinWU70WRDSITorwaOnchrkrSKGbmogzxALLMy24GqsrFgZgsYz01En5+efckHA3+8cpS+ELXtlAj2efbU87QveHg/IIocB+J0XUv0KavbDVyiNYmYSdJE2hR6ghRmIbgRe7Rgepy1eWxGzue8YOoqpVmPYtsa5ETN11J0mDR698cScay/3EV7JmfCYwe1cRFWc4TPomeP2q7+TDqLPfx+cRN9RfcLcTiMD1oL+pbcUeZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPQvYCsrO060JXZuS50ZLOidghTMJVVVrYfxEOeTuP8=;
 b=aFCb6jKZFEvNt4Gbsg2PlinF0MuN4XS/zMz+S30BYiMkakWrOPHf/DhxN2kOFML22Y0gt2gX9BlCFV84apj9IxhIvtdAdcpI4RA7w8W9D3wzE05WJCS+16FpObdIx8Fn2bgM0JqV5qj/7gsO7OVCCttAI/rMt404DcV8YGbz0R8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
Received: from BN6PR21MB0162.namprd21.prod.outlook.com (10.173.200.8) by
 BN7PR21MB1618.namprd21.prod.outlook.com (52.135.254.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.3; Wed, 9 Sep 2020 04:08:10 +0000
Received: from BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39]) by BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39%7]) with mapi id 15.20.3391.004; Wed, 9 Sep 2020
 04:08:10 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kuba@kernel.org, wei.liu@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com
Cc:     saeedm@mellanox.com, markb@mellanox.com,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net 1/2] hv_netvsc: Switch the data path at the right time during hibernation
Date:   Tue,  8 Sep 2020 21:07:32 -0700
Message-Id: <20200909040732.18993-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:7:fe0e:50ca:c8bf:219c]
X-ClientProxiedBy: CO2PR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:104:1::17) To BN6PR21MB0162.namprd21.prod.outlook.com
 (2603:10b6:404:94::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:7:fe0e:50ca:c8bf:219c) by CO2PR05CA0091.namprd05.prod.outlook.com (2603:10b6:104:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.8 via Frontend Transport; Wed, 9 Sep 2020 04:08:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2db76353-7dc6-49ee-d7f3-08d85475f697
X-MS-TrafficTypeDiagnostic: BN7PR21MB1618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR21MB1618FD22C6F26033C706E46ABF260@BN7PR21MB1618.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HE4rmVSQwcotRTV54HwBmLWO3ZrhikeR3h5xx/6R5Kn3L9tDMeCrIgty6Pht+SdCvQeGW1XH3vB9fiW0T9Q1Touwn7SJFF4CPiYs6CUjLYWtjqpPR9pigefmmKpsXzMLTA6dT9Bjdyn5eO/zYPAqOU0GW+7vHCUagGXJESFreUAo9NEea9IoZnTpb7+WwOu/kRCVsGSODEFFy0KI5ldBOd3N7LQPFi52L95ekMulh5RFWWVP/qL01JYN2GwcYO5pZEogPf/LtEJjaP1lG9COUAKsa7xwGxPNR6hc3/bg5uw3YjfpKXNcU4c9rmRIz/MCdAuBdt29uMDh5JEksK4ZhhRqvMHiYdYFGCNph480Gx1al+m14uzANblVNkv4FIKRhQADqjay6JvDDVszDD47XCsh9fzvzdJI5bs3ST3qQSo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0162.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(6666004)(2616005)(86362001)(8936002)(186003)(16526019)(83380400001)(107886003)(10290500003)(6636002)(8676002)(1076003)(316002)(478600001)(52116002)(66556008)(66476007)(66946007)(5660300002)(36756003)(4326008)(6486002)(82950400001)(82960400001)(3450700001)(7696005)(2906002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: g8Z95UpsGYrXMLaiUbnpGKUsQM6N1XF58/nJ+T3LnrPxdTOULT4/XRzfXgVH1PGV6Mri9Z5h/Nv61KNynyG3GHq0UQ7aOS/ZqbALhCcp3OMwU4i18oPIEt4XcNSncatZRsHnQMnsCPqPKOmHzWosrZ8Sl8eO59+Afbn1OrF/+v7/pYyaEkXPu32eyCUa17kFS0U2i8CKBurY+nICC6M1KT9HjwJn7uZg9CAipIuhvu8XMfJs4dinORuC0RmJwNgiiF3AU6jkaunX7/wek9cv8/qbI3pboMyftGgIDJOyM5rzCr52fOt4cFuvesynckx9tTOS6nIdFDFEM9QQV+GG603DWvGY9Nj1Qh+zhNd590lPaLvtwyteMjrIDrXJzVvd34gVhsZNqvY88ghZBgT211zHnFygeTA1N+qqjtBwwzJoEGyYzeFcr522oSO/mVSvqFjpeluZoIN1R5eVhw/gHAoztA2xfizG5vGP7SLVFX6O72sX5iqO65BDayPjFgzWfrQpZSs4HrP6SQBnUC3ttgAwB379unXPqemuEJnWG3oePb+H7cvR+NnkJwrSxQD7Vhz3AMaHQ5xuB3OTMWt8d/eJaLkB5IS9JPBn/1w2Cnl67WYUl4Nk9uavum41ypYN7Xmoai6WZuxcpPLRfsHQ57MhVzv2AKBE8YJ4ghaXRg1cs8phrt8RuWFYpN2T0rDFzIVqtcum6QuR2DAE5Q9nDg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db76353-7dc6-49ee-d7f3-08d85475f697
X-MS-Exchange-CrossTenant-AuthSource: BN6PR21MB0162.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:08:10.1786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AN50k459PyDZAGitfXR6P0ai3fE7O+tP0d6D28l3y17dsFdqI8AxyR1asye2jjzu+YtLzRjaLIZPyXN7Xlctmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR21MB1618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netvsc_resume() is called, the mlx5 VF NIC has not been resumed yet,
so in the future the host might sliently fail the call netvsc_vf_changed()
-> netvsc_switch_datapath() there, even if the call works now.

Call netvsc_vf_changed() in the NETDEV_CHANGE event handler: at that time
the mlx5 VF NIC has been resumed.

Fixes: 19162fd4063a ("hv_netvsc: Fix hibernation for mlx5 VF driver")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 81c5c70b616a..4a25886e2346 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2619,7 +2619,6 @@ static int netvsc_resume(struct hv_device *dev)
 	struct net_device *net = hv_get_drvdata(dev);
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info;
-	struct net_device *vf_netdev;
 	int ret;
 
 	rtnl_lock();
@@ -2632,15 +2631,6 @@ static int netvsc_resume(struct hv_device *dev)
 	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
-	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
-	 * hibernation, but here the data path is implicitly switched to the
-	 * netvsc NIC since the vmbus channel is closed and re-opened, so
-	 * netvsc_vf_changed() must be used to switch the data path to the VF.
-	 */
-	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
-	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
-		ret = -EINVAL;
-
 	rtnl_unlock();
 
 	return ret;
@@ -2701,6 +2691,7 @@ static int netvsc_netdev_event(struct notifier_block *this,
 		return netvsc_unregister_vf(event_dev);
 	case NETDEV_UP:
 	case NETDEV_DOWN:
+	case NETDEV_CHANGE:
 		return netvsc_vf_changed(event_dev);
 	default:
 		return NOTIFY_DONE;
-- 
2.19.1

