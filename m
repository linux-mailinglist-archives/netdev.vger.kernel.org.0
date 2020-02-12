Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80A15A066
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 06:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgBLFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 00:13:27 -0500
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:33272 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgBLFN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 00:13:27 -0500
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.190) BY m9a0014g.houston.softwaregrp.com WITH ESMTP;
 Wed, 12 Feb 2020 05:12:19 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 12 Feb 2020 05:09:47 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 12 Feb 2020 05:09:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiM1lEx85W1SBiDbSPYy2SIFyBXb1M1oiglyMXRY0F3Mq/UEtxI5+M6WxLsUuTjxGLqupIdDyh1xZZI/NvARpr90sJoGA2S2cJ/cA3h/OOw1dE22OYnlL9a7P5RfAnskpadEErmBl4UidxXZ+BGIW11l7CQTjl2f0wnelZ8G6/nbartbXd3wef+QjorIyI6Deux4dIpIS80iLmRWYqjwBETX9XU3/UuonbKPBLxSSva6qHVhXrDqTtQHtHptUkUg6jKX9twDiUxwkcMq1TxdjzVfpxLP2qq+8MzToih8B/Uro/kbrzkvuoPL2zpyn7pN6Hu4cw3lCnHX1XKegDCPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsX8SyFgZx35DCtWGnHfF6/+AwS1bA9uIeb1n9BK+NI=;
 b=O6SMsF/iXwJGFM/BrO+hhqYUb/3X+zqZJMvZmdubd2duDXMoST28FK5UXpohWbi6bjw06lnlKuMG1jAxEre+eB0H/w5y7ryw9qY8Q8aKUs6t7BDuV/Es918QNdu72qOX4Zc3ky7hUllvpz67UTffZ2lRo/WTznL5EaQ7cEAZo+MSskp11x1p9vwEp2K/kgYvdbcFuK1LhlLoGqr3RZlvOnq0mde+nCb+XB11f3XiXggRNzI87RpYVdX8UtT5MA5AZSG1ctgXQUKrcrZjOYYf3qjnqDDvgBRurDjUxK6ovEUqBfAuEhA8KuI01ei/m5VwNUO3CtAc+H0eF5vUCHnW3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3329.namprd18.prod.outlook.com (10.255.137.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 05:09:46 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::c1f6:c296:bddf:20e4]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::c1f6:c296:bddf:20e4%4]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 05:09:46 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <pkaustub@cisco.com>, <_govind@gmx.com>,
        <benve@cisco.com>, <firogm@gmail.com>,
        Firo Yang <firo.yang@suse.com>
Subject: [PATCH 1/1] enic: prevent waking up stopped tx queues over watchdog reset
Date:   Wed, 12 Feb 2020 06:09:17 +0100
Message-ID: <20200212050917.848742-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.16.4
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::16) To BY5PR18MB3187.namprd18.prod.outlook.com
 (2603:10b6:a03:196::29)
MIME-Version: 1.0
Received: from l3mule.suse.de (195.135.221.2) by LNXP265CA0028.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23 via Frontend Transport; Wed, 12 Feb 2020 05:09:44 +0000
X-Mailer: git-send-email 2.16.4
X-Originating-IP: [195.135.221.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e700ef6f-e74f-4488-f836-08d7af79c729
X-MS-TrafficTypeDiagnostic: BY5PR18MB3329:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR18MB332991212650BA92ACAE69F6881B0@BY5PR18MB3329.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(199004)(189003)(316002)(2906002)(81156014)(81166006)(6666004)(8676002)(8936002)(36756003)(956004)(2616005)(44832011)(1076003)(5660300002)(6486002)(6512007)(26005)(66946007)(66556008)(6506007)(66476007)(16526019)(107886003)(86362001)(478600001)(6916009)(4326008)(52116002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3329;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcF2PpxGZetXvOL1N4xXAW9IPIJvaaRpd0cQ0kOBabfoWo4A9byR8SlD7ehSNv2IOG+OF9pJ5P7UVX8INhK/vo3whM/rRuhfUqgG8lgIzOdY3xGLF/qzHl/8q/X1dc7pMRkLO+I0NaiKXp9q/jrb+bDrF3F/sNr8/Qduv3SJExiU7BQBVcFt/fCQPFcWejGO9j7DCWmU1kIR62YdFKGqwuNINMkWlZ9J8Zse496XHEU1Y+xyp5xJDkaYQ6/oVogXrl8Oo+fLPptdgM7qbKZ+mqrI1PV55P/5GntJdPQgTOs7sddZttj0GCc0s/QcZa1SwuPF6TJEzRSM3n3TcgSoUSADIQTpug6H7fnwStyXG54mWNfwFjunYVUoFKl+xRJZpiEh+7f9WR4vGNQx8wiUSb7zhmuS6h648TwCb9mGfTeA03Red1QJUZtuxE5+rH36
X-MS-Exchange-AntiSpam-MessageData: 1LFxQOU8VMhgNtpZrz72Dlmf+4t+Xm++Rhg2dTmHFJ+SiLGRey3qVazB1PEAWSSwy3rJfizB5M17Y9AnTf6O/AZ4030cCYsqLl08ko4rcUSqPLyYEfwiuSFtHDNr6BET2JqhSBR4yHriajXGYsnNnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e700ef6f-e74f-4488-f836-08d7af79c729
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 05:09:46.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GF9QZSdtVvzL29YCDalcDCNZ8eqmiRksCmkmLrm9iRSO3vvtSWeVhqdToiqJaWsMsgpImRsQebj9WDEaQcVspA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3329
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent months, our customer reported several kernel crashes all
preceding with following message:
NETDEV WATCHDOG: eth2 (enic): transmit queue 0 timed out
Error message of one of those crashes:
BUG: unable to handle kernel paging request at ffffffffa007e090

After analyzing severl vmcores, I found that most of crashes are
caused by memory corruption. And all the corrupted memory areas
are overwritten by data of network packets. Moreover, I also found
that the tx queues were enabled over watchdog reset.

After going through the source code, I found that in enic_stop(),
the tx queues stopped by netif_tx_disable() could be woken up over
a small time window between netif_tx_disable() and the
napi_disable() by the following code path:
napi_poll->
  enic_poll_msix_wq->
     vnic_cq_service->
        enic_wq_service->
           netif_wake_subqueue(enic->netdev, q_number)->
              test_and_clear_bit(__QUEUE_STATE_DRV_XOFF, &txq->state)
In turn, upper netowrk stack could queue skb to ENIC NIC though
enic_hard_start_xmit(). And this might introduce some race condition.

Our customer comfirmed that this kind of kernel crash doesn't occur over
90 days since they applied this patch.

Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index bbd7b3175f09..ddf60dc9ad16 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2013,10 +2013,10 @@ static int enic_stop(struct net_device *netdev)
 		napi_disable(&enic->napi[i]);
 
 	netif_carrier_off(netdev);
-	netif_tx_disable(netdev);
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX)
 		for (i = 0; i < enic->wq_count; i++)
 			napi_disable(&enic->napi[enic_cq_wq(enic, i)]);
+	netif_tx_disable(netdev);
 
 	if (!enic_is_dynamic(enic) && !enic_is_sriov_vf(enic))
 		enic_dev_del_station_addr(enic);
-- 
2.24.1

