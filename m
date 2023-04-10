Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DE76DC43D
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDJIUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDJIUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:20:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EA1268D;
        Mon, 10 Apr 2023 01:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBArJuaTWViA8ZznpjLyQhvN6rM0WAJrg+UaQ6AQmQz5f//J7w/RNceh6YGyDYBV6/i9fljD2L5Ax9UFfuKQW5HGByfXpZhfXW7qjU0laZh7ErYGn1GZs6whvG7M7OyVKv3UK95aTFUsDlhhxcnqDjrAj6oLHfSkHD3U3fmy9OOm4/ALLVBHV/MJJJVO6hGElj/OhZQ29eJMSWEu0VM1cenhFDdqEIl+dQF4lOplXDow+rpdH5E97GEKtI7zOB+IJ4skaNMIJBJSRxMabu9feIqQs6DQQCMP4iKxSL5Wj0v1StC4B8DkTvn1S1sDpooHHEbhnMgg6F9dU+aYoJi0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpW0xlsWeqMK112gJA07Wju1Be46jE1MYdcOAaFn1PA=;
 b=G+90fGpNrzRujhKmen2/2ToIFdQ6yeBphnDDNOra/3sccHgU/w90I4itex6mmK0OLRMnoF226SmOP/+dfvguG13F2uD7SJatPj/WXwgCtgnwrmN7CMZpE4djVlHKi1jjjSE6clRaKyNNlHKlCmVF3Bp8Rux1JxR9D7I0l7/Yx+cYlM+Dn++ob+ps+4jarcMxb7KGPGuH8SofKqEqEJliWePiAwjjOE/bxU6ixy98g1PM+79ratA/v9TLwwgjHDnUvr5x94YRvcdM6rqYLbCNvd8Z3+UrPn6WACTpfjKaNXh5dEGxWJkZ8lhyYlG+4/4qRNkwYYeTZ37Egv/fj3G1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpW0xlsWeqMK112gJA07Wju1Be46jE1MYdcOAaFn1PA=;
 b=URh3L/0Xp6yRLdm7VWsi/3Og7euj+46aOLAagXJvNA0GV3dWiB60hrgor85DjYk5Xu4PSeXpBXNjfNAtScO0ZoLXFrDQTj0Wcmt/e3DDQleomH5KCYkhnHsYeQiSoonDU9g7gsQ+Np2lhHfAF8f78VlOIHA9yb08+mdIDFiZnvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5244.namprd13.prod.outlook.com (2603:10b6:208:347::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 08:20:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 08:20:45 +0000
Date:   Mon, 10 Apr 2023 10:20:38 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: qrtr: Fix an uninit variable access bug in
 qrtr_tx_resume()
Message-ID: <ZDPG1oqiZSFaSif2@corigine.com>
References: <20230410012352.3997823-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410012352.3997823-1-william.xuanziyang@huawei.com>
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5244:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f0208f3-2daf-4bd8-726e-08db399c7b67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4E+1phIAQC/8AX6c/u8FR+ngidoYxx8gPScYsGkoOf7i5mTBuB/UQohSnT1OVy19PvVH8v8/OXHIiCIP/gd0MCTA5G1M+56BAmaJqDyxPtOB05msSCdjZSzL4k8xjbkyHETCDQQ1p3g48Q53n2xeTgrJZF6vzsUkBGyPbxpmuz3pDucDAhukKOwFUYVIa1+PqcOhagE/TR8Yo/wqHmwv9vmP1WsXUR9gtdYzqR018X2PRGvvznurpDDVCyOJvvSv4liSoYNLHRukA6+1l9kCveLIL4UU6/dObX5R8oau3WC60H1r0FWkr87CD6u3dcA9MTiY9BrHk0YKwTeMgo+1In6BQ2aRxgRy2yy1XbtN6orbXYPrnZl2DfID2BKBQ25hmUnTHSSzjuuWTzEo2D5mH+ruRDKopEfB3zSHKV5c4y/e+eBuipXOYDAvalq4Y4HdPG4E8J0cFMnI4AG2UEo4Uk/JbJua/JFpdpb+vcZzhQ1dnRsDHOSlXhDUQ/alpRHXSNSyeNDUtBdECo/1eqgc2DGG8nzGPmhv06HExkYKpEbVEpcFXpBX03VuGRxRBQ8tQCsjE6pfnH16LCqRPa3K4UmAosoNb/cgVuOv6E77Np0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(136003)(376002)(396003)(451199021)(36756003)(86362001)(2906002)(2616005)(6666004)(6486002)(83380400001)(186003)(6512007)(6506007)(966005)(66946007)(478600001)(66556008)(6916009)(4326008)(66476007)(41300700001)(8936002)(8676002)(38100700002)(316002)(44832011)(5660300002)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WemwthnZ3pTWlN1Ujc3Pevs2qlGFefLIZ0swQhcSiPS8RIIXz5YyLLw0s3A6?=
 =?us-ascii?Q?/V5mB5gcGC6EYzw4GU+wnlusIh/Mm0rFFTgg0cH5xZ+0CIN6hKggiM2DC8Kq?=
 =?us-ascii?Q?E6OOpwWxxaCguu63Blmo6F09j3dXnp5R3ExBR3fWHvoiTanpB3G0lwoBjkyB?=
 =?us-ascii?Q?l8gjn7FJbpz0YYPaa0KDJUvgpMpeqSRB4yRlVed9xWPedhfNH3UsrILVEByO?=
 =?us-ascii?Q?oRXiFrmxV4vEJVz7NGGBy7quVGHprVsQG9nf/Ob6p2O5l5x5Ovhpo4p5jeEM?=
 =?us-ascii?Q?i27S5aEOMXhDQGxYyvc1udJzzMmt3WdQTN8QMOhw4ZshLg7c8/qfs+TZ5wsp?=
 =?us-ascii?Q?up8MKL19DY2+POH3g+8L0BH03h7WYozFUPABnrFRVyPsa2d9txTVwmKW4O6O?=
 =?us-ascii?Q?GKAGE2S/uvMTwSGoFn0yclB9Ru+DlzDEaW9kGR+x3sxn82yc7+aPoVreJs0D?=
 =?us-ascii?Q?rpCNquU7Ozh33v2duStKvt+aRda3VvjL4iYJrM6OZgSorLJSxAYA91tt+Bhe?=
 =?us-ascii?Q?ldKXzvMGZbr16zi9ojUR8X60XV4d85JxQwlaeMarrUP6zFCvGxhmBJIDmWTZ?=
 =?us-ascii?Q?6p3tybiy1LMuXA/XiMZw8n0gyfLJfwZW32yi2EvlnGUG3wqX7O5j9Pu9KY45?=
 =?us-ascii?Q?QaJXgjd/LZDvOvYyn0GHC7k546+jb1lLkWrq+HoHH443vI02gmnKJTQwFPvh?=
 =?us-ascii?Q?xf+hhj8SK+7DUy5JoqMfvJnOTkIKAvON1GljkGFRc3UT7voax/ZF/hjxg8ef?=
 =?us-ascii?Q?tButvEBu6KRrXkXMC4b1ekkeeNcbySlPKVSwOTw5EwDa+I1jEdRA/yAiVMM2?=
 =?us-ascii?Q?S5QxfgQII9M+a0mGpmcS/DwZlOHmAKI/wQJbHSFeZLMbO+yL4+0VYitYaKB+?=
 =?us-ascii?Q?jmSPUuwPHUf1fPcPYaABgSUxh0x/1FW4HBAB4Zlt7FQSut9x/vO2Wi6o/ixX?=
 =?us-ascii?Q?71PhFDN5oOyG/YDE1CwmEHU954B0JjyzVhVUoB9fU+Kt5r7CmtyWhorQ+U1A?=
 =?us-ascii?Q?4HXLFn8zTxrOsRKdBh+W+4zyp4Hl01jnhUmPDJLgU8aZpOQqdl86ayEBW8iS?=
 =?us-ascii?Q?7kfviSKGTJgHDmyk319WTPMU+79JQpmYsU/acXy92Wph8yFxXBUvjoUeNrf6?=
 =?us-ascii?Q?Wm+Ge9/4qRPxGDmpw/HVH3C7kkmyVEjPgXjxOQwTB7csb18v3siqo1A7a75C?=
 =?us-ascii?Q?NI3vnT2q63OgLDhSIgtWLeu47WrEjnwVBMgBIu0m20klIgLy4rZ2NG6hRQNx?=
 =?us-ascii?Q?J0O2lMgVveUUkeBTNk+I2qMfkKrxlbDJu+t7yArYdNjPdsaWpv5VjekRKjwq?=
 =?us-ascii?Q?hOdHIYvE+item7L9MV6BBYsBynTEiqltmE9pCfzATABy8d+bp9lb2ibNjfQV?=
 =?us-ascii?Q?xu9lSmjOiknDG0mzYw59N00BpLwxP7e9aaRxMt4abLhkCSH6PLPJpUJxo9E8?=
 =?us-ascii?Q?vzr+CTT7mU3jXzF5WiwE6oCAbaaJe1jaGWdFWTzPMd0mr3VfdO7rjVgo2Kkd?=
 =?us-ascii?Q?xC8vCXUeRwl/JEMYPV2jrKB2nCjJOI4KWyMlRlij6m1vrjXwmoqmjJgiDmyL?=
 =?us-ascii?Q?FbFCcheZbqCumOtEBDlsbxUMXJAScp/HmyvEFcAiw2xdEydfCAe3feuEeoGH?=
 =?us-ascii?Q?i1rHxyfmfUv+EDaxteG0je4T3+dMIaPwEoJuyVZwRzeQu7p+LSGIjTJsrvN1?=
 =?us-ascii?Q?fLanIQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0208f3-2daf-4bd8-726e-08db399c7b67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 08:20:45.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rmjbL1wFMawEQ8q5L9jybJXYdnoolkAuOOvItMU3X4k4HJoIFzGFOyue0qr8Twrlb6M190GUsTIk+JsSj9rru8VPnWDUbRdqc/NxdejGAFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5244
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:23:52AM +0800, Ziyang Xuan wrote:
> Syzbot reported a bug as following:
> 
> =====================================================
> BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:766 [inline]
>  slab_alloc_node mm/slub.c:3452 [inline]
>  __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
>  __do_kmalloc_node mm/slab_common.c:967 [inline]
>  __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
>  kmalloc_reserve net/core/skbuff.c:492 [inline]
>  __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
>  __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
>  qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> It is because that skb->len requires at least sizeof(struct qrtr_ctrl_pkt)
> in qrtr_tx_resume(). And skb->len equals to size in qrtr_endpoint_post().
> But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb->type
> equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the syzbot
> scenario. This triggers the uninit variable access bug.
> 
> Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX in
> qrtr_endpoint_post() to fix the bug.
> 
> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
> Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=c14607f0963d27d5a3d5f4c8639b500909e43540
> Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
