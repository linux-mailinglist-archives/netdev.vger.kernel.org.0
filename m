Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C6A67B55D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbjAYPEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjAYPEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:04:31 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2126.outbound.protection.outlook.com [40.107.220.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBF640F4;
        Wed, 25 Jan 2023 07:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYue36nVnRPPPhydnGJ1wokPSomp/tyk3P/xQHQQojADSYljLMtLwDv3071zVkeoBIraEd7/XgdR/WFgtn/Krk7q8BUvugOyoFen1bfCSIKawfmLJA6E1rktticNrLz2Y3ZFxUwFQWCv3MUTqb/bXQ8nE+u9Z6EZz4eUFKp0Mll3S8dFWaohke0+qtJ9wz8TRVfwIY2O8JyTCgnjrSQ7zkbbNI9KXLdhUoNoH3y4ZhFS5aWDBD8lPVqAcg+kqtDFGYjgz9x6GgZKM+sl3h24PN3Dc+MS18LaYR7WjTXRuTBPuyHKra7hZU0ptl36V1HiDCJ641h7oLL0SkAeeiSq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuE/3uep11OpjKA3rPW5x2npKbMx/XXhDKBCHgHAgSc=;
 b=KN+uAIFeQiTrllYqF/dASeb5I9qWjzmG0j7o3pMABRe6vwoUoC1nuXv44kpmmVEQks/oMc/648PYJ92XU/VqTJ7B1mLRf3JoFP31vtT+lvk9eUl3MOqvCJnc8b5AfeeJWTscGXNZs5O/PO2LwpH8snlc4pCojGPJ0KD2TwNX0Y+9VBARnkIW0gGB92PTNH82UtRuEBJppLdWavrTrdbQpMgRfkQWkhWojXm0zuQb2Q4bBxwm0CMCd5WxKySpdQrcqpj327vBNJ+dvahBiA7jxu4OoWuu7jPilLIFp17/pLQ2rp4erGACDBFcyPH6yf3/8Or+zLEaO/sNqgMSkDU/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuE/3uep11OpjKA3rPW5x2npKbMx/XXhDKBCHgHAgSc=;
 b=kW+9GTLrPPfE5rpGgG87gY1/6ta39N7ml/t2ADUPipRZBTMUTlorD/K5L9VSgyeeg6/5eh91DrJa/0m3sBsCGMKW4nsydB7W9R2QJ4PxdolQKCKJNMcJXm91MEZDbklGhF6bZzAM0mi7kO/UolwnIEfLwf1mdamYaLOBy1PHqDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4686.namprd13.prod.outlook.com (2603:10b6:5:3a3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 15:04:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 15:04:26 +0000
Date:   Wed, 25 Jan 2023 16:04:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: qrtr: free memory on error path in
 radix_tree_insert()
Message-ID: <Y9FE9E4G/arTAHjL@corigine.com>
References: <20230125134831.8090-1-n.petrova@fintech.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125134831.8090-1-n.petrova@fintech.ru>
X-ClientProxiedBy: AM0PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:208:122::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4686:EE_
X-MS-Office365-Filtering-Correlation-Id: 43487519-dc98-4345-d8d2-08dafee5738a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxkl1R/0nmH0tD/zC3W1JZjL6wa2xAsFobtDsQZeOTAjjk7sCh4i+GfBr2WMlEBxhGKDbZ8Ftxrd+xC0ITRXupdqk7pxrCiYM9xHC1p0p3mU0+erMV/2z8wSlrsM/G7FfkEgofdGu52KfucPEwUlvNtMN01iGAmORYDnBvqWXP6Z8+uj5ndoCUQWw8cETYfjuozJOrH0IJi0Ca34w1ZbAacbHdC1GhUPs2JwAVPJSA0GSEKaJx5ysY4P4njFKD+EMV14TlJH/qSznOdISwNYGJ9I8MSaX6XtFLht34WI9JJGa3398a+5BbMnTuj8MKi6/V8JyJAqGN47PBq7jymOtxKJM2xW8PCx/DwcsuajAZ8jKr+o4Y/jR6KBV8kLovWZ/9bocbhilAxD6asHCfFHpqvdFLNxgBD5cR91mi9ksM813/OPt+45XXrPww1x4QEQiwNHhETfCuN+XIfAowdXRmQfE2sNkMnPNo3mH7/VhnmyWzEnX49tC0lPcDrM3XrshWjhIZ1BWdHZpvbPSbT2wWzKC/0ZoaV91re4c5JYs6RNBfzUiCrjdWCBE9aYX6E9EIK4pgddBzr47l+yUqOeGhbFlYAUqnRWIYZA4lHGAGgNdOi0BRe0+lslx3OLEFy3yEGuZFNWlZy0VoLfrhPMdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(376002)(346002)(366004)(396003)(451199018)(2906002)(2616005)(316002)(4744005)(54906003)(44832011)(41300700001)(86362001)(7416002)(5660300002)(8936002)(66556008)(66476007)(8676002)(66946007)(6916009)(4326008)(6666004)(6506007)(6512007)(186003)(6486002)(478600001)(36756003)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WQY1KKKcQex9aQkTruBK/iup+K4gO6+OWouO0i5rUZUUSNpWanFLd1voZWUC?=
 =?us-ascii?Q?IYa/GGSy12CxVFB7GgOHSR7+wSa3acaJW4HzaeiEPlT0RVoSY22I/0EJn9gR?=
 =?us-ascii?Q?CBqf+IkH99vjqAl9XWwu2gC16iBnJj8ZOxBIKEFNFKB2730sudQU8j88Hb5N?=
 =?us-ascii?Q?l1/I+7MrN6idmmZlFtJP9hDBSPP69NSdVSs69SNlt6k8fQR3x3a8FVZk6Ob6?=
 =?us-ascii?Q?QpP2NcrrWRdhX8Cur079khV+FMLyNtPynu2LyVJNHcJ6un8yU509BVe5AvQN?=
 =?us-ascii?Q?8eeYCXlC1UwrYMAs65Gf1iyihrXvAXydS4L+bEB2Ls78L/hqIOU2or1U66GC?=
 =?us-ascii?Q?q25DWNh/TIg6FWYPodZwIs/uL/MHxObNmeWaxvqXbpkeF3OOhbWOPAq8lW/z?=
 =?us-ascii?Q?8uh2dPcn5XySA6JQTYDOWeUcsOgmGBo08hQrR2Y9woMr8pA8aVr2gS+GSGTL?=
 =?us-ascii?Q?KmPfRkdfS/SYGgQNdGwcCwvgO5nlFBYnaDJxsDyU1gt8PbIX/oy4DHCVP6K3?=
 =?us-ascii?Q?hW/yWlizDqnGzP0IbDA4A9wF0Nmj8hZfgbQu7nWQ++sIxNE/ekiByoz0AuSk?=
 =?us-ascii?Q?JwLVhOwjs//Ttr2NzAKRISfuoN9GJraHdlpm7irh/tfHk4G3Ce46wu0sgy0L?=
 =?us-ascii?Q?w/P46CZ6uE3GzR6zvMjSGHepRdLL4Kt2qpz+dppTJ2cWxnQrNwbi/xSaV0nB?=
 =?us-ascii?Q?1wNOgl1bhTwAUHuYWZdE1TU2z5Bf6nvX6vzJ0I88bHftORkDH7Ij4Ned0u3Z?=
 =?us-ascii?Q?PFWCNhYEo8tOMjeQUxI6ZIE20kvA+XJhMnlJI5B2+H5/ODTCsfqTJlKFmV9d?=
 =?us-ascii?Q?0Fm2g2uSnIXnLjrRh0CGiXTTKW9PAz0n+jMhk/lhstyCj9r89Dv/KhOEpIol?=
 =?us-ascii?Q?64u1fA/RkIqs8kDWyqLMSl53UMQiERmiCvhxBJRpRztjOAX7ZaEY/3c01tNz?=
 =?us-ascii?Q?QydtoKlDC2d4i8w3gIaF0t9LkVugjXknd8ap+qdEv8WEFju9egb38JnoCvkX?=
 =?us-ascii?Q?cdGdu4UjVCgm9JzN0ox4p96vCJS5yLIiVWvL9krFzajgZGN7tMFgODFsWKh/?=
 =?us-ascii?Q?Kje5mHMOKpmfrhilQEG/MTWIbXJG27phpmEN4AIRGCLSivLlNV7w+8GHjgKm?=
 =?us-ascii?Q?+KWVc0VBf5rOPpWKc/SOKWFWlh+Qpa5cLFsitFNOn1Wolr/gbddl0eC6lPbc?=
 =?us-ascii?Q?sh15aIQb4ipHQn82wgAtj2oROLC09W1PaX9S7Q5zcvbLwjSuLkVsf6sqdHb4?=
 =?us-ascii?Q?jaRnSBrq3QsBynX5/VEBwYhU8oNGAY9gymK6JKVDXB4aaJH3LYSLNwoJfhTH?=
 =?us-ascii?Q?UB71ef/LkFsIqzHGEZCUFUbi09LcE5Y4JTGSkh+v4SSu02T5Rs7GrIhrIolC?=
 =?us-ascii?Q?QiUASOBmSkszv3PcL64f8lxgKRcLSH/uBO/tb7CldVVhNc4hCXJh2ZMa9s1m?=
 =?us-ascii?Q?mgHbmrRNoqc17hJXkLixR6adr+2PIFvrskdvGNvNEw3pLEkvA5TtS++RA/Z8?=
 =?us-ascii?Q?NpFGHMGKpunKk/JVvHfpXwq2oAxl1QqLIEiceIOImUwZToLTNHCwOOvzG1FH?=
 =?us-ascii?Q?X1VptXU6CnUdM15v9w1cxX/ouWwcFDETEVu+C7S0QB5N5O+MOGseUC0cFHq/?=
 =?us-ascii?Q?cGxsDeXLgCVg5FiG0EpLK69hOZppDjaPV0OorXHexNZgpQCy9JH7AOxIdlke?=
 =?us-ascii?Q?9f9gSA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43487519-dc98-4345-d8d2-08dafee5738a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 15:04:26.8303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfeZNtBWaEmoxuxs3PMEsIBRccCBLsHKimpTRO5yZ3SHa6jwItVyv7K3KLcpzXMZUKep3eamkbCk29FxKA9dSFCcPC1gc/KsAhTy1QgYKAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4686
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 04:48:31PM +0300, Natalia Petrova wrote:
> Function radix_tree_insert() returns errors if the node hasn't
> been initialized and added to the tree.
> 
> "kfree(node)" and return value "NULL" of node_get() help
> to avoid using unclear node in other calls.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

