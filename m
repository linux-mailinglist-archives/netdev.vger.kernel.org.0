Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B070C1EBC22
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 14:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFBMzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 08:55:33 -0400
Received: from mail-eopbgr70100.outbound.protection.outlook.com ([40.107.7.100]:40330
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbgFBMzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 08:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwJAMbZ+ylRZkWt3/koTs1nCWOkfQ6ourFPxH4FhVRagHK+zKgOetcJMv1wvbJI5PQTOjVmer1P6vqG6brH7F/+ofI0JGSO1TED4/acbJiD5niEGj4Yqb/oPOX7xbfs4LJVguBrSNbnRzIoGFgNikrTv9mxdYAR+IelBsyuqykuBIHcaekwPe4gOOLrNVozxjHDPGKGZUdYUPVcTleNAVaIBF5TENMMuG9DcmSNlt3fTu95J0UrmSsLylMXIabm/cuU1MI2yd2Mkdl0sxGqJcblj6Ypd/RuCJvuK5xLNMxiEBjt7jCHkf0FYBW2laFVkEYX0tzTvHoy6a10wKumNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPqRQE3zUP9UntRILkd8oj+oWJUrs8Q9G56l+OnY2zY=;
 b=g6KA2cuGZ3+ktc80yOAlSQYm0v4hMaq7lGoK3ASkvvHpvv/KTz5FsPaVZfAvsSkXxwC+2cIHmrNXSHHQF8xf7x0GLfCJfSC/tKYtz129yigucm5v4rikvb15yH9RUNvH8GXPSYe8jKeo0NzhJlgb69iKMAq3zHVAvGKMM+RW9ttHyix2rfr/k33yAyS5BuiMvWRThcDmufzM9pwfSOrniX0KHUrgilElltn0jfDfTaGnmjEg1FdCRpodQ/4jRcDh1Ce8mQahboHkHAe7PuBL11qjoMkrIcPyLFYcyoqah4HrwO8pUdqbKj+R8RnYX0pXuEnkpQhUwQp4wYlXAgs73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPqRQE3zUP9UntRILkd8oj+oWJUrs8Q9G56l+OnY2zY=;
 b=EY7qldcvvB247uMEyNc2BnTXH0mvtf/z3vEw4ZhVGUNUxCRwByKx4Tm+T29Y7aszOc0hEytGDtqmjN73r7KN0vzqz8VigcggNUfg/DdNZ5K96Vf3dAijPJSK8XXpTu9KGUGBP9z03nhQ/vC0oyEWS3AeihETnhejgDynYwNlzfM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM0PR08MB4499.eurprd08.prod.outlook.com (2603:10a6:208:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 12:55:28 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 12:55:28 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] net_failover: fixed rollback in net_failover_open()
To:     netdev@vger.kernel.org
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Message-ID: <df2d392b-0713-20b8-0deb-1a9f93f7a9c2@virtuozzo.com>
Date:   Tue, 2 Jun 2020 15:55:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0902CA0001.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::11) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR0902CA0001.eurprd09.prod.outlook.com (2603:10a6:200:9b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 12:55:27 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbe1e2db-2eb3-4746-3446-08d806f43982
X-MS-TrafficTypeDiagnostic: AM0PR08MB4499:
X-Microsoft-Antispam-PRVS: <AM0PR08MB4499CA1E61DFEC1603A47785AA8B0@AM0PR08MB4499.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7L/woPCuyLI2mPC7IcUtzrZSS41/ajPWC93aDyPc4P96KyBymAAlX/O5gOXPJIGwpk4+J70YNaqwTtdmT0kH6k+njdNqR9vVjdp9Pu1RuSqzTX0RHtc288BPag9sdV0XorrOLsIydU6OLS/wia3dtZ6bb0oNmZT8ytF2+O4gTtQSZtev7Q6IbtEVpAGtM1OpjOIcpiSnUNSO6z+VC8CoQuFx5bkz/jBc2KLzBdKfsRx+MmBZyRJOZqrrTNLBhD/jcncWJ97AYjK6Y5advl20ek+W0+BYZbwL7FzbcMqyhuXXb/NFvuQzknxnMjT2+s9SiPHMtSIR5SNuXUgMmV8usWTTGEt3q7oIcnMCi22rkgs3dsi2nqg4M8g7j7ALHzQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(376002)(39850400004)(346002)(5660300002)(316002)(4744005)(6916009)(2906002)(956004)(2616005)(86362001)(8676002)(31696002)(6486002)(478600001)(16576012)(52116002)(54906003)(36756003)(8936002)(31686004)(66476007)(16526019)(26005)(4326008)(186003)(66946007)(83380400001)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WKOQpkToPZ6HBpQvlxIR+82s9slk27Y9NDNVSOY/lkYgC8qghGRlVu+uHG5ue5mmTy7ZJptfZ889iQxDaA3XDx4+Qh3p5Dozm64+7vboiBW3JBjIYapxrPOxsdToTgrgPBQmq8TVEiZ1u/QP1b2Fg2TlMQJ+K5cDzV5OkCtND9+1Kn1kSahwBH6aCvuvzvXgy2WI6Naefdnc8BsUUkAMT6PhVn9/hAtfImNbR1+qycLHVRBWJMwomoY+UZdk7cbEPjgXxb9etTjgQTgo/aPIdZ9vWwtG5I3gFniK3r733YLePzN6J/kTp9MM5u/PQZ38qsZmkwFwovMwkzUfKYZpcbMnOX82FZpdbrdayLT1osMVpK2knbAjQyCl85ErbP7s9HR8QLtp7DzyIcE/ls3eOPV6rpgiOudnrpQD8Wo5RpP4suPrvOJ0O4x+kuGY6j8AHV+Grt5iRO9G2cTPWHkAWJYN2r1s4ozV4yZoP83nnf0=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe1e2db-2eb3-4746-3446-08d806f43982
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 12:55:28.1235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxdlKebBkiWTir1tLQrI5OhUbmOMmac68PeiDLnQv479ekHxrjLWBmesi954RPzOXr5hdKAkeffL6ZCFjRGSGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

found by smatch:
drivers/net/net_failover.c:65 net_failover_open() error:
 we previously assumed 'primary_dev' could be null (see line 43)

cc: stable@vger.kernel.org
Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/net/net_failover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index b16a122..fb182be 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -61,7 +61,8 @@ static int net_failover_open(struct net_device *dev)
 	return 0;
 
 err_standby_open:
-	dev_close(primary_dev);
+	if (primary_dev)
+		dev_close(primary_dev);
 err_primary_open:
 	netif_tx_disable(dev);
 	return err;
-- 
1.8.3.1

