Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3433564279
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiGBTXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGBTXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:23:48 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5554D25D2;
        Sat,  2 Jul 2022 12:23:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoZJvKAnsWNOItxIU7syoi9u9S/gIS8vJwbtHq3nZSzcAIfJdF66i7oh5gaL5EmnpHA49nKrNTVuDNpGPWvb1gnOA0lXODWnwrharBMJWU4Y40Gbts4X9m9sUSutHOtPc3hm8gHImg718sFgZJnaW7R0TBe+++4OySrZglpuFWmhhF2I+XKAelOrJHCB7zvyLR3XTCwuf5vygAINyC+qI2chV6gD2OMfhcr5pKLYmWiYC436+qqXa2XmwAZDnBNGPoqKF0+bWJGDbe9EmjYBK3Qruw4OBB3JJu2PQ5MMhbLNvHxTjpXCKE2gyZ+sybBF1s17aFe/lyToHe06upLOUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbZ5Vz6E50aHZOJu3HPby3p0H7q5QVxIptLrGyHEVCU=;
 b=Q/RbnvwEHFHasBQYSTIpVvVX1QcWdDmft3WmqxkpndSCseH8huOlsg/4FLP5756fGrK0S7nWnRJKhwiqw78hksY1NY061gredepowQA9TWD+Des5GwVfaBnMsqp2sAvkRg43E+4K5TPcVr059y6oPiB4IHPzQSWaAuNuNcVypqAeGROzcwiNGSFfKpuvao//mmhc+kympaRPc+OwyKWLbEf91G+t1lc+JAcZbMP9riNloSY9Mle3yWGeUu9EWj3iXaDeRp01fQ1OvE7fbCUZ9wuWhRZMmmgbMqVvi0UoiPnLT6NOkk1qSBSQA+GHKKl9MGi7nJuxBE11cr46Jv4xWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=randorisec.fr; dmarc=pass action=none
 header.from=randorisec.fr; dkim=pass header.d=randorisec.fr; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=randorisec.fr;
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:25::15)
 by PR0P264MB1788.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:16c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 19:23:44 +0000
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138]) by MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138%3]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 19:23:44 +0000
Message-ID: <247d7cde-5d07-4c63-970b-bfce8742c4d8@randorisec.fr>
Date:   Sat, 2 Jul 2022 21:23:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
 <YsCVB2Jh8d6mM6f7@salvia> <YsCYfBSobCXxy7Ok@salvia>
Cc:     netdev@vger.kernel.org, security@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, davy <davy@randorisec.fr>, amongodin@randorisec.fr,
        kuba@kernel.org, Linus Torvalds <torvalds@linuxfoundation.org>,
        netfilter-devel@vger.kernel.org
From:   Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Subject: Re: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap
 buffer overflow
In-Reply-To: <YsCYfBSobCXxy7Ok@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0094.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::34) To MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:25::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac71ab6b-6651-411f-5e40-08da5c606125
X-MS-TrafficTypeDiagnostic: PR0P264MB1788:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lrex10HMcarwVJWgLHjzAmqiTLn57AjRUW7JQLoq6jKDPHiF+6LQhRwog36pmbhNMFycA19wv8Q2T4HRFKs/5oxCw056XfGdyuDpe9NFVMtNFYiuxrcvEoPc842IU2PduVYdEWd+pq6yj/6eOauOxIMBf+2mTsrp02UCndnw+DVvuKe+jYmaLSZjsSZat3pzxeKQCEEi9BFQTV1oT7uxecPJA4pKRnWlMRQxWMl/NrasQVRt0uyVMhn9wv17EhYRLKei0JMAzeMjqeK93nGc2eeThO9k/zFixghMoSY9XU5bH5OTyuyHn1uEYMOvsmsahHffoSgRRm1zX/EOdqKmeQ23hVnJ5zAufP+L4ssCUaokU1VgnBq6NbkPdPRbZBR0WIt/+ngSenVy1otmMEQvG9O7mPAOL8RKVerjqUMGamyBoT3hvIhQj5tQ8hWqUZiYb9CAwANzj9K+Fa4aKrCSmkjiIK6U5V3hOOPyBMWmSbVoKY8YexeFTOkEqGTjk7KTKNBFQHApEWd1UmhXv/HPe1W5kGtT8XmsON8rG8Ks1GfFPdsF6tWWAh5FyOkXV+FwJjXmxD2DLRhpl6UZG/rCAJ0tiweIvYKBKwa/jfQAgBrTpv4wwMMB+8eGtb/TdWq1rndPOL+lwHj84MhUTeERzoRG4lfW6declFV11sxdWjKVzqmf+DHgvh3pVaENIMgt9/UqFkooAjeuQkVx1rFd84EV7z6THtAghKx64SsRvJd3rDVrNiWGX36BjJix4Bxi6kc51Vg283Ds+IeHFEqbEwqWoR1G5E6fnhFbG+jde8JsfO4r7CjOWFZ6uySmngt4fWOky4q0slfqH9p9JOT0wyvnDeG22z1XBnfDTBmNP7ErJ4oF80iAMHLPoGoqb7e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(376002)(346002)(136003)(2616005)(2906002)(86362001)(41300700001)(26005)(53546011)(6506007)(6512007)(186003)(8936002)(6486002)(966005)(31696002)(83380400001)(5660300002)(478600001)(36756003)(38100700002)(31686004)(316002)(6916009)(54906003)(66946007)(66556008)(66476007)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlBZSUhiQzloc1lObm9FdzI1WmM1aXRkNEdOZTNGNHlKTTRjRVlwdGJUTThV?=
 =?utf-8?B?TFpFWXd3SDN5TS9yT29Gell4MTlCK0JoNkZaRm1ubDk3M1orZ0ZBQWRnOVJY?=
 =?utf-8?B?RXNORWU3VWRETlBvYktkdUpaY1VkRUI3aVM1WXY2ZjA5Ym9pbXpyRnJEWGNI?=
 =?utf-8?B?clluZnh0Rm1MK1dVZXE0K0toM3crdWxUVlk0Ylh6V2poVkladXFpZXdCNDdh?=
 =?utf-8?B?ZnJLYzdiMzc1RnUzWkhZVWh5dWwyemptQ0JiZFdsOThQMTlnUTNvRUtvdWhQ?=
 =?utf-8?B?Q1ZiQnZrR1pSdjcxQkxyV2xMSEpjT0l3Y0hNeWlLVGtBYVo2bEZ1OTZnNC9v?=
 =?utf-8?B?RFhDUkRTdFJWNEl3eUhtVVZqcStaM1dKNm1XUlhPVExJeTVOUUhGYnpOMktB?=
 =?utf-8?B?WFBjRWUxcWRmR1NpbUtjbituWldtRi9rbkNabXpkSTlGcElaUysrTU5Ebkkz?=
 =?utf-8?B?K09ZVjU4dmVxMHkvNmM3cEhWMmR2Q0hNcTlxcGQ0VXhxL0JFNVNLUm1mMm9p?=
 =?utf-8?B?SFBHeUtRRGd2UUZpamhJR0ovRTM0SnMxeDU0RFBjMVF3Wks1aURwQXpKWjVT?=
 =?utf-8?B?STByL2dPVWhnZHhmMkJTL0k2ZzU2TFFkMnJUc0FaSUMzN1VPTnRIR0hmYUJq?=
 =?utf-8?B?Q3pjN3prYzM1aFZuem5MMjdGL1pqYzd4NmVoa3hyWmJnTW5iaU1YaEk5eEdq?=
 =?utf-8?B?RFJMbzVGTEcxWVo3a3EzWnZ6QVNqL2RlN3UvbEVTZElNbGQ2bGQwVnNMOXRR?=
 =?utf-8?B?RERsUnJTKzY5T0tDczBDRTNmK1ZTbldHQ2VHQzZGbEkxZmNZSTc4Q094QTFk?=
 =?utf-8?B?dnE5YXNCRHUyb2FqdVFRM1VWVlNGbGpKYzZmSHY3TDZzdGpaRnlJOFpKV0lI?=
 =?utf-8?B?dldBS1BUMlBiY0I3VWhhcU5lNSsvT09UdXo3dXo0UTZObXJxcTdDdnB5V085?=
 =?utf-8?B?Mk1oM09xUm8xbXE2MTJXL3dnZkcwTy9zTFBrejV1N3lKVVJOVm9hdDIycVZh?=
 =?utf-8?B?dUducklpelBxeVVJNlhIUGU3ZlR5MEwyNkNIUk5vT2tUM2NsM2RXWkJGSGg1?=
 =?utf-8?B?YnZRMkNYbzFGSjhiSm1PekRVUjFzamVuVmRhWDdpZHFHTHN6ZkVOTWJTOTNo?=
 =?utf-8?B?eWxVT2lhK3NlZ0dVTXRwc1pkeWtIbWRqYXZUem8rVTNpS2hzK1pPeUFVcUNF?=
 =?utf-8?B?STY1VDBBbEdjbGxZMW1hOHlMUE1rUlRkeVhQTUJ4RVRVQXBiemhRUGdZTEtj?=
 =?utf-8?B?Q09TZ0V6SEFPa0FVbTh5MTVOWG9UTVJlWU9rTHZqSXduM0IrYkx0K0Nib0tt?=
 =?utf-8?B?OTRvWS9PTkkvUjlvLzU2MEtLUFJFYWZRejR6L0Z1SzYrZ0VtakpUbEtHK0RU?=
 =?utf-8?B?TWtHdklabVVwRS9VdXk1akZ1OWM2ejZCUjc5VlJiYzlIZGtNVnplMjJRc3Vh?=
 =?utf-8?B?OTJ1ZVU5aDkvMVh4dWtSZTU1dmZvN3RYNnAzWjdVVmM4dlZnWHBLc3dzdkV3?=
 =?utf-8?B?c285NlA4eVIyWTdpSnpBUDR5VElVdm9VVURYRFRmNzRZU2J3Yk13bkJzVW1X?=
 =?utf-8?B?L2VrRElWRmtiZlc2bFdRNnB1N3BoZ2t2azdSSTZUY3JKVC9UT0xNWnlJV0xI?=
 =?utf-8?B?T0JnendFUnFRdGRXS2paN0dYRWthNU5nYkd4bkdDSmZoaUVVY2poc2cvTEdm?=
 =?utf-8?B?QS9FRGRXVnFHNm5YdTNYY1pFV1hsVFd3eS80TW92ZkJka1ZwcUE5NXMwOW9y?=
 =?utf-8?B?NkMyQ01pSU9PZzhJcGhSek5vU1l1djJTaU1NamhNVjNIR0kvUVpVd2tyNlRS?=
 =?utf-8?B?THZoSTdOejR3Wk45MVlpMVpnOStXdzhFMGtrQ0FPazU5SG4rOENJYWphNnNR?=
 =?utf-8?B?Ymt1eG9rMmtRbGIyVEh5WStBWW81cERtc2dPcExKcVhOZXI5cWtoMGdoc1NL?=
 =?utf-8?B?aTBJSUR5MHc2UXEzZ1NJRWlGRVZLWkVZNjBLSGh3cXdjV0NQeERpbzM0MElH?=
 =?utf-8?B?OWZNQWpwK0lCREdMd3Z6NmVsSllTbjV4MTRhd0czTzdIaHVDZXc3dVA5NEhW?=
 =?utf-8?B?NXVVZC9Cc0d6VGZtOUkvdWhGZlRqekFBdE9OQ2Z6a0NpcC9nVnVhZ0tOMmk0?=
 =?utf-8?B?WHdJT0UrVmF3V1hrY1hEOVZMZmsvRkJKVVhoaXU2azdtVFNNcE1kZXI2ek10?=
 =?utf-8?B?dVE9PQ==?=
X-OriginatorOrg: randorisec.fr
X-MS-Exchange-CrossTenant-Network-Message-Id: ac71ab6b-6651-411f-5e40-08da5c606125
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 19:23:44.3738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c1031ca0-4b69-4e1b-9ecb-9b3dcf99bc61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gyEFey/jFWDabsWaFZqbwL8kZJlwbiz6FFOCEuzBEGfxT66+rxBD7zWAQGms+Zo+utbWGUmsvHlGZciiTjmeNwEDdII8fKKnkEYcWj9D3p4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB1788
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/22 21:11, Pablo Neira Ayuso wrote:
> On Sat, Jul 02, 2022 at 08:57:14PM +0200, Pablo Neira Ayuso wrote:
>> On Sat, Jul 02, 2022 at 07:59:11PM +0200, Hugues ANGUELKOV wrote:
>>> From d91007a18140e02a1f12c9627058a019fe55b8e6 Mon Sep 17 00:00:00 2001
>>> From: Arthur Mongodin <amongodin@randorisec.fr>
>>> Date: Sat, 2 Jul 2022 17:11:48 +0200
>>> Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
>>>  overflow
>>>
>>> The length used for the memcpy in nft_set_elem_init may exceed the bound
>>> of the allocated object due to a weak check in nft_setelem_parse_data.
>>> As a user can add an element with a data type NFT_DATA_VERDICT to a set
>>> with a data type different of NFT_DATA_VERDICT, then the comparison on the
>>> data type of the element allows to avoid the comparaison on the data length
>>> This fix forces the length comparison in nft_setelem_parse_data by removing
>>> the check for NFT_DATA_VERDICT type.
>>
>> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702021631.796822-1-pablo@netfilter.org/
> 
> For the record, pull request is already available with pending fixes
> for net.
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-1-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-2-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702191029.238563-3-pablo@netfilter.org/

Arthur Mongodin which has found the vulnerability is currently testing the proposed fixes against his exploit.

He is also the original writer of the previously proposed fixes and should be credited as reporter.

I'm currently waiting for his various test results.
