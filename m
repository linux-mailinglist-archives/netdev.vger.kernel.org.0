Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979566C8710
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjCXUux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbjCXUuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:50:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72271EFE0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:50:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGNMxAUJBFTfcu6+KGQESAd8A+SZ/2ybKVCuHzNYvzULpvl3panAccbUSfORjzsrcuSYBfWA9VLVeBT8Bekzk7dGSyI5A147UxMPTM0hhEV1/WXgq9I9+P7HAJT7NJuecim7DQCQ23uLPlqeUzcQoM3643Zb/+pD3iDmLOtYaYcAOTpSN5eXp7h3pXGrFBCAPI/ehbbVZ+pBnAuxM8I8jgQo8AG7oNoFV5/6EI50uPhRXzUIbDsUSZUUtx+cktDvwyywQ455UgadbAgLTIpcrUVNfwk18AXzYFMMx60GxrELSYKbgmaFnJN/rPZa5NlVdjHJxkr0yTwJIC2pzp+qew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQotUoAdqJErj/JeVlVtdCEs1RNSo7WqNzE+KH58l+o=;
 b=HXGQf7X0jHloDxLtswKVR27/P9x48zSrjca6rkD+CKqNTWG3YffhwUJrifBX+7BefqJ2uZT8wnyEYPV7T5wTF6MX0nS9LnmacmF/MjDwqx5cKosmF7ufE4QPANv1L4A4/nnZq3kjAXez2sy64tJIMu88bdGvT7rTZ0VTznxeGxofxDTLCph45btc4urKHNrmsQGyC8OGTbdJ4C9hgM9WHsywm1MGvVrrbByKMX2iMAA5H/xSkhvLypW3us29UmIgeKFP6tsWWYDIZPaO4jJDjpK3wFJM+KiaO8BHzmsJVeLNMCZPbbjHTD6igHT90kTnbUB1To39vSRcP343Ug5c2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQotUoAdqJErj/JeVlVtdCEs1RNSo7WqNzE+KH58l+o=;
 b=EEnHhVTvE6BoPSJuaVjhsQ+MhdDsulNa8X6eEgAYXepGwHDbfmayAKIj+Z3h3Bx26fxtsa2vlhJO0ca/7+NdD3SHtKNbh3UXWA8f1UPVdSJRX0xa1+ywq+rw0ylNZAQuZqkPspaBwvSm9otc5GqYpTSu21gODI/x42KKHr1ti/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6253.namprd13.prod.outlook.com (2603:10b6:806:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 20:50:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 20:50:46 +0000
Date:   Fri, 24 Mar 2023 21:50:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: sfp: make sfp_bus_find_fwnode() take a
 const fwnode
Message-ID: <ZB4NH6X3TsNV0/N4@corigine.com>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
 <E1pfdeA-00EQ6K-SI@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pfdeA-00EQ6K-SI@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR03CA0072.eurprd03.prod.outlook.com
 (2603:10a6:207:5::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 04532d9b-9953-4d0d-8992-08db2ca970db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tPe7x61llXBCyDdxQCRnPxDN8igJ91oX1E0JzIwHplkclr1bcQXJZMqwjhFExwQvPYWujHZ9a6Par4JOrVVsO0fmEwzFx8ioO6Ox38uBwtVG1MKfFdm9+rxQfS4+6Mvq1TYxY79Ob7il/xdWmduayIySNZ8PdeJIeJ0Hbu6ksfNWy1f2Qubm4ajUqlQrHdhaluvuJ4LQuiS+4XpLTa4aVElnTlVEWfgpIAfOJosgjCeJtK/KuJtCF2wSqDsLeM6ZWTJppT+AFQNKB0ztK49HYCQUnU8eB95hNX+mRZZ0o33X9pguku9UZB+FBZt9z9nfuNNsDoW8LiEnmk6DIeVyV8Fzs0+SZ68XwOY6MITyrt546IOrEBQoDTteMMcGbo9L2wcVGDZ3tb9au2WJNiMr2JOvZIi7LHVoxoF+xzXCgRRmefkDie4iv5eDUOxwLhNLbfi8DaEd/7bZVK9+p2hqvQa9Cv2jMHs10HGYixl/GAhFyKSQ2R5RoJK/cdaTxRH/4XYOch0plH0GxdVh0yUHXjQTCbJ776q905pN9JXlILvgIjPoD03hUBaV5HACRCa8PTMRd51E46rTKgrgwumLMKFoCGniMcKp1WAe2zHnPGXxsRKV+/Lflrn+6Bf2Bv86WpShXuJnAMCsI6aCloilEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(136003)(396003)(346002)(451199021)(478600001)(66946007)(6486002)(558084003)(6666004)(4326008)(8676002)(44832011)(66476007)(54906003)(316002)(86362001)(36756003)(66556008)(2906002)(2616005)(38100700002)(6512007)(6506007)(186003)(5660300002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AyWoslZ9ndk5cdhCWbybnjOi+jNSm2hd4CIhgo0jjRcrVYIOVbwBizr9dLgi?=
 =?us-ascii?Q?U+RLXRoOjuk4KOILAieAmvP53GRaoPHSFY100OfLKwTLVcoWocfBodFyjOiq?=
 =?us-ascii?Q?yAC8nuDGgXPbF7if0SrvB/p/i2nBrjJ5xk99Z8tRVPWadl8UbXXOBk7+nF5l?=
 =?us-ascii?Q?Vprci/WdabmAxqmxKAMpJ7OSFArtGCfgU08KssKBA/ap154Y2MY0GuAFDgp6?=
 =?us-ascii?Q?uQCI7oiEtiXQsC+dLBYceZbSGOeUT7OK6FedAWIN4fSfav/Cc24GvKhVyopw?=
 =?us-ascii?Q?HinWZqPY9TMSQXSg4I3GWHFg959y1vXsRZv7tjTjcC3BACYAaMRla5Eb3gpq?=
 =?us-ascii?Q?40KLKjbFAE5r0ASHJk285eW5fydvewSWhHyg4+hs1GwLNYRyIJSEk8zqEfjZ?=
 =?us-ascii?Q?EYP7egc5W0LTgUcPljxwqPu+XKNfWeSvjU+64LuFKXcNRp35p6SANENgS28E?=
 =?us-ascii?Q?fF0yVFwaaxXc+E9U5D9XjqGWYKKVFsNfeaa5qqswsguo8LnzkhdFMiVChOlF?=
 =?us-ascii?Q?MQIipzqp5sPvzUB97Wrt0sIEvmshXVMZSQVbslzJAQKq/yGWc73TY/PjoAx6?=
 =?us-ascii?Q?ASxC2wgzOOE0QSQX16CAZ80TSYby8Bvnv2ldjAvaqWeQsfoCKL/F/xwnGNn9?=
 =?us-ascii?Q?cAKon/2rrAl5VkdRnj4bZtSjNrTMe5sqE2eB0HM9RmFRjR1v2hpAGPJw3klY?=
 =?us-ascii?Q?ZV6OTmEtr9EpbAkGMNRpjU2TgZlnbbScIQTPI7GvEBmZ46qFhMSoYAHkjc+b?=
 =?us-ascii?Q?WA0JzvHFKXzIIV35J/CUk7suQJYnA84UGYyWcxCkE94BjTqDnhud71Fsx3Yx?=
 =?us-ascii?Q?AGf7s3qscxiecq96zE4cp8qbcUhp0/DiyW1IR65UIKEbuaYMKhexBoL4ztnO?=
 =?us-ascii?Q?fv/NkSaNWT4HOa0o3r+JnUDxfriZtIphS0H9LfAEcOJVOYTx/n/77RHNhdbb?=
 =?us-ascii?Q?hiwW0uo0xIYXxtoFBNXvKMZk+Lqt0yBYdeScpO7B6yWbfUkpJjf78W+TiJq4?=
 =?us-ascii?Q?tPPa1WIV5HyI7GodbgXlMbTAfh7aXBuCHGrupmm2SFgBm3MqHWlnNaDX/nP4?=
 =?us-ascii?Q?YwFCsJ3698kVENPVrs0YMVVRdU66clgXxuiV47TaPWqh0W4aS95kLJ5av5Ce?=
 =?us-ascii?Q?P8PxYscpQU7dUJWX94vX2ArbNnS3iY2RcRcp/sty9QSsgng2Q+gPqZvqlEN2?=
 =?us-ascii?Q?nJezjOajk8tN+/8gfYtXnzOsdswILs5l1OI+9UUa+8MtNMkNI7PMWV4oGlP1?=
 =?us-ascii?Q?TsTWvkkDbCqqXRw/dX+RSEzz+qOCNwPVLgjsB3L0qlX/LJEf4891t4TZiNBk?=
 =?us-ascii?Q?nlnSnQJL6EW3L1RT3qBIMham9q6i32ASF2BUadlBNnSNm9R59q9gXPdF1C5I?=
 =?us-ascii?Q?5fe4imZYWI81douOmxM2cvuEtimWGKIhiOhjyoDbJozGDyt7sIwcDy49G20K?=
 =?us-ascii?Q?YSK3RSF+j2QAPpjlkFVYxSU/V7s/QXaQQk+DIKK3ZMgibEZN+YlIm6Cqoak4?=
 =?us-ascii?Q?NoNDooqPG4KVTxGp1OxiMBu+UEt/LZ6Rn7oilFh8oGnzl7BZMlyT+xdMhPyk?=
 =?us-ascii?Q?qZUpzm3rrosViEfQNkX2Hh16qcpoYFBmjgCOkreSGKXdB8mDiH7mpXl4UanP?=
 =?us-ascii?Q?k2oRrbW5gplSXl+pczkmQpW01MBNEaagi3iwMPl4D+NT8OyB9oDyG/9JAoDr?=
 =?us-ascii?Q?OH//Og=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04532d9b-9953-4d0d-8992-08db2ca970db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 20:50:45.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPDTF1iqLdVJlvWQULCc+SzbPtp+ZzDHgn0pt4UZpMqfKStMCKMXH5hnP+fXqHdqP8kahFPVwak3f6esGM5wBzQE9Q7QaYCubEqfN2zqp2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6253
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 09:23:42AM +0000, Russell King (Oracle) wrote:
> sfp_bus_find_fwnode() does not write to the fwnode, so let's make it
> const.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

