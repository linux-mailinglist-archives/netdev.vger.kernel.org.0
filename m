Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501373D0EEA
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhGUL5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:57:46 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:12901
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231937AbhGUL5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 07:57:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Al12F50jzGJzQ3LlpvWxbXIpFr10fOrknhmHjYtDEXfUZcROz+RhpAffqxCJAeF+U3qna7VpbLK/lOY7DXIA5gSgy4A2yLCSLHz4y0ToeF/M6a0OUKFqojiyKaAFiin9oc4tPVv5EcL2vjxTUI4Go72XImLq7+VpbbvF8CdwztY3bex5jOsKXdWfvWO9S7iiIIUlruPTykYtRLDQAmCI18KYdi85uusm/Hsptb6LNybA6YuSIsrZ7WcudREnA6K6pTtK73zjLsC68uwDPJAOrQEIWmiArUvT+4a7eBJ65d3fpaBMB1oH0OXhE/+rOc7umQwsZK+seBeP9zoAg7Jd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vBZqUhJkhqSekzr+iGAUmSWcJ3H2e2PXKoHGWU8eJE=;
 b=c8mBzVi05D+HJIx7VMhh8sa8beSbnFYC5U65Oi/N0yUK/zCW2OIcVmoW+5Hec08KUJNg3l+aXI9VCsRcZJVln2fw7JfKZRchagPhIhN3v41pCnYL3c0mV85rwCoossbaV7yCS6paNYXs5FDBsxpxVQwoqavBZfOL0Ya73PKqE7oNLu/dxcjB/yKrYeeftKxfCQ05/4c5a8FM8ruy9qaWQsXxgbeyninTQPiIoisupi1DS7AoO8VHjnNw2FhW7f6JBE/fS+oiQROWy51BZA9u3c7ew+Fi+bsywDzytCZYIFmmT6D9r5EQkN2E7namJpr6sc6A4S4g88VXqU5GmjTwiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vBZqUhJkhqSekzr+iGAUmSWcJ3H2e2PXKoHGWU8eJE=;
 b=jeb7gBj+vr/W2zp3Trvkb2tfr602cZCXmXmiVjPZvJe5knhoxbIzOXavmM8NZQJ9rTpFStxKeWu9qcRaQeY802/2pTBKPyGAEifU+iSfOEy1ZDG1Cgqe0o/nAVli2IyOqcDE5eWLysuI5H2ei8/6YWiRS47iw2RYDonWiHvCrXU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5695.eurprd04.prod.outlook.com (2603:10a6:803:e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 12:38:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 12:38:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net] net: dsa: sja1105: make VID 4095 a bridge VLAN too
Date:   Wed, 21 Jul 2021 15:37:59 +0300
Message-Id: <20210721123759.1638970-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:205::29)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:205::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 12:38:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bce69f3-1984-4dc8-004f-08d94c446c0a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB569585DD83E62DAA07205EE4E0E39@VI1PR04MB5695.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uuYxKahGEGc4pDCHCC7mmn8uc0bY/DdqJbgNxGdQi6wrYVSN5pJGrJzTkwY9p4szf46y9uta0EB/H4LFvS07ZMiehyXewisKMyl1Zfg2T6+58iTNdZbIVc1psCGoFH5mOfbAMF5J1tsxOvR8e219CTTDRcs/eW2qQo6jzxey3VIN1w3eZtUUIPJEtJBt4P1W+GN6/63cDgXxGWcYQ+VU23jQieGjXO3637IrdZi4j+2WlJiTA2cZaWVrWdTszbc/eRBFMlee3QqtHI7G7VrU7GTaZZfydunzsExbel4yNJfsi/S2ZNDY9V6+/HMo4u2B+635vHRusJig9Zlr+SFqnzlGzKteBBFCvMQpJRgOQc/o/s6Nzki1/o6jqYCeY3HTsKeAp0hFvZEn2SiDS2R/ACMvARyGd9+khz2GUjGOkShdCsFNP5QHi4p5ctltmwepEoefuP9njtA/rD/HXBXw6FQduu391pHKYRmSdLZjJv0A8sixIXVzpqFaC5RA7libN8D3YctWnoH3tm3EY5C2ghXprUl/k8CHsIbaNwmveWG1nGqx+/9oN1BGeVi3tFQI+3d3oCAS66gfJWvsQT1lW89O50fb0Ej6f3/DzkppR7oQGQYKPvJHci8KBWPwyfUOMXm4hg1xkb5zIDo3050KWkVQhL/mCAkcNGckCFOCk4QsY8aAK7pr1O+iWQ0AIHjwHPzkREaMTnSQuZ75sGFprg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(110136005)(1076003)(66476007)(36756003)(66556008)(956004)(52116002)(2616005)(66946007)(4326008)(2906002)(6486002)(6512007)(508600001)(6666004)(316002)(8936002)(38350700002)(38100700002)(186003)(8676002)(26005)(83380400001)(44832011)(54906003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?utNfW+eebaqDxsWO53HAtHT7T+N1M+OUrcR1pHr23I0kBRzavS7lwbS1D8sR?=
 =?us-ascii?Q?7Lthd5NlG4XrDcOywFezzm5DyLK8hUIqBxZPV4OkJ9hdnUOfLGJnUrBAAMH+?=
 =?us-ascii?Q?M3scSNdqyh2Hpx3y0Gq32J0/3dFBjmcZZG94R4GA/M9EGjj+bd/ioVCj6reF?=
 =?us-ascii?Q?9BaktcQdKPr1G1Wy21koTWpT3270t4vqEN7R1KMzBR9Dp6S1n2Goa0egFlz0?=
 =?us-ascii?Q?iyvhN+5TEurauB+wK3LQv+BGb9jVJ+88wdYJwY7Dt1K0VZwJ2+LbBn7Nco5e?=
 =?us-ascii?Q?qf0XaS7hThTzyiD2UhpNAKzngOyCUbldyawPJ1zd0F/W38yove5gxedHHUsH?=
 =?us-ascii?Q?Uzpkq830viuCwiNJybqXBAByOnlRdqTXNUaOcsHg86mxNe6CzOTP8DQv/mrW?=
 =?us-ascii?Q?1h9wtk9KeZoTwiz5PMkI+HAWqbHRClz/DBI54Y2aQET1TMzMeHvcUB/ExkyV?=
 =?us-ascii?Q?2q3ovkHy8+e8jW5hPk+EXh+D06zgk6YvWHkxyZct+Ed4rCcBs31/G3AsVFxh?=
 =?us-ascii?Q?CR3CB2z2BekXnwVhLw1tfGHsqTwg3xHvslyiHYSeMAzTX598jUY3wE7VSdWj?=
 =?us-ascii?Q?yIsfMThAChxvy1O4NNVZeD7LSlbNML9EnKDUkad4c/4J+OWOjn7gAfEs6+Di?=
 =?us-ascii?Q?SRTRlBJHqpB1y8EjY0FdSf2SYfhWg5VTplN3W+L57Pb6QJ9yfTwaSA4Izbad?=
 =?us-ascii?Q?y51rh3+MPryT4byYQCmQ2abceygaeirbq7pi0NoDLvRX6tsoKqye0bKu/4JD?=
 =?us-ascii?Q?bvIRtMrW3O33q9k9CueCIn5yJGgcjBk5PXK3nxkU3ZUjcQi1SIcmeyuOOzn8?=
 =?us-ascii?Q?dcNCo2E2SjGS/fCd4FdJWMEdOkGyR6MDZA5RXHgf46xtLdoz0sKWHsUJ/SoP?=
 =?us-ascii?Q?E602Eq84Jy5Zw+uGykY85gyBhz+PzpBrlVGJxqEkr9X/Dmzj3iLMrdtHVkhY?=
 =?us-ascii?Q?TusnunltaysyKzMX7PuD2IfFgATfq8B2T/B5TY2lT+8kDKg+EsnByqDldcbq?=
 =?us-ascii?Q?Ph4fBWc/WRAY4b7cIhSXZAKu1UXqtetwqWs596jEF1VcS2TIgptqDOFoeFIH?=
 =?us-ascii?Q?RWwX0RoDq98d8Vx+cJJIzRTCIZZStznFogdJDSKjwMnjl29wsUzgY4WpV5bE?=
 =?us-ascii?Q?hjijgb5865zrMB1QPjRo4CEJzYn/WrcFuxZbdX0NyhdMmsKTvF/7XXDLnqjV?=
 =?us-ascii?Q?I3vTjDkRI6moso0SgCWTg7l489QLIu1vJBBVRf47L3JoFMcHXg9toFgCy+IQ?=
 =?us-ascii?Q?WVRJL9rZLzo7F8q4RyOXWKYRgTEItT+DMUQfA+8od4fdpTr03O3bSXcxxhUE?=
 =?us-ascii?Q?vyEtDPiK49cXNH0LMdDCjJXA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bce69f3-1984-4dc8-004f-08d94c446c0a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 12:38:20.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkOcMD9bzo6P/XDo2Zus1m55iLFo7B24GhK4ol0ylpyah8c2L+oTbgJos7zoTTOttB52oGGGtTl6R51juDIkqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This simple series of commands:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0

fails on sja1105 with the following error:
[   33.439103] sja1105 spi0.1: vlan-lookup-table needs to have at least the default untagged VLAN
[   33.447710] sja1105 spi0.1: Invalid config, cannot upload
Warning: sja1105: Failed to change VLAN Ethertype.

For context, sja1105 has 3 operating modes:
- SJA1105_VLAN_UNAWARE: the dsa_8021q_vlans are committed to hardware
- SJA1105_VLAN_FILTERING_FULL: the bridge_vlans are committed to hardware
- SJA1105_VLAN_FILTERING_BEST_EFFORT: both the dsa_8021q_vlans and the
  bridge_vlans are committed to hardware

Swapping out a VLAN list and another in happens in
sja1105_build_vlan_table(), which performs a delta update procedure.
That function is called from a few places, notably from
sja1105_vlan_filtering() which is called from the
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING handler.

The above set of 2 commands fails when run on a kernel pre-commit
8841f6e63f2c ("net: dsa: sja1105: make devlink property
best_effort_vlan_filtering true by default"). So the priv->vlan_state
transition that takes place is between VLAN-unaware and full VLAN
filtering. So the dsa_8021q_vlans are swapped out and the bridge_vlans
are swapped in.

So why does it fail?

Well, the bridge driver, through nbp_vlan_init(), first sets up the
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING attribute, and only then
proceeds to call nbp_vlan_add for the default_pvid.

So when we swap out the dsa_8021q_vlans and swap in the bridge_vlans in
the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING handler, there are no bridge
VLANs (yet). So we have wiped the VLAN table clean, and the low-level
static config checker complains of an invalid configuration. We _will_
add the bridge VLANs using the dynamic config interface, albeit later,
when nbp_vlan_add() calls us. So it is natural that it fails.

So why did it ever work?

Surprisingly, it looks like I only tested this configuration with 2
things set up in a particular way:
- a network manager that brings all ports up
- a kernel with CONFIG_VLAN_8021Q=y

It is widely known that commit ad1afb003939 ("vlan_dev: VLAN 0 should be
treated as "no vlan tag" (802.1p packet)") installs VID 0 to every net
device that comes up. DSA treats these VLANs as bridge VLANs, and
therefore, in my testing, the list of bridge_vlans was never empty.

However, if CONFIG_VLAN_8021Q is not enabled, or the port is not up when
it joins a VLAN-aware bridge, the bridge_vlans list will be temporarily
empty, and the sja1105_static_config_reload() call from
sja1105_vlan_filtering() will fail.

To fix this, the simplest thing is to keep VID 4095, the one used for
CPU-injected control packets since commit ed040abca4c1 ("net: dsa:
sja1105: use 4095 as the private VLAN for untagged traffic"), in the
list of bridge VLANs too, not just the list of tag_8021q VLANs. This
ensures that the list of bridge VLANs will never be empty.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Reported-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ced8c9cb29c2..e2dc997580a8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -397,6 +397,12 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		if (dsa_is_cpu_port(ds, port))
 			v->pvid = true;
 		list_add(&v->list, &priv->dsa_8021q_vlans);
+
+		v = kmemdup(v, sizeof(*v), GFP_KERNEL);
+		if (!v)
+			return -ENOMEM;
+
+		list_add(&v->list, &priv->bridge_vlans);
 	}
 
 	((struct sja1105_vlan_lookup_entry *)table->entries)[0] = pvid;
-- 
2.25.1

