Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54416A2B3D
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 19:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBYSK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 13:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBYSKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 13:10:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B27315559
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 10:10:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LV4roSp3rRoMsNldVeD5KBpsq7R9orY9ML/CUCoRhh4uP8LQhKUfayiLlfr41b8TUgSF/KZ8sCppbUGGz+bF6nDXqtiCfjjJPmJ9wZe3ZFDEX7wVWRbP8xAS6pG4IqzoE51jNZpZ3zp8/u7AgpC8gkpuj3vJQO5+MSRGIt45lJ18iLLfEGdXZfVnZ5bnKpQcrMARapWbGAHQQ7FFPAMrqubkR5Ysb/pdwm0EWs761tHQZySKUo3VfqPbEHBRFC3J+ZO7XKKrcexqIICeZ6IxP5/qaD7TKhScibHq/TEQbjeQZEmlbZPw+xS764U5n6HLN1N67m5uXNv4rPyny9L+9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DI5jItakVFJxBhXF0B5FqsSnxJir0QgfidifLzoGQpo=;
 b=j5iNQLVxmScPdeT9sduPnjxFHvhY5Yj1i/9dGdVqLdaWVD1DRtinEzIE8iAAFQmPQy2sGevRwXy6nIdchTPtWGDbRSyOmaPJl18gOxhu4xreegRxVTpP9uLa3l5q2lukoYj2dFdnJHIuNT64q8Ode7cnIyqok96M805tXOaRbTNVjSLv34W4I2fcGRccfqStvdFpx4jrM/7F4Y9KlNufVj1twUHmYHTibn+vN7IYPznPSPQqsdMcX/83CKV0hNYtwHFnVae/AYCPmHIi9fW1xsPNxJ99O9QEWssiEORrQ8jtgWXSIWQUm1p3mCX4Ajm9s4umaNGIDP7c7RGMD93C3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI5jItakVFJxBhXF0B5FqsSnxJir0QgfidifLzoGQpo=;
 b=BvAhenAzqeOo0cRWp9itvhhK52sY7JeCx9nOZlMrrFDzhihkt0B2bBp/kUBlY3I/uQ92HBFv/OijgazxfHpRVJIV6rGKBNWv2hzGj7n26VMG05Pji/nt8OQdVMBNyI4hUFerBaFbQ5QKOyEWsFUPssoK4f0L0zSDeWb9d328RGHokR4iNch6iR7JIkPt4kqFeXV3CuLVbeM8y9uu66Y+EdAnZxbvagWN4PwSoq95bzU0JwvZasyPPTF+CZl8kWWAq1LKrV7hwxgGCKzWU+JEdmcoiJ2zk4+wETpCvxRFDiUEXPdjOhKdpx5iD/KDnaRDUsOw7Xlww4DkaAWEv0Qc9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by IA0PR12MB7752.namprd12.prod.outlook.com (2603:10b6:208:431::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 18:10:19 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd%8]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 18:10:19 +0000
Message-ID: <4f43fa6c-d68b-11f6-66cc-5ee995d05a6e@nvidia.com>
Date:   Sat, 25 Feb 2023 20:10:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v13 3/8] net/sched: flower: Move filter handle
 initialization earlier
Content-Language: en-US
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
 <083dceba-cc14-5aaf-1661-0ce5e29f161a@nvidia.com>
 <CANn89iLcuA-shK=eo-vYs_H3Q6GugaLn6nTpVT3dCmhcm87Q8g@mail.gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CANn89iLcuA-shK=eo-vYs_H3Q6GugaLn6nTpVT3dCmhcm87Q8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0137.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::30) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|IA0PR12MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed0a97b-1608-4571-1091-08db175b8dcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ic00qZ8UBvkVVksm2BTMjm7aduam+Y8OYfZQuUrQwmtYLtVsAWmXXyNAtMDiuyEXAURlpEXBpKpV2SHG5Owzf3jfRvfE/Ccdg0Wu5JKBJtJINRhBsW3MxXTCE9mDjQdPWEj/qDdAppJqSD9GJj/BEIy+Rj/PoRSSFniNpuhtDQ1fRb4kc+rIbqQzdsvn8keeUC2X6D8JfGQ92xGKqr4ov46wAQyD28vTfLPfoqM4QHOwe6E98Jv8rfaJptyL9lXT/4dGNhDmuhx0nx/HSL9od7LZGdWDUYOjejjM6d+QGw911k0Ny+r9lb2ln6w8LQbjXMwA3e+rudejX8rHcUML40qhmCt2fWdaGIOLoTbZwFifUpv52sTLonwjakd8bTIKM6dQlVwjHaiddO7K3h0G7+lvInnR82SJzpr6tQPFcFEI8o04MGooXTE6QovmNfX+fb7b7t1sselEU5e1Lh/IyCJJSSe1dh9OyAXh1pM29GT8UODjG8J58jKVWllCKDcro5Fp86q9SiZHRpL/9Rykdama+oJSc2Mh31FCqPY1PT++wUeyBgikWOy10OTN8jpWQwvj0YP7/4ENpljYHdem6FFCYT2M/Rh8OPspdjhGilezhEaTDU92L5Jl7VSViyBZzUuuu/RADCvXaMqiGV4ScE1hcBIzQq+hfm2g5V18f66ZB4UAoHVU+UtAjod7jFZGS2SArbUGqfd5mNiJ2Y+q9MQ9qeSgJHAs+obV6/Av8k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199018)(5660300002)(36756003)(83380400001)(86362001)(478600001)(6666004)(6486002)(2616005)(53546011)(6506007)(186003)(26005)(6512007)(4326008)(6916009)(8676002)(66476007)(66556008)(66946007)(41300700001)(31696002)(8936002)(54906003)(38100700002)(316002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0gwdUpudEJjTlB1anhlSkpiaTlhY2wvUzN2eG05U01HdUQ0bWdSK1d4a0hk?=
 =?utf-8?B?dFdYVnJ3QWZHdG9BaXBvQkl6ZXN5RVV3ZkFsYkRSbmN2QklEZFF2YzZ6cXNW?=
 =?utf-8?B?RzRxZTRpd3RiV3pTYnlnNnZOb0Z6cnN0MzBWSG9VaVF1YTFITXloOWZVM2RN?=
 =?utf-8?B?OFcveDJER1plb1ArclRiUXVsWTRHU21DY254M1VidVFtQjgxRWx1RDVJM1E2?=
 =?utf-8?B?M0pQaHJ5dk1GdUFEUDZDVERwQ010N3REQzdlbGg1ZkNLOFVXYnM5aUt4MjBa?=
 =?utf-8?B?TDZMTVorMWtFaTU4S1hzRGpTYUtRSSs5bnFkdzJFallnYlJRamZoZVYyUHU0?=
 =?utf-8?B?RUhiak9EbVMrYzJpS1VURXVGMUx4QjhsMmt1cTJSWUN2OHpUVnhadWU4Y2VX?=
 =?utf-8?B?cFp1cHVPQUtkRFo1V0h1amgyWUVmdFBQeDdtTEsyUnBiRDQ5U2c4dTVMWTBT?=
 =?utf-8?B?M3pKc1BDNi8yZGRwbVA5c3lMNlYvczQ5cW1tdi94NUg3T3FJL3ZENDJsTDIv?=
 =?utf-8?B?RlpJSVR2R1ZmSG03Y3ZubzFZVTJ1eEMyMk9IdmxvaC9ENkR6M2h6RVdnclFP?=
 =?utf-8?B?WXFkUUR5ek5vSUhKckVJeGpqQWNuNWFPTjkzakFVbmJBUUVMN0ZaelBOK0pV?=
 =?utf-8?B?eU04UUMyK1ZodDVWam1FS2FZS2Q4NGxxZG93eG9KVklPa2pQOGw4eENwWlY5?=
 =?utf-8?B?S2NwS3FCYU1xSUVZaGE5UVpKZVFjTDFFenFvK2FwNUJFQkMwV1ViN0Vpdkwy?=
 =?utf-8?B?bWFkTEJ0Y3ZGaHZsYUR0YUNFUVlpZ2FVbEF4U2tueEZCMmJjSmtKaUgzbENj?=
 =?utf-8?B?MEN1ejdmbUlhT1piRWlCR1dveVUvMGt0K053TGJ6cmZLRCtWOUNndDM4NlBw?=
 =?utf-8?B?Ty95TVJ3Z3Y0clc5aTVRNGo2WkVhdzZWMkFSOElUVFFjU0hackJaQlJiNGJV?=
 =?utf-8?B?TXRBaGRETWlVTmJQWkc2VlVrMFJiS0VZM3E0UnA0bU9IZ1dhenRUZm5DVXpV?=
 =?utf-8?B?cm5LYkpHbU14d3pjN3M3MnBZejh5eFYrOFJKakp4NnRjRTRFVEp5dGFvYXUz?=
 =?utf-8?B?Z3JtV004KzdrNzlVOUhaVmRtOXhVbGVzUXpTOXVNazJncTkxM0dtM0RtSGhF?=
 =?utf-8?B?OHJNTUl4eCthZzJrKysveExSTHNsMHJocHBDUGJHZGhqVExzemFUc3hCRkpD?=
 =?utf-8?B?ckdoVVVnNW9sK3FYa3ZuUUwwMjRuMHVyTWQ0dTJKbVFwRVFMYTA4ZGNOVU5v?=
 =?utf-8?B?eS9IRmpTQ1FnaGdFbGc5cXRiZ3g2V040a1J3Y1pwcGg1Zzd0SkNJOU4xNUZH?=
 =?utf-8?B?U3FObkJXa0JuWHFLN3NQVThMVXEyQVgxR0tKY2crMHpyQ2JBeVNCUkQ3K0RL?=
 =?utf-8?B?aG0vMUR0TWJGOFU0dFl2MlVLR3J3ajNWd2FCSjVPOUkxQnlNc05STmFodlF2?=
 =?utf-8?B?cmc3TDRTT3poZXJpUTFYa1NmanhYY2tpVVhBcTVHalZPRitaSVVNQkY1YXRy?=
 =?utf-8?B?Ti9wWldMclY1c0pMT2RZaEwwNVB5YXlxa0t0UHZ0QU95Mnk5TU5tR3YvTVdh?=
 =?utf-8?B?YmVKbnlML1hPWDh3MXlwc0FsSE00QitzaDBEaG5yOHhwWnBTWDhhc2ZyZzVw?=
 =?utf-8?B?allPSVVEY2J4c1gvNy80RFcreUtjQ080NmlEV0VFQTZRYzFlYkFEeGFlRmZx?=
 =?utf-8?B?VmtQaE1qc01YTjh2UXVmblJjS1JYaDVYUkFlSXZ6a0VGRUZubG1KcFVaZmFu?=
 =?utf-8?B?bXRkTlFCenB5VDI5aXBNYllIZENqTjg5WFMxSDRIeCtFZHd1YTFLSUVSc2N0?=
 =?utf-8?B?OUhuRE9yOStIRU1BNHp5S01UUDZaTUtFRkRJTUVNZzNXSENBQWFsY2hiSjE0?=
 =?utf-8?B?TS9TTzBneENRYUI4TjlNSGRVQi81VUhQMnNJSzh2TERESDJOeDlqY25URmVh?=
 =?utf-8?B?NlVjU29wQlF0ckZUN01vQ0ZuRUdJWFZ6Q1o0ck1WQXQ5RTlhZEFob2tqeG9I?=
 =?utf-8?B?dmRDWmJUYWd5cHcyNGoyREhHcVpzQTdjVkdMZkdlL2hkZ09kQjVoOFMweWdl?=
 =?utf-8?B?SWo1QzNNaGJXQkt6eGlGL2V2L2V1K3pxMjdMUnhIKzdCZXVIaXg5dHZicmtF?=
 =?utf-8?Q?QsQ5rz38fvy5BBRZJNlLHP+tf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed0a97b-1608-4571-1091-08db175b8dcf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 18:10:19.3864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dExW5sq8mh2ezqV5P+DFlLf3RQzFEiWo5g6QMVacXzxgmYExfSJ1dA9l1VvfbuAQNGh3H2vbOaB6KmrTpDfXgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7752
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/02/2023 10:14, Eric Dumazet wrote:
> On Sat, Feb 25, 2023 at 8:54 AM Paul Blakey <paulb@nvidia.com> wrote:
>>
>>
>>
>> On 23/02/2023 12:24, Eric Dumazet wrote:
>>> On Fri, Feb 17, 2023 at 11:36 PM Paul Blakey <paulb@nvidia.com> wrote:
>>>>
>>>> To support miss to action during hardware offload the filter's
>>>> handle is needed when setting up the actions (tcf_exts_init()),
>>>> and before offloading.
>>>>
>>>> Move filter handle initialization earlier.
>>>>
>>>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>>> ---
>>>
>>> Error path is now potentially crashing because net pointer has not
>>> been initialized.
>>>
>>> I plan fixing this issue with the following:
>>>
>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>> index e960a46b05205bb0bca7dc0d21531e4d6a3853e3..475fe222a85566639bac75fc4a95bf649a10357d
>>> 100644
>>> --- a/net/sched/cls_flower.c
>>> +++ b/net/sched/cls_flower.c
>>> @@ -2200,8 +2200,9 @@ static int fl_change(struct net *net, struct
>>> sk_buff *in_skb,
>>>                   fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
>>>
>>>                   if (!tc_flags_valid(fnew->flags)) {
>>> +                       kfree(fnew);
>>>                           err = -EINVAL;
>>> -                       goto errout;
>>> +                       goto errout_tb;
>>>                   }
>>>           }
>>>
>>> @@ -2226,8 +2227,10 @@ static int fl_change(struct net *net, struct
>>> sk_buff *in_skb,
>>>                   }
>>>                   spin_unlock(&tp->lock);
>>>
>>> -               if (err)
>>> -                       goto errout;
>>> +               if (err) {
>>> +                       kfree(fnew);
>>> +                       goto errout_tb;
>>> +               }
>>>           }
>>>           fnew->handle = handle;
>>>
>>> @@ -2337,7 +2340,6 @@ static int fl_change(struct net *net, struct
>>> sk_buff *in_skb,
>>>           fl_mask_put(head, fnew->mask);
>>>    errout_idr:
>>>           idr_remove(&head->handle_idr, fnew->handle);
>>> -errout:
>>>           __fl_put(fnew);
>>>    errout_tb:
>>>           kfree(tb);
>>
>>
>> Notice that the bug was before this patch as well.
>> We init exts->net only in  fl_set_parms()->tcf_exts_validate(exts), and
>> before this patch we called __fl_put() on two errors before that (like
>> if tcf_exts_init() failed).
>>
>>
>> Here, its the same, we can't call __fl_put(fnew) till we called
>> fl_set_parms(). So you're missing this "goto errorout_idr":
>>
>>
>>          err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
>> !tc_skip_hw(fnew->flags));
>>          if (err < 0)
>>                  goto errout_idr;
>>
>> Thanks,
>> Paul.
>>
> 
> The bug I am talking about is triggering because ->net pointer is not
> initialized.
> 
> ->net pointer is initialized in  tcf_exts_init_ex(), before any error
> can be returned.

Right, so all good!
