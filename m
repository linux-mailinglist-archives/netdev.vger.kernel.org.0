Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577703945A6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbhE1QH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:07:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:24476 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236829AbhE1QHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622217972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHHLW5NDzSGZmt0zbw4K842+r0h0EgSHLdYF6IWsZPA=;
        b=FIaxxgV+QcOh1CVoz5t31VVEz9E4jQ0Tyvbsx8kB879Ue9VoT6y/QtgLdfgY/1mbbE3WcO
        XF2g/sHb3bnzzzX0qtmA2bPeMl3CJfObANj4ydckjbwGmpdXywBMk0r35mNfPdTdNI0icg
        VFaoNFbajdjDxdE9yZCLlwy1qVWE+ro=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-HqPp-Z3VP5GAdQMawBVXYg-1; Fri, 28 May 2021 18:06:11 +0200
X-MC-Unique: HqPp-Z3VP5GAdQMawBVXYg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQFvfKIFtTsBaDiiWSjzw1k1qrLUxXfknRRPfXILjwKQukKnZ7MqzdeN3vSbsjUeTFomfdBNl4cdxQgyFUE4GFbvCb3E2GZ9L+GYlCT4ULxjDrAKyks8f+PtDK5Y7JoudoFonA6ij4HIv5OK/bnrt+OhN48Wgk9mlus/Uyi518FuML3n2AhZV2IpSHQQSIOJtmJUuuCT5LXc6F/q0JflwGN8G+9qYVgQZoc1tbOxLpZsW1FFrLxy93NcvojUKeeIpg2caYb3lInd4jFQfi+W+IYUjGQPO8WYuSnpBLRtuS1fb/ZCKIzqSXrgWLbf9DbKTQIDA5bwpXVGtB/MKrOHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LBeo+nvBbp0OslWeWV7ZMBNopvn9e2HmrZzwE6xeu0=;
 b=ScIuBCSYM8k7gGm6rrxbR1C2G8o+cAobsfu+kIh0kfisc/JP/Nem6UyALajniR1/DfRHN3YNi34WEgIjNHBqPKryVXyRLUessF4vbkP/5tLX95CADZXSl4rs5RNNh+ZzT9hdyV4JM/8S9L2ONIOmNf1i02qyDsN/gHtm/7N6PBtPBTERsM0Uq/4yIlBd4GZ1+47TSkAfZZmyWpyxLXhqKv2fT+/gSDC04x8g/k1f/W21UetUoJTarvRcwcm3TZtONyYe6uqzVGDGgbZvv9yOEgQUE37Cwg/k+NKqFkVqHCqGaBOUw9sJQPn9t1Wv3jzs1NDVpZtoSU8DMTs+eVP0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM9PR04MB8415.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 16:06:09 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 16:06:09 +0000
Subject: Re: [PATCH] xfrm: policy: Read seqcount outside of rcu-read side in
 xfrm_policy_lookup_bytype
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
References: <20210528120357.29542-1-varad.gautam@suse.com>
 <YLEIEa6DLjgd5mu5@lx-t490>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <a288e9e5-e6d7-b732-980c-38c6d971abe9@suse.com>
Date:   Fri, 28 May 2021 18:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YLEIEa6DLjgd5mu5@lx-t490>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.93.32]
X-ClientProxiedBy: AM0PR02CA0089.eurprd02.prod.outlook.com
 (2603:10a6:208:154::30) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.155] (95.90.93.32) by AM0PR02CA0089.eurprd02.prod.outlook.com (2603:10a6:208:154::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Fri, 28 May 2021 16:06:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3925822a-d767-4777-2919-08d921f2818f
X-MS-TrafficTypeDiagnostic: AM9PR04MB8415:
X-Microsoft-Antispam-PRVS: <AM9PR04MB84157B6BA1FF99F5FB1E51A0E0229@AM9PR04MB8415.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9E+LZZdGSiiof2alKTb2yuUoUupI1IAK53Lyan6yhGHR0C0OnILw8vsOmvUY/iID+6PiUEZiKP9xZFy/+OY3fTBZ4mH5+6S9xNbjLSyDHn0ibB/k6A9XTm7yXm/nTw3YGr8lE/6d1jq+JKiD+V74pX3J5EU9Xt6nDUG/pmqItLzORhOiJjH3w2T6bswsPFV+1QErP/1VkIAKhuhMIqegjAvRNkSp1zGKiNy4Qx8ZUyQX371aQflT6tp90J7B5wl/EcwBJ4W6iPtB0mDDwOl9Q6zX9avKEaVh/ReW4YLhV/X6pPRU99anlXgrouc/XEHIDdKBdB+OEPCoPRqkAKaCz4yhq+Ed5O7S+TAr75RthhstloKyVVAdiXgdy+xbE+2fvHtGCxRwwJWKkK4KNrnmPm9mg/nOpTuXhDMIEXfarkaVSz13ZzxkqhC3h/uIQ/CvbP7Vigus4NPFwNIemRLLbFrv4l4t3iRiu2ta6FMBy6YiKW1i5xpkPacUGqi8likbd7mgRPYguYksrydiOpDuS2MSIzr6gpp1/8r/hg2IwXtTL3KbHesCSdLiIyoGZcNJL3/cSBoMTGzkIqOubFWaJy8QyxulFe+sdFrPlVZwm+gddUiUbtfJL5YwOl1kB23iwehOf1C6IBkw43RDdiQ9biDV7FDCg0DT2QY/6NZ3Hiqg44mAjia8k6oq2avtkQW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(396003)(376002)(31686004)(6486002)(316002)(86362001)(26005)(6916009)(2906002)(44832011)(956004)(53546011)(16526019)(8676002)(5660300002)(8936002)(54906003)(16576012)(2616005)(186003)(66574015)(36756003)(66556008)(31696002)(83380400001)(66946007)(66476007)(478600001)(7416002)(38100700002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YTCWIHpFnRBKCBToyVn/rE7IYljauP0+CJgQr+lkEqro/AyZL86M+eltU7oL?=
 =?us-ascii?Q?HTtq7tdViqVFSpOOirwL5xhCqK6PKUh8AiloxTCev0iC34H1p5+5UREPs9vP?=
 =?us-ascii?Q?9TenlQFvPTGiyv43kjfhH0ByPIWDYKNwp0OHf+U5Ws0JsFassPJSpeQAIkae?=
 =?us-ascii?Q?X1Hhb91Xk5/OySUeRtbNJ9ewOZa785A18aVDUoNOhi2APANpnFfJvcy6UJzu?=
 =?us-ascii?Q?wsdjzVOznsYHVSEUoilsAOopi4+PihSc+WyIUImtpCPu4hwWYUpnP285ENVU?=
 =?us-ascii?Q?XHEADZnbhA0w1FMbI5ZJvoVVjgBPsURrDsb79v/DSB2b/W3uUpkXR5XXJYUT?=
 =?us-ascii?Q?uaZiTBYOlL9UF2MOSH8ZBao5mm0nTCIpxN6oENRnkwl4+rB7jorA/CMUXdTp?=
 =?us-ascii?Q?LfqTjpi3fT4X4V+Et7MewH9Ef0Z7lx2uyEET1jNIhmSd2USmQfv96jVBwb4O?=
 =?us-ascii?Q?YLkSfa4g2vyk9P3zfQT9f4vd/raNuYIHije2tPpJ6DkKRz+VUBFRpNBFnXI5?=
 =?us-ascii?Q?eL7jDpzwBXop2e0i104hQeTEErFUCNoA4qrFuGFFVOUZiOT5wRC3Uz/NMTEk?=
 =?us-ascii?Q?1VznDw97lMMdX4m+4Zfdqgf81OUT7kF/Q1eVDDXnmEHf1vicYwYlFShDgADV?=
 =?us-ascii?Q?rAvNunaj4s5jq4Lb+c74/PxnqwHKobg8Y5TBajRJBFbs8qeuM3sHaJ/kR4NR?=
 =?us-ascii?Q?IA0/J9PtjZ5OUtMpthDs5nolHteuqqZe19ozXxOZSE7qWMU+iBnHt1TW9cud?=
 =?us-ascii?Q?B2rXi9WrdvsjOBX6Cfciew7M+8tHNxsr01vXnSNSUwUw0+SAFi2c1cGkS74S?=
 =?us-ascii?Q?ZIb9Ki+V+O6Eg19lIrkYBADQU/TBUtKuQAmZmz1HcMT3p+jdzExu7k41ky/u?=
 =?us-ascii?Q?Jefw0s0edmQ2ZZiXfCZpH3TRbMVXILV0HHJds78kRBCPo5R6DOtDGe9zbz0k?=
 =?us-ascii?Q?8AI1RI4yOkyghX4E8VHcoDfQEZrZ69iHyRftE/sujcf8JDKGexULIKYiExI6?=
 =?us-ascii?Q?Y0G3/lJ/zmPVomMqzCFObeVda/Me2/F2CzyEIeWm3B1aEPA9Ly57lvd4zR+I?=
 =?us-ascii?Q?1USuBVQ+ZC9iqNPOoqRYQvi3Uj9cfx+BeraHZt/spRpsXLMVWW7K9w325hir?=
 =?us-ascii?Q?Qt5fg+sd7z25H/hcpAMB6GZ4krLd1srkhUUMsKkSBJPkkUUgJpGSFLbXM2rs?=
 =?us-ascii?Q?dIE6ZKvBv3ZtL4Q0ufli8IC7xtZVqNvvvR14ZPU6L8kMtiwjzkZKMlRRSfxm?=
 =?us-ascii?Q?JboWvwpIlDWKBn2Qk0dugM53bXq3c6UXWY4jLeA1+/ZnzdlUBT30yaR/C975?=
 =?us-ascii?Q?d8kMCLK0Kd8qTnM8ejJOItJC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3925822a-d767-4777-2919-08d921f2818f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 16:06:09.0690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUaWmXikVIGWK1lWOxoXg24wR0ZfU0rM2OpK834SravoUdGG83kRmca4E5VlQ4tRofHZDisW0PSAnhk/CRZkmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8415
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 5:11 PM, Ahmed S. Darwish wrote:
> On Fri, May 28, 2021, Varad Gautam wrote:
> ...
>>
>> Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)
>>
>> 				rcu_read_lock();
>> mutex_lock(&hash_resize_mutex);
>> 				read_seqcount_begin(&xfrm_policy_hash_generation);
>> 				mutex_lock(&hash_resize_mutex); // block
>> xfrm_bydst_resize();
>> synchronize_rcu(); // block
>> 		<RCU stalls in xfrm_policy_lookup_bytype>
>>
> ...
>> Fixes: a7c44247f70 ("xfrm: policy: make xfrm_policy_lookup_bytype lockle=
ss")
>=20
> Minor note: the 'Fixes' commit should be 77cc278f7b20 ("xfrm: policy:
> Use sequence counters with associated lock") instead.
>=20
> The reason read_seqcount_begin() is emitting a mutex_lock() on
> PREEMPT_RT is because of the s/seqcount_t/seqcount_mutex_t/ change.
>=20

Thanks, corrected it in v2.

> Kind regards,
>=20
> --
> Ahmed S. Darwish
> Linutronix GmbH
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

