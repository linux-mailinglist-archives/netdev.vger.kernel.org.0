Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F6168674F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjBANog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjBANoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:44:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2131.outbound.protection.outlook.com [40.107.244.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A84AA76
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:44:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1KOXTZMQmVC7Vms6zs5aWbkgsqMrNhNlQ/XRQ+MCR79vGqaLriTUhwtJnGgrbfWHQD3oFrhATAHQWna9Lp+WshtTN7t3goWCZ0HNk8b989i+MfdYp5nZ3SghMd8m+79sWD0rDp3zohnz+BFQuvdadRU6xR+fuvw0sEsCZoFqEkoCoFFjGeLuM0hflYYTUM7e2n14TYRjfZSNrnLwmN1o58mc6ryAQv49juVHJgZZ8njexbEQb2o1q7omlkDVx4hsmiEZid7+nnAJJm2yjGjvUumuPvTQaKrRbIuRxF4t9Q+l39QSk87yJiAVsxgjXyDVCBpDuy0vCWiGQQzvRx3zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKPh+f+61taz8yiFYoqZDRfwaw4iv2IRrgXN1oJ9+n0=;
 b=Fq+DUPxRRbnXE61jbXguZTSw53WOYTrBtbutKhiMgPGSY0Pz1Jh24mVdaVoAuNUlp9qeWYd56rsYWuqpo194kkuufVs5ysDeQVIjWarpdt78IEQtI9y77sno71zzKeW6/UwUbuEYj1Eo+oDyZJiFwwDYIxKyKuRsLX/pWaiq9SwP7+Ga1a+Xcv3ud+lreSxrkYujnXNFk7LBkRl/ju1PnH6nK8K+ubj5j0cKkvS60noXBmjANPdmgPpSsULkPldQBXRsnZpH8HcFGzSBT935w3KkepPBaFkvs3yTTQO4lTuSaTR+wJniLI8ZNZzZHHgYV//0TsBvUz9ozTq5tzhdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKPh+f+61taz8yiFYoqZDRfwaw4iv2IRrgXN1oJ9+n0=;
 b=EWBRgmjceGcL5ouZdh5+/yM0fs2mx84IeySq0TfjYNSv1yiACWSsHgPvfYHVwGbGjgadmR/YD3MXcGmSasu5HOAAicFcr0ewXZniswSrm6A6pgVGV5pFFFFbSzwemIyneCfg6LxuA26Wj/hHvJqLjN3tScPQUKXVsgNF7/6zcT8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4807.namprd13.prod.outlook.com (2603:10b6:303:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 13:44:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 13:44:29 +0000
Date:   Wed, 1 Feb 2023 14:44:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 01/15] net: enetc: simplify
 enetc_num_stack_tx_queues()
Message-ID: <Y9pst8+QO7GCqUIh@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d10fce-f0ff-4439-2634-08db045a70fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9cgld1DSUOJv1uNXPSXEBwMWOJc7ojUHze/6Mo/flZE+aMAPT9lMv3b8kuoMD8FnUgqkZO1ILbeR5G2Q0B9KamRmqefTgWFOHv1UFIP7+hitaTu3aleBgPz+Y8H5b5DhZdOfKm8Yc9nMpysIUSH5Qh12LjbswfqOyCyIjDy6S2rcDm7r57PVcE15T5erpdoLlsmKTzC7/Ti80nkMusYiu/8wChDX2bHxj127Umor/f8qR5cFDQPcJy81ESUuWuQwsEdGoWEqo8tOQjUevTmh04NBjsxblLPTBSsXwbq5xzzqR6rXxN4/+u/9SNK7iiq3fWzDuvDsCnvhlRa5g0l3ftLQ2KVIU701UGXWSDKLnh3vVeLZ4E4rgVlNM+zQ94XXh7rFvkaWUhS7fVAP+AUeITpurMAuoL5HJkjDE3lNWlW9hTgRYiSEiAK+VoyucRDd5ybokJD+2Wi74+eDR5FI2uMytkZI83zcFyXdkGUNTLUnWxrgrXVWRu5XVXSE1pnUBIUySr8ZCUV8xI7ShRcn9VyBzX7YF+i25FSqf+velqkD6G+M9eCx3B3+y0f6bLL1cXt7nlb1Z1p356bl3ndosX0JitKSHQol7+5HR/m5H9WhTWeToxq0pichop5T5L4rtZtjD6QnVlcjI1gdsas7D8H23Ah1WPpuRVqDmV/4xlnoH0XlPZ6rI1zgWRtbs6u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39840400004)(136003)(366004)(451199018)(8936002)(41300700001)(6666004)(478600001)(6486002)(36756003)(4744005)(6506007)(7416002)(6916009)(44832011)(66556008)(2616005)(4326008)(66476007)(2906002)(83380400001)(66946007)(8676002)(38100700002)(6512007)(316002)(86362001)(54906003)(5660300002)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEZF4yJ5KH6B9A1p2jit1xDYQnNzhrI+nx1BLhLLOAB+1621LChG5+NCLgDJ?=
 =?us-ascii?Q?5GKN3Qcm8L5MaZRwRu7y9YaQvo7Fq+4VQ+lne99uUaAoA/UaJ8zy/XXzdS5X?=
 =?us-ascii?Q?pPyaXG2bm9x4zaQjRCY/Cw4otcAdewx63K3qR/9X1vv8ehD/tOhfsM6rMZD+?=
 =?us-ascii?Q?yeOTr3U+ph9YeIr+eCNl6pfr1LvQ63BOn5bMT55kzuV9C9nll0NYSjxRrx7l?=
 =?us-ascii?Q?TGznhWEWeteg9Ht5ldFZWICCiSSR4no3RMfbnnuQyJYpS/pFFMGrO43bdrXs?=
 =?us-ascii?Q?Q/HqjJGHqkTWXtqqfdqGEkKnISNRC0HRWJHkTaCti92e1rwENHK4Ce9ZQ3OC?=
 =?us-ascii?Q?ldiND8d5J0HiYVitO+GOnu3Sszdo2JrKCTnIS7rvwsJIwokWxDyfOc+Fbjlu?=
 =?us-ascii?Q?g24pWdchnzjuEOcBNCr/dNs5TpJzU9x7/3gFfbpg/cu94BiFlR/GiZLpLd3k?=
 =?us-ascii?Q?OMcycA/oqzQdUxJ14KVNUNrTqYeSBzWze/TASMzA8iJtAJ4Pz/sAqScr3z5W?=
 =?us-ascii?Q?1hZJu31LGfmgcayFisWtBb0ePDsiUVNsVN+5cFAXAisKkwyxlh1FmLc6I2lc?=
 =?us-ascii?Q?AJ2+lJlar8VuH5QrhKwyeMSSqZPn/oMbmRYJhNc0FcvY4yf6rvtZxTPYfxfv?=
 =?us-ascii?Q?wk39kEXZJue3WFfyfvfqVom5qV2U67oIpSf1Ol2gTvVGJK+M+OS8N2i9VMDo?=
 =?us-ascii?Q?4MTuPxa/jk6Q75lknUW3SkG/Xr3gWxS0ZvTn9mErRX/5uBXOiikPgJOKb+oZ?=
 =?us-ascii?Q?Hk17ZSFW3DbIiP/bGxaPl8MdJGf1OnJGqafZnE45ihu/E7sHig3ox13JfClr?=
 =?us-ascii?Q?Yj0/3FwL/M1FYjEL7gOP8uGysxGfL+JhUppeSTqCpYKGKYCgf0Y14UPrvDE6?=
 =?us-ascii?Q?XFdrTDX5cIK7L6oIwv6Xze5PoSxc4rG9/NivoP3sTKGuKkogI50jILmPaoCa?=
 =?us-ascii?Q?0luA31Wal+nKX0tCKEzy/DHiaqdcHJuPekzRfL7M2iiJkTWSDZaDvpnLftPT?=
 =?us-ascii?Q?Rgu72b3uCUyVmpdQptvYgMAbEATNrBUzuh3meqEjEM8hXhjG3OGPtCLZAI7v?=
 =?us-ascii?Q?PdNyKz1IKx5Lscp5r/R7cGo89atJOv+SeCclNK7NT+GjUBZWeRkWoF55aC2G?=
 =?us-ascii?Q?RUoa5/7yRg0/1xFA1wpT5pYQuv1xjqXElIu5eWUwAopnGd9UxTBF2xSV3uX/?=
 =?us-ascii?Q?0UtavYfYK7W13nfoPtty7nCLiYbIKXwDlPkHiaC6gwp+ty3A9YRGfrlMcQXn?=
 =?us-ascii?Q?CNkD9RGskKjT2YvXFjnZi6ceDrFrCXZnE/VX93mV42mqGxSIwio0jEldYupk?=
 =?us-ascii?Q?jLCmo/kcD7e91im8IB/kLP815ckD9XdLCTGmQzdTPIFKsXBx+OxcI8RHmwSg?=
 =?us-ascii?Q?gnlzrZwtVN9i5fSxtXB85LaCMJkPsIgJdxrU0iTtZugbiegeEZ7eAcXPYd0N?=
 =?us-ascii?Q?TU2XMiKCYCaqx6AV5E3V5JJT/6Em4l5gAEEaQOh3ItOBjoruHn004PFEmVEG?=
 =?us-ascii?Q?vHpDbl+MOtomX9LdF0XL2XsKYSryuLjogd2yyp4bhmnTIhB6prygp/bgWhe8?=
 =?us-ascii?Q?jJ+K/5BQJqX5OI5IgnssfYj8vdGLFd+DVcRu3Y7f5HGC1qXT/+IAvslJ9L5t?=
 =?us-ascii?Q?BLVlK7ReV4bIw127iDVJXReoO9A9+vlzdxZKx192TpsgTVyKkWdTGPFgEY8W?=
 =?us-ascii?Q?sZg46w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d10fce-f0ff-4439-2634-08db045a70fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:44:29.4253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjSz+R89PTczBKqTO1ZB7p5CpFizhMdgnxmEnkJ3Syb7KRl3Yf6n2tmpfvMlafT8LF7JgfSQA/Ks94/l/AxUoJwZx6ozNQlsJuw9lm6wXMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:31PM +0200, Vladimir Oltean wrote:
> We keep a pointer to the xdp_prog in the private netdev structure as
> well; what's replicated per RX ring is done so just for more convenient
> access from the NAPI poll procedure.
> 
> Simplify enetc_num_stack_tx_queues() by looking at priv->xdp_prog rather
> than iterating through the information replicated per RX ring.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
