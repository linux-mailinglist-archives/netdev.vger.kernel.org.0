Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A3E3AD2F4
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhFRTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:38:55 -0400
Received: from mail-dm6nam08on2109.outbound.protection.outlook.com ([40.107.102.109]:49025
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhFRTiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:38:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO0daRD9QWhg5xY8BJuSZDVd2N7tUuiimsDNXbVTCXk9ElsOsxSP/v6NkpHQS4MoGLIpsv6LJ/QmaY/qoRYA5NO8gRE9psvg+h5T1T0p/pLphazYxJhenXc4L7QUYM+niwf/RljS7yMWqf453oxdLFI4VSnwZpRNxpHeuVIBKuFcvyPoG9JWRhrYePzIGzy7xsJ5AfbiRVh45oA/i+aUMGmztglxBDXoM/7zeO5r7a1zxXRhbOX8iuXRN1U/vrv3JS4P3iOr7QdMcmGbM+KaxxwLUBLVVLDn9y6TSYd3QAf2a92C4dKCjkuL/cJb2cVt5tGK3HCfspXoF/OGkUrhug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6YNd3gONZFC6t/EqrsnxL5SrAPFYOipQ8VNM6MJMUw=;
 b=J1JOUcZJgFg63jkm5purJel+6QJsp5xzfw3/1jrRC/T6n/3QNj9bTGTMpuU+4ELptXExN0VHNcoRIoenjyCep9VpWMSFYzrMjKhQboN3KNxR5/CwjqPPx6pM12wPlj+i0ZO3eaOFb160pL9Dnc64x5cevwXfnmzIjnyw+rjWP1ZRm4wrd7dbFADVvFZSfTSPVkjg+a5/n3QqTPnGEH18VWBlo97/ZzZWzY6HwSuFYpVqGfrXthVrWlmySWLJaeMeiD9ndhMjPzDn1z0eUYwCnqdQP8Ugm+hnt2im7H0BmVj23nlpqiDtsW+GSFaxRe/lirH7e8a3w5Aw5LEelPHzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6YNd3gONZFC6t/EqrsnxL5SrAPFYOipQ8VNM6MJMUw=;
 b=TE4yfUiGqG5R5+kTXTjuciWkKO8YKqKoqyQwzviG1w6fL9v0NHzopB2QAphlviu59RHhGA7DYEhYOLaUbIf1ezE8Zuw4ZADz4yxK635m6hCAeEqJZ5JUliqlk76uiOWBLm7cYEZkb8Nlx+Rmcpfdp0n9Z2GPJf4pq9wA5i6+y2U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (20.179.53.83) by
 DM6PR21MB1211.namprd21.prod.outlook.com (20.179.49.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.3; Fri, 18 Jun 2021 19:36:42 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::98cc:17a:2e9:34ff]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::98cc:17a:2e9:34ff%8]) with mapi id 15.20.4264.011; Fri, 18 Jun 2021
 19:36:42 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: Set needed_headroom according to VF
Date:   Fri, 18 Jun 2021 12:35:39 -0700
Message-Id: <1624044939-10310-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0238.namprd04.prod.outlook.com
 (2603:10b6:303:87::33) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MW4PR04CA0238.namprd04.prod.outlook.com (2603:10b6:303:87::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Fri, 18 Jun 2021 19:36:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b2b0b30-7215-44ee-abb9-08d93290662b
X-MS-TrafficTypeDiagnostic: DM6PR21MB1211:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB12114601C12A948BE4442404AC0D9@DM6PR21MB1211.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:191;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jOL+Liodl3OQYVD0H0qgWa0dNp2JQw0t3WX0DWzZJtOcygW+PZESD4R4kXxDhhAQdogsRdNsC6EOMs2duuBl+6WTQU9/WQ78ZpeBXlVuMXsuA88FU633A4DQjxV98oAyG69aNKmkptyNjZcCHhINq7PRrVvlkNIcKhjJNTHXA5xIs4RFxhkUu76N20vv+UYI/q5FbqhTYLI5966o6brIUWyv0xEBADgqWLiAZ0CW/9qE5MF5TjAS7CMtnLluw/NVLTrPYpn/MUbu6Ukf5C9njHqtdf4lUswx7PW2/NV8Jtgi1WI8wK6y5oqr63gtjcCgwInHCNpMI7QglMBnrV57Rwmk7YnO5uyoAzPSkcU+ogv0K8nyOEsNsaO9eQM7d6wrdRk85EsMMjH8FUtlKI3K55/PKiYxstSY9Ayh5AYi4HmFOVXUaTS4KI75xr76i0rt6ko+SZkXHZlYEEnby35t2FTlx020I3EwicHvf9GoWpHtfnDkqjxfYnyO3SmL7vKvmTN6hUN51LBqqSdthxH+P87mgh3ivNyqU5iaUBmI97G3fvQjHnEF5th4airvIul+9VYwc26bZgX92w9R1SgztTRhl+YrtoaAGbxWT76gLyjHJHItJ3GnZfWMryQCGofzc7JnhmTYatHsnD4JMMEk6vlLzWvHYwaizHtCKmG43zO2vDboJHfE8ehKrIXqC7JEpQlzU+wayTeq8Ij+T1VXIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6506007)(83380400001)(38350700002)(7846003)(82950400001)(316002)(66476007)(8936002)(186003)(4744005)(10290500003)(82960400001)(26005)(66556008)(8676002)(6486002)(478600001)(2906002)(52116002)(6512007)(956004)(4326008)(36756003)(5660300002)(2616005)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwzQ3aD031WHovdqvVthkglnGrS9ADJvCjJWFRbXQkrT6Mr11NU4n2csaPJt?=
 =?us-ascii?Q?ar6w9A1hzA1Dv7Pb9pT/CKlMHObul2bgOtaiUJHnFjcs5WoVbRXHWp/jjaxT?=
 =?us-ascii?Q?umEZ0SxT8W+OyTH5OfIiDCVKnE9H1+8c8rrwbpnkde0+xpl1Hi0N7o2z5KzX?=
 =?us-ascii?Q?zQdbTt0unZwigB1+hOhwswKnDAsQMjWbtNct41X2sALTAx2MPIeDbyMFohdN?=
 =?us-ascii?Q?A/+B/EIeqTmy1Vng4moohjxyWsOjBv8P2qDxWz1HuJiR9+QBQxsHxDfflZs1?=
 =?us-ascii?Q?RnJ4cuLGL78p50v6IwsG5b1XIL0rCkFYFfTJiM8e0aPhiSy9+fKqjwYM8kY6?=
 =?us-ascii?Q?U16PYQkDsJufh/2RD7gOw/xWmD50M6107Apjb7l1WaEGcgKzB7WsXXiukW/+?=
 =?us-ascii?Q?Afin+4NUIaq6IekB45B6G5c69MqjvESJooGnZkiqVeJuEN0eNsRBJuUJk7WB?=
 =?us-ascii?Q?BhFSGXPyNg6wo85CMcal0lZ/vrBL0KJUIoUJxOKrAYggdUFzaWShZLoR1b/E?=
 =?us-ascii?Q?HDPP/wRUyoe0pYHfRdRO88rtFfUkNDeJC4Pi0d7kJpwfeBN7I4KvJSkw/JOb?=
 =?us-ascii?Q?Qro4eEFcbbLrDSDzt/vEojV2jp8F/Gew+cn6Po0qp3MtMIdwxBJOc6EnNjpI?=
 =?us-ascii?Q?bP1OmcRJ2Rcfcrb0UBzJXtioJqazEpsT8/2Q1qgdGT2JOaPrLTJ8E8oqP/RE?=
 =?us-ascii?Q?6Ue5bp4cEI3zDvGTFrNt82WKaX0Hq8v6OhB5pYkvEXboELl6esNRZDsVKKlF?=
 =?us-ascii?Q?8nNnWjACQCpss1pt4136x118sKhAeQ6/DKAQny5U4AY5G7VZMrp0PRXbnwLS?=
 =?us-ascii?Q?b+qmQnG2MQ2A5OiADMQ8USK3j7ySo68cjLXJ1wcg7wXZtaAC0J7npZwrPaqd?=
 =?us-ascii?Q?8gF31A7PGTBkQ8pGOaAnGBmH5uxQMI0Ro2s9zgYVM7O4iA30AW1B1ThAGtbb?=
 =?us-ascii?Q?Uoq5/d5IplkODzfWD7bGn6yyVoEIPTxRaohgXBU8CKCaGz0LGCPjDv3/Ko+7?=
 =?us-ascii?Q?QAR4GHGyLW1ey92RlHmIgWrR0IjbxqKKhN6tWg1bJDsU1pg8WhFTqw4epEMz?=
 =?us-ascii?Q?scyEaxGgLxmRdgjNyq5OSAJE6xIXfYkrRM26RlU1Gz0JogoUZBbTTrB1gerF?=
 =?us-ascii?Q?/k9HEd37tExuWgxIhP11wFFCSFq4lgWlnEeFDE0TtTOq0EZrrblbQyM2gz/q?=
 =?us-ascii?Q?JCcmJW5SZicMF+p/XLvVCAe0zfBohc37CksUC1eieP4KtpuGpnYGaHgDT2dP?=
 =?us-ascii?Q?aXhuXPVxwTa2mYONdjDISWNXsOUwLMqTAa1zCVoEvZG539uzh3bBP6tdzx6A?=
 =?us-ascii?Q?VQnPNxfaB2KEDeHiVsziTSKe?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2b0b30-7215-44ee-abb9-08d93290662b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 19:36:42.5988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cUI2CT7al7CU8VtwLNAAzjUGRKw7d8PS1pCCYcHnrG9XV1zue/nHAKKyZomolSFy/rrOK8n0eNWvZIWlPlz4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set needed_headroom according to VF if VF needs a bigger
headroom.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f682a5572d84..382bebc2420d 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2384,6 +2384,9 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	dev_hold(vf_netdev);
 	rcu_assign_pointer(net_device_ctx->vf_netdev, vf_netdev);
 
+	if (ndev->needed_headroom < vf_netdev->needed_headroom)
+		ndev->needed_headroom = vf_netdev->needed_headroom;
+
 	vf_netdev->wanted_features = ndev->features;
 	netdev_update_features(vf_netdev);
 
@@ -2462,6 +2465,8 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
 	dev_put(vf_netdev);
 
+	ndev->needed_headroom = RNDIS_AND_PPI_SIZE;
+
 	return NOTIFY_OK;
 }
 
-- 
2.25.1

