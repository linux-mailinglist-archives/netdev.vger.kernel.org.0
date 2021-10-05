Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A79421B00
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhJEASE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:18:04 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:30119
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229850AbhJEASC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:18:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+ypWsl/u9DK9x0G/xgMyyCxQy5o6RavhUz3CqjQ4rl0xEMQHYwwqvIIjQ0g65yybuD2a4XXjOqbaB61xP7+zYRK+g4qHJXJ0D25i8efAdEZQz4FOzSfsldscTKFgR5lu4TqC3q6I2XWjK90fU/j2k5VyvWeVAuPKYKpvmiYT5XnNkOBWfjjZKk8vB4uTYA7w4MNiJEkKgLqhIHB3Y7OIxPMKMdRuyZF9dGjW7gIp0iMQwdpXXZvyyIYJG+hjqNIRbrNLwIQMhzXFIOw/l+J2z9C2Ig9LeTU9HEXaSFG4bp2gvr3eOt0GTnfuzzHRztBwgfRTkcvi88ithLqQnSTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDcB3HhAKa/WgBUIfW0nhoICSl0wsf4w0E7/C2iIhgw=;
 b=cBCvAmUsSmniIuWN9Ouxg7jqS9tTC6LYfncc5Sw608WX+VOlqihFr2Vq5GJABfx0wpbxIUQhjodVUzBfgVJqMyrii4/+/U8ongeDGwpVXeGixahu4efU6jC3GbPiyMWIcCP+zMmVDlFRcPQE6eVZDfIyBZtZd2svanTwBZy1XKFLc+QMIimIpukVnYRk7FFR+Ei/qRAGwopKCSVHkTwPJ6pjOHaKYFcGZ+lwVUyA4h4Q69gwpKb7tXUg8qoVwuBHXVjg1bPV89YqQqiXiHdunzaP58awwqzLtrGCTEwf/LYCV/ipLoTzyIjMzlKQPWw/c3IZ4I32ENJcjpjuH7UwTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDcB3HhAKa/WgBUIfW0nhoICSl0wsf4w0E7/C2iIhgw=;
 b=rfI3a3Utp7BQMd2LHVy+jKLZ3vn5KZvvQr+tS1WiOAt6JzxVi7wM1L4s07OK3YC6URA1O/w2afpPE1SB6+DujYMgpd86mjaEXgwjxyMfzOMe+V0Au+9cy+KbRiqFtlzvXOlSVmyN9+wQZ8fYr10/9VGoZrt7u2rfVZNZXZ3JAVg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 00:16:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 00:16:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v2 net 2/4] net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware bridges using VID 0
Date:   Tue,  5 Oct 2021 03:14:12 +0300
Message-Id: <20211005001414.1234318-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 00:16:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b1d28da-dae3-492f-e9af-08d9879555a9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3615:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3615C88A1EB2645E30515037E0AF9@VI1PR0402MB3615.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mObpY3VTZ3CnKNhHKCb5U9Yz3jp2lt921nam5ul7FQxWccGYe/zUX0J2UJ+a02cDswlHzjkZCs3CLPcH4iZbOLB37sS9DeWzNSTARP9FbqTh62yfAhNY/5ld0pUJdOZZ2LN0m0XoNI9qkJfMlM5T4szgtD6e160uenwb13RuK848Z37ZpjwpA9U+PiKYtW5mvaPD9TnuBQXLITFvVpsk2ukVoh18gATkJ4+2vtR2pqWV91oIluNFSiTkwdaHYChjYCxViMLY07hlZ4hJaoTVo0j4Fx8tymYyGiOZB1EfT8+0PiE0sRaHV0alnG3nN2a3xQ854UvM4glbIJ8hRJhgRi+VigJd89lqUlRRBoidYY6gPUDwyqkTL1ixhrMN2Mh7CrMnub9eDvxQxahs+ygLpAXmF43iN1jLkSdB6XDjWbqF1xCpP4nFmSYH9PPG+hqnmJeFBTfGIagMb8ThXFrw9vMl0NbYnyqux6ECDH2WsLbstmjRc81m0yjPSZGLFKWKO7DczemMfhe/MsF04e3P35U9owWEsPTkeYHs3m1nJ9oL7WLES4gc/ZPlFzXwxSIIpfCoUOSR3ue41d0ajnkYqaZ7imzIx8apCugmOP8Az/50VA+G/kdFX9uXhSwmTzMZU6xflu0dla0VIEuLLoB1DO169CJtXtzRiKoauC6wTlQg6ety0e891DMl8yFomVtfTWV99yPXz/EpaKGa3ii7kilqGhe/yUzWyOcWnCCWTiMuV2g8O3Q7JS6gY4J8plZQVvdh20OUUxYhxlvBE7Uw//SR2FilZ2MvoRnc44nWmd5Rt4m1I7SEasIqTPLL0qs9+mf3ha8kPcQNt9q75Z8pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(38350700002)(110136005)(316002)(8936002)(4326008)(54906003)(83380400001)(956004)(2616005)(26005)(5660300002)(6486002)(8676002)(6512007)(66556008)(966005)(52116002)(66476007)(186003)(66946007)(1076003)(508600001)(44832011)(38100700002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LtwvP6H8ZmHO1cSUK7IvJqoJ6f8eWzdoxRTbS60oRSd0XZrZ9HBsBvyb9cAG?=
 =?us-ascii?Q?0o1uQS6+wD/F6LhpNxG0XYjUT63qGwEt9AFS973OR6QMvNUjL8lO9T8J190N?=
 =?us-ascii?Q?Fdy8flUiQNRE9g6wI2fX9OClnvpo5V2bwpPWDNv/MPbT+cUIi0VfhtW6nsn2?=
 =?us-ascii?Q?oh4tJ0Q9/j6HiIPrpCs+/RHvkqX9ertRAd+sf3LTn2hwzisc2O93RXA1sfvl?=
 =?us-ascii?Q?rA7qVOVFwkC46B7413+6tLuFiJUpfFbjz7TGMA6qW+JiUT5QTv7Yo/rRO4cF?=
 =?us-ascii?Q?viYuTnl178aTJ7lbCpHqYMhShlZCWW4un5EKgnc8AAW0kOlObc0KORVeecAY?=
 =?us-ascii?Q?nEaq0EztAlXSeBbSyctfY9f1zfdEi1YJfSugiKkLi7SdkWVDUOOjurug4Phn?=
 =?us-ascii?Q?OWkaBAZaDb1lsiG63A+6IUGYNaBT3sxEEpwfMkxOCC1J6nhHs22Pk62GVWpz?=
 =?us-ascii?Q?20QB9ATaG/p2vwvKcptnZJX7kGyUYdUHaIj42O36DQHOWW/K7xySREShQNCt?=
 =?us-ascii?Q?HptssDyosysur32bp9WzH4fgQi4Jk7qpG0DlUF3dVJMH0hLPhmV2gRk8r8jw?=
 =?us-ascii?Q?eLJKYa6jUMIMPW8mh3psCA81ZWy0Y0ypFzGnbPUgr+IkLkOxxKgTtnnQhU9S?=
 =?us-ascii?Q?f43LYOX1WzPHKNiR9L4429MUmyxmWedwwt5lu/NtNJdIISyAyAMWM1kS/fS0?=
 =?us-ascii?Q?WMb+4LLEWvDC5xgpaOKf6hLqkaelAcXQcEQIz1B+Y++EJfwJkSB+pz/vyOwP?=
 =?us-ascii?Q?Gs0Nnqwvq6QhvkyvrUjnYILxtefnXJ+860Ky9ilkYiPt9kuR2zOboxfZyXnW?=
 =?us-ascii?Q?yR1ybPpRLbxD2AGEoY/vQJA0MfcbqBJsrpvKouOoiPYbhh45dSgcayXwYt06?=
 =?us-ascii?Q?KNdllsZft9NT9/xhWENBGA2VA4D6XvODsLUQ12PpzuNbJBBa0Sv2Cr6VPc6u?=
 =?us-ascii?Q?9IBnhiF3nZjA5XOlFDQbNUME2Z8ACbtLFkO/qW2z5RaEZBzWKUXeYAj24K87?=
 =?us-ascii?Q?5fUS2dHrVJQkezsGSfyrGUcLwHV+RBrMaffVmpHQ1p4suyrfJbU8956T/xYC?=
 =?us-ascii?Q?5pr2MFyz1T6MQfAMoAGJnstoaRSPXR8JN5PQYY9V0z4VqdOWAznSjGVRvP1H?=
 =?us-ascii?Q?zk9BzRShwQ8nLYk1+zxgLu6p9maK0dkul8jMLb+WimaxLxC50EIULxjAIHhQ?=
 =?us-ascii?Q?OgX8aGANCkmr8MdbAFUyMNK2AqLhbHXb6m0/vKLPuGPYxBkt/sbyOir3SRcH?=
 =?us-ascii?Q?tIWWtofzmHcpNSKzs9aetSUxoqlWaw4dNuSlnekvoDanUye1WU7hPCND9IhO?=
 =?us-ascii?Q?LkB5j8+PrUcOugbOlJwCBjkx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1d28da-dae3-492f-e9af-08d9879555a9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 00:16:10.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdJp5CScINBaBtY/4l7BHPgHXB6gghyUh4NMTUgB1ihB2aHT6DG6my+J9Rz0nG2Vvx7fnZmo+d8m/00DkCUgYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The present code is structured this way due to an incomplete thought
process. In Documentation/networking/switchdev.rst we document that if a
bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
port (or on the bridge itself, for that matter) should not affect the
ability to receive and transmit tagged or untagged packets.

If the bridge on behalf of which we are sending this packet is
VLAN-aware, then the TX forwarding offload API ensures that the skb will
be VLAN-tagged (if the packet was sent by user space as untagged, it
will get transmitted town to the driver as tagged with the bridge
device's pvid). But if the bridge is VLAN-unaware, it may or may not be
VLAN-tagged. In fact the logic to insert the bridge's PVID came from the
idea that we should emulate what is being done in the VLAN-aware case.
But we shouldn't.

It appears that injecting packets using a VLAN ID of 0 serves the
purpose of forwarding the packets to the egress port with no VLAN tag
added or stripped by the hardware, and no filtering being performed.
So we can simply remove the superfluous logic.

One reason why this logic is broken is that when CONFIG_BRIDGE_VLAN_FILTERING=n,
we call br_vlan_get_pvid_rcu() but that returns an error and we do error
out, dropping all packets on xmit. Not really smart. This is also an
issue when the user deletes the bridge pvid:

$ bridge vlan del dev br0 vid 1 self

As mentioned, in both cases, packets should still flow freely, and they
do just that on any net device where the bridge is not offloaded, but on
mv88e6xxx they don't.

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20211003155141.2241314-1-andrew@lunn.ch/
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210928233708.1246774-1-vladimir.oltean@nxp.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: fix up commit message

 net/dsa/tag_dsa.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e5127b7d1c6a..68d5ddc3ef35 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -129,12 +129,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 tag_dev, tag_port;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
-	u16 pvid = 0;
-	int err;
 
 	if (skb->offload_fwd_mark) {
 		struct dsa_switch_tree *dst = dp->ds->dst;
-		struct net_device *br = dp->bridge_dev;
 
 		cmd = DSA_CMD_FORWARD;
 
@@ -144,19 +141,6 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 */
 		tag_dev = dst->last_switch + 1 + dp->bridge_num;
 		tag_port = 0;
-
-		/* If we are offloading forwarding for a VLAN-unaware bridge,
-		 * inject packets to hardware using the bridge's pvid, since
-		 * that's where the packets ingressed from.
-		 */
-		if (!br_vlan_enabled(br)) {
-			/* Safe because __dev_queue_xmit() runs under
-			 * rcu_read_lock_bh()
-			 */
-			err = br_vlan_get_pvid_rcu(br, &pvid);
-			if (err)
-				return NULL;
-		}
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
 		tag_dev = dp->ds->index;
@@ -188,8 +172,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 
 		dsa_header[0] = (cmd << 6) | tag_dev;
 		dsa_header[1] = tag_port << 3;
-		dsa_header[2] = pvid >> 8;
-		dsa_header[3] = pvid & 0xff;
+		dsa_header[2] = 0;
+		dsa_header[3] = 0;
 	}
 
 	return skb;
-- 
2.25.1

