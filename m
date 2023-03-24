Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824406C7E4D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCXMxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCXMxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:53:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2099.outbound.protection.outlook.com [40.107.94.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A71AF11;
        Fri, 24 Mar 2023 05:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2CVGvHIXAVHE+DRP6mNgP6NpIrPY2U55nRW30a0bHlN2VY+oLbx3pJeLGd5sidQWg87dCdAbvMIZRbcwyE8q7nh091c+LI4nFt6YQ8fIpyuSlAqC3f04ZkjSiOZZmsgpfMar9A5N93ghXR3DYpgw9GixReud9x9JFL6oHXbhv+XT0k8GSe1v8sawo9ow6FTLAiAb6t6Wj5GQtCZ7scdRio08UIAhw5BSfAoTKXK0SOJsFoM8N87Xo2Pbx1H1Nb4TsoomfZnUFzA09uEMXhfioOEwsnceQGXgu9LC3Xws04HKI4p1Igv1Jp/Gh1bVtXtAHQMOQBxaquRw/B6W5n3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/g/XjAaJqUAlC9Wwz6XWjiIcpV5ht8e+IpClDRKoMTE=;
 b=knLGMShXrUYObmNGtClSP98gXNesADPz02Hr7nElQm3Qyg0MlxieVAoqmGlJRSvENbPOELZduaa2DM6vVeGZBV80EyK6/f/3DQ3Zjp3YjuAbQbjsojurY90LdZkfnvluAS0N+bNn16/2+YXpUCks+7URz0Sn8NuYFtDmWVD6PT8da1l3MS7HjIsXu6L5mLsh/h8MxAGI3fjalo3N0uEwpmGDDqs07jaKE0nhq4xgfrodqvareAIuh1v82oScSfWUTPETKgw9LrnDkkR8OiLVDhTLp8EJ+6CHzYZuq2uhnj7HrezIT2UHjpHzf1x8qLmKnZNpCQFRudVZOUt+LjzQnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g/XjAaJqUAlC9Wwz6XWjiIcpV5ht8e+IpClDRKoMTE=;
 b=tlmcFZSUxLzV2nocjOJ8np5JNnvHR4xLe3X8YVdemkZh89SVV/0iY21T+HxLhwRV7gFQFHxVflvHMxg+Xw6U37F9VL/K101n3jxXZhAf5IwvYuBRc2SKS/qodOnApwVSv3XHVVM1+NJ9BjTNJ+cejJsazcGytHn9gYIiYbq55vA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6231.namprd13.prod.outlook.com (2603:10b6:806:2ff::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 12:53:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 12:53:26 +0000
Date:   Fri, 24 Mar 2023 13:53:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array
 member
Message-ID: <ZB2dPw4pMl/r4z6X@corigine.com>
References: <ZBz4x+MWoI/f65o1@work>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBz4x+MWoI/f65o1@work>
X-ClientProxiedBy: AS4P195CA0022.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: 36cf1daa-7a7b-451d-771a-08db2c66c221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzhYrX/Xf1W7DbJifrN5//qwVSRHsbhs7mLND2lFRdAirjM2PSVjalvzUEL2k+p44cS4+vpicSGWJ/ZAxUn4BurPWXmsr90PTzL69owLwWgIOWzlxtU5+vDE8Ism75hIQPNKzXAVLn4FU487/MTGhx/p/6sglzPfN1b2vmybkv9mRhhxGe1UFj2FtvqoK2Lzii96+7aA97UwRbb/99wjzdjfWzrapJfyzzR9TgcQ+QsYYyooN8iSvmv3z1UuKnb55RZQgkyobCw4B+LgM9zLRGBGrUvSOYgln3hK9EDFbt3OWBLXxX7D8u4HXl1JYooXc/mdBpmMBa4a84OzAXDiGIqz8mN7032NScG05NjIZKymPsk3e82gUdSqmuC0Az9xkmgIstcMJTQVtJMuDMlWadDQnfmyBAiw178i7ST7f82eDDOZDyrQC6PhdnP7Ka/BNVPMIE83/w900pRquEiBkA1wxiikdNrtBmhv++8943OlVf58T7JvC+4J38ZIOcb6UBF+o9FI0haTMWi2QrrOyQC62UEVb6+pkgCbAFdHFtvC8kp1vc5QwEhKKh7Y1njYuebDy0SJw1EbKqytx0VoFCJv8Qsx4E4PAOV5AO0G0kNdulkBstbjv1iV3kdCztnE4X3GGtZ8Xb7d7F9OKvGKnK2XDnYFzrMJP8vp3ooBGQs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(396003)(376002)(39840400004)(451199018)(36756003)(38100700002)(4326008)(6916009)(8676002)(86362001)(41300700001)(66556008)(8936002)(66946007)(66476007)(966005)(316002)(6486002)(54906003)(478600001)(2906002)(44832011)(5660300002)(7416002)(6506007)(6512007)(186003)(2616005)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnRGUStFQlBqdFNZSzQrUHF3TW50RmVlUEVsd1EyczNFemtkNmJhR1hJL09B?=
 =?utf-8?B?dEJLdFBRVEhXeHNBekh3cDZQNHpoSmlHRnhuenVkV3BwYkNPemhyelBCSzdm?=
 =?utf-8?B?TTVNVWFHOHZMSGlaYVJWV0gvN3RJQk1NbmJzdS9EMGIyemxUbHAxOXVaaUZC?=
 =?utf-8?B?NWhHaE85UmlicjZGRUNNSDFJK0JXYzc2cWJQRS9zNWNnRVFUbjkyM25pS0lk?=
 =?utf-8?B?eFBYQ25aaFBnNUVhdVFndkl1NDZ3RmdnampBWVpOQmVkOExzMVRWWis5N0V6?=
 =?utf-8?B?VlZMNm9rSVY0UjJURHZrMldxbDlWMWgvV0tiU2M0d1krN2FnQSsyVTU4TE5s?=
 =?utf-8?B?bTZ4TGt6V3NvVm1UUFhTSXlDWUlrYWlDTkJNTnNKZjFpaXlFVGhwMk1tenBB?=
 =?utf-8?B?emM4UUNnZ08wQklyS3o2SFo5eUNXWkh0ajhiU0FpaHV3NWU0OG00L1ZSVEYr?=
 =?utf-8?B?eWVSTWlHR1VFR2FaY1plWU1QSGE2U0NHaXBMSzBBQVZjdVk4eGpLQnRYaGxH?=
 =?utf-8?B?RlJxeklZaWp2Z1k4SGR5Umx3Yk5FQW5NTU0vdk5hUkljakx5NDY3aWtCZ3dX?=
 =?utf-8?B?cXR0S0ZkMHdWQWFtTWExaHZOQXZMUXllbCtBbHd0N0Q5TlNQREc3VVBKNCsx?=
 =?utf-8?B?ZmZXbVh3eEgvSkVJTnNJZkhMYng5eHBITmRXQm9RU0xyczRFaVMxMTMyM2N2?=
 =?utf-8?B?K1VpczJnSVRMWitXcmxKd0EzUVlxLzJWOHNQcXRTTGtjKzNwcHp0NnozQ0hr?=
 =?utf-8?B?QkxZNnluVjFSazRIaDVFUWJkdUpjNVhGbkhwKzAzaC9vaFRxRUZCMmZZMTND?=
 =?utf-8?B?WTVtVWlIRmswalF4QjAveEZGWmVrQjNlS3NsdlBEK3o3UXJSZC9FQ0RuTElM?=
 =?utf-8?B?RlplR2llc0IxR0pPeU5taXM2Zlk2bmpSUi9CV1ZMMy8zR1p2OFI0NXlnVnpC?=
 =?utf-8?B?eTB5WHdxODRCL203U29zdmxUNDlyd0E0dExzM216Y0FtcVg5MWIwTURFTTN0?=
 =?utf-8?B?cTh4SjQvbUpDSmY1V2tSc2ZET0Y3RUQzTlU2R1F4UVpJL0JnNEF1dWt2Wm0v?=
 =?utf-8?B?emg3SUxndFVaVndYRnRxelFiQndiU21SclFUeXJqeTVrMkFrTzk4NkhneVRp?=
 =?utf-8?B?blNFdnZMUmowTkRVUC9SRlIrTlhaWHJaZXo3UExJbU5YT3ZDc0ZqV1dGcXdB?=
 =?utf-8?B?NFQzdHJPbWthTDlDU2ZoL0hQMGVJbkd0eHJvM2h6MGQrb0FKNmdnUmFBSS9m?=
 =?utf-8?B?TzA5MmxHYU1IWUdLUDZwSVJ0N2dobjZLVHZZb1lRNDNnTEZKMmp3ck1mWGFM?=
 =?utf-8?B?bEYxSlJHdmZTYndtSmpqRlJmeFRDQ0NNR3ZnbURRbzY3WTZUUHFJcitKTE8y?=
 =?utf-8?B?RUVqZmJkcDRyVFRzMk1iYTRiRW5kVExwWnlZbEl6ZzJROW1OQjJ0TTJ3NlFU?=
 =?utf-8?B?a0M3ZHBpcWQ3SVpMWUZETk41Z3U2MG4yN3U0K0RsY3NaOVR2eERVOXphOTlt?=
 =?utf-8?B?NXZ2aWcwT1pKWjdiaDhzV1pRdlhPNGMwZjNVanJ4ZG5POERVczhDUGFwbDgr?=
 =?utf-8?B?SDlRVXhBQ05Ud1pwVThSNHNmTDRCOHRiRHdyRzFsT1ZXZitZQUNJcGVpR0dh?=
 =?utf-8?B?ZW0rRXdnOFNtWlJRSWp0VzdQTmEwWmVXc0pTbFZZK3FrTVloV0NWcXc1OTBG?=
 =?utf-8?B?NVJHTkNPdUZ2WkcrSitUR3UrSFpOSjdPRGNybUFUWElQVmdTdStSeG1hZ2Y4?=
 =?utf-8?B?Zk0vbU5mbkl2L0dOdkI3NEkrWWFRMDJqZnd3NlorMzhNRWtRamxhK3M1SFY1?=
 =?utf-8?B?WExBN29KSzFGQnRodHNlZ1VGRC85VDJyUFRuVHdtRmlaeEFVQ0phb2F4OGI1?=
 =?utf-8?B?VmF4RW9zZTZCQUUrdERKVy9PcmpVN2xURWNYb2NyVzJmdnl1ZFVzN1FlVUxr?=
 =?utf-8?B?MXB2eURHbUsrTzlMZGJvQnlCR1BHZWQvODdZc2tUSjVxZFJkdmV3WnZscHlz?=
 =?utf-8?B?eGlxNi8rZlpRRjliNDdLeEVhd0VrMm4yWVY2STNLK3I2VFVOY2FBOUZWOEpt?=
 =?utf-8?B?My9nU0tGM2E1cmFkOGRaQUt4VS9IYTRUSXNKYjJrT1B0L0ZlSFJ5dkdaemFZ?=
 =?utf-8?B?Z1FROTNscDE3TVAwODFwY1k4ZGF3U1BIQnR0bkZCZG8rZHdoelh3YlIyMEcv?=
 =?utf-8?B?ZW9GV1FCU1REdnhjdkZMRkZXbXJOQ1d3L2pDUDlFWVh1dnFZVElDU2c3NXlP?=
 =?utf-8?B?dDZzTkc4MzhsSUQ0bmJSNDdESnhRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cf1daa-7a7b-451d-771a-08db2c66c221
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:53:26.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CYSh08152G4gWIvKcEFUEk7MJ4L+vKO7sicRPpa9k5CCw9T4mL67Uq5fOSxu+PG2lVIAOkEHBSAkMPo9/k6MByaNOwqf7RpUf02NNYyFF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6231
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:11:35PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> In function ‘fortify_memset_chk’,
>     inlined from ‘rtl_usb_probe’ at drivers/net/wireless/realtek/rtlwifi/usb.c:1044:2:
> ./include/linux/fortify-string.h:430:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   430 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/277
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

