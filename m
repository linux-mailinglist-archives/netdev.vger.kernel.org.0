Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BD36C702A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjCWS0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjCWS0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:26:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC522CB3;
        Thu, 23 Mar 2023 11:26:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HN2lUBpy1JtaGCzsM4Rq+K32iJn3PHlTA3Jcw+ZgkFwySqXvBU3FSlQwPnft409fshETbM8XGUUAKuM2mhEBeHWWwh+FNZbgOgDlpufUzmy4DzdgNvT9pHuV3bJgEMxqd0hHhv5SSBb+inlU+0SScVlhme67uyvDSlLUVC3b771T9zxsZvuMW5lJDa699y67GaR83ihjbjC5YkHUSSQBlkkK6y9ne9M8r0NzisbSbeHLgHLkF9qWDtu18FQoxVSqmaLNmYMc7REiNfQzpACVcl4tjKpgDyT5nSiUlMsCON9oo89H1IjRasohtwLE9axsK5bo4VxzjJjnXaXbie3sHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ocy/jIFl3SFKKRqQebCkSmnPTbOdlmdfqjCtPj5ctF0=;
 b=Q48Kubpb56P+EMNp20+P/nn+8AqoQ+vk2GnSWqAjDC7F9bVmJ1ddTIHrzta4/hoOQBHFQoxtf3xhZbF4911Xd84lBiq6AF4wdp6svwQqUwfP1os5OpxMEM+HD93hx8/JrisQTf85nqtMpR6VI5QPWT6SGwAS3HfpW0EqtEcNP1jyTBTFEWy1MlJnEgdYQClG0tkg3jLKvpJjsJalcgSDWH6VuYvzRMMh/oTrwV3JRGm78qzcPjPpDHpJjvNnU0b0byNjJ3pQvCTM5oGL5RQv+etROk9FrAK/hTrpgABz3wLi9hKlgryz9E4pXQCZeYq9EZnZz+BbBlmyQGWUdnzAEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ocy/jIFl3SFKKRqQebCkSmnPTbOdlmdfqjCtPj5ctF0=;
 b=VGQqGn9JBwmEtS8q4dKyxrFbrn8jcx0xs0C9aMWFK8ET+DiVxr6y9VHyJZtLRNxQgK6+lpNLwelT4odhmb1UeW/Jju7pRQi1RqhfpN9CzHecCZYq77IDaoRLm5qgOGt2KggSEc/0Xe0CklOhtrIXMnOVGgnge7vt24GBekAeIXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5477.namprd13.prod.outlook.com (2603:10b6:510:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 18:26:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 18:26:04 +0000
Date:   Thu, 23 Mar 2023 19:25:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Wireless Development <linux-wireless@vger.kernel.org>,
        Linux Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] wifi: mac80211: use bullet list for amsdu_mesh_control
 formats list
Message-ID: <ZByZtOsg8Brvhvnw@corigine.com>
References: <20230323092454.391815-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323092454.391815-1-bagasdotme@gmail.com>
X-ClientProxiedBy: AM3PR07CA0102.eurprd07.prod.outlook.com
 (2603:10a6:207:7::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5477:EE_
X-MS-Office365-Filtering-Correlation-Id: 3056134d-886a-46fb-43bc-08db2bcc0fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0u0vfHBMuA/bf/OEY9kCBmyjXdd40l6zl0tYC7ChJAVYZW+kK+Xj7sfKl5D0Bzgvgvda2sJRJ8PglbpRyeInf8o6N5VW4a1X5UgYB7p/mYKTWVuxsF/QZBT8BatZ12JmwrvlnR9jB9egbU8EFeuTtfiMQVslnSw/2nc3Hiic0rvsmo3xIZRdIFtcI9UY4qh/sVKZ/5jfn0FVQnOfxnwvFlUPb4Lho7yQ7A+KGF4CVSkuaJ7677VwydYTSw9I1j0HWkvOgbT7cUzwGvp+Z6X2dFta56FJq8e+VRg/WjYvWUolA46lTxVkcTCmrdAENBxCre8ohsExKaQz0TeddAl+CohaJBwD1zvDv9ONmVcj8Z0y1LgfrcQmd5AkT8tOmL5rOM4FGmJdyJNC7eZwFPURuO9t/iHSJrctduzFYc/ETCvVILJYwoXT8E/QzyWdWeYof4LIYbwUcPVJJzDjJ+BVI253lBcFsnu2GC2g+UAtUDxsCsyTA34xiCR2hZLG7jFW9GdZ2MKstkWYcQJwvbrwojnRg7OXNJQLnDwGCXtZA0ToIZN4mhY+wyxUggcH5vS6adR+vTIwUCDFn1eefcOZiZAfYcJE0BjNqIsyVikIUKNZnWQ4m0ScTzIIygfeojm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(39840400004)(346002)(136003)(451199018)(38100700002)(2906002)(36756003)(83380400001)(966005)(2616005)(6486002)(186003)(478600001)(86362001)(66556008)(8676002)(6916009)(66476007)(66946007)(4326008)(54906003)(8936002)(316002)(6512007)(6506007)(6666004)(7416002)(5660300002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+S92eoGoXiKuTI18cXLgzMfx+vqjRAmnxMbdjqJ5/tq2mfp4jH+FN7TyVLvj?=
 =?us-ascii?Q?NOhD8GBeCVDnH/NMKxguO2A3DWpGNeq0KgxrMBGU5Odctfp8hROymbJ4OrJK?=
 =?us-ascii?Q?xtVZxq1bDT2biXi6kjpLDpQ5EHA39pq2necOJtZ8I/LRDpT+qIRCDNEyuV9x?=
 =?us-ascii?Q?RCCLTplbPdQuxHhxufnvPuZ2E/TFsYgp9uyyPXG6arlkCNffJx1B1AQYzJKt?=
 =?us-ascii?Q?BfgPCKqN5UncuM8n5tMBC8+vVPA28KuBQj2WkVOCBqzaB1ZawmdHmXhd7kUo?=
 =?us-ascii?Q?uMk226l7dOGf5XznrdhfWXOKuDqwHRVVb82TliivTT7pGMCCoWSQUBejz5Nl?=
 =?us-ascii?Q?+HBMEZBzhcxDO3Z9W0Isg8TkLuAjB/f2Pf8HoARBnvSFfLYEhj+/DRP+Puzo?=
 =?us-ascii?Q?uKe0YkLCnYwVrrTeS9BTwWtZNVe1mYG8FXoSloDpT0JXuGGbWcTDvFtxNjua?=
 =?us-ascii?Q?zVs7P4uDexqCPWuZu+qDKsK5B9KpbxxD2br++CSR43E3hL8h1U33kottVH03?=
 =?us-ascii?Q?ZOqno/VcL/e9sqLe6OJnoUBue+om8he8Wyvmu8+VTVerYbebNDFN1UWw8Kbq?=
 =?us-ascii?Q?FOl9fZgUBqmTWIW9L5/rv/M6bxutL7EWijuFVTRdogbrqmsHuy6oLVe5I+yg?=
 =?us-ascii?Q?04pKLt4cLjw73ZlxDjXoclAlNwRCHcF9OFt550K7hUWxNl82gYKzZsZmBObC?=
 =?us-ascii?Q?92qNYpskEiqx/SvCwdv8XXBC+MlYB+6z4pVIzo0+o6ywByGELbyQAAmVbH5n?=
 =?us-ascii?Q?MKLOTX8LQyicFyKDsNyb5mfdEc4rA4b1Qhth1c1PPMkqved2Yj1X/TxDscEU?=
 =?us-ascii?Q?k20yp/NUDmso8EmMk7j6PvqDkDGi78EhXWCI7m16hZSdBv5Zzb/udMd65dRD?=
 =?us-ascii?Q?NLR8kPhid8VKPMFIH5jrYi/YnTWbZxK/bkzFaKDogH9EgUJs0x3p9vj/Xh+/?=
 =?us-ascii?Q?H3khJehnw9WO3CJHDUbzC0Ur3+wtawAWFPrN9/1EOU3EnzsCIbLUqxgninAJ?=
 =?us-ascii?Q?SNDPokmFGR9TeSlYogW6UyZ1l7XOTnYW9Efb9PKqJJf8doFENrb/1U3HLwii?=
 =?us-ascii?Q?/Aenu3YNxg+e+7VG845phacrqnHlOo3usmr7MlpyWuyGDIhXISkvzXK0M1vH?=
 =?us-ascii?Q?A+1bbFJDsDKj5rttZhpAwA8pdAuOu+FZwFloEAE5cl8foBbZ98li+tY2u7B1?=
 =?us-ascii?Q?enhoMK4FXgZCaArAWvgh4SXdANtyW1zl0vVI63+iZufcS5UdydD2IJrznKF8?=
 =?us-ascii?Q?sMR3W3qKRHG2J7Z574TimklLisiMIkG+XhG+7y6cMJd7QVNhqxgu6MlqPbyd?=
 =?us-ascii?Q?FstR8n35gKOzEG0+J7VDpFask6HAIa029eQ00mj+ZvQRcw1pZQFz+CKmO16i?=
 =?us-ascii?Q?Wu7JUwkVlfyTLQUm+hibrLC6oJJR2vos02ydk8kSlip0D6zkIEIiArADs1tC?=
 =?us-ascii?Q?uupB/5t6Ey6Ud+7QR1tf8MfomocsUvG0O8s+3ZnjA+xpL1KyN3CBWVYoU1Pd?=
 =?us-ascii?Q?/65qd7TOw9dn/yxDWOCIcyPFWpTvI3DzYjX0t+uX8+FmHKQqONiwC82bhN5A?=
 =?us-ascii?Q?ffbrQqS5QIWJUE0+3TbGdLcFsIlnDIflWGGV9WBYCYXrWHSnIPmqohMIot5J?=
 =?us-ascii?Q?J6E/6M1/VRpa/vkdDeJqL2v8CyGxsuQdCieDZi5pfsydhZYNxQX7ulgSy2VK?=
 =?us-ascii?Q?9FPZEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3056134d-886a-46fb-43bc-08db2bcc0fcf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 18:26:04.5058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoIz6ajiFlqepxIgfQHSZL0eQFRnJMHl2Ly6W/83N93715uj8ml0W1GSq+L0+sdRg6E/8GRqmrtO3nHRWyiDQ8SEmKQIBMlTs+F8ePeBiVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5477
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 04:24:54PM +0700, Bagas Sanjaya wrote:
> Commit fe4a6d2db3bad4 ("wifi: mac80211: implement support for yet
> another mesh A-MSDU format") expands amsdu_mesh_control list to
> multi-line list. However, the expansion triggers Sphinx warning:

FWIIW, checkpatch complains about the way that the commit is referenced
above. It's probably not worth respinning for this. But a way
to address this would be.

The referenced commit expands amsdu_mesh_control list to multi-line list.
However, the expansion triggers Sphinx warning:

> 
> Documentation/driver-api/80211/mac80211-advanced:214: ./net/mac80211/sta_info.h:628: WARNING: Unexpected indentation.
> 
> Use bullet list instead to fix the warning.
> 
> Link: https://lore.kernel.org/linux-next/20230323141548.659479ef@canb.auug.org.au/
> Fixes: fe4a6d2db3bad4 ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Checkpatch also says that the Link: tag should go here.
TBH, I'm not sure if that is important.

> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Patch itself looks good :)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/mac80211/sta_info.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index f354d470e1740c..195b563132d6c5 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -622,11 +622,13 @@ struct link_sta_info {
>   *	taken from HT/VHT capabilities or VHT operating mode notification
>   * @cparams: CoDel parameters for this station.
>   * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
> - * @amsdu_mesh_control: track the mesh A-MSDU format used by the peer
> - *	(-1: not yet known,
> - *	  0: non-mesh A-MSDU length field
> - *	  1: big-endian mesh A-MSDU length field
> - *	  2: little-endian mesh A-MSDU length field)
> + * @amsdu_mesh_control: track the mesh A-MSDU format used by the peer:
> + *
> + *	  * -1: not yet known
> + *	  * 0: non-mesh A-MSDU length field
> + *	  * 1: big-endian mesh A-MSDU length field
> + *	  * 2: little-endian mesh A-MSDU length field
> + *
>   * @fast_tx: TX fastpath information
>   * @fast_rx: RX fastpath information
>   * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
> 
> base-commit: 0dd45ebc08de2449efe1a0908147796856a5f824
> -- 
> An old man doll... just what I always wanted! - Clara
> 
