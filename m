Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC96BF370
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCQVDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQVDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:03:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2137.outbound.protection.outlook.com [40.107.243.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A631E9F6;
        Fri, 17 Mar 2023 14:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZAwhWfhr6SB9pcaoXBWxTujxAIe4zff8e/42fCkufU7U7XkD0pmUwFoBG37zs5RbO4zrKIfkWqlI/mQypPcLn2lKm42jxrI+k2WRSGu+wshe+/4DzKNfZUQMzrYFnBXrI2M82xf0UzuoOrEGgw0DzJS4rAvdHI62m6WhM+arCyP4mTeWOIzgFkZpa+1fE2aOylZuLOzolAJou78PjG+qJtS1VHQmhUOjsH7Fs0Gq5gs66+tbXnZ+WIOiGWl+e0VOJGp7eKzmwC4C1Js202jEkjl+lJCZjF9BhEJryvPDAKlBeaGCaZ5WWkMBiw6lNXYx5EWsjWwUJjikrWKAtcnOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HyyLPsXx2yjVwFXHC80u/XYyDnaotTY+b/0mInZkQ8=;
 b=oauobb0Pf+24X+lvf8VD5AiHgFA2dQ8AGMwlXY4FpcnH9V/75olAY57dpYMAmNdx5vsYTX5GQVY5kf+H5aBOht1BFJ6/OKKFnKnn9wWIHHuLqyx/jmD2YhHDoYETe2RJ/vRS7WUaRKeTYewFfsXU0hwc3YRgDSH+3UTfnhBnHEgU5wL93/9OYZnxoKBmT9Qyk6KQmEfmyIEl9iF8BtatUHTI74tt7IEqehSXJUR9slQYkOm6adCJ0WT90fPYEUHpB4wGpoIpnPaXPna+bef34v/2xjvhHo0Q/8yO1cfgrpMNvkOJ2IcsCB138Z8x+F7qwzyuT/oVeFAVDVueh7xGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HyyLPsXx2yjVwFXHC80u/XYyDnaotTY+b/0mInZkQ8=;
 b=mvLxuUCTc6egoXuGunT/Cg/0lvBKz+sWv5rTVhCi/K0XTq6mReEk2bfWbRNFa8oA0X4sbRIU+GrSmCP7pxE6E3UeFymYQYvc9PNu/eCRRCkbPEOiI6YcKzfvbfvQBHg06Gv0N9RJxY0a4Co6l1N/0yi3DGquzwVUbYa3IaftX18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5121.namprd13.prod.outlook.com (2603:10b6:208:350::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 21:03:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 21:03:29 +0000
Date:   Fri, 17 Mar 2023 22:03:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: 6LoWPAN: Add missing check for skb_clone
Message-ID: <ZBTVmYW1IWQA2c7h@corigine.com>
References: <20230315070621.447-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315070621.447-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AM0PR07CA0031.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5121:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb3d8cc-8a30-40a4-49a1-08db272b0e97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNVXkJTm+g4feXPLK4i+lt3d0dhorPPTpwIuMMDMfvi7Pdz/6QYyIg6sNGeA193dr9I2zcxMeMn3m3qlXnzehFlKPgOoeyttgNtmxLnFdYUSgnWD5I7RT/jOygi1meRIknd+mQZWqqpWiExlcq0VZAReY/2F5B9WPOsYQNNLOmBurg/h4azNGhmxrgFDtZ1KLuLx5l+5q5VVBGk9tPKyHmh6S6mQk787ixzPmwGf75hxyU57piXpy1edCmftCfZLOElfgCAaHwSAicGqM6hjNrYCxwInVRbhAgeFYrg/j+AeJzkCHoxmuOyIM+tMMTUdfVzBk63BYLvm7JBOnT+pnMswsY35B4SpqRa8UVsAjfP8iTP2KdCaq4U+oTGAHbZkTwLtgPmZkMrXK3hnV8W/W0JXzIgyrZura2nYMuLf2SKRPNl6AEQywexjjAaCh5+s5+miFkYbNdk2c67jHzr7/IJt3vV5Qnd4BHCwphHUA0ZtECdq5cug7Ex6fomFUF6ypFq97s9FTUIsXruS054+Nxuc+d3A7FJ63nBCGmBsnhmTOkhKt7jjxJzThtBptp06Z4Y7yrvRFs3XU9PfdEkIn53EPFWqeI7TX5HLG1eUnHEASSK7xcgTTHLgTzFtp509Z+d2dZJlazdjXV9m5Rflw5g2C+wVOzvjgiYXQrJo2LiL4C6PrD7K3SKF7sQMTda5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199018)(2616005)(2906002)(7416002)(5660300002)(44832011)(36756003)(86362001)(38100700002)(83380400001)(316002)(66476007)(8676002)(4326008)(6916009)(6666004)(66946007)(66556008)(6486002)(478600001)(6512007)(41300700001)(6506007)(8936002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CFnCHB9jJLqiVkO2NmlRvXYNJ0+T5jZrOKJdBtFxvNzgXOQS78d4C1CG+7Wj?=
 =?us-ascii?Q?k67USaxy+9xg85FRQ2FrzAmQD05X3eK2DOtyAxzFXvUZX4WNClETihOiazG1?=
 =?us-ascii?Q?U1vaFCc5adb8vyZlIrzBs5IXFS/7YlgQZGSJvVGQrFuouUsZs6+KcicIBcW/?=
 =?us-ascii?Q?U5mYxB/ohiYt+BJLrPWRFgTv76aQ542NcSpSLxYM6yJ+L5Rlzz5ygWVXlmir?=
 =?us-ascii?Q?r5s7GmzK0wGewmfZmaHhsjDdbOD3O9YRTcLus6IhTr2S4G7djeaI+yuTS7+0?=
 =?us-ascii?Q?6OEyuy6hYgIcYpG6NOG5Y97gzT9Uqa9AWI3UXlV3sDrlaHQbHf78QzquTXWj?=
 =?us-ascii?Q?xpVnMaZg3leQMxAQsFcdwlVl8Q0TK9W2aOQv7I23vOP24x/Vv1SFzPxXRqGL?=
 =?us-ascii?Q?a18T6y3+X/02dc4rskPVb/1H5rT9cX2oKI4UScHh3NoH6kqmN6QKyFPqNwsW?=
 =?us-ascii?Q?+WpHwk1qL5cjxkeHlodvQbo7HP+CNNDjeZcF0Xc/jujgt3sRVAi8B2gEtsrz?=
 =?us-ascii?Q?j7ofAQIBhTaa2YhsUDAgz5Bww0YeFFonLWk+oHBvdntF+MZhBLOR+9mahCWT?=
 =?us-ascii?Q?nhrxCCuOSRt3FnE1Mk/0HKRNMQ1sUzKxNKSd89h0Xzp0bEIjQQWvrmvR75He?=
 =?us-ascii?Q?DKDa9aiyYDM56M/ET2Jhjkaa8E7rrCMbonGNY3UBpN1HSEaTGEEtWegjM86m?=
 =?us-ascii?Q?c46ymve1O4mSU1THOGTSXdJLnNLd4b060ImWc6mL0PVzJ47390MzAZoX3zQT?=
 =?us-ascii?Q?nNtWoTkEt66mBx2tCjGSCH/B2P6Pn5hDuhZ+DMsmY67gsvLahELzXT7E+3Uh?=
 =?us-ascii?Q?M5HG87OS51J/hm+/od56mKZMeTaxRUuHY02pHFvbhx3N6yT5Kq0raq89n3HD?=
 =?us-ascii?Q?6Adq3VeO15S7PUvreqTfFpswODcAIfdtt85ao16MbfxvsHqu/pBJXAVLOcKN?=
 =?us-ascii?Q?z8Plgdt2LqsyCa11ZWEm66K+WU94Oa0Nk9f2nQKapk7fZBVFY9MWPhh3q/Ea?=
 =?us-ascii?Q?YWEamVuvkOYIynoCvYal/axdEht+OqyAqrbbJyJUIfLWeD1KlQrTkbBX8l9u?=
 =?us-ascii?Q?krSjzeULMqL/hwrEHYNCBDLgiOK+i62r8sKpRgsbJzFd1jmNA9fwmEY8kGx+?=
 =?us-ascii?Q?B3c+GLfq2ftFVLKwDO312LxZYCQVpTjaN2Gdm6nUTzz+FC95HBSmAFXuBCgP?=
 =?us-ascii?Q?MJmlcvAwC0sj3X7K4kkd0CPVECmTOFiIt3HtVKrYv6CIdNEy/dRp6OEBOkNf?=
 =?us-ascii?Q?GdxZB33zdl2PS/S/uTuW/Ij82Y8edFluYdtVKxj47XbiZCSDF+YZizp5Dr8i?=
 =?us-ascii?Q?1rifoKCTyGUcMJtpEHRG5agTTjVTLz/zxiXjbfStfn0W0vQDw++xok5dkVWT?=
 =?us-ascii?Q?9G39xmbdJaGcGHVxZiHWOfiPFAtzQHUFCSEvoi1CpdgTnlhnGSBP2MEfOlUs?=
 =?us-ascii?Q?vWpDjmBzsTFKvsNHItIL+cIaJHuNsB1qPgf1iUETPlMr7+hhv+EDdq1uSe2I?=
 =?us-ascii?Q?sRhi6WF1i+Anj1LHvxlV/ppE912pIgme1Y/V2G/znTao81c4pH1qMBFFVPwc?=
 =?us-ascii?Q?8phUQ5alN0vwKT7ZJTgib5CdI7zPzE9KJoFhlcTJ51i04HG4PTQ+vs3Dfhnn?=
 =?us-ascii?Q?hUuq1lRzwGTOjLR8i9RAuoXpXCMyXIisVVdTAarCliSErckTzpNmXBRJC/Fh?=
 =?us-ascii?Q?oQ2JAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb3d8cc-8a30-40a4-49a1-08db272b0e97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 21:03:28.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PusHlCmqekRLtqIO3I8EaSISKFRmd34UOkG8D2rrUzLHyf75mv1CZ5f7D94+2WDa7bH0GPcUprgK9d4n2ppjpG+A/hpnoDPSzYiOfOBEhxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:06:21PM +0800, Jiasheng Jiang wrote:
> Add the check for the return value of skb_clone since it may return NULL
> pointer and cause NULL pointer dereference in send_pkt.
> 
> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog:
> 
> v1 -> v2:
> 
> 1. Modify the error handling in the loop.

I think that at a minimum this needs to be included in the patch description.
Or better, in it's own patch with it's own fixes tag.
It seems like a fundamental change to the error handling to me.

> ---
>  net/bluetooth/6lowpan.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 4eb1b3ced0d2..55ae2ff40efb 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -477,19 +477,25 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
>  			int ret;
>  
>  			local_skb = skb_clone(skb, GFP_ATOMIC);
> +			if (!local_skb) {
> +				err = -ENOMEM;
> +				goto out;
> +			}
>  
>  			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
>  			       netdev->name,
>  			       &pentry->chan->dst, pentry->chan->dst_type,
>  			       &pentry->peer_addr, pentry->chan);
>  			ret = send_pkt(pentry->chan, local_skb, netdev);
> -			if (ret < 0)
> -				err = ret;
> -
>  			kfree_skb(local_skb);
> +			if (ret < 0) {
> +				err = ret;
> +				goto out;
> +			}
>  		}
>  	}
>  
> +out:
>  	rcu_read_unlock();
>  
>  	return err;
> -- 
> 2.25.1
> 
