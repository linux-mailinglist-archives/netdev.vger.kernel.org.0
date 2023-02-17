Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C9169A32D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBQAyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBQAyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:54:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58BA658F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:54:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYcUlmGlRS4cEgNlHdoAtesa2cDnU6uXyUFqmbwlXEA04jtGw0pSmtonr+ba94Dqypj9DHUVtgxgfX+ge2yPL4slzxXEJCRuu4/MGBwZwj6aGB9qsMyj4Mkz7A6enlYAXI+Y426sdh2ZmJRTjaM+6H9a+0hpuP8ADXYyEur0/HlGtP6w6OE8C1ZW7J5/Jh+cqA6ADNtULam9LDXHEs2Zi0J7Bbp61zihmzvDNLqjVIGwIA/uqi0kP5Na+SynA2eU4PwYXM5DJC4MjiZ7Gr4CzIC55WrqITiNkJb6TAk5OJFzPraCYW12zxBQcKzBYVL/Y3Ttdzr0uZ2ADnlzjnYoSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBkE5YtCncnjPhF28LYZIGUV7GICNx4k5JDTj7ehWWc=;
 b=eDs9L8l4tgLYdRh3iUcasNt64dpyOs4QVRb/ZPEJybd6gv92tmhisaMN8qDs5CsPAT++QvXfZLSczeiZ/hYQ7FBpEY6X4JS47siLQJI76jzQzkOL57dogJPsalU2KMOeE0Kkd/Vx0SHytlw1c701XPPjxokOv79Mt8/h8WLV+34PoMuK0sQubBmQyOvdWFuoNHRvM6SwrexoZOgDJejvxm3FgtsrjuzQ/FPU2wFeuCG9l3I0QgGkSH8zxXMe1IOar5c1lr9m3GJMQWjvHBqXDnnoKyzTu9uOoh711M1GdDQLbRdf+eeqqXPKBYA0Iy5vOYFn+GVroxMvMNS9tUC0lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBkE5YtCncnjPhF28LYZIGUV7GICNx4k5JDTj7ehWWc=;
 b=lpBenfcKjQlDrMVca/yZbPbW0RO9Zfq3paOEaUlqDsNX9LcyhDe0Al0bUG04miObbGdVA34ok6jX00nNyzg5Ety8GfJwytml9R9bPHXAlSFxnNqbr24UZiTXqKkJNADB6Q0j9uw9TXjZ9/cy2uxGSnyXWl8kCVVyVblRgjc6di0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Fri, 17 Feb
 2023 00:54:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Fri, 17 Feb 2023
 00:54:08 +0000
Date:   Thu, 16 Feb 2023 16:54:04 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <Y+7QLNPxJIf8uFP7@colin-ia-desktop>
References: <20230217003845.3424338-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217003845.3424338-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: MW4PR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:303:8d::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4553:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a21a4c-0f65-4c54-8089-08db10817989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2cYhU6iap6ORO59jzcMiC+KilutC1VVVuh69zHUAm/5Scpue32qfT5dvfJL1u1nzRLhIgS2UiwLOkO5PJ4FwUZN59ETtj5xRYhMhwShC2Iuzo/WCp1iOPnDLJTbI3+xJfqC1IDsCuomB6qmjR7z759+DyEFYMeWDebnTqhfcTjskMjPMN2ve6sau+fCKYFaq9PJVMKnHQDeJp8OmfeZcOL+UZyjaum3qnJ5uys/2gXL+QIa1Gq1ye8vzIgCUSjdaVCnmo/Q2T3AVKqDhVs+3RjomsHk+sNgm2FJvT/92o7PERg5N+T75gjqepfn5y9Gq4Y6EzkUevHTwAVdkwym8yT/Ml1tSSsaaCwbKAOVxRC9w8ExcBWrmlBD9RXvVs7IqVLqz38EQiU7V9WSIg7Q+Y2xchyhSPNGFA6lMIBP73Jo1qMJ23KG5tZqKSXYm7YGUJw8Zu421455V2R84GoPDP+qv6fLax4t9hTiE7UDfH2CDYvHNZqvRjcZS83mAk9+UlOU4xd84K77b/hgaOzxRe/8wkRZQwx2ajv5nDLVvC8rwOLw8UfEABfPygD/phg81RlxordJvNP3U84TyHjK1q2W+5BIlGa7zlVviCx939FG7T+uGIkOvZch3FtDBbTQlrTIIoY+5ggUcb5pKABE7GXBzEAarDyO0vTpVqHWJxXbOwH4/jVCqf5OcINhgAJ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(39830400003)(396003)(366004)(376002)(451199018)(6486002)(86362001)(83380400001)(33716001)(9686003)(186003)(26005)(6506007)(6666004)(6512007)(478600001)(38100700002)(316002)(44832011)(7416002)(8936002)(2906002)(54906003)(8676002)(4326008)(6916009)(41300700001)(4744005)(66556008)(5660300002)(66946007)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FePczyG7T/LJEhCaX4skZH6JJ+dsn1Z2T3jAhodGVFg8clxBHD9F9EC5lxie?=
 =?us-ascii?Q?R5tV1XgrhBLA5l6xfWlg9DBsJA7BsBMWCOMmfbgJ516OzJkcEmpzKIi+kBD/?=
 =?us-ascii?Q?hGlH47Q+WjcGMfpRySx60RqjWcJUSKlPdOHYT0Wez3lZP5dqaBBTVZ2oOOZr?=
 =?us-ascii?Q?eyUtAn5ZXd7d1nHt0Qlakb1TuMUnIHT/VwkNkk+htE9zrdFZhwkotgWjtmSI?=
 =?us-ascii?Q?Rgirq3f4LjJtwqCjjY2m53xc4f5fGw2mStSzcq8lWtMhKhmoheJKtiG4z1gw?=
 =?us-ascii?Q?ycvgA1uflbJyw1CUZUa/DKsQMBgV8qcj37WBSXByDxeHanAbguK7PxR0SXNp?=
 =?us-ascii?Q?SfkSgO4zz+QWWCMd0c5kBzyziUZ8olHkLEdlz/J+SN/utEAFD12ATAkst2Qb?=
 =?us-ascii?Q?cRy692sVHCeTRCTGHJVzwYu+Jpgr9DnqIzYBmHnj4xjfUyCKPj3CJRMjf8pV?=
 =?us-ascii?Q?5b5FNaVacIHHR+h8RbS1gL+/pQWJO3Hp1pZIsAVtl+Kj7BqWENvLdmue/M7p?=
 =?us-ascii?Q?72RMzsjfvy15qr99P0zOOq/Papmo/CmgMWstpbMgjxu6UOlYBkwrxkNEVIEO?=
 =?us-ascii?Q?7pIo6L6HD3UiOe7wgDklgauM8PB7/9j7sukGopEEN/7XboL/uOBwzaAD/Zag?=
 =?us-ascii?Q?4hWM4GlrEeBO7aaplSTm8+PccQu/9DUaeX6LXdZHN/3hKiTzQkv3mspffl4b?=
 =?us-ascii?Q?shBcORtyyCVT3oqwnTC77P8pK5WdtUw7AjzDsLTaq3ppHJy7djItM8ORBvqa?=
 =?us-ascii?Q?GiX8A7mCNR+wey6ZTKv/l7K7beyyV4nIXFWdqcQpq5l1CLfyt00L/u1IwqyL?=
 =?us-ascii?Q?hV3H3s9/7UsESYDjlPj7RlRNZJ2xuNgVciX63mapW7Ga97EI+6aaxNAH5hYY?=
 =?us-ascii?Q?iAfSKVvKSQI8ToLGr+6UYfTSn4GZJ994WO1V6PWfNYW0cOwOLVRKQHUM9GTi?=
 =?us-ascii?Q?pDpyc7RFsFT5rMZXNZkmps/NstvX5Y0cWbZROxYGtQilJad+TauL2llMBSC/?=
 =?us-ascii?Q?0f2KXmTfkyu1uE4evflKcotoMEUADY2MihoUA80Rt1y0c+UkraAA/O+7rF89?=
 =?us-ascii?Q?g5CRkk9Z7yRD7uteHTq5RjoD2lpx5ZtuUPsPKzzQMDuUKUGcWz5PvWa0c1e/?=
 =?us-ascii?Q?zDXhSLvtC60fLdjX0k+hRiuK82M54Yt92NlofJXyEjwHDua0xttJKQKw9TRU?=
 =?us-ascii?Q?1bLaQUW64Pn9TMgSW2UU+8oRfKm2QCLQSc9KIdnUxuM+Pt0HbPhyHBzIWtQh?=
 =?us-ascii?Q?JPedUQHsaGjlpa0Eq6EZS6X57zN6SPxNYR7K2qkrQBy3GOH/H1cJLz1yQrHe?=
 =?us-ascii?Q?t9gAogrO9R8QHXHLLeGgadiEMRwfV4bGjN3oX1wNAEsyDm3ACPcFmNSo+cEF?=
 =?us-ascii?Q?5H1TUJsgC82cMLEht3kZYYyQPAcg5gZtlirDKwHmSSQDQhIv7UF73aFLWncU?=
 =?us-ascii?Q?5GtwBu1/l2u+uqIDKyDdvp7AUPWOLdbogMfkQ3eV3QJnxEkAkhjk8WdKCelB?=
 =?us-ascii?Q?biwiUISr3YTxk5QAb0UTX0sZsV9+jo6BZHObfaaA2kLlEFk1ZR9uS8K09Xa1?=
 =?us-ascii?Q?qEsfYqxaq36+ywWbt5GM3zM1fMCJP+bRrkIQ4xZ9nmhvitiInRRV8MjdIVbZ?=
 =?us-ascii?Q?s7kEbbcTuAAjuuTtsOkfP5A=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a21a4c-0f65-4c54-8089-08db10817989
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:54:08.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNYJwpTiw0Hgog7I08LKiwoGHnsqSQY9KzfwuoyewI0+jc0KwQd1YzXWJYCZuWq8G+31pNdjdo8xAY0WVTYaTAZ5J8sXIpQJkkDpK5kBS94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:38:45AM +0200, Vladimir Oltean wrote:
> When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
> and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
> be printed:
> 
> [    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...
> 
> Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
> duplication, and update the mfd_cell entry for its resources.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Yes, I notice that as well now.

Thanks for the fix! I know my original patch set messed up Lee's tree
(apologies again) but if this goes through net-next I don't think there
should be any issues.

Acked-by: Colin Foster <colin.foster@in-advantage.com>
