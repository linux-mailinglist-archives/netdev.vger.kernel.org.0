Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC726CF1E4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjC2SLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjC2SLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:11:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20707.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::707])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9393F6A6A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVzs2B7MK565jC28pHWZ5twj0bKoF4NNaBPwzeGjGnZu77JvXrF8dPUYj9DAG6WpICrDBPKwHCp94HxfjeHzSRbftOp1jKVmh+jRiWAgUOVXjmor39loZ/9C3IbxBPJs+J93JIfnPbUQvXjVCvGMyideAZaSRbCN7OKfwpEOZTXehVcH3jhjABavDkWLUE3EnpcVcwwPOGaQ12uJN0nB+1rbL1aRGp3lrGlYw7gJ3pHYgiGw4cMmD1KBy0tb5kDIoiJVxsNskyGqFF6t4LIoVRrat6wccRhKx4yQOkih2RxoJZCfm10ik9I65t5rvqzEBVBQ6JUdeOdnU0QGVJTdQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZrmkI+UIYqwPwnGDFBuewmSUNc8WPjTccdRWf5k72I=;
 b=SojxZzKUdn6qIENUziM9MOc/UIlgE/roTC/CpsbBz2NbziPsaWqmjsVAI7EQ8T/YNVAXyCh3yEilhyBBOTJewKYzw42TXkMUIM2OHu2MxCQsvVht6+YKNJ/vx2NBUrdlLjlnAZtbVBiEod4iaveu7FfnbhWyQH9SgHtBzvslw9F3Z5s7qenYnx7xwwzrDXzedinWQ1qQQpm5pdarg+ciReOLQz+bKfSK9m3/1p05cmyj6N1LOtRrJpFLRFtXQMfttKDNG31gnyQqKpruu1h6P0TVmh8yeStHnv7NzbWtSFX1rJqSXO+VqM+y+d3LNnxoadQ1GPVY3isiDIwO5ckXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZrmkI+UIYqwPwnGDFBuewmSUNc8WPjTccdRWf5k72I=;
 b=mASRbSL1ywsc8ge7iRTdniOLhfFGVofsRdBLuPewxD+8A8gAhsVvp4On6KF+riEqPJExXgCSyyl2yUzZNr4YIpt+2FFpY1micR+htgLKaxCxFgazCvIxS5csZWo8p5sx5vKVLWLTVfE9G0dbHKzaywxQvgyZuwDZktVLAfHfvHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6122.namprd13.prod.outlook.com (2603:10b6:a03:4eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 18:09:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 18:09:48 +0000
Date:   Wed, 29 Mar 2023 20:09:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Liang He <windhl@126.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] rionet: Fix refcounting bugs
Message-ID: <ZCR+5p8TGvS+GQsP@corigine.com>
References: <20230328045006.2482327-1-windhl@126.com>
 <20230328191051.4ceea7bb@kernel.org>
 <7e193767.4214.1872bf50476.Coremail.windhl@126.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e193767.4214.1872bf50476.Coremail.windhl@126.com>
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: ebc9bfca-2d4f-40b2-3d13-08db3080c883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vUSabuBZ64o5O20msPD6URNKTx7XMnK26a/55shMrcQ+B0TZCMjLl0m74ejRClQQVlfQoMW16lB32xyeXT31OMWS8+vph9Z/vic6v69JMMq6kj9iKXDpGRP9llQVAB58lRzCvZVFSoatxjBhSgz02Diu2eW855NWnH2DBkgpZ8gGdH+x9QGnj9qpL1czbiCDZgu/5TB7PJlSMiCD+BjdPZr18cyhry7HCLtj8s20yR1sGCjLharIk0HukTzP8RvQ7O1TaQDud94RGVyBJNN4pfR7Y+ZOALw0sKQ7kUKG1OUbl0ZSzmN16rpyUcsmXEN1AblmvBK/QEVKoz/X+nwQNtOQgTqDAKYuDN/aYCd0g5svluZo3hgpTsfTnaOQq2Ek62IlCVKLsksrITBrETfBoUsImffUqBJa3bV66gG6KUZKmXI7Pm06WxbtXH9YeVlyAY5JtoQylVIBPSSZUWtX4dqJikyrKPSsoceu1Ub0i3yhrGpY41CLHAoiFfA1mYjDfVD4KLI2kziVmGSfwLyRkI3bIEnOBstAnlr8wpfqn6tLypL6SpTtrtWucq+iNunUpvo2NnPJq8tkQRRFsL1+ZVlFnOLpU2d8V5nVHQbhSLw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39840400004)(366004)(376002)(136003)(451199021)(44832011)(41300700001)(966005)(6486002)(5660300002)(2616005)(8936002)(186003)(6506007)(6512007)(8676002)(66946007)(6916009)(478600001)(4326008)(83380400001)(66476007)(316002)(66556008)(66899021)(6666004)(86362001)(38100700002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSMYnbeJ4ZZfVm9+oTVzjdax/lecPtApdszgsUMU6OGFNz1PrsfEpv6oR1KX?=
 =?us-ascii?Q?5fQBP7JkoxiKwNkAlm4xTPgZlXJdC4IT1y2bj2x0pFwX/gf0ghjZZy1d2sV/?=
 =?us-ascii?Q?Em/COoRqY5lOgZO/n43EDWEe+ddbY2W6EMLvFOzUV1IuYlb+2+3n8d1x+Gmg?=
 =?us-ascii?Q?buqSl1O4n9iBFWhF8dXfTXxZ/zGe8jpm5gpRdXOzMaJjWva+1z/pR8l7lqyp?=
 =?us-ascii?Q?R6MODQ0BWzH7KE9TVJFIfptjDbLGJ0UILPlg/OFRuzPtwnDZCVoSr5YWXLE5?=
 =?us-ascii?Q?5qC3fgQAA/ya/trBk8BsfGADpRKCYXATZ3omifvPz99qvQ6pSsR5PO0SYmbB?=
 =?us-ascii?Q?3Zi5EHWB1RBo6BGf7qkNEOsLcBuF8p7X/439v1vgITijKPzqq8eGK3c3npqT?=
 =?us-ascii?Q?D0lC8Es6eW/ZXhFa7Z2DqB95h5iKyAeDoX/iTdbKxFahgfxXUTVL6v0rECax?=
 =?us-ascii?Q?B1ba55rJ8MaV6RJmivD+U/dXnFtjraRsPOzsTA+9JwteS8CZsyjXY4p9dpR5?=
 =?us-ascii?Q?qs6BLuZJfgGkDnWDl8pNVqRHwb3q3OiAdi7kHnz2NpGRjqMHY9uWqvr2eedb?=
 =?us-ascii?Q?IG/1gGPgNcX6H2jNwm8YQURip70exzrrN8A/pcq6uofa6Urg/0MTA0GVL3EU?=
 =?us-ascii?Q?Z3/4/pRGIY6iykvvk71zxCKb9BKulV/O1ngfrVbNS4fxnDwM9ioz0dAnf2IJ?=
 =?us-ascii?Q?yxEGp3GFguBjMphJGxYLYceY7QwOR23I7T0cfDAEeVFk8DtVTfHypB5IX6pu?=
 =?us-ascii?Q?PIG54vENHmRQOc0ktpWrNtg4tkIgkRIH2V9ENmG8bm2MqUzuJ0d0KgIEeXlC?=
 =?us-ascii?Q?z2WYCIQJ424bm+Mk/BOrviDMcUKs1+O55sKofsQx8bd4Om0rr6g4RVBHZicE?=
 =?us-ascii?Q?mG6PU1LRsmGg3ls7nSZKjUa1+ezlvs8EMDnY11lm99d1jod4iBI2m/cOQ8o/?=
 =?us-ascii?Q?KvH95nvQi1CFzb+fuutvBPoforszK7gtZK8jTg/B92zkfs+y0PGB/RGOQR6W?=
 =?us-ascii?Q?uBcVSSmhCdAYNyOPoMjj23NITIS/S/Cb6cCilLcy44omKa2okkSnIdJBK9kE?=
 =?us-ascii?Q?nPiR9i+lZ8MwjhRrhD9TRlJU2uLcX+R5M3lNJFGsA/xIQDM0yVkDOBx41AU0?=
 =?us-ascii?Q?J5ssUEVZOSC5IEtgTzFfG8IxBQuRxT8o9iRq9zJd3quxOG04d31Zk1x/6Li2?=
 =?us-ascii?Q?x2KhQ+U9ObURiFr1o96ttYBOiKoJZcdcA1FS+TKA/Uf7gTVp60HFEcuzKiF9?=
 =?us-ascii?Q?d0Lr5frGs99CgDEwyU4FYeuI2J39k4+AIZvqtIR2yv2H7Y/ylck07Oza9Pj0?=
 =?us-ascii?Q?rZBzm3DpeoTY+3ST2rP4UUCjkCECpnUnFclmcC36s/1FM9Ul1pVNWaBEVHe4?=
 =?us-ascii?Q?q+ydAseE1gZWLeMVKvx5HMP2SHMQZ9s5G+SQzdPkyoQQrBGIFMHI9vevwj57?=
 =?us-ascii?Q?z2tOMdzozais52PYezk5Ud7/SK3Tlezp0MhiQnPHoRG2c7Y/4sdta4gBzzHp?=
 =?us-ascii?Q?BlDO/hXGpp+kOao7MirRxppE8TNpGuvbzoBq8WyGCGztVXPbCKZY00ulGI7J?=
 =?us-ascii?Q?C61WKQ8hT/A39yq1cTfnaItbPYJYf5rgekrQEBNRqItBNd3e+9Dh+5wwK8Zx?=
 =?us-ascii?Q?MJLGtKcTv58aXqEhpNOqvKeTtR5FjllKN3j+BMMjzjR26zBJ4ZNSq/H58IyE?=
 =?us-ascii?Q?tucwLQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc9bfca-2d4f-40b2-3d13-08db3080c883
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 18:09:48.3522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PywGCQW+ch6MPN+tLuFVcugSkd+OX6cB/T2AphLpXQ0UlaJLmsoTzkKZuxUVhV0AZbYD2yNy7NW7WUehskLPtHeEJxTDZE25LxKN3xPOoi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6122
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 02:01:30PM +0800, Liang He wrote:
> 
> Hi, Jakub,
> 
> First, thanks for you reviewing our patch again.
> 
> At 2023-03-29 10:10:51, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >On Tue, 28 Mar 2023 12:50:06 +0800 Liang He wrote:
> >> In rionet_start_xmit(), we should put the refcount_inc()
> >> before we add *skb* into the queue, otherwise it may cause
> >> the consumer to prematurely call refcount_dec().
> >
> >Are you sure the race can happen? Look around the code, please.
> 
> We commit this patch based on the pattern we learned from these commits,
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.3-rc4&id=bb765d1c331f62b59049d35607ed2e365802bef9
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.3-rc4&id=47a017f33943278570c072bc71681809b2567b3a
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.3-rc4&id=b780d7415aacec855e2f2370cbf98f918b224903
> 
> If it is indeed in different context which makes our pattern failed, please kindly pointing out it.

The difference is that these are not start_xmit callbacks.
See below.

> >> Besides, before the next rionet_queue_tx_msg() when we
> >> meet the 'RIONET_MAC_MATCH', we should also call
> >> refcount_inc() before the skb is added into the queue.
> >
> >And why is that?
> 
> We think it should be better to keep the consistent refcounting-operation
> when we put the *skb* into the queue.

It's subjective.
Due to the locking of the code in question there is no race.
The code you modify is protected by &rnet->tx_lock.
As is the code that will decrement (and free) the skb.

> >As far as I can tell your patch reorders something that doesn't matter
> >and then adds a bug :|
> 
> If there is any bug, can you kindly tell us?

We are dealing with a start_xmit NDO callback.
To simplify things, let us only consider cases where
NETDEV_TX_OK is returned, which is the case for the code you modify.
In such cases the callback should consume the skb, which already
has a reference taken on it. This is done in the driver by a call
to dev_kfree_skb_irq() which is executed indirectly via
rionet_queue_tx_msg().

So currently the reference count handling is correct.
By taking an extra reference, it will never reach zero,
and thus the resources of the skb will be leaked.
