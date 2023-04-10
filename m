Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094176DC385
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDJGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjDJGZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:25:35 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070.outbound.protection.outlook.com [40.107.96.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520F640D5;
        Sun,  9 Apr 2023 23:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvQRffiiag5io9fhhAIwsD0uKy2y7m18fv9JA5hEVcc80w0OsGYHeTqIucPWSy1szaOhNpc1oHxNNhn2e7lVlykqV2E9uQyLRSLAVLQw28X2mInKL8cKpVUvmVE81/nNguBzpoHh/l3wOYQkHIHGk9SvPvka+9gEwWLKfH8NH7Yb5xVt0HxfeBvupU22h8idkUeBu3qynBX3FITP3bNRqZN3Q38HF9wYBPH63IqtBysgzUYMASOE44CsJkIFIPFS6Gus4DbZYPdiDputgd3X/v8lwQSOp0sQZdlZ5tUyTD2tA7bhP3ouIbqJeNmYfvYfFfGJiQ7xmyds/qcIX3xQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykE0Ir4+WRcp7+JIzuRvqm5g8gkjosAzzHuESpREmuE=;
 b=U3dxal/REHlIzEjxESAHIgUEYIJQOM0iCQ+GN7XhNhSLkhxtcBV1RNfEeoou3T/K/G2fgX2iZcF3CXLppbaKFN8TpTTFVPsEiBvi9MtyP5JUiD4tbottsdthaGAL91cvOgesPJKyQkbLYcqab2OvwZDcbpeOh67PzeFYTWpPHNYo0YIXr6Z50+8dooc1r6JWWA2EF8eZk4hvUW6sRjpriaz7PmJedtRm0yLfpWxrU2yEeDwog5fPtu4E9+gcEjAbQMl71vsFJTCXF9yYKvOF903GDEXaLRVORhkeXNdV1H/+8r0M/0oy6njVU168ksC2rpvoZ1eOyllKDCV0ops48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykE0Ir4+WRcp7+JIzuRvqm5g8gkjosAzzHuESpREmuE=;
 b=Osq/VV94TerC9k/ZcJffSOvijzfetki61dmxv25Yj5Vr2su+gebKlpUiK6Y6uPbkL4lfiPxJnuvrFU+sCbMFwLU6RfFVxqlKrP+gqFRf/ws40530DFEYvK3GI/Lyo2arx+kF726n2qWtlexgvOKbRs5/YEqS5JIx8zhNqTcJ5+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 06:25:29 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e%6]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 06:25:29 +0000
Message-ID: <6eeaeb18-6d8f-d124-ce97-266ab2240b6a@amd.com>
Date:   Mon, 10 Apr 2023 11:55:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v4 10/14] sfc: implement filters for receiving
 traffic
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-11-gautam.dawar@amd.com>
 <20230407202123.654fe6e4@kernel.org>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <20230407202123.654fe6e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::21) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 795dcc43-69a0-4e3b-f836-08db398c60e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84x2y6/NYL7loiwSmK3Ys79UzRLJg4R8LBeTRXflbvvBPJo3QARI/ulwTVyYEAd8BwYQuXo5mik6Jph4ecBV68/NBfz3t2Xv0b4xmv0JKjMgoXzorUu7sug2zkXL7Oi5QSU+Xi1F41VxZG5s3a+8mekgZWDvA0CMS+Q5+Ho5eWXxI6XXlUwkwnlnWVYT7u+nGMhvDAF/xb3T4Q5dFy5wG3RZ2w9ICPtjUTiEOUBZPYqfnV09pOKOzpZKlvHHSUTorfZsvdHXRE1D7ihCRUw9T1C0XTVSJQeZN/Jcth8TKCW0nKOg18UcucdP6G0JXEQ+r9a5IQJRworpWzc13fAERKGzgCIaV1X2oJeYU8EA2NkSu0gqwwx2PbheqU61nauNXup+wrZuMHK3UFEYzPOFbVCWIZWuoCsXWN1dy0jyu41g8KGbrPtjyAJZqPOdGfMXdn+m4lNK6QGwkJx6paEpiQmkV7NkFx8crXRhi+8Rle46U39ITY83X2tB8P2qb228eC0oAMDmt4NRuVVO/QJmBgvqyJfyvBj1FZXxTbR7aHQJlY7DcKaji/crFwBjye4500D2R4Nt/H7McV/njO6MuSVhZTFZWjrzwsdVQn1JSKcQnloUPBySJq4w3k6X/lbZo+NK9FzN8K5iv4yUK23Q/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(186003)(110136005)(316002)(31696002)(6636002)(54906003)(4326008)(66476007)(66556008)(66946007)(8936002)(2616005)(8676002)(41300700001)(5660300002)(36756003)(83380400001)(7416002)(2906002)(4744005)(6666004)(6486002)(38100700002)(6512007)(31686004)(26005)(6506007)(53546011)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3VleENRZjY1akhYdk96dkNJK2EyL1AvUTI4ajViY2s1N0N1RVpNdkUvRWpy?=
 =?utf-8?B?ZjRPV2YveWxHbmIyUnU0dDlyd2MxYjAwVStyMzgyd2lVRkp6Zm9OZ1NUQ2x2?=
 =?utf-8?B?R213akl3ZE42L25Cd1hYZDZvaE1xOHpBVm5Xay9QSTY3TmhCUVEzMFF6UFdY?=
 =?utf-8?B?bEV0ZENIUWhnM2xaZnFCSnpKSU9zelhnVjNTbzd0ZHQ4cXpRVzg0T1FqZU1a?=
 =?utf-8?B?ZTZxdlQ1NjV4UHJnTmFtRzJlb1hxR0hSYW1pRTRrQ3BmbHdQcUE0UHlXblBj?=
 =?utf-8?B?NVNWcXR2UzNXWEVnY0wydXB1ejU0WXBpSVRhSWtnQXdOWUJYT1c5RUJ5UDZQ?=
 =?utf-8?B?ZGVZZzJkV1JmNDBUbk5wSE8wRVhZZHQrZ3ZBS2h4a3NVVGl5VU11aUtXcEpV?=
 =?utf-8?B?d2NHQjEwZ0YyNUxJdVZxOHlZOTFlUEtGRnJsVHFDWTZIMnJXNnR2TmhYYXNK?=
 =?utf-8?B?TjNTa1lobXNrWDNKbkNtM013M05mYmJsN1VNZ0NHcDRhL093cWhqUk8vaWNI?=
 =?utf-8?B?MFExd3p3MGV3THdyR0JRQnBUT2NWRVROekRpV09hMGd2M3B5ODFhRVFxM2Fj?=
 =?utf-8?B?aHNvODZKUGlBTXE0OWkrRTNLOStVK1dXaXdFK3NCb0RmbE9VVnhIUGxjZzZF?=
 =?utf-8?B?YW5kOVdXQzRBMGlhc3ZhMEs2LzFkc29aYjM0bUVycWxzMkVkSnZiTzBMTlJE?=
 =?utf-8?B?OWJvcmRwWXhoZDRWMUViVkkxMk1pcUxrVHZ6RHNlR3lwc1R3NnRHL1FpaTVQ?=
 =?utf-8?B?R1U2QTFCVFJ2N3p5RkxzRnM3U0FOVTdtQ0h4SU1KN1d2WmZIOTZESmt3aGNh?=
 =?utf-8?B?blAvQ1hTOFJZRUdXNkY5a29Lb3JhSVJPQ3dGRTVEQ3lCYlV0anI3dHZNaFQv?=
 =?utf-8?B?amJLUlhwQzA2ajI5M05WNWRPNHlZTnY2ZjlqZmUyV282T0VVYi9FR3RDelpD?=
 =?utf-8?B?bXp3NzdZSU1vdjdMZS9KN255UGljR01abTVDZ0ZnOGVEMTJVWC8rM3BuUGcx?=
 =?utf-8?B?a1lvdGFwS0tZYzZtclV2clo1OVA2K2w4bHhORTNkaWRuaFBjMnJuYjByY1dH?=
 =?utf-8?B?cmZxaHJ3QnRNZFZNL3lKTjZOdkpabXlUSktIQ08xYnArT1cxSTZzcVZRS3RP?=
 =?utf-8?B?MW83VjhkUE9IVDNzenpodlQvY1BvRnVadHp1NG1wa2lXb3dyT3hYMVJnd3Vn?=
 =?utf-8?B?aXozOEdkaHpjeEFSdGdRR2h0M2Q2c2ptTW50QkJiS1JNYmFNSFdrYXQ0RGUv?=
 =?utf-8?B?Tnhka2pCKzNXOWo1Y0M0anhhVEQwTmRDTXJsT0xLWUplNUFRbGZEaGRSbERm?=
 =?utf-8?B?V2QzUFZYRVJrejEwNzhzQytCUVk4UmZKVmpuOGxPMDFPUjJ4UjdDc2U2Wnll?=
 =?utf-8?B?WHV1eW55NEp4c3NtN09GVVc3bTlKK0dkNW9ZVnkyVkNRVTU1NXF2MDFmdnJ4?=
 =?utf-8?B?OTl3VzNmWTRMa213d25xSUVvS2I2YzVhT2dJa0svcnB0MjJWRU1rTm5rclZN?=
 =?utf-8?B?cThOR0xnd1AxUnl2bXZIc2lRSXNHZmttKzlJc2x6d1E3VTFxcWVDZFY2MURk?=
 =?utf-8?B?QVNha2FLVXFzYXZDeVNGeklmNUJ1ZzdYaWZZOXdUTFAzWTNYdzBoU3JuYUpY?=
 =?utf-8?B?enBTNVRjdnhrM3RYOGtBMmNER1ZZcVEyS2lSb0VFYmhNRzg2OGRkdThYeDZT?=
 =?utf-8?B?a0hCK3VXZTRRb2JsenV4Vm82S0c2RHk3TGRpM1VhZWVQdUhpUXRFSUtCVkxY?=
 =?utf-8?B?R3REWGM4M1d2eUwwMmpaZFFJS1BFb3NJMzA2UlYxdTk4MWVaSGFHK2hkQ3Vl?=
 =?utf-8?B?dzZZWExNWno2N1BJSW9OeVdyUjJVTHFYbDR0dnhNQVRYZnJqSkcvTjZKL3pV?=
 =?utf-8?B?TTFVQkxyOXV4SjNQSUlNNllIeS9QWnJ3aTQ5N2RXRlhGRmRXdWhEcXlnaDJO?=
 =?utf-8?B?UmZaLzJwY29Pc2RrM3lvWndqR3ZWOTc2Y1RMUXZQL0JMRmNaNWhhQXdnZjZw?=
 =?utf-8?B?RVRJTlkzNHJhdGFMTHRlU0xHZHcwZng5ODBTMk1yeXR3ckpoemYxUnRxVFAr?=
 =?utf-8?B?UkpXMnFJanI1ZkJpQXgvVFpnbWE2UFNkenBjUlk1MEhXYVkvRVc3Z21TdjNZ?=
 =?utf-8?Q?mZbHb2bWOZvfkgf3gvKMPQUbr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 795dcc43-69a0-4e3b-f836-08db398c60e3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 06:25:29.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6W9qP0cQzr0IORY2cqfF2cxGNUmzjzZwIIgyW+QVZwos65DWOmiraxN098xFOYr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/8/23 08:51, Jakub Kicinski wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Fri, 7 Apr 2023 13:40:11 +0530 Gautam Dawar wrote:
>> Implement unicast, broadcast and unknown multicast
>> filters for receiving different types of traffic.
> drivers/net/ethernet/sfc/ef100_vdpa.h:137: warning: Function parameter or member 'spec' not described in 'ef100_vdpa_filter'

Mistakenly mentioned data type instead of the member name. Will fix.

Thanks

