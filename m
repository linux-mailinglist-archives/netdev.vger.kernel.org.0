Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A839B3CD620
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhGSNMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:12:53 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:60704
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240741AbhGSNLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 09:11:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wt7s+8u3qqOhBgy7EMT9A8J3fyRCAb/AwU3FqT0YOZNtuoOOn6GhgZnZu5xxExRnsbk50ZtNPEkFJusGusbiR3osDKfhy7t/e+QhDScNDe2tSPtGnUToDdVuWx4MEtH36/N6CDewcDypQpY4zXSTLl84VBa0Bx7AXN+PiXdXGJUEDuWEzY/jE4NIpwpJwddQGXNawxKfJoPPNzTCv2gc4VtxVqKElzCVMNt7KVWoI1c1fyErEvcQPUtnmfCTa+8ABq9L9kCbtNlSvveVuWjt+c4R6JH8JiPZeV0lt0APpqiJminUPavbfmtu3Zqe7Gx+dM+5v1tpCANq18zSPH12VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agdLMeXNj3vtQdFOSwcUfVCjKkjkOOZrCNaDnKJJ13U=;
 b=Es5P4VDAvm4LHtCnGdjpa+hFndt5GicgF2DckWRMXm6r9QSdgihylCKcJY8dGiLkrfukssNcxBer+7NhIKeLzN92GPiyif/E4Zgtif4hCQr8WH0JOhacVxvwE/82TmGtm6WZYCBcRO5UWwaF2cmU9B1YGzMWKNnxk+SI4KbbOfjk3xp6FRn569F7htiswIyxtU/sI/v6hw5U870FaX9SaF2ZayZvnstZ+E0y42g6b5r0z5rspUDyMZSdgAHusZB/7wsSggPfu3YEnT/5lTc32SDd4qb4ZeVFncL0y5au+z9n5Kau4YzBEsIJC46QzitTgL1Tk7PsJGZqDucctG4PRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agdLMeXNj3vtQdFOSwcUfVCjKkjkOOZrCNaDnKJJ13U=;
 b=fYF9+Wi4sJ+CbxaPpQdKGgHTWWHWrAF6PPei09eM9y544d0HevIhFGnYWFQENDzZOAP+teWUqg0yH7cJhsx+0Wk5hTdJywO1rcUnj8ovAnrvbkFVwQeGIU88597ssipGhLkpy0Ck0Wrfi7lERmLMJ42xGqSXC5LTRHlDbmcLa8Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 13:51:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 13:51:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 0/3] Fan out FDB entries pointing towards the bridge to all switchdev member ports
Date:   Mon, 19 Jul 2021 16:51:37 +0300
Message-Id: <20210719135140.278938-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 13:51:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 875b1664-f366-41ab-0a63-08d94abc60ef
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471D5297A13202C3A8E489AE0E19@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRY+phvvAox5nbr+zn5ZlRGHQqp1aGuJXenQwA4rfJ2eZYihzXKuQgTTM9KFK2Ju7xTfn75qFz/2EdbY0w55avIYKA2Am6z/3S0G+JeYdgBhsolr7oJ9bUMfuIoqA5egHuZdU24808jcdVBS3RQh00TbOZGIaSFoIInrXl5yonmRA58vsnQXb1Vp7luFaFgXDOiAAmeTlqwslv0lD5e00fhx+ETd9qvJ5RyNwSvahlR9jvzcBTdLgxtF99zZmQ8EDJ7fc9X15FtkGHQyutfAgksZVn4Ehdr782sU45AWw4O+6+eFOw69BJ98LDQa5z/96iyeIVJK2FqNa00IBCxFFLOi5HKggd/UH21KqQj7kQzPI294551NyCHUpqauEttmLkecVdwwGcoCqh9OKpNyLFVNTNYOECFmhqrUs9ROcPgxivWuCLFHXHJxViQP23Q74zuL9uPYX86xY+/8d17kIYQ2jxn96aIl0ljvHwWCQHCMKl8MtnOEmVT1aDokz0xUvOgj9QKse9bRo3ZiNBneu8cWUVKLpwh4gMmn9XXB6WpmfGjc22NP9TX05OrID8p2MGW5g7QVe/oNv3pZnOFgRlE6la+tgaQI/mtiLbQOYJzAhzCcM71vFDPmFBdRXrA+/ifO50XUdB6dqSEfdP9nH4YGatWp7ITiqqoujVN2KKwreMlwSh4iKtnp9tq4R5o5VE/aiC+nkZ/Yo1Rv6LiUkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(6506007)(8676002)(7416002)(1076003)(44832011)(5660300002)(52116002)(110136005)(316002)(54906003)(8936002)(6486002)(66556008)(6666004)(4326008)(6512007)(36756003)(478600001)(83380400001)(186003)(86362001)(2906002)(38100700002)(66476007)(26005)(66946007)(956004)(2616005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tJLtwJFdRMnyGAMuH6XaWBrFqsxnswbRatYl4a9F81tMmaTERQHUDYF59QwN?=
 =?us-ascii?Q?slzPpDIF/6LKD6XFKVQ5OJxfdqFG69cQZcvBSMmZWKEvgY6HyO/SI/cndsPg?=
 =?us-ascii?Q?heYuvPDg9oNu/TF8REik/Y2zCVLnPgdbJKSEmebZ4e1xdacMs+yBnbJK7Skc?=
 =?us-ascii?Q?MvEe4PgUZt9IHXCxDJy6uiwL2pT8SY8WMzCevn6UaH16Dh1iIyl5EtXkPngL?=
 =?us-ascii?Q?P4kuopDE4qD4i2pptl6Y/DhypMXKve1jVABveZRGvFeaJsR71kG35Ffh2H3k?=
 =?us-ascii?Q?eEmfPoOR1pI505O5dnNDoE0BFViG5aRvY+cuHflTpTxqzeqs/xOL+s6lTgjT?=
 =?us-ascii?Q?hDvjaar8FKGtubYbw3BiFbjLPcc+NYMIz1aFjzoiBkMwcmxeEhgC1OLgW9It?=
 =?us-ascii?Q?SZy8zq/GJbDH5JCDf9dwld5O/2+2ZpzpDt6CQwzg3uBAzZtBlCpoeFgcxQPM?=
 =?us-ascii?Q?HEAFBGaTUxEWEhmSsmqmcBjWQG3nC5jtTMVuWEI47lH7zn1beK90d5HsGeAP?=
 =?us-ascii?Q?eWuSXuwpd1l3W7qTp/zKxux7j5Uh8M9nE0BXZwSq2rFuZoS+LYZV+57dwznR?=
 =?us-ascii?Q?l1O6OH7SL8k4VArhLVojSpSFO9W4R5KNbjDyTD1BDDKsBCVECGKZO/4gjZeT?=
 =?us-ascii?Q?N0SiM1EEK+G2gDhxo3tqgvLlBLP3+fKbH+8Trpc/PQhDQrp+7rzZazKcNSWM?=
 =?us-ascii?Q?GWiQJDzzO9S7aeCl0RGgaWi9JxbX7Sk/9bp4aJmJqYZx96DrfPWcc7UfL+iF?=
 =?us-ascii?Q?opqxNxou9vr0e205IC6zMGNV8HNHusXwhj7ogjNxP+NxB4x2KhTAYsaXuK2p?=
 =?us-ascii?Q?CP/Surx7i0+I5VzNo/84c5EyZMbp3HEfseLw4bXUTxPYR8f8UtSgjmVZRidL?=
 =?us-ascii?Q?8uJBBNKAz5i3A2qvQJnDbvw+GSm9g9VeumAbJwTeBQ2Zx0jP9udRA0bogHud?=
 =?us-ascii?Q?YO12dCDOYRtWrW44i7wYjnaoVhAcWbVCW7ia1bqHa3LKOchCx7LsWq/7bpHA?=
 =?us-ascii?Q?NlugkVTpcMskCxpZhrlmJ8cs/BnaImWq6xNAuwjAm6pY+DBcnj1SK3V+zhVs?=
 =?us-ascii?Q?xkR+kx5lnuefHUxlaaWH78xoxOhbMmjW8EsXkifMOsUJ6WQjnYAseLqjbJf5?=
 =?us-ascii?Q?PG8kVabAS+hTeS4EuVKBtHz9XXjDLkMUXsYiYm3zkPcQydinQduPI1z9gqsK?=
 =?us-ascii?Q?jKtwwnG8VJspqsawwsdU1keOUTS+QXEEbtLSVcmgawKcob7YILUk33fvXLXN?=
 =?us-ascii?Q?Cqsqy/H2+2wvI5ks5cTLMdaphROF8mc4xZh1X4QEHVK26U727O4q4d6aZ0ti?=
 =?us-ascii?Q?4fioAC7ZtdpK887xpbv3afm5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875b1664-f366-41ab-0a63-08d94abc60ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 13:51:59.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRfm+kkRcJuW6VDqRlsbvWtig06f42rBbBK1kAvOyA7GDYQr7/1G7w7k/GHi/oKHRYyS2M0Qjau3F5lT4MqNpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "DSA RX filtering" series has added some important support for
interpreting addresses towards the bridge device as host addresses and
installing them as FDB entries towards the CPU port, but it does not
cover all circumstances and needs further work.

To be precise, the mechanism introduced in that series only works as
long as the ports are fairly static and no port joins or leaves the
bridge once the configuration is done. If any port leaves, host FDB
entries that were installed during runtime (for example the user changes
the MAC address of the bridge device) will be prematurely deleted,
resulting in a broken setup.

I see this work as targeted for "net-next" because technically it was
not supposed to work. Also, there are still corner cases and holes to be
plugged. For example, today, FDB entries on foreign interfaces are not
covered by br_fdb_replay(), which means that there are cases where some
host addresses are either lost, or never deleted by DSA. That will be
resolved once more work gets accepted, in particular the "Allow
forwarding for the software bridge data path to be offloaded to capable
devices" series, which moves the br_fdb_replay() call to the bridge core
and therefore would be required to solve the problem in a generic way
for every switchdev driver and not just for DSA.

These patches also pave the way for a cleaner implementation for FDB
entries pointing towards a LAG upper interface in DSA (that code needs
only to be added, nothing changed), however this is not done here.

Vladimir Oltean (3):
  net: switchdev: introduce helper for checking dynamically learned FDB
    entries
  net: switchdev: introduce a fanout helper for
    SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
  net: dsa: use switchdev_handle_fdb_{add,del}_to_device

 include/net/switchdev.h   |  62 ++++++++++++
 net/dsa/dsa_priv.h        |  19 +++-
 net/dsa/slave.c           | 199 +++++++++++++++++++-------------------
 net/switchdev/switchdev.c | 190 ++++++++++++++++++++++++++++++++++++
 4 files changed, 365 insertions(+), 105 deletions(-)

-- 
2.25.1

