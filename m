Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5106C3FB799
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhH3OLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:11:47 -0400
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:42720
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236877AbhH3OLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 10:11:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deyNgmbUNjWSZpQvV6QBwoo7P998N+PelpbIBApjYX4pfmCcaCwbyRRl2FURHISNieyc+SUqjtmYu+Dy5Dk9yIBReWvHCvU7CYyCDzzVnMUIqq3rhQ7326gS+JZGAa8wvxwdjK4Q6tFc7bS+sp/piwSMBtywQAfwmwppyld4hNwSNjN50yr76n9G2/qbGibJbp7KYZAdtyYqikt6dj1+W8wNxC35QyWnATtJIj0E1G8vojMAbjVZKAeZtcFTbglSB92jgEZY29Ub187ik+fRPCwhp1giucKSGvR3cuOC1P2xe4/KMpVufZnjKinZbYrXTZfGqf4FmYzVF+1ZOYBMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVx59GCnJ6XdeSqJ2mV2CGUL41O6bK0WCiaHOO4fN98=;
 b=lMru6n1sBT5R1aZ5j0OgbmzNYJVg1oHoRUPMxNXthlwabdQoINkw2Yax7IwSJV6bzI4M29JBb359Q8/PEYs2SU/enod8c3jhvp7Fv2MsZGnpB7YrkDihQy2iuuTTtT7vKsQrBarB7Vhre7arBhYxBU2sYgWB/JVDLujStDPKosxQaQlZD3q6D/AvdtUUiC8qTnSYVR08ayz4cKzaUFZPTw4ChoApIJOvMRQKdOwWElk3lwjTwFjQV4HUDyH1s3NAr9h1UU0S8kpbTNZzGFelBOurpxrsMY29mVQtmrdo/4iIoMSffxMawr83okuaqEmV10VhIXtHwztUP23hg6x9rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVx59GCnJ6XdeSqJ2mV2CGUL41O6bK0WCiaHOO4fN98=;
 b=08D23hlpiqAOsuBE+AuC/M+l2Lk/ZecBFNC6gs7T1sedlmgHydcouhQSdxaP/sUOyuyMV3BpXyxAllSzoc2M1FWMpqcR4fkyLXzt4rAcmMQcsuEVLzpzCthGk/sJ2ta4GDNO1NReV+53hnsVykVR1Ff1drij0CA5BmBZBr0gAt0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wolfvision.net;
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com (2603:10a6:10:c8::19)
 by DBBPR08MB6298.eurprd08.prod.outlook.com (2603:10a6:10:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Mon, 30 Aug
 2021 14:10:48 +0000
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::452b:e508:9c57:a6e3]) by DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::452b:e508:9c57:a6e3%7]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 14:10:48 +0000
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
To:     Punit Agrawal <punitagrawal@gmail.com>
Cc:     wens@kernel.org, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, sashal@kernel.org
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
 <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
 <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
 <87czpvcaab.fsf@stealth>
From:   Michael Riesch <michael.riesch@wolfvision.net>
Organization: WolfVision GmbH
Message-ID: <aa905e4d-c5a7-e969-1171-3a90ecd9b9cc@wolfvision.net>
Date:   Mon, 30 Aug 2021 16:10:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87czpvcaab.fsf@stealth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0107.eurprd04.prod.outlook.com
 (2603:10a6:803:64::42) To DBBPR08MB4523.eurprd08.prod.outlook.com
 (2603:10a6:10:c8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.125] (91.118.163.37) by VI1PR04CA0107.eurprd04.prod.outlook.com (2603:10a6:803:64::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.22 via Frontend Transport; Mon, 30 Aug 2021 14:10:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4304f7e-9a90-42ab-bf9f-08d96bbff789
X-MS-TrafficTypeDiagnostic: DBBPR08MB6298:
X-Microsoft-Antispam-PRVS: <DBBPR08MB62986C36B27D5D59EBAA6154F2CB9@DBBPR08MB6298.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CaEBWpado7MUo9C8UEZ7w3l93U0iE4lNWlcvp+dfHI8EFuxh45shiaOcs7X9ZnodZg8myMsqy7BNPBMXh/ABPu/o9+g+6RO1+UFgOpVr+bvKSS+ZD6Rn33D7SXXtDP6eci3vVZltqrrSyi4ZwdivC8XynKuC3FThWZMehAtUH5iSll6f8SIvgFzzOorB1s2z03D8d7Juh86ztrEdzGTC2ViHWr3mt1OqyKKDUZN7TdS/YbP3LhfHRuByuB0Pep2XA5FZHHsCAe7eRs6ca/vKolLHb1ZgHL51sucfTYdRH+nWFtLPx6IKVMzpaUiywj064lfYuhvTb+pYRVT3SgCh9zfHr0z2e7J0X5/dXipYR2NZ7m4MgZBGrvDdPN0pXnUYJKnHchNRQhyk9AzwDf3dBvO5pJqrr8yzxNqOC4RWSjlPDau3xddpYHidGd84bVBWasjm6zfGdl2k06M5cds0Sr7LD2vm28Wbm+uSfG6lq+c9TkXMNmS/440qlJ3dX19shukjogRap5YI2jMCwzy0TN6lEB0fr6W5tw9Z+ir3yUoSf5I8PoG9V6dZFiLNnuKKlfimUAcjHxnmX+ux0DaVZHy011et8y+EROZ9vKj15NC69mOWG8/WV0QBfQ1Cp2I9nWPxe9tSonC2Pr1ixgxF2HgkEm0Ldt2Ge2qYkkJVreOKV+USHvIC4FZMNz6HxovQvRE6M+UnZ50Azj81s/qaXo3dhsYtD1Q4yh3p4/7almLaIHJf/Fstf28+C7+BEzJEzSUSTca0tuK03JBTFSaDG4W+bW2/a7pRLv5b6tu3EBsRE/jX197FBJ9T2juQN4YoUGBQx0jBt4oz+jH63d4zaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4523.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(5660300002)(186003)(7416002)(36916002)(36756003)(86362001)(31686004)(83380400001)(2616005)(956004)(6916009)(31696002)(66476007)(66556008)(478600001)(38350700002)(6486002)(8676002)(66946007)(2906002)(966005)(38100700002)(54906003)(8936002)(316002)(53546011)(4326008)(26005)(44832011)(16576012)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE1mVERWNHpubE9qU29FUE5SV3k2cURRaUwzN2dJTGlLUk1LbTdvSVlFOCs1?=
 =?utf-8?B?aXNRc0VHT1ZqYnhwSlB2MTluejhyZnp2Wk1Qd3oxa1dhWHN4TnRhZ3BiV3hs?=
 =?utf-8?B?aGllUTdqMzEzY1d0dGQwaW9tdWFDL25zOGlMS3N4enI1ZDhaeVZkd2RobjlD?=
 =?utf-8?B?bkRadFVyTzlkNThYRTNXSEFxbjdMZkMyTjhoWUorM0NDM1kwRTBzbUFaVlBj?=
 =?utf-8?B?eDhDSEtONHREdjZ0blV4cjB6YUpVV09kWDBLbzlRUWJwa2xLVTVoektHck9p?=
 =?utf-8?B?VWRSNm10MENnblZpS3JYK29JKy9ObUd1K214VTBUdmMwS2ZUL0hEM3VLRlJ4?=
 =?utf-8?B?WlFwS2N4YjJWZzNnRGJWRWNHQTdjVUJ2dzFxUmxnYTRNZklwZEd0SCtWK0Nn?=
 =?utf-8?B?K0ZYWjljblZXRU5RazVBdWdIdVQxSW84Ym0rYmhmazlLRFFJYWM4MnZyeW9J?=
 =?utf-8?B?RnBtZ2p6b00yT3Uwd3NHTkhuOWtLRGtFRWhSMmNLS2w0RFJrcmNqYzEzcjcx?=
 =?utf-8?B?STB4R3ZCbUhoT1lXNlI0Z0Y4Nk9MSGJ1SFpTd2dXQzRnTVVNNHVwY09ZQmla?=
 =?utf-8?B?clJkZThDbXd4Nzl0OXVGeXdqWkl5QXlESnVxMFdNWGNDTmlOMmZYVmN1OHVq?=
 =?utf-8?B?dVBmakJrMGFtZmthSmdnd1I2SjNpTy9aNk9OUFpMRUp4T0ZyT2lDUXFUMGdk?=
 =?utf-8?B?Q245TkRjQkZ1TTVRbzhqY2lWN2tETGtGeUZzS1NaNlN4NzZLbC9MdjhMdW1T?=
 =?utf-8?B?SWdjbkJ5UVJseHlQUU1QdDkwM2FOeFpFYTVuWE1MUmpVQkQ3TDFsUVROZzJj?=
 =?utf-8?B?QUFtOFJvMVpVNjMrR0VHdUFRZDUxT1ZSYTRZUmc1UDk1dkRJbEVmYU8waFdm?=
 =?utf-8?B?WURTWUxTeTBka1AxMGs0QVhLT3JCWVpuRGVlSnFzaFhMcHF2VmVqYmZjME1P?=
 =?utf-8?B?YklidWNHZG1pV05YSEpkYXJ6M2FTV252UEFLZDhnZktwWlUwbU5uRi9tSk1B?=
 =?utf-8?B?aitSUHEra05NeFJzcCsybUJEaTFmRUhrRTZRQmFjK0RjUmN2dHgzTzlRbXpL?=
 =?utf-8?B?UEtjbzQxVmR1YmpxM29QOGJXLy9DSVVlNlJZSlZsalowT1VCUjA1QkxEcUVt?=
 =?utf-8?B?L1dGd05nTm1WSUNsVU1uYitPTlpsOW8vMjEzTmZ1VGtPTkZnZ1BlS3hFK2pZ?=
 =?utf-8?B?NHFBM3RUVlJBYnY2VVhlZkZ5VEJmaTZXVVFzb3ZHMlJ2eXJydlVleng0eUF6?=
 =?utf-8?B?V1ZrbjU4eXVzSENEUmFpMGtUVHExbGpaZFFHR0I3bkpHWWF1SzlwWE9YYnBL?=
 =?utf-8?B?ZVQxa1YwUmtUUnNqT2xOWTZ6djJYangvL2Z4OGRkU1JEdXhmVm5hY2VZSzlF?=
 =?utf-8?B?SU1na1dZSUJSSFRnaFJGMVVVNU9WcUtXZnFVdkk5Um9GdHB3QkV6aG13ckU0?=
 =?utf-8?B?UUhkNzNVY2UzZThXWXZURkk3bXJVSk9VYjRGOVp1ZkdBcjFYVVJDUDJhNVlN?=
 =?utf-8?B?L1J0dkVQWDFHdDUxVExoaldVdWw1QlAyMmhFaEtUR09UdktnL1lKdXNkUTNi?=
 =?utf-8?B?bGkrVGYzRk5OOFB2bm0xd21BTFVTQTlUYWxDZUl4akoxSjRRNVhhRW9pQ09m?=
 =?utf-8?B?R3NaakN1ejIyTjI3dWY3UFc2UzMvMHFQbkZPUkJVK3RSYllJQnhReVhLQlZ1?=
 =?utf-8?B?eFgzZXlDc1I5MGJxeXdMTWtNaWNJWjBvM1R6OWJBU3UxQi9aMklibVdQYnUr?=
 =?utf-8?Q?HiplEM8Hi5Kf/UWMsfQMAWdMrSfT9MdnL2lXKIV?=
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: f4304f7e-9a90-42ab-bf9f-08d96bbff789
X-MS-Exchange-CrossTenant-AuthSource: DBBPR08MB4523.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 14:10:48.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0kCyCK2Qp1Y6YM5mlXnrx8xwKT2DGZoA0rVlXcv8DVx6yWXm6Fo5tLuFUiLgvZDP3UCLW1v4N/wVnHJNDzb9ZP3kPeIO/xq3xCkN1lkJUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6298
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Punit,

On 8/30/21 3:49 PM, Punit Agrawal wrote:
> Hi Michael,
> 
> Michael Riesch <michael.riesch@wolfvision.net> writes:
> 
>> Hi ChenYu,
>>
>> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>>> Hi,
>>>
>>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>>> <michael.riesch@wolfvision.net> wrote:
>>>>
>>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>>> unbalanced pm_runtime_enable warnings.
>>>>
>>>> In the commit to be reverted, support for power management was
>>>> introduced to the Rockchip glue code. Later, power management support
>>>> was introduced to the stmmac core code, resulting in multiple
>>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>>
>>>> The multiple invocations happen in rk_gmac_powerup and
>>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>>> in conjunction.
>>>>
>>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>>>
>>> I just found that Ethernet stopped working on my RK3399 devices,
>>> and I bisected it down to this patch.
>>
>> Oh dear. First patch in a kernel release for a while and I already break
>> things.
> 
> I am seeing the same failure symptoms reported by ChenYu on my RockPro64
> with v5.14. Reverting the revert i.e., 2d26f6e39afb ("net: stmmac:
> dwmac-rk: fix unbalanced pm_runtime_enable warnings") brings back the
> network.
> 
>> Cc: Sasha as this patch has just been applied to 5.13-stable.
>>
>>> The symptom I see is no DHCP responses, either because the request
>>> isn't getting sent over the wire, or the response isn't getting
>>> received. The PHY seems to be working correctly.
>>
>> Unfortunately I don't have any RK3399 hardware. Is this a custom
>> board/special hardware or something that is readily available in the
>> shops? Maybe this is a good reason to buy a RK3399 based single-board
>> computer :-)
> 
> Not sure about the other RK3399 boards but RockPro64 is easily
> available.

I was thinking to get one of those anyway ;-)

>> I am working on the RK3568 EVB1 and have not encountered faulty
>> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
>> whether I can be much of help in this matter, but in case you want to
>> discuss this further please do not hesitate to contact me off-list.
> 
> I tried to look for the differences between RK3568 and RK3399 but the
> upstream device tree doesn't seem to carry a gmac node in the device
> tree for EK3568 EVB1. Do you have a pointer for the dts you're using?

The gmac nodes have been added recently and should enter 5.15-rc1. Until
then, you can check out the dts from linux-rockchip/for-next [0].

> Also, other than the warning "Unbalanced pm_runtime_enable!" do you
> notice any other ill-effects without your patch?

No, not as such.

Best regards,
Michael

> If this affects all RK3399 boards as ChenYu suggests quite a few users
> are going to miss the network once they upgrade.>
> Punit
> 
> [...]
> 

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/log/?h=for-next
