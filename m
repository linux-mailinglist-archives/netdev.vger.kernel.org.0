Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80BE279C27
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgIZTdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:13 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:60485
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730184AbgIZTdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvGQGlJ3jF/v3gxHP+LNGvvoiP3fQjdLxDTfj1RRd9WzCxCpfzGs0F27p+KHAKqJL8BApVD9l4eOrYqnQJ8Rl6y+1LEt9CsOq94FcCS8Hs7eFerDxuwmEin0liBzLpBTsgw8Fp0TZ0yL6Pj9PQSbezf5nGjo08jlAy3eqOD9hmaoqoVCS1huyyuCKp28zOeM+mKwWuUOHilnNWR9t/QYx4FRFH8GYAw2oIhE96CEi4L6P3gj8AL0Y/EQ+WQhKDhroYukacgv/VIrhHh7tQoneyp9XpkxdQnhYEH07aReuKY/+HOD2XKfN+O3fQ6E1Sci6GHLyRSDhOxrF/BxV0X/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtp8z1ZislxVZrBgOgqO/XBH86iahfxyQrq93zBH2zI=;
 b=g6FXBxK4kj1aoTNG9UJtZfw/5uopYI1zIYqiU0oODgP1CrUuQannbe4O85ozOCHT4PxwNLZDeFtL6VIzFQidlP6AU/7oo4P6etM9DYHf+BPCLUYh2p3KD6NmZVp2yQAWXojCeS+M4vP3e4icoASTkxn4SMJSCJTBKKU1A3KgPr2sBOqXieWzgJHOnWhq60z54FJ9S4FabmQZTNvw0sx+bBrf23UPSrLrBTXCaEb3Y/foTUk3fov/90ZKmoJ8GbiYdpKdmvd4BoWoDlP+dIYlxTGbn7KaYMBt0CJYk/r825Xes4xgdxkCRfTWiIeK9rt/xK1EM81LO/PYLb3+yJHihA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtp8z1ZislxVZrBgOgqO/XBH86iahfxyQrq93zBH2zI=;
 b=BBsxKsp5bT2oR/5owMQCAYcwUYhwIvWE3hBMT11eMs9vIkUUOmQJzqH4X+jw4n6yIwFq+7cXEXHeVVYFqW6QD0wSfbwficYTGRc80+qxz4Bpu9jywZTlBZY7suF+CUeQBtpK1mA7jJVhzcn6XFXnrAwPv9svkXF6+v8v/SiQnR8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 03/15] net: dsa: tag_sja1105: request promiscuous mode for master
Date:   Sat, 26 Sep 2020 22:32:03 +0300
Message-Id: <20200926193215.1405730-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:00 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c4d5dc6-0d98-4d76-6d14-08d86252fafa
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D5D4241A00BDFF959BF3E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UtNwnOtcnEzXi7Md+fllJRVtuohysW2Iz2WGYhES+oQbnCFxzVe9RQsxkaCP2oyAZzbhR/C/PbYuyLTYict8tn3VNXWhyUjxYfa1AHRUo75MDP3pvw3WIkm4PyDk8negWF8oN/eCa7Hps/SVf/bbPG7ZN8PN4LMLLgplkP3GoZLP5Zzq+RPK5ePtrn39LOaxVmDg8JeASC14IGc1DzJ3NmQTBmy3z5GcM8QYVHEx4iuQyNz99h0pgtgFz9yAbE4qSvKZH28L9APcck627Epq+wd2PcD/3NZaFbZEr4Cze2wRpY/Q8LBY+ZsrilIrUD6ZMR0Gyd1toCVS6XcIjCeqYpzGt0FN6Vv2Ijs3Ph40n7qo52wHY5yNzbQ71tBRHkhA7LXdsCpT2Kd/0NKqe7pAxegqGlJa/E36gaimFP3WgSV8wqQLJD++7YJ/PW1LOsQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: skEjSWT2i+w7sRUyibu7LDvn7usUjU//RHqAlceijrdiD3Vkke30zgi7NvNEf1V4juoUuhP32LA0ZnmeqHeWmmFpBC6YHh/glPimxi6VeMwlU7hf7Boog7q1DOWRjk9SqJl/v8JG0F2mimujLIC9UujAIdf+da3x1oVSNxGyKcSjX41kIVJMbORBskgBlTO9S6fqJhv47Poq95kaPU+UWAuQdjhXsndMhq/FTxVB+fPlCWpDqMICy/5ste2edqQsZ2HOcxBCjdoqvmHJyJotfns7fGGOJp32IupleukCqnTqNUVE/IMCe+aK4v7R3mS5Ru20BOQ7TrVWdOvEh/YPcQahnzUJrQzf0XLYMdF6lL+PYczMStKFpB5pvxUY9fG5zHjdYDiWhggVcd6BcCQo+ANayTYEzlTXYHTW/XxymMIM+VBIVe7j/B61FaQti/wL3n8Mk3OVY9sgtWvnqG4UdAVTe47HmkKtgjk3QxqffHTHdUZlYXorrnLprjP+U7AAUOvHjjftHHYhhANpPb92dDYVf33glkxYJ5SOx4Wat8BfOGUyUrK0LQIYPEetJ4PK2qPGW3uMc7Tn2UoqPebuzMMW1xi9kdEXNYfo0ayr1YuW/c83eAgjFBQLQBarJX64eb7NceXipCv87zeyoWPiww==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4d5dc6-0d98-4d76-6d14-08d86252fafa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:01.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J7f9BUQW0BDjxlYtDS/A7db2lMLjZLIHJocfaK78moySRu4wIjmLLEV4nQ15EODsrXV2zIWYxwJ5ASbsl5kYvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PTP is broken when ports are in standalone mode (the tagger
keeps printing this message):

sja1105 spi0.1: Expected meta frame, is 01-80-c2-00-00-0e in the DSA master multicast filter?

Sure, one might say "simply add 01-80-c2-00-00-0e to the master's RX
filter" but things become more complicated because:

- Actually all frames in the 01-80-c2-xx-xx-xx and 01-1b-19-xx-xx-xx
  range are trapped to the CPU automatically
- The switch mangles bytes 3 and 4 of the MAC address via the incl_srcpt
  ("include source port [in the DMAC]") option, which is how source port
  and switch id identification is done for link-local traffic on RX. But
  this means that an address installed to the RX filter would, at the
  end of the day, not correspond to the final address seen by the DSA
  master.

Assume RX filtering lists on DSA masters are typically too small to
include all necessary addresses for PTP to work properly on sja1105, and
just request promiscuous mode unconditionally.

Just an example:
Assuming the following addresses are trapped to the CPU:
01-80-c2-00-00-00 to 01-80-c2-00-00-ff
01-1b-19-00-00-00 to 01-1b-19-00-00-ff

These are 512 addresses.
Now let's say this is a board with 3 switches, and 4 ports per switch.
The 512 addresses become 6144 addresses that must be managed by the DSA
master's RX filtering lists.

This may be refined in the future, but for now, it is simply not worth
it to add the additional addresses to the master's RX filter, so simply
request it to become promiscuous as soon as the driver probes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Move this setting from the driver code to the tagger code.

 net/dsa/tag_sja1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 3710f9daa46d..36ebd5878061 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -353,6 +353,7 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.promisc_on_master = true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

