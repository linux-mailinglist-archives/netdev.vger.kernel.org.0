Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42EF249797
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHSHkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:40:02 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:42336
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbgHSHj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 03:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+7pBDa52MwM91JLTO0pE4ctN+12SVulprhK/435LW+CrA9p9+2ew+907/Eh+sDKxWrD8HDtBfHqFZ0o9VDvYL+fAqp+9ewLliqa9tWc8A+xxeG5joQ3GxyWJGzhNDbjeOYUuiMEcPpMgTupYnDxC6BWQkXihcNfldUeIxkMwNgMaPp7LnhL1zL3ojmUAniQS8DcCYWhuDqEHy4HzmJ36vMbIaSuM68uLBMgxLDP5Ze78dqe77TmJG6bs8y6nqUtWQqoEmHvNlb6mY7k8FoJCXuveoW/I3D+PAGcOzFF5kt8wRJl5bRjwdIEhD25BjwdoOEGaYM7Cz6clk8AuDtOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6x3GgEpno7AvdrV+HK4eH39Q6gZGOgil880CBOlwIk=;
 b=DYLPkq4rupdgSnPWkzkTgQc8aciG2irT1mIQ14as1mLrdt9ZsA4e1y1C/oEQPh6TWx01zUD1uZ8g+Z9X2S3BAYJbvb00pYAiLL5tIIsM/plhK6aBDuAS9SIOFqtRgyOvJw1vtns6SlZ1FB5yUqJ0CQESTcbqvbbzFLC0XtcL91oKRAtcEQpEjuu9UuTq0U/KDpJ6f63LJYAjVBktlJrPE/NAeXVEMDHrxTMNnFiyF67OjhQD2/xHQTTsvM3iv8NHYbE9SwAtu49o1ayZLc02cYJtgi1psUQyiKOn3cSgWPS7km8VYjmxuKhKVbMfaO5LhpQSuVv76MlDOBe5EQZS0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=haltian.com; dmarc=pass action=none header.from=haltian.com;
 dkim=pass header.d=haltian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=haltian.onmicrosoft.com; s=selector2-haltian-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6x3GgEpno7AvdrV+HK4eH39Q6gZGOgil880CBOlwIk=;
 b=E1hOWQgTSps6D5W+KH51edy6WfsMY8kIFePGkzzvAKhNy1AiKFrHK3n7UzT9d6isJWFdz9JmIofaxlBLdPvo8tSib6GSSawdDUgz02ZBxsaAmZXstwm+fyDWddggL2Q7VkntV6S7/GlQ2sNr56yr/KHCW1aWeV38l5h16ifVT+M=
Authentication-Results: lists.open-mesh.org; dkim=none (message not signed)
 header.d=none;lists.open-mesh.org; dmarc=none action=none
 header.from=haltian.com;
Received: from VI1PR0702MB3760.eurprd07.prod.outlook.com (2603:10a6:803:9::25)
 by VI1PR07MB6288.eurprd07.prod.outlook.com (2603:10a6:800:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.10; Wed, 19 Aug
 2020 07:39:53 +0000
Received: from VI1PR0702MB3760.eurprd07.prod.outlook.com
 ([fe80::fc9c:b733:d178:6858]) by VI1PR0702MB3760.eurprd07.prod.outlook.com
 ([fe80::fc9c:b733:d178:6858%3]) with mapi id 15.20.3305.023; Wed, 19 Aug 2020
 07:39:53 +0000
Subject: Is netif_rx_ni safe from interrupt context? (Re: [PATCH] batman-adv:
 bla: use netif_rx_ni when not in interrupt context)
To:     Antonio Quartulli <a@unstable.cc>,
        The list for a Better Approach To Mobile Ad-hoc
         Networking <b.a.t.m.a.n@lists.open-mesh.org>,
        netdev@vger.kernel.org
References: <20200818144610.8094-1-jussi.kivilinna@haltian.com>
 <987760ed-17d2-d486-5dd1-d40418f62ac1@unstable.cc>
From:   Jussi Kivilinna <jussi.kivilinna@haltian.com>
Autocrypt: addr=jussi.kivilinna@haltian.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <92c88618-23ec-2e30-1d79-b84f8d193bc3@haltian.com>
Date:   Wed, 19 Aug 2020 10:39:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <987760ed-17d2-d486-5dd1-d40418f62ac1@unstable.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1P192CA0014.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::24)
 To VI1PR0702MB3760.eurprd07.prod.outlook.com (2603:10a6:803:9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from t520.lan (80.75.107.218) by HE1P192CA0014.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Wed, 19 Aug 2020 07:39:53 +0000
Received: from [127.0.0.1] (localhost [127.0.0.1])      by t520.lan (Postfix) with ESMTP id 0E254600559;        Wed, 19 Aug 2020 10:39:52 +0300 (EEST)
X-Originating-IP: [80.75.107.218]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ee7e47d-3b7f-43ae-0835-08d844130fc3
X-MS-TrafficTypeDiagnostic: VI1PR07MB6288:
X-Microsoft-Antispam-PRVS: <VI1PR07MB6288CF498267016E97415F92E35D0@VI1PR07MB6288.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOwBcAynA3drO/JQR62mNy9QnHYUYRowiGZsb3U2YdtPzdbCETtPSBUjf2H56+SC0WX0udZzoLypMH14UkhHp2scC/TDrSilnuzC3zfXHSQIskUpDf8kXqxysLE/Q8ti3jjcMJRDGcO/BPCU2IXOuB7Yr78xsQzcHoq43EE2870XL0kvRv4nywiYGliJSkdYkj6jtXAiAUy9cRcJ6UdtmaKfSKX+D0mEKz5/7NCBI9clwy0PtuJwi6HgdpUKxtWltUQIRi911EQ6kEY+CiQrrxpIHPNN1E4/zwCXnIedlVivLTN4utEsBxIbPA84GptH0T9ReyzuAUNgSrSQoTPhjtF1peVLP0f9FcUOdBe0PnSYmVr8F5+nLaBhFyUD5NgmWSHq4VVhGasxLNIyr0BiMAvUfNejoOHGV3pAQvm7ctctfgBsxVhZSraccRVdQORuKvjihSf1IF/2k36pzjJ+j9YW8zdt6PH3M17BueNhuZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0702MB3760.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39830400003)(2906002)(2616005)(66946007)(66476007)(8676002)(53546011)(8936002)(7246003)(316002)(86362001)(36756003)(66556008)(31696002)(186003)(966005)(83380400001)(5660300002)(478600001)(52116002)(7126003)(26005)(44832011)(31686004)(110136005)(6266002)(781001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aUqz/+XfmmrG1gGVAMBzdjjAG3lzRggyOrjTBUIEahfmFHqXNaSNeVPiizKVScaYYiS8V1ZWunNEHFZy6SrjeYFlnw4FQlHlOTBBEp1gfRb1z+QZkyB31rsemXt83L1qwmgcEeMsJO2am8LeXWZ9Xait9B1gSPVHplXipCJMAXEoVB5uHfywRo9NccoymLUN8p4Z2u+fG1ipEuEHCftWy54D9fPbpkfljhWsivYkrJ2QbCa2wJstxM3Brj/TjLGYp0Q2vJC8+BFPyNXm1Tnk9Fv80S+Y5dZAUeY4oPF7uS/pH5rrWInKI7SIZfr9tbfpP0lER3qX579Xjl4x9iyYwrEMIKPLDmFYyz38h00v4TY4YqQfP2/DURBDGht7KdyxkezFkOVy9AZrsK4aKe+e3REm+g9EAqoZpI75qWvBsXZPYtkCovPFb5pbRtdZ5exI8gOEXgeZ6MT6Dsu7qRco4qu/M6KyaZlRkisSxx6SOo7KOcNENvw4DyKcFV3Q/Yz94uUkWzgkfmeJQv4GOtSQ8wvYuqau91biw8bf5zq/wt5nTuymopXZ16xeq0BfHQ4pmJ9UpOrESOdDNn/KGLXrrHWX7pX+RH08Usdgo7n+Tnt5x2vJLkmjaMlTr3vqNqfeQXaYOAog7/ZHZRIAPLbhwg==
X-OriginatorOrg: haltian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee7e47d-3b7f-43ae-0835-08d844130fc3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0702MB3760.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 07:39:53.4661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2f7c6292-67f2-4cc5-82be-5d187e289ab2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPhSCT0S0+LQIBWkcBaNix3bbKcBGiOe/AQ3wPwD2vhb6idssowV8E8n3ok/rDtl1pIUAgc2M8CSemPZ+dr4S18PqGCa95Xwpnisx6zJ+jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6288
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

+CC netdev mailing-list

On 18.8.2020 23.12, Antonio Quartulli wrote:
> Hi,
> 
> On 18/08/2020 16:46, Jussi Kivilinna wrote:
>> batadv_bla_send_claim() gets called from worker thread context through
>> batadv_bla_periodic_work(), thus netif_rx_ni needs to be used in that
>> case. This fixes "NOHZ: local_softirq_pending 08" log messages seen
>> when batman-adv is enabled.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@haltian.com>
>> ---
>>  net/batman-adv/bridge_loop_avoidance.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
>> index 5c41cc52bc53..ab6cec3c7586 100644
>> --- a/net/batman-adv/bridge_loop_avoidance.c
>> +++ b/net/batman-adv/bridge_loop_avoidance.c
>> @@ -437,7 +437,10 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
>>  	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
>>  			   skb->len + ETH_HLEN);
>>  
>> -	netif_rx(skb);
>> +	if (in_interrupt())
>> +		netif_rx(skb);
>> +	else
>> +		netif_rx_ni(skb);
> 
> What's the downside in calling netif_rx_ni() all the times?
> Is there any possible side effect?
> (consider this call is not along the fast path)

Good question. I tried to find answer for this but found documentation being lacking 
on the issue, so I looked for examples and used 'in_interrupt/netif_rx/netif_rx_ni' 
bit that appears in few other places: 
 https://elixir.bootlin.com/linux/v5.8/source/drivers/net/caif/caif_hsi.c#L469
 https://elixir.bootlin.com/linux/v5.8/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c#L425
 https://elixir.bootlin.com/linux/v5.8/source/drivers/net/wireless/marvell/libertas/rx.c#L153
 https://elixir.bootlin.com/linux/v5.8/source/drivers/net/wireless/marvell/mwifiex/uap_txrx.c#L356
 https://elixir.bootlin.com/linux/v5.8/source/net/caif/chnl_net.c#L121

Maybe someone on netdev mailing-list could give hint on this matter - should 
'in_interrupt()?netif_rx(skb):netif_rx_ni(skb)' be used if context is not known or 
is just using 'netif_rx_ni(skb)' ok? 

> 
> On top of that, I just checked the definition of in_interrupt() and I
> got this comment:
> 
>  * Note: due to the BH disabled confusion: in_softirq(),in_interrupt()
> really
>  *       should not be used in new code.
> 
> 
> Check
> https://elixir.bootlin.com/linux/latest/source/include/linux/preempt.h#L85
> 
> Is that something we should consider or is the comment bogus?

It very well be that the existing code that I looked at may not be the best 
for reuse today.

-Jussi
