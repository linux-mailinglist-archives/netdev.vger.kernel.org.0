Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF4311604
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhBEWsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:48:03 -0500
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:30318
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232231AbhBENDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:03:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsHidOzoSZt0wxa1RDDlOW0yi7My3Ly4SDaXG/mYrXa9kBLK4riWXezRpU+eS/jWgJt+Bjo5hIc+TViLDWFprdM3Z4mCxX2h7LCyXixvI/M0lJRV2y/2nQpjm/gv/bTPi2sQBOADbVatZhwunTWO8hgX7t6ObneXmfrNJNjzN6/E/7g+TAs93CUYGRXSGtzcR7J92v2ak6J29Flk7uWnks46uyYeev6dQaBUoJESdYBTamx0gZyO85rLTtEv7tm3ajKb5CO7V7dxcrc6n+nmvVW/3SpaMLHN5+1Xy2nCPeJth4BQdzUB+rCyektTMfriAwyHLAft7rNI7/2FmgnHtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUJJvA+Q4GF45K54FW/M29zlodOIT6cZx0bvqDl+qyA=;
 b=JxSUDtD+1C5i8zhntJ6sMg5fa8UkTUrrVj3ySlesIEVy/0YEbNUGnCk2vVa+ex2kvKrqX2juhdOZ+ZVD/Pp+aMRq4f6+Xp9KOWVtzVUu20sS7Puh8mQRrDZoeSLbnyivDhtWK32jfqNb8SiNVI6gks1erMdmI1d4EB4oMSoMn5Ldh/qNPuG63kYGZE5XJJ/D6M56deRF0dEgx/cgDh5v2JviOIusJ60pRhJ5wWt8vfH2YqQ0AhaZ98BvevPzOSLkJBUtEFuJ1lLEoMrTgjoCOykDvKoMpGt/GZSpQpi0pSW3++QFz//afn00WGDy6EATIKA8pLSKKOsYJE8fE52zjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUJJvA+Q4GF45K54FW/M29zlodOIT6cZx0bvqDl+qyA=;
 b=StJRGAwHMW8y3ufkpZfcuRn4Nvgfo2nLNzV7w8ggRMh2LlEpEFiVRybrqWF2/tTIP/BMmwh8vPVn7q5FJUYI7QS+RCT3cWjUB5Lj1r3+nZVlDbEGmb3nU9iimypKPJ96OPYpsREw0DfhZy1PYXNQXBKr8dQCu+y+c0B3WnUlik8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:02:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:02:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 00/12] LAG offload for Ocelot DSA switches
Date:   Fri,  5 Feb 2021 15:02:28 +0200
Message-Id: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91ea9354-2c20-4363-ad72-08d8c9d65bcf
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286338074729038A898377ABE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeJX2FqTZbWFxS35oGBjAdmFSv6J168eOGDbLLULnuX9lahFjJnKkkMxUSrHwCSwG/WPi7Lk2BKBu80hEnpkuHs1PQnPR0jk2plTVUZIdUFNgVqKJ3XblxFrdpzs2Q8fwGvpTKbJqBdyCJxp90Yydeim+V8FuCoQNVCExfhD5nHLLG0Cnqn4BGRBDCzRADS9XUlwZo5biVuW5pVuWtO1NvHmj3DLuI+I0LN5/NhPJ0GpYcSlNzgXclVE3yeyvwdfYio5SySVuzD+7dzWZM0PGrRrbS++fEdMIXIIy2WlOtgD2xWr/QdkUCa7CfjSsY1uD3/Xyg/PTkpS8lfi5OEjzXr91O8oHy5p/dR/KmevsM0ikTtwk+UF9x6LfSEN2ZAyU8nG5Y96EnktD7QSg2x2QWzxZMrRN08N5JmnoP+ELUXBUeBjFfJcoI/QITaTflYHVy2hTYG5Bej9vaPVurzeEp7l6hM6spf/kv4xYOzX/WCWKfEtTBH+9GSfzJ5NaW6pLYXM7tsyxXrh47T94P4zZMQddx4jTwmxg1N2WnGnl5s0cSEkbUiJ3nAdmtAlqzw9pmjasVlK2EMer93rHnO+KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dKrERzq46UYvytY1h1/OcEGesodnJ/lkP3Soji/APDIbLDOsqg2HTes9SMzg?=
 =?us-ascii?Q?1ArqlUyXYxqK7bKonK2uVjquwQtr1CuOWQu9n8hkuK8jrglOKFa0W7ShrBQQ?=
 =?us-ascii?Q?f3gfrjFTJLQWW0nnMdr6itbk/Z5Oj5QRpJLnLJJhcDU+VfNzV49akt8KndWe?=
 =?us-ascii?Q?A9oNQc8GakOUxAU3UIxkDJaaiGCdDqrHWKin2POb8G44OgwV7Wwg5EOOU348?=
 =?us-ascii?Q?/nAIpc4XELSALzaXA/GwYOaB021Xr6uupsyjrfAvZtUoCOrF2D9l2s2XHgmC?=
 =?us-ascii?Q?J61LChpoPQLRvqul9qncwvSIjmmhdzCewUqEeckPU4qsv3AscSotRD5O3xkt?=
 =?us-ascii?Q?3nB0l7zLjXg5Pet9UIOeqyXtMEvbYuvIYcNJbQx49Jlg2tOBr66qA5K7YBUJ?=
 =?us-ascii?Q?TLVvdv1YRVQugdLdSz5sCQUVEhD4aQ613m98reSVtv+VnWA2Ed9kLFVeM/Fc?=
 =?us-ascii?Q?LzQglkDSfj/fxvt2b2DPblt4eNiS6pHmGnlkg1NXsM8fOvx4S09R1byGUT+c?=
 =?us-ascii?Q?/aAZ6ilbety9VPxnLUhxjM4xqJxku5QTtVZq24uiqTENlPzoIHb3vB2iWtu0?=
 =?us-ascii?Q?XkuZ7mtPWp6VszdgHINpQHj7nb3tKfjRtl+m6cB/d1kXq5KSyYru2fb13qaA?=
 =?us-ascii?Q?Ja2W9eLbBfzD876dIHIZe86nPwKsZPCFzdC94qkNkA4tMbTV/5MQwsYKi0E+?=
 =?us-ascii?Q?Y/3jPtnsPmFV/Ka5Ka7n65n/0puv/y4J0pzi6crrN+97fDC/QFjxXglEMZXS?=
 =?us-ascii?Q?h3DlDbR/7ZWzFPkB8DU/xq/SpjLdz8sTDWapnWRozrBVTEBvp6mg89jS2OrK?=
 =?us-ascii?Q?UkOy9QcTJEOqKmupr1KgwS2AGSM40q3fIos71AQnWd83drbbRt4qziwHeU3H?=
 =?us-ascii?Q?HKU21WcmOBmfXDAOXNH1SpYrMDEMUkQ7zOcqfZe5MHxmVDnsw0DndGioJV5s?=
 =?us-ascii?Q?oVRR2zAQq+tf4j5k0ElOucX+iHNifHmSQv+4zla8OIesyedpJNCj5IO58AG+?=
 =?us-ascii?Q?L2FCGzTkQE/KEIMYkKAqNvdx88LLbA1PoDpDIq/ZpUzVC2fLqq9vy8IXM1MK?=
 =?us-ascii?Q?vcg12iZwVK0+YnNZ7daE/SwW9De8fBA80qH1MaFzaYAsIfOUhsVD5LSIVySz?=
 =?us-ascii?Q?y+ru3dM/XqNm62ckeXQt/QVyRsx8nRc/+ug0ZFYiNFujjuKXosEhhqtYSOq7?=
 =?us-ascii?Q?n4FhKbC7U0iaLmjbphiXylOMmoPHACGyFf6zWKuB/HHlvWrWqfblUrIpQqUl?=
 =?us-ascii?Q?lHYqj8vkPxzITDZu3m68+nIjCMGFjAa77/XIwI1Cn1zDzAAQm5f28WlYSyd1?=
 =?us-ascii?Q?skkL53o25brh0w4M9+qihmqt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ea9354-2c20-4363-ad72-08d8c9d65bcf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:02:57.7414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+B6VM+6Y/3m1BYC8NPbvsgi/4V/4RRL7+GWqmkBBMMW2u8rLWgtjAf+9CdLapK5c4uCe6RDhYoAJ9uzNRxumw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series reworks the ocelot switchdev driver such that it could
share the same implementation for LAG offload as the felix DSA driver.

Testing has been done in the following topology:

         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |            |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |            |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+

The same script can be run on both Board 1 and Board 2 to set this up:

ip link del bond0
ip link add bond0 type bond mode balance-xor miimon 1
OR
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp0 master br0

Then traffic can be tested between eno0 of Board 1 and eno0 of Board 2.

Vladimir Oltean (12):
  net: mscc: ocelot: rename ocelot_netdevice_port_event to
    ocelot_netdevice_changeupper
  net: mscc: ocelot: use a switch-case statement in
    ocelot_netdevice_event
  net: mscc: ocelot: don't refuse bonding interfaces we can't offload
  net: mscc: ocelot: use ipv6 in the aggregation code
  net: mscc: ocelot: set up the bonding mask in a way that avoids a
    net_device
  net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
  net: mscc: ocelot: set up logical port IDs centrally
  net: mscc: ocelot: drop the use of the "lags" array
  net: mscc: ocelot: rename aggr_count to num_ports_in_lag
  net: mscc: ocelot: rebalance LAGs on link up/down events
  net: dsa: make assisted_learning_on_cpu_port bypass offloaded LAG
    interfaces
  net: dsa: felix: propagate the LAG offload ops towards the ocelot lib

 drivers/net/dsa/ocelot/felix.c         |  32 ++++
 drivers/net/ethernet/mscc/ocelot.c     | 206 ++++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot.h     |   4 -
 drivers/net/ethernet/mscc/ocelot_net.c | 131 ++++++++++------
 include/soc/mscc/ocelot.h              |  11 +-
 net/dsa/dsa_priv.h                     |  13 ++
 net/dsa/slave.c                        |   8 +
 7 files changed, 262 insertions(+), 143 deletions(-)

-- 
2.25.1

