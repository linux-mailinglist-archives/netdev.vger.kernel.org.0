Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7482D0878
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgLGAB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:59 -0500
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:17892
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728683AbgLGAB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0XgaJjkReN50lvXF/Hbg0v6+FNQPE8Tpx/NrGj08GiRPDsMsNCWnBPhLxoT8QjRRfgXGnqgtRrG5Y9hDjwox1DN4wVgSfu3sy64DLzb3jsw6/8MpQTE0WxKb2rb0MVHppUsLNsualltVngrzspeDlwfFjEJMFJDbiNUvZcJgtq6f2OQXYQ0UoyImOt8LTe/555GO9J2fmc3feuZJ4k6tK6ePu6qdraNizTphb6h+UdCjtIaplUTwVYhUPaxUkHY8UO0FQsq3OhwMjEM0FlpFodrrZBSpjcQDBV3kDWE8gdNgHu+VQNsLJeeTJJsNauIwZ6UCO9gKmG1GGbziFcZSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1aaSplXW7VCc/5O8O2/UDxdFpNfODNYhSZ9QSiG4wY=;
 b=HHb7bTaGMZHYzmF7hT3PPnl1GKcSAEGvDBTO/oCLcBQl1oIZFnsKiUqX8g/pgOw6THnupQ/XhhMug2I+ONIYEVKYbCI/5/7Dyje9MAOkwgjUIX6pxSB5pO5Wabi2E+B7M4RuUczbvzmEEeGF6ct7WPxREpzXXYC5PiSGGRMkufjmYwpaBys41IDJwQaaxLdOhjIjxQTKjji92elGpIyI/hZB8/QXqaPNjy3kFIPPfUoZFM1kkygApdFzHHIT2Hp0+W10ht5eQJDYXCrO6clM9yKcQcvlPyFFNOTPBSejx41ITHR0EydxEJUnGbhStuaEyIV4+jeXkUkg9+7IQRDMbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1aaSplXW7VCc/5O8O2/UDxdFpNfODNYhSZ9QSiG4wY=;
 b=ZmhrAp8Q0T8f87qbquPxcknhB3AFLgfJNQGSfMXMlDiRi7w1mw3NT+vMQb/hcE/6j2Ztg5aXZRqZNcBmvZBxafvR7MLfvZVivk0vsuyY0s6n/1sQha4QDsz6DsqUMvIOivJfGxqV+O2TqoIwd0oUqxVyfYgSs0UmwiPYeTnoIts=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [RFC PATCH net-next 11/13] net: sysfs: don't hold dev_base_lock while retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:17 +0200
Message-Id: <20201206235919.393158-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78b2c608-f89f-4387-3117-08d89a430f53
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637113821BD29D8308F84DAE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3CC+M575zOEt3IRbw8DalIxCUqL/YSgCNvfh+E3AxHJpiQClHxy9FXZkSkPksGWFcs1GWxTSrSvQ7xTQqdTu9XDXb9Sez6qnwO1Ky40g1hbVyPb4fTh+IHUZnNXl/j9gT0+BbT4lgkkVl2C1fC8nlwImAEAF5LjWd9yZu75JSoagb7MnITsXJaaGiHfZrYP1sjruSriy4wVIzK3Uj2z3U9M806900zaYxLcbjASfM+CCzjjg8uheue5TMqvEczNQiVU5fHGww+pKwrBYC2i1tV/hVG/uAhpwEbWLRlCrkvG+q3r123rEBD0JjmRZMgfso0pYGdt8J73IRbkwdhtgyin1jqEa8ghtkI9vcDT2seIJJ2X19HR2adtcJrrQ7iq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pX0eL/Ayi+cDZft4fn2Dg7PrMoz8i6OZ/XwnZG8osI8/Zd30QySGYcnR/kSh?=
 =?us-ascii?Q?rIiC1H/uAvIqaMa3caEEuK0s+TflByYPPfAilHuCVang13D1jdbuCp6Qinmc?=
 =?us-ascii?Q?x3WDSlItgb+Hd0QM4jf6SiFX+C78gR8uqx53sAjpOwGvCF0bWf0Bxnkp0TTw?=
 =?us-ascii?Q?qDQGmwfNF8mTqVTr94wZp/mhTPIBcwKsPMoUiTU2oBg/4VPFcJQ2RMr6EtUn?=
 =?us-ascii?Q?LUONZEU4e3vT+A2ymRTpK4tLNl28Rb3MfxsRoSAZvJCJMBW5tq2uocQuFt03?=
 =?us-ascii?Q?xIy2spuMNeLWVBjdBQnsjMulVbzzf79Y05FtxZ53FcJYzER7SzGCeZZJC1FK?=
 =?us-ascii?Q?Yd6Dx99bn4jMxa/xEpqYBdKGOv+MVB05TESDVAhqu5UJogy2Oql3c1Efhn4h?=
 =?us-ascii?Q?jZk3EQWqdrEAQ7PU8mxx65rWAWILyuCXAW990ASvX7U4DNaEfF+CwFY/mB6J?=
 =?us-ascii?Q?WqYAE9AGaJ5LhJ3m7tRNLTWgHRqXuKNsBtj07h8dEJIw4lMFvQ0/167qdqlY?=
 =?us-ascii?Q?tW76enPqd2eg68EtI66B2ech2Q0uXEhM+/AhpY9ru+4L0pMRwUWncoEtL5LL?=
 =?us-ascii?Q?rkZaUnG2EvPdWzu3NUhEhrKG7q1W3FY1/7xJoEHSOgARclQ3/VX54XB57EzZ?=
 =?us-ascii?Q?lMbeUfKA+5ogMn7R/ShhfXLerNlfGh+0S2/TdV+2W/Rxh24Tg3gbgAsZqkHq?=
 =?us-ascii?Q?6E8L9NDGGXMwR01RgIcIJvQ21f6OgNsNhlDUlwGi/BGmmMTDzNKgLZXXtE/I?=
 =?us-ascii?Q?chnZYDIwS7bDWK7iooXcwLiKzQ2NG52v11iFGE2PpymBrBAeXjq+n8cqi4Ji?=
 =?us-ascii?Q?IctTHMNXZ/uNLczE+QuQf91RzG/2WLnJx2IvHkPqFQYAvRok/7qS1xkJ1tmY?=
 =?us-ascii?Q?k56iuBGd8l0ublcn3UEstYXBytRBo941TMsEFgaDttvZeZAxQCPNT0lON3va?=
 =?us-ascii?Q?LXiABvXLx9GjP/3n3qOxXN5lss3NG0coEacuSU8k0D3tpvCqYy4Ns8mCnXV3?=
 =?us-ascii?Q?xB1T?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b2c608-f89f-4387-3117-08d89a430f53
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:08.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ySFUYTotQGvb7mt0Uohe62aou17atBWu53D8vlPp4KV/T5MC+MEsHs8OYuwTIfkvPv+qoAzERubVsiDPGaowQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

I need to preface this by saying that I have no idea why netstat_show
takes the dev_base_lock rwlock. Two things can be observed:
(a) it does not appear to be due to dev_isalive requiring it for some
    reason, because broadcast_show() also calls dev_isalive() and has
    had no problem existing since the beginning of git.
(b) the dev_get_stats function definitely does not need dev_base_lock
    protection either. In fact, holding the dev_base_lock is the entire
    problem here, because we want to make dev_get_stats sleepable, and
    holding a rwlock gives us atomic context.

So since no protection seems to be necessary, just run unlocked while
retrieving the /sys/class/net/eth0/statistics/* values.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 999b70c59761..0782a476b424 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -585,14 +585,13 @@ static ssize_t netstat_show(const struct device *d,
 	WARN_ON(offset > sizeof(struct rtnl_link_stats64) ||
 		offset % sizeof(u64) != 0);
 
-	read_lock(&dev_base_lock);
 	if (dev_isalive(dev)) {
 		struct rtnl_link_stats64 temp;
 		const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
 		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
 	}
-	read_unlock(&dev_base_lock);
+
 	return ret;
 }
 
-- 
2.25.1

