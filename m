Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBEB5ED78F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiI1IVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiI1IU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:20:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADE872860
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drIwDXSfuVkmZm7Qays9RtmoGKjFoaOu0AAPB7xBO7a5tGZqEhzSnRucKoOA+exFvzXllteeHg1as/OwGP6rXYZXs0FW/bk2vxyE/AUOp5wAzFJC2oYJc6Naz7cl3bzC2T1H5mOPqEX3HjWjj3EaYQovStemwCQVtM/iaksH2rdHJS7UXAWr7zLw9+t/vYz19k6L97BW2hdEFI9lquPrhtdOtwdgQu0coO5H6qQUiReFH7qppNhXELLGbOyGLWU+OsrBdOt2OwNLrepof0UB/KUbdez08sb0zrvdASGwRFyfBRDSrICn6LinUvJH6b1dUgP8o5pYGYzK65iyN5e2jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8/SUeJwzMAgzZua6qR3Uzi27TIpoR43AvlMrRd1kY0=;
 b=DbfOW50WAD5P65Jz1LvDCCS/POHrrM1SFl0ykd5poAHxPiTd6ODZTYRp6IfKb6v0cPDAxiDALzktz2RTVY+dLHdGhT7JqwsJeCSAjz6ZUIo7g8gnJfcDvnITT9Wgu1lHR7FE+BJa3mRHd5ucc0GZ+kf4APoVTCoEb43F4LXhJJdxNKKVKne7+67c3Am0Ox3MZW6RhCRM1FOwPCozGGhqzkHkklBff5D8W+Xgm7+dBtV5ymzBIVPAvf92RP4gbzqGGPun2Ptb+ucLZHmLr6nT2cog8RiZsW1X6V9ud4P5K1/psnF1pP76Qx3tNGfc5EbJ042GOXmKTf3CpSpj/8jmkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8/SUeJwzMAgzZua6qR3Uzi27TIpoR43AvlMrRd1kY0=;
 b=VE+ml3THs2AS5UVvrOTPZAF/+46aIwsLwrmPZAiQw5LY8fysCMZ5JSSwFJM6LcphY006qePSst9dMJlBcGv8kKqGW5y7SH7uksy4YdE2gUeNbDaYQVeUsIBs26Rw8PQmceviU/t7mO0qJZ97oA7G8j/efBispril/X9GOyJHBEo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by MW5PR13MB5630.namprd13.prod.outlook.com (2603:10b6:303:190::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 08:20:54 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::f565:49f5:8d21:e93]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::f565:49f5:8d21:e93%4]) with mapi id 15.20.5676.015; Wed, 28 Sep 2022
 08:20:53 +0000
Date:   Wed, 28 Sep 2022 10:20:47 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH -next v2] nfp: Use skb_put_data() instead of
 skb_put/memcpy pair
Message-ID: <YzQD35IZUA3LUJZX@oden.dyn.berto.se>
References: <20220927141835.19221-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220927141835.19221-1-shangxiaojing@huawei.com>
X-ClientProxiedBy: GV3P280CA0051.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::35) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4431:EE_|MW5PR13MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: ad233ab2-3e42-460f-911d-08daa12a5c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxWc72ayFYmhzOCIUNW0ovKLrSkWbWKMs2BmIZutK7eM52lT65lY4TtLQkwPlhusMZyZU2IQWjpHCswCm9WXNluUuJDfEsYWYckm6Z3xquXo7tClRHeto8Zcw5ag9pvZQQ1omfWNehtH9zp2v548+QBHhYww51bcdTeDXw/hYbBZgWX+5CHHFJrL6/MNHd6uoYQclk5PrjxmMWTvwJr0usFMM8auGtm13VkijbyvBgdqQb11EmDogSLpvPRHfa08va5CVUBvc9ho0o6rMV0a0pyKi+G+skBexBQ9QXQzeCPoYrGAOrwZ68c0On0elLX9x5q1XMfd14kwfsDfy6+hFS8hgsbOpma61ScgdizGMNPjJbBzXXTi87zRfpAvLt7rMMuMNKoQ/rqeMelO0dPegXVYQ4rhTkW/HUkxS6DqzNOpUUKaCmunz1ixuVGJlHFHzp8VnlHy/C0jr6roDSiAAOfrDTfZPHkDGQoduwk8HcQh4WfrwGFHR7ZFLCAIJCxber6FoyC946UTAHZEAwHqhi3Vcb3vbvArgoWVzIPPks3cKd2yCV+LCDf0BxA65A3/ybqJ6m2TlFq9eQc/zyeh9n6qQbobprwU091R4RbpTv1P8v8MTlctuqPXRqRURMmnCyYlMlDH+r6DPOjqx/xJJNuxktzrAClj54dxPqe4E/6PWgjmiwueCWxsQCgoSDaju2+3KlKO08AYOg1U/bDbADtMboPyhcCVu2PwYDqdCL8h5MT7eSLNZwlwjzmr4O9A6MtEFV4/jb3n7+KI3rd7MZFfCMMXvvOYEYQ5mv++LvN09peSnl3koMbOmJnsJ1TF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39840400004)(396003)(136003)(451199015)(478600001)(38350700002)(38100700002)(6486002)(316002)(66574015)(5660300002)(7416002)(8936002)(86362001)(41300700001)(6666004)(6916009)(26005)(83380400001)(4326008)(6512007)(9686003)(186003)(2906002)(52116002)(53546011)(66946007)(66556008)(8676002)(6506007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1L1DV63r31rocxDDA2J7Cw2O87zPaCT+vD7GMkdZPq+olKIVaJK7aDH7iQ?=
 =?iso-8859-1?Q?1yIbAc7YXuRu6aL45HYTGLaWsFAv2mEB700GLAuPLSk/P7tHJTzuObOqRw?=
 =?iso-8859-1?Q?R/XfD72eiv/MeIyFH63dwSuVarbmqRbN57baJEpi/IjFfH6UZGfbgCysLa?=
 =?iso-8859-1?Q?UdEiT5tm2mE29V9m9LJbqrnoClcsjIyh64DpCkMqdcmoQWakBrPpI4y/qx?=
 =?iso-8859-1?Q?wDUsdV8wu+vQdvstIX9o+sLTW63lERRdylgU6HywizcKxtJzZqa0Sd6Nhu?=
 =?iso-8859-1?Q?mRHtitUDfYJL0tMPQARnfHwXTU5oAGbFjElXCVjCJLO6PAmBdhwSVeViW9?=
 =?iso-8859-1?Q?uBHBJD3OsIaWINg86XAuRHR9gIHyzxgj5mhk0FXTNbKvhVrfifa5a/08kP?=
 =?iso-8859-1?Q?xGujznHbv6Qx+Rxe9DM4sGjKfYC8/pE4lZ+0XWekJEBGsuLojyMritdhMX?=
 =?iso-8859-1?Q?f/7KTy0JINKrSQuSouDgneReQJ+3SVHOdg+Kzu+CHvwklQ4FL3Le9d1zfe?=
 =?iso-8859-1?Q?QO/2/NlRcoPFDp+5s9J7SKUocd1aCDLtOt4GwdTfxf4aEFlr8dxGWn8GUZ?=
 =?iso-8859-1?Q?qZK+L11iRv97F43XfYwwAzk23QvNyOus2VCdxh80kR7KydevKPLUWNp+hw?=
 =?iso-8859-1?Q?6uKA7LbQr/oS0b9guJDwbu7vOxtG3r2fZKBkDmj+TqgfSPK5X/n8REGL83?=
 =?iso-8859-1?Q?FPhYX1NLujBu2pMiqqBrjvmBmupqoukNZSyJRzDjDn7gqSM7xp5bohnY3P?=
 =?iso-8859-1?Q?KBb1FkM1Absj/6sYhhhiX8+GkPMUmqPLHjUcblKaJEtPlRhCTzjPmZG05Y?=
 =?iso-8859-1?Q?PTeC9f5aIk5emAtPZ4HOGSVPkU9zUjgjvfsZqfBHtx6jIHpM1MfMkVCtQk?=
 =?iso-8859-1?Q?zeupuMxtW+Ug5f3q6LrXhBZ8BM0ObFdxhKqltYoQStVEbffD1YCQITFqXA?=
 =?iso-8859-1?Q?AxH+g+VlABTA5CAage+HUhP4l0gkC/aFBs7q8vIThSbDU28C6dqXksSm5B?=
 =?iso-8859-1?Q?KWqw7n7PLpwzFOuw+6GySVn7w/poYBrbJsOzwRNKwqi+FgQw3qr4unbRcw?=
 =?iso-8859-1?Q?qrr75C5CJFB3HdW9GKFojygvFFVdoygFnz0C/IuYkIvvKRNIUXuQRBRNTH?=
 =?iso-8859-1?Q?9KB944VFwo7+2W3zPVM1OWDiJYWNYGEZtfrjfNHHkr+P4kIrCNVzFZ6pH1?=
 =?iso-8859-1?Q?83Wp3DR0Tha8B3uyp7lGOz+xepFjZU475I7+WYLwjfRrijWD0s20/f6flo?=
 =?iso-8859-1?Q?84QR4ML81cyZBSt0DFOG2w6aEwFY2iLCwkU0HxIw7tHc4PtZDKriYPHbbm?=
 =?iso-8859-1?Q?WC2mHzunSx4Daa5ahBAk2+CsZRc1PrRQUXjZbP7NJq+yqwaZNzJrdtwzgO?=
 =?iso-8859-1?Q?9p8AcuQSSGw9OXAGt8vb3z4+hQqetvBkfGXxnymmt/urv6mRuN+Bl1dGga?=
 =?iso-8859-1?Q?ZKPIsRr1tiVp4i05HGwJsu4L6Os5YNjfhBsNFdhWO5A9by/AifwZYTILVZ?=
 =?iso-8859-1?Q?yJNaiXEAjvsbY3EJGwY1DX1sc4+nwJa4PCgvHbd4ZxTbJTd8rfBZ+Bz40Z?=
 =?iso-8859-1?Q?7WpQTtz6pDQjpNT0e9xZEeqGbfmEfB34Qbio/maftiTj+WQI1e5lKQM/Yh?=
 =?iso-8859-1?Q?zKgEOSCTUmjMNnBZ3MXHvBZtGVKFvXHVo8EXRjZYe4RvZsI/8d/4Ei3A?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad233ab2-3e42-460f-911d-08daa12a5c75
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:20:53.9347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uP8ocLuo5nfW4iDo3jkcXTMKvlMDjxNH2wWe8vdP/5jJyi6nz5fE8AYQrtqdMi4XjyhUurqh2EA8JylizlpzgPTcyTr63PwWhQVg9GDbHvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5630
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shang,

Thanks for your work.

On 2022-09-27 22:18:35 +0800, Shang XiaoJing wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>

> ---
> changes in v2:
> - no change
> ---
>  drivers/net/ethernet/netronome/nfp/nfd3/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> index 65e243168765..5d9db8c2a5b4 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> @@ -84,7 +84,7 @@ static void nfp_nfd3_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
>                 nfp_net_xsk_rx_drop(r_vec, xrxbuf);
>                 return;
>         }
> -       memcpy(skb_put(skb, pkt_len), xrxbuf->xdp->data, pkt_len);
> +       skb_put_data(skb, xrxbuf->xdp->data, pkt_len);
> 
>         skb->mark = meta->mark;
>         skb_set_hash(skb, meta->hash, meta->hash_type);
> --
> 2.17.1
> 

-- 
Kind Regards,
Niklas Söderlund
