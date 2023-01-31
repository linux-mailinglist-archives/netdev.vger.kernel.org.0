Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EC16835A1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjAaStc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjAaStH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:49:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2115.outbound.protection.outlook.com [40.107.94.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72D193C8;
        Tue, 31 Jan 2023 10:49:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQVs3FeLy4LvMCDZ7Dq98h1pZHJCU2wlj8fDZFVV2y6dKLv7G68aXo6OqA0VLZbzfuaEBFpuzXZFPT2Fs6GWqLrCaq5nCAB9afgDZjmM8qDobTWYdn8rvIPKZyYzKEAhTvDgAsEx8htaWokCauJVwl+f5qd3MHdmKtZHwNESf4EBKqaa0b1AOA7vF1oXaTyfKwB1ojfmpE3FcZJ2dF08/RkFOrk84QFW0xqphBVfHtukEWB62kduLaqM8k61GJ2TEbkFIKUTT75WKQrNrvTeJr3Y/Lc/jzVf+F1B71hdn6Wz4L3XXeT2+QK1IokKn798AMKP7She8tjHcTfPk7D46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUcgDp9KlkYc1HlHw38vE4TY7VrDrj5QfGPjak3SpZI=;
 b=nU/rTfxhWMbC3hTXf+M8+oUu95X33UgW29OGCpVy7cAENCwmMydMAr79DsQKZq3oeNSQpioO3Q1m27Avulrg2kw9HAdiCsHUxE6VL9sxLI+Jvi7WifTcnFa6fMo3+4WlLniF3C5kMmO81uefmMoE6fjVKM9I7ja/JeH6c1DEgtE6W6ZoXUoQhqtelu/wP26mKh5iuNrote0awwNzVUh1Bf8znmOHCJUXCSmAnEoFpiXMb6Z1VwTWq9L15BsN/aEbC9ujE2+GKCX2Gxi41KvwsWedfiL2PgMfWsoUZGo2I9MpcFhG701lewOnu+t/pmUQ4zU7Y4fJ5eh4Jnq+VCUVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUcgDp9KlkYc1HlHw38vE4TY7VrDrj5QfGPjak3SpZI=;
 b=GYkhmA9EGoM1A+tDw8ZwOJ7lsDQgM5e75BJbvpTYbJOABOlCOEOPzD1Kfnytstcl2V01SqB867uiAnnCzWWM0PLpIS6pTexlttNlRgg1RTcENipKfX9TH1Py46YYPcL8JFBb7t6owbrTzYOeqd6VtSHtgG+2bYFWU7wVP6zmD5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5868.namprd13.prod.outlook.com (2603:10b6:510:15a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 18:48:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 18:48:57 +0000
Date:   Tue, 31 Jan 2023 19:48:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 2/2] 9p/xen: fix connection sequence
Message-ID: <Y9lik890+4G4z6/Z@corigine.com>
References: <20230130113036.7087-1-jgross@suse.com>
 <20230130113036.7087-3-jgross@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130113036.7087-3-jgross@suse.com>
X-ClientProxiedBy: AM4P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: bb93c1b1-3e0f-4562-a850-08db03bbcf1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uIvKSc1WpVgAgjrTIVMNv3QIOectieoR2KLpyWjyYniv52654lck6aBHFOUzxQtPXiZQznWLLwQfPV1U5/yHdcMK/HMdbGtyZW8jAYbRD7uW3nqatCxvOTS3DbDlz9QSZP1f8epbHF2LwYh3YCf1yw8rV1IkllEOqa5fZ8eZx3TB3Ty7dgdSpcJWkPKvTTIDafBBClEMRGNWxYydMlLMG+LSujMKyrXqRdyCb5bzS3fWR3ffRdHAvRtlwal/uBZauBekr4i2Dh+UraPtBlAQpA1Iaz26BCM9b5oUZfwuS7zfuxarcCwiuCJsQ+6CA0GhucStEcd0jiI3kxsNyfdHBqDnOqTV/xoHtEDCW0PnCuE+gxePTFQy7Zbcjl4N+7y92lPg1u92uoM2LYEPjijqu6o32NNjJJ3E2ojc0SL2JLZJ37XvNmfMwbfSMESGq/6vr68qp2h9bA3rExsZgN/3gd5Vy73M8nr/fGh9z7UHaYZrRdtatFi22doPZQpvj2M9dadnL/dMghg9v3mjyGC3td92eduIOVggR0Kzqhz/rChjrAvwd6xoilpy7xnR+KDLeyYdJYW5Zdx5EC7HbbiueED/vhWfQhHQqZ6M09u4x5g2Dq9VyglwlyGj/rIwvFPU9pvkxgVTARGMS/o9rPfMVp0RkY+r0dAjloESmp/kpKtPgmM72AsJiOhl0bH6qARmiuBhOZzSevn5ki4juzzLzHeSJWkTgxZJesVON8vNmCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(376002)(396003)(136003)(346002)(451199018)(54906003)(316002)(8936002)(4326008)(8676002)(41300700001)(66946007)(6916009)(66476007)(38100700002)(36756003)(86362001)(66556008)(6506007)(6512007)(6486002)(186003)(44832011)(2906002)(7416002)(966005)(478600001)(2616005)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFaPLEzdJ7A/7d4xQuJG+8eA9pdEtoLmOha8vxcpbBseR726YMX+j3aKBhxQ?=
 =?us-ascii?Q?Rn95A91++RZe4l6GKptZqd4Em7awbJjy7FLv1Pq2zOe8SBLdjGwLWIi4aSE0?=
 =?us-ascii?Q?Kw1NGM8J7lsGdsZXYAAqB0hBXbITiNTb+kO46YXWPMXHKRaF1q8OBn93SITT?=
 =?us-ascii?Q?5Z3GOSHnnuIKEiOf3XQe+Zs/XPBjAnEd3s6y596EUYygIExiIn6OxDRIhYiX?=
 =?us-ascii?Q?4v/t0Toh0CA0CzDdbcKREMgXQuGQDYlBXhlCXuusngb7LmEEDSyAp0QpE493?=
 =?us-ascii?Q?9eUWdezHmrmaoNeeplw5Sos03tSuXtsdaWqAOgmqIdPwHoZp6rZD2JqC6SEe?=
 =?us-ascii?Q?osxsmiRUw0gXNHPce2SKbJEF+cn/Y+vdDU8g2L8etUzd4HjdLakIiQA0oeFq?=
 =?us-ascii?Q?8tDr3xnoi3T30kld8t7wlEb8c8nNA3oOOsUKL8tooAoWWNcAAMFdKp0apE6K?=
 =?us-ascii?Q?DZhJhBBJaO89uPRxXEGgwaSwRs9wGQzzyspVzYpYpDXEdV4bxYPVPgb7FcKN?=
 =?us-ascii?Q?UrQXxBGkVHWXNZu35d1ER6PrMRPEWTajbCTLGGqTy8QgI+O/W0b5OvUbDT++?=
 =?us-ascii?Q?5fgp7Om2ZLBMpDUvpaGcrIyRcqEcJv30ee/zPZT17KWy9WVaSB+FDJnNGvVE?=
 =?us-ascii?Q?5GoiLOb6lGCUVM0SclAlzyFbcKlASHSaOOE71vWNPdnMF0SAp7TDAtW+38v7?=
 =?us-ascii?Q?WXKxkWcFvd/b2OatEiTtVmac5t9MC9DzzfDZsRkCARXrPlqXmIW0EOMtwpS0?=
 =?us-ascii?Q?aJVVSbQqOtk4ztneW5TMnnOSgjuGksmWSm1LLnUHGy/VfkTSqtZs216Yr/xT?=
 =?us-ascii?Q?fxUEykhUgMwrSk05xoNju0MFDIzox+2ma/7QrA/yoTLdoFHHq7K8NYibWTuI?=
 =?us-ascii?Q?VFCtq4mv4gOY992mHsXNN7Y+aIJgygwpLrZj4/4M5rOvLjmQrJ+m57CB9QFk?=
 =?us-ascii?Q?Ev+P60BdBGeA+T13wuYz9jZ125OrB8cDiGNjtRzmjzpws8cRelM7ccgPyrtr?=
 =?us-ascii?Q?f344GYQ08Gf/L2U5ncG/pIXQ4lEW6gIROzWHz7LcP/rYo5nCJnFtqWR4f1zu?=
 =?us-ascii?Q?teLS3qi2DnOZa221mBBP49alUcUnesYFww5lbDpm1jonm/6MFwkNNpsfSTNo?=
 =?us-ascii?Q?/1qyRpFy73fjkbJ2Xc+QImDnppNMEDfnMdjLP03JH7MQI73dAVuAVkb2qAML?=
 =?us-ascii?Q?sJo/Uwa1Zf+uojlgBVwSg8IdDTNcOI/NdHGI3vBWIFutbq6XR4tx5jSjJCyh?=
 =?us-ascii?Q?81Mb+TwRA/SGgqfUUejiqQf0pVPoXPjlF8QSnSIN1BQe33rtA8cZTKOQjuyf?=
 =?us-ascii?Q?Ivf3RwdvyaXkKbmr92nkKhNx/Zud241YBrS+wwlkv81UUide3am6CYfmy7/l?=
 =?us-ascii?Q?SukSY1iJiGi9NS33PL1F+796aBXy/XKvQwDuMba4QU4+bShL+wftQhGt+TqC?=
 =?us-ascii?Q?mcr622fciBEGosXSgXemTiL/rJPtEYH7IyoQGYZH3ef4frIWY1KJQTV4m/7c?=
 =?us-ascii?Q?7sGzDZk2POnsj6KM9PvQGcZfq2s+XGKhOvHv5OA9vc1br3dVv8U5BCVSzE/8?=
 =?us-ascii?Q?LVhv8abi/tYYXzZ6ND7104uqebYYQlrh35UJCParT9oTHxJiuNYay3id2CsZ?=
 =?us-ascii?Q?nXN5F9bSKn35lt8eM4XRXwbtZ8SWXzObb9Rx78sGHi+FlXSsgQ6jbr0XUOvG?=
 =?us-ascii?Q?Cz6M+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb93c1b1-3e0f-4562-a850-08db03bbcf1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 18:48:57.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpheZB8boZE1FrAs0UlcsNaK/EVyd7gjigtGiuECyjC6pp5OwQZCmkSnoTCAWQmCTig+pg680p/u/znnJ9lKNAuKMdri5pcS8eabBG3m238=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5868
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 12:30:36PM +0100, Juergen Gross wrote:
> Today the connection sequence of the Xen 9pfs frontend doesn't match
> the documented sequence. It can work reliably only for a PV 9pfs device
> having been added at boot time already, as the frontend is not waiting
> for the backend to have set its state to "XenbusStateInitWait" before
> reading the backend properties from Xenstore.
> 
> Fix that by following the documented sequence [1] (the documentation
> has a bug, so the reference is for the patch fixing that).
> 
> [1]: https://lore.kernel.org/xen-devel/20230130090937.31623-1-jgross@suse.com/T/#u
> 
> Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
> Signed-off-by: Juergen Gross <jgross@suse.com>

It's unclear if this series is targeted at 'net' or 'net-next'.
FWIIW, I feel I feel it would be more appropriate for the latter
as these do not feel like bug fixes: feel free to differ on that.

Regardless,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
