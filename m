Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB76E69F0F6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjBVJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjBVJH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:07:57 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2B37AA4;
        Wed, 22 Feb 2023 01:07:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8sbtafO5081R4SjIWGuPl058gOQzhMXFGrsLmVnGSN9iBPSsonRvImKj/sJ9nwv2mMXBjThGGubgHIGIv7UFZHvan8So+BDjcsxT8+lsavvulNXMXxYe565/dfJ9W8yz5pNG2K2fzzYGJBSJ0ND32IoaLuA9lnua/Ky7KPsc/zhJooPuMW875oSkSSyLnYLrUYg2BO/6rS/U/R8D99u4Y8IzlMbwj3TVRWZ6BeeCmpCjF4kXx6IaSaykMjkudPw0xSBB0BMg/YbYsBRLIrJNZlthDBX8ErgGeAoZ2v4i+Nvrn+WF7GtvbATtVPjFjlQtzRkvJBTmz2LwnUkL6hV9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMcgoTztx10tfQxEo3kMi0a8Z05NH4i4k7m7ua8x6IA=;
 b=nNRpLmqw7QIKvEzOrhJGFK9cIvcejp7gczYN3cBk+EchY9XFxTTHZZNBB3eOGv3U/n6kM8cxSWk9hE2LMWtX5rrSVuI2g2RxkFk0BNiCofRYin2cfaUd5ZSdK0ckAcfBCu5UHQda38SnYb17fo8poZtNSVoO68ZOZJcpMT90Ys0s7frceCCApKUMBA/iAj2soI3t6qVOM/mNpOPRgLa18igA5OmcJyhE4BvYHABRtMULRM0ZJJpP129KT4V4bYeaG/RKfdGtCTL0La0LeMHnus6n4lUSotdfXqrF6/dWsnTj1XQSgw/m/p/bCGbBkGmwWK5TsGnixvDd1OMvZNTrAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMcgoTztx10tfQxEo3kMi0a8Z05NH4i4k7m7ua8x6IA=;
 b=njCg7FQMw1oMuCtV2RaWKNKXFRDmoBJy814eruIs9pamMjiCicnP/2/aj5js6GRINce+S+XaFbeeq/fjOvx4bCYJs1vkVmep4o2wXnv1ue1CPCbbzWHBHsIaX7yCl/vt1/DpBvMEDS3xKZqitM8ToclUCo32HR+X+/demro93j4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5409.namprd13.prod.outlook.com (2603:10b6:303:181::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 09:07:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 09:07:51 +0000
Date:   Wed, 22 Feb 2023 10:07:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V3] net: stmmac: Premature loop termination check was
 ignored
Message-ID: <Y/XbXwKYpy3+pTah@corigine.com>
References: <87y1oq5es0.fsf@henneberg-systemdesign.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1oq5es0.fsf@henneberg-systemdesign.com>
X-ClientProxiedBy: AM0PR01CA0130.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5409:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf60fee-3a18-4792-739a-08db14b446a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttMUE0ckIbB9Gv78iXT6Nfe1bLQ+SRnQ+lLz6UvMfBqg0yaUUYD+fRqHX6ALnfbzEK4QRf0kHYBwogrQKFH48gr24X4rJwXYXBu0kVOaK7KCDIwiyUUfvknJxSSFEwDHbmYgQTPO7TAi+10jCA90XJFJTAl0BCMhI1MrW1ot+qBPiy/Bh6VBxuOpQoxo90ZF4lCLWvpo/7X5pIt5qGVKMqasoYhqClKm2Cz2jnv7UvJ2X//Fc4bTNNqNBj2vaakLB5lnKJ9gOYNR7FpmgZOxFtgDM1fi49QOrTtminx+O+0dHJthmHKQKzhe/UX2r40n4NcCZnzcju5WQPTKsIpkshpUTEjZCWbccU2YE38TZH3r6ov430ceONHfhiv02I4MuMsq/iSV1uT0ga6f/9J3HAVoBOxHRTdSdeMCAN/KnggKdq7WTgZLIj8AB2kZZ1jTa7vI6eaUV7Vbl1npvqngGBQhcyeAroUNkOG2RffkBYujeem9UU61w0QGCLeFVuaeZQA72mDFo5SpYy8Nlmgk5jnfdvfp+3LgoaXZzPjM0VeVHdrQuJ/Rnp9DV9xd0wDQ5MVcc5CFko+J1Wz9hJKqiGiif8GI+gPK1OuVBmFwtTxv+CLTVfm8Kk0gyObyJc3oFsCC4Y57+02IgXb9hHW9tAjQZNP6kJF1E0HLzYb3ZiT6R+7R6parWzlavNhbSLwg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(376002)(39840400004)(396003)(451199018)(54906003)(316002)(41300700001)(5660300002)(478600001)(44832011)(8936002)(7416002)(6486002)(66476007)(86362001)(4326008)(66946007)(8676002)(6916009)(66556008)(2906002)(38100700002)(6506007)(6512007)(6666004)(83380400001)(2616005)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gtwb645PERWIJkkL5WIDMUDg5vby4Fs1xNrpL5ZD8pdbcelBilnULJ/vsjZp?=
 =?us-ascii?Q?4mTn5qBLZPjrzbZVagq3zleVznpDHHciQ0+eJMrmm/vcPAzV1ueHPCTv0oKa?=
 =?us-ascii?Q?u6GkxO/eOVDZZnoK0NFcbsbw2HWAuFgQow6/laExoPB0udvSyiuR9VC+FezU?=
 =?us-ascii?Q?1/M7tj/kCs5y/q7qprw1/DhMuhu1VUS+JdOse4JX4LE+A4BMc5+3OBu7RQOX?=
 =?us-ascii?Q?HFBojgTlGkP9kq8NCin6/MCj4NgxwRoLdNoO3cfLTCgixeMAmlpX59uhfH1f?=
 =?us-ascii?Q?izPDr+0ewfX/3ENox8t97gzGTK9UmIjr1IZbQDg02d7Al8JaoMPyi4gtlH8O?=
 =?us-ascii?Q?NkknxMXV5kNb8DI52j8jd+22tvsNRLQmavDtoPQiQeyxnOaY0+leLkPC++ui?=
 =?us-ascii?Q?x+9twfJCNa00R4P5EycVazMKlGnjIK1xVkVTB559lkw5AHYUVVFgcG7tqN9V?=
 =?us-ascii?Q?dNUu9gj9Nmg5h5/jptR0Xq/yYyzgmqId/xgofVQQ2B0wl+SL/HxDhI2Jwh7b?=
 =?us-ascii?Q?pO/TRz2ZmdPzMWx6WcBzaF9FO+FgtC0bCK3rZHSzSa7zdmcuErHu1hO5YoVG?=
 =?us-ascii?Q?YCzlWFz1yKjPbOjh2HXqpTz4yCo/lnOqrriBxUqH6t1+vgavO//AeY5Y+oMH?=
 =?us-ascii?Q?r/lZlkkz8L9Qxm0YUfjpewb4mrCMnZ84Glw3XK8B1OhB4gCwG0rcPEox5+mG?=
 =?us-ascii?Q?TVmeBcuH8HC45R7Uw1L0QgetiHerFm43X2Q/KHaMshwBJtf1oEEvOzP/97jy?=
 =?us-ascii?Q?KcFKQelWz/TKophghTl9DVIZW0ZLXsn5VSmYZD/H0vwpRedhYxnIip6CBte6?=
 =?us-ascii?Q?E9Yo08wwIX3ASWkyaLEvPKrKXJp9PDBf7G/a7b1TqSZp0ylCyrTr2qX23e7l?=
 =?us-ascii?Q?t9QfBmpoSYWtYEyvQ+XKMtbU3uq9wIzZdFZhPqvW3ity5Rh3u9hhVOho61sy?=
 =?us-ascii?Q?FlEUz0NxZ4NTl3tMqclSBNOOrHSvX7sx9udg3XhHE7CMCiA0esM9MnkXo9yY?=
 =?us-ascii?Q?dFs2w4bld+oMWGcTfi7n3y3Hvl16Njy36HjNkGgsUc/SIvgURH31jNlHkY7E?=
 =?us-ascii?Q?p/YjlNoDilgLSemn2ulrLvRb42ni7j0zyWa5kipGorMNVdlghLzmYDNfIsj0?=
 =?us-ascii?Q?6jSFuYdf1XY+d6yWNwZyF2WoVK5O9dXDBJyOXoztQgja3JXXDnLGAE62spzT?=
 =?us-ascii?Q?7Fa5wH+kiQj0ntqK5dfGIE5cyTDs3plX1GIROqwFy7L7muon6mZV1jV4U8iX?=
 =?us-ascii?Q?tLhaMo+gt14fUpK03/eHHiuMcF+5gNP3aJx7+8GcoLuHP8beLRWO/niMYk+/?=
 =?us-ascii?Q?9NJ/uOc6fV71Xe7qNFs0xIIMIYl5hJGUeU6i/Jds4SB7dY1Mo1BvLjV6eUar?=
 =?us-ascii?Q?qT0uP4Ok4PA2U9lZAX2VCtk7zoFoZo64M2Vs/fIklg1Zj6y1q+/1MHrLMrBQ?=
 =?us-ascii?Q?WJoVSHECFYVaQWHW9cmFTb5TNh+kUtSNwDZyGH5yvdbjVdIwqf2n6JTeROPP?=
 =?us-ascii?Q?ld+YXEgwSKALeySoZc69Q2ca0qn8MkYxU4q01Yov/mDClwJKEMqjvtxtchtE?=
 =?us-ascii?Q?XvcIjDW4sRAWTo27B8RY8D3ArgcHjC/hQM6gzUKunsMTenf4tGCuC/nBoQXg?=
 =?us-ascii?Q?MVfvcuYjiB/z00lxd+AIua1LDZ/3S4qGS8CefN/qNPHkGs4gMJahQup0KsTr?=
 =?us-ascii?Q?T56/6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf60fee-3a18-4792-739a-08db14b446a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 09:07:51.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCu22brypHN9m+k43UqyyRSxzPlKJmsHVJGBQti5MhLH0c1EYszAzvQypjCrFPF+IAWL85qjLlMwixqKNlnUipYpSzztNaW7S0IqyccfH6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5409
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 08:38:28AM +0100, Jochen Henneberg wrote:
> 
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.
> 
> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")

This commit was included in v5.13

> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")

While this one was included in v5.4

It seems to me that each of the above commits correspond to one
of the two hunks below. I don't know if that means this
patch should be split in two to assist backporting.

> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>

That aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> V2: Added fixes tags
> V3: Fixed fixes tag format
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1a5b8dab5e9b..de98c009866a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		entry = next_entry;
>  		buf = &rx_q->buf_pool[entry];
> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		buf2_len = 0;
>  		entry = next_entry;
> -- 
> 2.39.2
> 
