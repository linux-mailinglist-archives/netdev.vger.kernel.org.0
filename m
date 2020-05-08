Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF321CB8BC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 22:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgEHUAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 16:00:41 -0400
Received: from mail-mw2nam12olkn2039.outbound.protection.outlook.com ([40.92.23.39]:50241
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgEHUAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 16:00:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaS9dxVIkrFYP/LGfcazexHfD5lw6FCNTbTidZDBnG9EFkpLVFzzH4gtq5tbo7ckcHWd3h/eeyGvonNr/wnJJTTqM2CBcxWItam05KRgBxBb03LIwerqBSgNxj4oF17CGRMkrOTMUYKV7U2YZDKlOfk2ZwIzuwWqNGQjNGBh7TkGEZORm3UWH0OfxpB8u9bn9uTHUbbHV+xwVLvwbTTe9YuRzdGu2ead0cdzFep3YLIYO9q2WVA/uGN6NI1u4b5VdQQ8u6trbNdUXahqDAoYRcwgcv6O4M7wOocm255WHRTsW3h7ug+OREGisEa1r1cRDjknpXihx8RmkrGPydWEcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAmSsuWwkrP6YvSNnNzJwigV6XQ3L4E7XFJ3fUtzyLc=;
 b=HpXpwWJ8VfD2woq343KWJGOVKw6Kn86sOKDqR3OZ0HimJZHxO3dJgm+cGY8k3QLHbVC6pfSedkbfRw285Kd7b+DplSGIuloHEqAbV9T9SJjawZRJnU1iX3HGNid5elshCV/ZpOuxyTbPBgnSHtldvxfp3P2b8sCNlE/AYaj84UnojLqGD9bC/ZWdMZfRT/854qdpY9wXdOdIaVeuswz5VAQKM2BT0rqKbN7XKsAgouTc7IupzIapK/9aJtEgsmLfN0R1rtUaoYimeux+KFM0XNx5JfiGV02EUbwL3kc/GTyHlLxjmAj7b/7j+lrjoFMdF4KJmBn/HcaaRffQpSvCyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=klittlepage.com; dmarc=pass action=none
 header.from=klittlepage.com; dkim=pass header.d=klittlepage.com; arc=none
Received: from MW2NAM12FT005.eop-nam12.prod.protection.outlook.com
 (2a01:111:e400:fc65::51) by
 MW2NAM12HT212.eop-nam12.prod.protection.outlook.com (2a01:111:e400:fc65::483)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.23; Fri, 8 May
 2020 20:00:39 +0000
Received: from MN2PR19MB3646.namprd19.prod.outlook.com
 (2a01:111:e400:fc65::40) by MW2NAM12FT005.mail.protection.outlook.com
 (2a01:111:e400:fc65::72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend
 Transport; Fri, 8 May 2020 20:00:39 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:41E574D3680BF688916B0B97A83AC78F929ED314B6BF0213B39998A355482840;UpperCasedChecksum:AF27B248FEBE936A4AD6F08A3D14ADAC1DD93A069D9A3A403F7E6A367387E314;SizeAsReceived:7903;Count:50
Received: from MN2PR19MB3646.namprd19.prod.outlook.com
 ([fe80::ac7b:bbc5:d13a:5621]) by MN2PR19MB3646.namprd19.prod.outlook.com
 ([fe80::ac7b:bbc5:d13a:5621%4]) with mapi id 15.20.2979.033; Fri, 8 May 2020
 20:00:39 +0000
From:   Kelly Littlepage <kelly@klittlepage.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, iris@onechronos.com,
        kelly@onechronos.com, kuznet@ms2.inr.ac.ru, maloney@google.com,
        netdev@vger.kernel.org, soheil@google.com,
        willemdebruijn.kernel@gmail.com, yoshfuji@linux-ipv6.org,
        Kelly Littlepage <kelly@klittlepage.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Date:   Fri,  8 May 2020 19:58:46 +0000
Message-ID: <MN2PR19MB36463B624F9DF2C29771E147B6A20@MN2PR19MB3646.namprd19.prod.outlook.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508112920.141e722f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200508112920.141e722f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25)
 To MN2PR19MB3646.namprd19.prod.outlook.com (2603:10b6:208:190::14)
X-Microsoft-Original-Message-ID: <20200508195845.2170-1-kelly@klittlepage.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.net (98.221.91.232) by MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 20:00:38 +0000
X-Mailer: git-send-email 2.26.2
X-Microsoft-Original-Message-ID: <20200508195845.2170-1-kelly@klittlepage.com>
X-TMN:  [g0WJXAQB9Z3lhGgzYdcyxa/xf6Q/s+gv]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 461ef316-6c11-474c-0f5d-08d7f38a7ad5
X-MS-TrafficTypeDiagnostic: MW2NAM12HT212:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ph9Sj66+a0wAYs5arA7hvAyyQBjAHZ3BaL3m+AbJRizfxk84EGxMKHI2fNH1KE1OA6pGoODFkb1iIsPuZBRlNJ/XNwzFurr34L4onrD21aLHH7P/f8lM1JRmb3Pl/FLiKcBnBc2Z9Mjm5CKCdxmxZ3akDPkLAMgwwUtd62gr60RmaJV+vW8iIy2yZZyEdUPMBJT+bj2Mb/6I72e/0FyWYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:0;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB3646.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:;DIR:OUT;SFP:1901;
X-MS-Exchange-AntiSpam-MessageData: +vpqjUNDhaoEntMgMW7aQXfKB/qbHahhCg8gJLv/uzTskDQAbC29Twv08olxwsZDiPqkD29BHTYUOU9zSnEf22LeGPcDdyi7cRp7w4j5ZS8XGFNQ86IqKD2rZyZVk1NcJatQV2QwnC1nb3AIZVx2Vg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461ef316-6c11-474c-0f5d-08d7f38a7ad5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 20:00:38.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2NAM12HT212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kelly Littlepage <kelly@onechronos.com>

The stated intent of the original commit is to is to "return the timestamp
corresponding to the highest sequence number data returned." The current
implementation returns the timestamp for the last byte of the last fully
read skb, which is not necessarily the last byte in the recv buffer. This
patch converts behavior to the original definition, and to the behavior of
the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
behavior.

Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
Co-developed-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
Sending from an alternative email given the compliance footer that's
unavoidably attached to all emails from my primary account. The patch
itself is unchanged.

 net/ipv4/tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377..e72bd651d21a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			tp->urg_data = 0;
 			tcp_fast_path_check(sk);
 		}
-		if (used + offset < skb->len)
-			continue;
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
 			cmsg_flags |= 2;
 		}
+
+		if (used + offset < skb->len)
+			continue;
+
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
 		if (!(flags & MSG_PEEK))
-- 
2.26.2

