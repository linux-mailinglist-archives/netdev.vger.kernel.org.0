Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7D6F4719
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbjEBP0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjEBP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:26:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB830EB;
        Tue,  2 May 2023 08:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1vfo9Enbpioq4NfC35nw0ObYesHy9OU0o6YTtiqQXcgTd/VPHbM0dCER5umNQF1WyPMMFnuc98s8HSXC4YZMD1gyVh8dOepprNUqv8zT0MlzqD8ArVz1jQ4IHfslKzqxinGDwkWhBUfZGB1zXqZFM/iijW1odZ6oDa4s+RnEeBbriIQ5YnuD4IotdPJinHcTZ45ACs584T1Z4dqzLtX/eAsQ6yxuQ4/JAM+YC4+g9wkA3Q/idbapHypAikzth/LymFBi/LtdKc9O78FbX/dTKG/Wi8yZO0i28eoki1LBVoQnsj6WVOCKtMzDb7UiF5pPV8E2Ug596cC5GfcXcIIOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKSSL1MuqPlVL7uJ+UaFiY9t6QrKipil9fXXzsd7Lx8=;
 b=UgNKyDVY9Q5ChaQYTtkUbrlXW9KyBndROWXqJGnKOzZauRGVPmembk6JtkPVMUFGZfCU5vOMYCG8teAJz9v6Zi9YbWcUIvxevP7sxPSNakgEdH321LzL2BIa+GgO6/3mOMpDoSpEJEWi/Fcqs+dBNW0kKJY0+Bv8gJKwPw9Tl2PGWsAnOwvOkVM/pKGKH+Uc1r35emqIzlVkYF/xj8aRTfXC2vNo7NAExVhOTQdGyFCvui5bu10VP4KpFoCKZNRgHQY5/nFUbo4C0hX9TIwPHyOhRwkZ+dLV2sID3ldSNWjQW1a8f2vSEn9tCKIHCTRqn34TnL9wcGJ2ar+XGobACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKSSL1MuqPlVL7uJ+UaFiY9t6QrKipil9fXXzsd7Lx8=;
 b=dBvXzU3cXs/2GC78x4R5+wvggDOvkydDE/ERETfynBrWEj0EbFs7tTfJXHTTt+P3LwvOuTZeLTbxeQxTIhwhjP+2sAxFY5aU+0G2iAIQvekv4PKlKGwlbrRp5QGY+T2cLrwxjDXbqBzMoq/w9LLau6hTe+xdcDh6M+wHrrWKbFM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5812.namprd13.prod.outlook.com (2603:10b6:806:21c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 2 May
 2023 15:26:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 15:26:38 +0000
Date:   Tue, 2 May 2023 17:26:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] 9p: remove dead stores (variable set again without
 being read)
Message-ID: <ZFErpgo7sq+49H0q@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-5-efa05d65e2da@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427-scan-build-v1-5-efa05d65e2da@codewreck.org>
X-ClientProxiedBy: AM8P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: dd8d8e6c-5cb2-4345-29b1-08db4b219f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXsrObXhUbj87weM59e5vAKCPyvhTHaSrLN6oTiYVH4EoIgvU6FE28VCNH4h1FfnDRd1fDfz3zrIdMGBah5XEDg9QSg3E+OP/ZWRF4TSgcGEe5okVHEt5bK2WVOI/xFUU8CZUsyWHPGX195URBWL9YqyL3Eab3QG2oXwBW9+dUMOb2trYAWEf3JK301zI1fIwUW5MJAFUm/vvSHInShx4cfrG/xqCqmt2uds5Bl5Hvn/XHFTM5KwrAwlNeozW0MxvpGKkzvDcqdIxk3nCgPDB+9lWad6YHH7ibVkY9QmZkX4lSpXrskYUzP8UiI9Sv62ZK0K3kwzJO3T0dDTzNT6sJcXAOlejenBPfmoz7+NU4tpEKf9Jtf9M/M4wlm+MvkkvW5hv9n44ZOjXcldHBv7aYsbPPyWzxkeTPQdRJRPi9qDFJphdQBtMCEyN3CzvachSt3yQCW3zydFdCKdLskX/+4CxFHFkaPAfzonHdllmtNGUbVU87vp83oDJRWx9mF/Xv10EEagEzJQl/xgtT1P+DcI7HjNoT31eRKr4ap0HIvlfUMp37psZfNUXiIK9tg4ac4bTKC+xtMXsvJHD55vCYejSaxhJCXn0hPsJLuAQP9ZMbQkquaHgeoJw9KxFjzQYIQoE7taEaAMcqY12B6zTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(376002)(136003)(346002)(451199021)(41300700001)(66946007)(66556008)(66476007)(6916009)(4326008)(54906003)(6666004)(478600001)(6486002)(86362001)(316002)(36756003)(83380400001)(6512007)(6506007)(8676002)(8936002)(44832011)(5660300002)(4744005)(7416002)(2906002)(2616005)(186003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/wY0lDuzSSooCFvIOL5TcYw/ouSZMLsAL6S5JxaJhy6xovnNj1wRZdb4ssjl?=
 =?us-ascii?Q?2eN+2gGYJy4DhSV3s3QYUuSvexO9/AqGR2oBqtLqmX2d62gvDbDJNKN/OquT?=
 =?us-ascii?Q?Sh41XHgjw/Rrp8D/XRQ0R3q+sQUsEMFasMlmQGNhLMS7LW+fwV3FCxmDedwn?=
 =?us-ascii?Q?cVMSMzxFMLTLr7cGr3OUkLF77c/T3zyYySRhgW8En+f9kTQomZDXvqPOscwt?=
 =?us-ascii?Q?admMvZfSmrL3nzgBOxk5nPRkCcKLSoftL2AsKFXBcOmjHD4yeaQzahFspuRe?=
 =?us-ascii?Q?KFoUqPmjM71gSMsETvVRMFGTmm0ZPocoUHjzLd4i1Z+fSYeSECgsoX3a9JYH?=
 =?us-ascii?Q?r8WFwSx5jo0fpMjDS6TD3bSLmXIYTLnFcqByBN4W4OSqHR6mGsfDRuQ3zHf7?=
 =?us-ascii?Q?hSGBS/B7prkSd99pCl2LZmm+59vYjpdqAhVZ61MIfHozbadffynsV43QV8BD?=
 =?us-ascii?Q?1MzeKufqd8DGsCG9lKcv/fHQqNnjW1L0j4zSpQFmqZCdU31CGNFCpgXH7AAy?=
 =?us-ascii?Q?ZD1UMV2L/xv33XJUEX8/2J2lb2kX2vTvqpJae/776Gg43J//RU2iRuvlFysa?=
 =?us-ascii?Q?mHbzYIUx44QGR15U52XhvSZdAEZeu0NUC5L0YCnyHAP0ATn57m2GWcZqpqjM?=
 =?us-ascii?Q?TiBs+6qAAcziTKDQxIZvJ95tyJzqoer8+J1WiOV1frh4mYQFkOrrYONUXV1f?=
 =?us-ascii?Q?PdCJcTz08e7+j6jiCYuk2xAG7bEmMIHX0URbdkg9Cw8yPMlN7egDX82xhb1E?=
 =?us-ascii?Q?IASznh803J7QDIkEObXI7TAhTanrieFLL+5u3A9rLiAJUwu7u5WxlS0mDt/m?=
 =?us-ascii?Q?x3ZV3lDSESbCsI4FOFBeMwvlbEfZDvZD+hmHjLR/qRtEx4g+Wopv+nQ2gt/U?=
 =?us-ascii?Q?aPpT7Eq/WOAoRmL60ZUYAkQUCI7iUgntiWydkpGBU1yCOMMP1+CT6oFnOIy2?=
 =?us-ascii?Q?O/VLxdu050GRLmlleLrmRTqeAUFI2z7qgQ6KQoMt8OovZSqkZZsi4dikT3P8?=
 =?us-ascii?Q?whTE3jXMsxYsjd+Y7RBaelP+yF7qMMEn1yPh0jHnYx36CZzOaD6N1EzpTLGW?=
 =?us-ascii?Q?EwpcL0xIAoMF36nu8hzPpHhfKi3m5I4Oh9i3hFvsav75sfS6io1jIObo8n7c?=
 =?us-ascii?Q?+WDbYJu05tndu193H1sKCVsp8RxMBQmPKMVl53t9SBj9gOj+gR+crSyduOFq?=
 =?us-ascii?Q?o56Rkhq8gCmfqLNK7m422LvFZp8v9Q/vkKUES2Y6stFM8+0S058RVLvUpW5R?=
 =?us-ascii?Q?v6onsiIlAnW/wsILGh+5XDRlpLbV9DbFS1CROsWoxgqnRMh8rwHI2MVNKmw7?=
 =?us-ascii?Q?THxrzBuA1/nvZGqeg8NTqm2fNkHZZWgA6mEr0V7YuHMPsiQq9vtaync4Rhsq?=
 =?us-ascii?Q?S+49zzgECj8oGVj6JtSmxo8GqdbGgh0mmBflHOFciThYoo1ohVmKboA/5bTg?=
 =?us-ascii?Q?uu29JE3ZBMpJy5FKSmhsNAOYSjOFAcTG1uV6SdwYnJyo34e/2ovD20/bZQMR?=
 =?us-ascii?Q?jjENbxhl8ZdRopzy/2xXJKQ+ivGebBxCSaaXZXdfUaWoSUTe2gZzk0zc7f+g?=
 =?us-ascii?Q?41+5GY2O4sRw0EnnC77PJGZdyWDb3sBqD7oDGtTgKusaMwo0DYpzs7lw4K4k?=
 =?us-ascii?Q?ZpF8K1IHTdCffI2OBL1fxEDE1HAtK1bx0BiPD6XV2ZEuTptifJXaht5zGsDe?=
 =?us-ascii?Q?HkqzvA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8d8e6c-5cb2-4345-29b1-08db4b219f0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:26:38.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnJF9PfbemARxExphEgZ7HqiWANBuufv3seRpYJvYEsaHiGCxoA0Ot8h0nZMTq91Uujcnc/eytlSJqYnGRS+iNeCtqnUHiJJuZBrTkJMKI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5812
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:23:38PM +0900, Dominique Martinet wrote:
> The 9p code for some reason used to initialize variables outside of the
> declaration, e.g. instead of just initializing the variable like this:
> 
> int retval = 0
> 
> We would be doing this:
> 
> int retval;
> retval = 0;
> 
> This is perfectly fine and the compiler will just optimize dead stores
> anyway, but scan-build seems to think this is a problem and there are
> many of these warnings making the output of scan-build full of such
> warnings:
> fs/9p/vfs_inode.c:916:2: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
>         retval = 0;
>         ^        ~
> 
> I have no strong opinion here, but if we want to regularily run

s/regularily/regularly/

> scan-build we should fix these just to silence the messages.
> 
> I've confirmed these all are indeed ok to remove.

Likewise, these look good to me.

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

