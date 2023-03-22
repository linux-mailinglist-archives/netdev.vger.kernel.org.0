Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46C6C5804
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCVUpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCVUpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:45:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2105.outbound.protection.outlook.com [40.107.244.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377CE1A49C;
        Wed, 22 Mar 2023 13:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi4NdqGVgKBV9LKtKSQ1V1VFcT4dyQ4PQupvu+DlFsjb13iysxn+a/CnwmGz4oKhrrImIxDmfmqulMWzk78IGlYTBwWo7CHLkDuDD/ORPlqtAYS5GpcYvPrhehHxK9pMi7KF1E+NYmx1K4twm2k8mZZTcH+a0PjXBJ1HZrCfSbENVwXpLy1UWnRnTxCC5/tErTLl51qesqNFzSAYEI74VeCLNMUIvU4Qlm9SXswTNDMZ+1ha2gsUUDyiokCz1a0cgBash0/pZj7zCbHgWA0dpCT43eu47z8IXmjuAZoygDSqFysq7zMgOpCkNa9rTAQFdSIc4xgdvz4gB+G7mD3NIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgZD2KmchfSEjwnxFRYWSv6wB0c7DH7Rry+jZ2QV8lE=;
 b=YNTsYFCTJCBx1HKClhbIIR2M+vYbfXz3oh1xH8vntJ32wkuqY+QLZ9wT9fYgrI962crjHFj0YTaGUEBAYTjO9BTnVnhLJWM8NVNs0RY+UVWGUDUDr1s/dfkffJEGbpbRsyy96yiqYzrMLLYLjMiDUPog/4RuRfrUWQtBKWn///451xLPfrvyvkGV4hvxdSXYDRxI2xRTYfX+T9qLLkxSpdQ4elfRQqpdjXraDIrPuyOvvMLIHcI9ew4jLTty56n4wzj00k92CnHLp9ZiDx8clRgXssKpCnQo48jVZUvg34NpFugXKgBd0hRRPiSXBY5SvMTGY5QLxH+GLsrEiLOpVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgZD2KmchfSEjwnxFRYWSv6wB0c7DH7Rry+jZ2QV8lE=;
 b=V25RtERJR8TBCvsEgPGZfdASA+bywV1aDRWaAY57Tk9UcAYoGCAPHFnZOlCoK7dFhpVlcPnbhHDlhunH4htHQRGTybe9KEKWWDzN7V7mbvnIk0tLAt12lB8h5iGrL8mXx8HPgB+UwUWdkBS7QMhWiHCFRfvI4pDdjEdJBjJNKjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4143.namprd13.prod.outlook.com (2603:10b6:806:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:40:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:40:50 +0000
Date:   Wed, 22 Mar 2023 21:40:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] ath10k: remove unused ath10k_get_ring_byte function
Message-ID: <ZBtnbgeW9T75ZXfv@corigine.com>
References: <20230322122855.2570417-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322122855.2570417-1-trix@redhat.com>
X-ClientProxiedBy: AM0PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: cd1eed4f-a8e8-4d17-0bfb-08db2b15b8b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2OtgbQ8a/rsryUIIRtCmyT+/CPS002lOkreX+NjaUQvrhdHAeaRPuwBWxhF6diypjj8zU3TP9Gcoe+W2i4zZJm45bhY7Uqa2PShelhi6BGtOsxLsfmpByvgnwcF2BCkSGgAK+5X+xFTaW8LkA3knQhX71rbCjhW4a4YYdrPg6lelNH23mJrJQQi+oJLzC5rLa35Q00Mk3M5JyipEQYuUjGfkTc7ivT9LG1F4uNfy/3vOoSxECnDMZKuBdif6ArfUJX5wvpbYH4QthnI4VMweK7Ku9Rkc6k/psRui/LfolLYhX6naixcSwDtdHeIk845M99a70ZqXJdncQFG11482m810Wh1qQJDa+B3pcnbgCg92xyZIjQeCvVXiaVsOXA7sY/CQLVTXq5WMI4kDvfLcMznRUwzni8u2Ekz+yUeOHfjCcvT7uoAvXw/nSb5ficmy1plNpiO0DVUzHCJesq/9TnfNOvXbEWzfjOl/cnG6nEYM391tblgMrKH4QmKXTL1GkRXjIvbg3zfQKmmtp8mrL+G2gBO0WIRjogdXRCOFOlu77/gP6jNBED3ChsIX+NaW2dQHrOrMHSL7HaPNF4EFzXgCWYa4bcu7ZJqJx/5SPmwxRPXg9kqm1priL++TGlsdblLYKp84NfUYmnbc8vNJCZluYCIlhcgYDguwWU+4VFSRZMepSLpWkoISTiDBcbC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(346002)(366004)(376002)(451199018)(6512007)(2616005)(83380400001)(6666004)(6486002)(4326008)(6916009)(6506007)(8676002)(66476007)(8936002)(316002)(66556008)(478600001)(66946007)(7416002)(5660300002)(44832011)(2906002)(41300700001)(186003)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ABZ7QnnuKdbgg6S1PU4i0rxUmK55EeXll/p6jBGLN8CqumiCAb0YxRD3b4k?=
 =?us-ascii?Q?j/jWntRqOUtuG02yHTJcsl/ILXHpkDmk7ASlFUx5e1BlMFHVMXrsyx1nOLDH?=
 =?us-ascii?Q?6DjsmWdL0WHURTxOdyK+waYzejIAikLUHgYWfdSAWkwohU2ItBe3J5w38Q9E?=
 =?us-ascii?Q?VQRys4doH0caTIO9Eio8wZXsJdpfIdTbae2LoJPWgrzwWjUvql9lpJv+M0RT?=
 =?us-ascii?Q?oVsrpx7czFvlhoi99kdm4/XTt5gFzJ8G2VQPAVq5eoiaD+DN0BeN/RQXQ6FG?=
 =?us-ascii?Q?iID9VvyiJnK8cZ1aFjiImUs700KWwV3yeO/8TYoVkIrlr/ut+CAlyUOuQrC6?=
 =?us-ascii?Q?JIuEJjqE33zG1XU4OZCZ4J2hE3EW8WYPQ7hDy0+ojPElAsJNcnRu/zupEsBt?=
 =?us-ascii?Q?Ub+7rBH+jy5/wfsSy2I6SWvcWL4tOAcXU4FkUsKt96w5FpbRccf2I+jhRthS?=
 =?us-ascii?Q?Wl9R9A37pLGDTZQILauqq9Je+I7GJfrtVh6xWb2NA9sk37ZccbuRe1zD4/Jf?=
 =?us-ascii?Q?OdBRD29pLF5AZkgMfbnhPDDGmE3Tfjpfh+9ddlQeCy3h/xApMKCMgWy3RgU2?=
 =?us-ascii?Q?2fd7x0VeHgeOWe3l9OK5XaSdDsyGOGrw+5RZy3yOD5FNG/PrSn73Sms7B8qg?=
 =?us-ascii?Q?7/ATgXvf7rhQHNFkY05AVizKOoW4FaGeYqsVbHnQPld4bxPOzHClZK0PRtL0?=
 =?us-ascii?Q?IipF6ZExSiaehpAa9CStJdi5XwqhvH1JXMPQ2VYq6V7FGO372IiYmvFezYRA?=
 =?us-ascii?Q?QMoauxV8EZev3TTc0fCxQZP5/0maSiaT/IN3YDLgCDQN2BB7vftpXBZl13ub?=
 =?us-ascii?Q?GLCtr5aFKAWxsO99Mjk7efkqn/fGuVTN4yg6j3eY7jBf+aRJqSqqbAN4c7zT?=
 =?us-ascii?Q?hXftFgfDq25mFS+MbkyF8AvHO9PunWX7XX5nKK4zHp9QyO4O/s6pN/z5Kuen?=
 =?us-ascii?Q?7a0qxpcgzkcqCj5xPiJYXCzNPCpEPaS5XGzOUtSLUaNw1almRuf3f9idQBdS?=
 =?us-ascii?Q?nvo3m16z+CKUMJZhxFQBlBeYxX7llMZ6r34hOdAjCECSqNmptT465bHPnIWI?=
 =?us-ascii?Q?Ta4iLGVjarSrsLJ1cCjY2WoH6XNtsZPxw+/UVuan707Z+MSTU1vuyUyN75Zi?=
 =?us-ascii?Q?nNCJptOdOLCOA/Gan+docdVtJiJz00r/SY80+QHLuiR6glf3PeMkQ8grCKdX?=
 =?us-ascii?Q?Bwxe3ArlwbnACSOLaETV/FvVcrPPCL3mMXeBJXnya1H75WCydBa2Js2okbzN?=
 =?us-ascii?Q?Fhc8VWdifS0D1c/+QKZjtXvxQCrfPfR8YGbHQXE4JIEm0A7V7wJ20fAsh0BO?=
 =?us-ascii?Q?t4r8X0rj6RI4Bkfc2jTR5W1u4fc/xtLkX908gYUOv4E0lS4zb8bYJXGxP3+z?=
 =?us-ascii?Q?BNvOvuVMXnAQG0hhmy05qiGTZ8Q8ZNdwoYMdiGpkeTd/mLaVisVJsnnrAVmM?=
 =?us-ascii?Q?hlYprUs7yGyL2noMOxgwoxLfrUhVQ1rHiMLa02SrF+tG6WLgBWRsgciux2g2?=
 =?us-ascii?Q?oFG5railicQhPHYy7omvFXc3V+77TXtIa9cPsh6iYTdih4P2rj5fJHpnXJ+l?=
 =?us-ascii?Q?DGDENpdgDxhb4bHL5Sn8xUiTzFmMuz4jev/k5tjK0XTzRyMAbQHhpqQbihFM?=
 =?us-ascii?Q?xQAYLKYxQv/6X2eVINh8NFj7ZRVIe4EXs3wT/Cos6vdTcp+9dqkbtfDkoEAE?=
 =?us-ascii?Q?aioZGw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1eed4f-a8e8-4d17-0bfb-08db2b15b8b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:40:49.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qQHIgK1EUB8Vqv1VakVDoX3hhmlNQuaTAt9/C+OvB43mFhSpER7rzNs8tyKF+/lEzxiF+FfDzAzE7MKc6OD8lJ/1sc+gg84HB+2Rpj9Z0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4143
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 08:28:55AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/wireless/ath/ath10k/ce.c:88:1: error:
>   unused function 'ath10k_get_ring_byte' [-Werror,-Wunused-function]
> ath10k_get_ring_byte(unsigned int offset,
> ^
> This function is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Hi Tom,

this looks good. But this patch applied, and with clang 11.0.2,
make CC=clang W=1 tells me:

drivers/net/wireless/ath/ath10k/ce.c:80:19: error: unused function 'shadow_dst_wr_ind_addr' [-Werror,-Wunused-function]
static inline u32 shadow_dst_wr_ind_addr(struct ath10k *ar,
                  ^
drivers/net/wireless/ath/ath10k/ce.c:434:20: error: unused function 'ath10k_ce_error_intr_enable' [-Werror,-Wunused-function]
static inline void ath10k_ce_error_intr_enable(struct ath10k *ar,
                   ^
Perhaps those functions should be removed too?

> ---
>  drivers/net/wireless/ath/ath10k/ce.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index b656cfc03648..c27b8204718a 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -84,13 +84,6 @@ ath10k_set_ring_byte(unsigned int offset,
>  	return ((offset << addr_map->lsb) & addr_map->mask);
>  }
>  
> -static inline unsigned int
> -ath10k_get_ring_byte(unsigned int offset,
> -		     struct ath10k_hw_ce_regs_addr_map *addr_map)
> -{
> -	return ((offset & addr_map->mask) >> (addr_map->lsb));
> -}
> -
>  static inline u32 ath10k_ce_read32(struct ath10k *ar, u32 offset)
>  {
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
> -- 
> 2.27.0
> 
