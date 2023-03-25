Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC06C8CFC
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 10:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjCYJsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 05:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCYJsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 05:48:06 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2090.outbound.protection.outlook.com [40.107.95.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382FD144B8;
        Sat, 25 Mar 2023 02:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTDDzHnfeRVAEH1EEfYZcSuyeK0czat0Lig+w1H99sfN4cbDv/9yDobiSYZJQNtgw+9PrYMRKahx8cert+UjNGtQIAdxU6iKxkAP2XmrWsAFgeqeBiVGY/0dt4uGFsY3EskrQHSlLRrJ46BVTodOv41ISXuSdoCb8skItOzvM8qIMDTLCZ6RUPsXj3nqrbzGXt11T5TS2m0I5oWXLxmRe+mhnNN9n/TSPWUbWtIwGph+jBjaUYPD3saszce5qEnYnhoDLu7VXPLkrcbqD6POQGtP5iXMTfVSvN1+DSiItKrhsBMLWwaGHCVhuaYf99HWaWCwCrGCnxWu4oB7zDuO9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y54wP80EVKEQXX6ia33bR9+Go4YeP+3F+0KjjTkwPkY=;
 b=S0abESeKG1c/deqSguC14M2/nlnDNFAldZ7eE8xJQT07hnPMrI1Hq1pLnu2cz++LlBUdW3ERFoDwbUv+GmSREzZxPgSmFFfJZDT6N2hzygSSk3xNdRSBPvW0bz+qaA09JiShLhvUv2Wfv5QdzysyOf99W7GbPL5SUU8dFKsgt2ca6tI8k64KIxD2zD+fxSKvx31AtoTXe7dVJMpnq+fpWYNS2dnDQqBX3np8YMaxtdkTDgvKm0RPdpDLMwaJFkk9q6hg0KRHmJjaalT+JLlXIzy2HYWufsPunW9SiykM7rWh6PdU3kjNYhDWEOy9uK0RDiNNIxq66Yjr6omvpwskvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y54wP80EVKEQXX6ia33bR9+Go4YeP+3F+0KjjTkwPkY=;
 b=GzlvPp4T74Yr3raBI8ztznPtxrzGdzF3tLryl6X62yaAZXRtX7EfAdlWfYIVc5AMPcFFF50GzoHWE9/+IRb7rJRhMqCG6GluYQcdJ+GwTxFFOFNjEBLpglnSciBKm+gPxxlXTaQqH5l/GUrSrbFrN3XtRU3rQ2KQf6sBkOCECuI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4526.namprd13.prod.outlook.com (2603:10b6:5:1b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 09:48:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 09:48:02 +0000
Date:   Sat, 25 Mar 2023 10:47:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_rfreg()
Message-ID: <ZB7DSn3wfjU9OVgJ@corigine.com>
References: <20230325083429.3571917-1-harperchen1110@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325083429.3571917-1-harperchen1110@gmail.com>
X-ClientProxiedBy: AS4P190CA0042.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: dfc72286-f4c5-49f1-70be-08db2d1605fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 607cwJFlZqvtKL+/Tq4p4JNUwoXWWH58TrIBA8PDHOXfO6hDcFwDLRZpIWkl0Ers5P5ReY7kUA6/vpgg3s5NjHQ5h9QJIjXY7DWJVVIr8Gck1+t2ozrmeQ6ATwAk8RGyzumjcnGp3lU7tmzLJTz96HvJXGKWI1MAyxjoK++kPyyosezgN0MRtFCVUgxT255jfacXDRlcTVz7b4VKSa1dEURI1nwiLLsz/yYO3FyUJCmzOTUFl2TBCuRYb2DKDeHxxp7g57VqUw31XoVVvVPAJh6n7TufkthC618GLP3EHrQoPHa+QNjfhzSmS4s9SD4ucXkMGmjEYXpXNXUtIavQgztGYaMGOSZJCMrF/kK/2WMkyX2PmYSeNFemzK9t7ng32QhvJf9KCBPNSaLWC0orGNDach2V1tY9Gzxs0ME0hxV3lXUjuktn24q6FclgZ/+BlP9WccMx0xKCzXGdK3SgEbOqz2QCReGbjXrLC7I6qCUTse3YsgV2QmE98l7utvFRu1/0Wp4Ryqem8u40TnFD14LSSyantjwNQOh1yIKSVcDi/QqhAy7f/MJ2qoTf7sTs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199021)(6486002)(4326008)(41300700001)(8676002)(6916009)(36756003)(8936002)(2906002)(66556008)(7416002)(86362001)(478600001)(44832011)(5660300002)(38100700002)(66476007)(66946007)(316002)(6666004)(186003)(83380400001)(6506007)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kosPHoe+PGMOej9m034mhu5Cv3GzcOLTTP9Ho6MV+ld78ry2hMDESXxoMsSR?=
 =?us-ascii?Q?fFIN/B6zWjy5F6JZTEAZXSfXBro0KTx007GUHANzh1aeBpWEJd9ExO2ItO2X?=
 =?us-ascii?Q?gJP+BJxv7kTg2Im9qq321+SYkJOQ36pO2kty36zBJRwfdOEwAmJ+Qsqda/Kc?=
 =?us-ascii?Q?ByhP1Wn4OLw5qCciMpqXWG9RSB2VXvZzC1wp/zMyt/0dY5n0Kk9pYIG4Rxvh?=
 =?us-ascii?Q?VpTg25ILhe1zpyIcF2ENyCvoBEvFhr8qE2s/u1Bc4I4zYASpcwo/lQL9d+Ne?=
 =?us-ascii?Q?cGhFrj6ApZAxYX98V6KIf0eYBVjCKuS0PsVd3hzizQFEFiEbzSdeayacctyD?=
 =?us-ascii?Q?lv6LNEW7uhs2atvNae3wuWkziwyfymCZpPWmNKEYN3REIiajrWnUvEFoMobC?=
 =?us-ascii?Q?JGhqvn4c6kaHWGrmXPyfruUHQ9VXrHDCU20uaWOxqj4YIxccatknxOFoURLS?=
 =?us-ascii?Q?OhbvAGz/cWROlnQads3LgERhWrZntu8xcE5DaXA4H5GDXHdkVdBKPBbNa3lQ?=
 =?us-ascii?Q?mIUwXFl246I0rhf7Ltu5b7T0Dy/aZQcvvqu7gula/Go0ZcJNUBQVPXxTobMG?=
 =?us-ascii?Q?rIvrkW3GiWcX4yYmqP5uFnp1R3cTNqO6zfp46ePOkM/Y28qwLeZGEFykb/3M?=
 =?us-ascii?Q?VZTeXtdsuUGrtcEyfgnZondfqosq5m6m6xpe5Sdi02a2AVlSZ4Id9USm4Rsz?=
 =?us-ascii?Q?LI6wYQui67vOFe7+QkErwDf4DgnsN6/4AByGlFzzeYkYJ+GvWqDAh9EAV3eL?=
 =?us-ascii?Q?bDq8kjAA7pFGW5/vjih8X8yA2IHaoO1p0GNPgUn4V2Va1YgHOpu3nUzMZgkS?=
 =?us-ascii?Q?t8HKfduNpJjdZsWwAV7Kmz3/iSqpyj89MThs/gHUZC8ZBiHsRzsG+Nj2VPpf?=
 =?us-ascii?Q?ZmFL8PdyoTrlPHo66oh3ynM0j0G3UoQx5JPtwcrB7rTTgJJ91GSM6mfFLSk3?=
 =?us-ascii?Q?Mce27U1zx0e7rImPvlRvh8eswtUqdWJyXErXcv+G7rJizOpol2oDoZJYHNhg?=
 =?us-ascii?Q?INgR2SWUqGVLSCKCZOER3gPLEoLlpx1IT7pfeaJN/P8jZpE/961RuPLNLCsO?=
 =?us-ascii?Q?uscmBC2ultOAD6FaOTs8bZsYjVaZu+TIOUFRtP2+KpY34/+IhCvfNG46SDdC?=
 =?us-ascii?Q?0cqG033VALro0XSgpX/zkT1kUt53YO0kNoyqc01JP8xNaLI3VkKMelC/KUVZ?=
 =?us-ascii?Q?68BDiPlCm/QA80j+7Qq0bEKXR864ALxH4L+i0BX2KUdV2XeHslBPUU0BBXjV?=
 =?us-ascii?Q?6KMBsu9DEHYY7VDEweuUZeVI6xQSn915zg46PdrkhbWE32ES5ZChRyM5NonT?=
 =?us-ascii?Q?V84IB0LFhfxIJ9haWPpVDuI8rQq85k6U7WyGnCXllkvh2WlEf6QRfk5OqWjE?=
 =?us-ascii?Q?j58F7qVwZ+0gzbLUazBVr3Z2ZZGMlxYtEMiGd6t8MhbzM2BDDWvgatcpflUC?=
 =?us-ascii?Q?uDOe7ughHkglWUKtql8LqUE7BKYVUO6FW7dnzb5UpF9ZIq/+uNAlpYZgrjW1?=
 =?us-ascii?Q?anGqZobFiIIfnTGI9r1eOO4PyDTuTlq9ULFY2XMzbJ7FbzxOTfzf2Q/MgJV1?=
 =?us-ascii?Q?Z875L8IYRRt+/DzuCPEstsk0yOnvUGXCkxNrabsICGm0jdXjss+1dmNgC/ta?=
 =?us-ascii?Q?pX3PNwywm4R80Iea+U5i4PJv3fbH+sKFcOjhitfoXeSKcMkgFvo1ePjfcJof?=
 =?us-ascii?Q?np2Ubw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc72286-f4c5-49f1-70be-08db2d1605fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 09:48:02.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RHnDIDb/xZieLMQHDWbd75dK2ApNEUxfoKCe6bhblRF80x5rgb8m1zoKmOPjLjOHj01mbUjRK04qbvUJ2s8QQp2T8RpdkrIT/jIuXDDq5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4526
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 08:34:29AM +0000, Wei Chen wrote:
> If there is a failure during copy_from_user or user-provided data buffer
> is invalid, rtl_debugfs_set_write_rfreg should return negative error code
> instead of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check of buffer
> against null is removed since it will be handled by copy_from_user.
> 
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>

Hi Wei Chen,

* I'm not sure if a fixes tag is appropriate for this.
  But if so, perhaps it should be:

  Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")

* I think the preferred subject prefix may be                                     'rtlwifi: ' (without the leading 'wireless: ').

* This seems to be v2 of this patch, which would be best noted in
  the subject '[PATCH v2]'.               

The above notwithstanding, the code changes look correct to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
> index 3e7f9b4f1f19..9eb26dfe4ca9 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/debug.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
> @@ -375,8 +375,8 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
>  
>  	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
>  
> -	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
> -		return count;
> +	if (copy_from_user(tmp, buffer, tmp_len))
> +		return -EFAULT;
>  
>  	tmp[tmp_len] = '\0';
>  
> @@ -386,7 +386,7 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
>  	if (num != 4) {
>  		rtl_dbg(rtlpriv, COMP_ERR, DBG_DMESG,
>  			"Format is <path> <addr> <mask> <data>\n");
> -		return count;
> +		return -EINVAL;
>  	}
>  
>  	rtl_set_rfreg(hw, path, addr, bitmask, data);
> -- 
> 2.25.1
> 
