Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27B36B7D82
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCMQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCMQ3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:29:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384D5DEE9;
        Mon, 13 Mar 2023 09:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNLaBwFGfwnGQrw0SscNTh99Aw6iaJKwQKa2TOKHyXxEPXeKERbCHGE+iagok691W5sd9ZdBmXrsZ1lOdI/B8FoOvMuWuNXTkMEqSdg+Z8UqxQh/5QCxYdzO9iKPjX0QuzzDwxYnKFHxXuZh8W2FwF/ElLFGKmR96G5F8d1ttdU03Z/wG5P0RZxxrvRag2unat9q7IzxU1qag3Ir2q0/jSvCttAsPJgt9SZ8BKNJ+6ohPaK6oguMx7nwCTr7h+krmclmZ6JTN+qn5NEBU9J2HNRg6mUjAMxQfWK98LCmLgCFwUBEmxVbk8vaXNS53DUsF12KMWi2ScNkll++qZFYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5kYKDmuuahIXp6lGSjfCK5Psvsd2mXKtJ87N5MonSo=;
 b=HmuIz2ma4gWj5bIRwaVrSsFydfq37a0t97Ckyga6ez0HoiIRWo+3/semQjoKKCiTFL8K0V/Ab6mrCY53MQsI1V/k4bzEEBBTRQpI+SQXoxwISkbe2TgWSbx5PjTRkwwdZIk+WXAybYE7Q79RnBHDG3Yi9eQlGgUjVWwWuWakGTIiuCm/OB5gsu1Np+PdE4qmL07ijBKzsXfdjzk/a5qbYOhkT2biUgELs3aNE6aYi//gYPU6SxrmhKIY2cdW+oZwd5+9zCE1gxcbyqF0GwUR0Iw/TVaaBKsHVBDTlERNC5NA7DC5I8kggBGmtTTYn89cBXRvRitwsLDhRAD2WH/AEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5kYKDmuuahIXp6lGSjfCK5Psvsd2mXKtJ87N5MonSo=;
 b=KVis4/9YL1k3bnp1VJHBx6o9NSFsL0ExgxI7YsqmguAL3ySWq1e8MNUJk5QAAWMarWnILe4b5BIGo2r0DzIm84sFTyF0BlumeqjnBQTeJDthVlx2L7pDbmlwSaPIDeHdLa/fE0zb+9FpOVf4wme1Gdv2szlO3HA1fLe+f4XtaGA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4147.namprd13.prod.outlook.com (2603:10b6:5:2a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:28:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:28:28 +0000
Date:   Mon, 13 Mar 2023 17:28:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: trf7970a: mark OF related data as maybe unused
Message-ID: <ZA9PJqBX4hiWnvJQ@corigine.com>
References: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AM0PR02CA0127.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: e8da34b4-ac2a-4c09-5708-08db23dff9dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyTgHvxT8ZdaK3t15r15ABPB7MDNq6iaJDQ5xBkWl2SwR4YMVCg0HiJYDCsqGM87dyKGL1CHExTOB5eFG3G5hISW3W6xFxNJLkjmk/BZRPuAgRH5uNnu4QUOdi8WGmTIKYY6Yqhq+ip4AEfv+FqFbQjvkZS9MMnVmNdYxeQPgDO1OJTRjI/l1fBNQlMnt95Q0RUZdBkt5wCsWPfz6WHYrahpBcD1OSl2RsbDfhKcMMIfhCgDDf5SZ/D22TnBoVJ77xo7FOnosg9zlFCkNs9PTNnAeB6s1O2C0I2mcjos6PYLrX3VLaIuCYc3j8SD2D6KZ3kXamasYD+uyYGBQrWkZ4zROd/Bb+Fl8ImWja87ry+f9Kz8X57l1fW3A5wzr7iCHu3jaciEjYR1kHNG/HTh3+e/Jv1FPb81xqj0JuR66aIiebGnBvVar3/pzZbZdejX5Kjtp/OVnLQ0yzH4192zub3EOefTAbwpBvVWF42z/IUfzSLWS3q0XE8k20eKh57XMN3eyAOgpYN63GIG4gvfPocNVgoDR6dTQN6PqiiWeZWU2RRK/nIIH9zL5xvlS8uevjRda1d0QU0LdVhcC++P/tvAQ7cPouyPZNI+kY85wSXd667JzORxI7U0L9fImrMsQla2GU263aLHt7CvR26u0GBy5dJ2DRgCoWmxqrwppdWL5Gf3noiqtcqd9S5fD5Y2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(346002)(396003)(376002)(136003)(451199018)(41300700001)(478600001)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(6916009)(36756003)(86362001)(38100700002)(6512007)(6486002)(6666004)(186003)(44832011)(5660300002)(4744005)(2906002)(316002)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVZVOFI5WjZHd0hqLzh6MlFjcVNITDUvT2dvbktWMUpvUVArWFZSOVJZTXFq?=
 =?utf-8?B?VjZBTkIwRHR5dDg5M2NpYzEvODBNc0ZtaWtlSmxTaU5HaGE1ME1NMC9OTU1X?=
 =?utf-8?B?dUNoMEdDNFdoZ2NPSWFsRlJKYzVJTUU1cHQ5NG50Vmw3YThpOFl5c1BoTDFk?=
 =?utf-8?B?MFdxZHpsbjg0ejdEMS9mM0RxMnV6S0tPYmtiUFQ4ZHNrNE9XRThEd3I5bXVQ?=
 =?utf-8?B?S3JCS0UyUEpsM2hqbCtmOHErZDRGVE5EVmVhNUtCMy9oandQRHo2QjBXNkZZ?=
 =?utf-8?B?RzdZTWxidS8vazF5Q2l5WEtzQ0dYZTBDWVRSUkNsN2d1WHpBTmcyd3ZNYTFl?=
 =?utf-8?B?Q2w1ZnpDNUwwaHIwclF2VW5zRkhZVllIcGhHakZzUnNqOVl4QUNVNUJmcG1B?=
 =?utf-8?B?NGpKT1RVOVBmUFYvR2phY0ZXOGMrdmFPcDMyVkJsKzh0WmREbmVSVXhKNzZm?=
 =?utf-8?B?VmhkaWI3cWNyM3B4QW1veURKSmlRaC9IZkpQWTl4UUNENHBXbGtYQkc5Q2F3?=
 =?utf-8?B?OFFqb3k2UXZ5Y1I3akpEdDVxZVB3RWcvRnB4Sng5NSt4Z1U3MlJoVklUZ2t0?=
 =?utf-8?B?eXdhVVpvVklIeXdWMmF1Tmc1U2FjSFI3UER6WHNOb2tnbnprc090Y1ZEcmhT?=
 =?utf-8?B?dlJSUWJqb3BJMCtxdEdsYTkrTFNQaVFBNDJBTWpNYTQ2UVpVK1Vxdy9rYnhu?=
 =?utf-8?B?aXN6b2VGelpIcnlpMldNZE0zb0tvckNVMkIyZ3EwTnBMemQ4cTA3bmEzUWpm?=
 =?utf-8?B?czRyKzZUMWtNaDl3T2tFZzRncVJMWUZpOGZVLzRHeVVhTEVLZmZhYWU2Q0RO?=
 =?utf-8?B?Mnpub0lBNHZieGc5cWhmaUQrbFp6U0Y3Vk8vV0sreHNlMmhhUzVtQk5OT3p3?=
 =?utf-8?B?Mklpb1c3ZERnekJIY0FCZDl2V3BTcC9yeWU4YTdFb2dMUkZXbEdGYWdvcDVu?=
 =?utf-8?B?N2g2WUlRWmRCcU9CZFY2Nm5IdHdwd3I4V2srWWMvSUNZRWNjS21WMFRXV01H?=
 =?utf-8?B?dk4wakg0T2lDQyt2aFFrb05BMWc3UDk5V28rd1hEVUIzQ0luUTVTcVpoWE1L?=
 =?utf-8?B?N3lDNjhTeDRGanZ2MkJKUHZjNUl1NmxwaTgrQ1V1eUM4dGFkU0tObndDYlZX?=
 =?utf-8?B?Qld3L3k5Y0VvTStGSEc2a201TU93VEhVaE50T2VyTHc5UUVodmtibkV0cGJl?=
 =?utf-8?B?RE5sUWVDOWVvSUxra3BPZXBuRTIwTGthcldRclFtNmJzc0cxYXpTeHMwakVT?=
 =?utf-8?B?b2dBZWVXQTJBMUxWaVIwbWl2OHZqUERqd29KaTZqZm9lOTFqeE02T2Z4Y3Vs?=
 =?utf-8?B?bkVrQlpENks3Zy9EVC9rRnlaT3FPUDFpc09VemFoNU55cUdJYUd2TndFaDdR?=
 =?utf-8?B?b2JDNHpFMTZzOGRGYjF4UjgxV2tzUzN2aU04TUpzVEZqUnIxRWoyaUVzUStK?=
 =?utf-8?B?TDF2QmtkZVhuOHdHTDZqbzl0bVZJTE1oS2NlSlZIZzZaelBNQ2p5ZWdWV2U4?=
 =?utf-8?B?WERSREt3Vk5qcGljZjdBeDBteUYycFB2SVJzOFJxY2JhbGlRZ2V0b0wzZUls?=
 =?utf-8?B?ajJHamVuM2M1RHg2UEhlMkduaE5hSnJYc3Z6R1Z0YXRqL0xMd2RrejA1R294?=
 =?utf-8?B?UG9Oajh6SzlpWVl3SmlsUGFQdjl5Ynp6c1QyeGZjeHE5cUpiQm8rTmNmWXQ2?=
 =?utf-8?B?cFdyQVRzdWx1YXIzZDl5NkxWSWFwaVNZSDYvbmpaM1FBK0ZNL0lWL2xDdDJT?=
 =?utf-8?B?dXVseDBrb09Iem9oYzZKNmMwbDdJUS9jNlFpRXFtdytjZEg5b2xXZnNubmtx?=
 =?utf-8?B?Z2U0WDg2UnpvVHQvN1lhYUhkZG5NTTdJWnhtUjJpK1AyK285elNPWlRNSndy?=
 =?utf-8?B?cGViS1NUNG44SFU3WEoraFdzNSt0THp3NU9LODlhTC9oK2QxYjZweU1wT0xI?=
 =?utf-8?B?b0pPNXExTUdrdmxwMEpqRnV6QTJjbGlybzhRenFTVG5YamxwM1oxaXhhVG9H?=
 =?utf-8?B?QTRmSFZtajBlN1Q0dXR1aGdpUjV3ZDhkS3RjTzc4aEU2bTJiTEY5RlZCY1N5?=
 =?utf-8?B?M09XQUFua1JhZWEycS96ZkYyMUNibXplTEw1VDlaYWxMNTArU3B2emM2Q3JX?=
 =?utf-8?B?T2czZlRWRkJsbHN1N2p4Qy9sQlI0bC9SWUh5R3E1Vmw0WkZ0NmNiZk53NzR4?=
 =?utf-8?B?NldqNkg5N0t2NGpUQU5ReDJpZWlyRng3S0Y3emN0NXl0VmxpaWZuZkhhZ2dU?=
 =?utf-8?B?NDRDNHdZTEd0c3BaUVViYm5iM3pBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8da34b4-ac2a-4c09-5708-08db23dff9dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:28:28.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7WAr7Y8+DHs1EH0CsIyCB8FyROG2eORm8kVkVK6MVFDIu1Mv8XBFKqaaF55GCdsIm5c7a9YiXQYW4esPW5GuaP8q+O3jMEa/jq+Q1m08q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4147
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 12:13:28PM +0100, Krzysztof Kozlowski wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/nfc/trf7970a.c:2232:34: error: ‘trf7970a_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

