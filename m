Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F42E69C687
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBTIWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBTIWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:22:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EF21258E;
        Mon, 20 Feb 2023 00:22:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWjlZ4ulAnp0DwKrZCi2CgH10wUyflHFn19IHIKR8YoIzyhKjOSOQjD2X9UPV1+UNEDi6DSH6hAGKeda38bxD9nPdnlIz6R3l8RWv3v9Xrv2nMDmlmbsuxYBnGxtzkXECG9xB//geubZorgWNc55a6bD00gcMFBVWyOWpkI5AACkxKXj6jYcJFK5Dy/p4HFciBI7y60IeYYjCvYGknLSgVchqpQ1IcIugs1XmM+Iwy0mBzee48qHDF1DueFFVBf7bKRu0hwedXLqyZqUgIUcfEwlPi/F8ElN744mVX/kK9LTSiMms3Fiygb8iMjdlXlrawpfaYRYJrRwM4VTV1N1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiBuoVT6cCflWomRymDRCiO7uVmklNqEroZtUhzy/PY=;
 b=iykv7nBQVaPTRIbiLt6YUtHlCdipWYbpXKU+IG5L5YRvQjYmmUi28hp5dDHvmcUBWXgad9XQFo8PGe4V3SFoeY3X5wAScaa5cO4BpV4yeHQ67uDvzdkAAqXa+Dd+Bj/GlnD9Wbd1EL6mesIHzGvlwnMTi+AjRGOB5eqk5X1wEtcsIYAPytNiZGzpWdiD9oLGawjMJW5pC3TT1mv8TtPDQAP+nNEPAV+ah9n8YvJkfuItmj/T4kpH9py4N0LUz+xYHuAFCaCPIHQz9BHPXLaTdAoyk1tLkwZNXKudRh+VkBvllGF/+P6jz0XFnG5XcW3thHt2bfwzEE5woWYwLKFjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiBuoVT6cCflWomRymDRCiO7uVmklNqEroZtUhzy/PY=;
 b=mCTq80TjtsAedj5bEnORz+bdjwRuEq7s9WTedmaqN7P6omRNd3f7JV8VPOfj1Frzy69TbBD9znRBHq7/PdVFRrIHpCx47Lak8XGrJqcEaIDs4vFcsCgnoVrYy4kx2001iYuLWckA1kfO8hfbOB93Q47dn4ZWkG2JDjiJ4tdJVocxs9kgOtvKT7VZS3+GrdJ0KARMRPI85wm6tjq7NPZld6q2fExPjN71arxm5lj67xtqThSjKZuYsiktJJqLnts7aDbxDZ6ezGFPf7gT8hSueVwxfdbrwawVOf+qTC11RxkzW75ygj4/wG1rlCn3JEml7S5VnxMP8fEExNOGcccC0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 08:22:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 08:22:30 +0000
Date:   Mon, 20 Feb 2023 10:22:25 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amit Kucheria <amitk@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>,
        "open list:TI BANDGAP AND THERMAL DRIVER" 
        <linux-omap@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 10/17] thermal: Do not access 'type' field, use the tz
 id instead
Message-ID: <Y/MtwTIuVDrt8PaP@shredder>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-11-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219143657.241542-11-daniel.lezcano@linaro.org>
X-ClientProxiedBy: LO4P123CA0620.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5040:EE_
X-MS-Office365-Filtering-Correlation-Id: 88fdae44-0087-4777-b125-08db131b9be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGdT1FYYOwWu5p76rw0OAO676W+NnzO5ENZjCEXTZYaqrbz1RbUmdlDZmX8d4fSvR0xFshybJZEFMgBOX1MT4FTg0GHiU59xLoikvjZXySfGTPV/NBQULcjhkbbebhArDS04kGFrmcj7hBBY/IWPJ7MnV0xGwCJspXnihsSRlPldYrCok0QtrOd6VduSPiWf6S+pO39JynXpjbAdOMXuMDzfB7py8jBR+nww0BUDX3qTlscTjtarOZ7zWuT1Jy53I06GusTQZRS2WYk4DAr998M4tqXu+IMdAz5qHwkBMhobCxFAptiu8uUB/MX5HI3uHrlN6aHRkS98MEtRICGRC7XqVZiewGYIzIO6moFMWE9NHnKYNTK2MTngjqGkMob0VzylGRfVhxaxxgwm5IQpg8jhPGsETCEozvLEZND+Yl7sQtfZl8HM7Am5FX0mAZLxuKPIo3sXLMIXptLikMeb/KXEBn+pkF2tcgmdSeMgVSyrU+18cpX+b9KiYs/8VKFs+kHY1ivclg1gPLGINMmoDBn4qg1ziPxnIuR2NdvrmiOcUxxse5yilKbVNLq2M4nGm88S21cv5UdkeG4M0V8w34bS+u7ROuJBTVHi6Q2Gk1mhei8rgHkZgviYG8K8Sop9v85L9ZLpUwUWvDRZREHIkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199018)(9686003)(26005)(8936002)(186003)(33716001)(6512007)(6506007)(86362001)(38100700002)(6666004)(2906002)(4744005)(5660300002)(6486002)(7416002)(4326008)(6916009)(41300700001)(54906003)(66476007)(66556008)(8676002)(66946007)(83380400001)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?brvGlaw9nvCsgfmPzQqdGW20NRoT03nuITeV0eGYV2UxcDALvFktdJX22eJh?=
 =?us-ascii?Q?8WYl3CXZP+0tSVe7VOx4plqwXLdUd7DKOwPf+zoJNZVOc9QIUjDCbziAX/u+?=
 =?us-ascii?Q?9kAoBXkTI7/9c87/0vfgTxy06u/QqqSAHousylPWwwgUYpadw1+r6EJwmJ8N?=
 =?us-ascii?Q?CIeIXNvnV+sGdka4LpMyYJIgaEDEPvbRDl1X0Lb/BcsM/u/yThpLl11XA3Me?=
 =?us-ascii?Q?36itsX2tA68Hxyg8BA9gsrgIlMzXJ4H1QxSsRj/oGHoTHqNy69ORa/azJbNC?=
 =?us-ascii?Q?Ya+S5aoovDMyqfPwM/yQoZg6s2H8e7GbWiD1IjnzrkczYPqyRR+w1abeVSWB?=
 =?us-ascii?Q?J9iD3nHvGwCU9Jsud18/5YL+bPF71hbao9BPf4b4OOgS+jXOdGG3IvsgMm2I?=
 =?us-ascii?Q?Tua5j3zZcMJ94SX48DSG6BgJ+i+3hnVYEL/tbqLiZDho6mGvS5xJI+TfkKjH?=
 =?us-ascii?Q?j+d8cQRKPshLQ25HBchv97M3E7jt/rOEjhRxNqDAr+akk+6y5DYU0a0lCd3E?=
 =?us-ascii?Q?+mWtSixyA/4hQbbu6N9/AI8mDdXVwf/S5XwBzj3yDcJbp0FNtia3ZrWwjqVB?=
 =?us-ascii?Q?8AGrwRfgpYyVRicPknezjL0H13iJycPn9qIe0fI4v5DyQd3aOs0V9vY3Isvr?=
 =?us-ascii?Q?0QI4Lj7rSy6J/C6tQMrUcuzlOuKOW+Oeqj4CBtIeTOOzd7Pc2k3reD3+deBz?=
 =?us-ascii?Q?bCDUbRgL0RP8CgAGmh2W37iRI9NS5CRKdX7eAzEPuBjVkY5N2ErdA4YkBIsX?=
 =?us-ascii?Q?wt7PcqbZAYXUKJtcH8LWfoivC0dmp8unzQx1IcHxsJQ23Cy+5/mQ+8Dra/fs?=
 =?us-ascii?Q?J/5BHohDY/XnN4Emg+frTqAzN9/msQtrkWo74zDIGm+YBiMeVzqloF3KVWpE?=
 =?us-ascii?Q?WHXSCEiKolcSl3GK8pA4z4OysJa1+quvUUE2gvxqj/PjMwsvwqcO0Hz3G72U?=
 =?us-ascii?Q?v47oiNBg9a5gGE8RXR5z8SrNpHfTjfxkplN7O4dcEZ9C3yMnEL3+bBIs2nwE?=
 =?us-ascii?Q?1KcPzgYkSq/QH0k1AnrlTObttYjLBPMLyrs7oX1k0EjqhdGGCxSdUWOdLoVc?=
 =?us-ascii?Q?aUF7LzwTQogxmxQ/pPIcAkkcHjbsuS1l7m5ibM1iY2WLJ9I1YQrMUsqTDTty?=
 =?us-ascii?Q?tNOsXJCOXVkvxpiMWbaGWskReGShegz63aEqIQKK+QGP8HWr+K1Aw+ky2viS?=
 =?us-ascii?Q?4sCVPXwJfeVO+bbrtX35El0PtbDiGpc6bBwQcEb4KuciDdDhEazWnx1fh5hi?=
 =?us-ascii?Q?bB8QIyxPJKP5TcAegec77TByyuzv9vDaICbJ8BNldE+1QDm6jw74nKThvWJg?=
 =?us-ascii?Q?LQRHMOpLhs3WakJJ9BIrYRpuqmMu4TKEX/jPKeCejU6rHNdnYWpyxk1ektEJ?=
 =?us-ascii?Q?b4LsP/NdJMpa1ONL1pZiGnJSOoldvwRdy9/Ij2fTkMS/MI1LcT5KrtNPaRUo?=
 =?us-ascii?Q?4n/B5q+sO3OTNM0xIfDQ+p4v1TF5BzaK0kc2PqiithZMpGbg3Jr0XmfJxVz4?=
 =?us-ascii?Q?S9M5czDhP+b41AKli1yoUu21vvTz7TpFW2kGD3spBj76TbtHr6SHW8UhZJHi?=
 =?us-ascii?Q?MLtYmI7hSi2dbF7e/Unck2i7OtOU9pQVWj6t3PvM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fdae44-0087-4777-b125-08db131b9be2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 08:22:30.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pssYh0A1vBG/2EBCb8vFtsq54jlid6iQ8akX9knHzVmCCf+RYba9MrCn17NmTxAWKL6WH0BSIlP98c8Xj5ffJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 03:36:50PM +0100, Daniel Lezcano wrote:
> The 'type' field is used as a name in the message. However we can have
> multiple thermal zone with the same type. The information is not
> accurate.
> 
> Moreover, the thermal zone device structure is directly accessed while
> we want to improve the self-encapsulation of the code.
> 
> Replace the 'type' in the message by the thermal zone id.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

For mlxsw:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
