Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EB73B81C5
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhF3MOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:14:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31984 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234373AbhF3MN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1625055089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFuuhixTehiLKtpvDYPJDGMhPJfdowiPPD3DknKrfzk=;
        b=cZupEmYFkt0uA6Vjur4XGqk7Nmv2FVQ7IU5MLwjvYv9vWIvNMaWih0N5nYwHfVaX+nNxtg
        vvw3kSqOXmV+A6f/ldD4XjMKpwCSA44zsUP/b9MVEqW/jqW5yBnp53YijeENH/32cRvzMe
        vLOyW7INc1BDSrV8cLg6UKtjb3gelrU=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-fBMYLUAxO7uLPEwN3xhhqQ-1; Wed, 30 Jun 2021 14:11:28 +0200
X-MC-Unique: fBMYLUAxO7uLPEwN3xhhqQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK1YWF7zo9F7ls1FAb7TE9IyJAdIR9LSWq2xaEgKjTsjYdebc7n71mRVTC9U90Y+33o0A31XC9hvszFqKkaABnbizc4cCxJscKFHEav2WTLPn5LgWA25T+AkZTEWPeFZPelPgs1hHjWoi7vM/5NVuxSVofcJ1zSV8zqp473hoL+x32Yqxh8XKR+ohJSWyEoBgk0qriJ9WN927MsvQxwGu6AT0G6S3RymzbWk8199ByTT5IUh3MssQA0hOqTuaAUofLU4K1FHDGpam6hvV8BA3+XgM+vrsfemtXT9u5DNFotp9o1ngVPNDzHud4RIMwjr1FziN7yxUROXk/IjzroYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83UyU1A2BOxJW8UrofbYu1TMUV854SKPpVBEwM/5n1g=;
 b=cio0+cKfADlUe8FzKqev3ouUDN3IJ3ItO+H6ldv0woNnmfy6qGHFVD2uAbESm52PQQ4+miWcgLEt4XlLjA+OzqaH6HespmlSy7XExTtAIXS9M2HKBFDxVkO/uZ/Rx9qPIMJAwpsxJs//1vDVlOCCXSHu9MkQm1o46mRUlUwgt2vEWL2vq3k/mlAYRoXBtfLIEkNjpAEbV1SZWNoJDpd80wqJJwqA+VR8dboRBTjnxbxns67/PRmtmFYrSU5Zltv0q7DJx2EleBd+fWWVhuqegeTAwI4YgZEWx+Q8ktMPwhWFv0ta4WJ6AUobzkv8/ndnB6b6y5PEd8wgasHrbpXlKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM9PR04MB8308.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Wed, 30 Jun
 2021 12:11:26 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98%7]) with mapi id 15.20.4287.022; Wed, 30 Jun 2021
 12:11:26 +0000
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Frederic Weisbecker <frederic@kernel.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
References: <20210628133428.5660-1-frederic@kernel.org>
 <20210630065753.GU40979@gauss3.secunet.de>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Message-ID: <ff82a4ad-179e-6a81-eacc-addc8ed12b0f@suse.com>
Date:   Wed, 30 Jun 2021 14:11:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210630065753.GU40979@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.166.153]
X-ClientProxiedBy: FR3P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::23) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.146] (95.90.166.153) by FR3P281CA0025.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.7 via Frontend Transport; Wed, 30 Jun 2021 12:11:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bef5fb3-3f41-48f0-4500-08d93bc02f64
X-MS-TrafficTypeDiagnostic: AM9PR04MB8308:
X-Microsoft-Antispam-PRVS: <AM9PR04MB8308F33576A030393A2E5EEEE0019@AM9PR04MB8308.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQqVyPeici3U2GWmt8l+VA0WGgcoDG7jW9uX9jEkRk+ROWFP7YJ0m3IwPYdF+166KhPwA3ur8njY0vfXnIS/jbp8QzM5lFcgRwO7P4hxp3rfLDSGVtkmtfXiKXrF+ow2CT1jkKo5Myjiya3nQDvvxUqC1aYeptnQA9MkMoWFgDX7DNUBegSMLmL1BEIc3YQpEP2axZYoVR0d+SCYlynqcSyFUK8CdkYU2hxM9Fsg+8Asgal9OXl+40sloyaM/xab3lJU8otzgGFyEHCVF+VOZHeHLnHMhzf/sRfr1eUb62l523Kcmc2/N0p5rKXzgNwX3fWrLEXebJCtI9mtcE6hG7bNLytlos/L52o+AOMd8bMRVgXSLdcv6kXyl54qkS32OPmiJHQf94yLXKzF09jBgNAEy7i7lL37YjJKwCKvgEFbFmnOlX7BFSPVXORN/UvQcxi6fVjh6tiUibwdSf/SqCIgiOJ51Q0Q7RyNL0Hmj92w1E7gmOmVev/jKeIJuYyQJ50YjFNA1/ZZlQhJMNkAR2IRysNvK/ZLLCeVaCFl8S7xm8vBGacwtkh7lKGeOPPkDahVkqwD+CjktOPf0uxMt289i4ydpG/E2y55moXwfbDN4JuW38R/GWpns11azxutZZk6bcwLKaSoWEKd4O5pXTUzKD+9oO0lNALyhSQDY8uVi5Hhk2V0JE3MlJIjV/l1vmbs/Ak5456wQmxSUK4269CQayIFDfH0U5pgKayX/tM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(4326008)(31686004)(5660300002)(26005)(16526019)(38100700002)(8676002)(86362001)(66574015)(53546011)(2906002)(83380400001)(956004)(186003)(6486002)(66556008)(66476007)(36756003)(316002)(16576012)(66946007)(2616005)(31696002)(110136005)(44832011)(478600001)(54906003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4GeSOrYmQLzPXy6CwSesq30AcaFxbDKCBdxue2xWS3peg/k9bhjq8MEnls6L?=
 =?us-ascii?Q?A7Ag8FOigaqcfE4FSmmUxhoKOBK18/XkrmkIU5vKT01d8OriW1/ia8rnEKOD?=
 =?us-ascii?Q?yfj8cHQk4loXVmXojxt35jHjE7m+xQR+cRjb4LcGexwL0BX8i5+VayXo2jN5?=
 =?us-ascii?Q?2jDlyMUFqzhkSPujLK3AcxKygb0rlLsn/ydMFu5y68IlTTI2BtXuuYR6u515?=
 =?us-ascii?Q?sYwqbflmoAMZEsBTu1cWNcVHhk4IArkXttwgt83KCGqyXkMJUy6vRazASlDj?=
 =?us-ascii?Q?YqQyrNsO27N25JQLP1Og9sY9Nw9jUFt5sMQjNiB3j9aCbIgTMDqugw5X7G1W?=
 =?us-ascii?Q?Ak1ceC7HbhZvxiGWZCZ/ccaC0TzwEHlx84J+JjOJ8x+dbat4tmkq3GHFyj+V?=
 =?us-ascii?Q?0+AEASd+dOiY0aIM23CaxDNwdhWloiwh6Kf8oW/fO/+DHlHOgp/34mBINxHG?=
 =?us-ascii?Q?omDShdxW6+a7GFfZjClgnJY7IdEAwyAc3fhCP88h6g4vyKVJL234/4P1S+7m?=
 =?us-ascii?Q?s8hor3qQViLEnFoD1fbGaaf4/QKxcL7sOHk9R/PB6q+w6JHkeUgo11LtIOSG?=
 =?us-ascii?Q?qBKR6niRTidWyO2cYEf5lqcSsymEwkmzy0kyAKWDGsaPie95vD8gRF8IsEh4?=
 =?us-ascii?Q?3MhOiDvYzn7q/Dhunv1IXsXrslWxI6pW1WTrQgfYond+7BaEgBNva5gThK0T?=
 =?us-ascii?Q?+nqGfKqYtYS0NX7iI41Ee10bY5U6wgpFgAvdODfb25lfwd/PZ3Wzl4LONseA?=
 =?us-ascii?Q?LyZCPq7XO/Jf6/vCqh62xnNgOKwURbTvZQbq7h+7RrZdhCXR+ln3Lh+H2swK?=
 =?us-ascii?Q?ixBv8zb6NtrLPOrGQW/mJdbOXgKqVzF+AJUs5flDOSMjiSD1wqTgwzJhseIN?=
 =?us-ascii?Q?VE0qARS7Ql1rHTAaEV/5bjmBNroJXT6EA70qbQqVz0HwI76dlu1xxgTtc93w?=
 =?us-ascii?Q?zV8DbBAXM8oAEf6uN7lv/5Or9AUmZXPYy4+ONvjo2ndUUt918owoL8Dmq4pM?=
 =?us-ascii?Q?edp1kAIqCD1Qb+W57oLC2M/QUysfvKihpxdMm8sxIstZpUCa8P7aW4s3qriE?=
 =?us-ascii?Q?TTgKrEQ/WFFRtJ+4+/WiUJk9I769KNnAoehK6Ebsleqv2TNcoElB+AJ1dOlg?=
 =?us-ascii?Q?y9TMzf6iQKYicAS48kbghw4+eb8v4shtC4TUFKBzVRdA51jYo1tSRemXtDHf?=
 =?us-ascii?Q?bIUGCnkOaiDIsZzvn981yTyTOf0n2APviQSjNEktBxsdgLHv0Hz3c57+hGB/?=
 =?us-ascii?Q?9Cko+wR8wB3Vej6xuwypPD1G5HVUkwjkRNYF7BFRzNcevIz5iogEQlC+fE0y?=
 =?us-ascii?Q?OV42P2zowY1UizjscyhhM6iJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bef5fb3-3f41-48f0-4500-08d93bc02f64
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 12:11:26.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSBIYy0R0s7JiMAgD+4BGsY2imC6rOHoFXgaZNV+aY2wXC6c3fMXpv3D5pduZhYar5IZCtB1t+/bLj+j/ij+3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/21 8:57 AM, Steffen Klassert wrote:
> On Mon, Jun 28, 2021 at 03:34:28PM +0200, Frederic Weisbecker wrote:
>> xfrm_bydst_resize() calls synchronize_rcu() while holding
>> hash_resize_mutex. But then on PREEMPT_RT configurations,
>> xfrm_policy_lookup_bytype() may acquire that mutex while running in an
>> RCU read side critical section. This results in a deadlock.
>>
>> In fact the scope of hash_resize_mutex is way beyond the purpose of
>> xfrm_policy_lookup_bytype() to just fetch a coherent and stable policy
>> for a given destination/direction, along with other details.
>>
>> The lower level net->xfrm.xfrm_policy_lock, which among other things
>> protects per destination/direction references to policy entries, is
>> enough to serialize and benefit from priority inheritance against the
>> write side. As a bonus, it makes it officially a per network namespace
>> synchronization business where a policy table resize on namespace A
>> shouldn't block a policy lookup on namespace B.
>>
>> Fixes: 77cc278f7b20 (xfrm: policy: Use sequence counters with associated=
 lock)
>> Cc: stable@vger.kernel.org
>> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: Varad Gautam <varad.gautam@suse.com>
>> Cc: Steffen Klassert <steffen.klassert@secunet.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>=20
> Your patch has a conflicht with ("commit d7b0408934c7 xfrm: policy: Read
> seqcount outside of rcu-read side in xfrm_policy_lookup_bytype")
> from Varad. Can you please rebase onto the ipsec tree?
>=20
> Btw. Varad, your above mentioned patch tried to fix the same issue.
> Do we still need it, or is it obsolete with the fix from Frederic?
>=20

The patch "xfrm: policy: Read seqcount outside of rcu-read side in
xfrm_policy_lookup_bytype" shouldn't be needed after Frederic's fix since
the offending mutex is now gone. It can be dropped.

Regards,
Varad

> Thanks!
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

