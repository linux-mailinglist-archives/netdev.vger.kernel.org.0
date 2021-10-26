Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4B43B59D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhJZPco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:32:44 -0400
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:26226
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236831AbhJZPcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:32:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUBGNonmFLUA8r7MG0ljgA7VmE2gn5CZZDJqHg3eSS26dBuVh1b0JBJOq4sx74d/OJzzCpLfMpGK2rANv5IZDCKHNxWCvyDU16ZfCvKnq1Ly827tQCP00ezOFIjyddPcgUcRNRGkoD5Waufvc1YZagg/WJpsoEPozTxkLQwProXmbV1OzNUaBYmFCMh5XAHfGkC5lpkYI64DwQjCLOeemvq1T0GIdQfHe5oCaBt0ZLr3qZeQV4BpqvFjCnLaoqTGG2dlN407jq+eKn3YluIQVT2dAt5clPtelFHBbE3BXQSBSg5qbmrqBhb37K6aTj1V4qfSoIWkput1KGNnjOLnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpwaJP7IeMXAVTZKCaBu0aKU8pTxDdZp+1wulUs0Pe0=;
 b=kMrTaDQ/k3n5/3zdYj/5PiEkukeyXgWbgf9Q90hGdIMpQtA/pHmf3S5CdYhqlo7eot9HUBXwtHkQWy/3dmHOgdZjEp/encB+X6Y2zlIFHH6ugYc3cs+iFIEBjKA/HsorBVbvCIb0SyeWrEJSdR286BD9vNm05dqm7S1nwT+QRraKeCkHGRv29KsqHv0sN1mciSEpKBSP7gJxNfN/NkhsYIuewYupTMy13dhrQKo+G+tBdsXSPMfn00gDTehnxE7jLFbrcGxnRrTI6bx6zOedpG17VfPt0i6lFTUlrvqZ0HnXJZulZfoWG/RQlS3tB9G98m1KLyDiY6Tn3CHn+Hno1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpwaJP7IeMXAVTZKCaBu0aKU8pTxDdZp+1wulUs0Pe0=;
 b=mLjqb0WEaT177mECyN+dRVSP2j41fvbccIamm3SevGe9/Ub5Wi00EPzO3M3tA+oA09wc2ht3VZ/cezditOdrT4/0mdBf+CQPfIcALaUKuATeR/He9IccqgMpavFWsfZEDEWpGgAurUBrWO8VjKJ8O4lgJgvix0cigwEU/K//kxI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB6700.eurprd03.prod.outlook.com (2603:10a6:10:20c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 15:30:13 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 15:30:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
Date:   Tue, 26 Oct 2021 11:30:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0043.namprd02.prod.outlook.com
 (2603:10b6:207:3d::20) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR02CA0043.namprd02.prod.outlook.com (2603:10b6:207:3d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 15:30:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68d2ead9-c6d6-458b-0c47-08d998958163
X-MS-TrafficTypeDiagnostic: DBBPR03MB6700:
X-Microsoft-Antispam-PRVS: <DBBPR03MB670020D7D54DE3498EEA969D96849@DBBPR03MB6700.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8LrvlvX5BbxYAaz1oUAmE54+PiNkiJckZDS3Myr5hiEYrGGWQLWOKf6Pk05aK8IMGQhfxtdEtu9QUpSQwrDmTNMjWB6/SpwT3xAG3bbayDg6YtST4zl6cudB/3ossis2ubg3idvK+RsOCeNXmA/5rOlLCN+QhkXsTU8Nicyjh+WFdMgkI56/9Ed+n/Qp3v5F1bzqD50rMNxXQ6qSD+Xvor+EqNqkMhlA7G2KMRAoXv4cb1/5078r37LEYE4pUaExkWMPZs3bsTAB8c+CQQINN/rkVG/kl2HucAEUhHBezbPyML5cC51mVN9He4A1sqOMfLV62wpjAHobEx6gU6ayyjx2+n+evLUXDl1CHAgM5lU0GLX0JklkDBfg1wZr/jDp/zb3tRZ72ky7WdEXOwF85RYchgtU77zseM+uecOgNWiUnHBGyvyOPCZYimlr1TBiR6lugnEctv8BVHxQOpexUu1ZkLt+O/NtnPWwJ5JW/09GfZ811qzoAQGdmSHpb4sG3RuNOUTK7KhOF3lE+QyeZSEqkcwdlcShXVim/CSwSyEsq1zKpibJYsR4j7VRhOwfAn1PAz6ku4zXAMM9rQ2xWm4Wge4E7s2qqpGWxNuYzycdzGShb8hj3Aw1gFATJyBJW2heuumLRWOmiEse6AReEdTZmpcZp6Niw4m04dLzlFn9J/er9aXxQEl6RrPBNe9sE/52ROn28UKCG8tnUeNouJDFz3QBB2bv7Zdkxkho3ENK5Cf+MWIXWp8COyg87FCJATTgn895E6cteJ5WNfIgXjiyMLBeHcpWQg12nksEckfati5ibpYqX2gp+L0kuKgqnGfwLv1zxehe6a4Yq6r90lBz991lADlIGx9peJqCvY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(956004)(15650500001)(966005)(8676002)(6486002)(6916009)(52116002)(66556008)(186003)(86362001)(8936002)(66946007)(38350700002)(36756003)(4326008)(6666004)(2616005)(31686004)(38100700002)(44832011)(5660300002)(54906003)(16576012)(508600001)(66476007)(26005)(2906002)(316002)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0VLUWROVlIvUEFQVjFZUDBRMU8wd2k4ZFF4dld5V29STTJiNEVqWjh4a203?=
 =?utf-8?B?YlVGVVU1eE9QbUpobkhVcHNUaCtEZVlFZk9Uc1psZ0xqYSs5V0szbTNCbjlx?=
 =?utf-8?B?dWIxeDdaRmFQZXRwaUhPVkdPc0duZUUzekQrd3lQT2JjWGpWVnRxWnR3QWNC?=
 =?utf-8?B?OWd0VTZia0ljTlBxenhtSWNGYUNCc3o2YXNRRGpXbU5waUxJNWdIdUJNZ2ZO?=
 =?utf-8?B?U3Y5TWNIYlBKWEN6ZEdTdGNMdFhiYXY5Y1c5MC9icnQvaTZhRU53UC8rV2tN?=
 =?utf-8?B?RGNiWlArZkxoWlhwSWhmcTFLSTIyY3dWMUJsV0Z0Tk9MMVUzc2cvWEpqMzFN?=
 =?utf-8?B?b0VzMTgzVjdHWVVQUU1tQ25tVE1zb0JucHo1c0tqRGdpQytIbU9rM25MTC8r?=
 =?utf-8?B?eUpOcUNTNXVzODBKeFgxaGFBNkJGNVg2WFVISFZCNXFHQ0VsSGFsRkc3bFJF?=
 =?utf-8?B?TU1PaEZwUHZzSGp1Q09SSXNDZFJGdTZRWEVCMmlybldwRHpkdG5JRDh4Z3BW?=
 =?utf-8?B?S2pLNm5ES0FrVGNBdG1WbzZ0NldFbDFWT2hKaklwUGdrejREc0xzN2U5UWdE?=
 =?utf-8?B?K0ltQWZ1TTRadW53aEFEbzh6OGxXU01wTVVPU1B0N1duNTVaaHJ2NWdYSVJU?=
 =?utf-8?B?MGRZUW0yWlB6ZnJJamRwMHp4T0R6V3ROWnlzcldPMkJMczBiRzVlS1RYcVpm?=
 =?utf-8?B?MU03V3lRc3lWS1gwQUNmLy83MFFCSE5NU2lQL0lGZmFnRndZZnRvWHNSVkVS?=
 =?utf-8?B?UEtSVm1naEJLWDJlOWgxRHc1TEVhRnRqNEFVR2dEcWJXTDZsZEtpL3BoenZC?=
 =?utf-8?B?VE5aa1hkUzFSNzJ5emUrSkpQdGZBVkliZ2hwVjNBTmNrd202VmtwTmtCdDQw?=
 =?utf-8?B?TEwxOXVkMmVmbkx5NFpGaFozNFF2Z08weEE0a09GaDJEc3NHcmovbkVKd0U0?=
 =?utf-8?B?MXM1c3VQdmxDd3R2UEY3SVQzSEVzU2RhRkVKbHpnaGh2YXdGUURHampCdEtM?=
 =?utf-8?B?aDdITTNnN3VUZ3ExS0p0QysweUpPZk03NTIxZlFEV3dITnQzcjZhaHRtRmxO?=
 =?utf-8?B?M1l0SlV0RDVFYVlPRTd2Z3MxVGlTUkFYYWNXMExzekFVYUVqTlNyYThQUy9K?=
 =?utf-8?B?RERJWkJWdTRUc0Q0cUtCN3d1NGRLdHBNVUFqa0NOcWtkSTV2ZmM5cGhxUmxG?=
 =?utf-8?B?ZVVETjNsTHpxZmRRUFpDay9FSmMxRXFEd3lBdnd5OUlhV2FDb0xJU0FTQmt4?=
 =?utf-8?B?R2FpQ0FlZVJERDlSTlJ2V1VJbDN6bURIVExlMGNaQ0J0M0p5Nnp1NmxjTFl4?=
 =?utf-8?B?K0FaQjcxZTljekFic3RwNnVtaEUzZE9zcFlyNHdZU3hZcEs3VStvQXZIcTkv?=
 =?utf-8?B?cHdZaVYrZ1BPQzh1RnhwV1Q3RzhjRnpycmJHQmw0ZWpQNTl2ZGl3VFJibUR3?=
 =?utf-8?B?d0hVUGtiZ3diWVE0Tmw1Yk1WY00rQWJZbDN1bkVreUZaN1UvakZ3VjNYVmov?=
 =?utf-8?B?NEh2UGM2VjdGTlpwU0R0a1lPY0hRbHJYTG5sYnd4U1dnbnpMSXduZHRQTS93?=
 =?utf-8?B?dmpEbm9NcXFza2FzWndDRXQybE96dWJ1S016bUVsU0pnbkhvUDRLcDNSNW5m?=
 =?utf-8?B?QUU2aXhOdWxNY0NmdWxTNFl2NVBTQlprTm1WcTZLMHMrMlBWOTR6eENXelY0?=
 =?utf-8?B?Z2pSQWo0cE9NQVlyakpScjc0cTN4VzlkV005cTB0bFc2YVB2dmFJMHYxa2tk?=
 =?utf-8?B?TTNqamQ3anVmTzZ3M1hHZ0hNaUhuUDFFd21IQ3pzamIzZEh6M082MXZtem04?=
 =?utf-8?B?NzZFVlptMTAyRS9ESXEwZG5FTEpQVWljUUdSbVNFUE1EZnJueFFsQWJ5bzZj?=
 =?utf-8?B?aE8wNit5N0dhWklOM3A5aVhWRmNrODV4dFp5U2NldFpSQ1VGZnNCZnllR2hF?=
 =?utf-8?B?c1Z6bzRXUDFNYVRXUFVEN2Zydm1pQURxbms5VUUyTXFpU1BxQ294cjI5aGpk?=
 =?utf-8?B?RDZETyswdDhQNURBRXo5RFNKM1dLOU82WkZRMURZUUpBTkVFWHhTcTdhTmdm?=
 =?utf-8?B?aUEwL1ZISFYzZlNOU3UwZGVLVFRwSVBWKzJBOEVQSHNSQUgzZmpwMjJOYnl2?=
 =?utf-8?B?b3F4VWZ0eGNEV1VBRHVSK1c3V1F1bGw5bjBEY1FhRUxCL0xBRlpldWVFb1Rp?=
 =?utf-8?Q?5TVOvbnT3TUCO2GB+s1v5aU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d2ead9-c6d6-458b-0c47-08d998958163
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 15:30:13.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8smjqiV9zeasU9J/lWGP1/28PXlHlukB4NaXknxVGw1WFqgcAnNI6WVJp5Om3WGQStpMbJKUpTAIltb8sPn5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6700
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 10/25/21 8:44 PM, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 13:24:05 -0400 Sean Anderson wrote:
>> There were several cases where validate() would return bogus supported
>> modes with unusual combinations of interfaces and capabilities. For
>> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
>> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
>> another case, SGMII could be enabled even if the mac was not a GEM
>> (despite this being checked for later on in mac_config()). These
>> inconsistencies make it difficult to refactor this function cleanly.
>
> Since you're respinning anyway (AFAIU) would you mind clarifying
> the fix vs refactoring question? Sounds like it could be a fix for
> the right (wrong?) PHY/MAC combination, but I don't think you're
> intending it to be treated as a fix.
>
> If it's a fix it needs [PATCH net] in the subject and a Fixes tag,
> if it's not a fix it needs [PATCH net-next] in the subject.
>
> This will make the lifes of maintainers and backporters easier,
> thanks :)

I don't know if it's a "fix" per se. The current logic isn't wrong,
since I believe that the configurations where the above patch would make
a difference do not exist. However, as noted in the commit message, this
makes refactoring difficult. For example, one might want to implement
supported_interfaces like

        if (bp->caps & MACB_CAPS_HIGH_SPEED &&
            bp->caps & MACB_CAPS_PCS)
                __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
        if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
                __set_bit(PHY_INTERFACE_MODE_GMII, supported);
		phy_interface_set_rgmii(supported);
                if (bp->caps & MACB_CAPS_PCS)
                        __set_bit(PHY_INTERFACE_MODE_SGMII, supported);
        }
        __set_bit(PHY_INTERFACE_MODE_MII, supported);
        __set_bit(PHY_INTERFACE_MODE_RMII, supported);

but then you still need to check for GIGABIT_MODE in validate to
determine whether 10GBASER should "support" 10/100. See [1] for more
discussion.

If you think this fixes a bug, then the appropriate tag is

Fixes: 7897b071ac3b ("net: macb: convert to phylink")

--Sean

[1] https://lore.kernel.org/netdev/YXaIWFB8Kx9rm%2Fj9@shell.armlinux.org.uk/
