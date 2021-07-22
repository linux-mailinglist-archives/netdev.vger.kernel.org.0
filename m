Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8203D2AB9
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhGVQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 12:21:19 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:38370 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231205AbhGVQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 12:21:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D162C40069;
        Thu, 22 Jul 2021 17:01:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E14Y3UGGKCM0ynWxyJcg45SCAga+v47Dsp0dBgXCCPWqtcSF+xQq60wne89bpseicmp9/xnyjvOqGrViwJtPKtGIFYSTo1FbEFwLH0XeciqklGuLC9wHiLPvt0H5KnP46APLzc/3hxTJ6sfTRGncUGBcJuAKtjm/J+N+N5w2Ux4FSC0xZL1FRhzJKOvcSD2QuzqDeZJtU1VKJmKD7Upt80RmVULyQBLL5xcxW4GQUNOMKNMXZjGKrArF4hUoqzTdJ1Fagx35WKKqQB+8qFSBvOprG1FGtY0RODXJ+8lornaVkh/MMdEgh9846Cv8hx3JinOqzLWGY8FxgCJcONVliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4DBdLe2ha0qTsKm9WHvdrg/X7DokmF3zcH4TWsjdzc=;
 b=Omd9zAglwvd8cLTiOSGdjtbVwGlPtl7xJ+zD8tuD+NWM/UbGeqR72bhohb3Hu3XsosP2BwxjjGBXqGxzOo5boJyiuU6hRcMUwznlkggtVlRyUiaJBCNZiAeFlKmnaGuVQ2jA36wsZoxE+A2uEk7nFtB975ZoNl0+a/fjoRGwJff4WfUI/fsDZSWE7Sw/P9GQ+xcPN/UWo4CwGrb3xF2n+/4zatEub/W0P9Uum8WuWe60V8WHsTqxnmV9DB/SzrUIV6YUZmlY+eecyIl5G/xNwROgFYDYhqetQW/4I94OQj0+HNBDH4ac1bL6qwmFPYQEjvta9IzHGBy/RJHJnNsToQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4DBdLe2ha0qTsKm9WHvdrg/X7DokmF3zcH4TWsjdzc=;
 b=Wx/lK6inE7Ch75LrLclILUjAg6xDFar7BDQ0wxqceNsXHODgaZgRZ9b1qQLfjfx8J/kem4Cra6aYS15Q91yJF84dcSjd895GPzg2FtXghHx9N0UoeQHIIco8qXhMT7rUVOR6gKRzCFUyE6k2DzehBhLabnunnVFgnUMmtfCRMG8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM5PR0802MB2465.eurprd08.prod.outlook.com (2603:10a6:203:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 17:01:47 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 17:01:47 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: Set true network header for ECN decapsulation
Date:   Thu, 22 Jul 2021 20:01:28 +0300
Message-Id: <20210722170128.223387-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0244.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::15) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gnaaman-pc.dev.drivenets.net (199.203.244.232) by LO4P123CA0244.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a7::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 17:01:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3ada1b6-8b48-4a7e-dc3e-08d94d3263fd
X-MS-TrafficTypeDiagnostic: AM5PR0802MB2465:
X-Microsoft-Antispam-PRVS: <AM5PR0802MB2465795015DFFA170E67BF15BEE49@AM5PR0802MB2465.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JemmuCCK0kBdRPR/P5r3QHZ6QuwAu0lHyLMYnukRO3yKyZF/+A+oJNm+TmyrF/3kQTisMd5d0GZQ3eTPJobcmzSqfCY2GJEX5345CLZ1qcEHCZP+SpOOuTbcshU2P6I9zav7jc1PgmUnXlHoFdb1+MmQbHcNG0KHD3UXJWFmV1v+DTrvBKq9MRX7qn1rV6RrewBqq8a6tF9b0Q94Qj0LjxGCPbNa7bJonfe4TLP5hvDdfGexB7Qozn/Y75Ob+fnFek/Bf1J/gLlxhvsipg9GLx372T3wnyRNvS6c2B79hn5Nl21kjtp7Li29eqHTXek8qBwQYScIUUHQPhd4b3QLm5r9ZXWktz8UBoTlFMv6m405xbchjJzICiY5XFxUQ4h7gDe6BqGuKuNHUZdzA5Qi0nyZRR/wrX2Ud/U4v9aKdwYgvLjKHUorfk+VwXZy0Y+GMkX4t/NLdpb2TTMHfYRGx9wxAhtdgBSzxK6qSaWRCBIgWFKH1DRxRtYLbZz1mVMuR+PosU4bRCTvznMbKvXgr0lecEA0GCG18QGx5yDes7O5EcSjdXKhIfUVlQzOUF8PzxT5JqCJUVFJvT/gFyw9KpXVzXzJDUAkOili4TlWgXWp9mYjBWV5tHc4QsqBh+2OHrDFLIRZXBc5vvIlTLu34MoDag8/m5NvxaryiWF2tDQiMpo8m4c9K3587NhAIFh57z4nMh+M7vBewFhqRaWddNDM9XxVGZFtuF88FvMpLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39840400004)(346002)(366004)(396003)(186003)(478600001)(956004)(1076003)(6666004)(26005)(66476007)(4326008)(8676002)(66946007)(36756003)(66556008)(86362001)(2906002)(6506007)(38100700002)(8936002)(83380400001)(5660300002)(52116002)(316002)(6486002)(38350700002)(2616005)(6512007)(66574015)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0hoWFl0b3g3cW1QREkvZVBTdi92cEt3ZnVNMU1pQmc4TGhWSWk2dGlYOUlV?=
 =?utf-8?B?REZEMVFkMWVEWHd1SG95aTI0UUl1S3dNM2xodWhFbnhlT3JKNW5scWtWa0ZL?=
 =?utf-8?B?V3ZseHc1V1BacVRnLzBwbnV0cXVlcG5tdEdHZHNEKzloc1FUamRFS2w2dU12?=
 =?utf-8?B?Z2hMdlgxdU9oMk00dFAwellHS2ptdVYvQlZ5VTR1Ykd4STdra3Zha05Hb0xL?=
 =?utf-8?B?UzAwT0tUbmtmZG5lT0dQWks4NHpnclZZaC9iUXY1Y0xXd0lCcllFSzF3Vk1P?=
 =?utf-8?B?MjI2alhyc2RjTDFVOHJjVzZ5UEh2U2FGbXNsNmVVeGczUTJPOEtKYkN6bVJK?=
 =?utf-8?B?M2pHYWtseTNJMTFIMUYyR1pKSEJSUGpZQjhwcUxDNzZDUnAwSVcrdEhCc0FN?=
 =?utf-8?B?U3VGbm4xeFl2VFd5UGdwOTQ1bXB2NlVDZjE3VUxSYStENkZnK3BHQkZxNnNL?=
 =?utf-8?B?WmcxNGdzdzA0VUNZYkY5K2hHcWorZ1RRSEZBZTZRSjE1cWZtb28ydU5ZdG9t?=
 =?utf-8?B?OERjbkdsTmJjS0JnaUNDR0xOOTdSVkJ4MVRGdTdlaXZxYS94ZWIySkZVbU00?=
 =?utf-8?B?OUU3WEVYUzlKR1U0OTQ2QjV0bXJJUFdjcHRiQWY3R29OMThKMEdKWmw1bS9Y?=
 =?utf-8?B?VGJQejdQcWZTa3V4aEZITDRtSTcvVGlmRkZUL1JuZzg2OVlhNXgycVhPNUwx?=
 =?utf-8?B?VnJhR3FEVUFnVmJFcnRQemxQMlNaTlpkN1JQbjZCbEZ3Rmc0WEpKcDJjV3JL?=
 =?utf-8?B?bnNvM0swamYydEl5dWNIZlVIY1B3NVB1VVJ4VDVVQ09PTndoZUZ1aXlIYTc5?=
 =?utf-8?B?LzNhYXdBU0V4K3dpMkxBUVFYdjUrTWJZdU14eVNpL2NqQmpyUk9jT2JMZlJ1?=
 =?utf-8?B?N2NDOXZ1ZjQveTI3OUIxNTdTMHJSYitkRHZSNWRaNWNEZG1kaFdYdjVCVU52?=
 =?utf-8?B?N3kzVnZ0bGtKQWgyd1NNOGZhOE1Qb1VlZktPSzQ3Wi9GM2lHY044Y25JeUda?=
 =?utf-8?B?cEF2WnBnQ3MvcFZLWXdwSkcxNlpXTjFwY2w5bmtXdXQ2V3VPWStQT2ppeFRv?=
 =?utf-8?B?V0lpV1l2YXZMTEhRY1pabm8vZzZWTHVUa3piWWllcWRUUmFCWk1tRUJmRXRo?=
 =?utf-8?B?ckI2S0FONFU1QW5zcGhCNlY5QVBPdnVmc3hpRWg2RjI0dXVkWUFQc1o3ZTNF?=
 =?utf-8?B?V1ZIQkFjMU9vbmE3SDI1dG9OVG9jVGYvYkRKR3FPVVZHdlNSVzNnTDVoZE95?=
 =?utf-8?B?UDhpRVUwUkdXRTgrRTdMdVRWMkxobGh3VzlDS05wVDB5N3orcjhYUHBVbFhO?=
 =?utf-8?B?WldibTBPNTQ1aEMwdDVxUzNTbUFyYVRMNFVoQjhTVmttUml5M1NwdFlkQkQw?=
 =?utf-8?B?azh3VHJadExEcEtORUFMNHo3ZHBkelFaUjA1K1Vwa2drUFZ1cHR2c01TZndr?=
 =?utf-8?B?OXozT1k4emIxNzhsZlkwMS8wQmprdk9jUER6U2lsRTI2MjVrSFc5bjRudmJF?=
 =?utf-8?B?ZUpYUHdGazI1S3BBZGpjblp4WWU1Y0t5UlBFSHJvYkwwY3NaVmZOMnNyMStJ?=
 =?utf-8?B?UFdKbGUrV2hmOVNzS0FyQkg0d3RhcUV2SDI1b2J6MUhabnZGWm12WDZwb2hT?=
 =?utf-8?B?Y1g0dCtGN2xpVkRRYmpDTHAvejlwYy9LK3NORmFsbTc2bXFhWVZ4UlFUZmI4?=
 =?utf-8?B?M2Izelo2S0d3eGN5NlFWb2JiNzNVaUFacmtsT2Q3SEkzc0VYaXpKU1hnT1Iw?=
 =?utf-8?Q?eoZhupyWgH/90bOu7PYzh14giUz8hJh7fyEpTAH?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ada1b6-8b48-4a7e-dc3e-08d94d3263fd
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 17:01:47.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtCbuMD62GmCut2wmgARnGyMAOC5dCxEkEK6uDwvom0AGvYVUQa3i8CMh7fQfSoCe8XLcRXM/tQA/L13XKFUzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2465
X-MDID: 1626973310-wzvakWF7NpzD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cases where the header straight after the tunnel header was
another ethernet header (TEB), instead of the network header,
the ECN decapsulation code would treat the ethernet header as if
it was an IP header, resulting in mishandling and possible
wrong drops or corruption of the IP header.

In this case, ECT(1) is sent, so IP_ECN_decapsulate tries to copy it to the
inner IPv4 header, and correct its checksum.

The offset of the ECT bits in an IPv4 header corresponds to the
lower 2 bits of the second octet of the destination MAC address
in the ethernet header.
The IPv4 checksum corresponds to end of the source address.

In order to reproduce:

    $ ip netns add A
    $ ip netns add B
    $ ip -n A link add _v0 type veth peer name _v1 netns B
    $ ip -n A link set _v0 up
    $ ip -n A addr add dev _v0 10.254.3.1/24
    $ ip -n A route add default dev _v0 scope global
    $ ip -n B link set _v1 up
    $ ip -n B addr add dev _v1 10.254.1.6/24
    $ ip -n B route add default dev _v1 scope global
    $ ip -n B link add gre1 type gretap local 10.254.1.6 remote 10.254.3.1 key 0x49000000
    $ ip -n B link set gre1 up

    # Now send an IPv4/GRE/Eth/IPv4 frame where the outer header has ECT(1),
    # and the inner header has no ECT bits set:

    $ cat send_pkt.py
        #!/usr/bin/env python3
        from scapy.all import *

        pkt = IP(b'E\x01\x00\xa7\x00\x00\x00\x00@/`%\n\xfe\x03\x01\n\xfe\x01\x06 \x00eXI\x00'
                 b'\x00\x00\x18\xbe\x92\xa0\xee&\x18\xb0\x92\xa0l&\x08\x00E\x00\x00}\x8b\x85'
                 b'@\x00\x01\x01\xe4\xf2\x82\x82\x82\x01\x82\x82\x82\x02\x08\x00d\x11\xa6\xeb'
                 b'3\x1e\x1e\\xf3\\xf7`\x00\x00\x00\x00ZN\x00\x00\x00\x00\x00\x00\x10\x11\x12'
                 b'\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./01234'
                 b'56789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ')

        send(pkt)
    $ sudo ip netns exec B tcpdump -neqlllvi gre1 icmp & ; sleep 1
    $ sudo ip netns exec A python3 send_pkt.py

In the original packet, the source/destinatio MAC addresses are
dst=18:be:92:a0:ee:26 src=18:b0:92:a0:6c:26

In the received packet, they are
dst=18:bd:92:a0:ee:26 src=18:b0:92:a0:6c:27

Thanks to Lahav Schlesinger <lschlesinger@drivenets.com> and Isaac Garzon <isaac@speed.io>
for helping me pinpoint the origin.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
---
 net/ipv4/ip_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 0dca00745ac3..be75b409445c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -390,7 +390,7 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
 	}
 
-	skb_reset_network_header(skb);
+	skb_set_network_header(skb, (tunnel->dev->type == ARPHRD_ETHER) ? ETH_HLEN : 0);
 
 	err = IP_ECN_decapsulate(iph, skb);
 	if (unlikely(err)) {
-- 
2.25.1

