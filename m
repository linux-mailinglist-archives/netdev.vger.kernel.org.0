Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77FB168388
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgBUQdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:33:14 -0500
Received: from mail-bn8nam12on2136.outbound.protection.outlook.com ([40.107.237.136]:37251
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbgBUQdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 11:33:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVJvMkkT3sDPfnWefX28Wu5Xr6oFr1tr4D+TQiXnNRGCLS4vHZr3hYtDF5YPe3aUpNmx4yQ7A5X1mcojZgOLq7fI0DgOooLa0WaqrDAGteoXag8Z3r5ttGX0dRY1+TIMWdCMTWKDunSZUgdRDsFxhkZDpFddFdC1Hj/UWmMtSH16xnFuIneS+lcfVA+sX+bnvY+oTX/uCft1zxIF22HcQ6XxTIcb3V7qL8qhfI96Ts5t1/auSx9pBATXaOz30WBvJwt1R3NaSHP30TYmud0Nf1zkzGxsuvKKeLPjKzUonOChuAvG0K2W6Gs2mUetvkpVTHX7+f8TFBAkoKL9UjNoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91W/YNxy7KdLwBwjVKKOhcMkqnYvOALOdWuHUTPZPpA=;
 b=dKJAJfMOGaHgeFq7HzGBRjSAf3tiQR61qvo0H7Oqz1Pu0H1suwQTi9xU4p4dt6WoQemyaOe65heH1sbX3tfqkECDPI0RsVrLg1FxQdEBiDLOLWgLVKzntuHaf0o8iGMSZoxg+1CHU8nfGa7hWKywsUO9bdjIYt/DtxJMa1Gi/8SpKo8pvX/OqiO+YP+ZsYin4hLz9c/sKugS+sZjoJd6oIm5m6g65WTaYlP7iDtqDBVOqwdBI9qp6GyOTs9/SLrFNqHBO+wFpufbOwZSrD2oRcoc2RUuat6xKmHgxK+oKggCkEjoFfQCQvIQQsNUUoivm9MJ9trVI6StM3NkViczJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91W/YNxy7KdLwBwjVKKOhcMkqnYvOALOdWuHUTPZPpA=;
 b=DnF8UDKPeo+p9Ebduh2/wJOEcJ2sV6aEcbDlOyUIa4Uix7JAfYIg5lYUf7HxIJnaSh9ua5dez3U45KAsRxqPnbVNZ51uSFW+H0zo05zry9WQPd3mJW8I2eynMlWg1zAbUwbZzaaczn/KUstSCFgWQNHBMg+FSAx3+/a3ytR1rZs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1079.namprd21.prod.outlook.com (52.132.130.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.4; Fri, 21 Feb 2020 16:33:10 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2750.000; Fri, 21 Feb 2020
 16:33:10 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [net PATCH] hv_netvsc: Fix unwanted wakeup in netvsc_attach()
Date:   Fri, 21 Feb 2020 08:32:18 -0800
Message-Id: <1582302738-24352-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0131.namprd04.prod.outlook.com
 (2603:10b6:104:7::33) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0131.namprd04.prod.outlook.com (2603:10b6:104:7::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 16:33:07 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8f96a27c-695a-4cf4-e5e4-08d7b6ebbb7c
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1079:|DM5PR2101MB1079:|DM5PR2101MB1079:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB1079190B2A4D81E73B5EAA1FAC120@DM5PR2101MB1079.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(199004)(189003)(8936002)(6666004)(186003)(6512007)(26005)(16526019)(6506007)(7846003)(2906002)(6486002)(66476007)(316002)(66556008)(956004)(36756003)(66946007)(2616005)(8676002)(478600001)(10290500003)(52116002)(5660300002)(81166006)(81156014)(4326008)(26123001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1079;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9a8jqrNaFOo0K0wgFuQGLlbXlot2Ae7pVPF6q2BoNM9IvRrpw3UTN4VOawHP+1mODQcrUv82eNkbDfsKkne5iwaJupZAhdexgoFhbGdm0PKzJ3sPKKLMcZzc/G1R7A7aYDYZ4+yvTzDzXidQakIF2M6x1EI8Iysw4ZY5gAtsI/v0AdrMqadn6MRerh7zdifk+ZRrgL1wAvLjgJW2ACKei9r6a6KiGlv+XQFWqMhxXClD0pGlTY3Is+uPdhj/oUcoKhzYq4jOWOoazkw04DBvtvfwbPA1O7Nizk1EPseT+mbf59k+Ce2xmXGC/sKWzqxCRUpyCMArKBEk0FQYP0z5sdEr1EuIt5sVGUbI4nxVGEwxbTqwGFODDrF6rYGxnoMD+omS5EUCeHJGzZlT3gWQwev7CMiqDVxKyEfnA2Y7zEClr9E4j7DsMyYb4ZXKI9g7WfEPKiARlVYVCCz0mm7P10eG942BC8S9O5QgC66/csA+VQwIX+fAeECQL3zRFhJ
X-MS-Exchange-AntiSpam-MessageData: SimskdsE69HmdMpnAeimShRE54ALwmn/kyuELKqm2vAAGJFFxQndwVORvlcdZFDs93Y8u2gPWmy4UkNe0JYbRFKCz2+s0hg/NK8WAbidcdtn82CVWTVOIXpk2HsS1sHoFvpG1CdrGQcBU4oc1ZTifg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f96a27c-695a-4cf4-e5e4-08d7b6ebbb7c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 16:33:10.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBNzm+XtUCFJBUB11Ca4fYMSW8uCoIi0strNmboMi1dSqf8jxvDu6b2tu22fI2DIISHhFfip/LO6nMf55h6rZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netvsc_attach() is called by operations like changing MTU, etc.,
an extra wakeup may happen while netvsc_attach() calling
rndis_filter_device_add() which sends rndis messages when queue is
stopped in netvsc_detach(). The completion message will wake up queue 0.

We can reproduce the issue by changing MTU etc., then the wake_queue
counter from "ethtool -S" will increase beyond stop_queue counter:
     stop_queue: 0
     wake_queue: 1
The issue causes queue wake up, and counter increment, no other ill
effects in current code. So we didn't see any network problem for now.

To fix this, initialize tx_disable to true, and set it to false when
the NIC is ready to be attached or registered.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/net/hyperv/netvsc.c     | 2 +-
 drivers/net/hyperv/netvsc_drv.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index ae3f308..1b320bc 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -99,7 +99,7 @@ static struct netvsc_device *alloc_net_device(void)
 
 	init_waitqueue_head(&net_device->wait_drain);
 	net_device->destroy = false;
-	net_device->tx_disable = false;
+	net_device->tx_disable = true;
 
 	net_device->max_pkt = RNDIS_MAX_PKT_DEFAULT;
 	net_device->pkt_align = RNDIS_PKT_ALIGN_DEFAULT;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 65e12cb..2c0a24c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1068,6 +1068,7 @@ static int netvsc_attach(struct net_device *ndev,
 	}
 
 	/* In any case device is now ready */
+	nvdev->tx_disable = false;
 	netif_device_attach(ndev);
 
 	/* Note: enable and attach happen when sub-channels setup */
@@ -2476,6 +2477,8 @@ static int netvsc_probe(struct hv_device *dev,
 	else
 		net->max_mtu = ETH_DATA_LEN;
 
+	nvdev->tx_disable = false;
+
 	ret = register_netdevice(net);
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");
-- 
1.8.3.1

