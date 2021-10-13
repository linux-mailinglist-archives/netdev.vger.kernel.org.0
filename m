Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F03242B0EA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 02:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhJMAVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 20:21:33 -0400
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:56417
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233128AbhJMAVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 20:21:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a10VS/Vd5k89+PsFBqWDwahpRz3MYiQM6vy1reN6z1Z1QrTlrWMyhfGhVDJagV9XBHtreADvFr7r7KEGQ9XMt9uNLUshYtkUISZjpzMHJiqoPtdMwSrYpZn0INXRNK6l7k+qE+XQSugub+OgMWfH42id4nJrcZfcomCw6ocQt+SdelpGOSnWYzpDMhif0ii6/Fl25aFg4pwsd0n46AhVj0dzopQ8y5RU/RshAqn6AUVAwAAcylEkKDq5EXjXDOTq0h1xpPfY+nBwm6Ja0nqfgQ6/KgGlGM2sE7GBuo4rFN/dVoK2D2eez/U9wqqpna6L2KinslWGbUWzyJzZKW7jqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaEpLiPGhxaDnobPB+siVaZD58MSsRU4+SvEaMCLOPE=;
 b=QeHRA8ndCwcOaosZhKWhMSTGmyMeNy0TMUpXyfSMfhDwh0nMDEDss/5fILQWx8T2zN9vf1a2Axd5o2bN736Bqoo13g2xSY//HtSnCxgGfUK9PJ+e1lokssWcRUod4S4VMQMETLTUIGQOX1EirrNDTv25rItVOaQCdkB7PjOLQb6MpN0b+VsW2gqYBlUeYDXV7wyqtRwBNtrZQoHg+eLgdD3KWXKmTQNStAw7kpoiK6lbG89p4CCBhV2ZjMn/4Sk7iEQY23QceOtLYeXQBtnoxguAddGZ300/8HH827xc/uU50HxuukrUvGxsFOhW5SFzsvgM5n8331G58UPSMPQN6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaEpLiPGhxaDnobPB+siVaZD58MSsRU4+SvEaMCLOPE=;
 b=QItuhfxR2SOYRyj6j7ckVrRh6n4t215fee5aCtQpA3q1pHs6uGVyLJqBYbu+/EpDRiMsYfWVDoRUJp3hK6OFBiDphTmXHjQx0i1OWk5FCulC2sZlMh2JnI5OAJbOspDaEuvfn/2vOoS/rRzmCR85ZjbhZperVK+GnwHEqXYjMp4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 00:19:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 00:19:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Yajun Deng <yajun.deng@linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] Revert "net: procfs: add seq_puts() statement for dev_mcast"
Date:   Wed, 13 Oct 2021 03:19:09 +0300
Message-Id: <20211013001909.3164185-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:205:1::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM4PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:205:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 00:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd65fc3b-ff36-4977-6181-08d98ddf1c8e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4223:
X-Microsoft-Antispam-PRVS: <VI1PR04MB422302282C307F96571DB1D9E0B79@VI1PR04MB4223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5m4h3lji7E3HylmcY6DbdES5D68RomkzyOeIDTmQ91W5Cu3/COfeifN+ulhHv3Ul6QMrAfvTOo6wHekMV5ruff6XTTv+CQ6uDBu3LPKqbapB1H6cicD/2OdKxyHBtLQi37CqbsUZs+r4lBt6fvU3Hqy8svyGqYCqDy6ZqkFQIpABvA3KTxU9umeW9I3ZpzZkDusuLcfP+l1I3ka7Cx+KeFLZMQLgke2BGCD39WugCo9gKktePuKwqbLrwSfWlNNNbaqdaIdvLfcxIqkxwWRP0k0WfZD9MAUI5swmen8N9efLG/yvZxHhYgBw6iFb1dyn2eq6xMdeSTD4+O2CyQGfTkKs0a7MJDbXXG0EQ94tnjaeuUEg5dUhKEuSJ1Le70kITMMcrxE3WgCY7v9WG3MYkOkfDDlRptGJFVmfJc58nl2YMy8r5NjuQrHDTq1CmdNaLt8BpfsyHs9rlhVeobnoAaJ+Q8r/ukLp6BA2j2HmRYPeQn7eBIUzGY+kGFTkEfr6sce2+MCyVaCZz13rFzN2UC/t2/rJvyxGNUqmUQFlbykw6ImTIx0vgdGnHC5yyzzU4pTqU76WpGs8IhWwcfUz9YcKzOQK6Sz6LrvI5B74HTHyGWxpIw05XwnrrDkyAEfq5d2YLfW0iuyrSwRlaw3ubr817TNq93zXLApmmGcy40FhF7wcvW8hqOG7AbmPdU2qTSA5HlE1xKTqPJwpnwUHbTrNiTZFvbfDN+lT63zDSS/GxlFE608vyhHkLAqd+XjNc58E5oJOMKoF8WcLnMCrwNAOc/m8suTt27WyLfnFWEEmvlNX+xE9U400mvZGTcBiz2iuLx57GTq1MSDpsMmJTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(186003)(2616005)(36756003)(8676002)(6506007)(38350700002)(38100700002)(83380400001)(8936002)(1076003)(86362001)(52116002)(26005)(66946007)(6666004)(966005)(508600001)(6486002)(54906003)(316002)(110136005)(6512007)(5660300002)(2906002)(66476007)(4326008)(44832011)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dN3iVnEjGE9a+n/hgMHLP7tDjXdM4E4VXZz1M7e4xgDlE9fSZshAvY1Hadc3?=
 =?us-ascii?Q?CEZjfo4tGSlDiRsYK4L0zrLf4APvrg3wOLWsUaJXHGvIaSx4Gvi0DFiPEgQq?=
 =?us-ascii?Q?NfUJwKBxxXxwYh5gwD12BNYzSHxDvHlVIGB3IbYHwSeM64fuOuM+IPrRD9Fo?=
 =?us-ascii?Q?QSystetW2s50VvriEz2SySoA5/dIdGEGDBWYy2R7hcuEnGkKJRb16dZJfgwJ?=
 =?us-ascii?Q?RNFUX3FMdzanu/07LDyfMwL0t8pb5fL7/w76+o/gJlB8i7+YzLrU9lzdD1Tz?=
 =?us-ascii?Q?YUdUY8B3+o4NlmldQgkgNRGTkXKzRMomOHczd39lkKGSyVyHAbN/zjLeuBTb?=
 =?us-ascii?Q?fYtSSULBqU6QeAj4/sI0uJPeyqhXh4bYvrfjg4+/WmetgogB6tDU4sVLtHGu?=
 =?us-ascii?Q?ic86QWTQw2qEi+oDZsGFZwGGV0MzaqC3kTQ7OXebjGHiOIc2SQHBcOCEtvcv?=
 =?us-ascii?Q?GbWJCnCIgELWHDCH3ZK4qCXqj4eeL5KpSxja/t7uF1+vrxZhhYge6FB+cLor?=
 =?us-ascii?Q?jpS+VHHlr4WPzEgLRKQdDA5vMe0BOzsaRFDi9avAa/2L79IejLBeCS0GSx/3?=
 =?us-ascii?Q?jiuoDSpJQ3fOkV1ocBkuQN8gotflBSDZeZbToPZpPi2MQWiJxCM431neytBT?=
 =?us-ascii?Q?fZ2wHBHi+HzHJ/HzHXkurC4As6rTPN65+sNuHSmCXCR7g47MfZ3X7z9Ud7vt?=
 =?us-ascii?Q?F/gxikMuLQCTWMwb6PoTfx/xl6kMVjzDdDaxfqOpiu2bMQiASrZPgAP1lzPm?=
 =?us-ascii?Q?Y6/CX7e6gKLQL6UcLdxwXmFDvwa84vq/n2EDYqiwEXa1WmVYcEBdUdQOjTrn?=
 =?us-ascii?Q?f5D9Ze8M7ScdQGt0GVGxY7JR0kKFUZUgF23t9tAx/we8nLN2z3VzVr9ibha2?=
 =?us-ascii?Q?C1dsZRUQZREZr8Yq1tWiwz8TzpdmHC7vYkqhZDtrdTXRjk+go+1Cmbx1mc0V?=
 =?us-ascii?Q?msoF47FEyM8qrB2h+5B0yNM1iQ8QMGazrnrUF69BDcXtxVeTOM1pCh7qbMhZ?=
 =?us-ascii?Q?NU1zIWH4a+4PZdlewYrrgBRC+2ZJ1hxT6y8zyB7Fd+DUrnGFuXF9TeIaDh4o?=
 =?us-ascii?Q?XQ+2ot58mRxdR/2JZv/iMh+ZBKRmX5+fAYJnTUSwC4Nc2RBHVJC06Lk1ArDU?=
 =?us-ascii?Q?pNKeu9QqDVnbW/34+tgerQSA8vWhQkZ1UD1s/AnD+dzNhUXLtYPbNq/ddVQ3?=
 =?us-ascii?Q?Z17A8npqk9mh0dPOHx4ccYo93QWljzIhfcRDEIcMIH+G1xGt8UF0sKkx2TQt?=
 =?us-ascii?Q?7ZjaQ8m/hgpRTFBtyX38Oik3+RMJ6yv5EP2WEY1hfIAL9hoxzdzAqUX9yvb/?=
 =?us-ascii?Q?Z7i7zz+nhNrFLcwzDYt8yfpk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd65fc3b-ff36-4977-6181-08d98ddf1c8e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 00:19:24.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExRpla8G0GsZnHhH32iFmozXSRhfTu7WJNRFKXngQsj/jwtbJdME+Dd3yiCe9JywYCXVZG/Yzo86kNRUtTIztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ec18e8455484370d633a718c6456ddbf6eceef21.

It turns out that there are user space programs which got broken by that
change. One example is the "ifstat" program shipped by Debian:
https://packages.debian.org/source/bullseye/ifstat
which, confusingly enough, seems to not have anything in common with the
much more familiar (at least to me) ifstat program from iproute2:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/misc/ifstat.c

root@debian:~# ifstat
ifstat: /proc/net/dev: unsupported format.

This change modified the header (first two lines of text) in
/proc/net/dev so that it looks like this:

root@debian:~# cat /proc/net/dev
Interface|                            Receive                                       |                                 Transmit
         |            bytes      packets errs   drop fifo frame compressed multicast|            bytes      packets errs   drop fifo colls carrier compressed
       lo:            97400         1204    0      0    0     0          0         0            97400         1204    0      0    0     0       0          0
    bond0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     sit0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     eno2:          5002206         6651    0      0    0     0          0         0        105518642      1465023    0      0    0     0       0          0
     swp0:           134531         2448    0      0    0     0          0         0         99599598      1464381    0      0    0     0       0          0
     swp1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
     swp2:          4867675         4203    0      0    0     0          0         0            58134          631    0      0    0     0       0          0
    sw0p0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw0p1:           124739         2448    0   1422    0     0          0         0         93741184      1464369    0      0    0     0       0          0
    sw0p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p0:          4850863         4203    0      0    0     0          0         0            54722          619    0      0    0     0       0          0
    sw2p1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
    sw2p3:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
      br0:            10508          212    0    212    0     0          0       212         61369558       958857    0      0    0     0       0          0

whereas before it looked like this:

root@debian:~# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:   13160     164    0    0    0     0          0         0    13160     164    0    0    0     0       0          0
 bond0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  sit0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  eno2:   30824     268    0    0    0     0          0         0     3332      37    0    0    0     0       0          0
  swp0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  swp1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  swp2:   30824     268    0    0    0     0          0         0     2428      27    0    0    0     0       0          0
 sw0p0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw0p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw0p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p0:   29752     268    0    0    0     0          0         0     1564      17    0    0    0     0       0          0
 sw2p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 sw2p3:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0

The reason why the ifstat shipped by Debian (v1.1, with a Debian patch
upgrading it to 1.1-8.1 at the time of writing) is broken is because its
"proc" driver/backend parses the header very literally:

main/drivers.c#L825
  if (!data->checked && strncmp(buf, "Inter-|", 7))
    goto badproc;

and there's no way in which the header can be changed such that programs
parsing like that would not get broken.

Even if we fix this ancient and very "lightly" maintained program to
parse the text output of /proc/net/dev in a more sensible way, this
story seems bound to repeat again with other programs, and modifying
them all could cause more trouble than it's worth. On the other hand,
the reverted patch had no other reason than an aesthetic one, so
reverting it is the simplest way out.

I don't know what other distributions would be affected; the fact that
Debian doesn't ship the iproute2 version of the program (a different
code base altogether, which uses netlink and not /proc/net/dev) is
surprising in itself.

Fixes: ec18e8455484 ("net: procfs: add seq_puts() statement for dev_mcast")
Link: https://lore.kernel.org/netdev/20211009163511.vayjvtn3rrteglsu@skbuf/
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-procfs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index eab5fc88a002..d8b9dbabd4a4 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -77,8 +77,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 	struct rtnl_link_stats64 temp;
 	const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
-	seq_printf(seq, "%9s: %16llu %12llu %4llu %6llu %4llu %5llu %10llu %9llu "
-		   "%16llu %12llu %4llu %6llu %4llu %5llu %7llu %10llu\n",
+	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
+		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
 		   dev->name, stats->rx_bytes, stats->rx_packets,
 		   stats->rx_errors,
 		   stats->rx_dropped + stats->rx_missed_errors,
@@ -103,11 +103,11 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 static int dev_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "Interface|                            Receive                   "
-			      "                    |                                 Transmit\n"
-			      "         |            bytes      packets errs   drop fifo frame "
-			      "compressed multicast|            bytes      packets errs "
-			      "  drop fifo colls carrier compressed\n");
+		seq_puts(seq, "Inter-|   Receive                            "
+			      "                    |  Transmit\n"
+			      " face |bytes    packets errs drop fifo frame "
+			      "compressed multicast|bytes    packets errs "
+			      "drop fifo colls carrier compressed\n");
 	else
 		dev_seq_printf_stats(seq, v);
 	return 0;
@@ -259,14 +259,14 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 	struct packet_type *pt = v;
 
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "Type      Device      Function\n");
+		seq_puts(seq, "Type Device      Function\n");
 	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
 			seq_printf(seq, "%04x", ntohs(pt->type));
 
-		seq_printf(seq, "      %-9s   %ps\n",
+		seq_printf(seq, " %-8s %ps\n",
 			   pt->dev ? pt->dev->name : "", pt->func);
 	}
 
@@ -327,14 +327,12 @@ static int dev_mc_seq_show(struct seq_file *seq, void *v)
 	struct netdev_hw_addr *ha;
 	struct net_device *dev = v;
 
-	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq, "Ifindex Interface Refcount Global_use Address\n");
+	if (v == SEQ_START_TOKEN)
 		return 0;
-	}
 
 	netif_addr_lock_bh(dev);
 	netdev_for_each_mc_addr(ha, dev) {
-		seq_printf(seq, "%-7d %-9s %-8d %-10d %*phN\n",
+		seq_printf(seq, "%-4d %-15s %-5d %-5d %*phN\n",
 			   dev->ifindex, dev->name,
 			   ha->refcount, ha->global_use,
 			   (int)dev->addr_len, ha->addr);
-- 
2.25.1

