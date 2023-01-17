Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E04866E20C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjAQPZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjAQPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:25:19 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2108.outbound.protection.outlook.com [40.107.102.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F246242BF6;
        Tue, 17 Jan 2023 07:24:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdJsTo24W6gsUP5MXiSOz9Hd5DhXwEJQTHAMrmHfUgFkEtp4uU63m2RvHOv6PRi3psAM+bkl8aSmQB+1k1ZGuRm9H8/tlX/99CcMq1YDFNgm4gpjfBuahgl7ZyWAs2YYeEUjSucvimzC9KNIMEc0ynutNcHQEJzMHRD4S1eYoobHoR1flo9RrsRrSBxHciE5Ul4c9rhThmggrax3FXEY8/DrfzXFJuvnfu4nV+fuEqXMEu/kORpBR5uzPw0iZJa5EiZJKhDoZ8UagjxSuzAM8ZsrmtU3NBKSebqad5bpk/4MAL2PKpLLtoi2rkzYocDp3wbmXehAousUG2VY+56HTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVgSo/+6KRaugzpsJQmPrC3jCSluQ8CI31I4VwZ9WL8=;
 b=J8sk1Q6bfsqtvfCuS5vzmtjdq66NtV8p/dsWO+PXYfcq3dVj3MzwEuRTzzwiD2+lrLv0taazKuVh1jyJIqRXTecPGwnoQp8vcEP63IBuJSsLTdT2hB/nOx7gkQ8HYrhTclgjUMKR0lcBBhEtjrrYwzAtD3u6VW+GpcTyfil4Yie5mfpNfrwnKyW+tq0wpU8H1cIodfq9xhJA7EBMfKLGTVYSycBVUvUUIGrNfe7KI5h3kpxJyn/zpqLKd2ynl2z/sDt/wT2RnFYBzCQtU5BVTekj3RSLsImA1lFFCsnWvXXmxUZKGzyuoUDrTkMJZSbQaJhayKySLEw6i3A6UXDEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVgSo/+6KRaugzpsJQmPrC3jCSluQ8CI31I4VwZ9WL8=;
 b=CdkK9aESLYQqs4CZAC5WZF1wffAPCgnEriJNv3ZJG5uP7ditWFj5VocWP6Dc5ZGoxS3UGXIwwXpr4qfuIJAHhS6z9unbbFJZBGCz7dSIiSyQR4Vwky6rUlJBL+JAcEtTRTjJ4df6gHi9ICz7jW9n4rktKezUK3uVlsHy1LXcYHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3933.namprd13.prod.outlook.com (2603:10b6:806:99::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:24:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 15:24:47 +0000
Date:   Tue, 17 Jan 2023 16:24:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ath6kl: minor fix for allocation size
Message-ID: <Y8a9t1HKPXV62yUM@corigine.com>
References: <20230117110414.GC12547@altlinux.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117110414.GC12547@altlinux.org>
X-ClientProxiedBy: AM0PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:208:1::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3933:EE_
X-MS-Office365-Filtering-Correlation-Id: a76f1937-1dbf-4a69-7142-08daf89ef7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVjCgW0X4dxo41Y0LO+PiojlynwXmhlFTDtxUf8Dm13hc0DF4RGU2nO+e+lQzvTQlg0825xxjNPD+RqsFUJlX71T881mb3ZaRV9tQeMB5qYUSBSIqDZrXeFAORKNqRBnP5BizZPmiA419X8ai2pqpvKJwR+8pJEGoSFSuTl01UvIBUOSVnqQ8ScHoPm8O+3Z4DNnvgzrvtt+Ef7rrZhbXTQSbFl0Cl3zqczv0LoLz7YTu1nYeyDVpnqKihb1wMwEqNWfQIgpBj4KBNxxqfbI+6UM24L8tM71euuzTjZYvPhfjfHNlioOiA5xl8jEvJhTmJp3hVGs42xmURIonncm5hRvcDcKsq4si99aUQ0b9+9KKzhWHWJJdEviiLWQMbxn52DxiiiDzHPDoB2s80iZrRsREax7njCmVtCsgmXfyAZN1Ty+QCeo6aWqlunS8jsiq/j9PWabV/AT+RltYGY8Xbgo/hpLsSyQgxCmVadh7RtnSIp+IwxYxwYyYgdJdRvLTIH0y9PmlkiDm7rXeAaIH9Xmalv2DEjezDtSWO0NWMD9lurA6JvJRolwmjxxlya0RFmONL1GFnDUivEMztQ3tFskoITJFNuUzLo5UgbSs+6Zfiqv/h0gBJdvmR5sZvImukgNz574zo0QlZMcpNstE39AbiQugKUIe0jrYGCzFsRoffeyQ199gGwqn0lJAGsL1YmCNMh0odqN0GhUg5yUhg8DHIp9swfcgCFnsOow/iX8Itqc/2ypny996AHRfQKR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(136003)(39840400004)(451199015)(38100700002)(36756003)(86362001)(6486002)(6512007)(66476007)(6916009)(4326008)(8676002)(66556008)(186003)(478600001)(66946007)(2616005)(54906003)(316002)(6506007)(41300700001)(8936002)(7416002)(44832011)(2906002)(5660300002)(6666004)(83380400001)(4744005)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ne7C3hM8QbGb1yjCPb7Wp1mxmkEMFvOIWbMnUptpRCESE08KJzXWNRlY29EH?=
 =?us-ascii?Q?AR7UsOoLyHtfPt8cKKTqoHX33+12hnoE2w87SDcdBxFUD7jd4f5CM7eRY+nT?=
 =?us-ascii?Q?YTL4S50MnAs7DFkmcfSSlTLmfs+hixPHbBAXWtwVaiNFMwq+nsg82xhgOHMA?=
 =?us-ascii?Q?LKriojLXi/wrcrbb01oU6Wbmj8OFOv6H8uaDksr22gDnx08Tf8UFHuQovn+r?=
 =?us-ascii?Q?BaP65w2lC1KNRq3bGhh/rqrRuoNkWRQP7PCBrgwuDna7BqvJy0g/V1/tgl6b?=
 =?us-ascii?Q?neLvVW6bVr3+YD46TxlCDXDisN0nokLnaBjznxb1ShV/HPYbqWkmzdqYx8qM?=
 =?us-ascii?Q?P45L2LUh4YNoBvaqran7qrHoR37fKktpI3fytwjtGt/Uo9YkdAmVFNpBn+8X?=
 =?us-ascii?Q?hNckve4r1OdRYyX4aSaGjnjYT85USu7eb7UA3C2L3YxwvR9XAuBVrbD07y7j?=
 =?us-ascii?Q?XRCKEc8nXfSpBdHFlA2J37ipKcI2Buel0O/gkvoryCBT3Gi8rMzbLrrr5y11?=
 =?us-ascii?Q?Eh4mn9bEkgJsw4HkyRuWR3r+maYv4gJKBtF0dqPnqa77teiTDY4EzApsecTb?=
 =?us-ascii?Q?F5XiLdVtoW2zFF42DIVqb2foFNmxL3Pep5z9TW7yCbXzvcB/QW7/Ccz/Veu2?=
 =?us-ascii?Q?4ZKecNZ5BoQdFqNBh+UExC83ncYntR/Tn48zMocxhAqnBua2QzzwCf71M0mD?=
 =?us-ascii?Q?UGkAIlrfTgY3BP+3fVYEdBen796tOXqNMot69q+ACVq25ngHNAivAEAUrdC1?=
 =?us-ascii?Q?1xa6+dIBSFb7IZh24evkTkXl1jqo/wJC6nMkK9cNqZTGZftqE8a0P9/1VG8X?=
 =?us-ascii?Q?AIyjZ3QTOxW3YaRR6HsqwQHVFSm3lgIdK+v9XiAGrLKE3b6UwKj1dI4dBhzP?=
 =?us-ascii?Q?0Tc8JP4fjtMvhuIpsSyh+PAtBt1XXQy4tsVL+iI+P/p4J/OthFk9It+/PpAG?=
 =?us-ascii?Q?ytKTPy0v18YO+xyceyK84Uuw6DWMhaOFBiNPvIOFQOYcL0dxZswy7SzUGv+r?=
 =?us-ascii?Q?F4S5sGXDtfLb9sXD9j+WhXxe551UpBM4bywXoCvdsAnFsw0MdCu/IjjkII7/?=
 =?us-ascii?Q?Cb0qu56Kc7thN01sagzTAc3lsUADiLdjGe7AEsNVT+kYFbqDcRmMoEy0fFSY?=
 =?us-ascii?Q?Q4frL37+wzKBZS+mHGHpT9m6vvIlR25iZJc8eCvxSilsXsLDY3MJmUUOFbUL?=
 =?us-ascii?Q?omZSiCZr9ku8gIRkxRNow26Xl2fL3kc9umUx607SQblAmXk7mK5rva5Gz9CC?=
 =?us-ascii?Q?pbAHzfpNIecHy7uT3MS2F0jy5dq4ypq5a9zEklugGEPLSZ8DD6YXaJkAlFuY?=
 =?us-ascii?Q?xLFzl1wfPW2lTw8LZoYTw/w3zD96UKKLK2uyLmUuzwSF5kRSca9zAnHd6537?=
 =?us-ascii?Q?F1+r5rCeqKo9g3E4VFj7r95VYbpOm37jXUP1oLUXXW1tk5Eo+JhtgHvfa9pZ?=
 =?us-ascii?Q?1isYiSvTobL2lC8lnFBqQLE441dmb+advu3qbVOJZXqOwOWGTriCY2iKTCnC?=
 =?us-ascii?Q?ThXbQ7smxSqYzzC9G7CGS3QvkZp2o7Qe8gRhxHkB7iX3W4MevYNC7iTRSTeU?=
 =?us-ascii?Q?G8wjCsMIpLhk/TSqKDyES9JSndtjDvnB6ST2z8cGrqpexidpiRlR2ntcwqCy?=
 =?us-ascii?Q?2lnPMbkUlb1M+SCw+Xv5/30sH7F1iiG5h4hE2Yf5jLnvFSJQSR7fK2OYSeDF?=
 =?us-ascii?Q?TdTYPQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76f1937-1dbf-4a69-7142-08daf89ef7bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:24:47.3130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFTfAjk0PC1bx4rVDstcJ9pyPWKhf3QX03AXoOQq/wcpQlx0vLg+5fdYobcb815g3bm00XGRdsKi6C1U53LBI78vrKn6PF5X1YexPt+/dAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3933
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 02:04:14PM +0300, Alexey V. Vissarionov wrote:
> Although the "param" pointer occupies more or equal space compared
> to "*param", the allocation size should use the size of variable
> itself.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bdcd81707973cf8a ("Add ath6kl cleaned up driver")
> Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
