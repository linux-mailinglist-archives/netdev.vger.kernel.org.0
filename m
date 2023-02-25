Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7336A27C7
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 08:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBYHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 02:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBYHyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 02:54:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D700AF750
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 23:54:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPpBJySpPdTpdmPot74zaJZDPm/XUDt2cv1E47EuNbctRqCxtCsa0hIBpAv+sz39LZwWJ1e0U6ZfeZQKQarWSV4mc/Gb6nBglVVZVPqnbC50x2kk60FbmunZOUzNzXJz0gtI2jalNvzeAzxzSjmXzjcm4D096wr5pNmwl9Kd9e2Xe4WZfJoczEnnmz8+8bfb9jO+dO6dU5SfHGNFrzTT9+1dicF/QU0G0maFBTzC+oxih/x9h2AaCrXU8tEjEYCXJ4Eu93bBLN+rCAV8Jl4pU6UNzJCxXasKb0d+zTr/IsjKaE4/Nak2PuuvdExWlHtcyNJPuQHicPqCr7XQ9xe4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1Uww6SWuRA3fbYdlThqPk3OtbetZAn7urylD5InB00=;
 b=ApKYxqlVafMhohse43cyNVLOxrGLaGPsqgZNr/dpi7O/a37fljwKV8GMy343/0j2LdqEQ0SRoHGAtSrsxp3bsQ+99PrOMniWQzvijf18uaoNEVTLLawT2f18YKbAv9aCVW2nvM5q5pR7UIs/Pkr9XpLdH3jYNHAsrY5UM57Pyo+7u4+9jkHinRTJBqutBQeLbyBnGDi96l/jTUDCbzX9hJI0pgQekpHKyMo+Dzi4NZ7YXCwxgAUPKigulup/VJDOznZPzN04KTGKagzY1CQ7uvAQP8ba/GV4/1TzvFlSPcRWjKXFE0/fL1oHXqagVBdjmkB/gXDSR1CJwS2qCW6xTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1Uww6SWuRA3fbYdlThqPk3OtbetZAn7urylD5InB00=;
 b=SyTHPuTfu6XldhCsJsxL05kPdjQesA3BYxDY9/U6OorBRZFOXN0/JNicNAkunxH2LhSbax+0diWEDwhu/dBn5eSSGQb+ZIIl+fYzcPNa8Na0L0qlZtxkj5DMlt0fW/zfHS8jKscmbqJwlS7xMQTINSJy/vvO+LFPwm6cJSIysEYB5X8leCznwUBGLqQ5V+S/ndtcHeW+mX9F5mj013znahwCY/2nnqW9yF0G5d16OaRXAKcTaS/wMOkdQN0SsOXVBQXZpP1Bw3YxeywT7a2+MbdC+GCOjSeFDWMqlfO1xaDivMPrTa13dyNncIsLTBVX/Hq0lbSmPM7whRHAjAPSgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SA1PR12MB7320.namprd12.prod.outlook.com (2603:10b6:806:2b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 07:54:04 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd%9]) with mapi id 15.20.6134.021; Sat, 25 Feb 2023
 07:54:04 +0000
Message-ID: <083dceba-cc14-5aaf-1661-0ce5e29f161a@nvidia.com>
Date:   Sat, 25 Feb 2023 09:53:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v13 3/8] net/sched: flower: Move filter handle
 initialization earlier
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
 <20230217223620.28508-4-paulb@nvidia.com>
 <CANn89i+Jd6Cy5H0UWS3j+nucGu-e8HP1sqdfoGzS=vGEEGawMw@mail.gmail.com>
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CANn89i+Jd6Cy5H0UWS3j+nucGu-e8HP1sqdfoGzS=vGEEGawMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0428.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::32) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|SA1PR12MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adcf058-afc1-40bd-aea0-08db17057680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m+kJboDaUVcwW84Ivpx7om1gdN2ukzPWvwZie9UMxgfiCsJtxChcpGVY0+jVAkN5M/SIMNa0F27xAEmSnjB4WN2T0I/B7MKnZxkfs4o9/Ke6OAbcjt/KPOSXZI61SO5cZmUIPf6LbQ/OfEiiD2a89NsdX/DnscWly/9aDyK/Vnp2F03lEeJZ17tAYeV1/LhCEAm0U5jDgtXpnfSZajMayOhc/ie+9/W90GD2kLWr7BlrBik0n//gesrOqzelJLpK+t+WS8hWifukZaOoJNQkmpnOLi19R2OPbS0C6waxi+1oA8cOyIACwqUh+mgX8ohxSFh5GY8BESI9Sjw7CPFIcKvLSAHTUNLS05u8pKJb12Hzuaxs0Da9Cu+TmNhRzmGsWQVXXxEgq61qjDJavWM/gHXfxAO8XXTvwuLdoPjkC+aYjGMukM4Gj6d4B4iFrTVfnTgBi1DGPPCyNJ6PXaroYbSFc9ZS/N4MMpKAxMNwmTUjOnbwqq47kwptACmvLj+pTUT1P/OpyIoc5Jfm89pNy3lesk4O2K7wPoSgojXuvF8RVfyts4MbGh47pWX80Ar4hdvAKjlNC/7QLwS1UYYViQBEP3sDKwjhpKLa08t4HMALGzoDDHXMLbFktqmb3asSei/9J9X/pi5pkS7nB3cV+eUJQbTT31xafLofe5by1bY5Q1ZTpFB22fUyRAVbXduuoix5ESBD6ESHddX7Bfa+Per4oiuSBt6mTDKDDLEGHQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199018)(2906002)(31686004)(5660300002)(36756003)(8936002)(66946007)(66556008)(41300700001)(316002)(86362001)(31696002)(54906003)(6486002)(4326008)(6916009)(8676002)(66476007)(478600001)(6666004)(38100700002)(6506007)(6512007)(53546011)(26005)(186003)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmtweUxwSklKYlo2ZHNGVkRhelhtTlF0RGR1R3p6WDEzRTk3Ti9YeTFjNjM2?=
 =?utf-8?B?UjZGeW45VTZRaURnWjV2aGtGQUhGcHpNVnJDSXdkK1cyRkRZTVY3ZldIMjVE?=
 =?utf-8?B?azl0SmZ5WFAvaUFIY1llb0tFckxDRmJwL0tzWUVJb29Oc2VoMUs0bjUrOEZK?=
 =?utf-8?B?cDQ5UHFUUCtrQ0ZHamJ2eE91ck9LNVRIWDJ4YkwxNDRkazE4QlV2Q2FVMkxq?=
 =?utf-8?B?RDJ1Q0paSkhMeXVhYW0yUGtlTyswdUdjak56N2NyZ2RmRG5kUXhISWdSVmhm?=
 =?utf-8?B?Wlh0SzJmSWlPQTdXUFZmRW5zaC8vbE82TzRSM0dhRlVEZmszeDRTcDlxMlRx?=
 =?utf-8?B?c1ZmVDJPQjFLTzE3d2FWREh6S1VoNjNkSEhwdTdsNmlvTGdxZWlKa3RBR0VY?=
 =?utf-8?B?OUtDZUtMSks5a24vU1prMDJLRU04dU95ZUJXcnFnc0ZySURoVmhrQjJncjhF?=
 =?utf-8?B?UHNYbjYzRmkzN2xBa0Vxek0xaTdZTTVJNGM0Z0VsTnN0NVRISXhjREphUVBQ?=
 =?utf-8?B?YmZGazJlR3FOMHFjMExMREk3TlFvdlluaFhFTHFpcHN4VTlrV0ljVmZuVmxO?=
 =?utf-8?B?Q1R2RHlmZjBjY0Qzd2doMjBNVFBodnphSTlLQ3FFVnZCL1lEYkREbFdBN2gx?=
 =?utf-8?B?bFZVcEhuRU80VVNFRjFTMy9vVGNjbDlPRUJORnVnemhEbk5SQUNwbTJMa2oy?=
 =?utf-8?B?VndTZlF4R2IzZHI0TmlmWjRRaHJvTjdxbEhLRHBGNWU4TGxCMEVENWZpUlBV?=
 =?utf-8?B?U21sV3JhSFhyeDBXdG5CWm5CT2RpekRUd2J6dnlkdE0rYVg4M2k3Q1Z3WGE4?=
 =?utf-8?B?QmFuQ1dXUHBlRXU1UEg0b2xiRmZqbVNlMEhUL0ZVRVFuNm1Jc1hFb1hUZG9K?=
 =?utf-8?B?U3F0TmxpT3Y0MUl2SGNhOUNvUjRWVkNFRHhUVW4yVC9vTkxUWkIrZ0RGT3Av?=
 =?utf-8?B?RUsxT1QrRlZoYjZCY1VuRDdZd1p2MnpmR0huRlowM0ZUUTB3dllMbHRHMisv?=
 =?utf-8?B?eXhwaU4yWTV0TzBPL295UmJzQlJveDluRWVXaXRTdkE3aUNCVG00Q29HMklJ?=
 =?utf-8?B?dFdRWVVWM0lnR0ZmTzFsQnloVktqdUZiT0FEOHgxR3NtN05ycDU3Z000NG1w?=
 =?utf-8?B?V3JOV09nSzlVeWJvTXhOM1FBRHMvdVRoSGdNcHpQcGpIZXZENzQvanZQeTFK?=
 =?utf-8?B?amRzc1FraVM3UzFCakJIS3NObStzUVJFUmlwT242NDJkU2VrNzNQQUdtTGNo?=
 =?utf-8?B?RFE2aUZ2SVhtRE0xVEo1THJNNnBxSHYwRHBsVTFmalhVK1lzQ3RFRm5veS82?=
 =?utf-8?B?ajhhdTNaOHRTdlZjYVlHSXFNRE1jMFBlR1VZWE04S0YyZ1B0dzVnVXU1akdj?=
 =?utf-8?B?eCtJbDI1RkRGOW0vOHIwU2kvY2VTZ20vaTFHNk9NeGtxREg5eGZyVTFBWmRh?=
 =?utf-8?B?UjFzUnRnUWdkK2ZsYnc5b3BWM1B5VjhNeTl1eTA3cTUrd1d3a2E0M1MxNHFU?=
 =?utf-8?B?YWZJWmpiRTdacENWMzhJcUN0elpJZEZpWlloUHVlMlNzSThJM1NQdkFxWWlo?=
 =?utf-8?B?TUtUYlBFWXFVdFkyUVphKzk4YzM2YU55aUhhTVowNkFyRjg3dWcrcVBYQTl2?=
 =?utf-8?B?eEgxMVk4Rmw3NnRVOGlrTCtTY0h3eXBIa1ByaGtOWllyajZTTTkyZXVnTVZG?=
 =?utf-8?B?SDNOZk1HM2cxRFZ0WmorMXRnSXhvaUIvM0JSa0VyQ1NiVUwrT0FGV2NZMHEx?=
 =?utf-8?B?RnlpYVdkR1lRd1UzS0pMVjlkOVJ6QWZYUUxaVzY4RE5pMEgyMFVNRWhoZkJO?=
 =?utf-8?B?SkNCQTZmMU16QS82QUpjVlZjb3dYMTEraEpCMVE2U1drdXBMcXl1MnN4UzIy?=
 =?utf-8?B?RCtKbUJacDQ5NXJoTkI1cGY0WjdDK2RwQjcvditDcVFiWFYyeTV4RWd6cG95?=
 =?utf-8?B?K3Ztd3JxQjM3ZkNpU0k2UUlLRTNZRFZrRU5tME5QOXFabWVXL0wxRkpUMlpM?=
 =?utf-8?B?bGQrRXQrL0VOcnIzOGlUQW9RWjM1ZWJJeE1NcHFMeUVKRi9TTzlIMy80Yzdx?=
 =?utf-8?B?T252SFhzK1lndHNkR2FVNGFod0Z2L29Cbk9VSWpuUThxSEtwMzk5MHJiSWpU?=
 =?utf-8?Q?hF/o/bq7IsW/XN5oPphvdaoX/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adcf058-afc1-40bd-aea0-08db17057680
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 07:54:03.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BrjUDNvN5S5+HZIaWWImRrHFsb6k6wD3HzneBa7A/ZFhIAl5TooY/0e4INrqLHZFGUtDskgNuEt1AYVJ2JXOMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7320
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/02/2023 12:24, Eric Dumazet wrote:
> On Fri, Feb 17, 2023 at 11:36 PM Paul Blakey <paulb@nvidia.com> wrote:
>>
>> To support miss to action during hardware offload the filter's
>> handle is needed when setting up the actions (tcf_exts_init()),
>> and before offloading.
>>
>> Move filter handle initialization earlier.
>>
>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> ---
> 
> Error path is now potentially crashing because net pointer has not
> been initialized.
> 
> I plan fixing this issue with the following:
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index e960a46b05205bb0bca7dc0d21531e4d6a3853e3..475fe222a85566639bac75fc4a95bf649a10357d
> 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2200,8 +2200,9 @@ static int fl_change(struct net *net, struct
> sk_buff *in_skb,
>                  fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
> 
>                  if (!tc_flags_valid(fnew->flags)) {
> +                       kfree(fnew);
>                          err = -EINVAL;
> -                       goto errout;
> +                       goto errout_tb;
>                  }
>          }
> 
> @@ -2226,8 +2227,10 @@ static int fl_change(struct net *net, struct
> sk_buff *in_skb,
>                  }
>                  spin_unlock(&tp->lock);
> 
> -               if (err)
> -                       goto errout;
> +               if (err) {
> +                       kfree(fnew);
> +                       goto errout_tb;
> +               }
>          }
>          fnew->handle = handle;
> 
> @@ -2337,7 +2340,6 @@ static int fl_change(struct net *net, struct
> sk_buff *in_skb,
>          fl_mask_put(head, fnew->mask);
>   errout_idr:
>          idr_remove(&head->handle_idr, fnew->handle);
> -errout:
>          __fl_put(fnew);
>   errout_tb:
>          kfree(tb);


Notice that the bug was before this patch as well.
We init exts->net only in  fl_set_parms()->tcf_exts_validate(exts), and 
before this patch we called __fl_put() on two errors before that (like 
if tcf_exts_init() failed).


Here, its the same, we can't call __fl_put(fnew) till we called 
fl_set_parms(). So you're missing this "goto errorout_idr":


	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle, 
!tc_skip_hw(fnew->flags));
	if (err < 0)
		goto errout_idr;

Thanks,
Paul.

