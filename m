Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0328F2DA01F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408926AbgLNTIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:08:45 -0500
Received: from mail-vi1eur05on2134.outbound.protection.outlook.com ([40.107.21.134]:49281
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408917AbgLNTIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:08:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtfOGTCMfWnne+TzUDDz3DEwrBurtTk2MFeYohNgRAwra4QA7du23msoCZFMxHc58pzwpmlywHz4XLDuLEGXUGPKd5TpHgCr1DTyBZplmmxe9qGQ2su9ANwI2xsaJcnA6IDU3DHVh85Zr2GZXoXPealElzN15e+y0L4am4A1n6xPm4a2G8r4SuXotX/UgoNLtHELulGscUFETW8mcGJKm76b9BTOnQ5PNsyI4dzcAtZ1Aqo7OT9vpaVw6zl9q6nWhNc59XkIhL63t+ajh8j59b0dV3fo2WQPdJ342YvwIAsYSlyJxSg3+i4pGBgvbRNB4iVuBxSfoVCWuWzLqziWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pToZO2XyyNDAjTjfRnVBcKQ6rX9ASC5CjKtCZZKhoM=;
 b=RzGiRYCTybd5hnQUvzyFaIG/yGYluZvepx5GUSi1SADt/1UxU4o+0WXyXojr+yBwzzuzcgceyMCVrN+ITCCkZBamo6Md3kVc7KjuezYfidKSyoyZOP+VPjtmW8XyUNXT24sSshqzLj7YwByI2cBHJ5JF/dEQ/uXz2PF6POJT3D144X1kmL7Bz4huyTc9Dn1LwHCKuNIwa+/7lWXDQxPqPIBC0ykpqwFlfJbSL/yMDA6QleeAAIHzKTGFpo5c6EB6vEJp+Bd82Gpj/ijwaocO8a68OD07tI/vN0HQLVVOS90+AMg/qg5tgFX73ctiKB55PVso1pwgnJd9hx26wA6CNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pToZO2XyyNDAjTjfRnVBcKQ6rX9ASC5CjKtCZZKhoM=;
 b=ol9nfGUgGNlxgqC19AN2CHToSzlthbzORsMnIfPAnROOyE/VuDYdpVwMwW042tLZeOXcgCaO9cX+7tyl7n8qbb4JIesUkvb5BsOwMP7ZxcPki17xis4RdgaZzfPvcwXs8o3v/AmJ7S3nGxBhu3qgSyoFwxYBjOkZEcBeZkecrSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB5455.eurprd08.prod.outlook.com
 (2603:10a6:803:135::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 19:07:41 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:07:41 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] net: drop bogus skb with CHECKSUM_PARTIAL and offset
 beyond end of trimmed packet
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
Message-ID: <1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com>
Date:   Mon, 14 Dec 2020 22:07:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM4PR0101CA0059.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::27) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR0101CA0059.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:07:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79e25654-cb79-4b31-e8fa-08d8a063880e
X-MS-TrafficTypeDiagnostic: VI1PR08MB5455:
X-Microsoft-Antispam-PRVS: <VI1PR08MB5455C491DE04715AD4D50418AAC70@VI1PR08MB5455.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5wFv2SZWdb5UABmRh5iZzoDOnGTuV7XMIYVUEIkWTNNs4OatwO8NoQbEmHOcom8JGB8xN8rvQWgXE8qc0F8MY56TkDTY3GCCsKUkX52n5z3zAAkKgW8d4W4dDsIRURkCszwAMEO17mlFafuUBlwiIrRMM1+2R4tZ10KOT0NJrP09MWnHESBi5auTS14ywjPJVTzjWmmx2p4z94EEzRBzHl0CLw4iozgLjA7GlnBJCUf7Tle0S9pMJ9sxvBORiIzTGWhCqn4usJQ898b+RWdVS5CO0moX9UEv/W876efg0JaWyWLJp1c//fbp78QCBQNEf3UBwswkCKjAmy5dDRCDJa5AGSQswMttXAlj3ITATKfBXA9qWG/hj21dw+QNasQXBH8lsmspP7AeSUs8ScfOWBKkpalbgAWqtD1QZ9hiufrpAIXcQGJQXBmazlx1LbRkW89NwUjwdqvhPRokgZeOHAp9RWagKX26UEyHmHfTmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39830400003)(31696002)(52116002)(8936002)(83380400001)(8676002)(2906002)(26005)(16526019)(186003)(16576012)(86362001)(4326008)(36756003)(316002)(31686004)(2616005)(956004)(478600001)(5660300002)(66946007)(6486002)(110136005)(66556008)(66476007)(966005)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MS81TlZGbUh5SlQzQ1lTYkhCY0J4dmVHRHRGNWxmb0pWbEgvSEVDUUFHdFd2?=
 =?utf-8?B?MGdyaVJ4TVA3ekVLdHc1cUIzVHFTUkc0Q3dpdHYrYjZ1UTRKSTBITnZFSzY0?=
 =?utf-8?B?TXZBN21sTExBRUhlRy8xMGJ6djJhN2R1ci94TW0zOUI5ekt3Wk5INU9xRzZX?=
 =?utf-8?B?c1dhS3VaTytYdWFVZUtLUGV3enNBbXVnbTJScnBqZ2VXcWRjekU1NWtpVERD?=
 =?utf-8?B?RUdYTmVNNlRBSnJXamVIRnVxM1kxOHpSVUwrRUxYK0VpVGtUZnRjdjdZcVYr?=
 =?utf-8?B?MmpoOGNXT2lKSk5HSTRKQldhaFp2RUF3eU1nbmJIS1NTck9PeWxua0RIVHZV?=
 =?utf-8?B?UzdvOGhxNEp2Mi9RT0RUbTN6OUFyblZnN0hISWl1TjRqS3JWS2h3N3ZRTWZ3?=
 =?utf-8?B?VlEzQkJRVHpBK0N2RHpyNTlnMXREZTNacGlndGIrWDBMeWJobHQ0Z3VCZHFZ?=
 =?utf-8?B?dGxqdTdLcnlTdGVFNnZlNU9GUW5GRzlzODJLRDZSdFNUTjc4SFlaSklYaDlO?=
 =?utf-8?B?SmV4Q0I1MWF6VEQ0dDAyWm9LT3o4cEdLbHBLMkQyNVdSWTd1NUpaZTdnWFEy?=
 =?utf-8?B?VFpDTmFwUGxMcXJtUDFaWER4UXVGL2czNXpzZXZzdjVJNms3enZVVkQreUpP?=
 =?utf-8?B?SXU4bEpSbXlpNmJwWm1pY1ZTZE5Jc2xUZ3U4MUowVjUxSnEvTFN6LzYvemlw?=
 =?utf-8?B?czBWcEVRT1RLckdEeWRGcVdFMEY5WUp4WmZ2VS9tVzgrWjg5REo4NjR5NTRG?=
 =?utf-8?B?bTd5NWlzWnEzTmlrais0WVpmaFVtVHM2ZlFKSVhpV0dBSHhSWmdYM3BRa2Zj?=
 =?utf-8?B?T2ZCTjFzU0RlMVk0UnFJMDE0bUE2TVZaWXpwalZDOVl5Q2JtYjJBU2Q4Q2F4?=
 =?utf-8?B?eithaTJUT3FEMTlIVGxyWW5oN2YwSU1JTmszUDZiTGZJR0l1NDdWMzFsN0Jr?=
 =?utf-8?B?TnBiQkF4dFdadFcrU1pvM29UL2tLcHZUcXY4OWswUlBTNkpLcndISmI3NG5s?=
 =?utf-8?B?ajByVm9CaDRSaDBBQU1ZblUzTkg4YXp6VEFWRTJmNVhQdHNzaWJJK0UvdHdO?=
 =?utf-8?B?TG9BVGROeEd2REFKdUlOekR5Q2RaUzJ3Q2FZZWlLbFdac3l3QUxEL1FoUnBr?=
 =?utf-8?B?RkZic0UyVTM3eVBWSnVSWURtdDJHZnVkOHFwQzJkcHl2RE9ScTBoeG5LWS9T?=
 =?utf-8?B?U2FlYUgyaitjWFpTOTNuZk96ak9aK1EyWEhGeGs5U3VvRWcyTU4ybnhSSkho?=
 =?utf-8?B?UThWZVRkeEl3U2dzdXJDQmFjUWkrWDNQSUF0dDNMenBpYmQrWEtTcnNLaWhr?=
 =?utf-8?Q?QQlN6LuRpmDyUDb3zgF3tMWeUi8nUjkutr?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:07:41.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e25654-cb79-4b31-e8fa-08d8a063880e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbKcYJ+JAId3XL+aUkrOAWToKQBZH1E09f13LpGZTCZlu78vf7T7kQai9T9iqlgaaeyOaeFqJPBmXzonMFHIPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reproduces BUG_ON in skb_checksum_help():
tun creates (bogus) skb with huge partial-checksummed area and
small ip packet inside. Then ip_rcv trims the skb based on size
of internal ip packet, after that csum offset points beyond of
trimmed skb. Then checksum_tg() called via netfilter hook
triggers BUG_ON:

        offset = skb_checksum_start_offset(skb);
        BUG_ON(offset >= skb_headlen(skb));

To work around the problem this patch forces pskb_trim_rcsum_slow()
to return -EINVAL in described scenario. It allows its callers to
drop such kind of packets.

Link: https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
Reported-by: syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
v2: drop bogus packets instead change its CHECKSUM_PARTIAL to CHECKSUM_NONE 

 net/core/skbuff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e578544..fbadd93 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2011,6 +2011,12 @@ int pskb_trim_rcsum_slow(struct sk_buff *skb, unsigned int len)
 		skb->csum = csum_block_sub(skb->csum,
 					   skb_checksum(skb, len, delta, 0),
 					   len);
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		int hdlen = (len > skb_headlen(skb)) ? skb_headlen(skb) : len;
+		int offset = skb_checksum_start_offset(skb) + skb->csum_offset;
+
+		if (offset + sizeof(__sum16) > hdlen)
+			return -EINVAL;
 	}
 	return __pskb_trim(skb, len);
 }
-- 
1.8.3.1

