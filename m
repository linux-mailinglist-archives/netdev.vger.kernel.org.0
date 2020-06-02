Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAAA1EB2F5
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 03:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgFBBaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 21:30:03 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:6043
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbgFBBaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 21:30:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKJzUmpVMn3drdMEUjJeYfBe86XAJt4LtBYh4M9eOlQga9C5drLrgKIYFcoRC4tgmxiaayDFPu1wdKtit+2xCgEubjYll6vOy7MbVMj2Mfyo5qPic1ciFckmj3+7aUiGucPmxOVc4wMRdmp/F+ml5KXMi4x4/mJjTaNx775FQC/+yOodo/MqkZfIjFGahKtbijDVa+h+stMYFKFHI+ILUfJw3PV5gebI1Y+9EWKooX6Njp/JLQXwCyHaJkgWJhcUnzlBZGFAX//SJwjjNTs4Tv4CZ/62JTreZ8rnBu9BimgfdMRg7m+majnuYvic6R5xC4nSeKTvWdWvhAZJIzKrpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJc7Oy5J1T62i8UJX8B3qKpf2/jnte5YepxPiCOOJmU=;
 b=b+HniIO18OgNigH5Yivl8Mfp/YaKa2TUXTEVNYIlpFNdvk2LKb/rMYbL0y4MUesp5CHBCvNPJIGg7hRZT7CdgF9So4V/wxy9FAqNE7VXvU3EZUZwUx2EML/tgTSvDWshpbTBXG1y241s9Nivc91nsX9uRotzbXno2gnZLdcHyV2PszNSlTqsmZptVeb8YfEbdaURsB6xY3QbmB76LDz7bALhisO8au7mTkojMiOq6OdoeyX20mvlGWV91oSRdxuijSCb80D37W6hcXjQu06LUAwlVMzcp+KtKW3sMu/Ing6DrrC+3ZfO6jOYKNNmKQoxTZrPKr9+aJKzZd0Bru3Dcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJc7Oy5J1T62i8UJX8B3qKpf2/jnte5YepxPiCOOJmU=;
 b=jyehIUGZh3CjGGQhUqGLExo5hBa9Zeiep3E2QU3V10j4RpIJASJcITiGo0OcNDtQzs7qfFwFqsPRBLJp+/3fmsDSlMSIvJdUBp3qwV8nhabUK5ScpBxYTUY2VY4bLYDfahsDnZT2vUID1J2OBMd8CwwjBsXLk7HG64kchRrp8Fo=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB4933.eurprd05.prod.outlook.com (2603:10a6:20b:a::20)
 by AM6PR05MB4904.eurprd05.prod.outlook.com (2603:10a6:20b:6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 01:29:57 +0000
Received: from AM6PR05MB4933.eurprd05.prod.outlook.com
 ([fe80::1828:1c78:bdca:9675]) by AM6PR05MB4933.eurprd05.prod.outlook.com
 ([fe80::1828:1c78:bdca:9675%7]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 01:29:57 +0000
Subject: Re: [PATCH] xfrm: Fix double ESP trailer insertion in IPsec crypto
 offload
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        Raed Salem <raeds@mellanox.com>,
        "huyn@nvidia.com" <huyn@nvidia.com>
References: <1590097773-14776-1-git-send-email-huyn@mellanox.com>
 <6d0d27dceb774236d79d16e44a3b9406ac8a767b.camel@mellanox.com>
From:   Huy Nguyen <huyn@mellanox.com>
Message-ID: <6a604183-8937-c66e-6755-674984d1e8dc@mellanox.com>
Date:   Mon, 1 Jun 2020 20:29:49 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <6d0d27dceb774236d79d16e44a3b9406ac8a767b.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN1PR12CA0100.namprd12.prod.outlook.com
 (2603:10b6:802:21::35) To AM6PR05MB4933.eurprd05.prod.outlook.com
 (2603:10a6:20b:a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (72.179.1.249) by SN1PR12CA0100.namprd12.prod.outlook.com (2603:10b6:802:21::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Tue, 2 Jun 2020 01:29:55 +0000
X-Originating-IP: [72.179.1.249]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aad1821e-b9ef-4a4e-1584-08d8069475b0
X-MS-TrafficTypeDiagnostic: AM6PR05MB4904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB49044BF84105BF4EFAE674C8AF8B0@AM6PR05MB4904.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VpxBO6x3I3zW72RLAD8hPHkunk3De+18XQ+hJts6Wf4Qn5vPrFCvGOQedKz4yQOMxA1bI3hfmqwriCQcmqeeKCGVJ5k/gjmHcyZtrvMKhTq05lP1XptHkyu6UpdLcqK+BpINGiegJvNYLWtVawn5yL6BBTHIQfNtPdKrV9ES9DI+q9yDG3JjZUK7tdqJnsyXWIX81M9fkVUFCypsodb2qMPCuUtFGpZQXECiyOdO8xsTgx+wsM1UfckQt62ltj5pnMz1XPhw814CahiKRdgryz2b/qU6Ijp28pCXB82XsKZKzkJnt8ysG6olkgxs3hOUgvxl2+qAemy/MghpzV58/iJchW9oStfklGj2LSe0lCMRu95FV/Vck/qVQpip74wZhNUw6aKZ/onnWUAxrOUWvbcdOapVFNZjj9FMbKE5CIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB4933.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(2906002)(83380400001)(31686004)(4326008)(16576012)(110136005)(54906003)(6666004)(478600001)(316002)(6486002)(52116002)(5660300002)(8936002)(36756003)(66556008)(8676002)(31696002)(2616005)(186003)(86362001)(26005)(956004)(53546011)(16526019)(66476007)(66946007)(43740500002)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Lnq3l4dQBToZXFbGHVI21OqHYKx7MjM21i7y0xQLtozx9yluTafPvyPaR6T+bmNZnh94/Gy7vO/nAmyfURWr+uRBzHN6bSVa76yfLWwihnCFcs7MXJ81i4y51mObzfFjUJA+vuR144L88FyhyfoGcHXdZkcAS4v+dRi/A0tBL9gbAm41OAiEeRPfDV9NGEO4ecPWtOKdN5cgTVN2gb2+OSL5MPMTNqp/Jx/UkRoPYYeyO5OJips/yZlfYf+Q1wwMQE/OP85dE5GeaZ5WdHy5m7afdslZU6zJsmDBXIwvM3W85zdmDi2xzXXVJNGc7dRxaLBEiOueLOVyaYZbXtYvl33NCnjEE+9sBrKVdaTXK0DkNkx8XVvL6oyzHcdKasfsqQ81wviV8D2pyX0uKVCT0qQybNqvCTG69i+BuoBpvStmN9SUCOzlRUsbQBE04twoYDc+OD3aUBICZBngkispGPIZNS+oZ2S+7U9PERjIYRg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad1821e-b9ef-4a4e-1584-08d8069475b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 01:29:57.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87oSqUi1pm7rYpsHdcO8VddC0b2B0QFBnz/NKhgN42OYSHa5lb2u6Lxg3s0RU9DXHlPDY3+zq+3eCw1ffhR6nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4904
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PSB

On 5/22/2020 7:25 PM, Saeed Mahameed wrote:
> On Thu, 2020-05-21 at 16:49 -0500, Huy Nguyen wrote:
>> During IPsec performance testing, we see bad ICMP checksum. The issue
>> is that
>> the error packet that has duplicated ESP trailer. For example, this
>> below ping reply skb is
>> collected at mlx5e_xmit. This ping reply skb length is 154 because it
>> has
>> extra duplicate 20 bytes of ESP trailer. The correct length is 134.
>>    skb len=154 headroom=2 headlen=154 tailroom=36
>>    mac=(2,14) net=(16,20) trans=36
>>    shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
>>    csum(0xd21a62ff ip_summed=0 complete_sw=0 valid=0 level=0)
>>    hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=0
>>    dev name=enp4s0f0np0 feat=0x0x001ca1829fd14ba9
>>    sk family=2 type=3 proto=1
>>    skb headroom: 00000000: 00 00
>>    skb linear:   00000000: b8 59 9f da d6 6a b8 59 9f da d5 52 08 00
>> 45 00
>>    skb linear:   00000010: 00 8c 76 0f 00 00 40 32 80 5f c0 a8 01 41
>> c0 a8
>>    skb linear:   00000020: 01 40 8e 20 a1 20 00 39 03 28 c0 a8 01 41
>> c0 a8
>>    skb linear:   00000030: 01 40 00 00 12 ec cf ba 03 24 97 cf a9 5e
>> 00 00
>>    skb linear:   00000040: 00 00 13 34 07 00 00 00 00 00 10 11 12 13
>> 14 15
>>    skb linear:   00000050: 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
>> 24 25
>>    skb linear:   00000060: 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
>> 34 35
>>    skb linear:   00000070: 36 37 01 02 02 01 00 00 00 00 00 00 00 00
>> 00 00
>>    skb linear:   00000080: 00 00 00 00 00 00 01 02 02 01 00 00 00 00
>> 00 00
>>    skb linear:   00000090: 00 00 00 00 00 00 00 00 00 00
>>    skb tailroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 a8 50
>> 69 d7
>>    skb tailroom: 00000010: 96 9f ff ff a8 50 69 d7 96 9f ff ff c0 01
>> 58 d0
>>    skb tailroom: 00000020: 96 9f ff ff
>>
> You don't need to attach the whole debug dumps you have pulled to find
> out what the root cause is, we do believe you ;-).
>
> The above dump is just a random and cluttered information that doesn't
> really help the cause of this patch's commit message, it is perfectly
> fine to just say:
>
> Duplicated ESP trailer can occur due to double validation of xfrm xmit
> handler in case of packet xmit re-queue after 1st validation due to the
> reason you listed below.
Done.
>> We figure out that the packet goes through two sch_direct_xmit from
>> qdsic.
>> The first one is from ip_output and the later one is from NET_TX
>> softirq. Below are the two stack traces on the same packet. The first
>> one
>> fails to send the packet because netif_xmit_frozen_or_stopped is true
>> and
>> the packet gets dev_requeue_skb. However at this stage, the packet
>> already has the ESP trailer. Fix by marking the skb with XFRM_XMIT
>> bit after
>> the packet is handled by validate_xmit_xfrm to avoid duplicate ESP
>> trailer insertion.
>>
>> 1st one via ip_output
>>    dump_stack+0x66/0x90
>>    esp_output_head+0x21a/0x520 [esp4]
>>    esp_xmit+0x12e/0x270 [esp4_offload]
>>    ? ktime_get+0x36/0xa0
>>    validate_xmit_xfrm+0x247/0x2f0
>>    ? validate_xmit_skb+0x1d/0x270
>>    validate_xmit_skb_list+0x46/0x70
>>    sch_direct_xmit+0x18a/0x320
>>    __qdisc_run+0x144/0x530
>>    __dev_queue_xmit+0x3bb/0x8a0
>>    ip_finish_output2+0x3ee/0x5b0
>>    ip_output+0x6d/0xe0
>>
>> 2nd one via NET_TX softirq
>>    dump_stack+0x66/0x90
>>    esp_output_head.cold.29+0x22/0x27 [esp4]
>>    esp_xmit+0x12e/0x270 [esp4_offload]
>>    validate_xmit_xfrm+0x247/0x2f0
>>    ? validate_xmit_skb+0x1d/0x270
>>    validate_xmit_skb_list+0x46/0x70
>>    sch_direct_xmit+0x18a/0x320
>>    __qdisc_run+0x144/0x530
>>    net_tx_action+0x15d/0x240
>>    __do_softirq+0xdf/0x2e5
>>    irq_exit+0xdb/0xe0
>>    smp_apic_timer_interrupt+0x74/0x130
>>    apic_timer_interrupt+0xf/0x20
>>
> Same, this comes from your own debug code.. doesn't help the cause of
> the commit message. you can just describe the flows that might
> retrigger double validation on the skb.
>
> So please improve commit message and avoid clutter.
Done
>> issue: 2143007
>> Fixes: f6e27114a60a ("net: Add a xfrm validate function to
>> validate_xmit_skb")
>> Change-Id: I2bc1a189b8160cd90b66b44212b4d44bbdebcaea
> Please remove "issue:" and "Change-Id:" clutter.
Done
>> Signed-off-by: Huy Nguyen <huyn@mellanox.com>
>> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
>> Reviewed-by: Raed Salem <raeds@mellanox.com>
>> ---
>>   include/net/xfrm.h     | 1 +
>>   net/xfrm/xfrm_device.c | 4 +++-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
>> index 8f71c11..0302470 100644
>> --- a/include/net/xfrm.h
>> +++ b/include/net/xfrm.h
>> @@ -1013,6 +1013,7 @@ struct xfrm_offload {
>>   #define	XFRM_GRO		32
>>   #define	XFRM_ESP_NO_TRAILER	64
>>   #define	XFRM_DEV_RESUME		128
>> +#define	XFRM_XMIT		256
>>   
>>   	__u32			status;
>>   #define CRYPTO_SUCCESS				1
>> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
>> index 6cc7f7f..c122e3e 100644
>> --- a/net/xfrm/xfrm_device.c
>> +++ b/net/xfrm/xfrm_device.c
>> @@ -110,7 +110,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff
>> *skb, netdev_features_t featur
>>   	struct xfrm_offload *xo = xfrm_offload(skb);
>>   	struct sec_path *sp;
>>   
>> -	if (!xo)
>> +	if (!xo || (xo->flags & XFRM_XMIT))
>>   		return skb;
>>   
>>   	if (!(features & NETIF_F_HW_ESP))
>> @@ -131,6 +131,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff
>> *skb, netdev_features_t featur
>>   		return skb;
>>   	}
>>   
>> +	xo->flags |= XFRM_XMIT;
>> +
> XFRM_XMIT sounds like a poor name, as you explained the packet is not
> actually transmitted, but re-scheduled for later even after it was
> already validated/handled by xfrm, i would pick a different name
>
> perhaps XFRM_XMIT_VALID.
>
>>   	if (skb_is_gso(skb)) {
>>   		struct net_device *dev = skb->dev;
>>   

