Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683F16D3FA3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDCJBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCJBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:01:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499F361AE;
        Mon,  3 Apr 2023 02:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NL/5CoTlhjtKmYow5ms+hCN4+NvBDd4oLgPTiylKD6fovB0iv/z2eQr8MCNqn75dvV9etYZEAVRmnUSlt6+RTynLarz1tgKxRCSlgTDSFIbmLLjB4tJ4z7e/FxjMh/9YvQj23FWUWHdaPZF9xtR8Zmcrp0u80NRf11tM+FLXSXGrVwuV25UkxSIm0aGAIWM/xdo1eWB13GK5ptYCPQ9B4izNL4aNAmA0m31RCX1LjSGYbr3P/W6VwEeQr9qt1Duz91kuTLBnUXGY0Eltwu3gZXBFeuy3wg+1ZyxDslrt0o3TXtrXcOs6mj/Svj5DI4cjJDAc3fKquFweFBCeaMQlhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihjkSxYeQ09n6W01RS4sQxvdPhDLVtLfL4Avmq+2o2E=;
 b=RBYVsFS9hQscfZlVdDw06j+3aS7mLZanqDUvM5iVjy2jblbe+r5bpjAc6P/5xIzeAqPjsUDWRZeCDp3m2AXff4rVvlT3jU8FVTL5ehtkRT11fhnMRqgKqYa98HmAeZZmKCiARXAVHRCBNEYviYMzUIg9eGzMxSSxvYdxX7aHQcbT62JrBw8jxNJGTU2giILeCGjFC33/TKyKYwecBBUyWUuSxfVk6nyZV6F8DV9uJswRxNkwiJ2Y3pYfbhAhFmQrSMthShVyLVkZZjTPDGGsJRomS+HHtcrMuSFWytIzeWcbpyfJuGXyepWYAarx9C/VMtSa2QGbmn5lt3Vm4aLC0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihjkSxYeQ09n6W01RS4sQxvdPhDLVtLfL4Avmq+2o2E=;
 b=HmYvF/0iODhShunLpyrW7BVRdclBFMTmcrIkJPxt6yiqGTM6DduYHud7StuarHROAiNlRKSwVk3sNotrdDqHXAjXQlwmpT/5AseMyTgSs5Yih/XYyvwVEGeE+Wq4DfxDqTQEsYglfBl4am6z4Iorx6TdORWncSumv+vaawrXfpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4661.namprd13.prod.outlook.com (2603:10b6:408:124::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 09:01:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 09:01:35 +0000
Date:   Mon, 3 Apr 2023 11:01:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [EXTERNAL] Re: [PATCH v6 3/4] soc: ti: pruss: Add
 pruss_cfg_read()/update(), pruss_cfg_get_gpmux()/set_gpmux() APIs
Message-ID: <ZCqV5xPilk/LPyZy@corigine.com>
References: <20230331112941.823410-1-danishanwar@ti.com>
 <20230331112941.823410-4-danishanwar@ti.com>
 <ZCg6lzWMTuLa4gAC@corigine.com>
 <19c82e73-2e37-582b-06aa-6f83776a562d@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19c82e73-2e37-582b-06aa-6f83776a562d@ti.com>
X-ClientProxiedBy: AM3PR07CA0109.eurprd07.prod.outlook.com
 (2603:10a6:207:7::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4661:EE_
X-MS-Office365-Filtering-Correlation-Id: d85865c9-fc29-4e38-3417-08db342206a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMKv/6F41S3TkrTRGELajIJZYpsYulmd24q9mfHwmvJjNDL03SFAIFmbwuSuRIzPh95yykpwikuS7SxyXdkSFZDlxV9aPWWEi6xRvxRujl8jpHnt+izVieqUiMis6Kkq+e1c1pjKNYd99JMlp99nEPZHs4IJHvHax/hWt/dX0MJvAEZs1Eyhgnmpik1glBY/QYtfwifl+mUuMpzy4V0Ta8S3jYvx/hYRkrOQ46X1bf9dNlusu0wXDDV1FQeM8ko77YeeItTVQViB5eKS3BRriEGyH96T91f8pmgQ2N+IMoOeuLp3TYfFt4BacYjctUGrQn08dYykNbhsZ7RJ3keB4cPJ88bfQNEWB/czpbZPks/+siP5qSdsNl+uNDVjpber0zpqlfcgL6SRSb9rxR5fe7xg6FFgN+taIuyqJ8A3DmDdtaE9/p8MignPaqUSybp8xDUxO9BjWdOh4CKzweWOass4jPO0wZzo7V3/+aAeU+6mW8Ombf8Z3lkIy/Ug53Mkw726/VUBwuSNhqTZc5a78QgBlvePw4Tua5c5bOO6O0lO2e8DR1W3YEpqy4i/baFy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(136003)(366004)(376002)(451199021)(186003)(6666004)(53546011)(8936002)(5660300002)(86362001)(2906002)(7416002)(44832011)(4744005)(6512007)(478600001)(66556008)(66946007)(54906003)(4326008)(6916009)(316002)(2616005)(6506007)(41300700001)(8676002)(38100700002)(36756003)(6486002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cjJaftuZgZuJNBgPDJXCWzzc8LKYb1c2SkhZPvfMkI3vkdVwlyEiprt4I1Em?=
 =?us-ascii?Q?BFaUn6Rn+0eAaUAAHRDumelz6YOvMsmuH5cc22CyDYAi9RQdIcg8cXuk8lq9?=
 =?us-ascii?Q?dHDDtsIWHtSZqy9W882uJ6KMu3faVR8iSCW44XjhZ1DnM5s6vXDYOWQ8C5OQ?=
 =?us-ascii?Q?u8AGRkFWlFdN+bg43n8E+FcLIXmPHeMZ9NYeFFll4KF5oBoUunrVzB+NrKGw?=
 =?us-ascii?Q?pSBErcd0rQNHYtegIKtFhR86kYDeavyFjC7ZKzLaGlONvO7M1vmtvozhfx9p?=
 =?us-ascii?Q?vsIM5A5yPBMtJZ3dFsgTT6MOAEfIPfhR9ocUsbpdynldl9YBkXB3wUSFC6HF?=
 =?us-ascii?Q?yI5xkmF1mE5g8PTyoCqT1efrU+VuxD4bvQd05Gk2U3jmDszMOA5Pzfn+F7D4?=
 =?us-ascii?Q?s6Md3bQgdToKHOoq/XHr7omdMN6kaX6QXduYBvz/RPdvvBAMRy0wOa32q2pH?=
 =?us-ascii?Q?JIXG8ZZBSmdiyv/RgHPd1kIBhbg8AWqFWhq3G8SwiUftRxTIcnJV53ZD6Cel?=
 =?us-ascii?Q?DOjXIjYhokT8GrwJHTniw3e/Nn7xxytmO/SAMibSHQNzdvuGCVkjUtdBHZAt?=
 =?us-ascii?Q?xtutU8skY7JsZtMgWvKXtQZJcEBg+hS0rDraZws0jUr1R366ZTrE+KaedbjX?=
 =?us-ascii?Q?mP0UKX/l+H4kw52bmNffIU9L39/rQsWS60Ewblu9ys52v7kQ+De0M6R1TLN1?=
 =?us-ascii?Q?nL4nMYWe1dicuxuLMINhyvX5Ej+0iiiqB8XN/lwpZCxIgBmQfKR4MeKq7TZE?=
 =?us-ascii?Q?ESlyPATy5oHjtiKcfpmGlaS+mrJHBwmJUm7g8RMKSPz3vgHaRGLcKdLzudH1?=
 =?us-ascii?Q?bm07PlbWrNf7J0Ohv5hKUQ0rrM3S8+vUNaFaiOQo6UmMW7XkYmn0oVGU95f4?=
 =?us-ascii?Q?dhsAhC7t13W4+Cn2s0t0mj+aiJl4g/bxA0PMSUKBJ4Lv8W/eW9bK7Fs8Domu?=
 =?us-ascii?Q?/va8XaBQP/fAvnspeHeNgnsLk7yvyvTdwtTeMnHSsgPVb0iC2X6l6Fnl8svz?=
 =?us-ascii?Q?QvC805BbSvcXuLpd1VZDD67M+rEe115EVqZzxfQXfvh+fWQXAhUoE40sszTR?=
 =?us-ascii?Q?U3LoRd0pLZuPmUGz9i+VX9RLb01QWdLgScGFy1hpl+xPOeGEaZmpdbPz5aq0?=
 =?us-ascii?Q?xRXw3yQcAlkqpdNTNDNvVxGQpFRlydP7RFySYb0ats/66pzpb7uWSwcWGg4p?=
 =?us-ascii?Q?1D2YD4+9clfY9aGCdi+e0Y1ACwUj4CLpb4X2YxiGWz7dbZ1HApVjiv/Oepci?=
 =?us-ascii?Q?mvbHSL/6zrcpTcNs/Yi8tZze4WkX6DT2YyybG33BvjD2Ny+VS4HHqs5/qvX4?=
 =?us-ascii?Q?yujtkt7iU+wiNiZvcYIFDFV7ikxe3Xp6HOS7O9NdNtlZ/FxJTbSz9mMy/mFA?=
 =?us-ascii?Q?UE2/wsi9RgYBkpo4uFOZxtVHZnvx0nHxB9xqVT741CzE/dMEAC7u9mbGgQzR?=
 =?us-ascii?Q?IHCngutxdNuNX7NB3xHh8WTXrYyAHC+GQL5V0kFmvqVcByJF7F3FIOjh0da4?=
 =?us-ascii?Q?p47sWhN8bz2y/uYIwdKsjEq2rV3ny9FTxyJRXcnJ2lUiIp2jJYRyR8bFLQXq?=
 =?us-ascii?Q?9G0WESJ8erzaQvB/10xzecBz3p9AqZWKvt1R3KBg0g/63JDmq8hAnzmhqtuE?=
 =?us-ascii?Q?tqI0J8KmW5S9X6f1WEWvktJR4umS2XBnnzO7Ef6X2OQALAa03xnjYB9S4Et0?=
 =?us-ascii?Q?DoZWyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d85865c9-fc29-4e38-3417-08db342206a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 09:01:35.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QiCVp4BA3X2hx2jTG9ArdXZP1BxLI4BQ8CRt3Src5j1e4B37WYloAdawsU6Nw6ncdyaS0qmHdX8gyzCNJb7oUT6FZPTyigwO68ynL9+6I8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4661
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:01:44PM +0530, Md Danish Anwar wrote:
> Hi Simon,
> 
> On 01/04/23 19:37, Simon Horman wrote:
> > On Fri, Mar 31, 2023 at 04:59:40PM +0530, MD Danish Anwar wrote:
> >> From: Suman Anna <s-anna@ti.com>

...

> All these above macros are not used anywhere in the driver code. Also in the
> planned upcoming driver series, there are no APIs that will use these macros.
> 
> I'll be dropping all these redundant macros. The below macros are used in
> driver so I'll keep them as it is.

Thanks Danish,

Dropping unused things seems like a good idea to me.
