Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD967F97C
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjA1QQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1QQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:16:50 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2120.outbound.protection.outlook.com [40.107.212.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D8018160;
        Sat, 28 Jan 2023 08:16:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaH89ZQIPr89Ngs22Zycb9HhCXuYAyJHb4VjhNnOw2mdAbupbfG0Q6C5wyZsSKoLgcxMx3xBsw/QkVBBwptQuTaOIipgpfZcSlPymxVa5xheocq72gekL4pO7pq/qqNnMy6//qB6PWClDXVQO7v/8nsBzkJ8Ek/zzbklitaRf8C19hRKtw5BTbTCyYLlaimFsR4sLYqKvmoFTlz7sd5mHoj1Ucu3k/IIHcB/gPp/fh9Vj+LY85+vEzref+mri4812btVvaVdGo76Lr2YYwahlaDraOKxw0sb66YkzWFOx7G26eyYCzPL0WFyxBkoJnh4SytoIleHhhSwm6UFUvG+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPo2d71h3sxt+ga2lJ6vP27Q95yM0nhRFYmcbmjOInw=;
 b=MXoVmXgysJnRm7berRsgeAfa8YXPPzpfyaN5yG7DXNR3MCTqzLLGuHDD7rSeOTctKsxmN2XdvjRL/bJD649NG1szcuSEvct7VxXhfV/QL+rNu+w/GMunXlf/mVd93BmL60qF6WZjhw8ZIOrSG5eV8nHB9P7sDyt3mOncSkHY3Lp3orcM2IQy7iPnTHWNqaF4b1QqHfENFBi0E7+mBWn3MTOdBTQj8A3TLdT0S8ORGIuLxvYGQTArDt/BbKBaFS6vpgzN2k8seXA1sUrLL3zgVNcQtcFAZJwYEKRa4GG+ZrREP21pw040pVvhWuriWfUm/kBu0iJ+ILyTf44dKD34Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPo2d71h3sxt+ga2lJ6vP27Q95yM0nhRFYmcbmjOInw=;
 b=VuHbcCMsz7g89eN73aJReinkQfCf57T2ZYhjMTOCwKAjaXHA+WjHhPKM7ljpNnVapfwjyI5eeASOTji01NH0v9wXXxYX6S5RTlJ8yNCEwJElcKwRBuPSxYiYu6f8sgIPIdTj3mt9m7bxx47COyRX1NqLP8DjlqXzOLpYuFBfgq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5988.namprd13.prod.outlook.com (2603:10b6:510:15c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 16:16:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:16:45 +0000
Date:   Sat, 28 Jan 2023 17:16:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH net-next] sh: checksum: add missing linux/uaccess.h
 include
Message-ID: <Y9VKZhCOdM4L28UA@corigine.com>
References: <20230128073108.1603095-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128073108.1603095-1-kuba@kernel.org>
X-ClientProxiedBy: AM0PR02CA0149.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5988:EE_
X-MS-Office365-Filtering-Correlation-Id: 12dfd87c-d226-42a1-8eef-08db014b0ccb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ao8vkiB3lfqZ173JZflQUj4r8ZGGfC37bm6C5X4Lk1+rEFIVIPylihFUIos2taPyRxlAd7+OODKRkstZnWtAIysp184mq+hdDDHgf7Pf2OstFlQ0vmRdMAySuXuE6eVABXFeRGAdWRMEpRV4jHCHKj7fCl31oHtZM3Pu63c59CRVSyz9PHlvkcYejvZ2vgA+d5M9OfPZJr708RSrZ4EjnstvNiQCaCn/hn9BBHwy+srTcaxtI+KlK50owHXs8fIXj0s4STfMoeKGmNPx1yzyD4kmrjhxLNuOdfcKrxCztHn0shPzlNikgz9npl430veNNHnUMz6BCt/KSYN76G9D5RFy4FxIAaOPfeFWeGT4itcsAinNJss+k99rX+xGhr8m3P6wOqhV5PtTZutNFxHypwteU4TOFuWd7R+fI5v81BamaUFcnEvy7kFvPeVZoM8GT9rsVsfnCuMAhB1mNE0ZMGV08sUAz5BrBnsLN2ZHnju+5lcrn+dbHVFzj1LsbAqvu7JbEOrpfHCetoyc1NWspwoi+ibk+dDiESJg4ottHv2mxho5ge8TlqD3R9y+Z5QiTbhbB4HWkxv3GcP8+5wFqLIxwL/s6kXDZsHpFhWiJKeiBDushSs8UsaeIDsHYGqWCxDPAm4xVCNN3bZtOQlzpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(396003)(346002)(366004)(376002)(451199018)(6486002)(186003)(478600001)(6512007)(2616005)(83380400001)(6666004)(41300700001)(8676002)(38100700002)(316002)(6506007)(44832011)(8936002)(4744005)(66556008)(5660300002)(86362001)(4326008)(66946007)(66476007)(36756003)(6916009)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FG2qcGA73g1SMymNf+m8W3buJHcY03ARzh86Mm/eRokoGePvtvcpKn3O4E2J?=
 =?us-ascii?Q?hq5T3ylyMapDJvby4y1n0ZD+4BLSGLXDl9Iue+L6gfI8lAmfWK/HBp7RfxA+?=
 =?us-ascii?Q?fCNTFqoo7dqFj0T117etKBboSzgJzrCGx/8lqRbGE1MGkYsKueCyNEMup4g7?=
 =?us-ascii?Q?1wxZ5hQMnMXO6c+pNMkm8elMO9yAnDsmQGLMc2wbWw7kjK+TJwFTtgkKs1aY?=
 =?us-ascii?Q?zKXr7ZHsIsiOUNDwJhYxWiCYZ9yOunlss2TfyyN3bu0jEDzNB573TyEh3aA2?=
 =?us-ascii?Q?Ht1OvpIKewkNGlR8yaQVHmG1afITZzMqAZtBPaeV1HhxDcrZvgKFVoSnvRtp?=
 =?us-ascii?Q?vRQLJ9oCdQxhMAXQBT0kzRYKswzKvfvIqQZhZXI3urxkJQDe6ma1Vu73jXNP?=
 =?us-ascii?Q?kYDGm+Vjz+zIJBizDXUxgurDbupAJY6Z8kaHhXjIFaCD1a+6P7pxtKkf+uBL?=
 =?us-ascii?Q?dErHTwPNyNebLc64GWIGXdvBecRT6NT5tNjr7gmJBrAV0cL7ELsxqr2uxbAw?=
 =?us-ascii?Q?0OL2vwJCbXQa7jODEbHgX9TGrzjoKb7iaxryO0DwnwWyyHrODn22dvSbG9Uh?=
 =?us-ascii?Q?ZrWZkMDA36dDVSYJJOicEb7tWiD9Fgk17yS6xSnDkciBdg65M17XTUh/kbKg?=
 =?us-ascii?Q?p6wDijFyvEn3huKLWeV8Mxg15k9mN+cccq0ATw7r5xEh4I/aR6jnelXtlcQu?=
 =?us-ascii?Q?ZdAn+I2cx+r1Ep0nipgdpnSp4/EAKRXIau9SCK9joJc1UH8ExQrhk3V2FcO7?=
 =?us-ascii?Q?CfRtkCqInmTQaGypV+dBq/Z8adsgw29ngJ2spTHuT1gjQflZSrG2kWPX4xIv?=
 =?us-ascii?Q?4TxWiuJl8giDUUmAUbyS60/WmNl1y9hFw094oZJ+ykHLGnMVpSBqAgi6Siez?=
 =?us-ascii?Q?hq7TtRlVzLf1wsNhIJton5TM09lYSuaGaBoauC2u0Gwvit3Vf/0N6NL+lLi2?=
 =?us-ascii?Q?bzRL2wOxWd7BYHoaG4pz3UW3LLMvlk8RhRgzc0ueA+4MFF3A6TrQcVJRJ9pQ?=
 =?us-ascii?Q?Qln3sP988WsvcPyAET9qrg8zbnqaUH0vTIiiNRg3QwS8o0IhKsaJmyKvIXKx?=
 =?us-ascii?Q?iw0BPs8nLM+ZcXsOuLX6yYHW/r/Nb7zFBknNcnUugGlkq7NoNzvpfVGlAgwA?=
 =?us-ascii?Q?BSQyTVHhA7CvVL+Sleq/1FsAFq+nSYmM8LIcOiB1fBppe8xyTyb/X9sLDY2M?=
 =?us-ascii?Q?YMp19x2t9T8470tNwYHWhyjG2FvFvwuNiacUZ8T8siXC7KfSfWjdWzhrYBkY?=
 =?us-ascii?Q?6jalohxS6fw0m/oJlaZS7E1v6k6pNKwo0Ty9E4XLMnPpjLH60TZS+vHuP0Qn?=
 =?us-ascii?Q?dtzKEIriKSDXuQx7T59AMMsehoyoMfDdsmtiyRocAMsAXk2ntap1fOcDgKSh?=
 =?us-ascii?Q?u9+e00pNIU0ZYGU2v1aLF5OhwxbBelO5rHOuPyx1DY270tXtD+BtYOmeqNrj?=
 =?us-ascii?Q?tHSEinp9Fd/O1M1e/Btohch8fvxF8+BwmqFKvX93Mdkyz3mXl7yWEP96QCmJ?=
 =?us-ascii?Q?yiVc/BxRsUE0WsxxCq9/RCUAMYfguE27k9zitYCmvgnLwcEhxWVygy1e72D0?=
 =?us-ascii?Q?jk0clzHucRgyF60aTmeGr/H0htI8GM7VdDM5ps2G/Hc4TKJQB7+Z0YBIyAAK?=
 =?us-ascii?Q?CitddNBjvUPBFE0bXIzsK/nSML4hnMtuL+ftBP4yGvIjwt7L7oppvVURNsv4?=
 =?us-ascii?Q?uQD/fQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12dfd87c-d226-42a1-8eef-08db014b0ccb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:16:45.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtxP0hXthHvor2BpRonwSdIfiIgbPrfB6hjYiWMvMoa8fKluT2C7MAcLn37aeF5aYFrIkXUtuiYzvXClnHVbqFa90kt2ia9kHpq0yNPumsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:31:08PM -0800, Jakub Kicinski wrote:
> SuperH does not include uaccess.h, even tho it calls access_ok().

I see that is true.
But it's less clear to me why that is a problem.

> Fixes: 68f4eae781dd ("net: checksum: drop the linux/uaccess.h include")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ysato@users.sourceforge.jp
> CC: dalias@libc.org
> CC: linux-sh@vger.kernel.org
> ---
>  arch/sh/include/asm/checksum_32.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/sh/include/asm/checksum_32.h b/arch/sh/include/asm/checksum_32.h
> index a6501b856f3e..2b5fa75b4651 100644
> --- a/arch/sh/include/asm/checksum_32.h
> +++ b/arch/sh/include/asm/checksum_32.h
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/in6.h>
> +#include <linux/uaccess.h>
>  
>  /*
>   * computes the checksum of a memory block at buff, length len,
> -- 
> 2.39.1
> 
