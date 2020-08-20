Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A824C771
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgHTVy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:54:27 -0400
Received: from mail-bn7nam10on2096.outbound.protection.outlook.com ([40.107.92.96]:63369
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728160AbgHTVyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 17:54:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBU1eFvs8Wm50+RbLsV3+TwDAgRoMgDYB7mX7j7ZzLQqrAywwtMzrBpZi6/Bl1vZnS+FMX3iYzOmLnCoGmrGDTwX6DpGx7hO735UrsJL0wsfyZ7r1wn/3WL2JDcZbZwAjUQM5Z8SX9ghhDKPImBzelZbO086Nx/P1UGGwIZCdge2l1oXUyZZzEfLUXwdWXveoej3YPtnrR6xve35JHGvNR6+pgiH15MVesPzmF7ZqnYEO1lZGpmy75KzZp8tzQ8v+9fqUe1gigUegl7zW7hsJPDzTiSzgVnbuMOVfK2Mbf1nLffadmt/2cyUOrGS8imOmcdFgVKYpLn46txdsVuY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VrQUpWlBAbyrbFDpQKJrFG87ckSCoHaR+du6INGFjk=;
 b=Q/nHahnrMD+2l7A797m2bK/xU22yfYEevShRnd0vYVb3EPr32UpAUEB1nZ56uq5qP4rJvJ0FwPGPIyVAIOFBLdO6BFEkHgMLHvP+YE/ttqdsdMVZHsUMnJ+VPrZAyG9xWTK4m17Dn+WcInmdIg7sUKrcLHGUNASaj+OEECJpNoYicGuKefoprxpGiSFcQhmYdKlwZvVI5ad2MyLhfWkoD80pBJepoFMPzRf1KCSEmHl9JpF7jMmluCmOShS9R/a/ME1nXgjYTNf+BdBIzdu9sVUyEtpYc99dxFt+qaRdrj6Ax+CIMUzsjz1uOyz2gbOog0/mAVhhqftmSnajKcdofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VrQUpWlBAbyrbFDpQKJrFG87ckSCoHaR+du6INGFjk=;
 b=Y7S9BeualQAubsZ1LbZp6osfT1ymbm6Pw0qyH5xgqYP62m7j5QaFjCh6HmaUMBvUDuIkXPcVeTSZjzgdWBww9pYFWJJI5tw9QNdy0of3xqeIGazeTkRlZhuZVoWLTdnpF7s/yM/pVnEOHposGFp2kC4JLcFd95fN3+bCO0t/5xg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from BYAPR21MB1333.namprd21.prod.outlook.com (2603:10b6:a03:115::15)
 by BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:107::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.7; Thu, 20 Aug
 2020 21:54:19 +0000
Received: from BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f]) by BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f%9]) with mapi id 15.20.3305.021; Thu, 20 Aug 2020
 21:54:19 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net, 2/2] hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()
Date:   Thu, 20 Aug 2020 14:53:15 -0700
Message-Id: <1597960395-1897-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1597960395-1897-1-git-send-email-haiyangz@microsoft.com>
References: <1597960395-1897-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:320:31::11) To BYAPR21MB1333.namprd21.prod.outlook.com
 (2603:10b6:a03:115::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from 255.255.255.255 (255.255.255.255) by MWHPR18CA0025.namprd18.prod.outlook.com (2603:10b6:320:31::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 21:54:19 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b4ce7c9-b671-4fce-28f1-08d845539738
X-MS-TrafficTypeDiagnostic: BYAPR21MB1223:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR21MB12234BF49F954B2AFDF4BB36AC5A0@BYAPR21MB1223.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1333.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(2906002)(26005)(8676002)(16576012)(6486002)(10290500003)(186003)(83380400001)(7846003)(5660300002)(8936002)(2616005)(110011004)(82950400001)(956004)(478600001)(316002)(66556008)(66946007)(82960400001)(66476007)(36756003)(4326008)(52116002)(6666004);DIR:OUT;SFP:1102;
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4ce7c9-b671-4fce-28f1-08d845539738
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1333.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 21:54:19.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nmpyuF0KJ8V8bfiRHx4ibUG4T3zZqypMeI0kBqCHTEP4F+u5idxOreveRpbaVYNJJqAXtF7Ll4MmD5pWa5eZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netvsc_vf_xmit() / dev_queue_xmit() will call VF NIC’s ndo_select_queue
or netdev_pick_tx() again. They will use skb_get_rx_queue() to get the
queue number, so the “skb->queue_mapping - 1” will be used. This may
cause the last queue of VF not been used.

Use skb_record_rx_queue() here, so that the skb_get_rx_queue() called
later will get the correct queue number, and VF will be able to use
all queues.

Fixes: b3bf5666a510 ("hv_netvsc: defer queue selection to VF")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0029292cdb9f..64b0a74c1523 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -502,7 +502,7 @@ static int netvsc_vf_xmit(struct net_device *net, struct net_device *vf_netdev,
 	int rc;
 
 	skb->dev = vf_netdev;
-	skb->queue_mapping = qdisc_skb_cb(skb)->slave_dev_queue_mapping;
+	skb_record_rx_queue(skb, qdisc_skb_cb(skb)->slave_dev_queue_mapping);
 
 	rc = dev_queue_xmit(skb);
 	if (likely(rc == NET_XMIT_SUCCESS || rc == NET_XMIT_CN)) {
-- 
2.25.1

