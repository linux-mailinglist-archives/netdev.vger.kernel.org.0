Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0272873A9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgJHL5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:57:25 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:40513
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbgJHL5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+q/L5KkF3nUg23NeEKUVFG2AzHVrSh+MF894WtieYQNy+kaR3TpKCKYsWqGMJERmXg027DVUwBFL4q4P4RPduz2O9XiJd2VGPBeacMK2b2W1LYSfZcRTE4d15VSLhafcCwaYLmbWS7XmwHx0qKrJX8tY/Tz2IPw2/OoBm13sx5k2L37rDaqW+oQ1zI8uLCUl/BzVoT1q7LhIUbKsAIj6gNDWLfWk1wM8GpihDAAgdXGiVHfmcIo+Qc8KT7V4ZfK/GOcTzb66Oc8PIHFvb95ZZcYOm0OL9OHX1TFHo+xYO5RbI/ZlzZDxllPPzDkJNunyFMoic+XbUj5RAYtYHLo0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sq5yUpxapp/rFj2WUKdCrM+aKZM7pzszDmW71PtA1g8=;
 b=iO3CperwInIbkscpfTnE/uw79TvP3aM6ykO/vzUZC2M9Xm+H74uOBO/Jw3CKxPVsCAnzL7fcogF+g5nSKT8rjrBBy9InsElqyeFFJkSgsp7zHnL0lQH2GERVM3pr9kYoezaVf7ykiyZeosCZ3bo+kJv0/4pHpNGjfLlayiFVCVl79z716sL6VCi+65N+nz/swrbrm6q3df/mj5V6zGb/Myqr6cnXHgiHzy4xp/L3ygLoFCrX8BLfjMQM8gyrEkh2UMx4ZruwoRiz5Jifk5bUlnE4yDQbX89cn7lYY+DTf9qcst33YufCg+Ft3GeQrVxFpeP8IW+bCVtSf7s7kqXVFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sq5yUpxapp/rFj2WUKdCrM+aKZM7pzszDmW71PtA1g8=;
 b=TW5XRUWLjSDksj7k6vB38c2mhx/gu9/HLektQSdqHeFsrp6aIVu4nTFFakhUNnjtvSA5bwYCDzUhSPDHjXS0nWQjyYO12+nmR1FLYurwDG8OAOPu24SI22RbHn7InACOkFSWUEg1G9386DGL4brMGZLzMLqSJcwHqzJSBYpATS4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 11:57:14 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 11:57:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/3] net: dsa: tag_ocelot: use VLAN information from tagging header when available
Date:   Thu,  8 Oct 2020 14:56:59 +0300
Message-Id: <20201008115700.255648-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201008115700.255648-1-vladimir.oltean@nxp.com>
References: <20201008115700.255648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Thu, 8 Oct 2020 11:57:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: af29af94-a957-46e5-f131-08d86b814b9c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB370928FF9DA9651409C15684E00B0@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsD83+803cUj3tLjuHuHKdnHa3JGSPOtJq9aMp8P9DnaUjfnJb6BFeUfN6fJKsBh1Acz3RDT1ldSvGLTHj89AppsshONy+4LjKyLtpqOwRVfp7NcPOTVDBI+RuCZyeSRBeJKTjNf6V5qAxG2wrP/9sNPxOI6ZJCFw/VtMhMNXxRPrVsuoAcetQMpkUNH88ndTXzpz80G6qAETnezW+SjflXWUpdgxlqcjYbEnGZVVQstx2euvBM1xPVZ/JS/xH0XFL2YIc7OPdBfqjjopIcllF+loMPe9IfSNynC/xnCLt8yvLOovbIcQh8Sn8R9AXuL4NjLzN1Q16sx7NE35U0A+3k1nBzWNSydsY/lEKh7gC0OU+SYwKWtN9codN6H1QDf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(4326008)(6916009)(66946007)(6486002)(8936002)(83380400001)(86362001)(26005)(36756003)(6506007)(16526019)(2906002)(478600001)(44832011)(66476007)(186003)(66556008)(8676002)(6666004)(956004)(1076003)(52116002)(5660300002)(316002)(69590400008)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +HhSeuWe1AQUVytpaFqHMeHm7qF4dqO/vqdsPUFp92mWXTACunl3lWUI5QnLeqJraKIXgifVCxDK59dF5VopkkVZu2jXW62+t/DmIS8qP2jnM4k4IWBayeQtv6QjQ5/CrKXNglumeB1VKTFOado3OJ9weBrKTOac0o5RBC9Y9xV4gbwyyn7uQU3prZk6jr4UBnxknlB63PfBVhqcnGMwSyv4qf7RTUAMhbkgocEYyV8ZKVcT2eJOIJ4thfAKODhMerLVXkSlTRd2EdMnpOswzuLaBNmcxLzFOeawyCzqo2IDBFb4HfPh5Ol/RA8StoYLskW2Rj+3ckgRasOfowv2wAF9mcLDS3hb0jU1UMv+8q1Gmjf6kG7WLIBY0lVkHRPvk4/I+zJx+F93u39Sf134brhDuXyTLKOTX8vpyomu8gn94FYwD3W7Du5LCAVNszPOy9MQAtce6krLTQvergDJSz7/jB99/55WfhX8eV3qayO0WbsFvQVqB/QiK6Wa7c4ArUvqdpRIna7poYGqDzgnmtB4bpYcd2KBXRM1Ig04WNkD+YWW25AvID6REKjFWBM+zOxoeq7rAgJvUta4TQWT0T3ftYnCAbSzvcjSNyIgZH91SlMdrXjvY8skWSCTBWaoe5Ju6JHvKkCgFa2bV9dcWA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af29af94-a957-46e5-f131-08d86b814b9c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 11:57:13.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLhHKdYO2x1WAN3rHr6br6nCFLIPC9eRGe087GtOcZOkhkY6d4lOdpeKsMzZ1kQH98jpqnmRzP9Bg2YsWtDN9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Extraction Frame Header contains a valid classified VLAN, use
that instead of the VLAN header present in the packet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index ec16badb7812..3b468aca5c53 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -184,9 +184,14 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
+	struct dsa_port *cpu_dp = netdev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct ocelot *ocelot = ds->priv;
 	u64 src_port, qos_class;
+	u64 vlan_tci, tag_type;
 	u8 *start = skb->data;
 	u8 *extraction;
+	u16 vlan_tpid;
 
 	/* Revert skb->data by the amount consumed by the DSA master,
 	 * so it points to the beginning of the frame.
@@ -214,6 +219,8 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 
 	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
 	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, &tag_type,  16, 16, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, &vlan_tci,  15,  0, OCELOT_TAG_LEN, UNPACK, 0);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
@@ -228,6 +235,33 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb->offload_fwd_mark = 1;
 	skb->priority = qos_class;
 
+	/* Ocelot switches copy frames unmodified to the CPU. However, it is
+	 * possible for the user to request a VLAN modification through
+	 * VCAP_IS1_ACT_VID_REPLACE_ENA. In this case, what will happen is that
+	 * the VLAN ID field from the Extraction Header gets updated, but the
+	 * 802.1Q header does not (the classified VLAN only becomes visible on
+	 * egress through the "port tag" of front-panel ports).
+	 * So, for traffic extracted by the CPU, we want to pick up the
+	 * classified VLAN and manually replace the existing 802.1Q header from
+	 * the packet with it, so that the operating system is always up to
+	 * date with the result of tc-vlan actions.
+	 * NOTE: In VLAN-unaware mode, we don't want to do that, we want the
+	 * frame to remain unmodified, because the classified VLAN is always
+	 * equal to the pvid of the ingress port and should not be used for
+	 * processing.
+	 */
+	vlan_tpid = tag_type ? ETH_P_8021AD : ETH_P_8021Q;
+
+	if (ocelot->ports[src_port]->vlan_aware &&
+	    eth_hdr(skb)->h_proto == htons(vlan_tpid)) {
+		u16 dummy_vlan_tci;
+
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &dummy_vlan_tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
+		__vlan_hwaccel_put_tag(skb, htons(vlan_tpid), vlan_tci);
+	}
+
 	return skb;
 }
 
-- 
2.25.1

