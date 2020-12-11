Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB712D7990
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgLKPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:38:58 -0500
Received: from mail-vi1eur05on2099.outbound.protection.outlook.com ([40.107.21.99]:51593
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388429AbgLKPiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:38:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foLB//2NlnSgEzHZ3kyYBa3R14HF7LqGWKrmRRueSlIhtEZ2ACn550WrnxnHpvTJi7qnr0tsQNyMD5D8znbHPkXNM3Ton5Y9PlqjV7w5prbYjWqdAnJnqDL3nCRYZOrV/GPJ5U3ft4OXQ6X4a0bzqox7bjD9765UD8Fx/gZUekKuozRoTX4Av8vU3zikFB35jgxTvu/vzKQFJ2F6URX4L9McR44J/Zlj7BqGb32QDvul9CKiC3f/hfZYSlDjSbFvNoQS5cE4/qGo6NYLWlWkZoeuUA6eEYprrXc3bmlUuwhc9zwV2ULcr9cDkTrZMVxBgxky+IRAYkzGOmfUEY+a6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1sJP5shswoUwiGk5Rg1ub80ljuE829dKHlCy7tjYv8=;
 b=IZxg91FbBAlyPsHHs8t+fXUpUnuROu1rwudNJkURjOJFwAtYvaG8ftjJofPiYXCXXvPM36XzPoym3VcBpnJ0ywiGXbPITrp+bCe5iXFIhLf1gKn/EPYKw2UdgMqXbXIkOLEg1Ycz823S9chCKrm5yWab+L2M8OE/BvkjM1mN0yN/u2BQaLqNbGkX4P0O2506OkTOxRKkZT9LTgfYMNMIC9GI0zH35Expi+aHDsnoKzStBsE3HdtcL4k2mgLm4k6YbOJ/s8+mQ0ICAdlp5iSVynRcjmNNJbXqtqYs7gUbv8qQ/KcfEwAGdrQkhnsBIjDEo9xK08WQ5rTPriOfYBCT/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1sJP5shswoUwiGk5Rg1ub80ljuE829dKHlCy7tjYv8=;
 b=g0z+iXVeuetP47eBErbmToS+m5t9wat9z8GbUjRdfY6wAQHuh4qroeuuQSvN/Utsx1WHJL89RLbpOK954CoxX5RlB5i/7hoAVgQ9WSxa1DBwAZ0CSlgpbHck0NTDWI/9slC1+0xGVLv8lW3c6uUF4olDuuGzuHFhI3xGWaUHnL8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB3936.eurprd08.prod.outlook.com
 (2603:10a6:803:e4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Fri, 11 Dec
 2020 15:37:36 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.013; Fri, 11 Dec 2020
 15:37:36 +0000
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
From:   Vasily Averin <vvs@virtuozzo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
Message-ID: <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
Date:   Fri, 11 Dec 2020 18:37:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM8P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::22) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM8P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 15:37:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e60d41f7-e016-4fd1-30a2-08d89deaaf64
X-MS-TrafficTypeDiagnostic: VI1PR08MB3936:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3936B34D01ABD6FA81838B03AACA0@VI1PR08MB3936.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ns+mQC1KOnJ/G1EV/Rs2NAtIsghInup+SrmVN5sqliApaDS89Pzv8n/hbHCCDpK+7plMW5EFYOG7P/GFQqrZh16GLyUbgBVj5P2cqYWeN2iWtvDq2kh2tO5Jps197uF6Ws4ka+WEbxvBIm2nB41nvB5JDHobrWzky2DxX3egpRQNxVuSpLqoh417heLfOV9TkAxvthy1Ifm1xwTtKF5BXwsiDom52O50glVdayBvS8Ily3vcyFmOLVvDkR/IzwtPQLhZT7wPbx++flNxVpe4q47OKeMwWo9QDFNYD1x9CwOzYjIlGEDKCPQOBUOWS9Y2029enJ3uPWya/joCnt9Dg1CPBpE21Pf3qH7PIcdx0tQXisHGxylC2tIMBGtW1Y81jDq0uqf0a79JbhZWNb/a7GLHeCoZcA/OphCA+8BHGNiRx0oCC0ZL3h2NKarYvaQC8XGAEv0hr4OL+/s/hHhj4u2xkghoXvuI9Yfww57Uo2Zk/LyvB+bcWPnMQGTYFWTWvavXFipE7au2xt19ltfGxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(366004)(346002)(396003)(376002)(66556008)(53546011)(6486002)(4326008)(5660300002)(478600001)(16526019)(83380400001)(36756003)(2906002)(186003)(316002)(16576012)(52116002)(66946007)(31686004)(8676002)(956004)(26005)(66476007)(31696002)(8936002)(2616005)(110136005)(966005)(86362001)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bzRJVFVuSlNMY2ZWalYwUTIweWR5STJiQUFhYnRBK1VpYzdkakN5Mk1nWFZ3?=
 =?utf-8?B?YkIwWVdEc21ZUTgwd0Fva014bkoxVVRxbWViMUNzUnpnSFNrTThMLzlGMmN1?=
 =?utf-8?B?Mm51My9nVE8zZVhBcFhlaThRWmM1cDY5Tm5lT2JSM3I0MVBhM2YwWjBuc1Nq?=
 =?utf-8?B?OWhBeWlpN1luT29ncFFhb2FGbUx3OTVFTUVsbVNVQkZoRGlwVW1XM1JEQkFO?=
 =?utf-8?B?Uko4Sy9vNUtyUjJZM0ZONzl6Nzd3M0hwck1scWFPbzd1bXlOUDJ4N3lJem5j?=
 =?utf-8?B?cCtva0tYSGFFQSthdlFlbFY2Q1phRUpodGxXUVZ0VDBlYnlkbWtqaWo3UHVR?=
 =?utf-8?B?QXBMSTE4ZlBpbnNHWnBYNkRHTEI3VEV5VENqdTZNTXRiV1BtZ2NMTTNwK2s0?=
 =?utf-8?B?QXVYanB2S25PblNxRFRyN1ZNV2RaWW5pVllhb0x6VXZXb3NWaXNkblRsRHIw?=
 =?utf-8?B?UWNubFRVTzRJQnFiWlkwWDhHdG5XWVdjWEs3eGtSZVdmWUdTd1R0NHJXUmVI?=
 =?utf-8?B?T1o0MXp2emN4RUM5eWRtMHJnS25tcURBdjFoKy9WbXdibitzRi9lTmYrank1?=
 =?utf-8?B?ZW5GbEg2UkRwRVFiK1p0YXNERWMwVXl1dkJ2WnZDbEVrcGNQSDg4a0RQaDVX?=
 =?utf-8?B?K0E3d0oyMXNVV1ZPUWlTblFUSUx0WjJkUnVKQlRpTUxOaXV3cjFSajRjZE4z?=
 =?utf-8?B?ZUtBOG9uY0szbkNxQUhSQ1FFMGFkV3Y1OEdtTXd2dkpSRkNpRTRnTmhRc2NN?=
 =?utf-8?B?Mi9MUkRkeThCcmFTVUFEMzhFQVBudVRVSTdqZTZ0bk53QTJaVmswWFBkdDVs?=
 =?utf-8?B?Tk1DTE9ldDgrV2FhZEtaK2FzMGR5SnM5Y2VDbTM0ZERXME5WTzFIZFJwY010?=
 =?utf-8?B?OGttdUxHdXNsN3F3eHJNbUxWdTBCc1VCMVFVRVlNNGUvdUdTcXBYeVljcHNH?=
 =?utf-8?B?dy9DMFJqeDRmalcrajdSNDJySGt0Rm9RaEIxaCtBVGQ4MGVhVkIxVnBnQWVo?=
 =?utf-8?B?YUdXa3Z2ZlVEN2RMeSsrT2ozUU5yUzhlc0hyOVRCKzc1aTJ1MERZSzhlNWp4?=
 =?utf-8?B?ZnFpODE3Q09uQVB0ZHZzM3JZU3A2MjhOUy9TZXNVZUFEWkFHZHYrc29nWTNO?=
 =?utf-8?B?cjllMVluSmYrS0JLRUtXcEx1MkovaGJrUlBxK01qUXZleTdxTFRGSGphUnE2?=
 =?utf-8?B?UHNGNFg2bFNOYVlKdEIyNHdvYXJPOTRHcGdmSEVHdzM1SUpZc3hnVXczMnBk?=
 =?utf-8?B?ZVJFS056bDFTVTd0UXFjTnBGZTVUT0N6NVd4U1RTL0t2dmxBK3dQRkFOZGMw?=
 =?utf-8?Q?4oHkomBArKQ52LrSvcWH8oBwCIGt/ZFQ2q?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:37:36.2262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: e60d41f7-e016-4fd1-30a2-08d89deaaf64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0e7Y6PO6nI3GJ8M655L0KilVxxOVpdQjGh3sgQwdKDQb2MrUC+/DPRz0GeOtpj7kQNM2mtbkPLLJm/cdwtsPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally it was reported on Ubuntu 4.14 kernel,
then I've reproduced it on upstream 5.10-rc7.
If I'm right the problem is quite old and should 
affect all maintained stable kernels too.

It seems for me the similar problem can happen in __skb_trim_rcsum().
Also I doubt that that skb_checksum_start_offset(skb) checks in 
__skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
Could somebody confirm it?

Thank you,
	Vasily Averin

On 12/11/20 6:00 PM, Vasily Averin wrote:
> syzkaller reproduces BUG_ON in skb_checksum_help():
> tun creates skb with big partial checksum area and small ip packet inside,
> then ip_rcv() decreases skb size of below length of checksummed area,
> then checksum_tg() called via netfilter hook detects incorrect skb:
> 
>         offset = skb_checksum_start_offset(skb);
>         BUG_ON(offset >= skb_headlen(skb));
> 
> This patch drops CHEKSUM_PARTIAL mark when skb is trimmed below
> size of checksummed area.
> Link: https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
> Reported-by: syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  include/linux/skbuff.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index a828cf9..0a9545d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3419,9 +3419,18 @@ static inline void *skb_push_rcsum(struct sk_buff *skb, unsigned int len)
>  
>  static inline int pskb_trim_rcsum(struct sk_buff *skb, unsigned int len)
>  {
> +	int ret;
> +
>  	if (likely(len >= skb->len))
>  		return 0;
> -	return pskb_trim_rcsum_slow(skb, len);
> +	ret = pskb_trim_rcsum_slow(skb, len);
> +	if (!ret && (skb->ip_summed == CHECKSUM_PARTIAL)) {
> +		int offset = skb_checksum_start_offset(skb) + skb->csum_offset;
> +
> +		if (offset + sizeof(__sum16) > skb_headlen(skb))
> +			skb->ip_summed = CHECKSUM_NONE;
> +	}
> +	return ret;
>  }
>  
>  static inline int __skb_trim_rcsum(struct sk_buff *skb, unsigned int len)
> 
