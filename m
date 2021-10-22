Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB74378ED
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhJVOU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:28 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233026AbhJVOU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYiiUaXp/ilxIiUXTflAEYxNQaHcvU9ZXUVTB4/XusKCiN7ZJHtjbBErwxrVYb0AaibN0kCyLPsSV5oGbfWj9NSccZi+1h7NblxjMCaGMnROtCeyM8WGei84sug/rJ3xxreCOXz36I98rfjPzaDvlxeRLlwnMusIRg7SFAj7f4w2G0XiIB3pU6srvAzEFDfTSI1F0p5P6vXiRdLeM9mHVw5/i+6cJEzLFgAlPcYcVkNshASlhiE4mZjnK0Ts/pt5XFaSRlvBw0/qldV6EtgaFI19/dpwWKAoqXxMbHYfE2r1lJ8IghTsCgmt2uea8jf9mkmDRXsw/eYTSzy1hDeQZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moRF2dH6E8ZFK1D4xqVmioIbskX61Dz3VexgeVOa1AA=;
 b=eStCequRCGSYyspiCUlOvpZQoizeojlcIo6Kta2XBmjGJ6qulOO2g5jw+mdZU1WwgJ8PRCdDUEaiwYopY2QgwUHX/tgiaHyNqwJ7SGOZR3YwPtqz/n5hWIUPEpDOj03KEQssvNt51uF1vwiOwYI4xh2qxli4WOlAc4RQapHOTOyWvzvLrjKePG7jiARdezO6DQ2YALnVCM0nZAIUDVea/0Wpls5L1R0vXrF9iq01fQwTdNxe3zfQkCvXm93qY0PqEr2xLbXVBin8GPFKKvfYg5GOUHKt4K1Xg3lsKWZ6vsDq3aqbxv68YMABCGqBxqNvFgcICUhVUs9mEtA+6atnwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moRF2dH6E8ZFK1D4xqVmioIbskX61Dz3VexgeVOa1AA=;
 b=GExCbfYePMz0UkJLQ9ajJfMonJNR1DZbh55CjF5j1n0xbsKQl52AxYBe7IJD8J+pWZa+kjaK8hQXjMbqfyLeMgRk2bEyXH4IKQLPXwWxKWF2IZ/9YyGBItgXz9SeeiNSU8jydJOKYndKU/244ul0IWrt5Ywi//Z/UTszZOX1kic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 7/9] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
Date:   Fri, 22 Oct 2021 17:16:14 +0300
Message-Id: <20211022141616.2088304-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c0a561a-fb52-4211-d7c5-08d99566c04f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340674A63EBFC5618405DD92E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/HhIRSRDgvBVDw7WGmx3lnMOkB+GsBJslrwcjTkneiRY8Al6CZT0al7uV5kIiBaDgf9xGNuEsd1xY40eYpKDp1DaOmbJ0Aoy2BJhltFh7haVrBYALh+SNFOGb/V+lOs4izPrzqqxNpv1qLneyT2z1amNKyEXhCdR/45XEBVivfZIRQfqNh89npLwvbylMEGJmRDtTYeIFjZNZ/lL1GDAjwvPe2QJUDoZNeb+xrfIFnVEMtroWG/TiDos9VyfT/gu4dVh8KFKPOWvJviOhBObrMFNY5c7p1qJ4Ap2xz89oW8USkHIBnK0nAVSrb7R4n4QP8ekQ0tq+YwJGavzFS6xVfZsm9YFLEnOOps8ZWHUwuqEZJpsGYdNTUSO13M3VmAeurp57M1eilFVBJ8E5EWxWZI5q4ICgNHb6nRAGAGRGXYT49lPq9qYBsYUY9m4HYGyKEB88oge6uYbM7RHY+Wd9s3Tt60D9N11tpY/8KAI97kTfECLpTVhtXnns77860yeDmeb0xXH+t1VHqlq0/1KygulFJEum6R2909iNkSs9vDPbFy8CznhbjMQl6PrY19DvJXHf/bnkXfkW4/9x9fqLlXv19eQsiIPDGw4McSP8/+LWHpMeh3c71q8d5tJeIHwSBetyNliRXf20IFfmPquj6Q/n9UdfUh6f2bO+r0YO8cD4RC6UGeP0kfyM2DhDqAuTjoni+VyE/7BS/K9g5b8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dSKK33hRG5z2otykLSEfkpor0CYHDem2IO+jePEZiaqCohl5qmzi+HqVa+iw?=
 =?us-ascii?Q?7DM9QyjEJRTIxVLuiaw9RoO+SyWpbi7PntMwnH1JmB/lBjaRIxKaiVwx/UqO?=
 =?us-ascii?Q?3cE2xjMziXILnRNwuVWdHibEvU9/E3sDoWLO6rvoRQNJ9y7QBnr8cFo8SzGe?=
 =?us-ascii?Q?3DO2pLW3nIdwj3r+6XcFjhK+pEBH6KmDPPSs8OWm9n4s1z//lEk7zqBVM0EP?=
 =?us-ascii?Q?i0+wCgcorn/1gh0tgQUUXEnjliLuWvasyvNbyh/fpVnSsWjZiRM5R7xZw5/e?=
 =?us-ascii?Q?jj9ulpTroBSEN8DJCrxLsKyGQ64wHbDS+KP8EK7m12bmL+qyOvK1XC0MvWAC?=
 =?us-ascii?Q?cFWsJNcXRxTxrOGoE/N9MoYkWJ9Fa/rvb/6CK4L7Fqz9BCG02y1kjgsrWlp+?=
 =?us-ascii?Q?12VB9zQAifbcSBokauPyfyKsUuSATrU7agIgPAAZnbuYHIQdvz98PttVZHR6?=
 =?us-ascii?Q?K8mzYgA6evW25JbH23kA1rU396nQQe39c+pqKJU+Lb1BJEVNC3ITWbl8esHD?=
 =?us-ascii?Q?MLTXqkSu1Ph8PgZhs7ipHQhc3Z8+ZKVQL3kRn4J5D+Aq+wWmmk0f3hTK5YYI?=
 =?us-ascii?Q?/0xD9ikbClWysISC9Ajrl0EKvgRyc7TPULOsnLDRmV6Vjzf+wCRvnQsrTpo3?=
 =?us-ascii?Q?OoxLUXgppP2mnyPxlRBsyPLCQNY7dXsHFN41R6oJJq069HK+e8/f1RKA0m3n?=
 =?us-ascii?Q?04UPXZy5FpJycf9BcokEIPYMs020+nTyHSBeks5mjGDCOERoYmN+Qm+/lHdF?=
 =?us-ascii?Q?2IesXEow8SScb1HHKoJ5pPsmX9oay+dIjscpXY0N9JFAtrsBiiOzo+AscC66?=
 =?us-ascii?Q?4aYjILdnN87RMpo1PBEyCDHdTOLDvpOiPs5n5cfmwdl9WQipr5iPQR0cktj3?=
 =?us-ascii?Q?KlDJ0oU6qNk0v02bOkmg4BMBTEm5oiJL1J5I05S4A6hI0mn+T23zjjY3HbcX?=
 =?us-ascii?Q?+moCMaJG3PCHt6CEnI+TMcxYEqURqBUv+DE23ugXb3CnIPSQJeJ/+gaH7xfj?=
 =?us-ascii?Q?I8gzumAJRS1XKVysf5gGaFW9i2saKAuBh3ulk/K6EvWToGUgffZX2f0HupSR?=
 =?us-ascii?Q?BZ89620NhsJ2FkIAgWHd06jxTZ9FkzKM3VwBfgaWZLMvtFNm8qtySzr1gmgf?=
 =?us-ascii?Q?VUEIYVHXQVnh8Mrva75aYgW47bObZkPIYxZWnW1syfurYvZC5h3fLsiaiORi?=
 =?us-ascii?Q?ZVws18A3LI8r/UurAfRY23hJA7RCPkihRcwC8InUjlPgztMDRPWT2V5oI5wX?=
 =?us-ascii?Q?ldRyM7AO38JKLdlHi7/jQ3DJEY9YIXQszygIduRb463SfovqnHSyp0RIqdfV?=
 =?us-ascii?Q?Qfw/zoqXHgq1otYXGGfZ8Dijh7JtXBuk+DwImFvCtt/qjslxkdCjBqytXBaK?=
 =?us-ascii?Q?UVxtCK3/1IpI01Vh81i2+5Sk/0LXR3kUHVSFF2hPOmQmW03zm3LqEu6JNvJw?=
 =?us-ascii?Q?TwM0tTAUNAgN3H1XFUGfllKNIaSu8XQW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0a561a-fb52-4211-d7c5-08d99566c04f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:59.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After talking with Ido Schimmel, it became clear that rtnl_lock is not
actually required for anything that is done inside the
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE deferred work handlers.

The reason why it was probably added by Arkadi Sharshevsky in commit
c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification") was to offer the same locking/serialization guarantees as
.ndo_fdb_{add,del} and avoid reworking any drivers.

DSA has implemented .ndo_fdb_add and .ndo_fdb_del until commit
b117e1e8a86d ("net: dsa: delete dsa_legacy_fdb_add and
dsa_legacy_fdb_del") - that is to say, until fairly recently.

But those methods have been deleted, so now we are free to drop the
rtnl_lock as well.

Note that exposing DSA switch drivers to an unlocked method which was
previously serialized by the rtnl_mutex is a potentially dangerous
affair. Driver writers couldn't ensure that their internal locking
scheme does the right thing even if they wanted.

We could err on the side of paranoia and introduce a switch-wide lock
inside the DSA framework, but that seems way overreaching. Instead, we
could check as many drivers for regressions as we can, fix those first,
then let this change go in once it is assumed to be fairly safe.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9d9fef668eba..adcfb2cb4e61 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2413,7 +2413,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	dp = dsa_to_port(ds, switchdev_work->port);
 
-	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
@@ -2448,7 +2447,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		break;
 	}
-	rtnl_unlock();
 
 	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-- 
2.25.1

