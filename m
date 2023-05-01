Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D868F6F330B
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjEAPlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjEAPly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:41:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6590E6;
        Mon,  1 May 2023 08:41:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7+zS/3as6fdEODL+m9RX+eiHLJYMiqM0jf0wpwdWGSqcL3FQdTJIrR70Ezz0JsIN6Q+dfrg0rIHTMxg7LHhN5plFCpzS4YGSGHRxCmqAU3Zlvy7O4ITheEezk+dNGZJ/iGMFvviCy3ncPypE4H1bTjGFQW4M/TcTk6GWtqSx9tonbkKeTBIuqq2CzZTKAAaWIt72BgqWTq7AIpdj6gZfIOZpi3oZkDjOgbPPjcO95cusYIGDRaPzaNqiK9eX/h3/fBLOw1wkKJD7q3aTJNgRqmgst1wyK3KaXw6ZLACrc64tok0szI0f5VBvlt4rdpCBYPNcTznX+HCY74YsF6uOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UI6ooDAuT5rVZxcrnfrUYfL4JZOF0AoAgyErnH1glyU=;
 b=aoKQgkuvkWt4PGjfF3nBrKfpjXMJ6bWF5ccn7pduVhfPBL6xikjWJ2hFbTRY8VlwiNLljmaTeq1RD2tHnrWavcwqO0asyCORhPof7IlgYcIPRiDTXmONC2JBqcBB46O7uZ/XzHbo/OxJZQiwgQT/vC2Uzh+z+WLqZFL2aCEwm2h635CAgsSy7el71hUUr+2cyBk/SSdj7yYKoyPCSd/wYLcA8CsIDoQNWctwss+tvOeIf6qJS++CHOgDqP8e3wNPYxruwe3Td+EmMsN05o0B44lDQiT3DX8TN8vZIZ+Ut165ZwPUYFskiUeRTLv6nbGzDGnDNqlNM58w1Hfn+ILVVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UI6ooDAuT5rVZxcrnfrUYfL4JZOF0AoAgyErnH1glyU=;
 b=G+FaDcOOMKmwgTAKtW8naMyFUQEAd5DiDq/2NtKDdVteqkQJI8oeN6oOtF13ldEAK1kc50+wgzhmaPH6tZvEQzQqOZu3/0m9jnHNAIIqz/zj4ZCJsNr6dWFu5Vpu+md0JofvcT/T/Pmd+Hnqxc2O/jSfF2wovzAF5wO1f9Et4GI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5538.namprd13.prod.outlook.com (2603:10b6:806:231::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Mon, 1 May
 2023 15:41:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:41:49 +0000
Date:   Mon, 1 May 2023 17:41:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pds_core: fix linking without CONFIG_DEBUG_FS
Message-ID: <ZE/duNH3lBLreNkJ@corigine.com>
References: <20230501150624.3552344-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501150624.3552344-1-arnd@kernel.org>
X-ClientProxiedBy: AS4P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5538:EE_
X-MS-Office365-Filtering-Correlation-Id: deaf7732-52a9-476a-e286-08db4a5a9427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fcqv6julS+s21o0ED/8wZgDnXVah486OqQ7I4+YxACz3EK2w4jDREq2cYJ0YPyTDfJdIoBoU9FWJiNKX6H3uC+GmH1jC+U8vcB10O2YDN7r2k1avyXy3iHWFJnt4DBEn3dmiikqYDDhToEUobH5BPI4lx2myoR7SN8FgeJnwGUb3N325YUzZdj4DqnjYDvO+l3IcefoU1i8l0UmqhEq6qAhEyqwUVtIp3Cc/DPdyMtbVA8czNQsOUBowbGCnVxKni/r9PZ26g5QcToWYkwYreGDHC05w7kDSJfV7uk6Ar2duDYqf+f7knx1hrmvVrXuop7xYPDkhZ8KP18ulcw3dRbnJF6s88qBlZxRgrJHUVZkrMrMq0bvBssGsDtkr1Dum1sZGdNuzLiIeyWC1kZPGbDFK6Lug9BlM/6RLg6CsZFeaytBaAt/aBojD7FieT6tTnqE0nbrXUhIGtrbSDHDLDhLHBXwY26O3M/x/5A/HGKQrWumqnTNXY2tI3IhmdCCYGK/hbeIPiMRIu4K65rKyW2hlJK+/RD8KwyK5XhgQ7n9CQoTh0OG2dHNy13wu3ohf1DCATFxTpB/eN/WPlVTLEDRxVqGL0BlzrrrWum1by6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39830400003)(451199021)(66556008)(6916009)(4326008)(316002)(54906003)(66946007)(66476007)(36756003)(186003)(6506007)(6512007)(38100700002)(86362001)(2616005)(83380400001)(8676002)(5660300002)(8936002)(6486002)(6666004)(478600001)(2906002)(41300700001)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0XRf+5xyYO2jPc25tYLWB32WB3CbWNWQTnfZM09Wyw0Wgi8vLFXVN/UJGbd?=
 =?us-ascii?Q?z15wupdj8VaGqT9LsC1F6HD1+qd7DQpXV2j3OSN9lTrFjNpl3gjRmqDg6wLZ?=
 =?us-ascii?Q?g/p9ZKqYPUwKGopkVpjTUC4hoATMLZJ+aAld5tosI0zEYdXA9OASwOpcN6kC?=
 =?us-ascii?Q?pGf0nwUNSO6ANfVhfnYOusZVLaGEp3zASsiH1u6jAyUt+gUeiWexAl1sw/2I?=
 =?us-ascii?Q?cL67Ukcs0KMS7xnhXBEcrUFNNs4YhIe2gQJkY8rVHpngR4ApXZvMkFDkuHxr?=
 =?us-ascii?Q?S3WYYOd198AKly17RbdgBBq71r5ISVVuu+g8//BhsgnWfYmScZoK27LKEd/1?=
 =?us-ascii?Q?6JrwAcb0D8557+wjmfhH7i97wMDtktt1SULUsLP7h4W9cLZPNWvoTSticten?=
 =?us-ascii?Q?KkSNr78JfkJn/OCjWH+D32rvnApfdg3Tdwi8tP3aH6VejCfMuIYoBPwkHMmn?=
 =?us-ascii?Q?2/lCtgmX3yyD2/A/En7rdTrJG7uiCDWJCagNKuQknN3JXty6wlPr2Hzu6Sst?=
 =?us-ascii?Q?3O7Nj/7I6Hun4O+RO9eHts33T0JI548FN4cgPAS1pl80woyXID4Vqqe6pqLR?=
 =?us-ascii?Q?nZEa2B43i6BEGtHTN3C/mQGv3wYRU5iw7M8rQPQT7GBF6Pmo/awcAqKrRI0I?=
 =?us-ascii?Q?emSFaxanqFcxv4rWL2GLhwAR8PDyfWzLxe3acih8cVt+fyjRM/hZfHS4B7CF?=
 =?us-ascii?Q?UAh0XzitkKhI7eaIoZejQQN2X5cCK2J0ybjoPb0ndB7fxdEClOsGcM+wcFBa?=
 =?us-ascii?Q?OHeQHFJT1Bpxm3H5EFtKQkystu0GSkes58vtJLbqnfyPenXjGTqp5DvrhwQN?=
 =?us-ascii?Q?TnPxzkBwGqa2cjBBM3BF6A3TZhcwC0/dxOTTFd4mdidxwJ3K5dmh6ZvuBo5Y?=
 =?us-ascii?Q?vCDQrj6z9t5Pr4tuQh4rpgXo+D7r6Xs0BzZAnQaCGw1ThapYPtbOyX3WQIRf?=
 =?us-ascii?Q?oj93hx6yiyslPLdaJWQA5kVaNCtCVDdC7HTY6Aahhc7a+B2UO0jKhvRZaTBS?=
 =?us-ascii?Q?zwuvDaeFlKjKQHbVquNB6VG/Mu+REhf90NfXRte01S/C/VjWV9GH4VOm64GR?=
 =?us-ascii?Q?tXSff9EKFFkqOhC3VKodz0BHhiLXttW0elOkNQzkHvqito8QoKP2hE69hsQt?=
 =?us-ascii?Q?8X4WFUarDl5nyUqcbvAr66/302dH0trZiGbkAeeBpEJKmHNt7xf+979WToPq?=
 =?us-ascii?Q?sJMFrHNxtKlD/6q9WG+KDPbxzuoKbOrp+UdO7f+gb+b1B+x12eGNW3J0HGza?=
 =?us-ascii?Q?TCjh6cS9YnKBHoI57UZlHs13iE9N2Q3rLnF/gSKYorKNXDfar36OK2Lhf+1b?=
 =?us-ascii?Q?mOLuL6SAWCiypHAR8py5w5kHSKZP44EaLUejWNFYKopo2F1M1X4P7yR3iE1j?=
 =?us-ascii?Q?WHGwyg+2CX6IQ+nvcCWMcFKjJxNRZ9A9us+Y64Mk/YsKGxElvbnv+yQZnVuN?=
 =?us-ascii?Q?MEeDgR4eefY+Zfiql1ovBHlWiMyMp6fEFYlO+TijKjfujaP+Kq/G5E1ke3Up?=
 =?us-ascii?Q?eHHPJlq/ISHC29CMXV7LwLcGIoT7BkWA9+K8wnFlnkkhrn/3wbIKihRwqMzA?=
 =?us-ascii?Q?l88vyKDD6ksfF5ATpODulD19yLaZhstj9eE2uHXemSn3bD5+vLWImUJPKFUb?=
 =?us-ascii?Q?yX3Yoqxv2nelr4DZPXfWzsiYswPiw/U5AJQWe+dBvrT9Ly8vJfHss4pLO2OY?=
 =?us-ascii?Q?3sqpeA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deaf7732-52a9-476a-e286-08db4a5a9427
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:41:49.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: og0nzpoxaq5yl74OkzN1Ll1oLG/jHLi1XAFpVUghiPO9UCS1lVS68zKXB1VFOoiwoJRtYdYWKUyqZ96YQdMSllJHNsUFxGJB0KpbsVyXOKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5538
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 01, 2023 at 05:06:14PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The debugfs.o file is only built when the fs is enabled:
> 
> main.c:(.text+0x47c): undefined reference to `pdsc_debugfs_del_dev'
> main.c:(.text+0x8dc): undefined reference to `pdsc_debugfs_add_dev'
> main.c:(.exit.text+0x14): undefined reference to `pdsc_debugfs_destroy'
> main.c:(.init.text+0x8): undefined reference to `pdsc_debugfs_create'
> dev.c:(.text+0x988): undefined reference to `pdsc_debugfs_add_ident'
> core.c:(.text+0x6b0): undefined reference to `pdsc_debugfs_del_qcq'
> core.c:(.text+0x998): undefined reference to `pdsc_debugfs_add_qcq'
> core.c:(.text+0xf0c): undefined reference to `pdsc_debugfs_add_viftype'
> 
> Add dummy helper functions for these interfaces.
> 
> Fixes: 55435ea7729a ("pds_core: initial framework for pds_core PF driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


While exercising this I noticed that building pds_core fails
if either CONFIG_AUXILIARY_BUS or NET_DEVLINK are not enabled.

I think the solution is for PFS_CORE to select both CONFIG_AUXILIARY_BUS
and NET_DEVLINK.

I am wondering if this is on anyone's radar.
If not I'll send a patch.
