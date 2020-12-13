Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8C2D9038
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 20:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgLMTiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 14:38:09 -0500
Received: from mail-am6eur05on2111.outbound.protection.outlook.com ([40.107.22.111]:50945
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725308AbgLMTiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 14:38:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOntk7SlJ+2T0hnhJdAM8XePbZcDkiZNC+5eW7sMU7gL0iZBRkmvO1OgWfg5RV9anpSF5Hyf8BAffonN1FTmZUIlcDpN879KgkGZ7G9Vzhma1Kx2Ds+7jFiAF8SbD0WG2vFBOnL5zApcPL2a9KYnabcRg1zDrj49fjO5OLgeOR60HRjx2v31h0WdsYLzJ3ghRNYSBSDtyBL0VSTGP99TV7JN+tL3pivKoMyzv+Kq3QntlD8ywtRtdgf4E5rAHRTBu+kspm9F/owczCguJvkl21Ifb7jfp3YU5zO6jOoAw+uKuZjn9FKjbcvpGtC2g5k9eOlponL6ApeXfUedNADOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=374tPbM3wH6g7qCkBJn86/qy56U3TN+2m9LNSpjKOHo=;
 b=a+mOBe191fB89AyIffQpUZWqvrbDBSwK7WmGg2gkI1NGexT3dH80x8PxyCFGQzY1dpUAqsi9BMnS7sC2KwM4jtA88EXt9nnitsPMA40wkJt5obREzdtLogW8EeINcJVPK0GWxsKBK7ja6AejwMs7WsBRq4BoB376LkDawG53m5JibxXn4Ribaw850TBqbIGVi7kX7QpTQXd86INCu6ljfJf3g//xKXEX61FVzyd8nYouM/vnxplmh67ez1H5P/T+0r3V50G50C5CMwxMamLXU7l++WqtwSS9H3Te559fdVxpZ7xZC4ndpcLqXHLecdJykN08YBuDDj5hj4X6UDD4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=374tPbM3wH6g7qCkBJn86/qy56U3TN+2m9LNSpjKOHo=;
 b=rzT/n1jenq2wXW8GdakoC/sTAf6KoPy3MyjFOweHn5XSkL8/FiwMv4XF9tAKeaHSQYIU5sBnvG+5F5NWf7Iou06HqpywvSQVKG/Ye3x6TA80YuVh1ltw/JpfvSiXGU2hJWnH1N9x3OBDvcam3xyeC8hYmXIgNRvL8oXHH9xorcE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB3053.eurprd08.prod.outlook.com
 (2603:10a6:803:45::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Sun, 13 Dec
 2020 19:37:19 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.024; Sun, 13 Dec 2020
 19:37:19 +0000
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
 <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
 <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com>
Date:   Sun, 13 Dec 2020 22:37:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR05CA0074.eurprd05.prod.outlook.com (2603:10a6:208:136::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 19:37:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee8f3bd0-0bb3-478a-1d62-08d89f9e811b
X-MS-TrafficTypeDiagnostic: VI1PR08MB3053:
X-Microsoft-Antispam-PRVS: <VI1PR08MB305310A29BF03770F01285ECAAC80@VI1PR08MB3053.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLbwOYdp4StHjXPnzXjow8KZyNdOXCznvpim0ikDf7N4mWjj9Qh3hC3s4uGWwiMtHq+C4cCHg/uqfWjY0yPFcCmPMSN36+AFK7nGXa7IaBewfe0Wvvx6/aC6e8JlmYYdhlfdZSRl2R0RIoLUNGOEj0oVOaDsiOFxdO1IRbab568CwhbzVJ9LQBw0P8sVeJJdgwRXE10+2VzFq7MrrHW1KUs6SRhIdYzT/RFE/6V5gT79/NUG3O619BIBI3d0XQYN5+dxesU6jvOfC/4ubrL+9q6jIsMXPgtBcdL8cXO3PjLJTepRD4YW/yw4PYo6l+MHvEBnNI2CWqBGqyDmABsTsC4lNwCukfXCzGG9/RZHT1TB+vsJUL9Jl6Mxn6hWTtYNgT9w278Hl+GirA5fWd3G8/1FWpoivqhabDbrLkuipWY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39830400003)(376002)(136003)(366004)(8936002)(83380400001)(16576012)(54906003)(31686004)(6916009)(316002)(4326008)(2906002)(86362001)(956004)(2616005)(6486002)(31696002)(16526019)(52116002)(36756003)(186003)(66946007)(66556008)(478600001)(26005)(5660300002)(8676002)(66476007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3NlQUhrQnZ6S0FyV0hscTRWcHhVbDRWbmV3ZHd5SjlrbFd6NVl6R2pJOUVi?=
 =?utf-8?B?aS9sUDFkVndkMFVzUTNyWVBSVHVvRTE3eUU4NTU1RGtZbUg3TE94TUZGRnZI?=
 =?utf-8?B?SnlpdmZlRHRuQzFENy9UdlNSLytlMEsvKzZwSFRNeEFZSWNhaVNPNlNmaTE3?=
 =?utf-8?B?aGFRdnpUQldaSjdpOGlXRG1QQkpjRklqaVBIaUlBdU5Uci9xZERtcEJjZGhR?=
 =?utf-8?B?UWY2cE0zVUJUVElpT0kyR0UrTk95Z0RXNFlzRGthWFlSdlNkdnlVMm90ejdV?=
 =?utf-8?B?SkphYlcweEZVdnM5bm4wWlhRays4VTA3eFNKZTdDQ05mSk02TTV5dm1tNTlZ?=
 =?utf-8?B?a1VGUFU5dVhDZG5sVWxaOUgwc3R2ZnYzdk5DRGszNS9WOTkreVlSMGRyeUYy?=
 =?utf-8?B?Wi9LWEJ6SWt1TkY4OE8xeHlFM3BzWlFqTVI0d1dTVzIrTVF3TkJrMkdra21D?=
 =?utf-8?B?VmdjVGtqaEdhcjlzUU1WOGw0WHZINEliTE9KcVdaamsvM01rZHF0d0tKaTFY?=
 =?utf-8?B?ek9NU1N6UXBFa0RhT2l5eVNFbEtyS0RhSFcxVk5ZeUR5SkUrZHBTblpUSVVw?=
 =?utf-8?B?dU1PWEpVaUFPVTRqbTU3dVFoSUl5UFhTbXBRZkowMjhndm9UeHZkYmplZnVt?=
 =?utf-8?B?S2NNR0dHSzltMW9kUGNnMFdQbU9UVzlpWmhaQ0d3T2tDbHlETnh3T2diRXZS?=
 =?utf-8?B?ZXRIYVprWDVCTGRoY2JiVDlDOE1vRnhENWJGQWxncWxVclEzU1lYeHVZK0Vh?=
 =?utf-8?B?SUlyZ3pmQ0xTM0RMc0pBU3loWnFEcU01VWEzajNBQkFZZHFUVk1YWU9PVjBN?=
 =?utf-8?B?RldZTjdjalhOcXJpWTJTN2l2dENDa0J1cFVMRGNZcDJ1MENnWkNWa3FWVmN1?=
 =?utf-8?B?Z1hjMVJ0ZVowbi9pYWZiYy9KYlg3d3BteFd3cGJTRzQvQytPamNLSEo4RzhQ?=
 =?utf-8?B?dlhwRXhwVWp0ZVlIOXZUTmNVOWVWTDlEVXpXV25VZzhRMHFCTW1GdUwxNVVT?=
 =?utf-8?B?Qlhzd3FHWHJhenFJcFc4V1dUb3ZaNnptdlNYMS9zaHZEMDdoWSt4Y25wMVVl?=
 =?utf-8?B?SHFKYVFhYjlZZE5LS3M1QzZlZm52aGh6MUt2dWIrTk5BMWwzenFkeldKV1FN?=
 =?utf-8?B?a3YyS1hrakNrMEZtbFNnN0J5dVZYTnZSb2IrNlZiWjFIeFVsUkdOUGN5dmlP?=
 =?utf-8?B?RDAvakU3cmVDc1BndVpHZ2swbjFPaU5lcmdzbktCb1dtZERmNEJZT3BFY0dy?=
 =?utf-8?B?UEdXWUdSM2JIcFcyMlVjN1FISFhtWExwSkZkWTAvTGNkTGxwVDFNcEFCNVNC?=
 =?utf-8?Q?FdtcIWb0qH7egfny5ZfV43dZ25TWW+Pn65?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 19:37:19.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8f3bd0-0bb3-478a-1d62-08d89f9e811b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6NAKtEPtQ95rHoPsvHldQHOH3/XuKEqc2DTS5y8vNiwHYCWqpwuAg7eAvEpqHdqI4u2g2R7DB9YEy/IIHl88Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/20 2:49 AM, Willem de Bruijn wrote:
> On Sat, Dec 12, 2020 at 5:01 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>
>> On 12/11/20 6:37 PM, Vasily Averin wrote:
>>> It seems for me the similar problem can happen in __skb_trim_rcsum().
>>> Also I doubt that that skb_checksum_start_offset(skb) checks in
>>> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
>>> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
>>> Could somebody confirm it?
>>
>> I've rechecked the code and I think now that other places are not affected,
>> i.e. skb_push_rcsum() only should be patched.
> 
> Thanks for investigating this. So tun was able to insert a packet with
> csum_start + csum_off + 2 beyond the packet after trimming, using
> virtio_net_hdr.csum_...
> 
> Any packet with an offset beyond the end of the packet is bogus
> really. No need to try to accept it by downgrading to CHECKSUM_NONE.

Do you mean it's better to force pskb_trim_rcsum() to return -EINVAL instead?

Thank you,
	Vasily Averin
