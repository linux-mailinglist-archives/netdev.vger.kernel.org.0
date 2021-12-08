Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983C846DE6D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhLHWge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:34 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236053AbhLHWgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXL/C6Iz8wbnOlByyH/YlA+xMvSylBFEqHwyPQnNfq22YQxxuSlH+g/fGTcYr+5Uwaph/OfopguQ7Slt1wSu/qlFkVTk3hCXFi1hG+7NVfDOv5UDs43lMAFQUB8vVtHRqABXPNVw7rg5LMqp3yf2fwYeuyK1sLo+bh5cld1TWbcpu8eQWBlVYbKJUFecrtYOl5/r6DWFFMuQl3L0jtOUIxZc0gZWaWJiYMBm7IWq9nwAIfQMM+Fq/DrA+bJWmKv/YGSX408/mLuhGwyW//6P0MaoL6WyzoW2saFANQDVPFmiljK75F1UD79Hz96W3LtpQNbD86jm+kAge5xbh41SeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzrbH5D8PgZazCT+6xc5n4e0JmVOve6z4wfniYNJzjk=;
 b=ioXiIYfOLIO5Pf5ILB2lOczmmDJUtkdvonX9C/URUmOk2BFAhAKuCYbXKWboEZcPDg65Bpsb7ziwwHMI767DiSukQHYpBvWuyTJYq1rlJCj3FpKIPgdflcCwDP8E3BCzlJCqsFKq0HezKmVMRAIK7zJrkWCeDUy99WtStDzzzVQG4xNcqddY0IwZR1Ecc74fC7sFlJXvIjRXJdOwX3kR1oo5ten8fZx+nuPzUETXAWRHS8+GzQgA3nDcViNE81eYawrUeGrmfX75N40f6nhcDXUx8BRSaI3QCoOhxDrsvekZ+ATpsO+tLaTIDv53rxj9qZZPkd2vVbxpUc/hdrCWwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzrbH5D8PgZazCT+6xc5n4e0JmVOve6z4wfniYNJzjk=;
 b=kgZ4ls5U1HLF8EEPl1xJEHRNBkWHf26PjVyh17BVErSPDA8OJVrf6up0DbRrDW5PabdE3eAQuh9Sc+bs/UlS3rWnppUa243fS1XCPJYHy+6waDOCOUVfjFNZ/lbDMRJeFIrmezo7eyGndr2BT/Oh9iVxilEqlLZybHx5aewmNcI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 7/7] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Thu,  9 Dec 2021 00:32:30 +0200
Message-Id: <20211208223230.3324822-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35b5b4ab-dac2-4f33-b58a-08d9ba9aab69
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408B95097823B6B404368DDE06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CeYcbzjusjiefdZsehtBnN+/m8iuPpKx8OOAWBrdFf4kTAVdsAHtUzKgTsCktbLiCzfZuQJzfSCFoAMs9YxNP+UYeNFQh9RcKoc5bw7bkfCwYHjeWro6+CKaXclsZxy7JZfuEWLChAwFlfDB5v27KWdB3DG1hg4t+J4bXEYSM3H9zlEN1jodmR1zlG2IyUecN8bIJoyyOONaSt/y29Nr5XFrgDrrPpR+Qj3vqnbqBKXhISSPI0CN59fbOcVmQ1c2AVrC8z/xsFlFAX96T9fpkDCOzu8NF6/SU8FJJwtl4mNnm4IF85Jf8sRNzRG6j6lAaRH4tvIMwCQyO4+U4h7fiM8NAIgwocJ6aH3Su/uvXdjZnt8pd1+XSACp9PUUbY9SFIOxbXovqaSOieC63r8LN4X1HDx72yXZg5ZfJQxa31wJEAU5XbMkzz2hC5XJ8FFUvDHk159GplA1Xjj1vLw9DUchpIedYYMUt5JHSCns1+dNyk8qV41yKrSSI/MAVDIeSycoLdsJySpUvXfJqqlDJfOwyfhWYQkQg+/MtXII3/987J3ayxqWc18VrQaJw4KU4hGoyLzUlLIfzzhlv0RpZKkqfzJCN3kLP7pX/DG8r5Sw9UK7lL3ZrVU3EIkARgNenF3gu0dPodWrXhVMkrdwMZvZ3F2XKQ6r63K642sXaphM7UZzok0r1YZdoJmx12SxaOOZczNR1QXdNi8Y141Bqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?klLYbVoRXEIKBO7XoVJVDrMQ8spby9CL3hnb9ELPIw1QPGF0rl4zgdQNOMyn?=
 =?us-ascii?Q?NuTf6QwrppZvxtuzFxk3i5bYD4Xhv6G2WAaG3TfoMr/jXNy0LaArYJBSfn8f?=
 =?us-ascii?Q?i2XJlvjoO7ahPrHBwMYvv9F1P3zzIXFzU7m6YQ4Oivyt+jTBK4LQo5OujJt4?=
 =?us-ascii?Q?Ggj6CTf+Yfb0CG1h9dHGchlZI8ft/1v+3xYdhZTCyRrkZih5F+Urn5s2ScG2?=
 =?us-ascii?Q?lmdPxDMq5OdrUh6eUJTcC7PvDp8dG/FEuxNrxX6cJtbYpTQxQVNBCvZA4qTZ?=
 =?us-ascii?Q?avf2Fuz3kYiJSXE5oH1rXO/kVYFmXaTEew6HP2IJOdZlfq2qNI4zUWtX41gS?=
 =?us-ascii?Q?LGQqHgHsSl6wBwiYU/Imo08di45n3J088WT+MsSA8agqvIsnicdbm5unYZIn?=
 =?us-ascii?Q?FGw6/EAiCv12HdqkXqOwseveBGBTY7xr8/X77+NXJ1Hqs3I4L61kGrrYi45g?=
 =?us-ascii?Q?NsyTmVfpmCGTrZDwF8HRMgS0WmgPL1dpcDQIKGOBAilJ007HfM4i4ByZ7LU4?=
 =?us-ascii?Q?1WtBk+X+fiKFVJUm5yJk3Ccd399f+lRm+W/UBJV1BWm7V73cqf6Bg5cShpJ/?=
 =?us-ascii?Q?sIImS4VTqpxkGPHc1ZcduNqTQXaUyQxldR1xd6m4mbRbbBavjTirBn7LvasK?=
 =?us-ascii?Q?s5FiOL2qJ2B4mRB+FVJjX+jJTH58ZIltnwNnYTNgFUR6z7x8TTAb1CccCuri?=
 =?us-ascii?Q?pT+LTuhQTrm+wIRP7puWLeoKwqG1qkTgJVyjyRHA+NtYmuFkrjOEvjnUkrRQ?=
 =?us-ascii?Q?CtGegJqlhfFa/qA9Szk7ja1onv9E/IjlZU65ZfGQYUY1W4EzHVoIxFYOjfsb?=
 =?us-ascii?Q?E+RtBEhLUWACGtRJVudhkXqmWxLCV98OsCw4jhnJQBkfRMTR2Oz02PoncuD9?=
 =?us-ascii?Q?mO/2jn2hXBvT/0KALdUIK6XWB2A0O55Z1y6Q9GS3IT8SrW/Zi0Ue+WAxgwN/?=
 =?us-ascii?Q?mMlWt/rbyT8xAZMfym7qrnCyVc9gBMkVnNnVznOIGrSRfwazXS1GJ7saHfZx?=
 =?us-ascii?Q?pc+OlR19fG0O41SpHspKotAzajQZDP7jg5AwxnXoB/ArBbNYgUN6bCjcU0uW?=
 =?us-ascii?Q?a2NH/fOkTvUSmwwPPNs4a9hn6p3DQTIgVuDX4yvoqheNxCKWHIGh9zDzttY6?=
 =?us-ascii?Q?dwf1YNQ6DSqwaLEVvQntAv4FeU8y8ijQ3B3xqmUFXHVrE3StRJT6UJRGFmte?=
 =?us-ascii?Q?mL5Ibn9fLWdewqD48gPeyg0AJ4ItzBmmrrFgWyNwbip2a+Ph7Xvx0TBv+1in?=
 =?us-ascii?Q?JTwgcmnRVs/iZyQJI/bTmDQkPrqWlQmlAnv+X+/g1vqe5W4ylRbjD0EwO+9m?=
 =?us-ascii?Q?BH7W6JcmZR/ey3Td/1HY3zNiH3zxOvRkhYzmfxgDJBYFi2Z+3CArKS7b8TIh?=
 =?us-ascii?Q?hWjLqOICjptq6vJW2xznBnivGM6SRhonQZee1rz/18ehIQiPyAtRxzwTXRy9?=
 =?us-ascii?Q?8isL9zTJKNShCec/RRM3+7mVfw8S4JH66BXD4AMZd/HCZ4fZvzR0MxrIig+/?=
 =?us-ascii?Q?Umn1BrHLRpCZAFLxu8Xl5PAT/Ji1AvvjEqhDaUO0pK+g4agSuv0BoQyWax8H?=
 =?us-ascii?Q?n5fujBuYEFtn30EtjHz0Q4cqmsQnVSk7mCSEVuXFKAq63rCibjJAeeJ6Ofjo?=
 =?us-ascii?Q?keIur+VCOVJiGT/DfFUgqDg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b5b4ab-dac2-4f33-b58a-08d9ba9aab69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:51.4916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6I0rJbt9stwIqKEZcdgtkv2trap+nuKf7540xdEdfq6X/JWxm1oW24fbOLUTOmb1QH7+NWpG1ItmJTgwOnfzhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for switch driver to be able to make simple and reliable use of
the master tracking operations, they must also be notified of the
initial state of the DSA master, not just of the changes. This is
because they might enable certain features only during the time when
they know that the DSA master is up and running.

Therefore, this change explicitly checks the state of the DSA master
under the same rtnl_mutex as we were holding during the
dsa_master_setup() and dsa_master_teardown() call. The idea being that
if the DSA master became operational in between the moment in which it
became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
when we checked for master->flags & IFF_UP, there is a chance that we
would emit a ->master_up() event twice. We need to avoid that by
serializing the concurrent netdevice event with us. If the netdevice
event started before, we force it to finish before we begin, because we
take rtnl_lock before making netdev_uses_dsa() return true. So we also
handle that early event and do nothing on it. Similarly, if the
dev_open() attempt is concurrent with us, it will attempt to take the
rtnl_mutex, but we're holding it. We'll see that the master flag IFF_UP
isn't set, then when we release the rtnl_mutex we'll process the
NETDEV_UP notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index dc104023d351..abf385852bb6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1022,6 +1022,10 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 			err = dsa_master_setup(dp->master, dp);
 			if (err)
 				return err;
+
+			/* Replay master state event */
+			if (dp->master->flags & IFF_UP)
+				dsa_tree_master_up(dst, dp->master);
 		}
 	}
 
@@ -1036,9 +1040,15 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			/* Replay master state event */
+			if (dp->master->flags & IFF_UP)
+				dsa_tree_master_going_down(dst, dp->master);
+
 			dsa_master_teardown(dp->master);
+		}
+	}
 
 	rtnl_unlock();
 }
-- 
2.25.1

