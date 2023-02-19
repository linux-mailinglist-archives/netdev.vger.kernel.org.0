Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC8069C090
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjBSOOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBSOO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:14:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2120.outbound.protection.outlook.com [40.107.243.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715B3E3AB;
        Sun, 19 Feb 2023 06:14:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0WgE41rANmgQ8puTBvbPyK+BTPcyIfwahhj/lVCIcpp5sjpBc6ayq/GBOngfnHEn1m5APFy/YEoDokod9X/R0TxIt9qS8foQ9pMeKbln/MQAte4nZd228Pxe3KPFMxBKbKxNc3OMngGsI6c8+UTPYj1nZLtx8QGLj8zGwqj0eK92BoCppgJCN5gaL9X0IMqgMY52gXDtd+rsMCj3L458pOYsN/W9cEBTFDdzrSI/6HKG5yUt/kGTRN0t0/rCBhiacZ3b2vnrH/Yuict6BX3I8GqJE0KpDJ2JKY3fZAPjPNYMRYocX4pzr/yPdQvW39nYh8p8tMNlry8MZ9GmMzekQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipE8eBpIMTkekG0hG48TixHNphQ6DYkDmNk2S9lKvwU=;
 b=kx+pbUn5aI9qJ/W0B5ysGkq21+9H2hvIxUs6OKFrijfDpIJeAAnitMwHbpMjRWQLn9oegNCbHttGYp724/lRZ2VZsnd2ou/+NF7p8JyhskletPPJQkFwys1OhH0BPJNrkn/IY1KAtgnailbsEdcgCW3S2sIsdIRuWhFBoan2LXIz7Hyla/Akv1/2o4wxxY/teujaNvvAwQzsn28vESvsNrehI+qHXaqa5MSxtRjRSWykwU9ogM5tyFvJvHfwQUzKNdH0uVYOGLVDyjOST474lXoge6z0q/u7i0TMkjNEX4MN298OPv/nZEFWEIpOLBxy8Y/N2KOrMvUeKhnk0P92dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipE8eBpIMTkekG0hG48TixHNphQ6DYkDmNk2S9lKvwU=;
 b=s6p+WVQbBdBk6WsmYEFHbgHWjRoChyG743RevIO+LjRKWrr11bMw0VizdpXsAMzgtmbA4RZPzi/oCK9qYqZHnMuBuB6tJMIFZX40wt8t9DYVLBCyQthg2U+3bzrlWOUVkhbqJUSyrf16xX8zFMOaNKW3LL2fA9RbVgvA4fNMUVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6152.namprd13.prod.outlook.com (2603:10b6:a03:4e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 14:14:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 14:14:26 +0000
Date:   Sun, 19 Feb 2023 15:14:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] bnxt: avoid overflow in bnxt_get_nvram_directory()
Message-ID: <Y/Iuu9SiAxh7qhJM@corigine.com>
References: <20230219084656.17926-1-korotkov.maxim.s@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219084656.17926-1-korotkov.maxim.s@gmail.com>
X-ClientProxiedBy: AM0PR04CA0110.eurprd04.prod.outlook.com
 (2603:10a6:208:55::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: b18f73b3-d001-49de-830d-08db12839b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cphAhUp6eKwGJF+Jb0pHaJ2yUBVqnoCp9eSZx10bV+SeYP/K1bplaqEAx+xUS/MFO4+VbFM9bibydkrvwqswBap3ICNZ02kbMucoUdyhdDWzXHm8YCdq8wCVj9FSuYv5qJOiMkjvK9+W2lSP1UQIr6qQX14+m0JRC3GUy7Et24T4+w70uTokCZ6cWotNck/5YprSs60gPMQx/j6H5lKyDAXIln3pE8CFtMrIQ0Z4pfm98kILfxCFNSeFkzC3N/nydFmXcKpH8Mg+2Ife8OZ9BcTvDEqlCsPraFs4z1mG/tH8sWAYbPmIpRjidIoaLF/YvCwwk1Z7c6B5bDDd7PBsHNUAfBiS21XdR57NRuwOl1AWysI1XNw6WJr6I+PAeM6apkUnWaxLd5EejBEOUaCDuf3G5xRqh5Y2FtOAgU1I1zNmLrXglMq41HhZ9YgY1ymOojw6uCW4FJxwQkQmCYtu9NYCGynW3MlKz2ULyY5NJjoDcZkn5VG6q0Y2k5PJflylOUbXXwaZVVjzY3QaqCRS6woTbb7frmcFYQ1olBTVM0zEecd9VdP9QfG+DlapUN/JxkWgQafzRA92nWsUKQe28tIn95llQ5rpH4f3F4Drfwmijx2EdP0nE5lyIFFP+OURzIavfmRrnRJKUl84WStfOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(346002)(396003)(376002)(136003)(366004)(451199018)(86362001)(36756003)(2616005)(6506007)(478600001)(83380400001)(54906003)(316002)(6512007)(6666004)(186003)(6486002)(44832011)(5660300002)(7416002)(2906002)(66556008)(66476007)(66946007)(6916009)(41300700001)(8676002)(38100700002)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oI72xbgGgXFxW3Fey7Wmz3eFtfsq/45Rg0BwbVHteMObgZO2sx9cjtiSvgYZ?=
 =?us-ascii?Q?XXTg0j4LgX7KURxARZOV2xACfwuDbEul6cA835MvpjZ4LrfWB70Cw+C1gKSP?=
 =?us-ascii?Q?NcIvmt47wwp6t9Grngejokvl0oyQvJfT3ZrxxhhJffUQ+h+DrvinWoMQVgTl?=
 =?us-ascii?Q?e/teJ/C9RYKBnm9SfJsF3P68domuwX8tzGEvQLJHRNBniZ4nStV0XFuJOOT3?=
 =?us-ascii?Q?e5K2vjxCEJF6LQXkbLs8yFXxIuZ1qUVOIdNKwrT2PvOLC6x8aj5daHuAvfob?=
 =?us-ascii?Q?tt93uM5yJHISNNyAVEUXn/cUdeVk04SQaU9mITYq4XR4S912j+DvBbkAD7md?=
 =?us-ascii?Q?+ueWzD8ny/bXb+ZLmN8QLqDVlnmacnE87Do6HNM+YGFz/NMLipuc4MBfxLk4?=
 =?us-ascii?Q?wj+BTjkCD8Va2IXzKj1J9NhF9FBFv3/w6+vUYmu1vht3zw2HhaIMIL0QeYdq?=
 =?us-ascii?Q?hzTS6eqJEyrajtHSXGSpsO+o3MQXfzp/1lRfASrB/xVzSi7O6RV9AjCkOIKZ?=
 =?us-ascii?Q?WLoxs87hW6BWomIbL6xEkTAIQqv8OlBYX4DpB67CK55MqWmeuz4CQ5tfgSGT?=
 =?us-ascii?Q?AmNXgXH771cYHHZzE6H4a2lE37T8IX806U3BIsus2I88ute9WCbBxkvTbw9y?=
 =?us-ascii?Q?Crxmrvymf5H9NjOs58N4oQ4w2kbOQKFNY7cNTopT3DhOcvO7QVrEHyCszBKq?=
 =?us-ascii?Q?rjVuQJ/Zj6zNysixkpebCO7I1gmHqouYLl9hbo6hO8glXRY73dVFpbG13nuH?=
 =?us-ascii?Q?8WXLlZohyoUbp8NkAomGP8O7M19LUWXpUxSfCWzWz05k3CzCItIR4tVbl9W8?=
 =?us-ascii?Q?2GmATnjE9fNPQzTaDQ9nRRdmETUBEJHP84zFlcQQ9kXapf7A5MscAQme/ZNT?=
 =?us-ascii?Q?CvWIIhjOD6BnTLN9Q0NdGa/F1nEA4CjhFbelrGNzBD8uUxlDOUWoC2klQtz7?=
 =?us-ascii?Q?fSPm9Da7cGsZPKBiPlR3bBRLgz22RGQvKWeuBSmPR56XA1ycjORacoVyocb7?=
 =?us-ascii?Q?ND9U9PL85qL1bMTYPjSc0bzcFXxZhi1cQ0Li+wBOM5wbtaeA1OL/X2NzELsr?=
 =?us-ascii?Q?72/NJ85+pUr/8fLYHgk0Y5DzUeapduAC0Hu7W8cTxB3KpsSixOCAx2xOmhi+?=
 =?us-ascii?Q?SRoKwLHnixYFj+VBX9xlFINrLf/Fl9eVUIZxcuy3BfMp9ttby8SzPQbP8+kt?=
 =?us-ascii?Q?Cgf1q8v6GfZ7iQBFVSh20lRcPHVPVIR+CANmCOMkE/ik9PUpj+UlTQ2j/T/p?=
 =?us-ascii?Q?QCViFWDsjoHqeKVQQmszHvqtV4hnhtW2YySQDiC20cZ/Rh6fu+5Y/DVAlgoM?=
 =?us-ascii?Q?1Uoflc+uEpoddRVbDZTFoWH+QUVgj7RiL0j106FK8Nx2mlJFpf8jOyCnRdqI?=
 =?us-ascii?Q?IVB5YQ/Rvd7UH+6A07r2QIxdoTLNJcsJa5a46McZznEa0qGEJO/zoPPhjQAt?=
 =?us-ascii?Q?4wX/dlpazHgHgfkeNqwcmaNB7Qx/cNDV0Q60dumyhKPXnxRk8pFee57dxodK?=
 =?us-ascii?Q?hkNUqG4Vei6hrXktblgT/56XbJxVlDvfcxtv5Qv2QTValKBfT0gkLDz0J/sT?=
 =?us-ascii?Q?CIo+DINdWopUMElDws+MUBEZL2mxfWDSvbvaRo6kYJffuHhWKYONAG+IvH9I?=
 =?us-ascii?Q?qr8Ra2H2ARy8+tGQoTo3o11dHyrkQFuVjTQc/jGfE4nOQzNQ6SyWbDASIHIZ?=
 =?us-ascii?Q?RMoWyQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18f73b3-d001-49de-830d-08db12839b51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 14:14:26.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79zNgAB+eFq79LSe5bAyer+1nKpx6eKKL8mkPf2btA63/xQRcsvmmBcfsxBnEYeGK1QLQYs4NTwWG44x3FbbM0O6lpmGBKpI1df+UzGUl9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6152
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 11:46:56AM +0300, Maxim Korotkov wrote:
> The value of an arithmetic expression is subject
> of possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Security Code and Linux Verification
> Center (linuxtesting.org) with SVACE.
> 
> Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

I agree that it is correct to use mul_u32_u32() for multiplication
of two u32 entities where the result is 64bit, avoiding overflow.

And I agree that the fixes tag indicates the commit where the code
in question was introduced.

However, it is not clear to me if this is a theoretical bug
or one that can manifest in practice - I think it implies that
buflen really can be > 4Gbytes.

And thus it is not clear to me if this patch should be for 'net' or
'net-next'.

> ---
> changelog:
> - added "fixes" tag.
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index ec573127b707..696f32dfe41f 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -2862,7 +2862,7 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
>  	if (rc)
>  		return rc;
>  
> -	buflen = dir_entries * entry_length;
> +	buflen = mul_u32_u32(dir_entries, entry_length);
>  	buf = hwrm_req_dma_slice(bp, req, buflen, &dma_handle);
>  	if (!buf) {
>  		hwrm_req_drop(bp, req);
> -- 
> 2.37.2
> 
