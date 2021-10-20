Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9CB4351FA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhJTRwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:30 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231148AbhJTRw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esfAt2MJ5xsWhjxQ9mE3/ctn7Y4Y0ogsOD46Gowes8Zu8vFqTn1xdUM7eNFxSYKwBKtvKp86SMmFuFvC02DRTwM7z5q8g2MivP2zS5aAytj6OzCg2aAQ1Fd5bH6cRQmR6qx4Aw/7PiYQI5gohXWbAB/wwaZnuNdRojFsA+gxpbkpfQSk6GXfMCkTNIZi1n+GpQOQskUg3U4brQwDF3n+TgNtAIz3wfdLGiDrHWIdaqeM6BiaHu2I5Y4yA1BP/CUKbGfsiGuaons42Y14Qu429oHCDOP+4n7WrCUASHbO/NkQsluYECJ2TtuBg+4mlDhFnFF+atCK7ib7qgyJGAxWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9O4AB9bc+PAHK8Iq0XTE9ArZroQOMI4mz+mXDD3b1Y=;
 b=RM8HPOx3uBfvDadl5YnIchu2ydzPLH9nX9rPIo8GYVeYGFyCRJ8+Bs+tfV4wYkLp49Y1ufXRSEDdcDKhHZ5ly+H7xx2WczQ1ZFbq+1HGrzLrqNn7rQ+1pSfFL6VG+ofvO/dToLywPVkdJo7vw6Y6Vo7u6Gy4h/8jeWSby0CeVVtDJTFiUIaM+p8x0jtQpnIqKwhlu9E5ciV2VTl9IO9aRldSZt8n+wwQcPlnwwy8FztW/IIKOFIWEcoh0Nkblomg0stU9wwgvvMwdQeOOgJxczkBqPUbVvVHEYdMPchjs+KNNgoWO3fLyiVuNh/kg7MAu6XGQL60NqhYk+eUI5TyKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9O4AB9bc+PAHK8Iq0XTE9ArZroQOMI4mz+mXDD3b1Y=;
 b=WS1dJdyZvDz2qQnyWi2CvVcdVQHDr+qXMWFR4IwsUu7QcAAOkCSUOH+hufy/qpV0oYfFXr5dhP/lldFWrR/wsIap5EaMsccWdwTaea05IQcDjNWKWudjSGgmrxH+sCRbVG2LbNa/4PpAjPIwlZYx59Cj9Orj7iqqJsImkC89lt0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 0/7] Remove the "dsa_to_port in a loop" antipattern
Date:   Wed, 20 Oct 2021 20:49:48 +0300
Message-Id: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed1f867c-bf05-4e97-a95c-08d993f210b7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861E9ED756A23EC5851CB54E0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AkiL7kc1hD4Zw81Vc3zcZr8HefGLOP68ILoi+BfwS5I4heP5ZIVKJnUcFLKY5YXx6Xp47HDIo8/MNtdpsGeehASW9tEis2dbyyNExX4kZsCpue/dtMV8xj2ViUpHFNXvkucQlLX9s1Ln1pjPpNxmlIh2pALb5jdhAMaXnRx6D+Pf0nXUUwbFnDO5fV5lMsiB15GH0/Wm7SrQXdRFu9QrwGf8mKYeV70WuFJpqWkopxznMpRjf46z1pXRAzX1yST2xtZSpJQguRrgtThlbzpSZ73w8orV5+0tJg/N9cJ1xhkpIymF/94iinoR2bD/0gD8qXfnHm2Oxz0AHgGh15a/Zr7/P93dJ/y05bGVWqmczY7wn8wOzu1nNecylEsyjWhjzeG0M6Hg2D/mBw6StLbuQhzmxc4hHbPfmYkKh2R1RjOP0mJUjtBJ7oUwIPKPeElVo0JyZPsP3JNZBdFqUjxH+uauQD/aSRyUHeisk3eNJWiLvqgt2TCS+XrpiCIR7aoLq0fvxxtnNhaMd1lX+AEMAULKggak/l/MjoJ15W/pzjzuRWD+Yqq09NZ62dnCKdjsgDMV/WnyQIclkSwWKxxdWkCXqkxKiGmrqHo7aGJkm+nx06pYLPJr9BEGUXlUmf8GyCu1CdcNLs2isEg0TXjYr5Oa1auIsFbqYT2yZ+Ys7+Er1Dc23XbhlGnkp28N7e3qE3WGz6pZV/0GKiRZQGkG1N4yRv+o+cPQH0f5YknDc117uHKpvL4ZtNkL2H3Fkq2JLxALbp07MO1koSrwSVv+P4UiJRoE6qPOO9O+4aAd/ZXizdDWQHF41/DxrW7ZtWsYcTN+9liazL40cdvMlqh1tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(966005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/WYiBwYmfp/wmtEe+/bR386c+w+pUrbpXrSkSFK0KSQymt1EG15DsCyS2zQn?=
 =?us-ascii?Q?vep9hPWqIilUKVLLYTr0b6dzovlyT5fHnQWVHGguwnj1M5Odon/ZvJEVgw+u?=
 =?us-ascii?Q?WQgzeUNIkjJ7qSHeV30A7k4lOaD7DawRAyRC9D0azh7m3t4SzsG96pJh9C/8?=
 =?us-ascii?Q?3jpaIoey4w4w3xxGQH86LCBes2p57OZFCope7oWHVtgI2Up+ANWubbdQIyKp?=
 =?us-ascii?Q?jtUI/UUfcALsp0WFBRpTR9Kx2zyEOLQQBq1lUTdsxTy8SchpwCNzhoUoMKf6?=
 =?us-ascii?Q?ZZzVVHWZ0YIhR+VPCKR3s9t1fnFEp3cIHleW1+BGATSD+63i70aykjaCV+0M?=
 =?us-ascii?Q?OKEvuQ+XWwgjcQySCEmfQZ+Txg8OjBXxwUKlZ1oV7EhA6mzxPCR0CL/YRWXO?=
 =?us-ascii?Q?m2R5I18IfmBbVMWR6NLxnKx+FlhiiVsyZ9lA2Vl95dDYrOQzPGUDMYRu+mVF?=
 =?us-ascii?Q?EkBymqBnRZXqgoUW2TXE0NCxu0dKCEXbIzmXZwf1+NN3jgF48ljoGNJUW1PK?=
 =?us-ascii?Q?gnXFwqBjp5pe0F4cr/3ndcRPULLfyXj/n8y0mFK+b4mtuDC64SfDBCQQM0yI?=
 =?us-ascii?Q?v11Z/tAfqvHfIW19ut9hiLme4x69UE/lNASsbEDGqvy/spnea1uGmdXx8L4S?=
 =?us-ascii?Q?CVPPmX+VVfGcFp3wS9axjJ5hwVWgl0u+xHZ0UD6G0K+mdwzUfzA6hcP8qevl?=
 =?us-ascii?Q?M4MmARffk6PFpvqSBh9yH8eo6YJD7kGnYjLksEhc2Dh06klJloXV0Stb0F+X?=
 =?us-ascii?Q?xDNrBK1Q3nlxpwPMSxaYyaoOFwvfYF1RvwMYMGGBCXlCSiyadWMjFYab0T/X?=
 =?us-ascii?Q?Ogysl93AgRUvfoRFYq/6z8QyNAyxrlMUqUt+6QGYJMWlqStXEvV8tdOR/Wu2?=
 =?us-ascii?Q?2owiIUdLMt48yQpQnKGUtm/WTcdA0G5W6erzE5QNZEcDzYtx6QrWSr/b2BMM?=
 =?us-ascii?Q?66U4MaIgTM666FeBHxvi9vYbmynmDDnSZVy4xzkWo4Iwvxru1EnW0MxmaPG+?=
 =?us-ascii?Q?jZG+yNRuID9eoIvRUcBg+DzVsZ8c2l/rSnRupiFA1zuC2g7YViY1Yn86UL2m?=
 =?us-ascii?Q?L9iBdf9RdvonHkEESeul+4Jyw+DFWO/RFHCljVZfZikSbOwF9ClMU8xfl6k9?=
 =?us-ascii?Q?WZctxtFWhHdH3tMrnwcK4n7SPm00CyRk9VtFBnCcm6FpxHV8Cd3K4OUJNhj9?=
 =?us-ascii?Q?ey+hvvlkItOtSmypxEU70WfBdR5IXsVJOYo4JjF8aJJ/0ID9SqfACpwagkme?=
 =?us-ascii?Q?wXRdBC9UwzT1Ks8iGJM/32Pm3yo4+SHfKKwxcmKBFe8klIgoECjcxxecDviL?=
 =?us-ascii?Q?OlOD9YKfa6wIeBKhPDRACCq5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1f867c-bf05-4e97-a95c-08d993f210b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:12.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZrXS380cciF5WaPXv5T0E1/t+weqTx3dAtWlUyoKmKa4fYuHuuZSpq0tQwYpPCTM6hnbz1MQ12bJ51eWUBSSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed that v3 was dropped with "Changes requested" without actually
requesting any change:
https://patchwork.kernel.org/project/netdevbpf/list/?series=565665&state=*
I suppose it has to do with the simultaneous build errors in mlx5, so
I'm just resending now that those are fixed.

v1->v2: more patches
v2->v3: less patches

As opposed to previous series, I would now like to first refactor the
DSA core, since that sees fewer patches than drivers, and make the
helpers available. Since the refactoring is fairly noisy, I don't want
to force it on driver maintainers right away, patches can be submitted
independently.

The original cover letter is below:

The DSA core and drivers currently iterate too much through the port
list of a switch. For example, this snippet:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_cpu_port(ds, port))
			continue;

		ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
	}

iterates through ds->num_ports once, and then calls dsa_is_cpu_port to
filter out the other types of ports. But that function has a hidden call
to dsa_to_port() in it, which contains:

	list_for_each_entry(dp, &dst->ports, list)
		if (dp->ds == ds && dp->index == p)
			return dp;

where the only thing we wanted to know in the first place was whether
dp->type == DSA_PORT_TYPE_CPU or not.

So it seems that the problem is that we are not iterating with the right
variable. We have an "int port" but in fact need a "struct dsa_port *dp".

This has started being an issue since this patch series:
https://patchwork.ozlabs.org/project/netdev/cover/20191020031941.3805884-1-vivien.didelot@gmail.com/

The currently proposed set of changes iterates like this:

	dsa_switch_for_each_cpu_port(cpu_dp, ds)
		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
						   tag_ops->proto);

which iterates directly over ds->dst->ports, which is a list of struct
dsa_port *dp. This makes it much easier and more efficient to check
dp->type.

As a nice side effect, with the proposed driver API, driver writers are
now encouraged to use more efficient patterns, and not only due to less
iterations through the port list. For example, something like this:

	for (port = 0; port < ds->num_ports; port++)
		do_something();

probably does not need to do_something() for the ports that are disabled
in the device tree. But adding extra code for that would look like this:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_unused_port(ds, port))
			continue;

		do_something();
	}

and therefore, it is understandable that some driver writers may decide
to not bother. This patch series introduces a "dsa_switch_for_each_available_port"
macro which comes at no extra cost in terms of lines of code / number of
braces to the driver writer, but it has the "dsa_is_unused_port" check
embedded within it.


Vladimir Oltean (7):
  net: dsa: introduce helpers for iterating through ports using dp
  net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
  net: dsa: do not open-code dsa_switch_for_each_port
  net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
  net: dsa: convert cross-chip notifiers to iterate using dp
  net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
  net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument

 drivers/net/dsa/sja1105/sja1105_vl.c |   3 +-
 include/linux/dsa/8021q.h            |   5 +-
 include/net/dsa.h                    |  35 +++++-
 net/dsa/dsa.c                        |  22 ++--
 net/dsa/dsa2.c                       |  57 ++++-----
 net/dsa/port.c                       |  21 ++--
 net/dsa/slave.c                      |   2 +-
 net/dsa/switch.c                     | 169 ++++++++++++++-------------
 net/dsa/tag_8021q.c                  | 113 +++++++++---------
 net/dsa/tag_ocelot_8021q.c           |   2 +-
 net/dsa/tag_sja1105.c                |   9 +-
 11 files changed, 224 insertions(+), 214 deletions(-)

-- 
2.25.1

