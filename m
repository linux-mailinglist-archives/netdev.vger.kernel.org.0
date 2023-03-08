Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64A26B0E51
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCHQPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjCHQPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:15:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2111.outbound.protection.outlook.com [40.107.244.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07153521CA;
        Wed,  8 Mar 2023 08:15:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hq+oqvuZ5huzEK4q+jGBcq6LIPRWCrZhCF5VLLIldkUs1CX/1lOypSC1WYL77+F5pgGhmTSbK1ocPsLwfY83ngvloPKW2+4Z2cYmzXQ2vCanasyowu4h2aMkCT2euUM6JWUWYqaCL2ZwwVmPtm9h4+F3D0/LML6HPRUIvfqlz639BRsL7Rs4jJb32ZDif8mpDUKcM09OUZ915ZoitnDxPtKbYLeAQbM3CHJZ0jSBdNn3Cv1S0ksxI9BA4PNEwI0g6McaJ8XHmhmH+qbWslGOUdnJ2g9ejIh0uqcedgeklbQQxMwZ45847MiO1yESmG/2JGlXbeGLPfZA5ovart9Q7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PqcycezzpILHXLFaf/6S8AuTHS4LanQypwizpahlRo=;
 b=MS8Vkcpa82ZQ8HYciGm3/cNSWPNOJIItz6PXi7XzDsAHCzADP+qjE2TSaJOcTp97Zb+sG7LMzHcBUU48+x38OpjgFMRLazhGXM136h6wddb/3i3V9w9/X2Xi6w3b7p3g2vrijVhKbA6fVG7bM1nFb8W+2ItkfeWTS1UXppay6YO7AmGHHaepcxcaH04IR7WHeiImdaZB3vFUs3htdSI2vO+Ya8WoYZOxPXwmbboZi2LFnJi4Rka//7FEPoWp39Ym6ZN/OUcIBV8C2FHlPeBZoeZQ3JIwdrcBe7vibKV/oio65ElBBN0qHVXd0QYu+cf4wYs+R4fim0WVPV5d+S/dhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PqcycezzpILHXLFaf/6S8AuTHS4LanQypwizpahlRo=;
 b=O38GYyLTvGJIj8VL+w1CL66yzI+UQR1kMEK5HBNt6Dj6UUQsiuJOQt+smIGXc2SKJM02nipyTS62t6+bcXYjPF6Zhp7NHKU/hT1SQA0tcHAgWeVNcUyUXENY7z4E4TNIi7Rt1a5IAmhRYdi32xXkwDvrE6AEoG3Him5z/cKkwOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3895.namprd13.prod.outlook.com (2603:10b6:610:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 16:15:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 16:15:31 +0000
Date:   Wed, 8 Mar 2023 17:15:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: ath11k: Replace fake flex-array with
 flexible-array member
Message-ID: <ZAi0nNtWKa8H5xfl@corigine.com>
References: <ZAe5L5DtmsQxzqRH@work>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAe5L5DtmsQxzqRH@work>
X-ClientProxiedBy: AM0PR02CA0174.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3895:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da0c463-02b0-43c4-d39c-08db1ff056e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mIqhD2wHzFpWcsq/f28eUeK5lWxbpgHR/mSDtGR490RLCQqLznQjku/pQjxQk+ryTX5d2pu6ZbRMpjuLaz4VtrnHO0ZLdWfq2rOP3YZtl3kgJhAVW9Ofwci3jC0qGPw/TBiT04qbZ7UBzzH5vo7TAlwtUeeGS5H18EGuOcOIjR4O6o6/2ETM1XmKXIvJuBxpMHMbk/N+zYFJtJvCnKo5YpK2/phf/TQeqxrIELxMUHTMVq3Cv9/TM7FiPt+ZefdWO8atKtLPYQRSXihyZ/KZ4By5d3g+iZjRSdyVDU00NSx6A+9jSdcEKAODD0YMxO8qj/3ApqjCUFcXYBDsHxtPBYB1IE33kUav69/QukXVXWX9kJR+RUhNrNPnL/2YGt4KBiNVjoVFjaW87/XsWlRZbfnvJOJ//Ogb3oqfKBsRQLowQt0CW7GtVtZdJAZwEn8VUbDMJuSuOhbyRgIVl8GA24NzFXgwRsnTG4pVJXkvDWPVfKkJnweAvQA0cok5P8hBx99uNQcp6YbxwVUOHmLAMODLNrVuIOi96KAruc4qq9GOaNoXVoWKd27j0oeCoz4dwdSQ0QXP4V75xZS3se5JnnDRhBtkdI34PP85/QtWkGBU6Cc37rHeo8P36B010twq5njRKqWSNTqmqk6TP7aIKIVxbdqQl9Qn4VVqMlm3bM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39840400004)(376002)(346002)(396003)(451199018)(5660300002)(8676002)(4326008)(36756003)(44832011)(8936002)(6916009)(6666004)(6506007)(41300700001)(4744005)(66946007)(2906002)(86362001)(38100700002)(66556008)(66476007)(7416002)(6486002)(966005)(54906003)(6512007)(478600001)(316002)(83380400001)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm1TRDZWNy9zeUpkbDh1eEUrUnF0dDdTVVdvL0dEREIrY2JNRmZDS1htOTZt?=
 =?utf-8?B?NDlSR2tJRGNNRS9MazJMcVA5S0J4QnM3SVl2WjQ4RTJVYVpJQlhqdGZuSXpE?=
 =?utf-8?B?WDY0aW4xUElET3ljdUxpU2JyN3p3QkhvVDlxZFY2SkU5TW1pMmwySUtSMDZt?=
 =?utf-8?B?Y1V5c0k2eVlrL0liV2ZvclhZMWVyUEd5cGhoTmVRaTQvZWNvUWYxZ1NoUHll?=
 =?utf-8?B?Vk03SWtheFBnWmxsazMybkJNZHl0ekN2eVJsWDJBeHF2YUc0YzNEWGRYTVkr?=
 =?utf-8?B?aE5veUxtUW1HV1VDTE52NWJNNXpqWjkyWm1rTWRoQ2M3ZXU5THl6NXBDVWJD?=
 =?utf-8?B?UlJ3MWsySzZqK3d6YXdkTEI5RFJRZVhuc2phcFBndlBSU0ZwUXNneTlFTHJu?=
 =?utf-8?B?MXdTV0dLOUFUc2RCVzY0QjFodWxSZll4Q01GOGRicUtQWm5tNnpjN0NodVVO?=
 =?utf-8?B?NWVmLytDYVJKbi9mMzJlOTB5dkdtRnVZcjZ6QzlLbDdEejFpdGZZb0dtTHdM?=
 =?utf-8?B?REVMMFZlY2hIbHBOUWJyelBkbGZBU2EwSUF1Q3crclVWemtjWFhmM21tVDdo?=
 =?utf-8?B?cWVsMTdpK1NsOCs4SU5IMEZoS0NHNjJPYmVjb3VvM1RzS0xobEtsQUNEYzhB?=
 =?utf-8?B?Y0JNZU53MUZuN0lmaXJIMFFnTUtuc29FOW1KblJNNmRTZUdUVncrbE51RkZ5?=
 =?utf-8?B?Ykp0N2dRVUhiVHlFQ3M1eW1ma3ozZTBjME13N3k5RGxUcnFRR0J0UjZnbSsz?=
 =?utf-8?B?QjZ3TVQ1aTlyTUI4R3oxTU92QU03VHVLN24rZnRpTURWMERpRnVCdDdMTm92?=
 =?utf-8?B?Q2UrMDVNbkdYRmxKMCtvTmUzRmk3MjlNTHQvMHRkVUhwS0ZzU1NVQ2NyUlRo?=
 =?utf-8?B?ZTJrUFRnZVZXd1orZVBaMlRxekpMbGNyL3NQMWVBS2d5bGcyMXRWdWpsVzN2?=
 =?utf-8?B?QUdJc3djNDRCV3NNd0RrZWVJaFlscGJsOTBHZnFXd0RKa1B0ZDZvY2g2QUJ1?=
 =?utf-8?B?UkhFOER2eDVWTmxvMy9Xc2RlcHRjUkJ4R3dIZXRYZkhFZDB3YW9GMEZUQTVu?=
 =?utf-8?B?djVacVBOQ1d1WXRISVlQcUUxRXNrdXhONVF6WkdjeWJVNE5reDZxTm5FcDZR?=
 =?utf-8?B?UFZrOEtFelJCenM1a0lXRWxSNzA4Ujc1dTNORmM1K0gydHNYczd3TU9xa0o2?=
 =?utf-8?B?OGJjZ3dRS0xwMXhLY0NWUTVvVTJIVVpBQ0RFVDQyMnRHeEhSZWdsbWdJdzU5?=
 =?utf-8?B?YmtrdFdMVi8zVDdJL28rc1JZYUphNnEvcmx3cFlrakZJUXJTdUdsSGFGWG5V?=
 =?utf-8?B?dU1UN3lGWCtjN0tSaU1GRk1BeTk1K1RYbjk4MEUzOW5GcEh6YkcvNkxyR29l?=
 =?utf-8?B?SmYraXhZV21ubk1UaWw4aWN1ZWRTTGVhSktmMmFhV2Q0Y1RQNzNZRHlrdktq?=
 =?utf-8?B?NThuMHVQY1h3Yk1CWFMyaW1CcFhld2J1VnJhRlYwQzNvRVJtRWNEWUFiYTF1?=
 =?utf-8?B?UW5KYXdVdnVLVFpKNVVEM20zQ2JzTGJoS1ZpR1dNalNlcHBFQzkwUy9kTzdO?=
 =?utf-8?B?R1RGOGlnMXJ5OVhvYUlxTXdXMWtHQ3pmOS9FNHFsL1hCQkNxbmY0WTdlYy9Y?=
 =?utf-8?B?WS9BOU9qSjBTdEU0bU1DNjVvaE5vVkdOVDBJUzFFM3k5d1ZvS09DRm14bXlO?=
 =?utf-8?B?MHN4VnltVzc3VWNkZ0tpS0ZCZWNMNjdEKzRKQ0tTbjllNS9TR1NiYzBmL2pW?=
 =?utf-8?B?WXJWL2xOZDVZV3ZBeDlWOUVrRVEyekxPdlhUUXZwY1pyMzdrckV4QnFhRVFy?=
 =?utf-8?B?akp5YktPZk1ObU0xNFl4S1hmdEhyYUQ2VzhzR0F2Q3pRSEMrdmE5a1RwOE5X?=
 =?utf-8?B?NG9PaFZDQTFSdXNDWVNjZnc1ZUE4bVh4NFQxV1NxZm8zQUxKS3FHL1Z4cTBX?=
 =?utf-8?B?ZUNtMHRKbmJ3WlgvbFBGSGJnL09oajgwa3ZpWWZHc2NlN0R4Y2J0bHM5YzI5?=
 =?utf-8?B?V2pUVmdqMC9VUlFIR2RqaHczaC9NVE5jbnd2L0pYcnNxWWR1RU9ianluUmVD?=
 =?utf-8?B?QkE3UUJrWkVIeXI3aFRQYlVnMlBvYUJoYVhhOU1wbDVLY1RtQm9GZkVodi9z?=
 =?utf-8?B?eGdJZjc2TTBoNkFWb1F5eUFvcnhpMklvMktiZkY1MndKQ0ErYy85WlhvWmY4?=
 =?utf-8?B?ZXhITUVhOHk3ZVVLVzA4Nld5NWF6ZzBNT1d3UCtyZTl3cXA5Mm92SHljM0tu?=
 =?utf-8?B?bUpSQU9rUkQyWCttRUJZc0EzcGl3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da0c463-02b0-43c4-d39c-08db1ff056e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 16:15:31.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fu6kRQCXsZ5aAdz1sddOOHqp5DwmWO4jINeFzmyD2QzuQjzWXMh52sZ4WIWHS0PxcSm0YBymuGfme7NhH9HNLif0iVj4v9fHg4o07gjiIPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:22:39PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address 25 of the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c:30:51: warning: array subscript <unknown> is outside array bounds of ‘const u32[0]’ {aka ‘const unsigned int[]’} [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/266
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

