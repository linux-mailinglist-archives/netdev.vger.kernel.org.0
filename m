Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8743D2D3516
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgLHVR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:17:58 -0500
Received: from mail-eopbgr00136.outbound.protection.outlook.com ([40.107.0.136]:60933
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726114AbgLHVR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 16:17:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUSfiFygusRz5DQnV8vv0v3DruZfNes5ck74jjTRDDMpYvytCV7yw/awGS3mkF12gdre6jf8ouPL7i8G8ICr553Q8uwTH21Ni3nhIHmCJCOoQzVBxJpRprjUlkGcf2uXKUrMTvk8kMnq6aNpvhenBiq1JdgfLTOxzMshqsU4QEGBNBg4oLnad6DJPHAnnpgGVY/JmKQKanavlURxDvHUDc3hcdDEOYBh8X7O+R1HBc/Vf8V3cyLR6tF072Lazm0uRuesNXfTN4BWnnEGF+kY3HLESdWot9GaorOrqiRwskSGVtATooqegkYgF07fihWTvZFoPP3gj20eLbQ+WvDCOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YhteRWbhQf+Ck11mdFFCeWKIYhrmzYxCnjM0NG1MSg=;
 b=Q7mvlbj2mu/+mMiD57nnPtkGskJH4sl9QhMWRy3lQ+gTAAqxZsQUOLAkk22mJiv6wVpK/Vf/Zh41e1hUz91Qb2BoQmDyywbzC+NUzrknNAzjfgfFMqsICbMt3strfVQkT5gM6A/Ozqt1ggaU/05qYAvroduSNo1EtIeOTtsh4J8eglR/dONWHS+hPD6cGIOU/NDzuoS539y8IL6+pGigP5lUC82C+C25QQqoYOlanedqxKyglyGpnrlp7FCKITSNGDZ10fzlakGG7h8fMJwx2i8Ul+InTmcdXlvkc7JHd/wM8b04Outwh02PJBxYkneFbHn3IG8tyAWi+AQsfGmp4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YhteRWbhQf+Ck11mdFFCeWKIYhrmzYxCnjM0NG1MSg=;
 b=D/HzcHnB39isrRw9CewcOUbemLZ5YBZNMlVlfEgqy3XBMumy6DfMXLhwN8v7JQ8yAwFCVlBUFj+70CY3RmVJrerSA9+Z3C1Icq61NZV5yGwwIirG+i5i/wgWXFHMNiE9pnjcCS9oEZkqn9GvtKppaHWlwo9zG99YLeE2WRlipkQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2961.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 21:17:08 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 21:17:08 +0000
Subject: Re: [PATCH 14/20] ethernet: ucc_geth: don't statically allocate eight
 ucc_geth_info
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Zhao Qiang <qiang.zhao@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-15-rasmus.villemoes@prevas.dk>
 <8259bec3-9343-82e3-a420-a8170cf922a4@csgroup.eu>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <38c7f603-9170-f5a3-6a47-d6959f3c3137@prevas.dk>
Date:   Tue, 8 Dec 2020 22:17:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <8259bec3-9343-82e3-a420-a8170cf922a4@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Tue, 8 Dec 2020 21:17:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8442e91-bc3d-409e-d5e5-08d89bbe9ee2
X-MS-TrafficTypeDiagnostic: AM0PR10MB2961:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2961193238A6D256121FFB2393CD0@AM0PR10MB2961.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkrHXohqjkgR/hEyLRnUMrdMTviQqFW+H64i89BMRKaHR/DcTMIBPMKw2x8Pk3lKhiqDdxvHcilKLbb4rcVOMMgLS57+aje08a0MwbKO3UmEKwjhKV0P2ZlaN8MeOXCEkOnSiiqNLD6szF7rZOsqI9KEelye2iLpZA4a57wV01oJXT/YT3MIUIzB8kyGwoQfuaW7XwvlpOtoWFJFWUZ9PQkKRrZqztIeqjPnSz2RslHK+3S0ilpE+p2Vcjn5UqCktzeSJpFJoyKZjJWQYTjFOysQGTYevGjlplS8yQrbeDyM7tk2JqoG+V6RskBUdg208D1yReYSOI3Y5mSjx8PQuJDzwVb06qf7m4EWfFLEGXEjgsZj0A+KvPfYQHcy1c65r0L0VX/y6ExJjGlsOIVd0xavyRnF4QXOvclXJVWQxK8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(16576012)(31686004)(54906003)(110136005)(16526019)(186003)(956004)(2616005)(8976002)(6486002)(5660300002)(4744005)(86362001)(8936002)(31696002)(66556008)(66476007)(4326008)(36756003)(26005)(44832011)(2906002)(66946007)(52116002)(8676002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGdjVXhzSUh5YVdjNndzRFNrUllSQUZFS0xBVk01SGxINHRFUERqeDd0dFdu?=
 =?utf-8?B?QU9RNWJCQjVrbm9ycmN3bDgrUlIzWHFldU9tbXlWRk9RNUVIVFZzaWJmVVdT?=
 =?utf-8?B?TmIrbUkwTnU4eEFUa2RGem5TNlc0OXVnbmNBcmhINW9TenFnZEhrS3Q0UWZK?=
 =?utf-8?B?VzU2TnR5bkgva1VBMVpXbXJndXlUV1c1aVFMMG00Y3A2RUVTMnhtamtwZkNZ?=
 =?utf-8?B?bGNNRHpWcHZKdjNWNFBhaklEdThYNlJ2MFd6RVEwSzdBZ2tvWWFyZ2Vka2Z1?=
 =?utf-8?B?T2hRUmk4ZzBpbmtLeDZaYlVGVW43WEYvekFqeUVCZzhoYzFuakhQcml5SGtP?=
 =?utf-8?B?ZEpNaVZ6YUVyWlh1WXlWY29UQUFidU9rR2h2dk1aS2h5YlA4c1JHYklLOXJh?=
 =?utf-8?B?T2xHUHBheGIxQmVzTWF4cldhSEVtd1hWZ1U0T3lCR3JzYlVHNjVRejN3Q09O?=
 =?utf-8?B?REhMR3lnaXFQMkMySStjS25RREdNSU94bWFzRnhNcm9QbWxpRnhLd29oVFlt?=
 =?utf-8?B?bzV6OWdSdlliaWFwMy9HNUZJb3A0UWVCbXRKazIxTEI3eVp3dTA1QTlqNk9F?=
 =?utf-8?B?NDBnQ0FqWUdtMEsyQTlGNXlUa1pzNnNWYURiVE5tZkNGeFE4WlVhV3MrblEz?=
 =?utf-8?B?eDRRRnNGTU1pcFZRRWtMbEdtSHFFOWltbk9YNWhSWFUyMkNVTllvWUl6cENI?=
 =?utf-8?B?aERKQUJVUi9BWGt3U3ZHZUluNWdlZlNvTHNGeG90RWRpOXRqZnhyM2lmY3NU?=
 =?utf-8?B?K015Z3VMdklqYTdBR2ZQWTZpMk5DWUFaNVFIY1A0cHdTVTJad3pldWtOK2h3?=
 =?utf-8?B?K3E0L3dWbHFPYW42ckUxUUMrUUxGSnJWenUxcjdGY2wyK1d1c3N0NXJMYlp3?=
 =?utf-8?B?VEJ5bzV4Q01tRUxNMk1kY1JXMVMvY1JwUG0xVm41Zyt4TTlvNTlPNm1PM29x?=
 =?utf-8?B?N3pWK0k2SUU5NHlRQU1ON1Zpd09md2l2TXZqekJsUThNRmUzRXdNZlVDT1hW?=
 =?utf-8?B?emJqT1BoOG9BbWxTY1U1Qm1YN1ZwTXg5OGhwa2RFRzRvRUI2eiszbTM2d2pI?=
 =?utf-8?B?NnhyblpIVzMvK2xya1g1TXlGcXpsaTFXYUVuTVlqb0FMbkFiODRoL2JEK3Ax?=
 =?utf-8?B?RzNOMnM0MkRWaDNsV0xnR015QUFqTWo3UkY0UnFXclMzdUdHS1RlclBqRWFv?=
 =?utf-8?B?aWlHUzljcWcrRGZGYWF3ZWNFSVB5MmVyTmRTaXY5anQ0TzhrQlcxS2RwcGpv?=
 =?utf-8?B?R0JtREUzTlNPSFA2YzNzOXJPVkJIN3B2VDlybmkyZm5EemdPcWhiWlQzSXp4?=
 =?utf-8?Q?nR5H3a2n1n16vQWathhw/26mQChPY/x5sW?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 21:17:08.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: a8442e91-bc3d-409e-d5e5-08d89bbe9ee2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5XOwbh7pgD8o1TzPRoR341GP+Nf1gap2lXjtz1UTI8BjqKiu2Or27lFbjfo9dzQFG04TE1re0cXykRssFRhKPOQUrh1Krw9wuFdvxd06mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 16.13, Christophe Leroy wrote:
> 
> 
> Le 05/12/2020 à 20:17, Rasmus Villemoes a écrit :

>> @@ -3714,25 +3712,23 @@ static int ucc_geth_probe(struct
>> platform_device* ofdev)
>>       if ((ucc_num < 0) || (ucc_num > 7))
>>           return -ENODEV;
>>   -    ug_info = &ugeth_info[ucc_num];
>> -    if (ug_info == NULL) {
>> -        if (netif_msg_probe(&debug))
>> -            pr_err("[%d] Missing additional data!\n", ucc_num);
>> -        return -ENODEV;
>> -    }
>> +    ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
> 
> Could we use dev_kmalloc() instead, to avoid the freeing on the wait out
> and the err_free_info: path ?

Perhaps, but I don't think mixing ordinary kmalloc() with devm_ versions
in the same driver is a good idea - IIRC there are at least some rules
to obey if one does that, but I don't remember and can't find what they are.

Rasmus
