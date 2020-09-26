Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB54F279B6E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgIZRcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:32:06 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:45635
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729870AbgIZRcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:32:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDuQ9nHxKBObpTxfd+JvSaLfLwGG7JWsbKMyrcVjjCMmBvQHpkEqs9C17V/dRc2NX0beCvr4aUvUErBr2QOSOK1fZJ8i5VQUigWeflK7B1FxZWoCwJphNM1QIpQ0nAZ+bo0m8prrZEp+GGgpR8ZnT3OtUcY+Fc0P+hy0ZAb8l6sCLwQRJAI6EmDHUOWaCQN1JyT9/b3mmR6SITgWuP9fEeEwKUtwUY5/pDuFOg7YDRTZl0NaF25UC1mom/18HsEgaHcPS/+jbDXDsXIVLPlw50NjoVGOooyW5tP+1KQWMjwfgaCI2rst46Cy/jXqg5QxCagSgI1rXpsYcgGc/aIfxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvY0g6DBKQivfiJ71jD2gdK5r71qUnUlvUONB9y20oc=;
 b=UOnmZNgO2wPl51b+TunELk0inTfhUtUY/hvl6m/hjSyCTKP+MLHJMV59gDPbRAghfwUwJwizZ/FD6ISH73oZfvaagjbTNJCuhqtji8JFj9oewNT50Brbi0mYVe+rXN1Y8zWigkv/BT7WF+Mjr1qoij3Iu0LPrE3Xe1y5K/MKQPlMUDbaOCfulDTFoWLLpishDPhc9htZMzMOEXPAa598wPtgRG/4OsMcWaEl325srEkLZ+72yQeAT+mSZIyOmgZVHXVGZUVGnLqU9S6lv3Po2R7g40aeg565o27Gpxv62DWOQ3oFQjmyugJZpGiVWaixXOioH6pDTgLmmikeo3FGQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvY0g6DBKQivfiJ71jD2gdK5r71qUnUlvUONB9y20oc=;
 b=It7Bt3hT7cYVqvSm1Gf7vX7EE72fMgWOCS1AwEjKTNpe3n4lX+l//wWo/7Vo0lt+WXPpKaJxM7g8WnL4Xg3uR/63SKBpydiPbr3TN+iBDmt3b6+o2sj6L3mUILcuR1aL2wwEK5XmqzOtZUHa6HwU9wOvIYZMh5XAlcqHnulzFIM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 03/16] net: dsa: sja1105: request promiscuous mode for master
Date:   Sat, 26 Sep 2020 20:30:55 +0300
Message-Id: <20200926173108.1230014-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbbb230f-ac17-45ff-2748-08d86241fd13
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640E7C8A80070C38AEA2E1CE0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVbsfsBY8Bna+w8t8HV3RNU7WHsRsGip2+rf9iX6KbkVMAdsYC0jd+kc3Jl7Ja7UJ/zzJozukaIhMnjM3nnZfAwOQRnwdIYxjh0KC6ZIuop6McFHDAQWHhfSkizWBuGjULCgHvGz5WzJMrJ1mLCR/V+7Lv0mUaUl4cB5LNJ+MyGgY2WJG7DhUHkUvn8Bt58GL79BdmfRgvHMvsDN1fVpkgnuQdGuGa0zaNDvdgSe/s1/rzWhn5X9zCjrmxvazjPYwwEimsxUXnG1uJPfi+Gvi79q9dNO6+tDbMd+urodSa1VDuE5wOUf5FCzgmz80zq+An/4lMUzfaTX4MjvY3m7mIAU5b890lXVLdyNTfFBUcMAVC219xjqySeTggVuy6fSBXKwQF4Yh2rtSGL0loEc46ZI4fPQX4HPDtkfBlPQuqyL/m5/3vNmjdoowQLSPanm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(83380400001)(86362001)(6512007)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wVq/8xFkijA2/2mDa4UQnnDA/jBIFhUeO9nc3RzNfbrXxp+N/HT3SbLAh7Evb5+TmReHyt0hqkZi5vmDzmDhAu3GdD1tSlK/A4++5vt4lm4KMpl2Mjq9rWgVJBWkWaAglmrRDNWgNU3LwXByRGtEkrTg1z093wA2agJC8/bdo12jA0I8VZyuoeYhN9G4Y5WWb5tcS7Kifx6IeHtuwyVA/RBCajm7CfMY8xsBqpUO4CSPSuEBk8kfW70hxzicDFZAt+lhIONrpgO/Fp/tn9PrD8sNCnRWcw8axzwk/eDMQ2tDmaUBZHYSN6fJMYwh77pkiiM3sIgjKD1TWQNXYB49gmQpCxYbj8ysbKgvJ+/PRoeC3AkIEStFy9o1A8YiX7ZhyEzJdW2mF5qnh4tJJO0rrIWyLjoiHV3/byOttysQxOFa+OYlgTsByN9De8uyGa81Zj7iNDTD8EdXvUeGigHL0RI4o6F7pJVVg7mRe6mtfM38zSH370VRgHkx9FAfjNy/1k0kdOR83T8EPHK5UUeWRUIBHAeUCCU+BUMxinlTxNaiFP2oOyhSX97R+9Mv2o7GLiQ3oGLsWlw1IbWAfE9+3S+iuZX9Unn0o1ZQby0vt3TPFbcJl/OCQte0FBAXpJOPuQMkdZZCTroLbFVKu89slw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbb230f-ac17-45ff-2748-08d86241fd13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:23.3181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nt+HrbEhjjogSJN7PFa1wFFHHKSENDQIBk1Oi86eT3H+OkSADlAEf3x0fdz+uLlFU5bj+HgyZbcg73bucHmXjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
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
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 547487c535df..626902b54ce0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2914,6 +2914,9 @@ static int sja1105_setup(struct dsa_switch *ds)
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
 		return rc;
 	}
+
+	ds->promisc_on_master = true;
+
 	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
 	 * The only thing we can do to disable it is lie about what the 802.1Q
 	 * EtherType is.
-- 
2.25.1

