Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFA03AA225
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhFPRMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:12:25 -0400
Received: from mail-eopbgr10105.outbound.protection.outlook.com ([40.107.1.105]:56195
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231251AbhFPRMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 13:12:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2w7NsQUzSkUoTYQcWdWuMV5v6DNMgTH0JXdCmalDkjUZi9U910eIYp7Rl/lS5ao39zv7F/MbmbGabDs3aKsfh1aZHepi1FU8+UfdeOCHQ2a1g6TtqRcYNTQNggCqhFtfjsGXxCMzTxcpLrRGK58gBYlkCcOOvgl19CLlu/m2s0caexBn92pGmD9dcmqT45VwrUtlrGbb37QdRfbUP0HBJal+C2Qa0wLX+MElkOE6KZRAADbgkk/9I84K8w0Gc2XJ+hWjHCmHqmzI3FPcxb9astgOqHd7ugNX0mZajMLcP3SxkNLc7iEMWkSiTqNWk1TcYrnQOzeP094xev61YzFTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn16LAReuU95BH8ikotcsU97xS8eIRBOIhLx0I0tCxQ=;
 b=Hdt2DhKd3QvcBUAVdCXw/3iJfLwkHkcxTfg8Ibc1757d6kip5lyDwyb5JbtN3Tk77+3NpkuUMf0JA3XOIyzhFar0eZi4Zk95tM1x/GUKYnrrkFUNuYmqEY6gyI60HXQ+4rO/nbOxZrGHb+z5UPWOeTy2sLZOoaPlxD4KElp1qaGe8tLSUx+yIF9rSeMhrbRslp5xBhyI1lBqEa3XZloArq6A/ssLkfNUlalr9WDmtIbVYDbYCE6ZJpfEgr4HyJ9KzMvsQlqACszilj2aG6VfmFs5DRiEhJCYCCU01vpMqO6LqL3KlwMiidi5qbvdHJ8N2yg3ghO8ZTleiB+MCIo1lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn16LAReuU95BH8ikotcsU97xS8eIRBOIhLx0I0tCxQ=;
 b=BENxMk0GbgcueT3NTjzQIEKDSwenHrzDVRj5eg0/znPN8lhjaWfmyLmpz9PQu6GgtnNf8b0kXyI2PQgF5snvOhQ/6jVte3EJaVGTQxQI9OOIapdPuEvRSfL1aH9XJrz2aCf2BSMFv9AwUVDzJMDTntiJby3nowqqYgAymehnpxk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Wed, 16 Jun 2021 17:10:12 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 17:10:12 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [RFC net-next] net/sched: cls_flower: fix resetting of ether proto mask
Date:   Wed, 16 Jun 2021 20:09:22 +0300
Message-Id: <20210616170922.26515-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6PR08CA0020.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR08CA0020.eurprd08.prod.outlook.com (2603:10a6:20b:b2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 17:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdcf59bf-93de-483a-a8de-08d930e99a4c
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02681858C5DFDFA8C8CF8EF7950F9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/J8eMVKl8utqkue8Q3H0APFc1bPz/W0iij9XsOX3AUIucucJ4L1lbN6K6SIPJ/vdv5otzb8AFlCs1hbTN2cbB+9pf/H6pzeBxnWFZHRTdvoFAgrFcoNsXGXoyf0cr4xfhsUs241P80MaNBlAmJT52se+B7wqFk1mIdiVB5l0jgK+NTd8Z7t8thieNWlywvZpAhpPMVcHL8yCeXj15NkEPY9UX9erdpGbmPkWGZqDG66RFJIgkQXzin94qqzJMVZ1FoM79Q4gRGfXreJhTayFyV00HfMGg+YFfyohNuBHzpCAy6jMk5dHdxsEIMwHbSa1J+mqNbp1duC7v03u7Gorqg7E+lC5WcF7kiNMXgyzQjvl5uxcPS0oXODIFGFlxCn5qm3Li0pEy5Mk65tTzDnXvGOLYnM5RoyT5rrBv9q3xKvR11pZmV3TaHFVgL2UP84vk8vX+WVZ0zatbdcwax9H4Rh7yYCgN9Vq7c16CouiPMXrwBHayt2U28OVHRjsmVgouIH8CzlKqLpny4RjUXEC8OvsoxqzDrHasmJNe4ukgJf+bRMpC+C2Hf/aWCjjWddcQL20AGHdkdChBjyDztyKk654yK6RQMJg7Y9tIrj3zTx3VA/O1rDu36RpBCFhL2EmyMaFHrs9Fg0jP0EOu90mOU9VqXNEEBxcVxMt9I6YV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39830400003)(376002)(36756003)(66946007)(6666004)(1076003)(52116002)(8936002)(66556008)(6486002)(6512007)(66476007)(8676002)(6506007)(16526019)(478600001)(186003)(26005)(956004)(38350700002)(38100700002)(5660300002)(316002)(110136005)(2616005)(2906002)(44832011)(4326008)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScxGB8tEDQRsFgk50q7Xm5c8sWpdgp4KHEJ7SNcDHaHsJgztIqOvKdFGM8tb?=
 =?us-ascii?Q?+XJrktp+Yn5aSn4MhjXrfHB3zNsFbTuZzwQU2jcO4DiU2sVwofCcEE4hw+dw?=
 =?us-ascii?Q?n7Xs69sbcoE1WrR0A2/c9mKNjOmnlie1v5TarY/8tQjGu0k3SMmqna6SPc+4?=
 =?us-ascii?Q?gP+K6WV2x7FF4N6dr1EnVcK3Zbq6wdoHwbiR/m+hIlELC1Kh0Tz6OvlW/V45?=
 =?us-ascii?Q?BgsM2eeyxxdjCviUFu9AeZsw/TZUmHNaDzIp1dAzHcdptA846SR1D1vgWwaS?=
 =?us-ascii?Q?2kaljCQPB48yfmM5bnlc+daDtg+OYrHck0tBRG0yAEo32gG4xKhqEAJgZdn4?=
 =?us-ascii?Q?Z4mhX1QVykEVAGUNCUmlB8ZStSvlau7978mvt5j+cvsbqwnYWatLrFgmOikv?=
 =?us-ascii?Q?YJ5Afx41ret4JYDSfKTsTVdSERTiCOhYt4kyQxgHod12e/1B9IXypddiwZ8a?=
 =?us-ascii?Q?/XIQ6qbJDToztje7Mx7Nbt2eqMD+eirTkuoocchfE61YOG23HDrGGa7SKvnp?=
 =?us-ascii?Q?FdlI2NrAnDew0iKZlEQWC00f1vvIfy11L5WLMm646Z/V/PB1qHDbI5+rCDOT?=
 =?us-ascii?Q?LSN86WR1Yt189rZMDQiE29yis2Qzm1UEOg8akxK7czFu6L5LLCjuXujOZ8nF?=
 =?us-ascii?Q?kYB6pobLo0ck0R220quSn6PLQiFsW01wREDMhuXebYVuuHBWLvIE/GRtB/Jg?=
 =?us-ascii?Q?OFfzjh6o7eiG4z6OeavX03ULz6gECQP3myNdgg0I4xQARgEHcZAo63SO0pic?=
 =?us-ascii?Q?zOL/5O382q0yzCbtckTGEyL+D4nIKYGaBr4Qlyz5KWbiTEIxVdaSaUWU8csN?=
 =?us-ascii?Q?i9elOw2+Qks3ntU/sRX73/gRvvcH3ekmXmTAZug3yqn6atAeKbAK3n8xZyES?=
 =?us-ascii?Q?eEXjIVUdNvzwm/UcsPEoHkw2/D6+tQHNjcbZgxLGvqFKjhhkT0slAJyB77sQ?=
 =?us-ascii?Q?FhZO4CvDYSUQoGmbUKZP7Sb0Hk8XQkTJpoZr3+FF1IT+9U8lqYcOzyW5n+Sv?=
 =?us-ascii?Q?yIkzb3kGJtNSi3WVJ9p+jHeWAlsagRbnLYOPVZQkqEYvaaXMZrtZKj4xwrlr?=
 =?us-ascii?Q?NjR57a81/j2l2qBv7a6jCFDPb62LIIh+p4+CZy3zhoHZneY8ftif4K+Je1+x?=
 =?us-ascii?Q?ig3lBwHbIDG+kM94bOq+1MLuDfP0uhwvrolpcf5XiOmGAVAmKcIfAzp8mgg6?=
 =?us-ascii?Q?LyuYElCA47g69b9WmuNuWw4fdf9CKnfMYFA1foRB9EDWUpFPTomtxyxTYrpR?=
 =?us-ascii?Q?8PPQpoAIj8qRKlDtLQR2IGkBEo1aQ70mGAanYHWnNPYe/OnS+4znCgQv6itm?=
 =?us-ascii?Q?kxEKpAGPZMbNVsqwgZxigoqa?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcf59bf-93de-483a-a8de-08d930e99a4c
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 17:10:12.6432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/1qFaWee9uvu7WGYENC1BQeul3XMcoNAvhOXT79BbUiD47V8Py1odrDynNm7JBH1K9WS/fccb3F/a5F4zf6HORp8aCPOnVSTKYiJ49Jn28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of matching 'protocol' the rule does not work:

    tc filter add dev $DEV ingress prio 1 protocol $PROTO flower skip_sw action drop

so clear the ether proto mask only for CVLAN case.

Fixes: 0dca2c7404a9 ("net/sched: cls_flower: Remove match on n_proto")
CC: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
I am still in testing process of the patch but reverting of
referrenced commit solved the issue.

The issue was observed on Marvel Prestera ACL patches
with HW offloaded TC rules.

 net/sched/cls_flower.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 2e704c7a105a..997ca0549c45 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1534,10 +1534,13 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 					mask->basic.n_proto = cpu_to_be16(0);
 				} else {
 					key->basic.n_proto = ethertype;
+					mask->basic.n_proto = cpu_to_be16(~0);
+
 				}
 			}
 		} else {
 			key->basic.n_proto = ethertype;
+			mask->basic.n_proto = cpu_to_be16(~0);
 		}
 	}
 
-- 
2.17.1

