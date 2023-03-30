Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353206D0456
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjC3MHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjC3MHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:07:52 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509AE1FE8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFhpCTC2vr2nRFTGopEqj379cnh1nOikmIghOUMwG1JoiAJdSw321X4ke+Px82nAI//LYBn6OC/a0raIuCoE+MKAQfVwGNvGR4ALxaUCv8lFsMcyPf1T6wVypf0/8+NHUHoUBiYflQbtd+OIep1HgzewfVzXyb+h1lWKV8zqy+MlJr7LDgvdex0beDWuf1cqOnO8sqx/IkiFe62hUAOC30upsRbkFMk8O4+wT06sa34xz+5w4dv0pdQr015lFlh/+TISufiGkc3Y7T1sBMXcphueOAxIU5bMrwOciSDbmdgl6omtYgqL07Q5oL9RFS46TTyJjhXVncGNm9mdPLMIGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjyKgZ0Jn59afArb2bMcd3yEb609HoArRJ5kh98bHHI=;
 b=ccdY2k8GGFtXQxEazLZD8dPVKuE9l5t8iL+oSP479V0XH5E6gtObWEUH4txiwNHCr2xrOaZVsoXKnmyPsCl3njjRMJTgry+aT6YiaMNd50G/IkckKf5Hvp95g4aW06WD2E4tiqRVMd+SdsEXW8rkkCDQ2L9j1/U4rParJOaqJfcNwweIrXD2fxm+v9rUMuO1JGkEI+t+Oubi008tf1fSDueEeF6C52666mu1V9k7IwKfsivfmqz6HE8RSIOYMGbnJQUsR45bm4PDxrXzsPElRujeVHQ8BcXfKwayGFBs7QFuuvLHbgJQ/IRJ3KoHfWH4iIto+DoRHSG+HcFKLW9syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjyKgZ0Jn59afArb2bMcd3yEb609HoArRJ5kh98bHHI=;
 b=wEGRMNbF58wH0lvPZbmBnyg7CWy97QHf7SgEmS9JvtuxDn2jk7nWHsQ6EX7F4ug0mSvgqWMvcSf/mv0OEwkzIK0XhJxyllBsvnapBoNGGM4KDEaby0GrluZ2sCiTSaJXXIo/O7Bt7n03WZrnqf84ZgwuVtkOfPkHzgGzWbXO9ug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7SPRMB0009.namprd12.prod.outlook.com (2603:10b6:8:87::10) by
 SA1PR12MB7174.namprd12.prod.outlook.com (2603:10b6:806:2b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 12:07:48 +0000
Received: from DS7SPRMB0009.namprd12.prod.outlook.com
 ([fe80::57de:d785:91de:d205]) by DS7SPRMB0009.namprd12.prod.outlook.com
 ([fe80::57de:d785:91de:d205%5]) with mapi id 15.20.6178.041; Thu, 30 Mar 2023
 12:07:48 +0000
Message-ID: <ab6265e3-5adf-1129-fba7-cbcd2e6776b5@amd.com>
Date:   Thu, 30 Mar 2023 17:37:35 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: AMD IOMMU problem after NIC uses multi-page allocation
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>, Jakub Kicinski <kuba@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20230329181407.3eed7378@kernel.org> <ZCU9KZMlGMWb2ezZ@8bytes.org>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <ZCU9KZMlGMWb2ezZ@8bytes.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::15) To DS7SPRMB0009.namprd12.prod.outlook.com
 (2603:10b6:8:87::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7SPRMB0009:EE_|SA1PR12MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ba6adf-4cda-4cbf-373f-08db311760df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2UO7qoe1lhXdLpfgIosn5kq+WmomqxMdoWoLdQL2mOCGPzJK4sAU3ug8H4SkND+PO3A1PdEEYNLdj3Y4rX6aj9REVRxk8OPLzwa7I/yaY8EFZiruL43AWHjeedyrdHd4ygaRFamhUS5IeEna3CfeBQvota9AQyq4HbUjjcnRUuq0E0Q1V/GRvKJZ0NJdEQOaxP43jljfHDO+FjTunOwhxysHL25qP8zNSsihxSZjK4BEyUbOWXQ1R6+G297eXxAWHz1bofJo7SqeeT3ZKA4n/2kCfcJQUA0pX1d3jp13z3QIrE56ep9flS8c3O/156BsjUZS9tzqhJmIjybbSlOoQoR2HtBmEF/Gzm7UaoeSge22mIUwhaRcNFHKsMXoalpnsaeGscRpiVj4x7lzMmmh7AHAfAprtfFP8YRjM47dLSLLa1P2SuCacmpiCbXOdIjyZ9Hn6l0c1/VgPdgJvLJPFLcZ25u+5jeMbqR/yXIZikq4XWK7A/EVMlP8g2vnF83MjCTCnbOHiVRUUJkwQfCkBVD2NL0zegHhFK55GtqZdZCDXCayhZMbMpXbEbno5tB6byamx0DTcA2+7DjIg4mQvu7AZN6f4S5GV/ah5HV4vI0S5wdbEXsC8LMirlq0F/+T2hhQyNMYPscKLcwZCyjLvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7SPRMB0009.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199021)(31686004)(66556008)(6666004)(53546011)(26005)(54906003)(6512007)(316002)(6506007)(36756003)(110136005)(4326008)(8676002)(66946007)(66476007)(86362001)(41300700001)(31696002)(478600001)(6486002)(38100700002)(2616005)(44832011)(8936002)(5660300002)(186003)(4744005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVlHamJKc01mVTUwRXRqby9sUTVZajAwckJtT0V6eXFpSWVRN3lXUm0rK2tw?=
 =?utf-8?B?NE9xVjVHZnhiWTY4YTlzbzM2OCtrZE42VWsrWFBoRVV0dHNxK3VDT0pKbkd2?=
 =?utf-8?B?N1pZQ0drbjdhcE1lVUZUb3JsN0h1WDcrekNDTHREWmE4ak80VWE2akJkR2Ex?=
 =?utf-8?B?VjNSYVpvVkhPZ2ZlZWk0bDBKSWdVekcxd0RDVDJBVU82NiswWWNxWTI2WXZJ?=
 =?utf-8?B?Y0ExT2dZSGZwUWY2Z2JjQWdoWU5paVMxTDNsN09ObU55WjZHZy9jOEtEZ1ZZ?=
 =?utf-8?B?NEt1dlNGUG1wTFZsL1ZZMDdNVHM2TUMvdTNoeE1TVXFiZVQ1ZlJ1dzhTcFJ2?=
 =?utf-8?B?cHBlSld0Vm9CTFVrczJBNTVhbU1iZ1BuV1lScUNwdWs1VUlJTjl0NUM1ejVE?=
 =?utf-8?B?dnYxa0RDQXBEQ0YwcUpnOSs5S1NlZ1R3bUtDVVBGK1ZqNmVnbjdPU1pZeDdO?=
 =?utf-8?B?bkFSTkFNYXBJaEwwSFVSTVNEWXM1dVE3K2puVlJQb2ZaejZqZGIwNU5UWGFF?=
 =?utf-8?B?Vjdram13VTg4WG91cnlFMzZYTTVtSGVPYjltWHlsMERkWTkwMnBIVzRBbjAy?=
 =?utf-8?B?KzhzOWc5YjB1QjJPK1l1WCtvT1BPZ2tzZ1o5azZoT1dKdDV3YTAweTllbnlX?=
 =?utf-8?B?eTN3eWpEZmRGelIxY2xtVzRwWkZYbU8yeFc1cVBzUjE0cFNNTmtsQWdQcUZy?=
 =?utf-8?B?ZElGRFJMdk1NVE0wZko1bzk2RW41ckFZWDZDeWNSMzQrYitwWlFELzZhbDB4?=
 =?utf-8?B?NUx1SjNJMlExQndscTdCQ2Qra1FsSU1zbXErVnMzYnZyTUxRbmpCVm1QblBQ?=
 =?utf-8?B?c2lYVUZocSswVkR4cTBYTnlxalZxUjRySFJZMExKZXdtRCt3UEhienEwOGE5?=
 =?utf-8?B?MnRDdS9RY1kxeDhubDdYQVU4OUxBZjdtek9mT2JrdkowRnB0WVozSWxMRENC?=
 =?utf-8?B?WlFMNnhQUmNkcFNhQm1GTGppaVJtMno4aEsrdTJ2SFF3dlA0cHFBMWtNN3dW?=
 =?utf-8?B?Z2QzTnROSXU4V0hOdjNJVVlsMGpxR0g5NitFVENXN3ZZOWRDaDB1VmlGeDNJ?=
 =?utf-8?B?T3FlT3JPRE1iUllTcnllUFdMVUp5TE5rSEZTR25ibHQ3L1BQNkV6WGRNODg0?=
 =?utf-8?B?N2xMR01TZmdSU3lEbFhyVHMraGRYaHhKalV4VXdOY1RvcFljNFpHNmsvTDM0?=
 =?utf-8?B?TnNnM0FLQUN0Q09pTXRDelgvcG1HUW8xNnFseDBsUC95RUM1UmRPUURQTlNp?=
 =?utf-8?B?UkhTeW1Pb2tja3V2MEhibVRramc0eW1GZ3d1RzNIYTdJMzY4T0VmY2hhbnRZ?=
 =?utf-8?B?UC9ZUnp5ODBYcmlmSUdVd0RoZkJjVFBYQ21RRC9yN3pjTDdlMFZFOGZJUlJu?=
 =?utf-8?B?VFhwakFqLzRkek5YOFVoekRXL3RTOGpaNkJCNy9SbkhFYU5QNlczWFI3NE80?=
 =?utf-8?B?OUl3Y2V4NlZCSkdDZFo1RWc0NlF5Q3hFaS8rYW50Yk5vNmNaSFNwUklYUENv?=
 =?utf-8?B?cDBuUmthU01YNVFITERjSXAzS1RvQTViYnM4Q3BjMHphR0I0OUtYQkMwUk9M?=
 =?utf-8?B?L1RWT1RiN0wveWw1Ykd2NG5TeVdCSVhqdk1RbTZ1YTY5NUpuRjhEYXVYUWpi?=
 =?utf-8?B?WHRwWjg1dFlsVmJNYUx0V0x0bys3OENzY0liN3U0VnVEQ2xwenZ3YTJXQ042?=
 =?utf-8?B?d0MraGdaZHVLdTNEdEZ3aVlZUDNlNEtQVzNBQjRFVmF6M0VDZ0VyWlJJSFJH?=
 =?utf-8?B?NVd5UlpQNmU5YlBYNENzMjdIY0dGc09US0I2QURIQnR0cSsxem5VV0FudnMy?=
 =?utf-8?B?cEZTL3BLdXVseVRlazAxaG5xeDg4QjN0WEVWMWxzd2MwT0M0S0hyV1MvTGdS?=
 =?utf-8?B?b293c3BwSG1BbUY3THdzbkM2OFVSb2hWOVc0bUdXclFxWC9uRkVSc1h0d1Nj?=
 =?utf-8?B?Qkh4L0xqbytoT0l3UURuS2pMSGtzVkw1NHJQTHpnck12aHhiL0pMZ28wcTNR?=
 =?utf-8?B?ZG1TeGlDSWxaZFdPeHFQRVJaL25wS201eGcyRlFNRGIxeHZqRmFWNVNrbEl3?=
 =?utf-8?B?U0duMkZwNGVNM1hvMGNWK09zb2N0M20zMldKUUJZbk5IR3F1KzVsZkR5OW1j?=
 =?utf-8?Q?OPxRVNCA3ubrCyOQN7TK8b5Mv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ba6adf-4cda-4cbf-373f-08db311760df
X-MS-Exchange-CrossTenant-AuthSource: DS7SPRMB0009.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 12:07:48.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uz7uiTyrxKymJyl/qUzVEFNafrsRdDHD9cOb7gJeXaEuvdI52j8pRaE7cLv2C3TizXbxqxGwwa+cTFDhrET0fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7174
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 3/30/2023 1:11 PM, Joerg Roedel wrote:
> Also adding Vasant and Robin.
> 
> Vasant, Robin, any idea?
> 

I tried few things on my Milan system. I can't reproduce the issue.

Can you please try the patch mentioned by Yunsheng?

If its still an issue, can you please provide steps to reproduce? I will take a
look.

-Vasant


> On Wed, Mar 29, 2023 at 06:14:07PM -0700, Jakub Kicinski wrote:
>> Hi Joerg, Suravee,
>>
>> I see an odd NIC behavior with AMD IOMMU in lazy mode (on 5.19).
>>
>> The NIC allocates a buffer for Rx packets which is MTU rounded up 
>> to page size. If I run it with 1500B MTU or 9000 MTU everything is
>> fine, slight but manageable perf hit.
>>
>> But if I flip the MTU to 9k, run some traffic and then go back to 1.5k 
>> - 70%+ of CPU cycles are spent in alloc_iova (and children).
>>
>> Does this ring any bells?

