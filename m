Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF246B7D8F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjCMQaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjCMQ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:29:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BBB5C107;
        Mon, 13 Mar 2023 09:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/vh+uhXsdf1xV4Ca2l5NtU/0XjfctsRJR51vfOhcgaGUaplTLc4Ej89AVBWWM9l8m1ur+GbnMHTG51Nm0LIT5/hn5rdZV1ypft2ZA4POwCoITv4A+7VpRFwCeqZyhd3mzMXWZINtP58tb19+eAjUFZv/X3co0LT+u7mr1vTQxCGPdSINVT1GDS3SymEOiOtrjxJv8iKY49Mt4pp+28p0B1Km/Qb5x4WwJh6KnZMHSYqxOWk3i23X+jtmrnTSt6hmulyiTx3hufKkjR7ec2IBal7bF2lonLIk8c7m9b+Sv6y0IwkL0mPaLkd9ofUVqZmaS9TcXuPyp1byoqOEV7hAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwTatwS4Z7C0EjmBH88xmJi7GfLQ64+rn3hWJg6ftcU=;
 b=UqcaDs/GSMT/jkGCv3vSvL3ldtFgy5v7ntQYVKL9Msnzq12iBgQm815diAk+xAu8l3MxVdeQwXthMdJMvQWqx/+wMniUVrC+NNzidiWP9QmJHfyGOHvrjroTPet62W+zFtwrRNf863qHg/mI6iHbAQPIc4D19t3zarPz6ey7YlfMnwGdgpdoRIioqrWjbHxBIB+AUeTdF5jJJt8kFF9n5ZErARmlGXIVWsI8ebUDOI7HhP1/3PMWL99k9x5EF2gja0wgCaTr+TKzpvDb01/yrbFO6FTdE/YyCedkbZI6nXKkasc1744XIYaZRt/yx85uF2lvVbhJqV6hDz7Xv2Y0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwTatwS4Z7C0EjmBH88xmJi7GfLQ64+rn3hWJg6ftcU=;
 b=hzjxkIRgwzVZZBisHTSUuhSFpHVSV56tJq986WFZzEWKzTqEy66QTXClfVGZ9q8SlZn09ER2dDo4zbHvPn8k88CZ5dg3CQs2ti3HaBKvbjPZWWzPJDq/rjj1xmx1R1kSXiR9+zbAE7qZoUvUGVpVJrk0u9qJJBOvnDOYRF8WHqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4147.namprd13.prod.outlook.com (2603:10b6:5:2a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:28:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:28:49 +0000
Date:   Mon, 13 Mar 2023 17:28:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ines: drop of_match_ptr for ID table
Message-ID: <ZA9PO82L1Adwtd7A@corigine.com>
References: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AS4P190CA0064.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a12820-794e-4ef5-211f-08db23e006a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5mHub3E7zRt567U4gKDuGo1osMW1VHavehyR0XtMnFlfAvr15mvfQyDZ3SIagKKO3Ifr7l49gA+1oMaA6PrYGZaMQ6vo75yondX4RTPZ6QZVfYhS+iCi6QkOWKGAFYVlCPLHyLPIE15QA43YqT/qdR8NkhosgEaUbd1fub3tJ/lqOwyvJ/mmlk7Gac9gHJV57oYCCd/Ou4baJid5Uk/dJxtVUImEmPT5DpzyHLjsDpJTc6UdyUtXRiTvWT71w0+g7CRbK4p85i5W/JpdgDQlpG9o7z310S4N2NWGHTif6zNH3NKGddrv88CzKBGPb6wt8wFAdTnnKNrl1KRaNfX+S2Kzm/7blQeUMypEFw5qVTbVsLx+cGr+XYekHAVDGtblj5hMBflWuJH8L4g5wr551KfC27L8G8QjtkCdyJhBzciXq4MXneJjA9o3pvvrGYoabAgAHug4SfrlE7NLCTeeINKEwUvKZWqO2Yq/RcuHHN5ouX0tYyQPDuvxsFTrMHgTzZbMN4RV3N78oWWJbVdbaW/VVbZQ/UOWCrNC0GHqYrvg1syfmVj6ENIlpil6lGepDAG/sM8cpLrmFDyS9cczeiBPRUXLJ9EBPBaVzf/PUlJgYM3MgMOBdgia0tu3Hkjh7vmtH0NRboC87F2cBzkLk+SuH0FgisWOEtFKtYRMsapbn36DRkYc7qDUZu6Qg51
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(346002)(396003)(376002)(136003)(451199018)(41300700001)(478600001)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(6916009)(36756003)(86362001)(38100700002)(6512007)(6486002)(6666004)(186003)(44832011)(5660300002)(4744005)(2906002)(316002)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1o4MTdnNHZzTDNUK2YzKyt4NUZSWk1xaXR1Wi9Pb1kzYTlLbDVrdEZBS2sz?=
 =?utf-8?B?cHpRaDlvamZKVDhGMnRaalN2NDg2bXRrZDhGL1d1d2p1b2p1S3NlYWFCMXNQ?=
 =?utf-8?B?T09RZzQ5TGdPbGphKzZqMnpRTUZ4ZDZOWEh5c0o3OGU0MHRhY2xDcmNhZWZr?=
 =?utf-8?B?RHcvRjJCUGFPLzVGa1ZsNVltUXl0M0o2R2I4MUZocWE5Uno1M2YrUXVRUGo2?=
 =?utf-8?B?YW5Zbm40MWxvVzVua1dINzJmaFpHSlBKbENxd0dMWTdpb1Bkb2RJNVpZdm5T?=
 =?utf-8?B?RXZCVVJOajZyTnBNVHNOZzg0YTNDSjB6RnA4NzNWeEJBQ2d4RURCbmNkZnk0?=
 =?utf-8?B?emlJbHdaUjFScndJaHVCbG0rbFoydVRzNm12QkVyMUV3ZnN0UDR5bGFLRWlF?=
 =?utf-8?B?Ykx2SkVHUWpHczlvMThGMndkbzRvMWl3K0FjWkxIc25jU1Ercy9vV3p5VFcv?=
 =?utf-8?B?K01zWWxkT3kwTWJCVWJzQUc1QU1OeHNWTUdEQisrYXpVczEwT1V3Z2xSSzdE?=
 =?utf-8?B?TkRuTVFmaUQ1ZExiVTArQnlQSFZjZ1VmTnpnSXpvY3FjdmxHTjd1blp4UWV4?=
 =?utf-8?B?NnFCd3pPeGZkVXBQV0dGdjFXbm9Ma1lRZU5ZUmNLZUlaMlkydFdQM0ptWlBJ?=
 =?utf-8?B?dmRtVFNZZk9uTTN4UVhSYkV3L1BpZks2YVkvcXplM3ZhaDdyTWZXZEFoUjA5?=
 =?utf-8?B?bzdjbTZwS3ZkMWpYNFJibzhzOXhtWmpTRXAzYnQwQ1VtSDJleHV5c0FvMjE2?=
 =?utf-8?B?OUFJZkVBcjZHUXlrV3FoZ2ZBYWx2Nkw5MGpmMnExZmN6bUJ6by9ZUG9mSlMx?=
 =?utf-8?B?UDJWQ0w0TnJXbVVjYkFQRmVjbjZ4MFgvSDlIUGhJYm1lWlZ6dDEvUFUzM09p?=
 =?utf-8?B?NHF2aU5abDRobHNqM2t4aEdoOGJlUDNrWjA4N21sQ3M4cEVRRWRaSTVxNGFJ?=
 =?utf-8?B?MFFOQm1GenFqa2tTbWJESXhvRVpTWTdpYlZia3NIWEViMjZuSzhPQmpyaFNQ?=
 =?utf-8?B?bnIyMXV4Q1JkRkdIN2w2ckNTaEloWUoyWElrYW5sWmNvZDY0Z1Z0OUVVT2JQ?=
 =?utf-8?B?NDlkTkY1cXdkRUVlNHp6VFpSaGxvMUYvbW11RDd3TlJDOW1sakRHVXpwQnJl?=
 =?utf-8?B?ZnBIYkEwcGZiYzZZZ2E0TllCc0pjYTJmMkVRYUFaSWVHTVhUY29tYkszdFJI?=
 =?utf-8?B?V0oxR0ZPR2ozRGpZczh5Sy9OQTZ2L0xyV2pESG44VGZ3K1ViNm1FZUN5TUs2?=
 =?utf-8?B?WldHck5QdWdyc2NUbW5JR3ZBQUljYzg4VlNnbW5OSzltUUU5REU4MlRyYmRn?=
 =?utf-8?B?ejV3OURNUC90cXRIOHlOZE9TQjRYcU4rSjZDMlVCbFpTVmhCNG56QUxhdUJq?=
 =?utf-8?B?NTR3SVNFUjNGeVl5THJGTzBpWE5zb3cwaVZ6MGN5ZFdLUER6R0xVaVdJekh4?=
 =?utf-8?B?WEZNQTNlL2NkelNhYVM4c21EMG9zSlh3TCs2a0RITlZXMHB3QTZGc3VQYm9I?=
 =?utf-8?B?MnBVUk9YdU94dEZxSzRHb0kwT0dxK0hFSWJOZ09PRzRzNitpSHhQNGlINkZ6?=
 =?utf-8?B?dmNMWjZlY2NBazY1VFM2WUFWdnh6NmdXMDNNUXBSNm5xOFdkQ2EwYmJVU0VI?=
 =?utf-8?B?M2c3Vm1VS0dkaHF4V1BFa1lqUzV3cDJsTURRU0V6U1lYMHcvSkVqRTBjSUpo?=
 =?utf-8?B?aFM3WFROMHJSbHlmcVV5Y2F5Q3crUWJVMEVFZFhXK2VKTmw4cmVwUXV4Ny9V?=
 =?utf-8?B?TVZWMnZ2ZkxERUJCTFFUa0pvaDNUUFZCMXF6MUdxcUYvWkpSVWUwcmR1cG5x?=
 =?utf-8?B?TFArWkdBSUVXaExEN3phNmVtWkFnaWdMRGViSDdrUlRDempNQUxHWnBkOTN0?=
 =?utf-8?B?TTFwQnZYSmRBeWlpbjFVK2dORy85b2VTYTZubzFyTi9lajR0RzNjTVJ1QUpk?=
 =?utf-8?B?NDdVekpsd1RXQzI3TkVlck5FSzBIbTR2Qi9BaTJwdHZSQ1BKcjJsUms1Y2R3?=
 =?utf-8?B?VjdKL2NXblczNlRvT1ZMbi8xUm9wR2J2M1pRR091em02Y2pGeDRxalpaMEF2?=
 =?utf-8?B?cUV6cjNiYkZXb2l5Zk8zOHRhNkZZTTNKSVlveXNubXJJa3g0VStmWjlYK3Fv?=
 =?utf-8?B?VVgySHJ6VE1kQzA5bnpWTVBEWFFwSXFMVTU1YnZ3bHR5MGhYbitKT0ZSb0J5?=
 =?utf-8?B?WUVyRFJhd2piU2wvZlJtUWhCalhxRWZWR3ZwMlF6dXA5RXlMQlJtRnFYdWkr?=
 =?utf-8?B?cXlKNExFcXVGcWFoTFJYcTFWY0JRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a12820-794e-4ef5-211f-08db23e006a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:28:49.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxfQmq+5DIKW/58u9OwhjFCQVn/JKg7jQ0HDyLRNl+WrDNrtTTSQQIMWnq8lGSk6bf+XX9FbsHhkGMBtg6OnAyZ7h04uwvXQrhKag0rdDn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4147
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 02:26:37PM +0100, Krzysztof Kozlowski wrote:
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it might not be relevant here).  This
> also fixes !CONFIG_OF error:
> 
>   drivers/ptp/ptp_ines.c:783:34: error: ‘ines_ptp_ctrl_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

