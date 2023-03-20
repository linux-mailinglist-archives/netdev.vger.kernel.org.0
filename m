Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD286C15F9
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjCTPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjCTPAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:00:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C9D2B9F8;
        Mon, 20 Mar 2023 07:57:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq55xxL+xJ/otuAysw0825ASUC/4Y+gUQNRdw9MPZ1LigOKG5JCMm5DVy/506zEnmgOzaoMw/+1xV3s9U/in3HLZYwJzdsxS/r8qTY9PZQjx7ix2e/x/RRwOAbPF0H6wik0KAX9mRpJzSdsGdGPdIN5x2CJMmD1PZ1PJY2KuNB9mXrU41nhbwifIkbZrqnB0nV3b4CidXdlYXtRgK4WUCe0c03wFdw2QGIDtAqmvpPJAHVaaq6f3okWAafCqkPVY1jFEC51YkkEGnYit9E7Cn7a4UnR0+9Hll7VUPk9nqkXbVywWDr0y1XK7BIAr5IshqkaYrvcfGdUrNfSiomg1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44cKe/+yenJfWqy6NchSiELiuf3Kujkz1QEtKHZntMk=;
 b=KTNSRW4a8oOUK11fntACJ2fxZJ/QNqrVd6McDQixlbxlHqIaKZ9P4duAfZGh+zB5R96zdYu3CacRCCwjgxJJW8y4ZWApF48oFrPa1R/O9E701we9xBLybTA8zjYaPEGOsxfS74ndGw2fs7FgOP8A1UDRf5dmyBoD6o2ERG0CWJMrFPFS2mbtzEaFEIBJRuciN89kq4Pw4DCde2mGZbU2o5wjZR0YGuJr7n/Z/VSHauDoHUx4F+ffiOc2rudcLd2G0eDPjUcOYrqbEks21zgreA3ezXVRuG0rqQep5+KLtP7EaZQwIGE2dnyiBaa1m3HyH8Ism3aaktN11Az4dAhG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44cKe/+yenJfWqy6NchSiELiuf3Kujkz1QEtKHZntMk=;
 b=UWdW/rlB3uizlDUJKLFcEckPogAIRKjBHHdjPzcpGZJtpmFtepxTM+41nyHFrzNJAvt0QnBDUgHWJPi0IsR/KCX7F9tBjEHX9FYE33uyuWeNlEXR7/rHNqkB1bSTsGO5ZfAeZwkL+KQVYBUFtaRjCaaD3DzJl8IMUPE1yOj4Z9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4448.namprd13.prod.outlook.com (2603:10b6:5:1bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:57:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:57:02 +0000
Date:   Mon, 20 Mar 2023 15:56:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mt76: mt7921: Replace fake flex-arrays with
 flexible-array members
Message-ID: <ZBh0NhaNFnttWRz8@corigine.com>
References: <ZBTUB/kJYQxq/6Cj@work>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBTUB/kJYQxq/6Cj@work>
X-ClientProxiedBy: AS4P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc995e2-d954-459c-755c-08db29535d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83Im7+8uA/81lOyT918m7iXUZBwYxohnBrvLlNsfcAZUVouq5VmLS2ABnBgp9YgVOzVS16QaFQUy0UlW+u7E8hyA4pkOjz9fYloOdCV4+idL/zlNrOrG2MyLBnTmdgzrC1uZbaZcwM2JXA2US4O9vsAk/6BzeD3UY5u4Sq711ShJnstSmCe0cUxEcPTypTtGhPAF1auHrkK4IGqyTbFBa5gr7BJcdkauluITMTGiVq4rW3mLNkySqMwVIt9m5eFTE9qX/TVBp3Bi8GpbPVEwloXVtGsQufNNV3XBjE9DJmLKqoJRnpN1virWro00B6Kmv9TaiFV1mjmN/mITud8TKIqniqF33mRP8/eF7t2YZam2UM0wPCh6t8J3O6V7vhiQoL7TQU6lhimWtxrfngxS9UQAiHkOadaVWY5WDni6fmpqjW8RbEIi7zPruecz6Tgo0u0jW+aBE7ppvetKc0P7k4xyDg+hclbhgpbPf4OcGOIHmt/jOvjsc+tSg33bb29RCv+pwMYrHn77IaXT1P8XlrbMNABgRlYoQsjNsHf99tJpzRolGR/ET2PlPAlG06/NgWBXd8WOXH5JSnfhPzEFRIhytbunWYMnD9AZdWGuaMhKgO1qYv0mvwDPFFxi74HkF8r5ueXKRmUneybipaLVz8AHmjpzNwuZKPgZboBCfrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(366004)(39830400003)(396003)(451199018)(6666004)(186003)(478600001)(8676002)(966005)(6486002)(83380400001)(6506007)(54906003)(6512007)(2616005)(316002)(66556008)(66476007)(6916009)(66946007)(4326008)(8936002)(44832011)(7416002)(41300700001)(5660300002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2kvcXB2a056ZVA3VW5BOHZha1ZKcnF1QTVXRTJNYWE0QUVrZzZwUW50Sksy?=
 =?utf-8?B?dk1UbWt6MDlLNjdWL05MUXVKZCtxR1E3dmxmVXFWYS8yallieThCZEFKZVFW?=
 =?utf-8?B?ZTJPbFpvMlRLQkdpMWtTMkI5OG96V1p0VXFGOHFvdUFPTkx6Yi8ySC94dXBR?=
 =?utf-8?B?NzJPdkQvSjM2MFJUOE5ZMDYzK005NXY3eUtML1BobWp6clJOZHNFR1Vkbkov?=
 =?utf-8?B?M2tzMVZlc041YzhPK2lpQ1JhYnRFb1RlRmdMU0pYSWFEK3VPdlNZQmowcFBx?=
 =?utf-8?B?M1ZIaTlaMjgwbXRuTTNmNGtSUTJ5WW5jNmRKK3loV0ovTG1rcElhSVExbnlS?=
 =?utf-8?B?ZVRrSFB2VHZoSHhGcmRVaEluWXZjTjZlaGxhTjY5cFZIN0k1ZjZLQWF6ZnZK?=
 =?utf-8?B?R1hLU3Y5bkp5QVpiRG5NZkdESk96dHVITFdZM09YdWNWYzlXZEpKVC9QUGNR?=
 =?utf-8?B?OVd6OHZvWVVaejVTNXVLTzcva0NFV2xBcWtrOUdueTd5NkQ4TEVRNE9jV1NF?=
 =?utf-8?B?WmFVQmlxeUpDbHVWNnZPSi8zZm5DNnhzMzB5ZWxuLzY1SElSeXRrVDVZNU1x?=
 =?utf-8?B?amZ3Q0dNVUtiTlhFVXVEV1pxNkJ4anptNnlNRVJNK3AyWkVKNENIVzVGeVRO?=
 =?utf-8?B?RUtUeGVKb01MRmxwOHl4OEk2ZHA2alF1OCtqVDc5NVprVXRhRUk3QWM3Si84?=
 =?utf-8?B?L1NXYWRNSjBraGNpVk5BTkRiMHZsMW44WWRDdGROZjhYcTRhUnlvdFNOeWZl?=
 =?utf-8?B?NGgyN01TRXZrL3lCTUhGdm1qU2prYi84TTdZeExhUmlzS0FNbklPaG8wZ3JX?=
 =?utf-8?B?YTFjN2Faa08ra2dCVEQ0a2RESUF4RGZJZnYvUWFyMW82emJTQkJ4eGlBRTM4?=
 =?utf-8?B?Kzk2MWI0azRuR0ZqaUFYN0tIbHJuenRnNjRKZWh3eFJFRnlrYWtVdEdyNElY?=
 =?utf-8?B?R2hLMlFNT25Pc0t2dm1KSHRoVUEyNVBmbEp2Q21SbDlzd3ZuNjVEdEtpelpR?=
 =?utf-8?B?MXBhM2taSE0zMjVqTi9VUmFRTkQ0S2Q4WmczTG5Kdkpxd0xzMFlrZkdxbFBT?=
 =?utf-8?B?OTZ4VUNSM0wyS2NMTkkzVXQ3R0xnSXpOWXZCZ0tJblhocEF0UFB6UnRpSGdr?=
 =?utf-8?B?R0wrNlRZM3FPWTdOWVhBeGcrVWwvcHFiZHdXUWFZbWJ4cnduaUdKRGI4NkVE?=
 =?utf-8?B?MDNvZ21FTURuWlVoL3ZJMEhPRW9GS01DZ3ZyMDIzcEp3aFdxeTJmaHZqL2ZY?=
 =?utf-8?B?SnpxdEZHcERwV1RGSXV0WXVlQTNOdDJtUGs1akVaaUt5dS85T3JHcG56Sncw?=
 =?utf-8?B?dlBWZnVqSlczRXphZGRDTTV3Z21nRW0rNWYrYjdZWGorNXEvd2pFMVZ2M0dM?=
 =?utf-8?B?bEpEOTNseUttUEhiZUNKUTJLOUMwOU9kdjNPQUVEeGNLYXlXaG5yM1lxYTh1?=
 =?utf-8?B?cS96Ui80V2w4UERBM2k1WHlKRFhNNWlmTHJLOG5NaUttcnNmSFhmQUhaSFRO?=
 =?utf-8?B?SmJucVZsMHNockR5YUdKTzNjRm0yRVgzQSt1bmU4ejE3YWRRTDJ6TE1uYWdv?=
 =?utf-8?B?VU1EdnJKdk9USDhVR1JKZVRqKzQ2WmFYM3BDRW5MWk0xQk8wN3ErdFdmRHhh?=
 =?utf-8?B?NXdXVDVZVUpKZkZMUUFBUlRUYmI4YWMzamRTN1N2cENvR3VNU3Z2dHFGejgv?=
 =?utf-8?B?K3c2TGxFSE1QNThhOXRkVzBSb1VZQ0tXSkJadE9sRWZhYTJrSlhQK2F4bkh3?=
 =?utf-8?B?UlNoWTlSRkVrS0JSTlpqZHZWTHRzdWJaaFJqQk5abjE5ZWxobWRvb0E4S041?=
 =?utf-8?B?RjlSNld5emtyakl3dng1aHpSd1pBT3RsTVdyR21vYUprQjlrSUJ2czFzWjE5?=
 =?utf-8?B?VGFBYlE5NTNtVHJEeStwWTN3RjR4alJTU1duRERBVmRkM29rN1BFWnd2bmFv?=
 =?utf-8?B?Y0JBSUlMUUhSOEx6YTNoU0NYOVF2ZmpxSGxYa2gzRWN6ZXdiQnVXdnFZU1F0?=
 =?utf-8?B?ejNId0ZHcFE1MDZqR29RVnJ4bGxwTHY5djhXS1cvOVYzWFZhMkxXbWFnaWxX?=
 =?utf-8?B?NXBLNDZBVWcwbUw5WkF5Z0ZUMG9JZXlPNURNSTd2N2pJSjB3TVhlRXJTNEV0?=
 =?utf-8?B?Q21BZkxvbkhubE53Wk5PQm8xc2k2dGxSWisvL2pBcVNCRThSNlQ2U2pFemZC?=
 =?utf-8?B?NExkOFp3K0tsVDBOSk9PNGtPOFlxT05KVmlreHJUdDd3d2RwMjhpNWVoQzJY?=
 =?utf-8?B?S2pwbE5lcWZoWGc3TUpka0dZQWp3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc995e2-d954-459c-755c-08db29535d22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 14:57:02.7601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EX4cpQy2+XYyBygqlGdau7Yre9Wfdec1CJSHS5tEZqvQslHOIzZSgR2G197LlPZmE2hWKIDWGRpMcr8A6B2hDikAzRIVsagddoell+pBaTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 02:56:39PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:266:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit_v2[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:263:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:223:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit_v2[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:220:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:334:37: warning: array subscript i is outside array bounds of ‘u8[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]
> 
> Notice that the DECLARE_FLEX_ARRAY() helper allows for flexible-array
> members in unions.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/272
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> index 35268b0890ad..6f2c4a572572 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h

...

> @@ -69,7 +69,7 @@ struct mt7921_asar_geo_v2 {
>  	u8 version;
>  	u8 rsvd;
>  	u8 nr_tbl;
> -	struct mt7921_asar_geo_limit_v2 tbl[0];
> +	DECLARE_FLEX_ARRAY(struct mt7921_asar_geo_limit_v2, tbl);
>  } __packed;
>  
>  struct mt7921_asar_cl {
> @@ -85,7 +85,7 @@ struct mt7921_asar_fg {
>  	u8 rsvd;
>  	u8 nr_flag;
>  	u8 rsvd1;
> -	u8 flag[0];
> +	u8 flag[];

I am curious to know why DECLARE_FLEX_ARRAY isn't used here.


>  } __packed;
>  
>  struct mt7921_acpi_sar {
> -- 
> 2.34.1
> 
