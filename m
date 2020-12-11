Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A62D7881
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437537AbgLKPCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:02:07 -0500
Received: from mail-db8eur05on2091.outbound.protection.outlook.com ([40.107.20.91]:23726
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437549AbgLKPBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:01:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoCplM7qLAC92n06MA1VKXuimTQctUQQklLTayTWhxSbInaHvwYboZYJ60Ya3tthd2vKzWOtqg7iI+rgE8JTM4mQRHtj5Uu8MZ+2OJPK5/tZEgTHBo23lvGu//6PEOkNS3WoBdLZoKizj7QTsR9vQqITvLNY3P8p+3CS1lNQJFxHPu0C3o0wCdxfUKeFki1ngPrwJQvh5f9UuWi3jvmj5+QG7fzsYZ23VPjA1TdYVFuyKztnbn22Cy3mfMVy6eX5hKEWAUlIf1m7hEGoNRUhpsd8nQ2pXu3I7blR1FkpXDchvOtmssxvN6qAF7A9InXVqLNjTrqvdeY2k8Yis/GLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTDVBDz6v8ED8cOVuP+sd1oUSykT5tY1ItyCHf3CcGc=;
 b=W1BTm7X0oPT8eoZzdH2VX8ndkBBMrLglrR0uOd/YMMiY+t4sRVSvKdV+2Ntab6Pa+QTICgSzamEBl8+R1FLSeGmlqr1yT+h9vFKZkY0WxBb1LL76jSY4uIyS2jvROsLvE4iaTPleO8wM0/Xy+MFp3EaH/7AdPj2Hde2xhAf5Z5TEHradEy4XF1y8J1psZtUSLfv5qmbqZN8rm8low8KKvvJjyOC+52/1vQki9EYzoiWHPVLvue1vrK/k0pr3trjM05oYpB3z43NxwuFXQYB6xt9b/Wg6IPlT2QqN8jmMtIvofvOsuuGs9CRg7At5RvwOFCuLQ46yUQy35MNmVp7GkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTDVBDz6v8ED8cOVuP+sd1oUSykT5tY1ItyCHf3CcGc=;
 b=kWsQI2EWoXbwKq5Mcaaii3cfCXznS0tQuzug1yZZ6fxuzuitdY1Gwqk0N7BsrU2jkNikZqhVLmMoasvvyS4QRcq77GbKbxalBW7YViB8bIix9OCUnoDHnJ18lDoDPfGdpigHf9KbSpc+kwluzuBX5W+55K3H5UOITtXIG9nlORk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VE1PR08MB5678.eurprd08.prod.outlook.com
 (2603:10a6:800:1a0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 11 Dec
 2020 15:00:58 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.013; Fri, 11 Dec 2020
 15:00:57 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] net: check skb partial checksum offset after trim
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Message-ID: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
Date:   Fri, 11 Dec 2020 18:00:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR04CA0105.eurprd04.prod.outlook.com
 (2603:10a6:208:be::46) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR04CA0105.eurprd04.prod.outlook.com (2603:10a6:208:be::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 15:00:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f63e3a64-6119-46e0-2da0-08d89de59113
X-MS-TrafficTypeDiagnostic: VE1PR08MB5678:
X-Microsoft-Antispam-PRVS: <VE1PR08MB567814904A3032B08B185139AACA0@VE1PR08MB5678.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uq68TLzYkCgVM7Vda4Fz8jqI9ZERnE89Erjo8Tt8sO+k77dVLBtL5T/BO3rzjz3dLjf69LBkeL9Sc2gmpAnjD3BM+Y5jSd7kHkkvqgPu5Kq/AKoz1MTz1gh+FPVCggIMtfbISteoErSPvsOKLCl9XRL0AYuQGq+hTOzbXBUTeVpicOQkWQMtMh4N4zZ/kIDPtt1Od9oWUskiW/cyzTQLD0X3WtCDmfWCprloyvreR9PCmXZqPY1Ly1FBr015LrQ+QYq+537ZQU3OH58E3EDPLmaio8KZVy5QnRBveVm+tDydjrVg7lCk5PAV7yAeKd5KjGEjLT9waatlcWn6NOvBsb1lH5c45SO8SmiJXNN/6w8jGXPhMq8Ew+8xKcQRELP4Fs8+PKLxYTca5/CCMhBBeVXGJzYxxvg0js17RmuoHNzLB9jLnKona9ARmmP5ii+GOIVNaYIhgwEWmY9aixdGYa5K8q1WFdbrjeTvg73ONsyM7O1ZGIa66Tjjvc1j85Qcfy9krk/kMy0Xp3Zgyfcl+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39840400004)(136003)(376002)(346002)(956004)(83380400001)(86362001)(16576012)(186003)(5660300002)(66476007)(110136005)(66556008)(4326008)(66946007)(26005)(2616005)(966005)(6486002)(31696002)(31686004)(8936002)(52116002)(36756003)(316002)(478600001)(2906002)(16526019)(8676002)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dmlwZ1phekZWclJ5V3FoKy8rbU5kQU1ZaTM4ZXorTmNTWXhDektqL0NGZ2lQ?=
 =?utf-8?B?R3MvYW02ZHJMUStWaXJKTWl4OFZJV0VvQjRyeGE1M3kzc2RXUzI0TEFsUjAr?=
 =?utf-8?B?N2tGZU9pYkdxYmR6OGVITk01dnkyQnNUWDBBaTkwc3BLL2Q5Wkd2SWVPTTg3?=
 =?utf-8?B?d21oTXZxeC9ENGJDSlBxWkwxY1ZuLzkrYzBkZ3RCTThRcW93TTlBSnJKVVJY?=
 =?utf-8?B?NWsrWUhCOTZMeDQ2ZlBoWGhXam9abGpPZVVCTU9ESmNERHhKOTQ1NmR2Q3JZ?=
 =?utf-8?B?d1cwd2wxMk5SS3FXM3hQV2hnTFcvUzNlZDRRRXRwWDdVUHp6Z1h6T2tlSm01?=
 =?utf-8?B?OW1WRWV5T21vOWZvcjgzK24xTDJ4ektSK0tKbEQwdjQ2ZnBDQmVwZGdTOXpR?=
 =?utf-8?B?UFVGaHlvbURNdlNweGNrUWNGMUczTXNEMWlQQUNrNGNCNlRpWnA1aXM4Lzht?=
 =?utf-8?B?NmxQdzNpTmU4ZmRMNS81NjV2U2lTOGtaWldWeXJEY0FvR0xyNk00VUNuTEFU?=
 =?utf-8?B?a2dPNHFPMXAzTUwrY1R3RnRhVDRWb1FNQ0JqRDVvODN2WWNlMHMrcFYrbUpU?=
 =?utf-8?B?eDNycVRNNm9YR3ArcWp6UjZuY2JpbnpIa3VGT3hOMVJxQVNhcGlhYTJENnRm?=
 =?utf-8?B?R1YvdDk3Nk9kUHp6a2Z0UFNrL3BZRTNLRkdLMjNiTU9selpObytCTXB2RmQ3?=
 =?utf-8?B?dlEzRFJQR0lkdHFWQTBhWUxZd3lGbGdXYm4zMnFMRHZqV3ljOEZjWEVzaTE4?=
 =?utf-8?B?bTlSbjdydU5JTkhEbzVLczN4NTdMTlFIeStpMzJpU2lpYjhyMFFUakxRL1Fk?=
 =?utf-8?B?SkgxUXJmcFYrT1RGVE1DVkxiQ1VKR3VNbEZNS29NOXN3N0JhQjRBaGtndmZT?=
 =?utf-8?B?Y3ozMHF6bkFrV0lzM2xCNktFTFZJejQvdC9iZ1RaOFkwS1pQbW02MXdBcGRH?=
 =?utf-8?B?U2lBOVFzYTFyc0laMlBrT2xxNk1UQVlXVTNxdFd0ZWNoZ3RyalFTR0krUXEr?=
 =?utf-8?B?TkRQcGU2cFdTOUFNNUx6OEN1Y1BLZ3hVa0xTV1NUM3RZTnlRTkhLSUhGdG9E?=
 =?utf-8?B?T1crNVdFcWhXeW1yd1JnOGZlR2NKazF6OG5qOTNHTWNFOWZDUFpTaENFcEJa?=
 =?utf-8?B?V3doMEJCYnZsTXYxOFVGV25wbEZkSkRZbzd2ZEVaTTNTTVJxV25scFVwbUUr?=
 =?utf-8?B?OVJUZW1BSUdZaVhFWmdVZlNMbkVtN1Q5L051WXBvOVRITkZsZElGS0dQMnZM?=
 =?utf-8?B?RTB3ZUFreXpZZ29qM2w3eHhqMGZ6WDhYRU9kRUlyVzFUQm9wS0J3ZFVRQk9m?=
 =?utf-8?Q?cPqfGoJ76CNpIv28DzSH4AOkRlV+QiaYfT?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:00:57.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: f63e3a64-6119-46e0-2da0-08d89de59113
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfx5i9qx0YLnT89MBOzV6FAgpakYzHBMf5QfqDKZyYmgBadtaLu1mVlJiGnjSGFT7k0d66NAB6mlnQ8/pnyqqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5678
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reproduces BUG_ON in skb_checksum_help():
tun creates skb with big partial checksum area and small ip packet inside,
then ip_rcv() decreases skb size of below length of checksummed area,
then checksum_tg() called via netfilter hook detects incorrect skb:

        offset = skb_checksum_start_offset(skb);
        BUG_ON(offset >= skb_headlen(skb));

This patch drops CHEKSUM_PARTIAL mark when skb is trimmed below
size of checksummed area.
Link: https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
Reported-by: syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 include/linux/skbuff.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a828cf9..0a9545d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3419,9 +3419,18 @@ static inline void *skb_push_rcsum(struct sk_buff *skb, unsigned int len)
 
 static inline int pskb_trim_rcsum(struct sk_buff *skb, unsigned int len)
 {
+	int ret;
+
 	if (likely(len >= skb->len))
 		return 0;
-	return pskb_trim_rcsum_slow(skb, len);
+	ret = pskb_trim_rcsum_slow(skb, len);
+	if (!ret && (skb->ip_summed == CHECKSUM_PARTIAL)) {
+		int offset = skb_checksum_start_offset(skb) + skb->csum_offset;
+
+		if (offset + sizeof(__sum16) > skb_headlen(skb))
+			skb->ip_summed = CHECKSUM_NONE;
+	}
+	return ret;
 }
 
 static inline int __skb_trim_rcsum(struct sk_buff *skb, unsigned int len)
-- 
1.8.3.1

