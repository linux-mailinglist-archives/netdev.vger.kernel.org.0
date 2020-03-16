Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC518719A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 18:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbgCPRxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 13:53:25 -0400
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:44161
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730437AbgCPRxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 13:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1WjlDALS697/enJ3L8lzQjSYvLtQouJQsmQji1JuD25Dnh1en3+WrvLoHGrR2ple0UTF4rirZmzL0Dwl+RvBkkYds0s6JgcEGa0l5Dn5RpUZB20iVnSG9h5A1Q83xBbwudHSTavz9CSQNo9QAWV21nEemwBTql8ZFLTGbZ9JrYMH+sBBKwkN2iPlf2km3fRVNFKm9N3+PzdkG8C2H8Hu+iD7+Q+w5UpGu7uHxzMm4vtr13nfZiODZhRemNc0AV4rocLcd+Bslj+hl6mYW2K89iCKW6mRF8wq54l16MFNS8J4HvsYa1hVR5GmEveeHu8kTe+Nk/V4K+3Fh7aEp+BUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWt2v9kgRO3XlFlHUgt9kxeGXSUtIXdx0LvSFFdPe5o=;
 b=EdP+aCfAjOT5xyEjptvW3yisvrM7IN8YnHW0vm5HFsOB8RPbMngTLg0XwA0KMH2rhcEzIJqabXO+Kiii46XnmqnH/GftwF5uqKHNMEOpAT80MTvBQEyJDpUFg+6u8PA9fsAGAecZRsr94fbbTKYyLNR+j6TkFkm//1pVfh4sIXVW5ehVA2XamoUMKJABvX7VZ3ErePdHGetxh3ugbtQVAc5knmZOagnpk42W1ZWH73K+Wawbqz3ahtkvrp2DQAUayrk3Yh1z/1nd+scVjEK1CYxUgD9q4Ilv1eCIz63IAcXk1I2dSlgxo1IdeNPdj5Mq+u8321aWh+COAYrsll8Veg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWt2v9kgRO3XlFlHUgt9kxeGXSUtIXdx0LvSFFdPe5o=;
 b=ANSc3lG8jOgn7mTCGm+MwW6k3qZV2/qCct5s/pwkLzXpijCTIlP5zX0JZ4vn4F3LTL3S0SnSPK64tmtQOGolhdjWeeFEEem01M26CX2EsJBs4SqhcgwlBjOdZi1vW2+xBF3pu6RSiaquSi7oI05b8Ddz/uGJB33OWqeki2eJxRg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Mon, 16 Mar 2020 17:53:20 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Mon, 16 Mar 2020
 17:53:20 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, William Tu <u9012063@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
Subject: [PATCH net] net: ip_gre: Accept IFLA_INFO_DATA-less configuration
Date:   Mon, 16 Mar 2020 19:53:00 +0200
Message-Id: <b7bc71aab99588a5b2c36c0338639fc5543f0f3a.1584381176.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P192CA0055.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:57::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P192CA0055.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:57::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Mon, 16 Mar 2020 17:53:19 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 244a9221-8d5a-4c7b-54dc-08d7c9d2ea00
X-MS-TrafficTypeDiagnostic: HE1PR05MB3323:|HE1PR05MB3323:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33234312F2836401FC1AFEA5DBF90@HE1PR05MB3323.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(6486002)(956004)(6916009)(2616005)(316002)(54906003)(66946007)(6666004)(16526019)(478600001)(4326008)(186003)(26005)(6512007)(2906002)(6506007)(66556008)(36756003)(66476007)(86362001)(81166006)(81156014)(5660300002)(52116002)(8676002)(4744005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3323;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 18Jv1085uiZveG52r1N7NbOtSErtKx/fO2XoI90UPHIMt4fl7jtXtlMs1xgnaPZV1ZSe2iRiCMq5L1KHzeI+gxkpk28yFK7OULKmP7b7us9OOJMX5I8zoYl97RdY1HNbmXdJtDhGWgNtHC/NzEKqmQzm3NYzVziM9mOEDrQGLxamJZI3rSegfE6gbLVw8wfkacj3bqnfV3J7WA9g7M2Kos6HRt91FrFlFsFwlmvMoKtsN3SD1LevCgcTUscdM5lt9ljscxQtofyRV7xGfRJhNe87UVt3hmrJu1FL91rP1aeHouFAHd9DymE2Cyxl7yE3/2kYzsMwZk2P74WPqWAO+98dH4x0swQaWHzlC/tsbdNw5fe2sOM9LBN4id6jmIWiyNk8vI8BO4Co+xXwGGv1pbLQCxz7tm4g/teSmQaXG8wy7hm9Hm8jGGehmG9+tb3A
X-MS-Exchange-AntiSpam-MessageData: B/yROSY+JjOfiMRR6eBw9zdSYrtUrCLZpRgfSEaz3OoJo1She5/kqBqLxouNQTiELL/OqmOwp/pDE233xm21qhnU6mJAvLpKAv135HlT8oT17473N8wTNgbNIqZErEifF+lic9LEaKpJP56dad2N5A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244a9221-8d5a-4c7b-54dc-08d7c9d2ea00
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 17:53:20.5048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ia0XJvbYp+3D2wVDOFBW0z7wo9blgrZCb5zHdR44ynng7g2U7N2iUiZ0bwOeR8zYrdLmNec6yeX90pfIVFZ1uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3323
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fix referenced below causes a crash when an ERSPAN tunnel is created
without passing IFLA_INFO_DATA. Fix by validating passed-in data in the
same way as ipgre does.

Fixes: e1f8f78ffe98 ("net: ip_gre: Separate ERSPAN newlink / changelink callbacks")
Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/ipv4/ip_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 7765c65fc7d2..029b24eeafba 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1168,6 +1168,8 @@ static int erspan_netlink_parms(struct net_device *dev,
 	err = ipgre_netlink_parms(dev, data, tb, parms, fwmark);
 	if (err)
 		return err;
+	if (!data)
+		return 0;
 
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
-- 
2.20.1

