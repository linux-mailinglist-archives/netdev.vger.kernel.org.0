Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED1F2D0873
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgLGABm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:42 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:57805
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728687AbgLGABl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEQ/4GL3D5CkicJgSmGR+CTyIyT2V/NslYfCKHDWS2edTAltFiz9WKZS8g8jgsVMLvXyjiUJRo8ObDIrCS0NCDBl3rKXxBPs1pTbIec43qpNqPF0mNOQa69Px7grL0jjJV12DdllC8xX3i2UUP9cmTsrYerAjLRHf5pCblJhkskNctid1UgrjTKY/dHh0VueUkXdVh4w/v1oYRFylF9PT7DPc4md6RWTMRiPus67K++WEhCiX6cC+hsoW5/kJFmAb63ctPya98tngeCiIFfBoAdK2qoANLR6+w2A5qWi4aYJkMCV2qwppJ0bM/JjAJDOWM9f9vv8HqP7ZjZGv26j8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO3y0hndosQW10PzBTQd32CGEWeBUaCxb1xYmAQDgew=;
 b=bhHlDUojyN60pmYAz0cnqzmgorCT1c1bwA5/Gn04KUuNVFV751QdLVLDUHC0ooKJW66aFsJnYqnqlnNGS97NJq96TOYlw2XnNVjaFQsl+bwap6SBgbhjNf+Rpxbhlp24OPoBjEHecG0OIggWkltCM7xivf01H3P6kunCUSt5UCqk7IG678BrP+L8jRvuk/AnDCsrbSI6ZZf9zP2aDN2JT8/VLDnOvW0lIe0ntUD0Iqgd1FbedAdVVTp/CzdCvlwlLQgUM9i7lRZpYZLXG7a/UdW7bRMeOccjPrpEYJEeyFZbCmwnVv+ylgPFhSOjkQmAUVd7JeWb7FvKN1AwVBqJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO3y0hndosQW10PzBTQd32CGEWeBUaCxb1xYmAQDgew=;
 b=IrtRMzpd/HTTEIkx3HNUT/dBNB4LVbGruWQDGMt7IJ3qHFIOscWwRW9TIdFDIm2DAwyMpGjycdCcAATMgPwb+EMoGSEjWENRx8g1uC0x+cacxykx7oi4L3XDTJUQpovbnMeUVVk4r7fvg0lsz6Y6vF9JUu78E8xbRA9ACbs6gPc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:06 +0000
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
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [RFC PATCH net-next 08/13] parisc/led: reindent the code that gathers device statistics
Date:   Mon,  7 Dec 2020 01:59:14 +0200
Message-Id: <20201206235919.393158-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43e97ed3-f231-442a-c99b-08d89a430dd5
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637803789BC7A78306ECEFFE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYxogD61xYwagRtL9lMNjpMhVPuJVXY4ecJfdq0uB6BCq1MU2N6sZFC1DVhJ79ec/ErxRnEYTAXEiGQtbW+Wioe8zOTv+SeF+2af0illsMde5RsvTYAKcBMCIYRV7M5kpFjDOyKsBhskwTbIALgsY//ogXEqUFikjT/GBgihuI13jAEVOds25ds6LhemBCiWxACd9vAe0V6/IxbRpksmp+yFmBYVaScuvTyyszgBBwUjeLg2dWKzlcmjBYugY5OAha+dXOZBENJBdRp2PjdqPMQkV3ZfYInZbLjDscHZC6l0555O4D6919NfXKr02jUAfaTYPABuIxOfqnpvrgXFQtXOQMSmoJtYHhzZxBPczxx5uwXE7GkUAvxRXPaq4NcR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0OmKOcTf6IeGnCRAo/vgzQHWdsBPLU+40e6xJfUBRvmdjX1C8qajluRcRx2p?=
 =?us-ascii?Q?34vg9UW+TkYdgmghlR2baIT6SiAoPRc4MdXFc9xfn0LHuioJorFqKakgZDsM?=
 =?us-ascii?Q?rgkc1tLNqRKspU3jypjQWq/Lusu4eeWehfxGq5iq8qK8jX7K+2lfQ1XIfSNp?=
 =?us-ascii?Q?Oo1LQcvz1jXgUjUKZSRQlu2bcr5SoaTknMg3RmJj7CIZ2vnQl8/3IXewLEmP?=
 =?us-ascii?Q?YkkiLxP/eOr8WUA2fkUPcR+0x1Hwdl9QmflX5k4TXxRrDmEdBHBCtXjzIR4g?=
 =?us-ascii?Q?DA5Yt41/Mm4S3/H8obPf3SPkXmb0DpWdzFfiunz8yJM7Sk8tAvoIA4uPYjyS?=
 =?us-ascii?Q?ZJFTm8WICPggq4p26DoFKRAGlmiEJht8qXZlgslVePv2yYGBOd5/TGC4aF73?=
 =?us-ascii?Q?OYwIHdVzOHGi4jWTwKCy0+SO81UW371uFGEssOoOlhWXk9GaOh0Jod5/J2ZI?=
 =?us-ascii?Q?VPozpF+OoiX8074sImNS1yaiY/YNKDt4rQQjLaStad/bC02im1crZDWPKo6i?=
 =?us-ascii?Q?gRjmdfQocy37w1csaGpP3q0lhZmpOvsUBi5c0Z+arh/1MNoIq8pLDXmhQ2NO?=
 =?us-ascii?Q?w1SRavOQxIvX983xXdcE2KecCVknx6t+LaUI0ihL7IqKewOGfCj1Bxybcvha?=
 =?us-ascii?Q?lXL36sbpLvinZReVhJFZZLplB7hRz+olpDxWvLMn9AeDEhh/1FONIRAf0z0B?=
 =?us-ascii?Q?tEbwt8UNvlTMejTXYPIaizHj4VhbkJEfu8uppM36dQ563XFbr7rk5Hpl61I/?=
 =?us-ascii?Q?ccLuD6l4cLyaPUrVVcxVj+pI6Qgvz8nzsWzh+qKcoK+n5JgwkvKvtm5gDHIy?=
 =?us-ascii?Q?8UoODIE60LEqwt2abAWDYv/CZuCllYxVMJzlBdu0cj+JlZWeTzbSgCAdv3M7?=
 =?us-ascii?Q?iNYh/MuyO9Y2TzARTq7pjgD1bNcmXNqp4lwAKteIf2vo8LRwzd/uMwhsVIfx?=
 =?us-ascii?Q?ujDSdcZGP6Vy0FnZ1oUqNhkc4DUh0u8RRDsKhZP7X7FbxBtQSo9T8hFnGgkn?=
 =?us-ascii?Q?GOPh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e97ed3-f231-442a-c99b-08d89a430dd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:06.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4zPGyse6yHdrb/7hymJmNg34GCTwr5X4xX3NQ0rZgIvFlJsKzWygzG9Xvr68hNYkgfqA/CSg7A64A4W7Lx8MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The standard in the Linux kernel is to use one tab character per
indentation level.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 676a12bb94c9..b7005aaa782b 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -359,16 +359,19 @@ static __inline__ int led_get_net_activity(void)
 	/* we are running as a workqueue task, so we can use an RCU lookup */
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-	    const struct rtnl_link_stats64 *stats;
-	    struct rtnl_link_stats64 temp;
-	    struct in_device *in_dev = __in_dev_get_rcu(dev);
-	    if (!in_dev || !in_dev->ifa_list)
-		continue;
-	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-		continue;
-	    stats = dev_get_stats(dev, &temp);
-	    rx_total += stats->rx_packets;
-	    tx_total += stats->tx_packets;
+		const struct rtnl_link_stats64 *stats;
+		struct rtnl_link_stats64 temp;
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (!in_dev || !in_dev->ifa_list)
+			continue;
+
+		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
+			continue;
+
+		stats = dev_get_stats(dev, &temp);
+		rx_total += stats->rx_packets;
+		tx_total += stats->tx_packets;
 	}
 	rcu_read_unlock();
 
-- 
2.25.1

